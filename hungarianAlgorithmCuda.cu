// #include <vector>
// #include <limits>
#include <iostream>
#include <thrust/device_vector.h>
#include <thrust/pair.h>
#include <thrust/device_reference.h>
#include <thrust/memory.h>
// #include <thrust/


using namespace std;
using namespace thrust;

typedef thrust::pair<int, int> PInt;
typedef thrust::device_vector<int> VInt;
typedef thrust::device_vector<VInt> VVInt;
typedef thrust::device_vector<PInt> VPInt;

const int inf = numeric_limits<int>::max();

__global__
void hungarian(VVInt *matrix, VPInt *result) 
{
   int height = matrix->size(), width = (*matrix)[0]->size();
   VInt u(height, 0), v(width, 0);
   VInt markIndices(width, -1);
   
   for(int i = 0; i < height; i++) {
      VInt links(width, -1);
      VInt mins(width, inf);
      VInt visited(width, 0);
      
      int markedI = i, markedJ = -1, j;
      while(markedI != -1) {
         
         j = -1;
         for(int j1 = 0; j1 < width; j1++)
            if(!visited[j1]) 
            {
               if((*matrix)[markedI][j1] - u[markedI] - v[j1] < mins[j1]) 
               {
                  mins[j1] = (*matrix)[markedI][j1] - u[markedI] - v[j1];
                  links[j1] = markedJ;
               }
               if(j==-1 || mins[j1] < mins[j])
                  j = j1;
            }
            
         int delta = mins[j];
         for(int j1 = 0; j1 < width; j1++)
            if(visited[j1]) {
               u[markIndices[j1]] += delta;
               v[j1] -= delta;
            } else {
               mins[j1] -= delta;
            }
         u[i] += delta;
         
         visited[j] = 1;
         markedJ = j;
         markedI = markIndices[j];   
      }
      
      for(; links[j] != -1; j = links[j])
         markIndices[j] = markIndices[links[j]];
      markIndices[j] = i;
   }

   for(int j = 0; j < width; j++)
      if(markIndices[j] != -1)
         result->push_back(PInt(markIndices[j], j));
}

int main(){
    
    int lengthOfColumn;
    int lengthOfRow;
    do
    {
    	cout << "Enter length of column" << endl;
    	cin >> lengthOfColumn;
    	cout << "Enter length of row" << endl;
    	cin >> lengthOfRow;
    }
    while (lengthOfColumn > lengthOfRow);
    cout << "Input elements of matrix" << endl;

    vector<vector<int> > matrixOfEmployeeWork;

    matrixOfEmployeeWork.reserve(lengthOfColumn);
    for(int i = 0; i < lengthOfRow; ++i)
   		matrixOfEmployeeWork[i].reserve(lengthOfRow);

    for(int i = 0; i < lengthOfColumn; ++i)
    	for(int j = 0; j < lengthOfRow; ++j)
    		cin >> matrixOfEmployeeWork[i][j];

   	VVInt *matrix = new VVInt;
   	for(int i=0; i<lengthOfColumn; i++)
   	{
   	 	VInt row;
   	  	for(int j=0; j<lengthOfRow; j++) 
   	  		row.push_back(matrixOfEmployeeWork[i][j]);  
   	  	matrix->push_back(row);
   	}

   	VPInt *result = new VPInt;
   	long t1 = clock();

   	// Run kernel on 1M elements on the GPU
  	hungarian<<<1, 1>>>(matrix, result);

  	// Wait for GPU to finish before accessing on host
  	cudaDeviceSynchronize();
		
   	t1 = clock() - t1;
		
   	int cost = 0;
   	for(int i = 0; i < result->size(); i++)
   	{
    	PInt e = (*result)[i];
   	    cout << e.first << "->" << e.second << endl;
        cost += matrixOfEmployeeWork[e.first][e.second];
   	}
   	cout << "Cost     : " << cost << endl;
   	cout << "Time (ms): " <<  t1 << endl;

   return 0;
}