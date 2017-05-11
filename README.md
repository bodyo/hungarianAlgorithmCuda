# Hungaruan Algorighm CUDA 

It is a realization of Hangarian algorithm 
Hungarian method is a combinatorial optimization algorithm that solves the assignment problem in polynomial time and which anticipated later primal-dual methods. 
It was developed and published in 1955 by Harold Kuhn, who gave the name "Hungarian method" because the algorithm was largely based on the earlier works of two Hungarian mathematicians: Dénes Kőnig and Jenő Egerváry.

We use Nvidia CUDA to speed-up calculations. 

-----

## Requirements

1. GCC Compiler
2. Nvidia CUDA

## How to compile cuda Hungarian Algorighm

 \\ Linux
1. Open terminal and run:
    nvcc -std=c++11 -D_MWAITXINTRIN_H_INCLUDED NameOfCudaFileCode.cu
2. Run in terminal 
    ./a.out

