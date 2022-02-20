local combat = {}

local constants = require(game.ReplicatedStorage.Constants)

function combat.CalculateDamage (spellName, spellLevel)
	local damage = constants.SPELL_BASE_DAMAGES[spellName]
	return damage
end

function combat.CalculateDPS (spellName, spellLevel)
	local damage = combat.CalculateDamage(spellName, spellLevel)
	local cooldown = constants.SPELL_COOLDOWNS[spellName]
	local DPS = damage/cooldown
	return math.floor(DPS)
end

local suffixes = {"K", "M", "B", "T", "Qa"}
function combat.Abbreviate (value)
	value = tonumber(value)
	local newValue = math.abs(value)

	if newValue<1000 then
		local str = value
		str = math.floor(value*100)/100
		return str
	end
	local str = value
	for i=1,#suffixes,1 do
		if newValue < 10^ (i*3) then
			str = math.floor(value/ ((10 ^ ((i-1)*3))/100 ))/100 .. suffixes[i-1]
			break
		end
	end
	return str
end

return combat
