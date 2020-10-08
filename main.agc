
// Project: simpleRunner 
// Created: 2020-10-07
// Author: Michael Tang
// Modified: 2020-10-08

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "Simple Runner" )
SetWindowSize( 640, 640, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 480, 640 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

SetPrintSize(50)
// --- Create Sprites --- //
gosub createSprites
// --- Variables ---- //
score = 0
gameover = 0
start = 1

do
		// --- Start Screen --- //
		gosub startScreen
		// Input//
		// --- Move Player --- //
		gosub moveSprite
		// Process //
		// --- Move falling block --- //
		gosub moveFallingBlock
		// Process //
		// --- Calculate Score --- //
		gosub calculateScore
		// Process //
		// --- Check for Collision --- //
		gosub checkCollisions
		
		// --- End Screen --- //
		gosub gameoverScreen
    //Output
    Sync()
loop

// --- SUBROUTINES --- //
createSprites:

CreateImageColor(99, 50, 50, 50, 255) // GREY
CreateImageColor(1, 255, 255, 255, 255) //WHITE

//Background Sprite
CreateSprite(99,99)
SetSpriteSize(99, GetVirtualWidth(), GetVirtualHeight())

// Player Sprite
CreateSprite(1, 1)
SetSpriteSize(1, 20, 20)
playerX = GetVirtualWidth()/2 - GetSpriteWidth(1)/2
playerY = GetVirtualHeight() - GetSpriteHeight(1) - 15
SetSpritePosition(1, playerX, playerY)

// Falling Block
CreateSprite(2, 1)
SetSpriteSize(2, Random(GetVirtualWidth() / 32, GetVirtualWidth() / 4), Random(GetVirtualHeight() / 16, GetVirtualHeight() / 8))
fallingX = Random(0, GetVirtualWidth() - GetSpriteWidth(2))
fallingY = 50
SetSpritePosition(2, fallingX, fallingY)
fallingSPD = 5
return

moveSprite:

if GetRawKeyState(68) = 1 // 'd' key
	playerX = playerX + 5
else
	if GetRawKeyState(65) = 1 // 'a' key
		playerX = playerX - 5 
	endif
endif
// boundaries
if playerX > GetVirtualWidth() - GetSpriteWidth(1)
	playerX = GetVirtualWidth() - GetSpriteWidth(1)
endif
if playerX < 0
	playerX = 0
endif

SetSpritePosition(1, playerX, playerY)
return

moveFallingBlock:

fallingY = fallingY + fallingSPD

if fallingY > GetVirtualHeight()
	SetSpriteSize(2, Random(GetVirtualWidth() / 32, GetVirtualWidth() / 4), Random(GetVirtualHeight() / 16, GetVirtualHeight() / 8))
	fallingX = Random(0, GetVirtualWidth() - GetSpriteWidth(2))
	fallingY = 50
	if fallingSPD < 50 // Speed is capped 
		fallingSPD = fallingSPD + 2
	endif
endif

SetSpritePosition(2, fallingX, fallingY)

return

calculateScore:

score = score + 1
Printc("Score: ")
Print(score)

return

checkCollisions:

if GetSpriteCollision(1,2)
	gameover = 1
endif

return

gameoverScreen:

while gameover = 1
	// Input
	if GetRawKeyPressed(89) = 1 // 'y' key
		gameover = 0
		fallingSPD = 5
		score = 0
	endif
	if GetRawKeyPressed(78) = 1 // 'n' key
		end
	endif
	// Process
	// reposition player
	playerX = GetVirtualWidth()/2 - GetSpriteWidth(1)/2
	SetSpritePosition(1, playerX, playerY)
	// falling block off screen
	fallingY = GetVirtualHeight()
	SetSpritePosition(2, fallingX, fallingY)
	// Output
	Print("Game Over")
	Printc("Your final score: ")
	Print(score)
	Print("Play again? Y/N")
	
	Sync()
endwhile

return

startScreen:

while start = 1
	// Input
	if GetRawKeyPressed(13) = 1 // 'ENTER'
		start = 0
	endif
	if GetRawKeyPressed(27) = 1 // 'ESC'
		end
	endif
	// Processing
	SetSpritePosition(2, GetVirtualWidth(), GetVirtualHeight())
	// Output
	Print("Simple Runner")
	Print("Press ENTER to begin")
	Print("Press ESC to quit")
	Print("Use A and D to move player")

	Sync()
endwhile

return
