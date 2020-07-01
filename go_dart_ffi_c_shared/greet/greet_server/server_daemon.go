package main

import "C"

import (
	"context"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net"
	"os"
	"os/exec"
	"os/signal"
	"strconv"
	"strings"
	"syscall"
	"time"

	"github.com/Meshbits/shurli/sagoutil"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/status"

	"golang-practice/grpc-go-practice/greet/greetpb"

	"google.golang.org/grpc"
)

// PIDFile file stores the process ID file for shurli process
var PIDFile = "./shurli.pid"

func savePID(pid int) {

	file, err := os.Create(PIDFile)

	if err != nil {
		log.Printf("Unable to create pid file : %v\n", err)
		os.Exit(1)
	}

	defer file.Close()

	_, err = file.WriteString(strconv.Itoa(pid))

	if err != nil {
		log.Printf("Unable to create pid file : %v\n", err)
		os.Exit(1)
	}

	file.Sync() // flush to disk

}

type server struct{}

func (*server) Greet(ctx context.Context, req *greetpb.GreetRequest) (*greetpb.GreetResponse, error) {
	fmt.Printf("Greet function was invoked with %v\n", req)
	firstName := req.GetGreeting().GetFirstName()
	result := "Hello " + firstName
	res := &greetpb.GreetResponse{
		Result: result,
	}
	return res, nil
}

func (*server) GreetManyTimes(req *greetpb.GreetManyTimesRequest, stream greetpb.GreetService_GreetManyTimesServer) error {
	firstName := req.GetGreeting().GetFirstName()
	for i := 0; i < 10; i++ {
		result := "Hello " + firstName + " number " + strconv.Itoa(i)
		res := &greetpb.GreetmanyTimesResponse{
			Result: result,
		}
		stream.Send(res)
		time.Sleep(1000 * time.Millisecond)
	}
	return nil
}

func (*server) LongGreet(stream greetpb.GreetService_LongGreetServer) error {
	fmt.Printf("LongGreet function was invoked with a streaming request\n")
	result := ""
	for {
		req, err := stream.Recv()
		if err == io.EOF {
			//We have finished reading the client stream
			return stream.SendAndClose(&greetpb.LongGreetResponse{
				Result: result,
			})
		}
		if err != nil {
			log.Fatalf("Error while reading client stream: %v", err)
		}
		firstName := req.GetGreeting().GetFirstName()
		result += "Hello " + firstName + "! "
	}
}

func (*server) GreetEveryone(stream greetpb.GreetService_GreetEveryoneServer) error {
	fmt.Printf("LongGreet function was invoked with a streaming request\n")

	for {
		req, err := stream.Recv()
		if err == io.EOF {
			return nil
		}
		if err != nil {
			log.Fatalf("Error while reading client stream: %v", err)
			return err
		}
		firstName := req.GetGreeting().GetFirstName()
		result := "Hello " + firstName + "! "

		sendErr := stream.Send(&greetpb.GreetEveryoneResponse{
			Result: result,
		})
		if sendErr != nil {
			log.Fatalf("Error while sending data to client: %v", sendErr)
			return sendErr
		}
	}
}

func (*server) GreetWithDeadline(ctx context.Context, req *greetpb.GreetWithDeadlineRequest) (*greetpb.GreetWithDeadlineResponse, error) {
	fmt.Printf("GreetWithDeadline function was invoked with %v\n", req)
	for i := 0; i < 3; i++ {
		if ctx.Err() == context.Canceled {
			// the client canceled the request
			fmt.Println("The client canceled the request!")
			return nil, status.Error(codes.DeadlineExceeded, "the client canceled the request")
		}
		time.Sleep(1 * time.Second)
	}
	firstName := req.GetGreeting().GetFirstName()
	result := "Hello " + firstName
	res := &greetpb.GreetWithDeadlineResponse{
		Result: result,
	}
	return res, nil
}

//export StartGrpc
func StartGrpc() {

	if len(os.Args) != 2 {
		fmt.Printf("Usage : %s [start|stop] \n", os.Args[0]) // return the program name back to %s
		os.Exit(0)                                           // graceful exit
	}

	// If running with command "./shurli main"
	// this condition will trigger the code to run without exiting the stdout.
	// User has to press CTRL or CMD + C to interrup the process
	if strings.ToLower(os.Args[1]) == "main" {

		// Make arrangement to remove PID file upon receiving the SIGTERM from kill command
		ch := make(chan os.Signal, 1)
		signal.Notify(ch, os.Interrupt, os.Kill, syscall.SIGTERM)

		go func() {
			signalType := <-ch
			signal.Stop(ch)
			fmt.Println("Exit command received. Exiting...")

			// this is a good place to flush everything to disk
			// before terminating.
			fmt.Println("Received signal type : ", signalType)

			// remove PID file
			os.Remove(PIDFile)

			os.Exit(0)

		}()
		fmt.Println("Hello world")

		lis, err := net.Listen("tcp", "0.0.0.0:50051")
		if err != nil {
			log.Fatalf("Failed to listen: %v", err)
		}

		opts := []grpc.ServerOption{}
		tls := false
		if tls {
			certFile := "ssl/server.crt"
			keyFile := "ssl/server.pem"
			creds, sslErr := credentials.NewServerTLSFromFile(certFile, keyFile)
			if sslErr != nil {
				log.Fatalf("Failed loading certificates: %v", sslErr)
				return
			}
			opts = append(opts, grpc.Creds(creds))
		}

		s := grpc.NewServer(opts...)
		greetpb.RegisterGreetServiceServer(s, &server{})

		if err := s.Serve(lis); err != nil {
			log.Fatalf("Failed to serve: %v", err)
		}
	}

	// using command "./shurli start" will show the daemon process info and exit stdout to terminal
	// leaving "shurli" process running the background, and storing it's process ID info in "shurli.pid" file
	if strings.ToLower(os.Args[1]) == "start" {

		// // Display Shurli Application's version and phase
		// sagoutil.Log.Printf(">>> Shurli version: %s %s\n", ShurliApp.AppVersion, ShurliApp.AppPhase)

		// check if daemon already running.
		if _, err := os.Stat(PIDFile); err == nil {
			fmt.Println("Already running or ./shirli.pid file exist.")
			os.Exit(1)
		}

		// fmt.Println(os.Args)
		cmd := exec.Command(os.Args[0], "main")
		cmd.Start()
		fmt.Println("Shurli started as daemon. Process ID is : ", cmd.Process.Pid)
		sagoutil.Log.Println("Shurli started as daemon. Process ID is : ", cmd.Process.Pid)
		savePID(cmd.Process.Pid)
		os.Exit(0)
	}

	// upon receiving the stop command
	// read the Process ID stored in PIDfile
	// kill the process using the Process ID
	// and exit. If Process ID does not exist, prompt error and quit

	if strings.ToLower(os.Args[1]) == "stop" {

		if _, err := os.Stat(PIDFile); err == nil {
			data, err := ioutil.ReadFile(PIDFile)
			if err != nil {
				fmt.Println("Shurli is not running.")
				os.Exit(1)
			}
			ProcessID, err := strconv.Atoi(string(data))

			if err != nil {
				fmt.Println("[Shurli] Unable to read and parse process id found in ", PIDFile)
				os.Exit(1)
			}

			process, err := os.FindProcess(ProcessID)

			if err != nil {
				fmt.Printf("[Shurli] Unable to find process ID [%v] with error %v \n", ProcessID, err)
				os.Exit(1)
			}
			// remove PID file
			os.Remove(PIDFile)

			fmt.Printf("Stopping Shurli daemon... Killing process ID [%v] now.\n", ProcessID)
			// kill process and exit immediately
			err = process.Kill()

			if err != nil {
				fmt.Printf("[Shurli] Unable to kill process ID [%v] with error %v \n", ProcessID, err)
				os.Exit(1)
			} else {
				fmt.Printf("[Shurli stopped] Killed process ID [%v]\n", ProcessID)
				os.Exit(0)
			}

		} else {

			fmt.Println("Shurli is not running.")
			os.Exit(1)
		}
	} else {
		fmt.Printf("[Shurli] Unknown command : %v\n", os.Args[1])
		fmt.Printf("Shurli Usage : %s [start|stop]\n", os.Args[0]) // return the program name back to %s
		os.Exit(1)
	}
}

func main() {}

// Compile with command:
// go build -o greeter_daemon.so -buildmode=c-shared server_daemon.go
// mv greeter_daemon.* ../../
