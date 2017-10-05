//
//  TestDjikstra.cpp
//  Djikstra_Algorithm_C++
//
//  Created by Korman Chen on 10/4/17.
//
//

#include <stdio.h>
#include <iostream>
#include <vector>
#include "Djikstra.hpp"
#include "Node.hpp"
using namespace std;

int main()
{
    int startingVertex, maxNodes;
    vector<Node> graph;
    
    cout << "How many nodes are there?" << endl;
    cin >> maxNodes;
    graph.resize(maxNodes);
    
    for(int i = 0; i < graph.size(); i++)
    {
        graph[i].costToChildren.resize(maxNodes, 32000);
    }
    
    for(int i = 0; i < graph.size(); i++)
    {
        for(int j = 0; j < graph.size(); j++)
        {
            int cost;
            if(j != i && graph[i].costToChildren[j] == 32000)
            {
                cout << "Enter cost from vertex " << i << " to vertex " << j << ": \n";
                cin >> cost;
                graph[i].setCost(j, cost);
                graph[j].setCost(i, cost);
            }
        }
    }
    
    cout << "Enter a starting vertex: " << endl;
    cin >> startingVertex;
    
    Djikstra shortPaths(maxNodes);
    shortPaths.compute(graph, startingVertex);
    
    
    return 0;
}
