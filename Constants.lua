-- this folder will go into replicated storage for both client and server access
local constants = {}

-- these are constant/final values - make call caps
constants.SPELL_BASE_DAMAGES = {
	-- Area 1
	["Fireball"] = 100,
	["Water Blast"] = 100,
	["Rock Smash"] = 100,
	["Gale Blast"] = 200,
	["Wood Spikes"] = 200,
	["Ice Rain"] = 500
}

constants.SPELL_COOLDOWNS = {
	-- Area 1
	["Fireball"] = 3,
	["Water Blast"] = 3,
	["Rock Smash"] = 3,
	["Gale Blast"] = 3,
	["Wood Spikes"] = 3,
	["Ice Rain"] = 3
}

-- roblox index starts at 1 - so rank 1 corresponds with 1st element
constants.LEVEL_DAMAGE_MULTIPLIERS = {1, 1.5, 2, 2.5, 3}

constants.BASE_SPELLS_EQUIPPED = 4


return constants
