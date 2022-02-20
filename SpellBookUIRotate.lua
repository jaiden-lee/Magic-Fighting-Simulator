local spellBooks = game.ReplicatedStorage.SpellBooks
local bookImage = script.Parent.BookImage

local cam = Instance.new("Camera", bookImage)
local book = spellBooks[script.Parent.Name]:Clone()

book.Parent = bookImage

local cf = book:GetPrimaryPartCFrame()
cam.CFrame = cf*CFrame.Angles(0, -math.pi/2, 0)*CFrame.new(0,0,2)

bookImage.CurrentCamera = cam
