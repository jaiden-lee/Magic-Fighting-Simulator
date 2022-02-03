-- this folder will go into replicated storage for both client and server access
local constants = {}

-- these are constant/final values - make call caps
constants.SPELL_BASE_DAMAGES = {
	["SPELL_BOOK_1"] = 100,
	["SPELL_BOOK_2"] = 100,
	["SPELL_BOOK_3"] = 100
}

constants.SPELL_COOLDOWNS = {
	["SPELL_BOOK_1"] = 3,
	["SPELL_BOOK_2"] = 3,
	["SPELL_BOOK_3"] = 3,
}

-- roblox index starts at 1 - so rank 1 corresponds with 1st element
constants.LEVEL_DAMAGE_MULTIPLIERS = {1, 1.5, 2, 2.5, 3}



return constants

-- THIS IS A TEST BRANCH
