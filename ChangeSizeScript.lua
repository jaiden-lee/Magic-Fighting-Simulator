local grid = script.Parent.UIGridLayout
local itemsPerRow = 5

local function changeCanvas ()
	local abSize = script.Parent.AbsoluteSize.X
	local cellSize = abSize/itemsPerRow
	script.Parent.CanvasSize = UDim2.new(0, grid.AbsoluteContentSize.X, 0, grid.AbsoluteContentSize.Y+cellSize)
	grid.CellSize = UDim2.new(0, cellSize - .05*abSize, 0, cellSize-.05*abSize)
	grid.CellPadding = UDim2.new(0, abSize / 505 * 15, 0, abSize / 250 * 15)
end

script.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	changeCanvas()
end)
grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	changeCanvas()
end)

changeCanvas()

script.Parent.ChildAdded:Connect(changeCanvas)
