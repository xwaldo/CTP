local PluginManager = {}

local plugin
local resources

function PluginManager:Init(_plugin,_resources)
	plugin = _plugin
	resources = _resources
end

function PluginManager:Plugin()
	return plugin
end

function PluginManager:Resources()
	return resources
end


return PluginManager
