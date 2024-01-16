local TwistedBox = {}

local CreateTriangle = require(script.Triangle).Solve

local CreatePaintedQuad = require(script.PaintedQuad).CreatePaintedQuad

TwistedBox.__index = TwistedBox

local TrackElements


function TwistedBox:Init(_TrackElements)
	TrackElements = _TrackElements
end

function TwistedBox.new(current,previous,element,parent,name,TrackModule)
	local SupportNodes = TrackModule:GetAttribute("ToggleSupNodes")
	local ElementColor
	
	if element.Color then
		if typeof(element.Color) == "BrickColor" then
			ElementColor = element.Color
		else
			ElementColor = TrackModule:GetAttribute("Color"..element.Color) or Color3.new(0.917647, 0, 1)
		end
	end
	
	local offsetCurrent = element.Offset or element.OffsetCurrent
	local offsetPrevious = element.Offset or element.OffsetPrevious
	
	local _current = current*CFrame.new(offsetCurrent)
	local _previous = previous*CFrame.new(offsetPrevious)
	
	local TwistedBoxModel = Instance.new("Model",parent)
	TwistedBoxModel.Name = "TwistedBox"
	
	local size = element.Width or 1
	local currentheight = TrackModule:GetAttribute("SpineHeight") or 0
	local previousheight = TrackModule:GetAttribute("SpineHeightPrevious") or 0
	
	--TOP
	local TwistedBoxStyle = require(script[TrackModule.Name])
	TwistedBoxStyle:Init(CreateTriangle,CreatePaintedQuad,_current,_previous,size,currentheight,previousheight,ElementColor,TrackModule:GetAttribute("ColorSpine"),TrackModule:GetAttribute("ColorStyle"),TrackModule:GetAttribute("SpineStyle"),TwistedBoxModel,SupportNodes)
	
	
end

return TwistedBox
