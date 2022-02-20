local plr = game.Players.LocalPlayer
local UIAnimations = require(game.ReplicatedStorage:WaitForChild("UIAnimations"))
local main = script.Parent:WaitForChild("Main")
local leftButtons = main:WaitForChild("Left")
local bottomButtons = main:WaitForChild("Bottom")
local rightUI = main:WaitForChild("Right")
local UIS = game:GetService("UserInputService")
local menus = script.Parent:WaitForChild("Menus")
local UITemplates = game.ReplicatedStorage:WaitForChild("UITemplates")
local spellBookTemplate = UITemplates.SpellBookTemplate
local localCombatScript = require(game.ReplicatedStorage:WaitForChild("LocalCombatScript"))

-- Menus
local inventory = menus.Inventory

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

-- Right UI
local soulsBar = rightUI.Souls
local levelBar = rightUI.LevelBar
local runesBar = rightUI.Runes

local soulsAddButton = soulsBar.AddButton
local runesAddButton = runesBar.AddButton

-- Inventory
local closeInventoryButton = inventory.Close
local bottomInventoryBar = inventory.Bottom
local inventoryDeleteButton = bottomInventoryBar.Delete
local inventoryEquipBestButton = bottomInventoryBar.EquipBest
local inventoryUnequipAllButton = bottomInventoryBar.UnequipAll
local inventorySearchBox = bottomInventoryBar.SearchBox
local inventoryHolder = inventory.Holder
local inventoryDeleteAllButton = bottomInventoryBar.DeleteAllButton
local inventoryCancelDeleteMode = bottomInventoryBar.CancelDeleteMode

local inventoryDeleteList = {}


-- Events
local eventsFolder = script.Parent:WaitForChild("EventsFolder")

local bindableEvents = eventsFolder.BindableEvents
local equipBindableEvent = bindableEvents.EquipBindableEvent
local addToDeleteEvent = bindableEvents.AddToDeleteEvent

local remoteFunctions = eventsFolder.RemoteFunctions
local equipRemoteFunction = remoteFunctions.EquipRemoteFunction
local getInventoryRemoteFunction = remoteFunctions.GetInventoryFunction
local inventoryDeleteAllRemoteFunction = remoteFunctions.DeleteAllFunction


-- Inventory Values
local inventoryValues = inventory.Values
local onInventoryCooldown = inventoryValues.OnCooldown
local inventoryDeleteMode = inventoryValues.DeleteMode


-- UI Animations --> format = {default X, default Y, enterX, enterY, length, clickX, clickY}
local animationList = {
	["robuxShopButton"] = {.5, .27, .6, .27, .05, .45,.27},
	["settingsButton"] = {.5, .27, .6, .27, .05, .45, .27},
	["teleportButton"] = {.5, .27, .6, .27, .05, .45, .27},
	["inventoryButton"] = {.18, 1.1, .195, 1.2, .05, .14, 1},
	["achievementsButton"] = {.15, 1, .165, 1.1, .05, .13, .9},
	["relicsButton"] = {.15, 1, .165, 1.1, .05, .13, .9},
	["indexButton"] = {.15, 1, .165, 1.1, .05, .13, .9},
	["tradeButton"] = {.15, 1, .165, 1.1, .05, .13, .9},
	["soulsAddButton"] = {.17,.75, .2, .8, .05, .15, .7},
	["runesAddButton"] = {.17,.75, .2, .8, .05, .15, .7},
	["closeInventoryButton"] = {.15, .15, .17, .17, .05, .13, .13},
	["inventoryDeleteButton"] = {.17, .9, .2, 1, .05, .15, .85},
	["inventoryEquipBestButton"] = {.17, .6, .18, .7, .05, .15, .55},
	["inventoryUnequipAllButton"] = {.17, .6, .18, .7, .05, .15, .55},
	["inventoryDeleteAllButton"] = {.17, .6, .18, .7, .05, .15, .55},
	["inventoryCancelDeleteMode"] = {.17, .6, .18, .7, .05, .15, .55}
}
local buttons = {
	["robuxShopButton"] = robuxShopButton,
	["settingsButton"] = settingsButton,
	["teleportButton"] = teleportButton,
	["inventoryButton"] = inventoryButton,
	["achievementsButton"] = achievementsButton,
	["relicsButton"] = relicsButton,
	["indexButton"] = indexButton,
	["tradeButton"] = tradeButton,
	["soulsAddButton"] = soulsAddButton,
	["runesAddButton"] = runesAddButton,
	["closeInventoryButton"] = closeInventoryButton,
	["inventoryDeleteButton"] = inventoryDeleteButton,
	["inventoryEquipBestButton"] = inventoryEquipBestButton,
	["inventoryUnequipAllButton"] = inventoryUnequipAllButton,
	["inventoryDeleteAllButton"] = inventoryDeleteAllButton,
	["inventoryCancelDeleteMode"] = inventoryCancelDeleteMode
}
local hoverSound = script.Parent.HoverSound
local buttonDownSound = script.Parent.ButtonDownSound
local buttonUpSound = script.Parent.ButtonUpSound


for UIElement, properties in pairs(animationList) do
	if UIS.MouseEnabled then
		buttons[UIElement].MouseEnter:Connect(function()
			hoverSound:Play()
			UIAnimations.ChangeSizeAnimation(buttons[UIElement], properties[3], properties[4], properties[5])
			if buttons[UIElement]:FindFirstChild("Title") then
				buttons[UIElement].Title.Visible = true	
			end
		end)
		
	end
	buttons[UIElement].MouseLeave:Connect(function()
		UIAnimations.ChangeSizeAnimation(buttons[UIElement], properties[1], properties[2], properties[5])
		if buttons[UIElement]:FindFirstChild("Title") then
			buttons[UIElement].Title.Visible = false
		end
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

local function cancelInventoryDeleteMode()
	inventoryDeleteMode.Value = false

	inventoryEquipBestButton.Visible = true
	inventoryUnequipAllButton.Visible = true
	inventoryDeleteAllButton.Visible = false
	inventoryCancelDeleteMode.Visible = false
	table.clear(inventoryDeleteList)
	for i,v in pairs(inventoryHolder:GetChildren()) do
		local deleteIcon = v:FindFirstChild("DeleteIcon")
		if deleteIcon then
			deleteIcon.Visible = false
		end
	end
end

local function openInventory ()
	inventory.Visible = true
	UIAnimations.ChangeSizeAnimation(inventory, .5, .65, .075)
	UIAnimations.ChangePositionAnimation(inventory, .5, .4, .125, "Linear")
end

local function closeInventory ()
	inventory.Visible = false
	inventory.Position = UDim2.new(.5, 0, .45, 0)
	inventory.Size = UDim2.new(.4, 0, .55, 0)
	cancelInventoryDeleteMode()
end

inventoryButton.MouseButton1Click:Connect(function()
	if bottomBarOpened == false then
		currentBottomSelected = "Inventory"
		openBottomButtons()
		openInventory()
	else 
		if currentBottomSelected == "Inventory" then
			closeBottomButtons()
			closeInventory()
			return
		end
	end
end)

closeInventoryButton.MouseButton1Click:Connect(function()
	closeBottomButtons()
	closeInventory()
end)



-- Inventory
wait(1.5)

-- responsible for creating the individual books - works in conjunction w/ loadInventory()
local function createNewSpellBook (book)
	local bookTemplate = spellBookTemplate:Clone()
	bookTemplate.Name = book.Name
	local damage = localCombatScript.CalculateDPS(book.Name, book.Level)
	UIAnimations.ChangeTextWithOutline(bookTemplate.DamageText, localCombatScript.Abbreviate(damage))

	if book.Equipped == true then
		bookTemplate.EquippedIcon.Visible = true
	else
		bookTemplate.EquippedIcon.Visible = false
	end

	bookTemplate.LayoutOrder = -damage

	bookTemplate.Values.Level.Value = book.Level
	bookTemplate.Values.DPS.Value = damage

	bookTemplate.Parent = inventoryHolder
	
end

-- loads the entire inventory
local function loadInventory ()
	local booksOwned = getInventoryRemoteFunction:InvokeServer()
	for i,v in pairs(booksOwned) do
		createNewSpellBook(v)
	end
end

loadInventory()


-- responsible for reordering all the spellbooks in descending order with equipped ones first
-- not the most efficient, but whatever
local function refreshLayoutOrders ()
	local booksOwned = getInventoryRemoteFunction:InvokeServer()
	local inventoryChildren = inventoryHolder:GetChildren()
	
	local i = 1
	while (i < #inventoryChildren) do
		if not inventoryChildren[i]:IsA("TextButton") then
			table.remove(inventoryChildren, i)
		else
			i+=1
		end
	end
	
	for i,v in pairs(booksOwned) do
		if v.Equipped then
			for j, x in pairs(inventoryChildren) do
				if x.Name == v.Name and x.Values.Level.Value == v.Level then
					table.remove(inventoryChildren, j)
					x.EquippedIcon.Visible = true
					x.LayoutOrder = -x.Values.DPS.Value
					break
				end
			end
		end
	end
	local maxDamage = 0
	for i,v in pairs(inventoryChildren) do
		if v:IsA("TextButton") then
			local dmg = v.Values.DPS.Value
			if maxDamage < dmg then
				maxDamage = dmg
			end
		end
	end
	for i,v in pairs(inventoryChildren) do
		if v:IsA("TextButton") then
			v.LayoutOrder = maxDamage - v.Values.DPS.Value
			v.EquippedIcon.Visible = false
		end
	end
	
	cancelInventoryDeleteMode()
end

equipBindableEvent.Event:Connect(function(bookName, bookLevel, equip)
	equipRemoteFunction:InvokeServer(bookName, bookLevel, equip)
	refreshLayoutOrders()
	onInventoryCooldown.Value = false
end)


-- toggles the delete mode
inventoryDeleteButton.MouseButton1Click:Connect(function()
	if onInventoryCooldown.Value == false then
		onInventoryCooldown.Value = true
		
		if inventoryDeleteMode.Value == false then
			inventoryDeleteMode.Value = true
			
			inventoryEquipBestButton.Visible = false
			inventoryUnequipAllButton.Visible = false
			inventoryDeleteAllButton.Visible = true
			inventoryCancelDeleteMode.Visible = true
			
			
		else
			cancelInventoryDeleteMode()
		end
		
		task.wait(.1)
		onInventoryCooldown.Value = false
	end	
end)


-- also toggles the delete mode
inventoryCancelDeleteMode.MouseButton1Click:Connect(function()
	if onInventoryCooldown.Value == false then
		onInventoryCooldown.Value = true
		cancelInventoryDeleteMode()
		
		task.wait(.1)
		onInventoryCooldown.Value  = false
	end
end)


-- adds or removes books from the deletion queue
addToDeleteEvent.Event:Connect(function(spellMemoryLocation, spellName, spellLevel, isAdding)
	
	if isAdding then
		table.insert(inventoryDeleteList, {spellMemoryLocation, spellName, spellLevel})
	else
		for i,v in pairs(inventoryDeleteList) do
			if v[1] == spellMemoryLocation then
				table.remove(inventoryDeleteList, i)
			end
		end
	end
	onInventoryCooldown.Value = false
end)


-- Handles the actual deleting part
inventoryDeleteAllButton.MouseButton1Click:Connect(function()
	if onInventoryCooldown.Value == false then
		onInventoryCooldown.Value = true
		
		inventoryDeleteAllRemoteFunction:InvokeServer(inventoryDeleteList)
		
		for i,v in pairs(inventoryDeleteList) do
			v[1]:Destroy()
		end
		
		table.clear(inventoryDeleteList)
		
		refreshLayoutOrders()
		
		task.wait(.1)
		onInventoryCooldown.Value = true
	end
end)

local function updateInventoryToSearch()
	for i,v in pairs(inventoryHolder:GetChildren()) do
		if v:IsA("TextButton") then
			if string.find(string.lower(v.Name), string.lower(inventorySearchBox.Text)) then
				v.Visible = true
			else
				v.Visible = false
			end
		end
	end
end

inventorySearchBox:GetPropertyChangedSignal("Text"):Connect(updateInventoryToSearch)
