-- Variables

local player = script.Parent.Parent.Parent

-- Module Scripts
local dataHandler = require(game.ServerScriptService:WaitForChild("DataHandler"))
local spellBookClass = require(game.ServerScriptService:WaitForChild("SpellBookClass"))
local constants = require(game.ReplicatedStorage:WaitForChild("Constants"))

-- Events
local eventsFolder = script.Parent:WaitForChild("EventsFolder")
local remoteFunctions = eventsFolder.RemoteFunctions
local equipRemoteFunction = remoteFunctions.EquipRemoteFunction
local getInventoryRemoteFunction = remoteFunctions.GetInventoryFunction
local inventoryDeleteAllRemoteFunction = remoteFunctions.DeleteAllFunction

local bindableEvents = eventsFolder.BindableEvents

local remoteEvents = eventsFolder.RemoteEvents


-- Inventory
-- Get Inventory
getInventoryRemoteFunction.OnServerInvoke = function(player)
	return dataHandler.GetSpellBooksOwned(player)
end

wait(1)
--dataHandler.AddSpellBook(player, "Fireball")
--dataHandler.AddSpellBook(player, "Ice Rain")
--dataHandler.AddSpellBook(player, "Water Blast")
--dataHandler.AddSpellBook(player, "Gale Blast")
--dataHandler.AddSpellBook(player, "Rock Smash")
--dataHandler.AddSpellBook(player, "Wood Spikes")

-- Deals w/ Equipping
equipRemoteFunction.OnServerInvoke = function(player, bookName, bookLevel, equip)
	if equip then
		if not dataHandler.CanEquip(player) then
			return
		end
		
		dataHandler.EquipSpellBook(player, bookName, bookLevel)
	else
		dataHandler.UnequipSpellBook(player, bookName, bookLevel)
	end
end

inventoryDeleteAllRemoteFunction.OnServerInvoke = function(player, deleteList)
	for i,v in pairs(deleteList) do
		local spellName = v[2]
		local spellLevel = v[3]
		
		dataHandler.RemoveSpellBook(player, spellName, spellLevel)
	end
end

