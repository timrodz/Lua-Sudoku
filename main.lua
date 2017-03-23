-- Graphics
img_UI = nil
font_grid = nil
font_UI = nil
tileSize = 66
xOffset, yOfsset = 24, 24

-- Grid
gridSize = 9
gameGrid = {}
originalGrid = {}
resetGrid = {}
answerGrid = {}
solvingCancelTimer = 0
isSolving = false

-- Mouse clicking
mouseClickTimer = 0
canClick = true

-- Screenshake effect
shakeTime = 0
shakeDuration = 0.125
shakeMagnitude = 2.5
isShaking = false

-- Output to the ingame console
outputText = "Welcome to Sudoku! I'm the\nOutput console."

love.math.setRandomSeed(os.time())

-- Initialize the grids
for row = 1, gridSize do

	gameGrid[row] = {}
	originalGrid[row] = {}
	resetGrid[row] = {}
	answerGrid[row] = {}

	for col = 1, gridSize do
	
		gameGrid[row][col] = 0
		originalGrid[row][col] = 0
		resetGrid[row][col] = 0
		answerGrid[row][col] = 0
	
	end

end	

function love.load()
	img_UI = love.graphics.newImage("assets/img_UI.png")
	font_grid = love.graphics.newFont("assets/MarketFresh.otf", 30)
	font_UI = love.graphics.newFont("assets/BebasNeue.otf", 24)
end

function love.draw()

	-- Screen shake
	if (isShaking) then
		local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
		local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
		love.graphics.translate(dx, dy)
	end
	
	-- Draw the background, gameGrid and UI
	love.graphics.setBackgroundColor(84, 91, 102, 255)
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(img_UI, 0, 0)
	
	love.graphics.setFont(font_grid)
	
	-- Print the gameGrid
	for i = 1, gridSize do

		for j = 1, gridSize do

			-- Set the x offset
			if (i > 2 and i < 6) then
				xOffset = 26
			elseif (i > 5 and i < 9) then
				xOffset = 28
			else
				xOffset = 24
				yOfsset = 24
			end

			-- Set the y offset
			if (j > 2 and j < 6) then
				yOfsset = 26
			elseif (j > 5 and j < 9) then
				yOfsset = 28
			else
				xOffset = 24
				yOfsset = 24
			end

			if (gameGrid[i][j] > 0) then
				love.graphics.setColor(50, 50, 50, 255)
				love.graphics.print(gameGrid[i][j], xOffset + ((i - 1) * tileSize), yOfsset + ((j - 1) * tileSize))
			end
			
			if (resetGrid[i][j] > 0) then
				love.graphics.setColor(96, 91, 151, 255)
				love.graphics.print(resetGrid[i][j], xOffset + ((i - 1) * tileSize), yOfsset + ((j - 1) * tileSize))
			end

		end
		
	end
	
	-- Print to the output
	love.graphics.setColor(50, 50, 50, 255)
	love.graphics.setFont(font_UI)
	love.graphics.print(outputText, 624, 260)

end

function love.update(dt)

	if (shakeTime > shakeDuration) then
		shakeTime = 0
		isShaking = false
	end
	
	if (isSolving) then
		solvingCancelTimer = solvingCancelTimer + love.timer.getDelta()
	end
	
	if (solvingCancelTimer > 1.5) then
		print("Stopped solving")
		solvingCancelTimer = 0
		isSolving = false
	end
	
	local x, y = love.mouse.getPosition()
	
	if (love.mouse.isDown(1)) then
		
		if (not canClick) then
			return
		end
		
		-- Check for gameGrid clicks
		if ((x <= 600)) then
			PlaceValue(x, y, true)
		-- Check button
		elseif ((x >= 619 and x <= 741) and (y >= 19 and y <= 52)) then
			if (CheckSolution()) then
				outputText = "Correct solution.\nCongratulations!"
			else
				isShaking = true
				outputText = "Incorrect solution.\nKeep trying!"
			end
		-- Seed button
		elseif ((x >= 619 and x <= 741) and (y >= 67 and y <= 100)) then
			outputText = "Grid set to the summative's\nexample."
			TransformGrid("exercise", 0)
		-- Reset button
		elseif ((x >= 760 and x <= 882) and (y >= 19 and y <= 52)) then
			outputText = "Grid has been reset"
			CopyGrid(resetGrid, gameGrid)
		-- Solve button
		elseif ((x >= 760 and x <= 882) and (y >= 67 and y <= 100)) then
			isSolving = true
			if (Solve(gameGrid)) then
				outputText = "Solved"
				CopyGrid(gameGrid, answerGrid)
			else 
				isShaking = true
				outputText = "Not solvable!"
			end
			-- isSolving = false
		-- Easy Difficulty
		elseif ((x >= 760 and x <= 882) and (y >= 115 and y <= 148)) then
			outputText = "Mode: Easy"
			TransformGrid("easy", 1)
		-- Medium Difficulty
		elseif ((x >= 760 and x <= 882) and (y >= 163 and y <= 196)) then
			outputText = "Mode: Medium"
			TransformGrid("medium", 1)
		-- Hard Difficulty
		elseif ((x >= 760 and x <= 882) and (y >= 211 and y <= 244)) then
			outputText = "Mode: Hard"
			TransformGrid("hard", 1)
		end
		
		canClick = false
		
	elseif (love.mouse.isDown(1)) then
	
		if ((x <= 600)) then
			PlaceValue(x, y, false)
		end
	
	end
	
	if (not canClick) then
		mouseClickTimer = mouseClickTimer + love.timer.getDelta()
	end
	
	if (mouseClickTimer > 0.05) then
		mouseClickTimer = 0
		canClick = true
	end
	
	if (isShaking) then
		shakeTime = shakeTime + love.timer.getDelta()
	end

end

function InitializeGrid(seed)

	-- Initialize the grids
	for row = 1, gridSize do

		for col = 1, gridSize do
		
			gameGrid[row][col] = 0
			originalGrid[row][col] = 0
			resetGrid[row][col] = 0
			answerGrid[row][col] = 0
		
		end

	end

	-- Default seed, given in the summative brief
	if (seed == 0) then

		-- First line
		originalGrid[1][1] = 8
		originalGrid[4][1] = 4
		originalGrid[6][1] = 6
		originalGrid[9][1] = 7

		-- Second line
		originalGrid[7][2] = 4

		-- Third line
		originalGrid[2][3] = 1
		originalGrid[7][3] = 6
		originalGrid[8][3] = 5

		-- Fourth line
		originalGrid[1][4] = 5
		originalGrid[3][4] = 9
		originalGrid[5][4] = 3
		originalGrid[7][4] = 7
		originalGrid[8][4] = 8

		-- Fifth line
		originalGrid[5][5] = 7

		-- Sixth line
		originalGrid[2][6] = 4
		originalGrid[3][6] = 8
		originalGrid[5][6] = 2
		originalGrid[7][6] = 1
		originalGrid[9][6] = 3

		-- Seventh line
		originalGrid[2][7] = 5
		originalGrid[3][7] = 2
		originalGrid[8][7] = 9

		-- Eigth line
		originalGrid[3][8] = 1

		-- Ninth line
		originalGrid[1][9] = 3
		originalGrid[4][9] = 9
		originalGrid[6][9] = 2
		originalGrid[9][9] = 5

	elseif (seed == 1) then
		
		local rand = love.math.random
		local val = 1
	
		for row = 1, 3 do
		
			for col = 1, 3 do
				
				originalGrid[row][col] = val
				val = val + 1
			
			end
			
		end
	
		-- Shuffle the values
		for i = 3, 2, -1 do
			j = rand(i)
			grid[i], grid[j] = grid[j], grid[i]
		end

	end
	
	-- Copy the original gameGrid to the answer gameGrid
	CopyGrid(originalGrid, answerGrid)
	
	-- Solve the answer gameGrid
	Solve(answerGrid)

end

-- Copies the content of the source to the destination grid
function CopyGrid(src, dst)

	for row = 1, gridSize do

		for col = 1, gridSize do
			
			dst[row][col] = src[row][col]
		
		end

	end

end

-- Check whether or not the puzzle has been solved
-- If any space has a value of 0 (empty), puzzle is not yet solved
function IsSolved(gameGrid)

	for row = 1, 9 do

		for col = 1, 9 do

			if (gameGrid[row][col] == 0) then
				return false, row, col
			end

		end

	end

	return true

end

-- Solve the given puzzle (if possible)
function Solve(gameGrid)

	local hasFoundSolution, row, col = IsSolved(gameGrid)

	if (hasFoundSolution) then
		return true
	end

	for i = 1, 9 do

		-- Check for placement
		if (CheckPlacement(gameGrid, row, col, i)) then
		
			gameGrid[row][col] = i
		
			if (Solve(gameGrid)) then
				return true
			end
		
			gameGrid[row][col] = 0
		
		end

	end

	return false

end

-- Perform the row, column and box check at once
function CheckPlacement(gameGrid, row, col, val)

	return (
		CheckRow(gameGrid, row, val) and
		CheckCol(gameGrid, col, val) and
		CheckBox(gameGrid, row, col, val)
		)

end

-- Checks for repetitions in the row
function CheckRow(gameGrid, row, val)

	for col = 1, gridSize do

		if (gameGrid[row][col] == val) then

			return false

		end

	end

	return true

end

-- Checks for repetitions in the column
function CheckCol(gameGrid, col, val)

	for row = 1, gridSize do

		if (gameGrid[row][col] == val) then

			return false

		end

	end

	return true

end

-- Checks for repetitions inside the current box
function CheckBox(gameGrid, row, col, val)

	xCheck = 1
	yCheck = 1

	if (row > 6) then xCheck = 7
	elseif (row > 3) then xCheck = 4
	end

	if (col > 6) then yCheck = 7
	elseif (col > 3) then yCheck = 4
	end

	for i = xCheck, xCheck + 2 do

		for j = yCheck, yCheck + 2 do

			if (gameGrid[i][j] == val) then

				return false

			end

		end
	end

	return true

end

-- Determines whether or not the grids are solved
function CheckSolution()

	for row = 1, gridSize do
	
		for col = 1, gridSize do
	
			if ((gameGrid[row][col] ~= answerGrid[row][col]) or (gameGrid[row][col] == answerGrid[row][col] and answerGrid[row][col] == 0)) then
				
				return false
				
			end
		
		end
	
	end
	
	return true

end

-- Place a number in any position from the mouse click
function PlaceValue(x, y, goUp)
	
	for row = 1, gridSize do
	
		for col = 1, gridSize do
	
			-- Check that the position of the mouse is inside the correct tile
			if ((x < (tileSize * row)) and (x > (tileSize * (row - 1))) and
				(y < (tileSize * col)) and (y > (tileSize * (col - 1)))) then
				
				if (resetGrid[row][col] ~= 0) then
					return
				end
				
				if (goUp) then
				
					-- If it is, increment the value of the current gameGrid
					gameGrid[row][col] = gameGrid[row][col] + 1;
					
					-- If the value exceeds 9, reset it to 0
					if (gameGrid[row][col] >= 10) then
						gameGrid[row][col] = 1
					end
				
				else
				
					-- If it is, increment the value of the current gameGrid
					gameGrid[row][col] = gameGrid[row][col] - 1;
					
					-- If the value exceeds 9, reset it to 0
					if (gameGrid[row][col] <= 0) then
						gameGrid[row][col] = 9
					end
				
				end
				
			end
		
		end
	
	end

end

-- Swap the gameGrid values once it's been solved
function TransformGrid(type, seed)
	
	print("Transforming the gameGrid - Type: " .. type .. " - Seed: " .. seed)
	InitializeGrid(seed)
	
	for row = 1, gridSize do
		
		for col = 1, gridSize do
		
			if (type == "easy") then
				if (love.math.random(0, 1) == 1) then
					gameGrid[row][col] = answerGrid[row][col]
				end
			elseif (type == "medium") then
				if (love.math.random(0, 2) == 1) then
					gameGrid[row][col] = answerGrid[row][col]
				end
			elseif (type == "hard") then
				if (love.math.random(0, 4) == 1) then
					gameGrid[row][col] = answerGrid[row][col]
				end
			else
				gameGrid[row][col] = originalGrid[row][col]
			end
		
		end
	
	end
	
	CopyGrid(gameGrid, resetGrid)

end