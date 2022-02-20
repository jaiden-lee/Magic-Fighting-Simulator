-- Variables
local inventory = script.Parent.Parent.Parent
local selectFrame = inventory.Parent.InventorySelectPopup
local UIGrid = script.Parent.Parent.UIGridLayout

local hoverSound = inventory.Parent.Parent.HoverSound
local buttonDownSound = inventory.Parent.Parent.ButtonDownSound
local buttonUpSound = inventory.Parent.Parent.ButtonUpSound

local hoverOutline = script.Parent.HoverOutline

local deleteIcon = script.Parent.DeleteIcon

local currentBookSelected = inventory.Values.CurrentBookSelected
local onCooldown = inventory.Values.OnCooldown
local deleteMode = inventory.Values.DeleteMode


local UIS = game:GetService("UserInputService")

local values = script.Parent.Values
local DPS = values.DPS
local level = values.Level
local rarity = values.Rarity

local equippedIcon = script.Parent.EquippedIcon
local eventsFolder = script.Parent.Parent.Parent.Parent.Parent.EventsFolder
local bindableEvents = eventsFolder.BindableEvents
local equipBindableEvent = bindableEvents.EquipBindableEvent
local addDeleteEvent = bindableEvents.AddToDeleteEvent

-- Functions

-- used for when you hover over the button - it will bring up the descriptive frame
local function selectFramePopup ()
	selectFrame.Rarity.Text = rarity.Value
	selectFrame.Level.Text = "Level "..level.Value
	selectFrame.SpellName.Text = script.Parent.Name
	
	selectFrame.Visible = true
	local offset = UIGrid.CellSize.X.Offset/2
	local pos = UDim2.new(0, script.Parent.AbsolutePosition.X+offset, 0, script.Parent.AbsolutePosition.Y+offset)
	selectFrame.Position = pos
	
end

local function selectFrameHide()
	selectFrame.Visible = false
end

local function hoverEnter()
	hoverSound:Play()
	hoverOutline.Visible = true	
	selectFramePopup()
end

local function hoverExit ()
	hoverOutline.Visible = false
	selectFrameHide()	
end

local function mouseDown ()
	buttonDownSound:Play()
end

local function mouseUp ()
	buttonUpSound:Play()
end

-- This deals w/ equipping or unequipping
local function mouseClick ()
	if onCooldown.Value == false then
		onCooldown.Value = true
		
		if deleteMode.Value == false then
			equipBindableEvent:Fire(script.Parent.Name, values.Level.Value, not equippedIcon.Visible)
		else
			if equippedIcon.Visible == false then
				deleteIcon.Visible = not deleteIcon.Visible
			
				addDeleteEvent:Fire(script.Parent, script.Parent.Name, level.Value, deleteIcon.Visible)
			else
				task.wait(.1)
				onCooldown.Value = false
			end
		end
		
	end
end

-- Connecting the events
script.Parent.MouseEnter:Connect(hoverEnter)
script.Parent.MouseLeave:Connect(hoverExit)
script.Parent.MouseButton1Down:Connect(mouseDown)
script.Parent.MouseButton1Up:Connect(mouseUp)
script.Parent.MouseButton1Click:Connect(mouseClick)
