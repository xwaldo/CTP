--XWALDO1--

--CONFIGURES TRACK CONVERTER UIs

local TweenService = game:GetService("TweenService")

local TrackManager = {}

local Tracks = script.Parent.Tracks

local plugin

function TrackManager:Set(CoasterToolPack,Track, TrackUI,TrackName,TrackBuilder,Widget)
	plugin = CoasterToolPack.PluginManager:Plugin()
	
	local TrackModule = Tracks[TrackName]
	local EffectWhiteStroke = require(CoasterToolPack.Resources.Util.EffectWhiteStroke)
	local Toggle = require(CoasterToolPack.Resources.Util.Toggle)
	local ToggleOptions = require(CoasterToolPack.Resources.Util.ToggleOptions)
	
	--SET TITLE AND IMAGE
	local Header = TrackUI:FindFirstChild("Header",true)
	Header.Title.Text = Track.Name
	Header.PreviewImage.Image = Track.Image
	Header.Frame.BackgroundColor3 = Track.Color or Color3.new(0, 0.517647, 1)

	---------------------------------------------------------------------------------
	local OptionsTemplate = TrackUI.ToolList.OptionsTemplate
	OptionsTemplate.Visible = false

	--SET STYLE OPTIONS
	local StylesList = OptionsTemplate:Clone()
	StylesList.DisplayText.Text = "Styles"
	StylesList.Name = "Styles"
	StylesList.LayoutOrder = 1
	StylesList.Parent = OptionsTemplate.Parent
	StylesList.Visible = len(Track.Content)>1 

	--SET STYLE BUTTONS
	local StyleButtonTemplate = StylesList:FindFirstChild("OptionTemplate",true)
	StyleButtonTemplate.Visible = false

	local StyleButtons = {}

	for name, style in pairs(Track.Content) do
		local StyleButton = StyleButtonTemplate:Clone()
		StyleButton.Name = name
		StyleButton.Text = name
		StyleButton.LayoutOrder = style.LayoutOrder or 100
		StyleButton.Visible = true
		StyleButton.Parent = StyleButtonTemplate.Parent
		StyleButtons[name] = StyleButton
		EffectWhiteStroke:Set(StyleButton)
		
	end

	------------------------------------------------------------------------------
	--SET TYPE OPTIONS

	local TypesList = OptionsTemplate:Clone()
	TypesList.Name = "Types"
	TypesList.DisplayText.Text = "Types"
	TypesList.LayoutOrder = 2
	TypesList.Parent = OptionsTemplate.Parent
	TypesList.Visible = true


	local TypeButtonTemplate = TypesList:FindFirstChild("OptionTemplate",true)
	TypeButtonTemplate.Visible = false

	--SET TYPE BUTTONS

	local TypeButtons = {}

	for name, style in pairs(Track.Content) do
		for _name, _type in pairs(style) do
			if _name ~= "LayoutOrder" then
				if not TypeButtons[_name] then

					local TypeButton = TypeButtonTemplate:Clone()
					TypeButton.Name = _name
					TypeButton.Text = _name
					TypeButton.LayoutOrder = _type.LayoutOrder or 100
					TypeButton.Visible = true
					TypeButton.Parent = TypeButtonTemplate.Parent
					TypeButtons[_name] = TypeButton
					EffectWhiteStroke:Set(TypeButton)
				end
			end
		end
	end
	TypesList.Visible = len(TypeButtons)>1 
	------------------------------------------------------------------------------
	--SET SPECIAL OPTIONS

	local SpecialList = OptionsTemplate:Clone()
	SpecialList.Name = "Special"
	SpecialList.DisplayText.Text = "Special Types"
	SpecialList.LayoutOrder = 3
	SpecialList.Parent = OptionsTemplate.Parent
	SpecialList.Visible = true


	local SpecialButtonTemplate = SpecialList:FindFirstChild("OptionTemplate",true)
	SpecialButtonTemplate.Visible = false
	
	--SET SPECIAL BUTTONS

	local SpecialButtons = {}


	
	for name, SpecialType in pairs(Track.SpecialTypes) do
		local SpecialButton = SpecialButtonTemplate:Clone()
		SpecialButton.Name = name
		SpecialButton.Text = name
		SpecialButton.LayoutOrder = SpecialType
		SpecialButton.Visible = true
		SpecialButton.Parent = SpecialButtonTemplate.Parent
		SpecialButtons[name] = SpecialButton
		EffectWhiteStroke:Set(SpecialButton)
	end
	
	
	
	--------------------------------------------------------------------------------
	--SWAP BETWEEN OPTIONS

	local function SwapsStyle(StyleButton)
		local PreviousStyle = TrackModule:GetAttribute("Style")
		local CurrentStyle = StyleButton.Name
		TrackModule:SetAttribute("Style",CurrentStyle)

		--SET SELECTED TO STYLE
		StyleButtons[PreviousStyle].UIStroke.Color = Color3.new(0.141176, 0.141176, 0.141176)
		StyleButton.UIStroke.Color = Color3.new(0, 0.666667, 1)
		
		

		for _,TypeButton in pairs(TypeButtons) do
			TypeButton.Visible = false
		end

		for TypeName,Type in pairs(Track.Content[StyleButton.Name]) do
			if TypeName ~= "LayoutOrder" then
				TypeButtons[TypeName].Visible = true
			end
		end
		
		local PreviousType = TrackModule:GetAttribute("Type")
		
		if TypeButtons[PreviousType].Visible == false then
			local TypeButton = nil
			
			if Track.DefaultType then
				TypeButton = TypeButtons[Track.DefaultType]
			end
			
			for _,button in pairs(TypeButtons) do
				if button.Visible == true and TypeButton == nil then
					TypeButton = button
					break
				end
			end
			
			TrackModule:SetAttribute("Type",TypeButton.Name)
			
			--SET SELECTED TO STYLE
			TypeButtons[PreviousType].UIStroke.Color = Color3.new(0.141176, 0.141176, 0.141176)
			TypeButton.UIStroke.Color = Color3.new(0, 0.666667, 1)
		end
		
		

	end

	SwapsStyle(StyleButtons[ TrackModule:GetAttribute("Style")])

	for _, StyleButton in pairs(StyleButtons) do
		StyleButton.MouseButton1Click:Connect(function()
			SwapsStyle(StyleButton)
		end)
	end
	
	--------------------------------------------------------------------------------
	
	local function SwapsTypes(TypeButton)
		local PreviousType = TrackModule:GetAttribute("Type")
		local CurrentType = TypeButton.Name
		TrackModule:SetAttribute("Type",CurrentType)

		--SET SELECTED TO STYLE
		TypeButtons[PreviousType].UIStroke.Color = Color3.new(0.141176, 0.141176, 0.141176)
		TypeButton.UIStroke.Color = Color3.new(0, 0.666667, 1)

	end

	SwapsTypes(TypeButtons[TrackModule:GetAttribute("Type")])

	for _, TypeButton in pairs(TypeButtons) do
		TypeButton.MouseButton1Click:Connect(function()
			SwapsTypes(TypeButton)
		end)
	end
	
	---------------------------------------------------------------------------------
	
	local function SwapSpecial(SpecialButton)
		local PreviousSpecial = TrackModule:GetAttribute("Special")
		local CurrentSpecial = SpecialButton.Name
		TrackModule:SetAttribute("Special",CurrentSpecial)

		--SET SELECTED TO STYLE
		SpecialButtons[PreviousSpecial].UIStroke.Color = Color3.new(0.141176, 0.141176, 0.141176)
		SpecialButton.UIStroke.Color = Color3.new(0, 0.666667, 1)

	end

	SwapSpecial(SpecialButtons[TrackModule:GetAttribute("Special")])

	for _, SpecialButton in pairs(SpecialButtons) do
		SpecialButton.MouseButton1Click:Connect(function()
			SwapSpecial(SpecialButton)
		end)
	end

	-------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	--CREATE COLORS AND OPTIONS
	
	local TrackAttributes = TrackModule:GetAttributes()
	local ColorPalette = require(script.ColorPalette)
	


	ColorPalette:Init(CoasterToolPack.Resources)
	
	local ColorWidget = plugin:CreateDockWidgetPluginGui(
		"ColorPalette"..TrackModule.Name,
		DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Left,false,true, 390, 470,390, 470
		)
	)
	ColorWidget.Name = "CoasterToolPackColorPalette"..TrackModule.Name

	
	
	for settingName,setting in pairs(TrackAttributes) do
		local settingType = typeof(setting)
		
		local SettingsUI = TrackUI:FindFirstChild("Settings",true)
		
		if settingType == "boolean" and settingName ~= "Active" and settingName ~= "SupportActive" and settingName ~= "CrossbeamDirection" then
			local ToggleTemplate = SettingsUI.List.ConvertOptions.List.ToggleTemplate
			ToggleTemplate.Visible = false
			
			
			
			local ToggleSettingButton = ToggleTemplate:Clone()
			
			
			local function on()
				TrackModule:SetAttribute(settingName,true)
				ToggleSettingButton.Frame.Check.Visible = true
			end
			
			local function off()
				TrackModule:SetAttribute(settingName,false)
				ToggleSettingButton.Frame.Check.Visible = false
			end
			
			if setting == false then
				off()
			else
				on()
			end
			
			Toggle:Set(ToggleSettingButton,on,off,setting)
			EffectWhiteStroke:Set(ToggleSettingButton,ToggleSettingButton.Frame)
			ToggleSettingButton.Name = settingName
			ToggleSettingButton.DisplayName.Text = string.gsub(settingName,"Toggle","")
			ToggleSettingButton.Parent = ToggleTemplate.Parent
			ToggleSettingButton.Visible = true
			
		elseif settingType == "Color3" then
			local ColorTemplate = SettingsUI.List.Colors.ColorTemplate
			ColorTemplate.Visible = false
			
			local ColorSettingButton = ColorTemplate:Clone()
			
			ColorSettingButton.Frame.BackgroundColor3 = setting

			ColorSettingButton.Name = settingName
			ColorSettingButton.DisplayName.Text = string.gsub(settingName,"Color","")
			ColorSettingButton.Parent = ColorTemplate.Parent
			ColorSettingButton.Visible = true
			
			
			
			ColorPalette:Set(ColorWidget,ColorSettingButton,TrackModule,settingName,setting)
		
			EffectWhiteStroke:Set(ColorSettingButton)
		end
		
	end

	
	
	--CREATE MATERIALS
	
	local MaterialListButton = TrackUI:FindFirstChild("Material", true).TextButton
	------------------------------------------------------------------------
	local MaterialWidget = CoasterToolPack.PluginManager:Plugin():CreateDockWidgetPluginGui(
		"MaterialWidget"..TrackModule.Name,
		DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Float,false,true, 250, 300,250, 400
		)
		
	)
	
	MaterialWidget.Name = "CoasterToolPackMaterial"

	---------------------------------------------------------------------------------
	
	local MaterialList = CoasterToolPack.Resources.UI.MaterialList:Clone()
	MaterialList.Parent = MaterialWidget

	local MaterialButtonList = MaterialList:FindFirstChild("List",true)
	local MaterialButtonTemplate = MaterialButtonList.MaterialTemplate
	MaterialButtonTemplate.Visible = false
	
	
	
	
	local DefaultMaterial = TrackModule:GetAttribute("Material")
		
	local function setMaterial(Material)
		TrackModule:SetAttribute("Material",Material)
		MaterialListButton.Text = Material
	end
	
	

	------------------------------------------------------------------------------------
	EffectWhiteStroke:Set(MaterialListButton,MaterialListButton.Parent)
	----------------------------------------------------------------------------------
	local MaterialDebounce = true
	
	MaterialListButton.MouseButton1Click:Connect(function()
		if MaterialDebounce then
			MaterialDebounce = false
			MaterialWidget.Enabled = true
		else
			MaterialDebounce = true
			MaterialWidget.Enabled = false
		end
	end)
	
	
	for _, Material in pairs(Enum.Material:GetEnumItems()) do
		local MaterialButton = MaterialButtonTemplate:Clone()
		MaterialButton.Name = Material.Name
		MaterialButton.Parent = MaterialList.Frame.List
		MaterialButton.Text = Material.Name
		MaterialButton.Visible = true
		MaterialButton.MouseButton1Click:Connect(function ()
			
			MaterialButtonList[TrackModule:GetAttribute("Material")].UIStroke.Color = Color3.new(0.141176, 0.141176, 0.141176)
			
			setMaterial(Material.Name)
			MaterialButton.UIStroke.Color = Color3.new(1, 0.533333, 0)
			MaterialDebounce = true
			MaterialWidget.Enabled = false
		end)
		
	end
	
	setMaterial(DefaultMaterial)
	MaterialButtonList[DefaultMaterial].UIStroke.Color = Color3.new(1, 0.533333, 0)
	
	MaterialWidget:GetPropertyChangedSignal("Enabled"):Connect(function()
		if MaterialWidget.Enabled == false then
			MaterialDebounce = true
		end
	end)
	
	------------------------------------------------------------------------------------------
	--PGS Settings
	
	local PGS = TrackModule:GetAttribute("TogglePGS")
	if PGS ~= nil then
		local PGSUI = TrackUI:FindFirstChild("PGS",true)
		
		TrackModule:GetAttributeChangedSignal("TogglePGS"):Connect(function()
			PGS = TrackModule:GetAttribute("TogglePGS")
			if PGS then
				PGSUI.Visible = true
			else
				PGSUI.Visible = false
			end

		end)
		
		local function setValue(TextBox)
			
			if TextBox.Text == nil or not tonumber(TextBox.Text) then
				TrackModule:SetAttribute(TextBox.Parent.Parent.Name,tonumber(TextBox.PlaceholderText))
				TextBox.Text = ""
			else
				TrackModule:SetAttribute(TextBox.Parent.Parent.Name,tonumber(TextBox.Text))
			end
		end
		
		PGSUI.Density.Frame.TextBox.FocusLost:Connect(function()
			setValue(PGSUI.Density.Frame.TextBox)
		end)
		PGSUI.Friction.Frame.TextBox.FocusLost:Connect(function()
			setValue(PGSUI.Friction.Frame.TextBox)
		end)
		PGSUI.Elasticity.Frame.TextBox.FocusLost:Connect(function()
			setValue(PGSUI.Elasticity.Frame.TextBox)
		end)
		PGSUI.Velocity.Frame.TextBox.FocusLost:Connect(function()
			setValue(PGSUI.Velocity.Frame.TextBox)
		end)
		
	end
	
	------------------------------------------------------------------------------------------
	--SPINE CUSTOM
	
	
	if TrackModule:GetAttribute("SpineHeight") then
		local TwistedSpineSettings = TrackUI:FindFirstChild("TwistedSpineSettings",true)
		TwistedSpineSettings.Visible = true
		TwistedSpineSettings.Height.Frame.TextBox.FocusLost:Connect(function()
			if not tonumber(TwistedSpineSettings.Height.Frame.TextBox.Text) then
				TrackModule:SetAttribute("SpineHeight",0)
			else
				TrackModule:SetAttribute("SpineHeight",tonumber(TwistedSpineSettings.Height.Frame.TextBox.Text))
			end
			TwistedSpineSettings.Height.Frame.TextBox.Text = TrackModule:GetAttribute("SpineHeight")
		end)
		
		TrackModule.AttributeChanged:Connect(function ()
			TwistedSpineSettings.Height.Frame.TextBox.Text = TrackModule:GetAttribute("SpineHeight")
		end)
		
		
	end
	
	if TrackModule:GetAttribute("SpineStyle") then
		
		local TwistedSpineSettings = TrackUI:FindFirstChild("TwistedSpineSettings",true)
		TwistedSpineSettings.Visible = true
		
		ToggleOptions:Set(TwistedSpineSettings.SelectSpineStyle,{"Normal","Bottom","Top","DualTop","Middle"},
			function(option)
	
				TwistedSpineSettings.SelectSpineStyle.Frame.TextLabel.Text = option
				TrackModule:SetAttribute("SpineStyle",option)
			end
		)
		


	end
	
	
	
	--SET STARTCONVERTING ENABLE/DISABLE BUTTON
	
	local StartConvertingButton = TrackUI.Convert.TextButton
	
	local function ToolOn() -- ON
		plugin:Activate(true)
		TrackModule:SetAttribute("Active",true)
		StartConvertingButton.TextLabel.Text = "Converting"
		StartConvertingButton.Frame.Frame.BackgroundColor3 = Color3.new(0, 1, 0)

	end
	local function ToolOff() -- OFF
		TrackModule:SetAttribute("Active",false)
		StartConvertingButton.TextLabel.Text = "Start Converting"
		StartConvertingButton.Frame.Frame.BackgroundColor3 = Color3.new(1, 0, 0)
	end
	
	--SUPPORTS TAB	
	local SupportButton = TrackUI.Header.SupportButton
	
	if TrackModule:FindFirstChild("SupportBuilder") then
		SupportButton.Visible = true

		SupportButton.MouseButton1Click:Connect(function()
			if TrackUI.ToolList.Visible == true then
				TrackModule:SetAttribute("SupportActive",true)
				TrackUI.ToolList.Visible = false
				TrackUI.SupportToolList.Visible = true
			else
				TrackModule:SetAttribute("SupportActive",false)
				TrackUI.ToolList.Visible = true
				TrackUI.SupportToolList.Visible = false
			end
			
		end)

	end
	
	StartConvertingButton.MouseButton1Click:Connect(function()
		if TrackModule:GetAttribute("Active") == true then
			ToolOff()
			plugin:Deactivate()
		else
			ToolOn()
		end
	end)

	plugin.Deactivation:Connect(ToolOff)
	
	local TrackBuilder = require(script.TrackBuilder)
	TrackBuilder:Init(CoasterToolPack,TrackModule,Track,TrackUI)
	
	if TrackModule:FindFirstChild("SupportBuilder") then
		local SupportBuilder = require(TrackModule.SupportBuilder)
		------------------
		local SupportOptionsTemplate = TrackUI.SupportToolList.OptionsTemplate
		SupportOptionsTemplate.Visible = false

		--SET STYLE OPTIONS
		local SupportStylesList = SupportOptionsTemplate:Clone()
		SupportStylesList.DisplayText.Text = "Styles"
		SupportStylesList.Name = "Styles"
		SupportStylesList.LayoutOrder = 1
		SupportStylesList.Parent = SupportOptionsTemplate.Parent
		SupportStylesList.Visible = len(SupportBuilder.Content)>1 

		--SET STYLE BUTTONS
		local SupportStyleButtonTemplate = SupportStylesList:FindFirstChild("OptionTemplate",true)
		SupportStyleButtonTemplate.Visible = false

		local SupportStyleButtons = {}

		for name, style in pairs(SupportBuilder.Content) do
			local StyleButton = SupportStyleButtonTemplate:Clone()
			StyleButton.Name = name
			StyleButton.Text = name
			StyleButton.LayoutOrder = style.LayoutOrder or 100
			StyleButton.Visible = true
			StyleButton.Parent = SupportStyleButtonTemplate.Parent
			SupportStyleButtons[name] = StyleButton
			EffectWhiteStroke:Set(StyleButton)

		end
		----------------------
		local function SwapsSupportStyle(StyleButton)
			local PreviousStyle = TrackModule.SupportBuilder:GetAttribute("Style")
			local CurrentStyle = StyleButton.Name
			TrackModule.SupportBuilder:SetAttribute("Style",CurrentStyle)

			--SET SELECTED TO STYLE
			SupportStyleButtons[PreviousStyle].UIStroke.Color = Color3.new(0.141176, 0.141176, 0.141176)
			StyleButton.UIStroke.Color = Color3.new(0, 0.666667, 1)



		end

		SwapsSupportStyle(SupportStyleButtons[TrackModule.SupportBuilder:GetAttribute("Style")])

		for _, StyleButton in pairs(SupportStyleButtons) do
			StyleButton.MouseButton1Click:Connect(function()
				SwapsSupportStyle(StyleButton)
			end)
		end
		
		SupportBuilder:Init(CoasterToolPack,TrackModule,Track,TrackUI)
	end
	
	
	--------------------------------------------------------------------------------
end

function len(t)
	local n = 0

	for _ in pairs(t) do
		n = n + 1
	end
	return n
end

return TrackManager