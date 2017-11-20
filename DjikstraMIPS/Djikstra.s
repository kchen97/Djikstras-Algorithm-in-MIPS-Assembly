	#Djikstra::Djikstra(int verts) -> is a leaf so no stack frame is necessary
	.text
	.globl Djikstra$$v
Djikstra$$v:
	
	#This implementation will have a fixed 5 vertices for simplicity
	
	#adjMatrix.resize(verts);
	#for(int i = 0; i < verts; i++)
   	#{
        #adjMatrix[i].resize(verts, 32000); //Initialize all costs to a large cost
    	#}
    	
	#Instead, we will initialize a 2-d array of 25 words
	#Each words value will be initially set to 32000, which is what we will refer to as infinity, or max cost
	
	
	#int i = 0;
	li $t0, 0
	li $t1, 20
	
	#We will loop through the whole matrix and set all of its costs to infinity
	# $a0 has base address of adjMatrix array
	constructorLoop:
	beq $t0, $t1, constructorReturn
	move $t2, $a0
	
	#Get to the correct address
	sll $t3, $t0, 2 # i *= 4;
	add $t2, $t2, $t3
	
	#adjMatrix[i].resize(verts, 32000); (Not really what is happening, but same end result)
	li $t4, 32000
	#Put "infinity" exactly where we are in the array
	sw $t4, 0($t2)
	
	# i++;
	addi $t0, $t0, 1
	j constructorLoop
	
	constructorReturn:
	jr $ra
	
	#int Djikstra::getNextVertex(int row, vector<Node> &vertices)
	.text
	.globl Djikstra$getNextVertex$in
Djikstra$getNextVertex$in:
	
	#int lowestVertex; 
	#$v0 will be lowestVertex
	li $v0, 0
	
	#int i = 0;
	li $t0, 0
	#adjMatrix.size(), which is 5 becauze in this case
	li $t1, 5
	
#lowestVertexLoop:
lowestVertexLoop:
    #if(i >= adjMatrix.size()) goto done; {
    	blt $t0, $t1, findLowestVertex
    	j doneLowestVertexLoop
    	
    findLowestVertex:
        #if(!vertices[i].visited)
        sll $t3, $t0, 2 # i * 4
        add $t2, $a2, $t3 #Get to the correct spot in the vertices array by adding i * 4
        lw $t2, 0($t2) #Load the node object from that address
        
        
        #{
        #   lowestVertex = i;
        #    goto done;
        #}
        #i++;
        #goto lowestVertexLoop;
    #}
#done:
doneLowestVertextLoop:
	
	
	
	
	
	
	.data
	prompt1: .asciiz "Minimum cost to "
	prompt2: .asciiz " is "
	.text
	.globl Djikstra$showShortestPaths$v
Djisktra$showShortestPaths$v:
	
	#Not a leaf, so we need a stack frame
	addi $sp, $sp, -32
	sw $ra, 28($sp)
	sw $s0, 16($sp) #s0 will point to the adjMatrix
	sw $s1, 20($sp) #s1 will contain column = 0
	sw $s2, 24($sp) #s2 will contain # of nodes
	
	#int column = 0;
	li $s1, 0
	li $s2, 5
	#Get address of last row of adjMatrix
	addi $s0, $a0, 80
	
#displayLoop:
displayLoop:
#    if(column >= adjMatrix.size()) goto doneDisplaying; {
	blt $s1, $s2, display
	j doneDisplaying
	
display:
#        cout << "Minimum cost to " << column << " is " << adjMatrix[column][adjMatrix.size() - 1] << "." << endl;

	sll $t0, $s1, 2 #column * 4
	add $t0, $s0, $t0
	lw $a0, 0($t0)
	jal PrintInteger
#        column++;
	addi $s1, $s1 ,1
#        goto displayLoop;
	j displayLoop
#    }
#doneDisplaying:
doneDisplaying:

	#Restore $ra and s-registers
	sw $ra, 28($sp)
	sw $s0, 16($sp) 
	sw $s1, 20($sp)
	sw $s2, 24($sp)
	addi $sp, $sp, -32
	jr $ra


#void Djikstra::compute(vector<Node> &vertices, int startingVertex)
	.text
	.globl Djikstra$compute$ni
Djikstra$compute$ni:
	
	
	
	