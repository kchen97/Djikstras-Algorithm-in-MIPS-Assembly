	#Node::Node()
	.text
	.globl Node$$v
Node$$v:
	#Constructor, which is a leaf function so no stack frame is needed
	#visited = false; 	
	li $t0, 0
	sw $t0, 0($a0) #This is where bool visited is stored, we store 0 there because 0 means false
	
	#Get to base address of costToChildren array
	addi $a0, $a0, 4
	
	#Reuse $t0 for i
	li $t0, 0
	#Loop through costToChildren array and set all to infinity
loadCostToChildrenArray:
	blt $t0, 5, loadWithInf
	j endNodeConstructor
	
loadWithInf:
	sll $t1, $t0, 2 # i * 4
	add $t3, $a0, $t1
	li $t2, 32000
	sw $t2, 0($t3)
	#i++
	addi $t0, $t0, 1
	j loadCostToChildrenArray
	
endNodeConstructor:
	jr $ra
	
	#void Node::visit()
	.text
	.globl Node$visit$v
Node$visit$v:
	
	#Used to mark vertices as visited and only does that so no stack frame is necessary
	#visited = true;
	li $t0, 1
	sw $t0, 0($a0) # 1 means true, and is how we refer to a vertex as visited
	
	jr $ra
	
	#void Node::setCost(int v1, int v2, int cost)
	.text
	.globl Node$setCost$ii
Node$setCost$ii:
	
	#costToChildren[v] = cost;
	#This is also a leaf function, so we do not need a stack frame
	
	#setCost from v1 -> v2
	li $t0, 24
	mult $a1, $t0 # v1 * 4 * 6
	mflo $t0
	add $t0, $t0, $a0
	addi $t0, $t0, 4 #Gets to base address of costToChildren array
	sll $t1, $a2, 2 # v2 * 4
	add $t0, $t0, $t1 #Gets to correct address to store cost
	sw $a3, 0($t0)
	
	#setCost from v2 -> v1
	li $t0, 24
	mult $a2, $t0 # v2 * 4 * 6
	mflo $t0
	add $t0, $t0, $a0
	addi $t0, $t0, 4 #Gets to base address of costToChildren array
	sll $t1, $a1, 2 # v1 * 4
	add $t0, $t0, $t1 #Gets to correct address to store cost
	sw $a3, 0($t0)
	
	jr $ra
	
	
#.include "/Users/kormanchen/Desktop/CS/Projects/Djikstra_Algorithm_C++/DjikstraMIPS/util.s"
