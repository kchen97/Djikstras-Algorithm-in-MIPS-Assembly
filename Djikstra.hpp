//
//  Djikstra.hpp
//  Djikstra_Algorithm_C++
//
//  Created by Korman Chen on 10/3/17.
//
//

#ifndef Djikstra_hpp
#define Djikstra_hpp

#include <stdio.h>
#include "Node.hpp"
#include <vector>
#include <iostream>
using namespace std;

class Djikstra
{
private:
    vector< vector<int> > adjMatrix;
public:
    Djikstra(int);
    void compute(vector<Node> &, int);
    int getNextVertex(int);
};

#endif /* Djikstra_hpp */
