local Rail = {}
local Stripe = require(script.Stripe)

Rail.__index = Rail

local TrackElements

function Rail:Init(_TrackElements)
	TrackElements = _TrackElements
end

function Rail.new(current,previous,element,parent,name,TrackModule,PGS)

	-------CREATE RAIL AND SET PROPERTIES----------------
	local RailElement

	--RAIL TYPE
	if element.Shape then
		RailElement = Instance.new("Part")
		RailElement.Shape = element.Shape
	elseif element.Mesh then
		RailElement = element.Mesh:Clone()
	else
		RailElement = script.PGSRail:Clone()
	end

	RailElement.Anchored = true
	RailElement.Parent = parent
	RailElement.Name = name
	RailElement.CanCollide = element.CanCollide or false

	if element.Color then
		if typeof(element.Color) == "BrickColor" then
			RailElement.Color = element.Color
		else
			RailElement.Color = TrackModule:GetAttribute("Color"..element.Color) or Color3.new(0.917647, 0, 1)
		end
	end

	if element.Material then
		if typeof(element.Material) == "EnumItem" then
			RailElement.Material = element.Material
		else
			RailElement.Material = Enum.Material[TrackModule:GetAttribute("Material")]
		end
	end
	-----------------------------------------------------

	local offsetCurrent = element.Offset or element.OffsetCurrent
	local offsetPrevious = element.Offset or element.OffsetPrevious
	local size = element.Size or Vector3.new(1,1,1)

	-----------------------------------------------------------------------------------------------
	local _current = current*CFrame.new(offsetCurrent)
	local _previous = previous*CFrame.new(offsetPrevious)
	--[[
	if element.Shape then
		if current.Orientation.X-previous.Orientation.X<0 then
			_current *= CFrame.new(0,0,-size.Z/2)
		else
			_current *= CFrame.new(0,0,size.Z/2)
		end
	end
	--]]
	
	
	if element.SizeAxis then
		if element.SizeAxis == "X" then
			RailElement.Size = Vector3.new((_previous.Position-_current.Position).Magnitude+(if element.Shape then 0 else 0.04),size.X,size.Y)
		else
			RailElement.Size = Vector3.new(size.X,(_previous.Position-_current.Position).Magnitude+(if element.Shape then 0 else 0.04),size.Y)
		end

	else
		RailElement.Size = Vector3.new(size.X,(_previous.Position-_current.Position).Magnitude+(if element.Shape then 0 else 0.04),size.Y)
	end




	-------------SOLVE RAIL------------------------------------------------------------------------
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
		
		RailElement.CFrame = CFrame.new(_current.Position:Lerp(_previous.Position,0.5),_current.Position)*CFrame.Angles(0,0,rotation*2*math.pi/rotreps)*CFrame.Angles(partRotation.X,partRotation.Y,partRotation.Z)
	end
	--[[
	if element.Shape then
		if current.Orientation.X-previous.Orientation.X<0 then
			RailElement.CFrame *= CFrame.new(0,0,size.Z/2)
		else
			RailElement.CFrame *= CFrame.new(0,0,-size.Z/2)
		end
	end
	]]
	RailElement.CFrame *= CFrame.Angles(math.rad(90),0,0)

	if element.RotationOffset then
		RailElement.CFrame *= CFrame.Angles(element.RotationOffset.X,element.RotationOffset.Y,element.RotationOffset.Z)
	end


	if PGS and element.PGS then

		RailElement.Velocity = RailElement.CFrame.UpVector*TrackModule:GetAttribute("Velocity")*-1
		RailElement.CustomPhysicalProperties = PhysicalProperties.new(
			TrackModule:GetAttribute("Density"),
			TrackModule:GetAttribute("Friction"),
			TrackModule:GetAttribute("Elasticity")
		)
	end



	if TrackModule:GetAttribute("ToggleStripes") and element.Stripe then
		
		Stripe:Solve(current,previous,element,TrackModule,RailElement)
	end

	return RailElement


end

return Rail
