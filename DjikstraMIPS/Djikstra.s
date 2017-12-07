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
	li $t1, 25
	
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
	
#lowestVertexLoop:
lowestVertexLoop:
    #if(i >= adjMatrix.size()) goto done; {
    	blt $t0, 5, findLowestVertex
    	j doneLowestVertexLoop
    	
    findLowestVertex:
        #if(!vertices[i].visited)
        sll $t3, $t0, 2 # i * 4
        li $t4, 6
        mult $t3, $t4
        mflo $t3
        add $t2, $a2, $t3 #Get to the correct spot in the vertices array by adding i * 4 * 6
        lw $t2, 0($t2) #Load the node object from that address
        bnez $t2, lowestVertexLoopIncrement
        #{
        #   lowestVertex = i;
        move $v0, $t0
        #    goto done;
        j doneLowestVertexLoop
        #}
        lowestVertexLoopIncrement:
        #i++;
        addi $t0, $t0, 1
        #goto lowestVertexLoop;
        j lowestVertexLoop
    #}
#done:
doneLowestVertexLoop:
	
	#i = lowestVertex;
	move $t0, $v0
	sll $t1, $a1, 2 # (row * 4 * 5)
    	li $t2, 5
    	mult $t1, $t2
    	mflo $t1
findLowestCost:
    #if(i >= adjMatrix.size()) goto done2; {
    beq $t0, 5, doneFindLowestCost
    #    if(adjMatrix[lowestVertex][row] > adjMatrix[i][row] && !vertices[i].visited)
    sll $t2, $t0, 2
    add $t2, $t2, $t1 # (i * 4) + (row * 4 * 5) = $t2
    add $t2, $t2, $a0 # $t2 = $t2 + (adjMatrix Base Address) corresponds to base address of adjMatrix[i][row]
    sll $t3, $v0, 2
    add $t3, $t3, $t1 # (lowestVertex * 4) + (row * 4 * 5) = $t3
    add $t3, $t3, $a0 # $t3 = $t3 + (adjMatrix Base Address) corresponds to base address of adjMatrix[lowestVertex][row]
    lw $t2, 0($t2) # Load the two values
    lw $t3, 0($t3)
    ble $t3, $t2, findLowestCostIncrement
    #	Now we have to make sure !vertices[i].visited
    sll $t2, $t0, 2
    li $t3, 6
    mult $t2, $t3
    mflo $t2 # i * 4 * 6
    add $t2, $t2, $a2 # Gets to base address of vertices[i]
    lw $t2, 0($t2)
    bnez $t2, findLowestCostIncrement # Checks !vertices[i].visited
    #	lowestVertex = i;
    move $v0, $t0
findLowestCostIncrement:
    #    i++;
    addi $t0, $t0, 1
    #    goto findLowestCost;
    j findLowestCost
doneFindLowestCost:

    jr $ra # $v0 will have lowestIndex at this point so we can just return

	.text
	.globl Djikstra$showShortestPaths$v
Djikstra$showShortestPaths$v:
	
	#Not a leaf, so we need a stack frame
	addi $sp, $sp, -28
	sw $ra, 24($sp)
	sw $s0, 16($sp) #s0 will point to the adjMatrix
	sw $s1, 20($sp) #s1 will contain column = 0
	
	#int column = 0;
	li $s1, 0
	#Get address of last row of adjMatrix
	addi $s0, $a0, 80
	#move $s0, $a0
displayLoop:
#    if(column >= adjMatrix.size()) goto doneDisplaying; {
	blt $s1, 5, display
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
#doneDisplaying:
doneDisplaying:

	#Restore $ra and s-registers
	lw $ra, 24($sp)
	lw $s0, 16($sp) 
	lw $s1, 20($sp)
	addi $sp, $sp, 28
	jr $ra


#void Djikstra::compute(vector<Node> &vertices, int startingVertex)
	.text
	.globl Djikstra$compute$ni
Djikstra$compute$ni:
	#Need to allocate space on stack for default stack frame + $ra + i + currentVertex + graphPtr + djikstraPtr -> 36
	addi $sp, $sp, -44
	sw $s0, 16($sp) # Used to reference i
	sw $s1, 20($sp) # Used to reference currentVertex/startingVertex
	sw $s2, 24($sp) # Used to reference the graph
	sw $s3, 28($sp) # Used to reference this object
	sw $s4, 32($sp) # Used to reference row
	sw $s5, 36($sp) # Used to reference column
	sw $ra, 40($sp)
	
	#Saved the graph's base address into $s2 and adjMatrix to $s3
	move $s2, $a1
	move $s3, $a0
	#int currentVertex = startingVertex, i = 0;
	li $s0, 0
	move $s1, $a2
	#vertices[currentVertex].visit();
	sll $t0, $s1, 2 #currentVertex * 4 * 6
	li $t1, 6
	mult $t0, $t1
	mflo $t0
	add $a0, $t0, $s2 #Gets to correct address
	jal Node$visit$v
	
initFirstRowLoop:
    #if(i >= adjMatrix.size()) goto firstRowFinished; {
    bge $s0, 5, firstRowFinished
        #if(adjMatrix[i][0] > vertices[currentVertex].costToChildren[i])
        sll $t0, $s0, 2 # i * 4
        add $t3, $t0, $s3 # Gets to address of adjMatrix[i][0]
        lw $t0, 0($t3) # $t0 = value of adjMatrix[i][0]
        li $t1, 24
        mult $t1, $s1 # currentVertex * 4 * 6
        mflo $t1
        add $t1, $t1, $s2
        la $t1, 4($t1) #Gets to base address of costToChildren array
        sll $t2, $s0, 2
        add $t1, $t1, $t2 # Gets to address of vertices[currentVertex].costToChildren[i]
        lw $t1, 0($t1) # Gets value of vertices[currentVertex].costToChildren[i]
        ble $t0, $t1, initFirstRowLoopIncrement
        #adjMatrix[i][0] = vertices[currentVertex].costToChildren[i];
        sw $t1, 0($t3)
initFirstRowLoopIncrement:
        #i++;
        addi $s0, $s0, 1
        #goto initFirstRowLoop;
        j initFirstRowLoop
    #}
firstRowFinished:
	
	#currentVertex = getNextVertex(0, vertices); //Get initial lowest cost from first row
	move $a0, $s3
	move $a1, $zero
	move $a2, $s2
	jal Djikstra$getNextVertex$in
	move $s1, $v0
	
	#int row = 1;
	li $s4, 1
computeRowLoop:
	#if(row >= adjMatrix.size()) goto matrixFinished; {
	bge $s4, 5, matrixFinished
	#int column = 0;
	li $s5, 0
	#Pre-compute arithmetic for (row - 1)
	subi $t0, $s4, 1
	sll $t0, $t0, 2 #(row * 4 * 5)
	li $t1, 5
	mult $t0, $t1
	mflo $t0
	#Pre-compute arithmetic for currentVertex
	sll $t1, $s1, 2 # (currentVertex * 4 * 6)
	li $t2, 6
	mult $t1, $t2
	mflo $t1
	computeColumnLoop:
		#if(column >= adjMatrix.size()) goto rowFinished; {
		bge $s5, 5, rowFinished
		#if(adjMatrix[column][row - 1] > vertices[currentVertex].costToChildren[column] + 
		#adjMatrix[currentVertex][row - 1] && !vertices[column].visited)
		sll $t2, $s5, 2 # column * 4 = $t2
		add $t2, $t2, $t0
		add $t2, $t2, $s3 # Now $t2 is the address of adjMatrix[column][row - 1]
		lw $t2, 0($t2) # Now $t2 has the value of adjMatrix[column][row - 1]
		
		add $t3, $t1, $s2 # $t3 now has address vertices[currentVertex]
		addi $t3, $t3, 4 # This would put $t3 at the base address of it's costToChildren array
		sll $t4, $s5, 2 # column * 4 = $t4
		add $t3, $t4, $t3 # This puts $t3 at the address of vertices[currentVertex].costToChildren[column]
		lw $t3, 0($t3) # This sets $t3 to value of vertices[currentVertex].costToChildren[column]
		
		sll $t4, $s1, 2 # (currentVertex * 4)
		add $t4, $t0, $t4 #Gets correct arithmetic for [currentVertex][row - 1]
		add $t4, $t4, $s3 # Now $t4 has address of adjMatrix[currentVertex][row - 1]
		lw $t4, 0($t4) # Now $t4 has value of adjMatrix[currentVertex][row - 1]
		
		#Now we can finally evaluate the first part of the if-statement
		add $t3, $t3, $t4 # (vertices[currentVertex].costToChildren[column] + adjMatrix[currentVertex][row - 1])
		bgt $t2, $t3, checkIfVisited
		j updateWithOld
		
		checkIfVisited:
		sll $t4, $s5, 2 # (column * 4 * 6) because we want to get to vertices[column]
		li $t5, 6
		mult $t4, $t5
		mflo $t4
		add $t4, $t4, $s2 # Now $t4 has address of vertices[column]
		lw $t4, 0($t4) # Now $t4 has value of vertices[column].visited
		bnez $t4, updateWithOld # Checks !vertices[column].visited
		
		#Passing all conditions means we found a cheaper cost, so we need to update the adjMatrix
		#adjMatrix[column][row] = vertices[currentVertex].costToChildren[column] + adjMatrix[currentVertex][row - 1];
		sll $t4, $s4, 2 #(row * 4 * 5) Need this arithmetic to get to correct spot in adjMatrix to update
		li $t5, 5
		mult $t4, $t5
		mflo $t4
		sll $t5, $s5, 2 # (column * 4)
		add $t4, $t4, $t5
		add $t4, $t4, $s3 # Now $t4 has address of adjMatrix[column][row]
		sw $t3, 0($t4) # Puts the cheaper cost at address of adjMatrix[column][row]
		j columnLoopIncrement
		
		updateWithOld:
		#Failing any conditions would bring us here meaning we did not find a cheaper cost
		#adjMatrix[column][row] = adjMatrix[column][row - 1];
		sll $t4, $s4, 2 #(row * 4 * 5) Need this arithmetic to get to correct spot in adjMatrix to update
		li $t5, 5
		mult $t4, $t5
		mflo $t4
		sll $t5, $s5, 2 # (column * 4)
		add $t4, $t4, $t5
		add $t4, $t4, $s3 # Now $t4 has address of adjMatrix[column][row]
		sw $t2, 0($t4) # Puts old cost at address of adjMatrix[column][row]
		
		columnLoopIncrement:
		#column++;
		addi $s5, $s5, 1
            	#goto computeColumnLoop;
            	j computeColumnLoop
	rowFinished:
		#vertices[currentVertex].visit();
		sll $t0, $s1, 2 # (currentVertex * 4 * 6)
		li $t1, 6
		mult $t0, $t1
		mflo $t0
		add $a0, $t0, $s2 #This puts $a0 at address of vertices[currentVertex]
		jal Node$visit$v #Mark it as visited
		#currentVertex = getNextVertex(row, vertices);
		move $a0, $s3
		move $a1, $s4
		move $a2, $s2
		jal Djikstra$getNextVertex$in
		move $s1, $v0
		#row++;
		addi $s4, $s4, 1
        	#goto computeRowLoop;
        	j computeRowLoop
matrixFinished:
	#showShortestPaths();
	move $a0, $s3
	jal Djikstra$showShortestPaths$v
	
	#Now we deallocate stack frame and restore $ra and s-registers
	lw $s0, 16($sp) # Used to reference i
	lw $s1, 20($sp) # Used to reference currentVertex/startingVertex
	lw $s2, 24($sp) # Used to reference the graph
	lw $s3, 28($sp) # Used to reference this object
	lw $s4, 32($sp) # Used to reference row
	lw $s5, 36($sp) # Used to reference column
	lw $ra, 40($sp)
	addi $sp, $sp, 44
	jr $ra
