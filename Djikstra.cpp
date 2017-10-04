//
//  Djikstra.cpp
//  Djikstra_Algorithm_C++
//
//  Created by Korman Chen on 10/3/17.
//
//

#include "Djikstra.hpp"
#include <stdio.h>
#include "Node.hpp"
#include <vector>
#include <iostream>
using namespace std;

Djikstra::Djikstra(int verts)
{
    adjMatrix.resize(verts);

    for(int i = 0; i < verts; i++)
    {
        adjMatrix[i].resize(verts, 32000) //Initialize all costs to a large cost
    }
}

int Djikstra::getNextVertex(int row)
{
  int lowestVertex = 0;

  for(int i = 0; i < adjMatrix.size(); i++)
  {
    if(adjMatrix[lowestVertex][row] > adjMatrix[i][row] && !vertices[lowestVertex].visited)
    {
      lowestVertex = i;
    }
  }

  return lowestVertex;
}

void Djikstra::compute(vector<Node> &vertices, int startingVertex)
{
    int currentVertex = startingVertex;
    vertices[currentVertex].visit();

    for(int i = 0; i < adjMatrix.size(); i++)
    {
      if(adjMatrix[i][0] > vertices[currentVertex].costToChildren[i])
      {
        adjMatrix[i][0] = vertices[currentVertex].costToChildren[i];
      }

      currentVertex = getNextVertex(0);
    }

    for(int row = 1; i < adjMatrix.size(); row++)
    {
      for(int column = 0; column < adjMatrix.size(); column++)
      {
        if(adjMatrix[column][row - 1] > vertices[currentVertex].costToChildren[column] + adjMatrix[currentVertex][row - 1])
        {
          adjMatrix[column][row] = vertices[currentVertex].costToChildren[column] + adjMatrix[currentVertex][row - 1];
        }
      }
      vertices[currentVertex].visit();
      currentVertex = getNextVertex(row);
    }
}
