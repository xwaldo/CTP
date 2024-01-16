local ChangeHistoryService = game:GetService("ChangeHistoryService")



function Edit(Layout,_Start,End,_Interval,_Skip,FillColor)
	
	local Points = Layout:GetChildren()
	local Start = _Start or 1
	local Interval
	
	if _Interval then
		Interval = _Interval+1
	else
		Interval = 1
	end
	
	local Skip = _Skip or 0

	
	if _Interval then
		Interval = (_Interval*Skip)+(Skip)+(_Interval)+1
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
	

	Layout[tostring(Start)].BrickColor = BrickColor.new("Medium stone grey")

	for i = Start,End,1 do 
		
		if not Layout:FindFirstChild(tostring(i)) then
			warn("Coaster Tool Pack: Layout Editor: Couldn't find node "..tostring(i))
			continue
		end
		
		if ((i-Start))%Interval == 0 then
			if FillColor then
				Layout[tostring(i)].BrickColor = FillColor
			else
				Layout[tostring(i)].BrickColor = BrickColor.new("Medium stone grey")
			end
			
			
		elseif _Skip == nil then

			Layout[tostring(i)].BrickColor = BrickColor.new("White")
		end

	end
	ChangeHistoryService:SetWaypoint("Layout edit. Interval: "..tostring(_Interval))

end


return Edit
