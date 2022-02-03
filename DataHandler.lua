local ProfileTemplate = {
  Rank = 1,
  SpellBooksOwned = {},
  SpellBooksEquipped = {},
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
      Profiles[Player] = nil
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
