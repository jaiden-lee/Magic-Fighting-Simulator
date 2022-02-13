local plr = game.Players.LocalPlayer
local UIAnimations = require(game.ReplicatedStorage:WaitForChild("UIAnimations"))
local main = script.Parent:WaitForChild("Main")
local leftButtons = main:WaitForChild("Left")
local bottomButtons = main:WaitForChild("Bottom")
local UIS = game:GetService("UserInputService")


-- Left Buttons


local robuxShopButton = leftButtons.RobuxShop
local settingsButton = leftButtons.Settings
local teleportButton = leftButtons.Teleport

-- Bottom Buttons
local inventoryButton = bottomButtons.Inventory
local achievementsButton = bottomButtons.Achievements
local relicsButton = bottomButtons.Relics
local indexButton = bottomButtons.Index
local tradeButton = bottomButtons.Trade


-- UI Animations --> format = {default X, default Y, enterX, enterY, length, clickX, clickY}
local animationList = {
	["robuxShopButton"] = {.5, .27, .6, .27, .05, .45,.27},
	["settingsButton"] = {.5, .27, .6, .27, .05, .45, .27},
	["teleportButton"] = {.5, .27, .6, .27, .05, .45, .27},
	["inventoryButton"] = {.18, 1.1, .195, 1.2, .05, .14, 1},
	["achievementsButton"] = {.15, 1, .165, 1.1, .05, .13, .9},
	["relicsButton"] = {.15, 1, .165, 1.1, .05, .13, .9},
	["indexButton"] = {.15, 1, .165, 1.1, .05, .13, .9},
	["tradeButton"] = {.15, 1, .165, 1.1, .05, .13, .9}
}
local buttons = {
	["robuxShopButton"] = robuxShopButton,
	["settingsButton"] = settingsButton,
	["teleportButton"] = teleportButton,
	["inventoryButton"] = inventoryButton,
	["achievementsButton"] = achievementsButton,
	["relicsButton"] = relicsButton,
	["indexButton"] = indexButton,
	["tradeButton"] = tradeButton
}
local hoverSound = script.Parent.HoverSound
local buttonDownSound = script.Parent.ButtonDownSound
local buttonUpSound = script.Parent.ButtonUpSound


for UIElement, properties in pairs(animationList) do
	if UIS.MouseEnabled then
		buttons[UIElement].MouseEnter:Connect(function()
			hoverSound:Play()
			UIAnimations.ChangeSizeAnimation(buttons[UIElement], properties[3], properties[4], properties[5])
			buttons[UIElement].Title.Visible = true	
		end)
		
	end
	buttons[UIElement].MouseLeave:Connect(function()
		UIAnimations.ChangeSizeAnimation(buttons[UIElement], properties[1], properties[2], properties[5])
		buttons[UIElement].Title.Visible = false
	end)
	buttons[UIElement].MouseButton1Down:Connect(function()
		UIAnimations.ChangeSizeAnimation(buttons[UIElement], properties[6], properties[7], properties[5])
		buttonDownSound:Play()	
	end)
	buttons[UIElement].MouseButton1Up:Connect(function()
		UIAnimations.ChangeSizeAnimation(buttons[UIElement], properties[1], properties[2], properties[5])
		buttonUpSound:Play()	
	end)
end

-- Click Buttons
local bottomBarOpened = false
local currentBottomSelected = "None"

local function openBottomButtons ()
	bottomBarOpened = true
	
	achievementsButton.Size = UDim2.new(animationList["achievementsButton"][6], 0, animationList["achievementsButton"][7], 0)
	relicsButton.Size = UDim2.new(animationList["relicsButton"][6], 0, animationList["relicsButton"][7], 0)
	indexButton.Size = UDim2.new(animationList["indexButton"][6], 0, animationList["indexButton"][7], 0)
	tradeButton.Size = UDim2.new(animationList["tradeButton"][6], 0, animationList["tradeButton"][7], 0)

	achievementsButton.Visible = true
	relicsButton.Visible = true
	indexButton.Visible = true
	tradeButton.Visible = true

	UIAnimations.ChangeSizeAnimation(achievementsButton, animationList["achievementsButton"][1], animationList["achievementsButton"][2], .075)
	UIAnimations.ChangeSizeAnimation(relicsButton, animationList["relicsButton"][1], animationList["relicsButton"][2], .075)
	UIAnimations.ChangeSizeAnimation(indexButton, animationList["indexButton"][1], animationList["indexButton"][2], .075)
	UIAnimations.ChangeSizeAnimation(tradeButton, animationList["tradeButton"][1], animationList["tradeButton"][2], .075)

end

local function closeBottomButtons ()
	currentBottomSelected = "None"
	bottomBarOpened = false
	
	achievementsButton.Visible = false
	relicsButton.Visible = false
	indexButton.Visible = false
	tradeButton.Visible = false
	
	
	achievementsButton.Size = UDim2.new(animationList["achievementsButton"][6], 0, animationList["achievementsButton"][7], 0)
	relicsButton.Size = UDim2.new(animationList["relicsButton"][6], 0, animationList["relicsButton"][7], 0)
	indexButton.Size = UDim2.new(animationList["indexButton"][6], 0, animationList["indexButton"][7], 0)
	tradeButton.Size = UDim2.new(animationList["tradeButton"][6], 0, animationList["tradeButton"][7], 0)


end

inventoryButton.MouseButton1Click:Connect(function()
	if bottomBarOpened == false then
		currentBottomSelected = "Inventory"
		openBottomButtons()
	else 
		if currentBottomSelected == "Inventory" then
			closeBottomButtons()
			return
		end
	end
end)
