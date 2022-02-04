local DataHandler = {}

local SpellBook = require(game.ServerScriptService.SpellBookClass)


local ProfileTemplate = {
	Rank = 1,
	SpellBooksOwned = {},
	SpellBooksEquipped = 0, -- this is a count; equipped will be at front of the table
	HoursPlayed = 0,
	Souls = 0,
	Crystals = 0,
	LastTimeLoggedIn = 0 -- daily reward system
}

local ProfileService = require(game.ServerScriptService.ProfileService)

local Players = game.Players

-- this is the equivalent of GetDataStore - basically, "PlayerData" here is the current datastore key - if we changed the name, everyones data would be reset
local ProfileStore = ProfileService.GetProfileStore(
	"PlayerData",
	ProfileTemplate
)

local Profiles = {}

local function PlayerAdded (player)
	local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId, "ForceLoad")
	if profile ~= nil then -- this will return nil if another server is has the data loaded at same time - basically it is session locked; we should kick player so no data issues
		profile:AddUserId(player.UserId) -- idk why we need this, apparently for some European Law w/ data tracking
		profile:Reconcile() -- fills in missing variables from ProfileTemplate if missing in current profile

		profile:ListenToRelease(function() -- this tracks when the profile is "released" - ex: it is getting force loaded from another server
			Profiles[player] = nil
			-- if player still in game, then kick basically
			player:Kick()
		end)

		if player:IsDescendantOf(Players) then -- makes sure that the player is still in game
			Profiles[player] = profile
		else
			profile:Release() -- this means got accidentally loaded in wrong server, so release it - or else can't be loaded into another server due to session-locking
		end
	else
		player:Kick()
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	-- this is used just in case players joined the server before the player added part below - meaning their data wasn't loaded
	task.spawn(PlayerAdded, player) -- basically just running this asynchronously; no need for Promise bc we are not decision making or error handling
	-- just want this to run asynchronously so that the player added event below can run
end

game.PlayersAdded:Connect(PlayerAdded) -- the player argument automatically passed into here

Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:Release() -- need to do this for session locking
		print(player.Name.."'s Profile has been released")
	end
end) 

-- Updating Player Data Functions


-- Get Methods
function DataHandler.GetSouls (player)
	local profile = Profiles[player]
	if profile then
		return profile.Souls
	end
	return nil
end

function DataHandler.GetRank (player)
	local profile = Profiles[player]
	if profile then
		return profile.Rank
	end
	return nil
end

function DataHandler.GetSpellBooksOwned (player)
	local profile = Profiles[player]
	if profile then
		return profile.SpellBooksOwned
	end
	return nil
end

function DataHandler.GetSpellBooksEquipped (player)
	local profile = Profiles[player]
	if profile then
		return profile.SpellBooksEquipped
	end
	return nil
end

function DataHandler.GetHoursPlayed (player)
	local profile = Profiles[player]
	if profile then
		return profile.HoursPlayed
	end
	return nil
end

function DataHandler.GetCrystals (player)
	local profile = Profiles[player]
	if profile then
		return profile.Crystals
	end
	return nil
end

function DataHandler.GetLastTimeLoggedIn (player)
	local profile = Profiles[player]
	if profile then
		return profile.LastTimeLoggedIn
	end
	return nil
end

-- Set Methods
function DataHandler.UpdateSouls (player, amount)
	local profile = Profiles[player]
	if profile then
		profile.Souls += amount -- this will change w/ multiplier later
	end
end

function DataHandler.UpdateCrystals (player, amount)
	local profile = Profiles[player]
	if profile then
		profile.Crystals += amount -- this will change w/ multiplier later
	end
end

function DataHandler.SetLastTimePlayed (player)
	local profile = Profiles[player]
	if profile then
		profile.LastTimeLoggedIn = os.time()
	end
end

function DataHandler.AddSpellBook (player, bookName)
	local spellBook = SpellBook.new(bookName)
	local profile = Profiles[player]
	if profile then
		table.insert(profile.SpellBooksOwned, spellBook)
	end
end



return DataHandler
