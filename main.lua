-- Graphics
img_UI = nil
font = nil
tileSize = 66
xOffset, yOfsset = 24, 24

-- Math
grid = {}
answer = {}
gridSize = 9

currentSeed = 0

-- Initialize the grids
for row = 1, gridSize do

	grid[row] = {}
	answer[row] = {}

	for col = 1, gridSize do
	
		grid[row][col] = 0
		answer[row][col] = 0
	
	end

end
	

function love.load()
	img_UI = love.graphics.newImage('assets/img_UI.png');
	font = love.graphics.newFont('assets/font.otf', 30)
end

function love.draw()

	love.graphics.setFont(font)
	love.graphics.setBackgroundColor(222, 94, 94, 255)
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(img_UI, 0, 0)
	love.graphics.setColor(50, 50, 50, 255)

	-- Print the grid
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

			-- Print random numbers
			if (grid[i][j] > 0) then
				love.graphics.print(grid[i][j], xOffset + ((i - 1) * tileSize), yOfsset + ((j - 1) * tileSize))
			end

		end
	end

end

function love.update(dt)
	
	local x, y = love.mouse.getPosition()
	
	if (love.mouse.isDown(1)) then
		
		-- Check for grid clicks
		if (x <= 600) then
			PlaceValue(x, y)
		-- Check button
		elseif ((x >= 619 and x <= 741) and (y >= 19 and y <= 52)) then
			CompareAnswers()
		-- Seed button
		elseif ((x >= 619 and x <= 741) and (y >= 67 and y <= 100)) then
			InitializeGrid(love.math.random(0, 1))
		-- Reset button
		elseif ((x >= 760 and x <= 882) and (y >= 19 and y <= 52)) then
			InitializeGrid(currentSeed)
		-- Solve button
		elseif ((x >= 760 and x <= 882) and (y >= 67 and y <= 100)) then
			Solve(grid)
		-- Easy Difficulty
		elseif ((x >= 760 and x <= 882) and (y >= 115 and y <= 148)) then
			TransformGrid("easy")
		-- Medium Difficulty
		elseif ((x >= 760 and x <= 882) and (y >= 163 and y <= 196)) then
			TransformGrid("medium")
		-- Hard Difficulty
		elseif ((x >= 760 and x <= 882) and (y >= 211 and y <= 244)) then
			TransformGrid("hard")
		end
		
		return
	
	end

end

function InitializeGrid(seed)

	currentSeed = seed

	-- Initialize the grids
	for row = 1, gridSize do

		for col = 1, gridSize do
		
			grid[row][col] = 0
			answer[row][col] = 0
		
		end

	end

	-- Default seed, given in the summative brief
	if (seed == 0) then

		-- First line
		answer[1][1] = 8
		answer[4][1] = 4
		answer[6][1] = 6
		answer[9][1] = 7

		-- Second line
		answer[7][2] = 4

		-- Third line
		answer[2][3] = 1
		answer[7][3] = 6
		answer[8][3] = 5

		-- Fourth line
		answer[1][4] = 5
		answer[3][4] = 9
		answer[5][4] = 3
		answer[7][4] = 7
		answer[8][4] = 8

		-- Fifth line
		answer[5][5] = 7

		-- Sixth line
		answer[2][6] = 4
		answer[3][6] = 8
		answer[5][6] = 2
		answer[7][6] = 1
		answer[9][6] = 3

		-- Seventh line
		answer[2][7] = 5
		answer[3][7] = 2
		answer[8][7] = 9

		-- Eigth line
		answer[3][8] = 1

		-- Ninth line
		answer[1][9] = 3
		answer[4][9] = 9
		answer[6][9] = 2
		answer[9][9] = 5

	elseif (seed == 1) then
	
		

	end
	
	-- CAN BE SKIPPED
	-- Make the answer grid be equal to the solving grid
	-- for row = 1, gridSize do

	-- 	for col = 1, gridSize do
		
	-- 		answer[row][col] = grid[row][col]
		
	-- 	end

	-- end
	
	-- Solve it and use it as comparison
	Solve(answer)

end

-- Check whether or not the puzzle has been solved
-- If any space has a value of 0 (empty), puzzle is not yet solved
function IsSolved(grid)

	for row = 1, 9 do

		for col = 1, 9 do

			if (grid[row][col] == 0) then
				return false, row, col
			end

		end

	end

	return true

end

-- Solve the given puzzle (if possible)
function Solve(grid)

	local hasFoundSolution, row, col = IsSolved(grid)

	if (hasFoundSolution) then
		return true
	end

	for i = 1, 9 do

		if (CheckPlacement(grid, row, col, i)) then
			grid[row][col] = i
			if (Solve(grid)) then
				return true
			end
			grid[row][col] = 0
		end

	end

	return false

end

-- Perform the row, column and box check at once
function CheckPlacement(grid, row, col, val)

	return (
		CheckRow(grid, row, val) and
		CheckCol(grid, col, val) and
		CheckBox(grid, row, col, val)
		)

end

-- Checks for repetitions in the row
function CheckRow(grid, row, val)

	for col = 1, gridSize do

		if (grid[row][col] == val) then

			return false

		end

	end

	return true

end

-- Checks for repetitions in the column
function CheckCol(grid, col, val)

	for row = 1, gridSize do

		if (grid[row][col] == val) then

			return false

		end

	end

	return true

end

-- Checks for repetitions inside the current box
function CheckBox(grid, row, col, val)

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

			if (grid[i][j] == val) then

				return false

			end

		end
	end

	return true

end

-- Determines whether or not the grids are solved
function CompareAnswers()

	for row = 1, gridSize do
	
		for col = 1, gridSize do
	
			if (grid[row][col] ~= answer[row][col]) then
				
				print("Not solved")
				return false
				
			end
		
		end
	
	end
	
	print("Correctly Solved")
	return true

end

-- Swap the grid values once it's been solved
function TransformGrid(type)

	InitializeGrid(currentSeed)

	if (type == "easy") then
	
		for row = 1, gridSize do
		
			for col = 1, gridSize do
		
				if (love.math.random(0, 1) == 1) then
					grid[row][col] = answer[row][col]
				end
			
			end
		
		end
	
	elseif (type == "medium") then

		

	elseif (type == "hard") then



	else



	end

end

-- Place a number in any position
function PlaceValue(x, y)
	
	for row = 1, gridSize do
	
		for col = 1, gridSize do
	
			-- Check that the position of the mouse is inside the correct tile
			if ((x < (tileSize * row)) and (x > (tileSize * (row - 1))) and
				(y < (tileSize * col)) and (y > (tileSize * (col - 1)))) then
				
				-- If it is, increment the value of the current grid
				grid[row][col] = grid[row][col] + 1;
				
				-- If the value exceeds 9, reset it to 0
				if (grid[row][col] >= 10) then
					grid[row][col] = 1
				end
				
			end
		
		end
	
	end

end