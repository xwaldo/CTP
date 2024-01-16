local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local LayoutEditor = {}


function LayoutEditor:Init(CoasterToolPack,Widget)

	local Resources = CoasterToolPack.Resources
	local EffectWhiteStroke = require(Resources.Util.EffectWhiteStroke)

	local LayoutEditorUI = Resources.UI.LayoutEditor:Clone()
	local ToolList = LayoutEditorUI:FindFirstChild("ToolList",true)

	-- ADD LAYOUTEDITOR UI TO WIDGET

	LayoutEditorUI.Parent = Widget
	--------------------------------------------
	--LAYOUT SELECTER

	local SelectLayoutButton = LayoutEditorUI:FindFirstChild("SelectLayout",true)
	local SelectLayoutText = SelectLayoutButton.Frame.TextLabel
	local Layout = nil


	local SelectLayoutDebounce = true

	SelectLayoutButton.MouseButton1Click:Connect(function()
		if SelectLayoutDebounce then
			SelectLayoutDebounce = false

			local _Selection = Selection:Get()

			local function SelectLayout()
				Layout = _Selection
				SelectLayoutText.Text = _Selection.Name
				SelectLayoutText.TextColor3 = Color3.new(0.698039, 0.698039, 0.698039)
			end
			local function UnselectLayout(WarnText)
				Layout = nil
				if WarnText then
					SelectLayoutText.Text = WarnText
					SelectLayoutText.TextColor3 = Color3.new(0.776471, 0.0588235, 0.0588235)
					wait(1)
				end
				SelectLayoutText.Text = "No layout selected"
				SelectLayoutText.TextColor3 = Color3.new(0.698039, 0.698039, 0.698039)
			end

			if #_Selection>0 then
				if #_Selection == 1 then
					_Selection = _Selection[1]
					if _Selection:IsA("Model") then
						SelectLayout()
					else
						UnselectLayout("Select a model!")
						warn("Coaster Tool Pack: Layout Editor: Select a Model, not a ".._Selection.ClassName)
					end
				else
					UnselectLayout("Multiple objects selected!")
					warn("Coaster Tool Pack: Layout Editor: Multiple objects selected!")
				end
			else
				UnselectLayout("Select a layout!")
				warn("Coaster Tool Pack: Layout Editor: No layout selected!")
			end
			SelectLayoutDebounce = true
		end
	end)
	
	-------------------------------------------
	--VALUES
	local ValueSettings = LayoutEditorUI:FindFirstChild("EditValues",true)
	
	local Values = {}
	
	for _,Value in pairs(ValueSettings.List:GetChildren()) do
		if Value:IsA("TextButton") then
			Values[Value.Name] = nil
			if Value.Name ~= "Fill" then
				local TextBox = Value.Frame.TextBox
				if Value.Name == "Start" or Value.Name == "End" then
					Value.MouseButton1Click:Connect(function ()
						local Node = Selection:Get()
						if Node[1] then
							if Node[1]:IsA("BasePart") and tonumber(Node[1].Name) then
								TextBox.Text = Node[1].Name
								Values[Value.Name] = tonumber(TextBox.Text)
							end
						end
						
					end)
				elseif Value.Name == "Interval" then
					
				end
				
				TextBox.FocusLost:Connect(function()
					if TextBox.Text == nil or not tonumber(TextBox.Text) then
						TextBox.Text = ""
						Values[Value.Name] = nil
					else
						Values[Value.Name] = tonumber(TextBox.Text)
					end
				end)
			else
				
			end
		end
	end
	
	-------------------------------------------
	--EDIT
	local Edit = require(script.Edit)

	local EditButton = LayoutEditorUI:FindFirstChild("Edit",true)
	
	local EditDebounce = true
	EditButton.MouseButton1Click:Connect(function()
		if EditDebounce then
			EditDebounce = false
			if Layout then
			
				Edit(Layout,Values["Start"],Values["End"],Values["Interval"])
			end
			EditDebounce = true
		end
		
		
	end)
	
	
	local EditDistance = require(script.EditDistance)

	local EditDistanceButton = LayoutEditorUI:FindFirstChild("EditDistance",true)

	local EditDistanceDebounce = true
	EditDistanceButton.MouseButton1Click:Connect(function()
		if EditDistanceDebounce then
			EditDebounce = false
			if Layout then

				EditDistance(Layout,Values["Start"],Values["End"],Values["Interval"])
			end
			EditDebounce = true
		end


	end)
	
	
	local EditNoFillButton = LayoutEditorUI:FindFirstChild("EditNoFill",true)
	EditNoFillButton.MouseButton1Click:Connect(function()
		if EditDebounce then
			EditDebounce = false
			if Layout then
				----print("LAYOUT")
				Edit(Layout,Values["Start"],Values["End"],Values["Interval"],Values["Skip"],BrickColor.new("Really red"))
			end
			EditDebounce = true
		end


	end)

	-------------------------------------------
	--TRANSPARENCY
	local SetTransparencyButton = LayoutEditorUI:FindFirstChild("SetTransparency",true)
	local SetTransparencyTextBox = SetTransparencyButton.Valuebox.Frame.TextBox
	
	SetTransparencyButton.MouseButton1Click:Connect(function()
		if Layout then
			for _, node in ipairs(Layout:GetChildren()) do
				if node:IsA("BasePart") then
					node.Transparency = tonumber(SetTransparencyTextBox.Text)
				end
			end
		end
	end)
	
	SetTransparencyTextBox.FocusLost:Connect(function()
		if not tonumber(SetTransparencyTextBox.Text) then
			SetTransparencyTextBox.Text = "0"
		end
	end)
	
	-------------------------------------------
	--ENUMERATE
	local EnumerateLayoutButton = LayoutEditorUI:FindFirstChild("EnumerateLayout",true)
	local EnumerateLayoutDebouce = true
	
	EnumerateLayoutButton.MouseButton1Click:Connect(function()
		if EnumerateLayoutDebouce == true then
			EnumerateLayoutDebouce = false
			if Layout then
				local points = Layout
				local pointsNumber = #points:GetChildren()

				if points then
					local Params = RaycastParams.new()
					Params.FilterType = Enum.RaycastFilterType.Whitelist
					Params.FilterDescendantsInstances = points:GetChildren()
					Params.IgnoreWater = true


					local _1 = points:FindFirstChild("1")

					if _1 and pointsNumber>2 then

						local currentNode = _1
						local success = true

						for i = 2,pointsNumber,1 do
							if success then
								if  currentNode then
									local RaycastResult = workspace:Raycast(currentNode.Position, currentNode.CFrame.LookVector*3,Params)
									if RaycastResult then 
										RaycastResult.Instance.Name = tostring(i)
									else
										success = false
										warn("Coaster Tool Pack: Failed numbering layout at: ["..tostring(i).."]")
									end
									currentNode = points:FindFirstChild(tostring(i))
								else
									success = false
									warn("Coaster Tool Pack: Failed numbering, couldn't find node: ["..tostring(i).."]")
								end
							end
						end
					else 
						if not _1 then
							warn('Coaster Tool Pack: Layout needs a node named "1"')
						end
						if not (pointsNumber>2) then
							warn("Coaster Tool Pack: Layout needs more nodes")
						end
					end
				else
					warn("Coaster Tool Pack: Select a layout")
				end
				ChangeHistoryService:SetWaypoint("Layout edit. Numbered")
			end
			EnumerateLayoutDebouce = true
		end
	end)
	
	
end
return LayoutEditor

