	.text
	.globl main
main:
	#Not a leaf, so we need a stack frame
	#We have a fixed graph of a 5 nodes, and each node has
	#one word indicating true or false and an array of 5 words, so 6*4*5 = 120 just for the graph
	#we also need startingVertex, i, j, default stack frame, total 152
	
	#int startingVertex, i, j;
	#vector<Node> graph;
	addi $sp, $sp, -152
	sw $s0, 16($sp) #Used to reference startingVertex
	sw $s1, 20($sp) #Used to reference i
	sw $s2, 24($sp) #Used to reference j and beginning address of graph
	sw $ra, 148($sp)
	
	#i = 0;
	li $s1, 0
	la $s2, 28($sp)
resizeLoop:
    #if(i >= graph.size()) goto doneResizing;
    	blt $s1, 5, buildGraph
    	j doneResizing
    
    	#graph[i].costToChildren.resize(maxNodes, 32000);
    	#The constructor will take care of this so all we need to do is load the correct spot from stack frame
buildGraph:
 	sll $t0, $s1, 2 # i * 4
 	li $t1, 5
 	mult $t0, $t1 # i * 5, we do this to get the correct amount to add to base address of graph
 	mflo $t1
 	add $a0, $s2, $t1 # Gets to the correct address in stack where the node will be stored
 	jal Node$$v
 	
    	#i++;
    	addi $s1, $s1, 1
   	#goto resizeLoop;
   	j resizeLoop	
doneResizing:	
	