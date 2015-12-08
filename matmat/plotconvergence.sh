#!/bin/bash

#~/scripts/qplot_jc --bx=1 --by=2 --by2=3  --title="MatMat Performance Comparison" --xlabel="Leading Dimension" --ylabel="naive time/OpenBlas time" --legend="mat-mat" --legend2="mat-matT" ./$1


~/scripts/qplot_jc --bx=1 --by=2  --title="Mat-Mat Performance Comparison" --xlabel="Matrix Size" --ylabel="naive time/OpenBlas time" ./$1
