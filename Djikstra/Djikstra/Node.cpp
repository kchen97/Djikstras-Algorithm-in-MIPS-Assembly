//
//  Node.cpp
//  Djikstra_Algorithm_C++
//
//  Created by Korman Chen on 10/3/17.
//
//

#include "Node.hpp"
#include <vector>
#include <iostream>
using namespace std;

Node::Node()
{
    visited = false; // A vertex is always initially unvisited
}

void Node::visit()
{
    visited = !visited; // Mark as visited
}

void Node::setCost(int v, int cost)
{
    costToChildren[v] = cost; // Set cost from this vertex to another vertex 'v'
}
