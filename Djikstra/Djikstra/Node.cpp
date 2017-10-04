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

Node::Node(int v, int children)
{
    vertex = v;
    visited = false;
    costToChildren.resize(children, 32000);
}

void Node::visit()
{
    visited = !visited;
}

void Node::setCost(int v, int cost)
{
    costToChildren[v] = cost;
}
