local ColorPalette = {}

local ColorDebounce = true

local Resources



function ColorPalette:Init(_resources)

	Resources = _resources

end



local LastCanvasPosition = nil
local CurrentCanvasPosition = nil

function ColorPalette:Set(ColorWidget,ColorSettingButton,TrackModule,ColorSettingName,ColorSetting)
	local ColorPaletteFrameTemplate = Resources.UI.ColorPalette
	--------------------------
	local ColorPaletteFrame = ColorPaletteFrameTemplate:Clone()

	ColorPaletteFrame.Parent = ColorWidget

	local SelectionFrame = ColorPaletteFrame.Selection

	local current = "RALPalette"

	for _, button in pairs(ColorPaletteFrame.Options:GetChildren()) do
		if button:IsA("TextButton") then
			button.MouseButton1Click:Connect(function()
				if current ~= button.Name then
					button.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.180392)
					ColorPaletteFrame[button.Name].Visible = true

					ColorPaletteFrame.Options[current].BackgroundColor3 = Color3.new(0.231373, 0.231373, 0.231373)
					ColorPaletteFrame[current].Visible = false

					current = button.Name
				end

			end)
		end
	end
	-----------------------------------------------------------------------
	local currentRAL = nil


	for _, RALButton in pairs(ColorPaletteFrame.RALPalette.List:GetChildren()) do
		if RALButton:IsA("TextButton") then
			RALButton.MouseButton1Click:Connect(function ()
				
					RALButton.UIStroke.Color = Color3.new(1, 0.533333, 0)
					ColorSettingButton.Frame.BackgroundColor3 = RALButton.Frame.BackgroundColor3
					TrackModule:SetAttribute(ColorSettingName,RALButton.Frame.BackgroundColor3)
					ColorPaletteFrame.Visible = false
					ColorWidget.Enabled = false
					ColorDebounce = true

					SelectionFrame.Visible = false
					if currentRAL and  RALButton.Name ~= currentRAL then
						ColorPaletteFrame.RALPalette.List[currentRAL].UIStroke.Color = Color3.new(0.141176, 0.141176, 0.141176)
					end
					currentRAL = RALButton.Name
				
			end)
			spawn(function()
				while wait(1) do
					if SelectionFrame.Visible == true then
						RALButton.UIStroke.Color = Color3.new(0.141176, 0.141176, 0.141176)
					end
				end
			end)


		end
	end



	---------------------------------------------------------------------------------------------------------------------
	local function updatePalette(ColorButton)
		ColorButton.Hover.Visible = false
		SelectionFrame.Parent = ColorButton
		SelectionFrame.Visible = true
		ColorPaletteFrame.RobloxPalette.ColorName.ColorName.Text = ColorButton.Name
		ColorSettingButton.Frame.BackgroundColor3 = BrickColor.new(ColorButton.Name).Color
	end
	

	updatePalette(ColorPaletteFrame:FindFirstChild(BrickColor.new(TrackModule:GetAttribute(ColorSettingName)).Name,true))

	
	ColorSettingButton.MouseButton1Click:Connect(function()
		
		if ColorDebounce then
			ColorDebounce = false
			ColorWidget.Enabled = true
			ColorPaletteFrame.Visible = true
			if LastCanvasPosition then
				ColorPaletteFrame.RALPalette.List.CanvasPosition = LastCanvasPosition
			end
			while ColorDebounce == false do
				
				CurrentCanvasPosition = ColorPaletteFrame.RALPalette.List.CanvasPosition
				wait(0.1)
			end
		else
			ColorDebounce = true
			LastCanvasPosition = CurrentCanvasPosition
			ColorWidget.Enabled = false
			ColorPaletteFrame.Visible = false
		end
		
	end)

	for _,ColorLine in pairs(ColorPaletteFrame.RobloxPalette.Palette:GetChildren()) do
		if not ColorLine:IsA("Frame") then continue end

		for _,ColorButton in pairs(ColorLine:GetChildren()) do
			if not ColorButton:IsA("ImageButton") then continue end

			local HoverFrame = ColorButton.Hover
			ColorButton.MouseButton1Click:Connect(function()
				updatePalette(ColorButton)
				LastCanvasPosition = CurrentCanvasPosition
				TrackModule:SetAttribute(ColorSettingName,BrickColor.new(ColorButton.Name).Color)
				ColorPaletteFrame.Visible = false
				ColorWidget.Enabled = false
				ColorDebounce = true
			end)
			ColorButton.MouseEnter:Connect(function()
				HoverFrame.Visible = true
			end)
			ColorButton.MouseLeave:Connect(function()
				HoverFrame.Visible = false
			end)

		end
	end
	------------------------------------------------------------------------------------------------------------------




	ColorWidget:GetPropertyChangedSignal("Enabled"):Connect(function ()
		if ColorWidget.Enabled == false then
			LastCanvasPosition = CurrentCanvasPosition
			ColorPaletteFrame.Visible = false
			ColorDebounce = true
		end
	end)
end


return ColorPalette
