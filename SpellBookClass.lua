-- this is a module script - put into serverscriptservice
local SpellBook = {}
SpellBook.__index = SpellBook
SpellBook.__mode = "kv"


-- constructor - we are really only using a class for data storage reasons
function SpellBook.new (spellName)
	local newBook = {
		Name = spellName,
		Level = 1,
		Equipped = false
	}

	setmetatable(newBook, SpellBook)

	return newBook
end

-- functions: none for now
return SpellBook
