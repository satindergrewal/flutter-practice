#!/bin/bash

export GO111MODULE=on

protoc greet/greetpb/greet.proto --go_out=plugins=grpc:.
