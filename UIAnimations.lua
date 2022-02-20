local anim = {}

function anim.ChangeSizeAnimation (UIElement, endSizeX, endSizeY, length)
	UIElement:TweenSize(UDim2.new(endSizeX, 0, endSizeY, 0), "Out", "Linear", length, true)
end

function anim.ChangePositionAnimation (UIElement, endPositionX, endPositionY, length, easingStyle)
	UIElement:TweenPosition(UDim2.new(endPositionX, 0, endPositionY, 0), "Out", easingStyle, length, true)
end

function anim.ChangeTextWithOutline (UIElement, text)
	UIElement.Text = text
	for i,v in pairs(UIElement:GetChildren()) do
		if v.Name == "ui-stroke" then
			v.Text = text
		end
	end
end

return anim
