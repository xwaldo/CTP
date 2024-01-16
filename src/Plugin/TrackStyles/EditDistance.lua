local ChangeHistoryService = game:GetService("ChangeHistoryService")



function Edit(Layout,_Start,End,_Interval)

	local Points = Layout:GetChildren()
	local Start = _Start or 1
	local Interval = _Interval or 1
	
	if Interval< 5 then
		Interval = 5
	end
	
	
	-- IF START IS LOWER AND E THAN 0 SET START TO 1
	if Start then
		if Start <= 0 or Start == nil then
			Start = 1
		end
	else
		Start = 1
	end
	if End then
		if End <= 0 or End>#Points then
			End = #Points
		end
	else
		End = #Points
	end


	Layout[tostring(Start)].BrickColor = BrickColor.new("Really blue")
	
	local currentDistance = 0
	
	for i = Start,End,1 do 

		
		if i == Start then
			continue
		else
			if not Layout:FindFirstChild(tostring(i)) then
				warn("Coaster Tool Pack: Layout Editor: Couldn't find node "..tostring(i))
				continue
			end
			
			local Distance1 = Vector3.new(Layout:FindFirstChild(tostring(i-1)).Position.X,0,Layout:FindFirstChild(tostring(i-1)).Position.Z)
			local Distance2 = Vector3.new(Layout:FindFirstChild(tostring(i)).Position.X,0,Layout:FindFirstChild(tostring(i)).Position.Z)
			currentDistance = currentDistance + (Distance1-Distance2).Magnitude
			
			if currentDistance>Interval then
				Layout[tostring(i)].BrickColor = BrickColor.new("Really blue")
				currentDistance = 0
			else
				Layout[tostring(i)].BrickColor = BrickColor.new("White")
			end
			
			
			
		end
		
		

	end
	ChangeHistoryService:SetWaypoint("Layout edit. Interval: "..tostring(_Interval))

end


return Edit
