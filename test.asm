#####################################################################
#
# CSC258H5S Fall 2021 Assembly Final Project
# University of Toronto, St. George
#
# Student: Xuan Du, 1002081132
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3 
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.data
	displayAddress:		.word 0x10008000
	Yellow:			.word 0x00fff000
	Green:			.word 0x000fff00
	Blue:			.word 0x00000fff
	White:			.word 0x00ffffff
	Purple:			.word 0x00ff0fff
	VehicleColour:		.word 0x00ccaadd
	Black:			.word 0x00000000
	Colour1:		.word 0x000aafff
	Colour2:		.word 0xbbb00fff
	Colour3:		.word 0xdddaa000
	Colour4:		.word 0x0cddaaff
	Colour5:		.word 0x00aaaaaa
	LogColour:		.word 0xdddaa000
	
	WaterRegionLowerY:	.word 12
	WaterRegionUpperY:	.word 8
	
	FrogX:			.space 4
	FrogY:			.space 4
	ObstacleLocX:		.space 32
	ObstacleLocY:		.space 32
	LogLocX:		.space 16
	LogLocY:		.space 16
	VehicleSpeed:		.word 1
	GoalRegion:		.space 20
	
	Collision:		.space 4096
.text
  main:
  	li $s7, 3 #lives remaining
  	li $s6, 5 #Goal regions left
  	ResetGame:
  	beq $s7, 0, EndGame
  	
  	#Initialize frog coordinate
  	li $s0, 14
  	li $s1, 28
  	sw $s0, FrogX($zero)
  	sw $s1, FrogY($zero)
	# Initialize the coordinates of Vehicles
	li $t2, 0			# Array index
	li $t1, 20			# top left vehicle Y 
	li $t0, 0			# top left vehicle X
	jal SaveObstacleXY
	addi $t2, $t2, 1
	li $t1, 20			# top right vehicle Y 
	li $t0, 16			# top right vehicle X
	jal SaveObstacleXY
	addi $t2, $t2, 1
	li $t1, 24			# bottom left vehicle Y 
	li $t0, 2			# bottom left vehicle X
	jal SaveObstacleXY
	addi $t2, $t2, 1	
	li $t1, 24			# bottom right vehicle Y 
	li $t0, 18			# bottom right vehicle X
	jal SaveObstacleXY
	addi $t2, $t2, 1
	# Initialize the coordinates of Logs
	li $t1, 8			# top left log Y 
	li $t0, 0			# top left log X
	jal SaveObstacleXY
	addi $t2, $t2, 1
	li $t1, 8			# top right log Y 
	li $t0, 16			# top right log X
	jal SaveObstacleXY
	addi $t2, $t2, 1
	li $t1, 12			# bottom left log Y 
	li $t0, 0			# bottom left log X
	jal SaveObstacleXY
	addi $t2, $t2, 1	
	li $t1, 12			# bottom right log Y 
	li $t0, 16			# bottom right log X
	jal SaveObstacleXY
	
	
	UpdateEverySecond:
		jal ClearCollisionArray
	
		jal MoveOddRowObstacles
		jal MoveEvenRowObstacles
		jal UpdateFrogXY
		
		jal RedrawAllGraphics
		
		jal CheckFrogCollision
		beq $t2, 1, CollisionReset
		jal CheckFrogWin
		bge $t6, 1, WinGoalRegion
		
		li $v0, 32
		li $a0, 500
		syscall
		j UpdateEverySecond
	WinGoalRegion:
		subi $s6, $s6, 1
		jal FillGoalRegion
		beq $s6, 0, EndGame
		j ResetGame
	CollisionReset:
		subi $s7, $s7, 1
		j ResetGame
	EndGame:
	li $v0, 10
	syscall
		
SaveAllTRegisters:
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	addi $sp, $sp, -4
	sw $t5, 0($sp)
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	addi $sp, $sp, -4
	sw $t7, 0($sp)
	addi $sp, $sp, -4
	sw $t8, 0($sp)
	addi $sp, $sp, -4
	sw $t9, 0($sp)
	jr $ra
	
RestoreAllTRegisters:
	lw $t9, 0($sp)
	addi $sp, $sp, 4
	lw $t8, 0($sp)
	addi $sp, $sp, 4
	lw $t7, 0($sp)
	addi $sp, $sp, 4
	lw $t6, 0($sp)
	addi $sp, $sp, 4
	lw $t5, 0($sp)
	addi $sp, $sp, 4
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
SaveAllSRegisters:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $s3, 0($sp)
	addi $sp, $sp, -4
	sw $s4, 0($sp)
	addi $sp, $sp, -4
	sw $s5, 0($sp)
	addi $sp, $sp, -4
	sw $s6, 0($sp)
	addi $sp, $sp, -4
	sw $s7, 0($sp)
	jr $ra
	
RestoreAllSRegisters:
	lw $s7, 0($sp)
	addi $sp, $sp, 4
	lw $s6, 0($sp)
	addi $sp, $sp, 4
	lw $s5, 0($sp)
	addi $sp, $sp, 4
	lw $s4, 0($sp)
	addi $sp, $sp, 4
	lw $s3, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
ReturnFromFunction:
	jal RestoreAllSRegisters
	lw $ra, 0($sp)
  	addi $sp, $sp, 4
  	jr $ra

# How to write a method
#  func1:
#	addi $sp, $sp, -4
#	sw $ra, 0($sp)
#	jal SaveAllSRegisters
#
#	logic...
#
#  	j LoadAndJumpBackToAddressOnStack

DrawRegion:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal SaveAllSRegisters
		#input t0 starting row index, t1 exclusive end row index, t2 colour, $t3 start column index $t4 end column index
		#input t5 value to write to collision array
		DrawNextRow:
		bge $t0, $t1, ReturnFromFunction
		#draw row
			add $s0, $zero, $t3
			DrawNextPixel:
			bge $s0, $t4, FinishDrawingRow
			
			jal SaveAllTRegisters
			add $t1, $t0, $zero
			add $t0, $s0, $zero
			
			li $s6, 32
			div $t0, $s6
			mfhi $t0
			jal TranslateCoord
			
			sw $t2, 0($t9)
			add $t2, $t5, $zero
			jal WriteToCollisionArray
			
			jal RestoreAllTRegisters
			
			addi $s0, $s0, 1
			j DrawNextPixel
			FinishDrawingRow:
		
		addi $t0, $t0, 1
		j DrawNextRow

TranslateCoord:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal SaveAllSRegisters
		# expect input in t0 = X t1 = Y
		addi $s0, $zero, 128	# save 32*4 into $s0
		mult $t1, $s0		# multiply the y axis by 128
		mflo $s2		# save the y axis into $s2
		addi $s1, $zero, 4	# save 4 into $s1
		mult $t0, $s1		# multiply the x axis by 128
		mflo $s3		# save the x axis into $s3
		add $t9, $s2, $s3	# add y axis and x axis 
		lw $s4, displayAddress	# load the display address
		add $t9, $t9, $s4	# add coordinate to the display address
		# return output in t9
		j ReturnFromFunction

DrawFrog:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		lw $t0, FrogX($zero)
		lw $t1, FrogY($zero)
		jal TranslateCoord
		# input t9 as absolute address on display
		lw $s0, Black
		sw $s0, 0($t9)
		sw $s0, 12($t9)
		sw $s0, 132($t9)
		sw $s0, 136($t9)
		sw $s0, 260($t9)
		sw $s0, 264($t9)
		sw $s0, 384($t9)
		sw $s0, 396($t9)
		j ReturnFromFunction
		
UpdateFrogXY:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		jal GetWASD
		# output t0 = 1 if move left, t1 = 1 if move right
		# output t2 = 1 if move up, t3 = 1 if move down
		jal UpdateMoveLeft
		jal UpdateMoveRight
		jal UpdateMoveUp
		jal UpdateMoveDown
		
		jal MoveFrogInWater
		j ReturnFromFunction
		
MoveFrogInWater:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		lw $s0, FrogX($zero)
		lw $s1, FrogY($zero)
		
		lw $s2, WaterRegionLowerY
		lw $s3, WaterRegionUpperY
		beq $s1, $s2, MoveToLeft
		beq $s1, $s3, MoveToRight
		j ReturnFromFunction
		MoveToLeft:
			ble $s0, 0, ReturnFromFunction
		
			subi $s0, $s0, 1
			sw $s0, FrogX($zero)
		
			j ReturnFromFunction
		MoveToRight:
			bge $s0, 28, ReturnFromFunction
		
			addi $s0, $s0, 1
			sw $s0, FrogX($zero)
		
			j ReturnFromFunction
	
	
UpdateMoveLeft:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		# input $t0 if true
		blt $t0, 1, ReturnFromFunction
		
		lw $s0, FrogX($zero)
		
		ble $s0, 0, ReturnFromFunction
		
		subi $s0, $s0, 2
		sw $s0, FrogX($zero)
		
		j ReturnFromFunction
				
UpdateMoveRight:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		# input $t1 if true
		blt $t1, 1, ReturnFromFunction
		lw $s0, FrogX($zero)
	
		bge $s0, 28, ReturnFromFunction
		
		addi $s0, $s0, 2
		sw $s0, FrogX($zero)
		
		j ReturnFromFunction
		
UpdateMoveUp:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		# input $t2 if true
		blt $t2, 1, ReturnFromFunction
		
		lw $s1, FrogY($zero)
		
		ble $s1, 3, SetYZero
		addi $s1, $s1, -4
		sw $s1, FrogY($zero)
		j ReturnFromFunction
				
		SetYZero:
		sw $zero, FrogY($zero)
		j ReturnFromFunction
		
UpdateMoveDown:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		# input $t3 if true
		blt $t3, 1, ReturnFromFunction
		
		lw $s1, FrogY($zero)
		
		bge $s1, 24, SetYMax
		addi $s1, $s1, 4
		sw $s1, FrogY($zero)
		j ReturnFromFunction
				
		SetYMax:
		li $s6, 28
		sw $s6, FrogY($zero)
		j ReturnFromFunction	
		
SaveObstacleXY:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		# inputs: t0 X, t1 Y, t2 Obstacle index
		li $s0, 4
		mult $t2, $s0
		mflo $s1
		sw $t1, ObstacleLocY($s1)	# save coordinates into arrays
		sw $t0, ObstacleLocX($s1)
		j ReturnFromFunction
		
LoadObstacleXY:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		#inputs: t2 vehicle index
		#outputs: t0 X, t1 Y
		li $s0, 4
		mult $t2, $s0
		mflo $s1
		lw $t1, ObstacleLocY($s1)
		lw $t0, ObstacleLocX($s1)
		j ReturnFromFunction
		
DrawAllVehicles:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		li $t2, 0
		DrawNextVehicle:
		bgt $t2, 3, ReturnFromFunction
			jal LoadObstacleXY
			jal SaveAllTRegisters
			jal DrawVehicle
			jal RestoreAllTRegisters
		addi $t2, $t2, 1
		j DrawNextVehicle
		
DrawAllLogs:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		li $t2, 4
		DrawNextLog:
		bgt $t2, 7, ReturnFromFunction
			jal LoadObstacleXY
			jal SaveAllTRegisters
			jal DrawLog
			jal RestoreAllTRegisters
		addi $t2, $t2, 1
		j DrawNextLog
DrawVehicle:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		add $s0, $zero, $t0
		add $s1,$zero, $t1
		li $s6, 32
		# input 	t0 Vehicle X coordinate, t1 Vehicle Y Coordinate
		lw $t2, VehicleColour
		add $t3, $t0, $zero
		add $t0, $t1, $zero
		addi $t1, $t1, 4
		addi $t4, $t3, 5
		
		li $t5, 1
		jal DrawRegion
		j ReturnFromFunction
		
DrawLog:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		add $s0, $zero, $t0
		add $s1,$zero, $t1
		li $s6, 32
		# input 	t0 Log X coordinate, t1 log Y Coordinate
		lw $t2, LogColour
		add $t3, $t0, $zero
		add $t0, $t1, $zero
		addi $t1, $t1, 4
		addi $t4, $t3, 10
		
		li $t5, 0
		jal DrawRegion
		j ReturnFromFunction
			
MoveOddRowObstacles:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		lw $s1, VehicleSpeed
		li $s2, 0		# First Counter from 0 to 1
		li $s6, 32
		li $s5, 0		# Second counter from {0, 4}
	UpdateOddRowObstaclesX:
		bgt $s2, 1, IncrementSecondCounter
		bgt $s5, 6, ReturnFromFunction
		add $t2, $s2, $s5	# t2 = index
		jal LoadObstacleXY
		add $t0, $s1, $t0
		div $t0, $s6
		mfhi $t0
		bge $t0, 32, NormalizeXBy32
		jal SaveObstacleXY
		
		addi $s2,$s2,1
		j UpdateOddRowObstaclesX
		NormalizeXBy32:
			subi $t0, $t0, 32
			jr $ra
		IncrementSecondCounter:
			addi $s5,$s5,4
			li $s2, 0
			j UpdateOddRowObstaclesX
			
MoveEvenRowObstacles:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		lw $s1, VehicleSpeed
		sub $s1, $zero, $s1
		subi $s1, $s1, 1
		li $s2, 0		# First Counter from 0 to 1
		li $s6, 32
		li $s5, 2		# Second counter from {2, 6}
	UpdateEvenRowObstaclesX:
		bgt $s2, 1, IncrementSecondCounter2
		bgt $s5, 8, ReturnFromFunction
		add $t2, $s2, $s5	# t2 = index
		jal LoadObstacleXY
		add $t0, $s1, $t0
		div $t0, $s6
		mfhi $t0
		blt $t0, 0, NormalizeXBy0
		jal SaveObstacleXY
		
		addi $s2,$s2,1
		j UpdateEvenRowObstaclesX
		NormalizeXBy0:
			addi $t0, $t0, 32
			jr $ra
		IncrementSecondCounter2:
			addi $s5,$s5,4
			li $s2, 0
			j UpdateEvenRowObstaclesX
		
RedrawAllGraphics:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		
		li $t0, 0
		li $t1, 8
		lw $t2, Yellow
		li $t3, 0
		li $t4, 1
		li $t5, 1
		jal DrawRegion	#GoalRegion Board
		
		
		li $t0, 0
		li $t1, 8
		lw $t2, Colour1
		li $t3, 1
		li $t4, 6
		li $t5, 0
		jal DrawRegion	#GoalRegion Slot1
		
		li $t0, 0
		li $t1, 8
		lw $t2, Yellow
		li $t3, 6
		li $t4, 7
		li $t5, 1
		jal DrawRegion	#GoalRegion Board
		
		li $t0, 0
		li $t1, 8
		lw $t2, Colour2
		li $t3, 7
		li $t4, 12
		li $t5, 0
		jal DrawRegion	#GoalRegion Slot2
		
		li $t0, 0
		li $t1, 8
		lw $t2, Yellow
		li $t3, 12
		li $t4, 13
		li $t5, 1
		jal DrawRegion	#GoalRegion Board
	
		li $t0, 0
		li $t1, 8
		lw $t2, Colour3
		li $t3, 13
		li $t4, 18
		li $t5, 0
		jal DrawRegion	#GoalRegion Slot3
		
		li $t0, 0
		li $t1, 8
		lw $t2, Yellow
		li $t3, 18
		li $t4, 19
		li $t5, 1
		jal DrawRegion	#GoalRegion Board

		li $t0, 0
		li $t1, 8
		lw $t2, Colour4
		li $t3, 19
		li $t4, 24
		li $t5, 0
		jal DrawRegion	#GoalRegion Slot4
		
		li $t0, 0
		li $t1, 8
		lw $t2, Yellow
		li $t3, 24
		li $t4, 25
		li $t5, 1
		jal DrawRegion	#GoalRegion Board

		li $t0, 0
		li $t1, 8
		lw $t2, Colour5
		li $t3, 25
		li $t4, 30
		li $t5, 0
		jal DrawRegion	#GoalRegion Slot5
		
		li $t0, 0
		li $t1, 8
		lw $t2, Yellow
		li $t3, 30
		li $t4, 32
		li $t5, 1
		jal DrawRegion	#GoalRegion Board
		
		li $t1, 16
		lw $t2, Blue
		li $t3, 0
		li $t4, 32
		li $t5, 1
		jal DrawRegion	#WaterRegion
		
		li $t1, 20
		lw $t2, Green
		li $t5, 0
		jal DrawRegion	#SafeRegion
		
		li $t1, 28
		lw $t2, White
		jal DrawRegion	#RoadRegion
		
		li $t1, 33
		lw $t2, Purple
		jal DrawRegion	#StartRegion
		
		jal FillGoalRegion
		
		jal DrawAllVehicles
		jal DrawAllLogs
		jal DrawFrog
	
	j ReturnFromFunction
			
GetWASD:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
	# output t0 = 1 if move left, t1 = 1 if move right
	# output t2 = 1 if move up, t3 = 1 if move down
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	lw $s0, 0xffff0000
	blt $s0, 1, ReturnFromFunction
		lw $s1,0xffff0004
		beq $s1, 0x61, respond_to_A
		beq $s1, 0x77, respond_to_W
		beq $s1, 0x73, respond_to_S
		beq $s1, 0x64, respond_to_D
		j ReturnFromFunction
	respond_to_A:
		li $t0, 1
		j ReturnFromFunction
	respond_to_W:
		li $t2, 1
		j ReturnFromFunction
	respond_to_S:
		li $t3, 1
		j ReturnFromFunction
	respond_to_D:
		li $t1, 1
		j ReturnFromFunction

ReadFromCollisionArray:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
	# input t0 X coordinate t1 Y coordinate
	# output t2 value
	jal TranslateCoord
	lw $s0, displayAddress
	sub $t9, $t9, $s0
	lw $t2, Collision($t9)
	j ReturnFromFunction
			
WriteToCollisionArray:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
	# input t0 X coordinate t1 Y coordinate t2 value
	jal TranslateCoord
	lw $s0, displayAddress
	sub $t9, $t9, $s0
	sw $t2, Collision($t9)
	j ReturnFromFunction
	
ClearCollisionArray:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		li $s0, 0
		li $s1, 0
		ClearNextSlot:
		bgt $s0, 1024, ReturnFromFunction
		
		sw $zero, Collision($s1)
		addi $s0, $s0, 1
		addi $s1, $s1, 4
		
		j ClearNextSlot
		
CheckFrogCollision:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		# output $t2 for boolean
		lw $t0, FrogX($zero)
		lw $t1, FrogY($zero)
		
		jal ReadFromCollisionArray
		beq $t2, 1, ReturnFromFunction
		
		addi $t0, $t0, 1
		jal ReadFromCollisionArray
		beq $t2, 1, ReturnFromFunction
		
		addi $t0, $t0, 1
		jal ReadFromCollisionArray
		beq $t2, 1, ReturnFromFunction
		
		addi $t0, $t0, 1
		jal ReadFromCollisionArray
		beq $t2, 1, ReturnFromFunction
		
		addi $t0, $t0, 1
		jal ReadFromCollisionArray
		j ReturnFromFunction
		
CheckFrogWin:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		# Check if frog Y at goal region and save 1 at the index of that goal region in the array
		# Return boolean if any goal region is won
		li $t6, 0
		li $s0, 0
		li $s1, 0
		lw $s0, FrogY($zero)		# s0 = forg Y 
		lw $s1, FrogX($zero)		# s1 = frog X
		bge $s0, 8, ReturnFromFunction	# if the frog Y is lower than 8, game will not win
		li $s2, 6
		div $s1, $s2
		mflo $t6			# t6 has the index of goal region 
		li $s3, 4
		mult $t6, $s3
		mflo $s5 			# s5 stores the goal region index times 4 for storing into array
		li $s2, 1			# t6 still store the goal region index for drawing
		sw $s2, GoalRegion($s5)
		li $t6, 1			# return 1 to t6
		j ReturnFromFunction	

FillGoalRegion:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
	jal SaveAllTRegisters
		# Input $t6 which goal region reached 
		li $s0, 0			# region loop index
		CheckGoalRegionArray:
		bgt $s0, 4, ExitFillGoalRegion
			li $s1, 4
			mult $s1, $s0		# get address in the array
			mflo $s3
	
			lw $s2, GoalRegion($s3)	# load the value in the array
			beq $s2, 1, FillRegion	# if this region is 1, meaning reached before
			addi $s0, $s0, 1	# not 1, check the next region
			j CheckGoalRegionArray	
			
		FillRegion:			# fill the region with yellow colour and mark the collision to 1
			li $t0, 0		# initialize all required registers for draw region
			li $t1, 8
			lw $t2, Yellow
			li $t3, 0		# strating column index
			li $t4, 0		# end column index
			li $t5, 1		# value to write into collision array
			li $s5, 6		# value to multiplay
		
			# s0 has the index, starting row = (index) * 6 + 1, end row = starting row + 5
			# start column = 0, end column = 8
			mult $s0, $s5
			mflo $t3
			addi $t3, $t3, 1	# starting column
			add $t4, $t3, 5		# end column
			jal DrawRegion
			
			# check the next region
			addi $s0, $s0, 1
			j CheckGoalRegionArray
		
		ExitFillGoalRegion:
			jal RestoreAllTRegisters
			j ReturnFromFunction
		
	
	
