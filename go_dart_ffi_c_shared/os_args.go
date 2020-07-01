package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	// the first argument i.e. program name is excluded
	argLength := len(os.Args[1:])
	fmt.Printf("Arg length is %d\n", argLength)

	// variables declaration
	var uname string
	var pass string

	// flags declaration using flag package
	flag.StringVar(&uname, "u", "root", "Specify username. Default is root")
	flag.StringVar(&pass, "p", "password", "Specify pass. Default is password")

	flag.Usage = func() {
		fmt.Printf("Usage of our Program: \n")
		fmt.Printf("./go-project -u username -p password\n")
		flag.PrintDefaults() // prints default usage
	}
	flag.Parse() // after declaring flags we need to call it

	// check if cli params match
	if uname == "root" && pass == "password" {
		fmt.Printf("Logging in")
	} else {
		fmt.Printf("Invalid credentials!")
	}
}
