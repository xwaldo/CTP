local Tracks = {}

for _, Track in pairs(script:GetChildren()) do
	Tracks[Track.Name] = require(Track)
end

return Tracks
