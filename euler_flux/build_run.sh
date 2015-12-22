#!/bin/bash

echo "testing main.c"
perf_cmd="perf stat -e cycles -e instructions -e L1-dcache-loads -e L1-dcache-load-misses -e branches"
g++ -O3 ./main.c
$perf_cmd ./a.out

echo "testing main.jl"
$perf_cmd julia --check-bounds=no -O ./main.jl
