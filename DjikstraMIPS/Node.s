	#Node::Node()
	.text
	.globl Node$$v
Node$$v:
	#Constructor, which is a leaf function so no stack frame is needed
	#visited = false; 	
	li $t0, 0
	sw $t0, 0($a0) #This is where bool visited is stored, we store 0 there because 0 means false
	
	#Get to base address of costToChildren array
	add $a0, $a0, 4
	
	#Reuse $t0 for i
	#Loop through costToChildren array and set all to infinity
loadCostToChildrenArray:
	blt $t0, 5, loadWithInf
	j endNodeConstructor
	
loadWithInf:
	sll $t1, $t0, 2 # i * 4
	li $t2, 5
	mult $t1, $t2
	mflo $t1
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
	
	#void Node::setCost(int v, int cost)
	.text
	.globl Node$setCost$ii
Node$setCost$ii
	
	#costToChildren[v] = cost;
	#This is also a leaf function, so we do not need a stack frame
	
	#Load base address of array
	la $t0, 4($a0)
	
	# Multiply by 4
	sll $a1, $a1, 2
	
	#Get to the correct address
	add $t0, $t0, $a1
	#Store cost into that spot in the cost array
	sw $a2, 0($t0)
	
	jr $ra
	
	  
	
	
