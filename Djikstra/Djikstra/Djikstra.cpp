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
        adjMatrix[i].resize(verts, 32000); //Initialize all costs to a large cost
    }
}

int Djikstra::getNextVertex(int row, vector<Node> &vertices)
{
    int lowestVertex;
    
    int i = 0;
lowestVertexLoop:
    if(i >= adjMatrix.size()) goto done; {
        if(!vertices[i].visited)
        {
            lowestVertex = i;
            goto done;
        }
        i++;
        goto lowestVertexLoop;
    }
done:
    
    /*for(int i = 0; i < adjMatrix.size(); i++) //Find the first unvisited vertex
    {
      if(!vertices[i].visited)
      {
        lowestVertex = i;
        break;
      }
    }*/
    
    i = lowestVertex;
findLowestCost:
    if(i >= adjMatrix.size()) goto done2; {
        if(adjMatrix[lowestVertex][row] > adjMatrix[i][row] && !vertices[i].visited)
        {
            lowestVertex = i;
        }
        i++;
        goto findLowestCost;
    }
done2:
    
    /*for(int i = lowestVertex; i < adjMatrix.size(); i++) //Find the cheapest cost we've seen so far and make sure it's unvisited
    {
        if(adjMatrix[lowestVertex][row] > adjMatrix[i][row] && !vertices[i].visited)
        {
            lowestVertex = i;
        }
    }*/
    return lowestVertex;
}

void Djikstra::showShortestPaths()
{
    int column = 0;
displayLoop:
    if(column >= adjMatrix.size()) goto doneDisplaying; {
        cout << "Minimum cost to " << column << " is " << adjMatrix[column][adjMatrix.size() - 1] << "." << endl;
        column++;
        goto displayLoop;
    }
doneDisplaying:
    cout << endl;
    
    /*for(int column = 0; column < adjMatrix.size(); column++)
    {
        cout << "Minimum cost to " << column << " is " << adjMatrix[column][adjMatrix.size() - 1] << "." << endl;
    }*/
}


void Djikstra::compute(vector<Node> &vertices, int startingVertex)
{
    int currentVertex = startingVertex, i = 0;
    vertices[currentVertex].visit();

    /*for(int i = 0; i < adjMatrix.size(); i++) {
      if(adjMatrix[i][0] > vertices[currentVertex].costToChildren[i])
      {
        adjMatrix[i][0] = vertices[currentVertex].costToChildren[i];
      }
    }*/

initFirstRowLoop:
    if(i >= adjMatrix.size()) goto firstRowFinished; {
        if(adjMatrix[i][0] > vertices[currentVertex].costToChildren[i])
        {
            adjMatrix[i][0] = vertices[currentVertex].costToChildren[i];
        }
        i++;
        goto initFirstRowLoop;
    }
firstRowFinished:
    
    currentVertex = getNextVertex(0, vertices); //Get initial lowest cost from first row
    
    int row = 1;
computeRowLoop:
    if(row >= adjMatrix.size()) goto matrixFinished; {
        int column = 0;
    computeColumnLoop:
        if(column >= adjMatrix.size()) goto rowFinished; {
            if(adjMatrix[column][row - 1] > vertices[currentVertex].costToChildren[column] + adjMatrix[currentVertex][row - 1] && !vertices[column].visited)
            { //If there cost to the currentVertex that is cheaper than anything we have seen before we update the matrix
                adjMatrix[column][row] = vertices[currentVertex].costToChildren[column] + adjMatrix[currentVertex][row - 1];
            }
            else
            {
                adjMatrix[column][row] = adjMatrix[column][row - 1]; //Update the next row otherwise
            }
            column++;
            goto computeColumnLoop;
        }
    rowFinished:
        vertices[currentVertex].visit(); //Since we are done checking all of currentVertex's edges, we mark it as visited
        currentVertex = getNextVertex(row, vertices); //Get the next vertex with the cheapest cost
        row++;
        goto computeRowLoop;
    }
matrixFinished:
    
    
    
    /*for(int row = 1; row < adjMatrix.size(); row++)
    {
      for(int column = 0; column < adjMatrix.size(); column++)
      {
        if(adjMatrix[column][row - 1] > vertices[currentVertex].costToChildren[column] + adjMatrix[currentVertex][row - 1] && !vertices[column].visited)
        { //If there cost to the currentVertex that is cheaper than anything we have seen before we update the matrix
          adjMatrix[column][row] = vertices[currentVertex].costToChildren[column] + adjMatrix[currentVertex][row - 1];
        }
        else
        {
            adjMatrix[column][row] = adjMatrix[column][row - 1]; //Update the next row otherwise
        }
          
      }
      vertices[currentVertex].visit(); //Since we are done checking all of currentVertex's edges, we mark it as visited
      currentVertex = getNextVertex(row, vertices); //Get the next vertex with the cheapest cost 
    }*/
    
    showShortestPaths();
}
