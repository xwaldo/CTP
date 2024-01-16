local EffectWhiteStroke = {}

function EffectWhiteStroke:Set(UIFrame,UIFrame2)
	local Stroke = UIFrame2 or UIFrame
	Stroke = Stroke.UIStroke
	
	local PreviousColor
	
	UIFrame.MouseEnter:Connect(function()
		PreviousColor = Stroke.Color
		Stroke.Color = Color3.new(1, 1, 1)
		
	end)
	UIFrame.MouseLeave:Connect(function()
		if Stroke.Color == Color3.new(1, 1, 1) then
			Stroke.Color = PreviousColor
		end
	end)
	
end

return EffectWhiteStroke