#include <vector>
#include <limits>
#include <iostream>
using namespace std;

typedef pair<int, int> PInt;
typedef vector<int> VInt;
typedef vector<VInt> VVInt;
typedef vector<PInt> VPInt;

const int inf = numeric_limits<int>::max();

/*
 * Решает задачу о назначениях Венгерским методом.
 * matrix: прямоугольная матрица из целых чисел (не обязательно положительных).
 *         Высота матрицы должна быть не больше ширины.
 * Возвращает: Список выбранных элементов, по одному из каждой строки матрицы.
 */
VPInt hungarian(const VVInt &matrix) {
   
   // Размеры матрицы
   int height = matrix.size(), width = matrix[0].size();
   
   // Значения, вычитаемые из строк (u) и столбцов (v)
   VInt u(height, 0), v(width, 0);
   
   // Индекс помеченной клетки в каждом столбце
   VInt markIndices(width, -1);
   
   // Будем добавлять строки матрицы одну за другой
   for(int i = 0; i < height; i++) {
      VInt links(width, -1);
      VInt mins(width, inf);
      VInt visited(width, 0);
      
      // Разрешение коллизий (создание "чередующейся цепочки" из нулевых элементов)
      int markedI = i, markedJ = -1, j;
      while(markedI != -1) {
         // Обновим информацию о минимумах в посещенных строках непосещенных столбцов
         // Заодно поместим в j индекс непосещенного столбца с самым маленьким из них
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
            
         // Теперь нас интересует элемент с индексами (markIndices[links[j]], j)
         // Произведем манипуляции со строками и столбцами так, чтобы он обнулился
         int delta = mins[j];
         for(int j1 = 0; j1 < width; j1++)
            if(visited[j1]) {
               u[markIndices[j1]] += delta;
               v[j1] -= delta;
            } else {
               mins[j1] -= delta;
            }
         u[i] += delta;
         
         // Если коллизия не разрешена - перейдем к следующей итерации
         visited[j] = 1;
         markedJ = j;
         markedI = markIndices[j];   
      }
      
      // Пройдем по найденной чередующейся цепочке клеток, снимем отметки с
      // отмеченных клеток и поставим отметки на неотмеченные
      for(; links[j] != -1; j = links[j])
         markIndices[j] = markIndices[links[j]];
      markIndices[j] = i;
   }
   
   // Вернем результат в естественной форме
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

    vector<vector<int> > matrixOfEmployeeWork;

    matrixOfEmployeeWork.reserve(lengthOfColumn);
    for(int i = 0; i < lengthOfRow; ++i)
   		matrixOfEmployeeWork[i].reserve(lengthOfRow);

    for(int i = 0; i < lengthOfColumn; ++i)
    	for(int j = 0; j < lengthOfRow; ++j)
    		cin >> matrixOfEmployeeWork[i][j];

  //  	int m[][11] = {
		// {INF, 	7858, 8743, 17325, 18510, 9231,  4920, 7056, 9701, 5034, 7825}, 
  //       {8128, 	INF,  5021, 13603, 19635, 11386, 7075, 8840, 1843, 7189, 9256}, 
  //       {6809, 	5364, INF,  8582,  14614, 10067, 5756, 5904, 7207, 3882, 4235}, 
  //       {7849, 	5515, 1040, INF,   15654, 11107, 6796, 4713, 7358, 4900, 5275}, 
  //       {10918, 8365, 4109, 5808,  INF,   14176, 9865, 7928, 931,  7991, 8344}, 
  //       {336, 	7285, 2830, 11412, 17444, INF,   4347, 6483, 6688, 4461, 7065}, 
  //       {1053, 	2938, 3823, 12405, 15835, 4311,  INF,  2136, 4781, 114,  2905}, 
  //       {8930, 	802,  5823, 14405, 20437, 12188, 7877, INF,  2645, 7429, 10058}, 
  //       {9987, 	7434, 3178, 11760, 17792, 13245, 8934, 6997, INF,  7060, 7413}, 
  //       {10518, 2824, 3709, 12291, 15721, 13776, 9465, 2022, 4667, INF,  7944}, 
  //       {2574, 	4459, 5344, 9561,  17356, 5832,  1521, 3657, 6302, 1635, INF}
  //  };
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