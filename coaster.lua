local scriptParent = script.Parent
local isDebugDescendant = scriptParent:IsDescendantOf(game:GetService("PluginDebugService"))
local toolbarName = isDebugDescendant and "DataStore Editor - DEV" or "DataStore Editor"
local pluginToolbar = plugin:CreateToolbar(toolbarName)
local editorButton = pluginToolbar:CreateButton("DataStoreEditor", "DataStoreEditor", "rbxassetid://5523059345", "DataStore Editor")
local isEditorActive = false
local isModuleLoaded = false
local editorData = { Plugin = plugin, Modules = {}, UI = {} }

local function LoadModules(folder, moduleTable)
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("ModuleScript") then
            moduleTable[child.Name] = require(child)
        elseif child:IsA("Folder") and child:FindFirstChildOfClass("ModuleScript") then
            local submoduleTable = {}
            moduleTable[child.Name] = submoduleTable
            LoadModules(child, submoduleTable)
        end
    end
end

local function LoadPluginModules()
    for _, moduleScript in ipairs(scriptParent.Plugin:GetChildren()) do
        if moduleScript:IsA("ModuleScript") then
            local module = require(moduleScript)
            editorData.Modules[moduleScript.Name] = module
            setmetatable(module, { __index = editorData })
        end
    end

    local initCount = 0
    local initCompleteCount = 0
    local initCoroutine = coroutine.running()

    for moduleName, moduleInstance in pairs(editorData.Modules) do
        if type(moduleInstance.Init) == "function" then
            initCount = initCount + 1
            task.defer(function()
                debug.setmemorycategory(moduleName)
                moduleInstance:Init()
                debug.resetmemorycategory()
                initCompleteCount = initCompleteCount + 1
                if initCompleteCount >= initCount and coroutine.status(initCoroutine) == "suspended" then
                    task.spawn(initCoroutine)
                end
            end)
        end
    end

    if initCompleteCount < initCount then
        coroutine.yield()
    end

    for moduleName, moduleInstance in pairs(editorData.Modules) do
        if type(moduleInstance.Start) == "function" then
            task.spawn(moduleInstance.Start, moduleInstance)
        end
    end
end

local function ButtonClicked()
    isEditorActive = not isEditorActive
    editorButton:SetActive(isEditorActive)

    if isEditorActive and not isModuleLoaded then
        isModuleLoaded = true
        LoadModules(scriptParent.UI, editorData.UI)
        LoadPluginModules()

        editorData.Modules.PluginWidget.Disabled:Connect(function()
            if isEditorActive then
                ButtonClicked()
            end
        end)
    end

    if isEditorActive then
        editorData.Modules.App:Mount()
    else
        editorData.Modules.App:Unmount()
    end

    editorData.Modules.PluginWidget:SetEnabled(isEditorActive)
end

editorButton.Click:Connect(ButtonClicked)

plugin.Unloading:Connect(function()
    if isEditorActive then
        ButtonClicked()
    end
end)