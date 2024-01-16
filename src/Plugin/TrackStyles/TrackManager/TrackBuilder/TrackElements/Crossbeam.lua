local Crossbeam = {}

Crossbeam.__index = Crossbeam

local TrackElements

function Crossbeam:Init(_TrackElements)
	TrackElements = _TrackElements
end

function Crossbeam.new(current,previous,element,parent,name,TrackModule,Connector,Invert)
	
	-------CREATE Crossbeam AND SET PROPERTIES----------------
	local CrossbeamElement
	
	--Crossbeam TYPE
	
	
	if element.Shape then
		CrossbeamElement = Instance.new("Part")
		CrossbeamElement.Shape = element.Shape
	elseif element.Mesh then
		CrossbeamElement = element.Mesh:Clone()
	else
		CrossbeamElement = script.PGSRail:Clone()
	end
	CrossbeamElement.CanCollide = element.CanCollide or false
	CrossbeamElement.Anchored = true
	CrossbeamElement.Parent = parent
	CrossbeamElement.Name = name

	if element.Color then
		if typeof(element.Color) == "BrickColor" then
			CrossbeamElement.Color = element.Color
		else
			CrossbeamElement.Color = TrackModule:GetAttribute("Color"..element.Color) or Color3.new(0.917647, 0, 1)
		end
	end
	
	if element.Material then
		if typeof(element.Material) == "EnumItem" then
			CrossbeamElement.Material = element.Material
		else
			CrossbeamElement.Material = Enum.Material[TrackModule:GetAttribute("Material")]
		end
	end
	-----------------------------------------------------
	
	local offsetCurrent = element.Offset or element.OffsetCurrent
	local offsetPrevious = element.Offset or element.OffsetPrevious
	
	if Invert then
		local InvertSave = offsetPrevious
		offsetPrevious = offsetCurrent
		
		
		offsetPrevious = Vector3.new(offsetPrevious.X,offsetPrevious.Y,offsetPrevious.Z*-1)
		
		offsetCurrent = InvertSave
		
		offsetCurrent = Vector3.new(offsetCurrent.X,offsetCurrent.Y,offsetCurrent.Z*-1)

	end
	
	
	local size = element.Size or Vector3.new(1,1,1)

	-----------------------------------------------------------------------------------------------
	local _current = current*CFrame.new(offsetCurrent)
	local _previous = previous*CFrame.new(offsetPrevious)
	
	if element.SizeAxis then
		if element.SizeAxis == "X" then
			CrossbeamElement.Size = Vector3.new((_previous.Position-_current.Position).Magnitude,size.Y,size.Z)
		elseif element.SizeAxis == "Y" then
			CrossbeamElement.Size = Vector3.new(size.X,(_previous.Position-_current.Position).Magnitude,size.Z)
		elseif element.SizeAxis == "Z" then
			CrossbeamElement.Size = Vector3.new(size.X,size.Y,(_previous.Position-_current.Position).Magnitude)

		end
	else
		CrossbeamElement.Size = Vector3.new(size.X,(_previous.Position-_current.Position).Magnitude+0.04,size.Y)
	end
	-------------SOLVE Crossbeam------------------------------------------------------------------------
	do
		local rotprevious = (offsetPrevious)+Vector3.new(0,3,0)
		local rotcurrent = (offsetCurrent)+Vector3.new(0,3,0)
		local standardCFrame = CFrame.new((current*CFrame.new(rotcurrent).Position):Lerp((previous*CFrame.new(rotprevious).Position),0.5),(current*CFrame.new(rotcurrent).Position))

		local difference = ((offsetCurrent) + (offsetPrevious))/2-(rotcurrent+rotprevious)/2
		local testCFrame = CFrame.new(_current.Position:Lerp(_previous.Position,0.5),_current.Position)
		local distance = ((testCFrame*CFrame.new(-difference)).Position-standardCFrame.Position).Magnitude
		local rotation = 0
		
		local rotreps = 128
		
		for i = 1, rotreps do
			testCFrame = testCFrame*CFrame.Angles(0,0,2 * math.pi/rotreps)
			local testDif = ((testCFrame * CFrame.new(-difference)).Position - standardCFrame.Position).Magnitude
			if testDif < distance then
				distance = testDif
				rotation = i
			end
		end

		local partRotation = Vector3.new(0,0,0)
		
		CrossbeamElement.CFrame = CFrame.new(_current.Position:Lerp(_previous.Position,0.5),_current.Position)*CFrame.Angles(0,0,rotation*2*math.pi/rotreps)*CFrame.Angles(partRotation.X,partRotation.Y,partRotation.Z)
	end
	
	
	
	if not element.SizeAxis then

		CrossbeamElement.CFrame *= CFrame.Angles(math.rad(90),0,0)
	end
	
	if element.OrientationOffset then
		CrossbeamElement.CFrame *= CFrame.Angles(math.rad(element.OrientationOffset.X),math.rad(element.OrientationOffset.Y),math.rad(element.OrientationOffset.z))
	end
	
	if TrackModule:GetAttribute("CrossbeamDirection") ~= nil then
		if TrackModule:GetAttribute("CrossbeamDirection") == false then
			CrossbeamElement.CFrame *= CFrame.Angles(0,0,math.rad(180))
			
		end
	end

end

return Crossbeam
