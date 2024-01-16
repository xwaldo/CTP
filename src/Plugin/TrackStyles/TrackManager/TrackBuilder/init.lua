local plugin

local TrackElements = require(script.TrackElements)

local UserInputService = game:GetService("UserInputService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local TrackBuilder = {}

function TrackBuilder:Init(CoasterToolPack,TrackModule,Track,TrackUI)

	plugin = CoasterToolPack.PluginManager:Plugin()
	local Mouse = plugin:GetMouse()

	local current = nil
	local previous = nil
	local previousTrack = nil
	local currentBrickColor = nil
	local connectorPrevious = false
	local convertDebounce = false
	local mirror = false

	local function BuildRails(Elements,Parent,PGS)
		for RailName,RailContent in pairs(Elements) do
			local Rail = TrackElements.Rail(current.CFrame,previous.CFrame,RailContent,Parent,RailName,TrackModule,PGS)
		end

	end

	local function BuildCrosstie(Elements,Parent,Connector)

		local SwapMirror = Elements.SwapMirror
		local HeightChange = Elements.HeightChange and TrackModule:GetAttribute("SpineHeight")

		local CurrentStyle = TrackModule:GetAttribute("Style")
		local CurrentType = TrackModule:GetAttribute("Type")
		local CurrentSpecial = TrackModule:GetAttribute("Special")

		if SwapMirror and mirror == false then

			local CrosstieModel = TrackModule:FindFirstChild(CurrentStyle..CurrentType.."Mirror")
			if CrosstieModel then
				TrackElements.Crosstie(Elements,current.CFrame,CrosstieModel,Parent,TrackModule)
			else
				warn("Coaster Tool Pack: Crosstie missing ["..CurrentStyle..CurrentType.."Mirror]")
			end

		elseif HeightChange and Connector then

			local CrosstieModel 
			
			
			local SpineHeight = TrackModule:GetAttribute("SpineHeight")
			
			local SpineStyle =  TrackModule:GetAttribute("SpineStyle")


			if SpineHeight <= Elements.HeightsMid[1] then
				CrosstieModel = TrackModule:FindFirstChild(CurrentStyle..CurrentType.."Connector"..SpineStyle)
				if CrosstieModel then
					TrackElements.Crosstie(Elements,current.CFrame,CrosstieModel,Parent,TrackModule)
				else
					warn("Coaster Tool Pack: Crosstie missing ["..CurrentStyle..CurrentType.."Connector]")
				end
			elseif SpineHeight <= Elements.HeightsMid[2] then
				CrosstieModel = TrackModule:FindFirstChild(CurrentStyle..CurrentType.."Connector2"..SpineStyle)
				if CrosstieModel then
					TrackElements.Crosstie(Elements,current.CFrame,CrosstieModel,Parent,TrackModule)
				else
					warn("Coaster Tool Pack: Crosstie missing ["..CurrentStyle..CurrentType.."Connector2]")
				end
			else
				CrosstieModel = TrackModule:FindFirstChild(CurrentStyle..CurrentType.."Connector3"..SpineStyle)
				if CrosstieModel then
					TrackElements.Crosstie(Elements,current.CFrame,CrosstieModel,Parent,TrackModule)
				else
					warn("Coaster Tool Pack: Crosstie missing ["..CurrentStyle..CurrentType.."Connector3]")
				end
			end





		else
			if Connector  then
				local CrosstieModel = TrackModule:FindFirstChild(CurrentStyle..CurrentType.."Connector")

				if CrosstieModel then
					TrackElements.Crosstie(Elements,current.CFrame,CrosstieModel,Parent,TrackModule)
				else
					warn("Coaster Tool Pack: Crosstie missing ["..CurrentStyle..CurrentType.."Connector]")
				end
			elseif (CurrentSpecial == "Support" or current.BrickColor == BrickColor.new("New Yeller")) and TrackModule:FindFirstChild(CurrentStyle..CurrentType.."Support") then
				local CrosstieModel = TrackModule:FindFirstChild(CurrentStyle..CurrentType.."Support")
				if CrosstieModel then
					TrackElements.Crosstie(Elements,current.CFrame,CrosstieModel,Parent,TrackModule)
				else
					warn("Coaster Tool Pack: Crosstie missing ["..CurrentStyle..CurrentType.."Support]")
				end
				
			else

				local CrosstieModel = TrackModule:FindFirstChild(CurrentStyle..CurrentType)
				if CrosstieModel then
					TrackElements.Crosstie(Elements,current.CFrame,CrosstieModel,Parent,TrackModule)
				else
					warn("Coaster Tool Pack: Crosstie missing ["..CurrentStyle..CurrentType.."]")
				end
			end
		end

		if Elements.Swap then
			if mirror  then
				mirror = false
			else
				mirror = true
			end
		end




	end

	local function BuildCrossbeams(Elements,Parent,Connector)

		local SwapMirror = false
		local CurrentSpecial = TrackModule:GetAttribute("Special")
		
		for CrossbeamName,CrossbeamContent in pairs(Elements) do
			if   (CrossbeamContent.ConnectorMirror and (Connector or connectorPrevious)) and CrossbeamContent.SwapMirror then
				if CrossbeamContent.SwapMirror then
					SwapMirror =true
					if mirror == false and Connector then
						TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent,Parent,CrossbeamName,TrackModule,Connector)

					elseif connectorPrevious == true and mirror == true then
						TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent,Parent,CrossbeamName,TrackModule,Connector,true)

					end

				
				end
				
			elseif CrossbeamContent.SwapMirror then
				SwapMirror = true
				if mirror then
					TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent,Parent,CrossbeamName,TrackModule,Connector,true)

				else
					TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent,Parent,CrossbeamName,TrackModule,Connector)

				end
			elseif CrossbeamContent.Mirror and not (Connector or connectorPrevious) then


					if TrackModule:GetAttribute("CrossbeamDirection") then
						TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent,Parent,CrossbeamName,TrackModule,Connector)

					elseif TrackModule:GetAttribute("CrossbeamDirection") == false then

						TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent,Parent,CrossbeamName,TrackModule,Connector,true)
					end
		
					
				
			elseif not (Connector or connectorPrevious) then
				TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent,Parent,CrossbeamName,TrackModule,Connector)
				--print(7)
			end
			
			
		end
		
		if TrackModule:GetAttribute("CrossbeamDirection") ~= nil and (CurrentSpecial == "Support" or current.BrickColor == BrickColor.new("New Yeller")) then
	
			local CrossbeamDirectionButton = TrackUI.ToolList.Settings.List.CrossbeamDirection


			local Direction = TrackModule:GetAttribute("CrossbeamDirection")

			if Direction then
				CrossbeamDirectionButton.TextButton.Text = "Back"
			else
				CrossbeamDirectionButton.TextButton.Text = "Front"
			end

			TrackModule:SetAttribute("CrossbeamDirection",not Direction)

		end
		
		if SwapMirror == true then
			if mirror then
				mirror = false
			else
				mirror = true
			end
		end
	end
	local function BuildConnectorCrossbeams(Elements,Parent,Connector)

		local SwapMirror = false

		if (Connector or connectorPrevious) then
			

			for CrossbeamName,CrossbeamContent in pairs(Elements) do
				if CrossbeamContent.PreviousConnector.Mirror and CrossbeamContent.CurrentConnector.Mirror then
					if TrackModule:GetAttribute("CrossbeamDirection") then
						if Connector then
							--print(1)
							TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent.CurrentConnector,Parent,CrossbeamName.."Connector",TrackModule,Connector)

						else
							--print(2)
							TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent.PreviousConnector,Parent,CrossbeamName.."Connector",TrackModule,Connector)

						end
					else 
						if Connector then
							--print(3)
							TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent.PreviousConnector,Parent,CrossbeamName.."Connector",TrackModule,Connector,true)

						else
							--print(4)
							TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent.CurrentConnector,Parent,CrossbeamName.."Connector",TrackModule,Connector,true)


						end
					end
				else
					if Connector then
						--print(5)
						TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent.PreviousConnector,Parent,CrossbeamName.."Connector",TrackModule,Connector)
						if CrossbeamContent.PreviousConnector.SwapMirror then
							SwapMirror = true
						end

					else
						--print(6)
						TrackElements.Crossbeam(current.CFrame,previousTrack.CFrame,CrossbeamContent.CurrentConnector,Parent,CrossbeamName.."Connector",TrackModule,Connector)
						if CrossbeamContent.CurrentConnector.SwapMirror then
							SwapMirror = true
						end


					end
				end
				
			end



		end
		if SwapMirror == true then
		
			if mirror then
				mirror = false
			else
				mirror = true
			end
		end



	end
	local function BuildTwistedBoxes(Elements,Parent,Connector,Transitioni)



		
		for TwistedBoxName,TwistedBoxContent in pairs(Elements) do
			local SpineHeight = TrackModule:GetAttribute("SpineHeight")
			local PrevSpineHeight = SpineHeight
			
			
			if Transitioni then
				TrackModule:SetAttribute("SpineHeight",Transitioni)
			end

			if Connector then
				if SpineHeight <= TwistedBoxContent.HeightsMid[1] then
					TrackModule:SetAttribute("SpineHeight",TwistedBoxContent.Heights[1])
				elseif SpineHeight <= TwistedBoxContent.HeightsMid[2] then
					TrackModule:SetAttribute("SpineHeight",TwistedBoxContent.Heights[2])
				else
					TrackModule:SetAttribute("SpineHeight",TwistedBoxContent.Heights[3])
				end
				TrackElements.TwistedBox(current.CFrame,previousTrack.CFrame,TwistedBoxContent,Parent,TwistedBoxName,TrackModule)
				PrevSpineHeight = TrackModule:GetAttribute("SpineHeight")
				TrackModule:SetAttribute("SpineHeightPrevious",PrevSpineHeight)


			else
				TrackElements.TwistedBox(current.CFrame,previousTrack.CFrame,TwistedBoxContent,Parent,TwistedBoxName,TrackModule)
				TrackModule:SetAttribute("SpineHeightPrevious",TrackModule:GetAttribute("SpineHeight"))
			end



		end
	end

	local function BuildBoxes(Elements,Parent,Connector)


		for RailName,RailContent in pairs(Elements) do
			
			local _current = current.CFrame
			local _previousTrack = previousTrack.CFrame
			
			if (current.Orientation.X-previous.Orientation.X)<0 then
				_current *= CFrame.new(0,RailContent.Size.Y/2,0)
				_previousTrack *= CFrame.new(0,RailContent.Size.Y/2,0)
			elseif (current.Orientation.X-previous.Orientation.X)>0 then
				_current *= CFrame.new(0,-RailContent.Size.Y/2,0)
				_previousTrack *= CFrame.new(0,-RailContent.Size.Y/2,0)
			end
			
			local Rail = TrackElements.Rail(_current,_previousTrack,RailContent,Parent,RailName,TrackModule)
			
			if (current.Orientation.X-previous.Orientation.X)<0 then
				Rail.CFrame *= CFrame.new(0,0,RailContent.Size.Y/2)
			elseif (current.Orientation.X-previous.Orientation.X)>0 then
				Rail.CFrame *= CFrame.new(0,0,-RailContent.Size.Y/2)
			end
		end


	end

	local function BuildTrack(Target,AutoConvert,Transitioni)
		if not Target then return end
		if not (Target:IsA("Part") and (tonumber(Target.Name) or Target.Name == "Track")) then return end
		if Target.BrickColor == BrickColor.new("Black") then return end
		current = Target

		if previous  then
			if current ~= previous  then
				if AutoConvert == nil then
					ChangeHistoryService:SetWaypoint("CoasterToolPack")
				end

				current = Target
				currentBrickColor = current.BrickColor

				local CurrentStyle = TrackModule:GetAttribute("Style")
				local CurrentType = TrackModule:GetAttribute("Type")
				local CurrentSpecial = TrackModule:GetAttribute("Special")

				local TypeContent = Track.Content[CurrentStyle][CurrentType]

				local AddRails = TrackModule:GetAttribute("ToggleRails") and TypeContent.Rails
				local AddTwistedBoxes = TrackModule:GetAttribute("ToggleRails") and TypeContent.TwistedBoxes
				local AddBoxes = TrackModule:GetAttribute("ToggleRails") and TypeContent.Boxes
				local AddCrossbeam = TrackModule:GetAttribute("ToggleCrossbeams") and TypeContent.Crossbeams
				local AddCrosstie = TrackModule:GetAttribute("ToggleCrosstie") and TypeContent.Crosstie
				local AddStripes = TrackModule:GetAttribute("ToggleStripes") 
				local PGS = TrackModule:GetAttribute("TogglePGS") 

				local TrackModel = Instance.new("Model")
				TrackModel.Name = TrackModule.Name.."Segment"

				local Connector = (CurrentSpecial == "Connector") or (currentBrickColor == BrickColor.new("Really red"))


				if currentBrickColor ~= BrickColor.new("White") and currentBrickColor ~= BrickColor.new("Black") then
					if AddRails then
						BuildRails(TypeContent.Rails,TrackModel,PGS)
					end
					if AddCrosstie then
						BuildCrosstie(TypeContent.Crosstie,TrackModel,Connector)
					end
					if AddCrossbeam then
						BuildCrossbeams(TypeContent.Crossbeams,TrackModel,Connector)
					end
			
					if TypeContent.ConnectorCrossbeams and AddCrossbeam then
						BuildConnectorCrossbeams(TypeContent.ConnectorCrossbeams,TrackModel,Connector)
					end
					if AddTwistedBoxes then
						BuildTwistedBoxes(TypeContent.TwistedBoxes,TrackModel,Connector,Transitioni)
					end
					if AddBoxes then
						BuildBoxes(TypeContent.Boxes,TrackModel,Connector)
					end

					previousTrack = current

					if (not AddRails) and (not AddCrosstie) then
						TrackModel:Destroy()
					else
						TrackModel.Parent = workspace
					end
					if Connector then
						connectorPrevious = true
					else
						connectorPrevious = false
					end

				else
					if AddRails then
						BuildRails(TypeContent.Rails,TrackModel,PGS)
						TrackModel.Parent = workspace
					else
						TrackModel:Destroy()
					end

				end

				previous = current

				if AutoConvert == nil then
					ChangeHistoryService:SetWaypoint("Coaster Tool Pack: Created track")
				end
			end
		else
			if TrackModule:GetAttribute("SpineHeight") then
				if Transitioni then
					TrackModule:SetAttribute("SpineHeightPrevious",Transitioni)
				else
					TrackModule:SetAttribute("SpineHeightPrevious",TrackModule:GetAttribute("SpineHeight"))
				end
			end
			if Target.BrickColor == BrickColor.new("Really red") or TrackModule:GetAttribute("Special") == "Connector" then
				--print("YES")
				connectorPrevious = true
			end
			previous = Target
			previousTrack = Target

		end

	end

	local ConvertAllButton = TrackUI.ToolList.ConvertAllButton
	local ConvertToButton = TrackUI.ToolList.ConvertToButton
	local ConvertTransitionButton = TrackUI.ToolList.ConvertTransitionButton

	-- CONVERT ON CLICK & CONVERT ALL/TO---------------------------------------------------------
	local Clicking

	UserInputService.InputBegan:Connect(function(key)
		if key.UserInputType == Enum.UserInputType.MouseButton1 and convertDebounce == false  then
			if TrackModule:GetAttribute("Active") == true and not TrackModule:GetAttribute("SupportActive") then
				Clicking = true
				while Clicking == true do
					convertDebounce = true
					BuildTrack(Mouse.Target)
					convertDebounce = false
					wait(0.05)
				end
			end

		end
	end)

	UserInputService.InputEnded:Connect(function(key)
		if key.UserInputType == Enum.UserInputType.MouseButton1  then
			Clicking = false
		end
	end)
	--------------------------------------------------------------------------------------------

	local function AutoConvert(Start,End,TransitionStart,TransitionEnd)
		if convertDebounce == false and not TrackModule:GetAttribute("SupportActive") then
			convertDebounce = true
			local Layout = Selection:Get()
			if #Layout == 1 then
				Layout = Layout[1]
				if Layout:IsA("Model") then

					current = nil
					previous = nil
					previousTrack = nil
					currentBrickColor = nil
					connectorPrevious = false
					mirror = false

					if TrackModule:GetAttribute("SpineHeight") then
						TrackModule:SetAttribute("SpineHeightPrevious",0)
					end

					local Nodes = Layout:GetChildren()
					if Start then
						if not (Start>=1 and Start<= #Nodes) then
							Start = 1
						end 
					end
					if End then
						if not (End >= 1 and End<= #Nodes)  then
							End = #Nodes
						end
					end
					if Start and End then
						if Start>End then
							local a = Start
							Start = End
							End = a
						end
					end

					ChangeHistoryService:SetWaypoint("Coaster Tool Pack: Started converting track: "..Layout.Name)
					if  TransitionStart then
						local GreyBricks = {}
						local TransitionRange = TransitionEnd-TransitionStart
						
						
						for i = (Start or 1), (End or #Nodes) , 1 do
							
							--print(Layout[tostring(i)].Name)
							if Layout:FindFirstChild(tostring(i)) then

								if Layout[tostring(i)].BrickColor == BrickColor.new("Medium stone grey") or Layout[tostring(i)].BrickColor == BrickColor.new("Really red") then
									table.insert(GreyBricks,Layout[tostring(i)])
								end

							end
						end
						--print("#GreyBricks"..tostring(#GreyBricks))
						local TransitionSteps = TransitionRange/#GreyBricks
						
						
						local Transitioni = TransitionStart

						for i = (Start or 1), (End or #Nodes) , 1 do

							--print(Layout[tostring(i)].Name)
							if Layout:FindFirstChild(tostring(i)) then




								if Layout:FindFirstChild(tostring(i)).BrickColor == BrickColor.new("Medium stone grey") or Layout:FindFirstChild(tostring(i)).BrickColor == BrickColor.new("Really red") then
									BuildTrack(Layout[tostring(i)],true,Transitioni+TransitionSteps)

									Transitioni = Transitioni+TransitionSteps
								else
									BuildTrack(Layout[tostring(i)],true,Transitioni)

								end

							else
								warn("Coaster Tool Pack: Layout is missing node: "..tostring(i))

								break
							end
						end
					else
						for i = (Start or 1), (End or #Nodes) , 1 do

							--print(Layout[tostring(i)].Name)
							if Layout:FindFirstChild(tostring(i)) then
								BuildTrack(Layout[tostring(i)],true)
							else
								warn("Coaster Tool Pack: Layout is missing node: "..tostring(i))

								break
							end
						end
					end



					current = nil
					previous = nil
					previousTrack = nil
					currentBrickColor = nil
					connectorPrevious = false
					mirror = false
					if TrackModule:GetAttribute("SpineHeight") then
						TrackModule:SetAttribute("SpineHeight",0)
						TrackModule:SetAttribute("SpineHeightPrevious",0)
					end

					ChangeHistoryService:SetWaypoint("Coaster Tool Pack: Finished converting track: "..Layout.Name)
				else
					warn("Coaster Tool Pack: Object selected is not a model ("..Layout.Name.." is a "..Layout.ClassName.. ")")

				end
			elseif #Layout > 1 then
				warn("Coaster Tool Pack: Multiple objects selected ["..tostring(#Layout).." objects]")
			else
				warn("Coaster Tool Pack: No layout selected")
			end

			convertDebounce = false
		end
	end

	ConvertAllButton.MouseButton1Click:Connect(AutoConvert)

	if TrackModule:GetAttribute("SpineHeight") then
		ConvertTransitionButton.Visible = true
		ConvertTransitionButton.MouseButton1Click:Connect(function()
			local Start,End

			if ConvertToButton.Start.Frame.TextBox.Text == nil or (not tonumber(ConvertToButton.Start.Frame.TextBox.Text)) then
				Start = 1
			else
				Start = tonumber(ConvertToButton.Start.Frame.TextBox.Text)
			end
			End = tonumber(ConvertToButton.End.Frame.TextBox.Text)

			AutoConvert(Start,End,tonumber(ConvertTransitionButton.Start.Frame.TextBox.Text),tonumber(ConvertTransitionButton.End.Frame.TextBox.Text))
		end)
	end
	
	local CrossbeamDirectionButton = TrackUI.ToolList.Settings.List.CrossbeamDirection
	
	if TrackModule:GetAttribute("CrossbeamDirection") then
		--print(TrackModule.Name)
		CrossbeamDirectionButton.Visible = true
		CrossbeamDirectionButton.TextButton.MouseButton1Click:Connect(function ()
			local Direction = TrackModule:GetAttribute("CrossbeamDirection")

			if Direction then
				CrossbeamDirectionButton.TextButton.Text = "Back"
			else
				CrossbeamDirectionButton.TextButton.Text = "Front"
			end
			
			TrackModule:SetAttribute("CrossbeamDirection",not Direction)
		end)
	end
	
	ConvertToButton.MouseButton1Click:Connect(function()
		local Start,End

		if ConvertToButton.Start.Frame.TextBox.Text == nil or (not tonumber(ConvertToButton.Start.Frame.TextBox.Text)) then
			Start = 1
		else
			Start = tonumber(ConvertToButton.Start.Frame.TextBox.Text)
		end
		End = tonumber(ConvertToButton.End.Frame.TextBox.Text)

		AutoConvert(Start,End)

	end)
	ConvertToButton.Start.MouseButton1Click:Connect(function ()
		local TextBox = ConvertToButton.Start.Frame.TextBox
		local Node = Selection:Get()
		if Node[1] then
			if Node[1]:IsA("BasePart") and tonumber(Node[1].Name) then
				TextBox.Text = Node[1].Name
			end
		end

	end)
	ConvertToButton.End.MouseButton1Click:Connect(function ()
		local TextBox = ConvertToButton.End.Frame.TextBox
		local Node = Selection:Get()
		if Node[1] then
			if Node[1]:IsA("BasePart") and tonumber(Node[1].Name) then
				TextBox.Text = Node[1].Name
			end
		end

	end)

	-----------------------------------------------------------------------------------------------
	plugin.Deactivation:Connect(function ()
		current = nil
		previous = nil
		previousTrack = nil
		currentBrickColor = nil
		connectorPrevious = false
		mirror = false
		if TrackModule:GetAttribute("SpineHeight") then
			TrackModule:SetAttribute("SpineHeight",0)
			TrackModule:SetAttribute("SpineHeightPrevious",0)
		end


	end)	

end

return TrackBuilder