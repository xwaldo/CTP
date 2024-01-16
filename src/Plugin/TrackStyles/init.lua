local TrackStyles = {}

local Tracks = require(script.Tracks)
local TrackManager = require(script.TrackManager)
local plugin
--EFFECTS

function TrackStyles:Init(CoasterToolPack,Widget)
	plugin = CoasterToolPack.PluginManager:Plugin()
	local Resources = CoasterToolPack.Resources

	local EffectWhiteStroke = require(Resources.Util.EffectWhiteStroke)

	local TrackStylesUI = Resources.UI.TrackStyles:Clone()
	local ToolList = TrackStylesUI:FindFirstChild("ToolList",true)

	-- ADD TRACKSTYLES UI TO WIDGET
	TrackStylesUI.Parent = Widget

	-- OPEN TRACK CONVERTER
	local function openTrack(_track)
		local track = TrackStylesUI.Converters[_track.Name]
		local BackButton = track:FindFirstChild("BackButton",true)
		ToolList.Visible = false
		track.Visible = true
		BackButton.MouseButton1Click:Connect(function()
			plugin:Deactivate()
			track.Visible = false
			ToolList.Visible = true
		end)
	end

	-- ADD TRACK BUTTONS TO LIST
	local TrackButtonTemplate = TrackStylesUI:FindFirstChild("Template",true)

	for trackname, Track in pairs(Tracks) do
		local TrackButton = TrackButtonTemplate:Clone()
		TrackButton.Parent = TrackButtonTemplate.Parent
		TrackButton.Name = trackname
		TrackButton.DisplayName.Text = Track.Name or "Track"
		TrackButton.DisplayImage.Image = Track.Image
		TrackButton.LayoutOrder = Track.LayoutOrder or 20
		TrackButton.Visible = not Track.DevOnly or CoasterToolPack.PluginOptions.Dev
		
		
		local TrackInfo = TrackButton.Info
		
		if Track.Beta then
			TrackInfo.Beta.Visible = true
		end
		if Track.New then
			TrackInfo.New.Visible = true
		end
		
		
		EffectWhiteStroke:Set(TrackButton)

		local TrackUI = TrackStylesUI.Converters.Template:Clone()
		TrackUI.Name = trackname
		TrackUI.Parent = TrackStylesUI.Converters
			
		TrackUI.Visible = false
		
		TrackManager:Set(CoasterToolPack,Track,TrackUI,trackname)
		wait()
	end


	-- TRACK STYLES BUTTONS
	for _, track in pairs(ToolList:GetChildren()) do
		if track:IsA("TextButton") then
			track.MouseButton1Click:Connect(function()
				openTrack(track)
			end)
		end
	end



end
return TrackStyles
