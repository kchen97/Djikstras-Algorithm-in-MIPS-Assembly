//
//  Node.hpp
//  Djikstra_Algorithm_C++
//
//  Created by Korman Chen on 10/3/17.
//
//

#ifndef Node_hpp
#define Node_hpp

#include <stdio.h>
#include <iostream>
#include <vector>
using namespace std;

class Node
{
public:
    bool visited;
    vector<int> costToChildren;
    Node();
    Node(int);
    void visit();
    void setCost(int, int);
};

#endif /* Node_hpp */
