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
	Obstacle:		.word 0x00ccaadd
	Black:			.word 0x00000000
	Colour1:		.word 0x000aafff
	Colour2:		.word 0xbbb00fff
	Colour3:		.word 0xdddaa000
	Colour4:		.word 0x0cddaaff
	Colour5:		.word 0x00aaaaaa
	
	WaterRegionLowerY:	.word 12
	WaterRegionUpperY:	.word 8
	
	FrogX:			.space 4
	FrogY:			.space 4
	VehicleLocX:		.space 32
	VehicleLocY:		.space 32
	LogLocX:		.space 16
	LogLocY:		.space 16
	VehicleSpeed:		.word 1
	
	Collision:		.space 4096
.text
  main:
  	li $s7, 4 #lives remaining
  
  	ResetGame:
  	subi $s7, $s7, 1
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
	jal SaveVehicleXY
	addi $t2, $t2, 1
	li $t1, 20			# top right vehicle Y 
	li $t0, 16			# top right vehicle X
	jal SaveVehicleXY
	addi $t2, $t2, 1
	li $t1, 24			# bottom left vehicle Y 
	li $t0, 2			# bottom left vehicle X
	jal SaveVehicleXY
	addi $t2, $t2, 1	
	li $t1, 24			# bottom right vehicle Y 
	li $t0, 18			# bottom right vehicle X
	jal SaveVehicleXY
	addi $t2, $t2, 1
	# Initialize the coordinates of Logs
	li $t1, 8			# top left log Y 
	li $t0, 0			# top left log X
	jal SaveVehicleXY
	addi $t2, $t2, 1
	li $t1, 8			# top right log Y 
	li $t0, 16			# top right log X
	jal SaveVehicleXY
	addi $t2, $t2, 1
	li $t1, 12			# bottom left log Y 
	li $t0, 2			# bottom left log X
	jal SaveVehicleXY
	addi $t2, $t2, 1	
	li $t1, 12			# bottom right log Y 
	li $t0, 18			# bottom right log X
	jal SaveVehicleXY
	
	
	UpdateEverySecond:
		jal ClearCollisionArray
	
		jal MoveAllVehiclesX
		jal UpdateFrogXY
		
		jal RedrawAllGraphics
		
		jal CheckFrogCollision
		beq $t2, 1, ResetGame
		jal CheckFrogWin
		bge $t6, 1, EndGame
		
		li $v0, 32
		li $a0, 500
		syscall
		j UpdateEverySecond
	
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
		
SaveVehicleXY:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		# inputs: t0 X, t1 Y, t2 vehicle index
		li $s0, 4
		mult $t2, $s0
		mflo $s1
		sw $t1, VehicleLocY($s1)	# save coordinates into arrays
		sw $t0, VehicleLocX($s1)
		j ReturnFromFunction
		
LoadVehicleXY:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		#inputs: t2 vehicle index
		#outputs: t0 X, t1 Y
		li $s0, 4
		mult $t2, $s0
		mflo $s1
		lw $t1, VehicleLocY($s1)
		lw $t0, VehicleLocX($s1)
		j ReturnFromFunction
		
DrawAllVehicles:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		li $t2, 0
		DrawNextVehicle:
		bgt $t2, 7, ReturnFromFunction
			jal LoadVehicleXY
			jal DrawVehicle
		addi $t2, $t2, 1
		j DrawNextVehicle
DrawVehicle:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		add $s0, $zero, $t0
		add $s1,$zero, $t1
		li $s6, 32
		# input 	t0 Vehicle X coordinate, t1 Vehicle Y Coordinate
		lw $s3, Obstacle
		li $s5, 0	#relative y coordinate
		RepeatFor4Rows:
		bgt $s5, 3, ReturnFromFunction
			li $s4, 0	#relative x coordinate
			Draw7PixelsInRow:
			bgt $s4, 4, ExitDraw7PixelsInRow
			
			jal SaveAllTRegisters
				add $t0, $s4, $s0
				add $t1, $s5, $s1
			
				div $t0, $s6
				mfhi $t0
				div $t1, $s6
				mfhi $t1

				jal ReadFromCollisionArray
				addi $t2, $t2,1
				li $s7, 2
				div $t2, $s7
				mfhi $t2
				jal WriteToCollisionArray
				jal TranslateCoord
				sw $s3, 0($t9)
			jal RestoreAllTRegisters
						
			addi $s4, $s4,1
			j Draw7PixelsInRow
			ExitDraw7PixelsInRow:	
		addi $s5, $s5, 1
		j RepeatFor4Rows
			
MoveAllVehiclesX:
	addi $sp, $sp, -4
	sw $ra, 0($sp) 
	jal SaveAllSRegisters
		lw $s1, VehicleSpeed	
		li $t2, 0		# vehicle index
		li $s6, 32
		li $s5, 0
	UpdateVehicleX:
		bgt $t2, 7, ReturnFromFunction
		
		jal LoadVehicleXY
		add $t0, $s1, $t0
		blt $t0, 0, SetXtoMax
		div $t0, $s6
		mfhi $t0
		jal SaveVehicleXY
		
		addi $t2, $t2, 1
		addi $s5, $s5, 1
		bgt $s5, 1, SetSecondCounterZero
		j UpdateVehicleX
		SetXtoMax:
			addi $t0, $zero,32
			jal SaveVehicleXY
		j UpdateVehicleX
		SetSecondCounterZero:
			li $s5, 0
			sub $s1, $zero, $s1
		j UpdateVehicleX
		
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
		
		jal DrawAllVehicles
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
		# 
		li $t6, 0
		lw $s0, FrogY($zero)
		bge $s0, 8, ReturnFromFunction
		li $s1, 6
		div $s0, $s1
		mflo $t6
		addi $t6, $t6,1
		j ReturnFromFunction	
