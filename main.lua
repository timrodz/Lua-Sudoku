-- Graphics
img_grid = nil
font = nil
tileSize = 66
xOffset, yOfsset = 24, 24

-- Math
grid = {}
gridSize = 9
hasFinished = false

function love.load()
	img_grid = love.graphics.newImage('assets/grid.png');
	font = love.graphics.newFont('assets/font.otf', 30)
	InitializeGrid(0)
	Solve()
end

function love.draw()

	love.graphics.setFont(font)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(img_grid, 0, 0)

	love.graphics.setColor(0, 0, 0, 255)

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

	if love.keyboard.isDown('space') then
		-- InitializeGrid(0)
		-- Solve()
	end

end

function InitializeGrid(seed)

	for i = 1, gridSize do

			grid[i] = {}

			for j = 1, gridSize do
				grid[i][j] = 0
			end

		end

	-- Default seed
	if (seed == 0) then

		-- Set the values of the grid
		-- First line
		grid[1][1] = 8
		grid[4][1] = 4
		grid[6][1] = 6
		grid[9][1] = 7

		-- Second line
		grid[7][2] = 4

		-- Third line
		grid[2][3] = 1
		grid[7][3] = 6
		grid[8][3] = 5

		-- Fourth line
		grid[1][4] = 5
		grid[3][4] = 9
		grid[5][4] = 3
		grid[7][4] = 7
		grid[8][4] = 8

		-- Fifth line
		grid[5][5] = 7

		-- Sixth line
		grid[2][6] = 4
		grid[3][6] = 8
		grid[5][6] = 2
		grid[7][6] = 1
		grid[9][6] = 3

		-- Seventh line
		grid[2][7] = 5
		grid[3][7] = 2
		grid[8][7] = 9

		-- Eigth line
		grid[3][8] = 1

		-- Ninth line
		grid[1][9] = 3
		grid[4][9] = 9
		grid[6][9] = 2
		grid[9][9] = 5

	elseif (seed == 1) then

		n = 3

		for i = 1, n*n do

			for j = 1, n*n do

				grid[i][j] = (i * n + i/n + j - 3) % ((n*n) - 1)

			end

		end

	end

end

function Solve()

	local tg = {}

	for i = 1, gridSize do

		tg[i] = {}

		for j = 1, gridSize do

			tg[i][j] = grid[i][j]

		end

	end

	for row = 1, gridSize do

		for col = 1, gridSize do

			-- Try all the numbers
			for i = 1, gridSize do

			-- Check if the grid is empty
				if (grid[i][j] == 0) then

				-- The grid is not empty
				else

				end -- The grid is not empty

			end
			-- break

		end -- j

		-- break
		print("---------------------------------")

		if (hasFinished) then
			break
		end

	end -- i

	PrintSolution(tg, grid)

end

function CheckPlacement(grid, row, col, val)

	return (
		CheckRow(grid, row, val) and
		CheckCol(grid, col, val) and
		CheckBox(grid, row, col, val)
		)

end


function CheckRow(grid, row, val)

	for col = 1, gridSize do

		if (grid[row][col] == val) then

			print("Row #" .. row .. ": duplicate of value " .. val .. " (" .. row .. ", " .. col .. ") found at (" .. row .. ", " .. col .. ")")
			return false

		end

	end

	return true

end

function CheckCol(grid, col, val)

	for row = 1, gridSize do

		if (grid[row][col] == val) then

			print("Col #" .. col .. ": duplicate of value " .. val .. " (" .. row .. ", " .. col .. ") found at (" .. row .. ", " .. col .. ")")
			return false

		end

	end

	return true

end

function CheckBox(grid, row, col, val)

	xCheck = 1
	yCheck = 1

	if (x > 6) then xCheck = 7
	elseif (x > 3) then xCheck = 4
	end

	if (y > 6) then yCheck = 7
	elseif (y > 3) then yCheck = 4
	end

	print("Checking the value " .. val .. " (" .. row .. ", " .. col .. ") at box (" .. xCheck .. ", " .. yCheck .. ")");

	for i = xCheck, xCheck + 2 do

		for j = yCheck, yCheck + 2 do

			-- if (
			-- 	(i ~= x and j ~= y)		-- Not the same space where the value is
			-- 	or (i ~=x and j == y) 	-- Same y but different x
			-- 	or (i == x and j ~= y)) -- Same x but different y
			-- 	then

				if (grid[i][j] == val) then

					print("Box: Found duplicate at (" .. i .. ", " .. j .. ")")
					return false

				end

			-- end

		end
	end

	return true

end

function PrintSolution(src)

	print("Printing solution")

	for i = 1, gridSize do

		for j = 1, gridSize do

			grid[i][j] = src[i][j]

		end

	end

end
