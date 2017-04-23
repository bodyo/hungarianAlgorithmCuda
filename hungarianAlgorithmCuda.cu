#include <vector>
#include <limits>
#include <iostream>
using namespace std;

typedef pair<int, int> PInt;
typedef vector<int> VInt;
typedef vector<VInt> VVInt;
typedef vector<PInt> VPInt;

const int inf = numeric_limits<int>::max();

VPInt hungarian(const VVInt &matrix) {
   
   
   int height = matrix.size(), width = matrix[0].size();
   
   
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
            if(!visited[j1]) {
               if(matrix[markedI][j1] - u[markedI] - v[j1] < mins[j1]) {
                  mins[j1] = matrix[markedI][j1] - u[markedI] - v[j1];
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
   
   VPInt result;
   for(int j = 0; j < width; j++)
      if(markIndices[j] != -1)
         result.push_back(PInt(markIndices[j], j));
   return result;
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

   VVInt matrix;
   for(int i=0; i<lengthOfColumn; i++)
   {
    	VInt row;
     	for(int j=0; j<lengthOfRow; j++) 
     		row.push_back(matrixOfEmployeeWork[i][j]);  
     	matrix.push_back(row);
   }
   cout << "debug" << endl;
   VPInt result;
   long t1 = clock();
   for(int i=0; i < 10000; i++)
   	result = hungarian(matrix);

   t1 = clock() - t1;

   int cost = 0;
   for(int i = 0; i < result.size(); i++)
   {
    	pair <int,int> e = result[i];
        cout << e.first << "->" << e.second << endl;
        cost += matrixOfEmployeeWork[e.first][e.second];
   }
   cout << "Cost     : " << cost << endl;
   cout << "Time (ms): " <<  t1 << endl;

   return 0;
}