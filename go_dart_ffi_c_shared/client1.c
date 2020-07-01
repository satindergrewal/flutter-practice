#include <stdio.h>
#include "awesome.h"
// #include "greet/greet_server/greeter.h"
#include "greeter_daemon.h"

int main() {
    printf("Using awesome lib from current directory\n");
   
    //Call Add() - passing integer params, interger result
    GoInt a = 12;
    GoInt b = 99;
    printf("awesome.Add(12,99) = %d\n", Add(a, b)); 

    //Call Cosine() - passing float param, float returned
    printf("awesome.Cosine(1) = %f\n", (float)(Cosine(1.0)));
    
    //Call Sort() - passing an array pointer
    GoInt data[6] = {77, 12, 5, 99, 28, 23};
    GoSlice nums = {data, 6, 6};
    Sort(nums);
    printf("awesome.Sort(77,12,5,99,28,23): ");
    for (int i = 0; i < 6; i++){
        printf("%d,", ((GoInt *)nums.data)[i]);
    }
    printf("\n");

    //Call Log() - passing string value
    GoString msg = {"Hello from C!", 13};
    Log(msg);

    StartGrpc();
}

// Compile with command:
// gcc -o client client1.c ./awesome.so greet/greet_server/greeter.so
// 
// It needs greeter.so file along with client executable file:
// mv greet/greet_server/greeter.so .


// For Greeter with daemon mode:
// gcc -o client client1.c ./awesome.so ./greeter_daemon.so