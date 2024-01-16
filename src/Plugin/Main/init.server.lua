local PluginManager = require(script.PluginManager)
local PluginOptions = require(script.PluginOptions)
local PluginFolder = script.Parent
local Resources = PluginFolder.Resources

PluginManager:Init(plugin,Resources)

--------------------
--PLUGIN RESOURCES--
--------------------

local CoasterToolPack = {
	Resources = Resources,
	PluginManager = PluginManager,
	PluginOptions = PluginOptions,
}

------------------
--INITIALIZATION--
------------------
local ToolBarName = "CTP \n v"..PluginOptions.Version

do
	
	
	if PluginOptions.Dev then ToolBarName = ToolBarName.." - Dev" end 
	
	local ToolBar = plugin:CreateToolbar(ToolBarName)
	
	local ToolBarButtons = {
		TrackStyles = {
			Name = "Track styles", 
			Frame = "TrackStyles",
			Image = "rbxassetid://8660153811", 
			Desc = "Create tracks for your coaster or use prefabs"},
		LayoutEditor = {
			Name = "Layout Editor", 
			Frame = "LayoutEditor",
			Image = "rbxassetid://8660078560", 
			Desc = "Edit layout"
		}
	}
	
	local WidgetInfo = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Left,
		false,
		false,
		325,
		400,
		325,
		200
	)
	
	for _, tool in pairs(ToolBarButtons) do
		local frameName = tool.Frame
		local name = tool.Name
		local desc = tool.Desc
		local image = tool.Image
		
		tool.Button =  ToolBar:CreateButton(name,desc,image,name)
		tool.Widget = plugin:CreateDockWidgetPluginGui(name,WidgetInfo)
		tool.Widget.Name = "CoasterToolPack"..name
		tool.Widget.Title = name
		tool.Widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		tool.Widget.Enabled = false
		
		tool.Button.Click:Connect(function()
			if tool.Widget.Enabled == false then
				tool.Widget.Enabled = true
			else
				tool.Widget.Enabled = false
			end
		end)
		
		tool.Widget:GetPropertyChangedSignal("Enabled"):Connect(function ()
			if tool.Widget.Enabled == false then
				plugin:Deactivate()
			end
		end)
		
	end
	
	for _, module in pairs(PluginFolder.Resources:GetChildren()) do
		local _module = require(module)
		if _module.Init then
			_module:Init(CoasterToolPack,ToolBarButtons[module.Name].Widget)
		end
	end
	
	
end






