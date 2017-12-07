	.data
	prompt1: .asciiz "Current vertex is: "
	prompt2: .asciiz "Enter cost from current vertex to vertex: "
	prompt3: .asciiz "Enter: "
	enterStartingVertexPrompt: .asciiz "Enter starting vertex: "
	.text
	.globl main
main:
	#Not a leaf, so we need a stack frame
	#We have a fixed graph of a 5 nodes, and each node has
	#one word indicating true or false and an array of 5 words, so 6*4*5 = 120 just for the graph
	#adjMatrix requires 100 bytes, starts at 152($sp)
	#we also need startingVertex, i, j, default stack frame, total 256
	
	#int startingVertex, i, j;
	#vector<Node> graph;
	addi $sp, $sp, -256
	sw $s0, 16($sp) #Used to reference i
	sw $s1, 20($sp) #Used to reference j
	sw $s2, 24($sp) #Used to reference base addresses
	#28($sp) Used to reference user input
	#32($sp) is where base address of graph will be
	#152($sp) is where base address of adjMatrix from Djikstra will be
	sw $ra, 252($sp)
	
	#i = 0;
	li $s0, 0
	la $s2, 32($sp)
resizeLoop:
    #if(i >= graph.size()) goto doneResizing;
    	blt $s0, 5, buildGraph
    	j doneResizing
    
    	#graph[i].costToChildren.resize(maxNodes, 32000);
    	#The constructor will take care of this so all we need to do is load the correct spot from stack frame
buildGraph:
 	sll $t0, $s0, 2 # i * 4
 	li $t1, 6
 	mult $t0, $t1 # i * 6, we do this to get the correct amount to add to base address of graph
 	mflo $t1
 	add $a0, $s2, $t1 # Gets to the correct address in stack where the node will be stored
 	jal Node$$v
 	
    	#i++;
    	addi $s0, $s0, 1
   	#goto resizeLoop;
   	j resizeLoop	
doneResizing:

	#Construct adjMatrix
	la $s2, 152($sp)
	move $a0, $s2
	jal Djikstra$$v	
	
	la $s2, 32($sp)
	#Here is where we begin setting costs from v1 -> v2 (v2 -> v1 is done automatically)
	move $a0, $s2 #DO NOT CHANGE THIS (Base address of graph)
	li $a1, 0 # <- v1
	li $a2, 1 # <- v2
	li $a3, 1 # <- Cost
	jal Node$setCost$ii
	
	move $a0, $s2 #DO NOT CHANGE THIS (Base address of graph)
	li $a1, 0 # <- v1
	li $a2, 2 # <- v2
	li $a3, 1 # <- Cost
	jal Node$setCost$ii
	
	move $a0, $s2 #DO NOT CHANGE THIS (Base address of graph)
	li $a1, 1 # <- v1
	li $a2, 3 # <- v2
	li $a3, 2 # <- Cost
	jal Node$setCost$ii
	
	move $a0, $s2 #DO NOT CHANGE THIS (Base address of graph)
	li $a1, 1 # <- v1
	li $a2, 4 # <- v2
	li $a3, 1 # <- Cost
	jal Node$setCost$ii
	
	move $a0, $s2 #DO NOT CHANGE THIS (Base address of graph)
	li $a1, 3 # <- v1
	li $a2, 4 # <- v2
	li $a3, 1 # <- Cost
	jal Node$setCost$ii
	
	#Call to computation of adjMatrix, make sure to enter your starting vertex
	la $s2, 152($sp)
	move $a0, $s2
	la $a1, 32($sp)
	li $a2, 2 # <--- STARTING VERTEX!! CHANGE THIS TO TEST DIFFERENT STARTING VERTICES
	jal Djikstra$compute$ni
	
	
	#Restore $ra, s-registers, and stack frame
	lw $ra, 252($sp)
	lw $s0, 16($sp)
	lw $s1, 20($sp)
	lw $s2, 24($sp)
	addi $sp, $sp, 256
	jr $ra

#.include "/Users/kormanchen/Desktop/CS/Projects/Djikstra_Algorithm_C++/DjikstraMIPS/util.s"
#.include "/Users/kormanchen/Desktop/CS/Projects/Djikstra_Algorithm_C++/DjikstraMIPS/Node.s"
#.include "/Users/kormanchen/Desktop/CS/Projects/Djikstra_Algorithm_C++/DjikstraMIPS/Djikstra.s"
