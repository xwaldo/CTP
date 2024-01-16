local TrackElements = {}

function TrackElements.SmoothNormals(part)
	if part:IsA("Part") then
		part.FrontSurface = Enum.SurfaceType.Smooth
		part.BackSurface = Enum.SurfaceType.Smooth
		part.LeftSurface = Enum.SurfaceType.Smooth
		part.RightSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		part.TopSurface = Enum.SurfaceType.Smooth
	end
end

for _, module in pairs(script:GetChildren()) do
	TrackElements[module.Name] = require(module)
end

for _, module in pairs(script:GetChildren()) do
	TrackElements[module.Name]:Init(TrackElements)
	TrackElements[module.Name] = TrackElements[module.Name].new
end

return TrackElements


