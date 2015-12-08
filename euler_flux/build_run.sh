#!/bin/bash

g++ ./main.c
./a.out

julia --check-bounds=no -O ./main.jl
