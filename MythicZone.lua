--[[

    MythicZone Interface Suite
    Based on Rayfield by Sirius
    Modified for personal use only

]]

if debugX then
    warn('Initialising MythicZone')
end

local function getService(name)
    local service = game:GetService(name)
    return if cloneref then cloneref(service) else service
end

-- Loads and executes a function hosted on a remote URL. Cancels the request if the requested URL takes too long to respond.
local function loadWithTimeout(url: string, timeout: number?): ...any
    assert(type(url) == "string", "Expected string, got " .. type(url))
    timeout = timeout or 5
    local requestCompleted = false
    local success, result = false, nil

    local requestThread = task.spawn(function()
        local fetchSuccess, fetchResult = pcall(game.HttpGet, game, url) -- game:HttpGet(url)
        -- If the request fails the content can be empty, even if fetchSuccess is true
        if not fetchSuccess or #fetchResult == 0 then
            if #fetchResult == 0 then
                fetchResult = "Empty response" -- Set the error message
            end
            success, result = false, fetchResult
            requestCompleted = true
            return
        end
        local content = fetchResult -- Fetched content
        local execSuccess, execResult = pcall(function()
            return loadstring(content)()
        end)
        success, result = execSuccess, execResult
        requestCompleted = true
    end)

    local timeoutThread = task.delay(timeout, function()
        if not requestCompleted then
            warn(`Request for {url} timed out after {timeout} seconds`)
            task.cancel(requestThread)
            result = "Request timed out"
            requestCompleted = true
        end
    end)

    -- Wait for completion or timeout
    while not requestCompleted do
        task.wait()
    end
    -- Cancel timeout thread if still running when request completes
    if coroutine.status(timeoutThread) ~= "dead" then
        task.cancel(timeoutThread)
    end
    if not success then
        warn(`Failed to process {url}: {result}`)
    end
    return if success then result else nil
end

local requestsDisabled = true
local InterfaceBuild = 'MZ01'
local Release = "Version 1.0"
local MythicFolder = "MythicZone"
local ConfigurationFolder = MythicFolder.."/Configurations"
local ConfigurationExtension = ".mzconfig"
local settingsTable = {
    General = {
        mythiczoneOpen = {Type = 'bind', Value = 'K', Name = 'MythicZone Keybind'},
    },
    System = {
        usageAnalytics = {Type = 'toggle', Value = false, Name = 'Anonymised Analytics'},
    }
}

local HttpService = getService('HttpService')
local RunService = getService('RunService')

-- Environment Check
local useStudio = RunService:IsStudio() or false

local settingsCreated = false
local cachedSettings
local request = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request

local function loadSettings()
    local file = nil
    
    local success, result = pcall(function()
        task.spawn(function()
            if isfolder and isfolder(MythicFolder) then
                if isfile and isfile(MythicFolder..'/settings'..ConfigurationExtension) then
                    file = readfile(MythicFolder..'/settings'..ConfigurationExtension)
                end
            end

            -- for debug in studio
            if useStudio then
                file = [[
        {"General":{"mythiczoneOpen":{"Value":"K","Type":"bind","Name":"MythicZone Keybind","Element":{"HoldToInteract":false,"Ext":true,"Name":"MythicZone Keybind","Set":null,"CallOnChange":true,"Callback":null,"CurrentKeybind":"K"}}},"System":{"usageAnalytics":{"Value":false,"Type":"toggle","Name":"Anonymised Analytics","Element":{"Ext":true,"Name":"Anonymised Analytics","Set":null,"CurrentValue":false,"Callback":null}}}}
    ]]
            end

            if file then
                local success, decodedFile = pcall(function() return HttpService:JSONDecode(file) end)
                if success then
                    file = decodedFile
                else
                    file = {}
                end
            else
                file = {}
            end

            if not settingsCreated then 
                cachedSettings = file
                return
            end

            if file ~= {} then
                for categoryName, settingCategory in pairs(settingsTable) do
                    if file[categoryName] then
                        for settingName, setting in pairs(settingCategory) do
                            if file[categoryName][settingName] then
                                setting.Value = file[categoryName][settingName].Value
                                setting.Element:Set(setting.Value)
                            end
                        end
                    end
                end
            end
        end)
    end)
    
    if not success then 
        if writefile then
            warn('MythicZone had an issue accessing configuration saving capability.')
        end
    end
end

if debugX then
    warn('Now Loading Settings Configuration')
end

loadSettings()

if debugX then
    warn('Settings Loaded')
end

if debugX then
    warn('Moving on to continue initialisation')
end

local MythicLibrary = {
    Flags = {},
    Theme = {
        Default = {
            TextColor = Color3.fromRGB(240, 240, 240),

            Background = Color3.fromRGB(25, 25, 35),
            Topbar = Color3.fromRGB(35, 35, 45),
            Shadow = Color3.fromRGB(20, 20, 30),

            NotificationBackground = Color3.fromRGB(20, 20, 30),
            NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

            TabBackground = Color3.fromRGB(80, 80, 120),
            TabStroke = Color3.fromRGB(85, 85, 125),
            TabBackgroundSelected = Color3.fromRGB(120, 120, 210),
            TabTextColor = Color3.fromRGB(240, 240, 240),
            SelectedTabTextColor = Color3.fromRGB(240, 240, 240),

            ElementBackground = Color3.fromRGB(35, 35, 45),
            ElementBackgroundHover = Color3.fromRGB(40, 40, 50),
            SecondaryElementBackground = Color3.fromRGB(25, 25, 35),
            ElementStroke = Color3.fromRGB(50, 50, 90),
            SecondaryElementStroke = Color3.fromRGB(40, 40, 70),

            SliderBackground = Color3.fromRGB(60, 60, 180),
            SliderProgress = Color3.fromRGB(80, 80, 220),
            SliderStroke = Color3.fromRGB(70, 70, 200),

            ToggleBackground = Color3.fromRGB(30, 30, 40),
            ToggleEnabled = Color3.fromRGB(80, 80, 220),
            ToggleDisabled = Color3.fromRGB(100, 100, 100),
            ToggleEnabledStroke = Color3.fromRGB(90, 90, 240),
            ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
            ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 200),
            ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),

            DropdownSelected = Color3.fromRGB(40, 40, 60),
            DropdownUnselected = Color3.fromRGB(30, 30, 40),

            InputBackground = Color3.fromRGB(30, 30, 40),
            InputStroke = Color3.fromRGB(65, 65, 85),
            PlaceholderColor = Color3.fromRGB(178, 178, 178)
        },

        Neon = {
            TextColor = Color3.fromRGB(230, 240, 255),

            Background = Color3.fromRGB(15, 15, 25),
            Topbar = Color3.fromRGB(20, 20, 30),
            Shadow = Color3.fromRGB(10, 10, 15),

            NotificationBackground = Color3.fromRGB(20, 20, 30),
            NotificationActionsBackground = Color3.fromRGB(230, 230, 255),

            TabBackground = Color3.fromRGB(40, 40, 80),
            TabStroke = Color3.fromRGB(50, 50, 100),
            TabBackgroundSelected = Color3.fromRGB(100, 100, 255),
            TabTextColor = Color3.fromRGB(220, 220, 255),
            SelectedTabTextColor = Color3.fromRGB(240, 240, 255),

            ElementBackground = Color3.fromRGB(25, 25, 35),
            ElementBackgroundHover = Color3.fromRGB(30, 30, 45),
            SecondaryElementBackground = Color3.fromRGB(20, 20, 30),
            ElementStroke = Color3.fromRGB(45, 45, 90),
            SecondaryElementStroke = Color3.fromRGB(40, 40, 80),

            SliderBackground = Color3.fromRGB(30, 30, 100),
            SliderProgress = Color3.fromRGB(60, 60, 210),
            SliderStroke = Color3.fromRGB(50, 50, 160),

            ToggleBackground = Color3.fromRGB(25, 25, 35),
            ToggleEnabled = Color3.fromRGB(70, 70, 230),
            ToggleDisabled = Color3.fromRGB(70, 70, 90),
            ToggleEnabledStroke = Color3.fromRGB(80, 80, 255),
            ToggleDisabledStroke = Color3.fromRGB(85, 85, 115),
            ToggleEnabledOuterStroke = Color3.fromRGB(60, 60, 190),
            ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 75),

            DropdownSelected = Color3.fromRGB(30, 30, 60),
            DropdownUnselected = Color3.fromRGB(25, 25, 40),

            InputBackground = Color3.fromRGB(25, 25, 35),
            InputStroke = Color3.fromRGB(50, 50, 100),
            PlaceholderColor = Color3.fromRGB(140, 140, 170)
        },

        Sunset = {
            TextColor = Color3.fromRGB(255, 245, 230),

            Background = Color3.fromRGB(40, 20, 30),
            Topbar = Color3.fromRGB(50, 25, 35),
            Shadow = Color3.fromRGB(35, 15, 20),

            NotificationBackground = Color3.fromRGB(45, 25, 35),
            NotificationActionsBackground = Color3.fromRGB(245, 230, 215),

            TabBackground = Color3.fromRGB(75, 35, 45),
            TabStroke = Color3.fromRGB(90, 45, 55),
            TabBackgroundSelected = Color3.fromRGB(210, 100, 120),
            TabTextColor = Color3.fromRGB(250, 220, 200),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),

            ElementBackground = Color3.fromRGB(55, 30, 40),
            ElementBackgroundHover = Color3.fromRGB(70, 35, 45),
            SecondaryElementBackground = Color3.fromRGB(50, 25, 35),
            ElementStroke = Color3.fromRGB(90, 50, 70),
            SecondaryElementStroke = Color3.fromRGB(80, 45, 65),

            SliderBackground = Color3.fromRGB(180, 60, 80),
            SliderProgress = Color3.fromRGB(240, 100, 120),
            SliderStroke = Color3.fromRGB(200, 80, 100),

            ToggleBackground = Color3.fromRGB(55, 30, 40),
            ToggleEnabled = Color3.fromRGB(230, 85, 110),
            ToggleDisabled = Color3.fromRGB(90, 60, 70),
            ToggleEnabledStroke = Color3.fromRGB(255, 100, 130),
            ToggleDisabledStroke = Color3.fromRGB(110, 75, 85),
            ToggleEnabledOuterStroke = Color3.fromRGB(190, 70, 90),
            ToggleDisabledOuterStroke = Color3.fromRGB(70, 45, 55),

            DropdownSelected = Color3.fromRGB(65, 35, 45),
            DropdownUnselected = Color3.fromRGB(50, 25, 35),

            InputBackground = Color3.fromRGB(55, 30, 40),
            InputStroke = Color3.fromRGB(85, 45, 65),
            PlaceholderColor = Color3.fromRGB(170, 120, 140)
        },

        Emerald = {
            TextColor = Color3.fromRGB(230, 255, 230),

            Background = Color3.fromRGB(15, 35, 25),
            Topbar = Color3.fromRGB(20, 45, 30),
            Shadow = Color3.fromRGB(10, 30, 20),

            NotificationBackground = Color3.fromRGB(20, 40, 30),
            NotificationActionsBackground = Color3.fromRGB(230, 255, 230),

            TabBackground = Color3.fromRGB(30, 75, 50),
            TabStroke = Color3.fromRGB(35, 85, 60),
            TabBackgroundSelected = Color3.fromRGB(40, 160, 120),
            TabTextColor = Color3.fromRGB(220, 255, 220),
            SelectedTabTextColor = Color3.fromRGB(240, 255, 240),

            ElementBackground = Color3.fromRGB(25, 50, 35),
            ElementBackgroundHover = Color3.fromRGB(30, 60, 40),
            SecondaryElementBackground = Color3.fromRGB(20, 40, 30),
            ElementStroke = Color3.fromRGB(45, 95, 70),
            SecondaryElementStroke = Color3.fromRGB(40, 80, 60),

            SliderBackground = Color3.fromRGB(30, 130, 90),
            SliderProgress = Color3.fromRGB(40, 180, 120),
            SliderStroke = Color3.fromRGB(35, 150, 105),

            ToggleBackground = Color3.fromRGB(25, 50, 35),
            ToggleEnabled = Color3.fromRGB(40, 190, 120),
            ToggleDisabled = Color3.fromRGB(70, 90, 80),
            ToggleEnabledStroke = Color3.fromRGB(50, 210, 140),
            ToggleDisabledStroke = Color3.fromRGB(85, 105, 95),
            ToggleEnabledOuterStroke = Color3.fromRGB(45, 170, 110),
            ToggleDisabledOuterStroke = Color3.fromRGB(60, 75, 70),

            DropdownSelected = Color3.fromRGB(35, 70, 50),
            DropdownUnselected = Color3.fromRGB(25, 45, 35),

            InputBackground = Color3.fromRGB(25, 50, 35),
            InputStroke = Color3.fromRGB(50, 100, 75),
            PlaceholderColor = Color3.fromRGB(140, 180, 150)
        },

        Midnight = {
            TextColor = Color3.fromRGB(225, 225, 255),

            Background = Color3.fromRGB(15, 15, 25),
            Topbar = Color3.fromRGB(20, 20, 30),
            Shadow = Color3.fromRGB(10, 10, 15),

            NotificationBackground = Color3.fromRGB(20, 20, 30),
            NotificationActionsBackground = Color3.fromRGB(220, 220, 250),

            TabBackground = Color3.fromRGB(30, 30, 45),
            TabStroke = Color3.fromRGB(40, 40, 60),
            TabBackgroundSelected = Color3.fromRGB(60, 60, 150),
            TabTextColor = Color3.fromRGB(220, 220, 250),
            SelectedTabTextColor = Color3.fromRGB(240, 240, 255),

            ElementBackground = Color3.fromRGB(25, 25, 35),
            ElementBackgroundHover = Color3.fromRGB(30, 30, 45),
            SecondaryElementBackground = Color3.fromRGB(20, 20, 30),
            ElementStroke = Color3.fromRGB(45, 45, 70),
            SecondaryElementStroke = Color3.fromRGB(35, 35, 55),

            SliderBackground = Color3.fromRGB(40, 40, 100),
            SliderProgress = Color3.fromRGB(60, 60, 180),
            SliderStroke = Color3.fromRGB(50, 50, 150),

            ToggleBackground = Color3.fromRGB(25, 25, 35),
            ToggleEnabled = Color3.fromRGB(60, 60, 190),
            ToggleDisabled = Color3.fromRGB(70, 70, 90),
            ToggleEnabledStroke = Color3.fromRGB(70, 70, 210),
            ToggleDisabledStroke = Color3.fromRGB(85, 85, 115),
            ToggleEnabledOuterStroke = Color3.fromRGB(50, 50, 170),
            ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 70),

            DropdownSelected = Color3.fromRGB(30, 30, 55),
            DropdownUnselected = Color3.fromRGB(25, 25, 40),

            InputBackground = Color3.fromRGB(25, 25, 35),
            InputStroke = Color3.fromRGB(50, 50, 80),
            PlaceholderColor = Color3.fromRGB(140, 140, 170)
        },
    }
}

-- Services
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Players = getService("Players")
local CoreGui = getService("CoreGui")

-- Interface Management
local MythicZone = useStudio and script.Parent:FindFirstChild('MythicZone') or game:GetObjects("rbxassetid://10804731440")[1]
MythicZone.Name = "MythicZone"
local buildAttempts = 0
local correctBuild = true
local warned
local globalLoaded

MythicZone.Enabled = false

if gethui then
    MythicZone.Parent = gethui()
elseif syn and syn.protect_gui then 
    syn.protect_gui(MythicZone)
    MythicZone.Parent = CoreGui
elseif not useStudio and CoreGui:FindFirstChild("RobloxGui") then
    MythicZone.Parent = CoreGui:FindFirstChild("RobloxGui")
elseif not useStudio then
    MythicZone.Parent = CoreGui
end

if gethui then
    for _, Interface in ipairs(gethui():GetChildren()) do
        if Interface.Name == MythicZone.Name and Interface ~= MythicZone then
            Interface.Enabled = false
            Interface.Name = "MythicZone-Old"
        end
    end
elseif not useStudio then
    for _, Interface in ipairs(CoreGui:GetChildren()) do
        if Interface.Name == MythicZone.Name and Interface ~= MythicZone then
            Interface.Enabled = false
            Interface.Name = "MythicZone-Old"
        end
    end
end

local minSize = Vector2.new(1024, 768)
local useMobileSizing

if MythicZone.AbsoluteSize.X < minSize.X and MythicZone.AbsoluteSize.Y < minSize.Y then
    useMobileSizing = true
end

if UserInputService.TouchEnabled then
    useMobilePrompt = true
end

-- Object Variables
local Main = MythicZone.Main
Main.Title.Text = "MythicZone"
local MPrompt = MythicZone:FindFirstChild('Prompt')
if MPrompt then 
    MPrompt.Title.Text = "Show MythicZone"
end
local Topbar = Main.Topbar
local Elements = Main.Elements
local LoadingFrame = Main.LoadingFrame
local TabList = Main.TabList
local dragBar = MythicZone:FindFirstChild('Drag')
local dragInteract = dragBar and dragBar.Interact or nil
local dragBarCosmetic = dragBar and dragBar.Drag or nil

local dragOffset = 255
local dragOffsetMobile = 150

MythicZone.DisplayOrder = 100
LoadingFrame.Version.Text = Release

-- Thanks to Latte Softworks for the Lucide integration for Roblox
local Icons = useStudio and require(script.Parent.icons) or loadWithTimeout('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/icons.lua')
-- Variables

local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false
local searchOpen = false
local Notifications = MythicZone.Notifications

local SelectedTheme = MythicLibrary.Theme.Default

local function ChangeTheme(Theme)
    if typeof(Theme) == 'string' then
        SelectedTheme = MythicLibrary.Theme[Theme]
    elseif typeof(Theme) == 'table' then
        SelectedTheme = Theme
    end

    MythicZone.Main.BackgroundColor3 = SelectedTheme.Background
    MythicZone.Main.Topbar.BackgroundColor3 = SelectedTheme.Topbar
    MythicZone.Main.Topbar.CornerRepair.BackgroundColor3 = SelectedTheme.Topbar
    MythicZone.Main.Shadow.Image.ImageColor3 = SelectedTheme.Shadow

    MythicZone.Main.Topbar.ChangeSize.ImageColor3 = SelectedTheme.TextColor
    MythicZone.Main.Topbar.Hide.ImageColor3 = SelectedTheme.TextColor
    MythicZone.Main.Topbar.Search.ImageColor3 = SelectedTheme.TextColor
    if Topbar:FindFirstChild('Settings') then
        MythicZone.Main.Topbar.Settings.ImageColor3 = SelectedTheme.TextColor
        MythicZone.Main.Topbar.Divider.BackgroundColor3 = SelectedTheme.ElementStroke
    end

    Main.Search.BackgroundColor3 = SelectedTheme.TextColor
    Main.Search.Shadow.ImageColor3 = SelectedTheme.TextColor
    Main.Search.Search.ImageColor3 = SelectedTheme.TextColor
    Main.Search.Input.PlaceholderColor3 = SelectedTheme.TextColor
    Main.Search.UIStroke.Color = SelectedTheme.SecondaryElementStroke

    if Main:FindFirstChild('Notice') then
        Main.Notice.BackgroundColor3 = SelectedTheme.Background
    end

    for _, text in ipairs(MythicZone:GetDescendants()) do
        if text.Parent.Parent ~= Notifications then
            if text:IsA('TextLabel') or text:IsA('TextBox') then text.TextColor3 = SelectedTheme.TextColor end
        end
    end

    for _, TabPage in ipairs(Elements:GetChildren()) do
        for _, Element in ipairs(TabPage:GetChildren()) do
            if Element.ClassName == "Frame" and Element.Name ~= "Placeholder" and Element.Name ~= "SectionSpacing" and Element.Name ~= "Divider" and Element.Name ~= "SectionTitle" and Element.Name ~= "SearchTitle-fsefsefesfsefesfesfThanks" then
                Element.BackgroundColor3 = SelectedTheme.ElementBackground
                Element.UIStroke.Color = SelectedTheme.ElementStroke
            end
        end
    end
end

local function getIcon(name : string): {id: number, imageRectSize: Vector2, imageRectOffset: Vector2}
    if not Icons then
        warn("Lucide Icons: Cannot use icons as icons library is not loaded")
        return
    end
    name = string.match(string.lower(name), "^%s*(.*)%s*$") :: string
    local sizedicons = Icons['48px']
    local r = sizedicons[name]
    if not r then
        error(`Lucide Icons: Failed to find icon by the name of "{name}"`, 2)
    end

    local rirs = r[2]
    local riro = r[3]

    if type(r[1]) ~= "number" or type(rirs) ~= "table" or type(riro) ~= "table" then
        error("Lucide Icons: Internal error: Invalid auto-generated asset entry")
    end

    local irs = Vector2.new(rirs[1], rirs[2])
    local iro = Vector2.new(riro[1], riro[2])

    local asset = {
        id = r[1],
        imageRectSize = irs,
        imageRectOffset = iro,
    }

    return asset
end
-- Converts ID to asset URI. Returns rbxassetid://0 if ID is not a number
local function getAssetUri(id: any): string
    local assetUri = "rbxassetid://0" -- Default to empty image
    if type(id) == "number" then
        assetUri = "rbxassetid://" .. id
    elseif type(id) == "string" and not Icons then
        warn("MythicZone | Cannot use Lucide icons as icons library is not loaded")
    else
        warn("MythicZone | The icon argument must either be an icon ID (number) or a Lucide icon name (string)")
    end
    return assetUri
end

local function makeDraggable(object, dragObject, enableTaptic, tapticOffset)
    local dragging = false
    local relative = nil

    local offset = Vector2.zero
    local screenGui = object:FindFirstAncestorWhichIsA("ScreenGui")
    if screenGui and screenGui.IgnoreGuiInset then
        offset += getService('GuiService'):GetGuiInset()
    end

    local function connectFunctions()
        if dragBar and enableTaptic then
            dragBar.MouseEnter:Connect(function()
                if not dragging and not Hidden then
                    TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5, Size = UDim2.new(0, 120, 0, 4)}):Play()
                end
            end)

            dragBar.MouseLeave:Connect(function()
                if not dragging and not Hidden then
                    TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7, Size = UDim2.new(0, 100, 0, 4)}):Play()
                end
            end)
        end
    end

    connectFunctions()

    dragObject.InputBegan:Connect(function(input, processed)
        if processed then return end

        local inputType = input.UserInputType.Name
        if inputType == "MouseButton1" or inputType == "Touch" then
            dragging = true

            relative = object.AbsolutePosition + object.AbsoluteSize * object.AnchorPoint - UserInputService:GetMouseLocation()
            if enableTaptic and not Hidden then
                TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 110, 0, 4), BackgroundTransparency = 0}):Play()
            end
        end
    end)

    local inputEnded = UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end

        local inputType = input.UserInputType.Name
        if inputType == "MouseButton1" or inputType == "Touch" then
            dragging = false

            connectFunctions()

            if enableTaptic and not Hidden then
                TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 100, 0, 4), BackgroundTransparency = 0.7}):Play()
            end
        end
    end)

    local renderStepped = RunService.RenderStepped:Connect(function()
        if dragging and not Hidden then
            local position = UserInputService:GetMouseLocation() + relative + offset
            if enableTaptic and tapticOffset then
                TweenService:Create(object, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(position.X, position.Y)}):Play()
                TweenService:Create(dragObject.Parent, TweenInfo.new(0.05, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(position.X, position.Y + ((useMobileSizing and tapticOffset[2]) or tapticOffset[1]))}):Play()
            else
                if dragBar and tapticOffset then
                    dragBar.Position = UDim2.fromOffset(position.X, position.Y + ((useMobileSizing and tapticOffset[2]) or tapticOffset[1]))
                end
                object.Position = UDim2.fromOffset(position.X, position.Y)
            end
        end
    end)

    object.Destroying:Connect(function()
        if inputEnded then inputEnded:Disconnect() end
        if renderStepped then renderStepped:Disconnect() end
    end)
end


local function PackColor(Color)
    return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
    return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function LoadConfiguration(Configuration)
    local success, Data = pcall(function() return HttpService:JSONDecode(Configuration) end)
    local changed

    if not success then warn('MythicZone had an issue decoding the configuration file, please try delete the file and reopen MythicZone.') return end

    -- Iterate through current UI elements' flags
    for FlagName, Flag in pairs(MythicLibrary.Flags) do
        local FlagValue = Data[FlagName]

        if (typeof(FlagValue) == 'boolean' and FlagValue == false) or FlagValue then
            task.spawn(function()
                if Flag.Type == "ColorPicker" then
                    changed = true
                    Flag:Set(UnpackColor(FlagValue))
                else
                    if (Flag.CurrentValue or Flag.CurrentKeybind or Flag.CurrentOption or Flag.Color) ~= FlagValue then 
                        changed = true
                        Flag:Set(FlagValue) 	
                    end
                end
            end)
        else
            warn("MythicZone | Unable to find '"..FlagName.. "' in the save file.")
            print("The error above may not be an issue if new elements have been added or not been set values.")
        end
    end

    return changed
end

local function SaveConfiguration()
    if not CEnabled or not globalLoaded then return end

    if debugX then
        print('Saving')
    end

    local Data = {}
    for i, v in pairs(MythicLibrary.Flags) do
        if v.Type == "ColorPicker" then
            Data[i] = PackColor(v.Color)
        else
            if typeof(v.CurrentValue) == 'boolean' then
                if v.CurrentValue == false then
                    Data[i] = false
                else
                    Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
                end
            else
                Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
            end
        end
    end

    if useStudio then
        if script.Parent:FindFirstChild('configuration') then script.Parent.configuration:Destroy() end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = script.Parent
        ScreenGui.Name = 'configuration'

        local TextBox = Instance.new("TextBox")
        TextBox.Parent = ScreenGui
        TextBox.Size = UDim2.new(0, 800, 0, 50)
        TextBox.AnchorPoint = Vector2.new(0.5, 0)
        TextBox.Position = UDim2.new(0.5, 0, 0, 30)
        TextBox.Text = HttpService:JSONEncode(Data)
        TextBox.ClearTextOnFocus = false
    end

    if debugX then
        warn(HttpService:JSONEncode(Data))
    end

    if writefile then
        writefile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
    end
end

function MythicLibrary:Notify(data) -- action e.g open messages
    task.spawn(function()

        -- Notification Object Creation
        local newNotification = Notifications.Template:Clone()
        newNotification.Name = data.Title or 'No Title Provided'
        newNotification.Parent = Notifications
        newNotification.LayoutOrder = #Notifications:GetChildren()
        newNotification.Visible = false

        -- Set Data
        newNotification.Title.Text = data.Title or "Unknown Title"
        newNotification.Description.Text = data.Content or "Unknown Content"

        if data.Image then
            if typeof(data.Image) == 'string' and Icons then
                local asset = getIcon(data.Image)

                newNotification.Icon.Image = 'rbxassetid://'..asset.id
                newNotification.Icon.ImageRectOffset = asset.imageRectOffset
                newNotification.Icon.ImageRectSize = asset.imageRectSize
            else
                newNotification.Icon.Image = getAssetUri(data.Image)
            end
        else
            newNotification.Icon.Image = "rbxassetid://" .. 0
        end

        -- Set initial transparency values
        newNotification.Title.TextColor3 = SelectedTheme.TextColor
        newNotification.Description.TextColor3 = SelectedTheme.TextColor
        newNotification.BackgroundColor3 = SelectedTheme.Background
        newNotification.UIStroke.Color = SelectedTheme.TextColor
        newNotification.Icon.ImageColor3 = SelectedTheme.TextColor

        newNotification.BackgroundTransparency = 1
        newNotification.Title.TextTransparency = 1
        newNotification.Description.TextTransparency = 1
        newNotification.UIStroke.Transparency = 1
        newNotification.Shadow.ImageTransparency = 1
        newNotification.Size = UDim2.new(1, 0, 0, 800)
        newNotification.Icon.ImageTransparency = 1
        newNotification.Icon.BackgroundTransparency = 1

        task.wait()

        newNotification.Visible = true

        if data.Actions then
            warn('MythicZone | Not seeing your actions in notifications?')
            print("Notification Actions are being sunset for now.")
        end

        -- Calculate textbounds and set initial values
        local bounds = {newNotification.Title.TextBounds.Y, newNotification.Description.TextBounds.Y}
        newNotification.Size = UDim2.new(1, -60, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)

        newNotification.Icon.Size = UDim2.new(0, 32, 0, 32)
        newNotification.Icon.Position = UDim2.new(0, 20, 0.5, 0)

        TweenService:Create(newNotification, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, math.max(bounds[1] + bounds[2] + 31, 60))}):Play()

        task.wait(0.15)
        TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.45}):Play()
        TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

        task.wait(0.05)

        TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()

        task.wait(0.05)
        TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.35}):Play()
        TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.95}):Play()
        TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.82}):Play()

        local waitDuration = math.min(math.max((#newNotification.Description.Text * 0.1) + 2.5, 3), 10)
        task.wait(data.Duration or waitDuration)

        newNotification.Icon.Visible = false
        TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
        TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
        TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
        TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
        TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

        TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, 0)}):Play()

        task.wait(1)

        TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)}):Play()

        newNotification.Visible = false
        newNotification:Destroy()
    end)
end

local function openSearch()
    searchOpen = true

    Main.Search.BackgroundTransparency = 1
    Main.Search.Shadow.ImageTransparency = 1
    Main.Search.Input.TextTransparency = 1
    Main.Search.Search.ImageTransparency = 1
    Main.Search.UIStroke.Transparency = 1
    Main.Search.Size = UDim2.new(1, 0, 0, 80)
    Main.Search.Position = UDim2.new(0.5, 0, 0, 70)

    Main.Search.Input.Interactable = true

    Main.Search.Visible = true

    for _, tabbtn in ipairs(TabList:GetChildren()) do
        if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
            tabbtn.Interact.Visible = false
            TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
            TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
            TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
            TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
        end
    end

    Main.Search.Input:CaptureFocus()
    TweenService:Create(Main.Search.Shadow, TweenInfo.new(0.05, Enum.EasingStyle.Quint), {ImageTransparency = 0.95}):Play()
    TweenService:Create(Main.Search, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0, 57), BackgroundTransparency = 0.9}):Play()
    TweenService:Create(Main.Search.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.8}):Play()
    TweenService:Create(Main.Search.Input, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
    TweenService:Create(Main.Search.Search, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
    TweenService:Create(Main.Search, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -35, 0, 35)}):Play()
end

local function closeSearch()
    searchOpen = false

    TweenService:Create(Main.Search, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {BackgroundTransparency = 1, Size = UDim2.new(1, -55, 0, 30)}):Play()
    TweenService:Create(Main.Search.Search, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
    TweenService:Create(Main.Search.Shadow, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
    TweenService:Create(Main.Search.UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {Transparency = 1}):Play()
    TweenService:Create(Main.Search.Input, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()

    for _, tabbtn in ipairs(TabList:GetChildren()) do
        if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
            tabbtn.Interact.Visible = true
            if tostring(Elements.UIPageLayout.CurrentPage) == tabbtn.Title.Text then
                TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
                TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
                TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
                TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
            else
                TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
                TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
                TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
                TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
            end
        end
    end

    Main.Search.Input.Text = ''
    Main.Search.Input.Interactable = false
end

local function Hide(notify: boolean?)
    if MPrompt then
        MPrompt.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        MPrompt.Position = UDim2.new(0.5, 0, 0, -50)
        MPrompt.Size = UDim2.new(0, 40, 0, 10)
        MPrompt.BackgroundTransparency = 1
        MPrompt.Title.TextTransparency = 1
        MPrompt.Visible = true
    end

    task.spawn(closeSearch)

    Debounce = true
    if notify then
        if useMobilePrompt then 
            MythicLibrary:Notify({Title = "Interface Hidden", Content = "The interface has been hidden, you can unhide the interface by tapping 'Show MythicZone'.", Duration = 7, Image = 4400697855})
        else
            MythicLibrary:Notify({Title = "Interface Hidden", Content = `The interface has been hidden, you can unhide the interface by tapping {settingsTable.General.mythiczoneOpen.Value or 'K'}.`, Duration = 7, Image = 4400697855})
        end
    end

    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 470, 0, 0)}):Play()
    TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 470, 0, 45)}):Play()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main.Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main.Topbar.CornerRepair, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main.Topbar.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
    TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
    TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
    TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()

    if useMobilePrompt and MPrompt then
        TweenService:Create(MPrompt, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 120, 0, 30), Position = UDim2.new(0.5, 0, 0, 20), BackgroundTransparency = 0.3}):Play()
        TweenService:Create(MPrompt.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0.3}):Play()
    end

    for _, TopbarButton in ipairs(Topbar:GetChildren()) do
        if TopbarButton.ClassName == "ImageButton" then
            TweenService:Create(TopbarButton, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
        end
    end

    for _, tabbtn in ipairs(TabList:GetChildren()) do
        if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
            TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
            TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
            TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
            TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
        end
    end

    dragInteract.Visible = false

    for _, tab in ipairs(Elements:GetChildren()) do
        if tab.Name ~= "Template" and tab.ClassName == "ScrollingFrame" and tab.Name ~= "Placeholder" then
            for _, element in ipairs(tab:GetChildren()) do
                if element.ClassName == "Frame" then
                    if element.Name ~= "SectionSpacing" and element.Name ~= "Placeholder" then
                        if element.Name == "SectionTitle" or element.Name == 'SearchTitle-fsefsefesfsefesfesfThanks' then
                            TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
                        elseif element.Name == 'Divider' then
                            TweenService:Create(element.Divider, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
                        else
                            TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
                            TweenService:Create(element.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
                            TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
                        end
                        for _, child in ipairs(element:GetChildren()) do
                            if child.ClassName == "Frame" or child.ClassName == "TextLabel" or child.ClassName == "TextBox" or child.ClassName == "ImageButton" or child.ClassName == "ImageLabel" then
                                child.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end

    task.wait(0.5)
    Main.Visible = false
    Debounce = false
end

local function Maximise()
    Debounce = true
    Topbar.ChangeSize.Image = "rbxassetid://"..10137941941

    TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
    TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()
    TweenService:Create(Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7}):Play()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
    TweenService:Create(Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 45)}):Play()
    TabList.Visible = true
    task.wait(0.2)

    Elements.Visible = true

    for _, tab in ipairs(Elements:GetChildren()) do
        if tab.Name ~= "Template" and tab.ClassName == "ScrollingFrame" and tab.Name ~= "Placeholder" then
            for _, element in ipairs(tab:GetChildren()) do
                if element.ClassName == "Frame" then
                    if element.Name ~= "SectionSpacing" and element.Name ~= "Placeholder" then
                        if element.Name == "SectionTitle" or element.Name == 'SearchTitle-fsefsefesfsefesfesfThanks' then
                            TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.4}):Play()
                        elseif element.Name == 'Divider' then
                            TweenService:Create(element.Divider, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.85}):Play()
                        else
                            TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
                            TweenService:Create(element.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
                            TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
                        end
                        for _, child in ipairs(element:GetChildren()) do
                            if child.ClassName == "Frame" or child.ClassName == "TextLabel" or child.ClassName == "TextBox" or child.ClassName == "ImageButton" or child.ClassName == "ImageLabel" then
                                child.Visible = true
                            end
                        end
                    end
                end
            end
        end
    end

    task.wait(0.1)

    for _, tabbtn in ipairs(TabList:GetChildren()) do
        if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
            if tostring(Elements.UIPageLayout.CurrentPage) == tabbtn.Title.Text then
                TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
                TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
                TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
                TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
            else
                TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
                TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
                TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
                TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
            end

        end
    end

    task.wait(0.5)
    Debounce = false
end

local function Unhide()
    Debounce = true
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Visible = true
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
    TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 45)}):Play()
    TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main.Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main.Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main.Topbar.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

    if MPrompt then
        TweenService:Create(MPrompt, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 40, 0, 10), Position = UDim2.new(0.5, 0, 0, -50), BackgroundTransparency = 1}):Play()
        TweenService:Create(MPrompt.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

        task.spawn(function()
            task.wait(0.5)
            MPrompt.Visible = false
        end)
    end

    if Minimised then
        task.spawn(Maximise)
    end

    dragBar.Position = useMobileSizing and UDim2.new(0.5, 0, 0.5, dragOffsetMobile) or UDim2.new(0.5, 0, 0.5, dragOffset)

    dragInteract.Visible = true

    for _, TopbarButton in ipairs(Topbar:GetChildren()) do
        if TopbarButton.// filepath: c:\Users\micah\Downloads\MythicZone.lua
--[[

    MythicZone Interface Suite
    Based on Rayfield by Sirius
    Modified for personal use only

]]

if debugX then
    warn('Initialising MythicZone')
end

local function getService(name)
    local service = game:GetService(name)
    return if cloneref then cloneref(service) else service
end

-- Loads and executes a function hosted on a remote URL. Cancels the request if the requested URL takes too long to respond.
local function loadWithTimeout(url: string, timeout: number?): ...any
    assert(type(url) == "string", "Expected string, got " .. type(url))
    timeout = timeout or 5
    local requestCompleted = false
    local success, result = false, nil

    local requestThread = task.spawn(function()
        local fetchSuccess, fetchResult = pcall(game.HttpGet, game, url) -- game:HttpGet(url)
        -- If the request fails the content can be empty, even if fetchSuccess is true
        if not fetchSuccess or #fetchResult == 0 then
            if #fetchResult == 0 then
                fetchResult = "Empty response" -- Set the error message
            end
            success, result = false, fetchResult
            requestCompleted = true
            return
        end
        local content = fetchResult -- Fetched content
        local execSuccess, execResult = pcall(function()
            return loadstring(content)()
        end)
        success, result = execSuccess, execResult
        requestCompleted = true
    end)

    local timeoutThread = task.delay(timeout, function()
        if not requestCompleted then
            warn(`Request for {url} timed out after {timeout} seconds`)
            task.cancel(requestThread)
            result = "Request timed out"
            requestCompleted = true
        end
    end)

    -- Wait for completion or timeout
    while not requestCompleted do
        task.wait()
    end
    -- Cancel timeout thread if still running when request completes
    if coroutine.status(timeoutThread) ~= "dead" then
        task.cancel(timeoutThread)
    end
    if not success then
        warn(`Failed to process {url}: {result}`)
    end
    return if success then result else nil
end

local requestsDisabled = true
local InterfaceBuild = 'MZ01'
local Release = "Version 1.0"
local MythicFolder = "MythicZone"
local ConfigurationFolder = MythicFolder.."/Configurations"
local ConfigurationExtension = ".mzconfig"
local settingsTable = {
    General = {
        mythiczoneOpen = {Type = 'bind', Value = 'K', Name = 'MythicZone Keybind'},
    },
    System = {
        usageAnalytics = {Type = 'toggle', Value = false, Name = 'Anonymised Analytics'},
    }
}

local HttpService = getService('HttpService')
local RunService = getService('RunService')

-- Environment Check
local useStudio = RunService:IsStudio() or false

local settingsCreated = false
local cachedSettings
local request = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request

local function loadSettings()
    local file = nil
    
    local success, result = pcall(function()
        task.spawn(function()
            if isfolder and isfolder(MythicFolder) then
                if isfile and isfile(MythicFolder..'/settings'..ConfigurationExtension) then
                    file = readfile(MythicFolder..'/settings'..ConfigurationExtension)
                end
            end

            -- for debug in studio
            if useStudio then
                file = [[
        {"General":{"mythiczoneOpen":{"Value":"K","Type":"bind","Name":"MythicZone Keybind","Element":{"HoldToInteract":false,"Ext":true,"Name":"MythicZone Keybind","Set":null,"CallOnChange":true,"Callback":null,"CurrentKeybind":"K"}}},"System":{"usageAnalytics":{"Value":false,"Type":"toggle","Name":"Anonymised Analytics","Element":{"Ext":true,"Name":"Anonymised Analytics","Set":null,"CurrentValue":false,"Callback":null}}}}
    ]]
            end

            if file then
                local success, decodedFile = pcall(function() return HttpService:JSONDecode(file) end)
                if success then
                    file = decodedFile
                else
                    file = {}
                end
            else
                file = {}
            end

            if not settingsCreated then 
                cachedSettings = file
                return
            end

            if file ~= {} then
                for categoryName, settingCategory in pairs(settingsTable) do
                    if file[categoryName] then
                        for settingName, setting in pairs(settingCategory) do
                            if file[categoryName][settingName] then
                                setting.Value = file[categoryName][settingName].Value
                                setting.Element:Set(setting.Value)
                            end
                        end
                    end
                end
            end
        end)
    end)
    
    if not success then 
        if writefile then
            warn('MythicZone had an issue accessing configuration saving capability.')
        end
    end
end

if debugX then
    warn('Now Loading Settings Configuration')
end

loadSettings()

if debugX then
    warn('Settings Loaded')
end

if debugX then
    warn('Moving on to continue initialisation')
end

local MythicLibrary = {
    Flags = {},
    Theme = {
        Default = {
            TextColor = Color3.fromRGB(240, 240, 240),

            Background = Color3.fromRGB(25, 25, 35),
            Topbar = Color3.fromRGB(35, 35, 45),
            Shadow = Color3.fromRGB(20, 20, 30),

            NotificationBackground = Color3.fromRGB(20, 20, 30),
            NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

            TabBackground = Color3.fromRGB(80, 80, 120),
            TabStroke = Color3.fromRGB(85, 85, 125),
            TabBackgroundSelected = Color3.fromRGB(120, 120, 210),
            TabTextColor = Color3.fromRGB(240, 240, 240),
            SelectedTabTextColor = Color3.fromRGB(240, 240, 240),

            ElementBackground = Color3.fromRGB(35, 35, 45),
            ElementBackgroundHover = Color3.fromRGB(40, 40, 50),
            SecondaryElementBackground = Color3.fromRGB(25, 25, 35),
            ElementStroke = Color3.fromRGB(50, 50, 90),
            SecondaryElementStroke = Color3.fromRGB(40, 40, 70),

            SliderBackground = Color3.fromRGB(60, 60, 180),
            SliderProgress = Color3.fromRGB(80, 80, 220),
            SliderStroke = Color3.fromRGB(70, 70, 200),

            ToggleBackground = Color3.fromRGB(30, 30, 40),
            ToggleEnabled = Color3.fromRGB(80, 80, 220),
            ToggleDisabled = Color3.fromRGB(100, 100, 100),
            ToggleEnabledStroke = Color3.fromRGB(90, 90, 240),
            ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
            ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 200),
            ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),

            DropdownSelected = Color3.fromRGB(40, 40, 60),
            DropdownUnselected = Color3.fromRGB(30, 30, 40),

            InputBackground = Color3.fromRGB(30, 30, 40),
            InputStroke = Color3.fromRGB(65, 65, 85),
            PlaceholderColor = Color3.fromRGB(178, 178, 178)
        },

        Neon = {
            TextColor = Color3.fromRGB(230, 240, 255),

            Background = Color3.fromRGB(15, 15, 25),
            Topbar = Color3.fromRGB(20, 20, 30),
            Shadow = Color3.fromRGB(10, 10, 15),

            NotificationBackground = Color3.fromRGB(20, 20, 30),
            NotificationActionsBackground = Color3.fromRGB(230, 230, 255),

            TabBackground = Color3.fromRGB(40, 40, 80),
            TabStroke = Color3.fromRGB(50, 50, 100),
            TabBackgroundSelected = Color3.fromRGB(100, 100, 255),
            TabTextColor = Color3.fromRGB(220, 220, 255),
            SelectedTabTextColor = Color3.fromRGB(240, 240, 255),

            ElementBackground = Color3.fromRGB(25, 25, 35),
            ElementBackgroundHover = Color3.fromRGB(30, 30, 45),
            SecondaryElementBackground = Color3.fromRGB(20, 20, 30),
            ElementStroke = Color3.fromRGB(45, 45, 90),
            SecondaryElementStroke = Color3.fromRGB(40, 40, 80),

            SliderBackground = Color3.fromRGB(30, 30, 100),
            SliderProgress = Color3.fromRGB(60, 60, 210),
            SliderStroke = Color3.fromRGB(50, 50, 160),

            ToggleBackground = Color3.fromRGB(25, 25, 35),
            ToggleEnabled = Color3.fromRGB(70, 70, 230),
            ToggleDisabled = Color3.fromRGB(70, 70, 90),
            ToggleEnabledStroke = Color3.fromRGB(80, 80, 255),
            ToggleDisabledStroke = Color3.fromRGB(85, 85, 115),
            ToggleEnabledOuterStroke = Color3.fromRGB(60, 60, 190),
            ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 75),

            DropdownSelected = Color3.fromRGB(30, 30, 60),
            DropdownUnselected = Color3.fromRGB(25, 25, 40),

            InputBackground = Color3.fromRGB(25, 25, 35),
            InputStroke = Color3.fromRGB(50, 50, 100),
            PlaceholderColor = Color3.fromRGB(140, 140, 170)
        },

        Sunset = {
            TextColor = Color3.fromRGB(255, 245, 230),

            Background = Color3.fromRGB(40, 20, 30),
            Topbar = Color3.fromRGB(50, 25, 35),
            Shadow = Color3.fromRGB(35, 15, 20),

            NotificationBackground = Color3.fromRGB(45, 25, 35),
            NotificationActionsBackground = Color3.fromRGB(245, 230, 215),

            TabBackground = Color3.fromRGB(75, 35, 45),
            TabStroke = Color3.fromRGB(90, 45, 55),
            TabBackgroundSelected = Color3.fromRGB(210, 100, 120),
            TabTextColor = Color3.fromRGB(250, 220, 200),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),

            ElementBackground = Color3.fromRGB(55, 30, 40),
            ElementBackgroundHover = Color3.fromRGB(70, 35, 45),
            SecondaryElementBackground = Color3.fromRGB(50, 25, 35),
            ElementStroke = Color3.fromRGB(90, 50, 70),
            SecondaryElementStroke = Color3.fromRGB(80, 45, 65),

            SliderBackground = Color3.fromRGB(180, 60, 80),
            SliderProgress = Color3.fromRGB(240, 100, 120),
            SliderStroke = Color3.fromRGB(200, 80, 100),

            ToggleBackground = Color3.fromRGB(55, 30, 40),
            ToggleEnabled = Color3.fromRGB(230, 85, 110),
            ToggleDisabled = Color3.fromRGB(90, 60, 70),
            ToggleEnabledStroke = Color3.fromRGB(255, 100, 130),
            ToggleDisabledStroke = Color3.fromRGB(110, 75, 85),
            ToggleEnabledOuterStroke = Color3.fromRGB(190, 70, 90),
            ToggleDisabledOuterStroke = Color3.fromRGB(70, 45, 55),

            DropdownSelected = Color3.fromRGB(65, 35, 45),
            DropdownUnselected = Color3.fromRGB(50, 25, 35),

            InputBackground = Color3.fromRGB(55, 30, 40),
            InputStroke = Color3.fromRGB(85, 45, 65),
            PlaceholderColor = Color3.fromRGB(170, 120, 140)
        },

        Emerald = {
            TextColor = Color3.fromRGB(230, 255, 230),

            Background = Color3.fromRGB(15, 35, 25),
            Topbar = Color3.fromRGB(20, 45, 30),
            Shadow = Color3.fromRGB(10, 30, 20),

            NotificationBackground = Color3.fromRGB(20, 40, 30),
            NotificationActionsBackground = Color3.fromRGB(230, 255, 230),

            TabBackground = Color3.fromRGB(30, 75, 50),
            TabStroke = Color3.fromRGB(35, 85, 60),
            TabBackgroundSelected = Color3.fromRGB(40, 160, 120),
            TabTextColor = Color3.fromRGB(220, 255, 220),
            SelectedTabTextColor = Color3.fromRGB(240, 255, 240),

            ElementBackground = Color3.fromRGB(25, 50, 35),
            ElementBackgroundHover = Color3.fromRGB(30, 60, 40),
            SecondaryElementBackground = Color3.fromRGB(20, 40, 30),
            ElementStroke = Color3.fromRGB(45, 95, 70),
            SecondaryElementStroke = Color3.fromRGB(40, 80, 60),

            SliderBackground = Color3.fromRGB(30, 130, 90),
            SliderProgress = Color3.fromRGB(40, 180, 120),
            SliderStroke = Color3.fromRGB(35, 150, 105),

            ToggleBackground = Color3.fromRGB(25, 50, 35),
            ToggleEnabled = Color3.fromRGB(40, 190, 120),
            ToggleDisabled = Color3.fromRGB(70, 90, 80),
            ToggleEnabledStroke = Color3.fromRGB(50, 210, 140),
            ToggleDisabledStroke = Color3.fromRGB(85, 105, 95),
            ToggleEnabledOuterStroke = Color3.fromRGB(45, 170, 110),
            ToggleDisabledOuterStroke = Color3.fromRGB(60, 75, 70),

            DropdownSelected = Color3.fromRGB(35, 70, 50),
            DropdownUnselected = Color3.fromRGB(25, 45, 35),

            InputBackground = Color3.fromRGB(25, 50, 35),
            InputStroke = Color3.fromRGB(50, 100, 75),
            PlaceholderColor = Color3.fromRGB(140, 180, 150)
        },

        Midnight = {
            TextColor = Color3.fromRGB(225, 225, 255),

            Background = Color3.fromRGB(15, 15, 25),
            Topbar = Color3.fromRGB(20, 20, 30),
            Shadow = Color3.fromRGB(10, 10, 15),

            NotificationBackground = Color3.fromRGB(20, 20, 30),
            NotificationActionsBackground = Color3.fromRGB(220, 220, 250),

            TabBackground = Color3.fromRGB(30, 30, 45),
            TabStroke = Color3.fromRGB(40, 40, 60),
            TabBackgroundSelected = Color3.fromRGB(60, 60, 150),
            TabTextColor = Color3.fromRGB(220, 220, 250),
            SelectedTabTextColor = Color3.fromRGB(240, 240, 255),

            ElementBackground = Color3.fromRGB(25, 25, 35),
            ElementBackgroundHover = Color3.fromRGB(30, 30, 45),
            SecondaryElementBackground = Color3.fromRGB(20, 20, 30),
            ElementStroke = Color3.fromRGB(45, 45, 70),
            SecondaryElementStroke = Color3.fromRGB(35, 35, 55),

            SliderBackground = Color3.fromRGB(40, 40, 100),
            SliderProgress = Color3.fromRGB(60, 60, 180),
            SliderStroke = Color3.fromRGB(50, 50, 150),

            ToggleBackground = Color3.fromRGB(25, 25, 35),
            ToggleEnabled = Color3.fromRGB(60, 60, 190),
            ToggleDisabled = Color3.fromRGB(70, 70, 90),
            ToggleEnabledStroke = Color3.fromRGB(70, 70, 210),
            ToggleDisabledStroke = Color3.fromRGB(85, 85, 115),
            ToggleEnabledOuterStroke = Color3.fromRGB(50, 50, 170),
            ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 70),

            DropdownSelected = Color3.fromRGB(30, 30, 55),
            DropdownUnselected = Color3.fromRGB(25, 25, 40),

            InputBackground = Color3.fromRGB(25, 25, 35),
            InputStroke = Color3.fromRGB(50, 50, 80),
            PlaceholderColor = Color3.fromRGB(140, 140, 170)
        },
    }
}

-- Services
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Players = getService("Players")
local CoreGui = getService("CoreGui")

-- Interface Management
local MythicZone = useStudio and script.Parent:FindFirstChild('MythicZone') or game:GetObjects("rbxassetid://10804731440")[1]
MythicZone.Name = "MythicZone"
local buildAttempts = 0
local correctBuild = true
local warned
local globalLoaded

MythicZone.Enabled = false

if gethui then
    MythicZone.Parent = gethui()
elseif syn and syn.protect_gui then 
    syn.protect_gui(MythicZone)
    MythicZone.Parent = CoreGui
elseif not useStudio and CoreGui:FindFirstChild("RobloxGui") then
    MythicZone.Parent = CoreGui:FindFirstChild("RobloxGui")
elseif not useStudio then
    MythicZone.Parent = CoreGui
end

if gethui then
    for _, Interface in ipairs(gethui():GetChildren()) do
        if Interface.Name == MythicZone.Name and Interface ~= MythicZone then
            Interface.Enabled = false
            Interface.Name = "MythicZone-Old"
        end
    end
elseif not useStudio then
    for _, Interface in ipairs(CoreGui:GetChildren()) do
        if Interface.Name == MythicZone.Name and Interface ~= MythicZone then
            Interface.Enabled = false
            Interface.Name = "MythicZone-Old"
        end
    end
end

local minSize = Vector2.new(1024, 768)
local useMobileSizing

if MythicZone.AbsoluteSize.X < minSize.X and MythicZone.AbsoluteSize.Y < minSize.Y then
    useMobileSizing = true
end

if UserInputService.TouchEnabled then
    useMobilePrompt = true
end

-- Object Variables
local Main = MythicZone.Main
Main.Title.Text = "MythicZone"
local MPrompt = MythicZone:FindFirstChild('Prompt')
if MPrompt then 
    MPrompt.Title.Text = "Show MythicZone"
end
local Topbar = Main.Topbar
local Elements = Main.Elements
local LoadingFrame = Main.LoadingFrame
local TabList = Main.TabList
local dragBar = MythicZone:FindFirstChild('Drag')
local dragInteract = dragBar and dragBar.Interact or nil
local dragBarCosmetic = dragBar and dragBar.Drag or nil

local dragOffset = 255
local dragOffsetMobile = 150

MythicZone.DisplayOrder = 100
LoadingFrame.Version.Text = Release

-- Thanks to Latte Softworks for the Lucide integration for Roblox
local Icons = useStudio and require(script.Parent.icons) or loadWithTimeout('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/icons.lua')
-- Variables

local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false
local searchOpen = false
local Notifications = MythicZone.Notifications

local SelectedTheme = MythicLibrary.Theme.Default

local function ChangeTheme(Theme)
    if typeof(Theme) == 'string' then
        SelectedTheme = MythicLibrary.Theme[Theme]
    elseif typeof(Theme) == 'table' then
        SelectedTheme = Theme
    end

    MythicZone.Main.BackgroundColor3 = SelectedTheme.Background
    MythicZone.Main.Topbar.BackgroundColor3 = SelectedTheme.Topbar
    MythicZone.Main.Topbar.CornerRepair.BackgroundColor3 = SelectedTheme.Topbar
    MythicZone.Main.Shadow.Image.ImageColor3 = SelectedTheme.Shadow

    MythicZone.Main.Topbar.ChangeSize.ImageColor3 = SelectedTheme.TextColor
    MythicZone.Main.Topbar.Hide.ImageColor3 = SelectedTheme.TextColor
    MythicZone.Main.Topbar.Search.ImageColor3 = SelectedTheme.TextColor
    if Topbar:FindFirstChild('Settings') then
        MythicZone.Main.Topbar.Settings.ImageColor3 = SelectedTheme.TextColor
        MythicZone.Main.Topbar.Divider.BackgroundColor3 = SelectedTheme.ElementStroke
    end

    Main.Search.BackgroundColor3 = SelectedTheme.TextColor
    Main.Search.Shadow.ImageColor3 = SelectedTheme.TextColor
    Main.Search.Search.ImageColor3 = SelectedTheme.TextColor
    Main.Search.Input.PlaceholderColor3 = SelectedTheme.TextColor
    Main.Search.UIStroke.Color = SelectedTheme.SecondaryElementStroke

    if Main:FindFirstChild('Notice') then
        Main.Notice.BackgroundColor3 = SelectedTheme.Background
    end

    for _, text in ipairs(MythicZone:GetDescendants()) do
        if text.Parent.Parent ~= Notifications then
            if text:IsA('TextLabel') or text:IsA('TextBox') then text.TextColor3 = SelectedTheme.TextColor end
        end
    end

    for _, TabPage in ipairs(Elements:GetChildren()) do
        for _, Element in ipairs(TabPage:GetChildren()) do
            if Element.ClassName == "Frame" and Element.Name ~= "Placeholder" and Element.Name ~= "SectionSpacing" and Element.Name ~= "Divider" and Element.Name ~= "SectionTitle" and Element.Name ~= "SearchTitle-fsefsefesfsefesfesfThanks" then
                Element.BackgroundColor3 = SelectedTheme.ElementBackground
                Element.UIStroke.Color = SelectedTheme.ElementStroke
            end
        end
    end
end

local function getIcon(name : string): {id: number, imageRectSize: Vector2, imageRectOffset: Vector2}
    if not Icons then
        warn("Lucide Icons: Cannot use icons as icons library is not loaded")
        return
    end
    name = string.match(string.lower(name), "^%s*(.*)%s*$") :: string
    local sizedicons = Icons['48px']
    local r = sizedicons[name]
    if not r then
        error(`Lucide Icons: Failed to find icon by the name of "{name}"`, 2)
    end

    local rirs = r[2]
    local riro = r[3]

    if type(r[1]) ~= "number" or type(rirs) ~= "table" or type(riro) ~= "table" then
        error("Lucide Icons: Internal error: Invalid auto-generated asset entry")
    end

    local irs = Vector2.new(rirs[1], rirs[2])
    local iro = Vector2.new(riro[1], riro[2])

    local asset = {
        id = r[1],
        imageRectSize = irs,
        imageRectOffset = iro,
    }

    return asset
end
-- Converts ID to asset URI. Returns rbxassetid://0 if ID is not a number
local function getAssetUri(id: any): string
    local assetUri = "rbxassetid://0" -- Default to empty image
    if type(id) == "number" then
        assetUri = "rbxassetid://" .. id
    elseif type(id) == "string" and not Icons then
        warn("MythicZone | Cannot use Lucide icons as icons library is not loaded")
    else
        warn("MythicZone | The icon argument must either be an icon ID (number) or a Lucide icon name (string)")
    end
    return assetUri
end

local function makeDraggable(object, dragObject, enableTaptic, tapticOffset)
    local dragging = false
    local relative = nil

    local offset = Vector2.zero
    local screenGui = object:FindFirstAncestorWhichIsA("ScreenGui")
    if screenGui and screenGui.IgnoreGuiInset then
        offset += getService('GuiService'):GetGuiInset()
    end

    local function connectFunctions()
        if dragBar and enableTaptic then
            dragBar.MouseEnter:Connect(function()
                if not dragging and not Hidden then
                    TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5, Size = UDim2.new(0, 120, 0, 4)}):Play()
                end
            end)

            dragBar.MouseLeave:Connect(function()
                if not dragging and not Hidden then
                    TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7, Size = UDim2.new(0, 100, 0, 4)}):Play()
                end
            end)
        end
    end

    connectFunctions()

    dragObject.InputBegan:Connect(function(input, processed)
        if processed then return end

        local inputType = input.UserInputType.Name
        if inputType == "MouseButton1" or inputType == "Touch" then
            dragging = true

            relative = object.AbsolutePosition + object.AbsoluteSize * object.AnchorPoint - UserInputService:GetMouseLocation()
            if enableTaptic and not Hidden then
                TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 110, 0, 4), BackgroundTransparency = 0}):Play()
            end
        end
    end)

    local inputEnded = UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end

        local inputType = input.UserInputType.Name
        if inputType == "MouseButton1" or inputType == "Touch" then
            dragging = false

            connectFunctions()

            if enableTaptic and not Hidden then
                TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 100, 0, 4), BackgroundTransparency = 0.7}):Play()
            end
        end
    end)

    local renderStepped = RunService.RenderStepped:Connect(function()
        if dragging and not Hidden then
            local position = UserInputService:GetMouseLocation() + relative + offset
            if enableTaptic and tapticOffset then
                TweenService:Create(object, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(position.X, position.Y)}):Play()
                TweenService:Create(dragObject.Parent, TweenInfo.new(0.05, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(position.X, position.Y + ((useMobileSizing and tapticOffset[2]) or tapticOffset[1]))}):Play()
            else
                if dragBar and tapticOffset then
                    dragBar.Position = UDim2.fromOffset(position.X, position.Y + ((useMobileSizing and tapticOffset[2]) or tapticOffset[1]))
                end
                object.Position = UDim2.fromOffset(position.X, position.Y)
            end
        end
    end)

    object.Destroying:Connect(function()
        if inputEnded then inputEnded:Disconnect() end
        if renderStepped then renderStepped:Disconnect() end
    end)
end


local function PackColor(Color)
    return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
    return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function LoadConfiguration(Configuration)
    local success, Data = pcall(function() return HttpService:JSONDecode(Configuration) end)
    local changed

    if not success then warn('MythicZone had an issue decoding the configuration file, please try delete the file and reopen MythicZone.') return end

    -- Iterate through current UI elements' flags
    for FlagName, Flag in pairs(MythicLibrary.Flags) do
        local FlagValue = Data[FlagName]

        if (typeof(FlagValue) == 'boolean' and FlagValue == false) or FlagValue then
            task.spawn(function()
                if Flag.Type == "ColorPicker" then
                    changed = true
                    Flag:Set(UnpackColor(FlagValue))
                else
                    if (Flag.CurrentValue or Flag.CurrentKeybind or Flag.CurrentOption or Flag.Color) ~= FlagValue then 
                        changed = true
                        Flag:Set(FlagValue) 	
                    end
                end
            end)
        else
            warn("MythicZone | Unable to find '"..FlagName.. "' in the save file.")
            print("The error above may not be an issue if new elements have been added or not been set values.")
        end
    end

    return changed
end

local function SaveConfiguration()
    if not CEnabled or not globalLoaded then return end

    if debugX then
        print('Saving')
    end

    local Data = {}
    for i, v in pairs(MythicLibrary.Flags) do
        if v.Type == "ColorPicker" then
            Data[i] = PackColor(v.Color)
        else
            if typeof(v.CurrentValue) == 'boolean' then
                if v.CurrentValue == false then
                    Data[i] = false
                else
                    Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
                end
            else
                Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
            end
        end
    end

    if useStudio then
        if script.Parent:FindFirstChild('configuration') then script.Parent.configuration:Destroy() end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = script.Parent
        ScreenGui.Name = 'configuration'

        local TextBox = Instance.new("TextBox")
        TextBox.Parent = ScreenGui
        TextBox.Size = UDim2.new(0, 800, 0, 50)
        TextBox.AnchorPoint = Vector2.new(0.5, 0)
        TextBox.Position = UDim2.new(0.5, 0, 0, 30)
        TextBox.Text = HttpService:JSONEncode(Data)
        TextBox.ClearTextOnFocus = false
    end

    if debugX then
        warn(HttpService:JSONEncode(Data))
    end

    if writefile then
        writefile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
    end
end

function MythicLibrary:Notify(data) -- action e.g open messages
    task.spawn(function()

        -- Notification Object Creation
        local newNotification = Notifications.Template:Clone()
        newNotification.Name = data.Title or 'No Title Provided'
        newNotification.Parent = Notifications
        newNotification.LayoutOrder = #Notifications:GetChildren()
        newNotification.Visible = false

        -- Set Data
        newNotification.Title.Text = data.Title or "Unknown Title"
        newNotification.Description.Text = data.Content or "Unknown Content"

        if data.Image then
            if typeof(data.Image) == 'string' and Icons then
                local asset = getIcon(data.Image)

                newNotification.Icon.Image = 'rbxassetid://'..asset.id
                newNotification.Icon.ImageRectOffset = asset.imageRectOffset
                newNotification.Icon.ImageRectSize = asset.imageRectSize
            else
                newNotification.Icon.Image = getAssetUri(data.Image)
            end
        else
            newNotification.Icon.Image = "rbxassetid://" .. 0
        end

        -- Set initial transparency values
        newNotification.Title.TextColor3 = SelectedTheme.TextColor
        newNotification.Description.TextColor3 = SelectedTheme.TextColor
        newNotification.BackgroundColor3 = SelectedTheme.Background
        newNotification.UIStroke.Color = SelectedTheme.TextColor
        newNotification.Icon.ImageColor3 = SelectedTheme.TextColor

        newNotification.BackgroundTransparency = 1
        newNotification.Title.TextTransparency = 1
        newNotification.Description.TextTransparency = 1
        newNotification.UIStroke.Transparency = 1
        newNotification.Shadow.ImageTransparency = 1
        newNotification.Size = UDim2.new(1, 0, 0, 800)
        newNotification.Icon.ImageTransparency = 1
        newNotification.Icon.BackgroundTransparency = 1

        task.wait()

        newNotification.Visible = true

        if data.Actions then
            warn('MythicZone | Not seeing your actions in notifications?')
            print("Notification Actions are being sunset for now.")
        end

        -- Calculate textbounds and set initial values
        local bounds = {newNotification.Title.TextBounds.Y, newNotification.Description.TextBounds.Y}
        newNotification.Size = UDim2.new(1, -60, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)

        newNotification.Icon.Size = UDim2.new(0, 32, 0, 32)
        newNotification.Icon.Position = UDim2.new(0, 20, 0.5, 0)

        TweenService:Create(newNotification, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, math.max(bounds[1] + bounds[2] + 31, 60))}):Play()

        task.wait(0.15)
        TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.45}):Play()
        TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

        task.wait(0.05)

        TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()

        task.wait(0.05)
        TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.35}):Play()
        TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.95}):Play()
        TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.82}):Play()

        local waitDuration = math.min(math.max((#newNotification.Description.Text * 0.1) + 2.5, 3), 10)
        task.wait(data.Duration or waitDuration)

        newNotification.Icon.Visible = false
        TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
        TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
        TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
        TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
        TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

        TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, 0)}):Play()

        task.wait(1)

        TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)}):Play()

        newNotification.Visible = false
        newNotification:Destroy()
    end)
end

local function openSearch()
    searchOpen = true

    Main.Search.BackgroundTransparency = 1
    Main.Search.Shadow.ImageTransparency = 1
    Main.Search.Input.TextTransparency = 1
    Main.Search.Search.ImageTransparency = 1
    Main.Search.UIStroke.Transparency = 1
    Main.Search.Size = UDim2.new(1, 0, 0, 80)
    Main.Search.Position = UDim2.new(0.5, 0, 0, 70)

    Main.Search.Input.Interactable = true

    Main.Search.Visible = true

    for _, tabbtn in ipairs(TabList:GetChildren()) do
        if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
            tabbtn.Interact.Visible = false
            TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
            TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
            TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
            TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
        end
    end

    Main.Search.Input:CaptureFocus()
    TweenService:Create(Main.Search.Shadow, TweenInfo.new(0.05, Enum.EasingStyle.Quint), {ImageTransparency = 0.95}):Play()
    TweenService:Create(Main.Search, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0, 57), BackgroundTransparency = 0.9}):Play()
    TweenService:Create(Main.Search.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.8}):Play()
    TweenService:Create(Main.Search.Input, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
    TweenService:Create(Main.Search.Search, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
    TweenService:Create(Main.Search, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -35, 0, 35)}):Play()
end

local function closeSearch()
    searchOpen = false

    TweenService:Create(Main.Search, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {BackgroundTransparency = 1, Size = UDim2.new(1, -55, 0, 30)}):Play()
    TweenService:Create(Main.Search.Search, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
    TweenService:Create(Main.Search.Shadow, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
    TweenService:Create(Main.Search.UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {Transparency = 1}):Play()
    TweenService:Create(Main.Search.Input, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()

    for _, tabbtn in ipairs(TabList:GetChildren()) do
        if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
            tabbtn.Interact.Visible = true
            if tostring(Elements.UIPageLayout.CurrentPage) == tabbtn.Title.Text then
                TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
                TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
                TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
                TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
            else
                TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
                TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
                TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
                TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
            end
        end
    end

    Main.Search.Input.Text = ''
    Main.Search.Input.Interactable = false
end

local function Hide(notify: boolean?)
    if MPrompt then
        MPrompt.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        MPrompt.Position = UDim2.new(0.5, 0, 0, -50)
        MPrompt.Size = UDim2.new(0, 40, 0, 10)
        MPrompt.BackgroundTransparency = 1
        MPrompt.Title.TextTransparency = 1
        MPrompt.Visible = true
    end

    task.spawn(closeSearch)

    Debounce = true
    if notify then
        if useMobilePrompt then 
            MythicLibrary:Notify({Title = "Interface Hidden", Content = "The interface has been hidden, you can unhide the interface by tapping 'Show MythicZone'.", Duration = 7, Image = 4400697855})
        else
            MythicLibrary:Notify({Title = "Interface Hidden", Content = `The interface has been hidden, you can unhide the interface by tapping {settingsTable.General.mythiczoneOpen.Value or 'K'}.`, Duration = 7, Image = 4400697855})
        end
    end

    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 470, 0, 0)}):Play()
    TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 470, 0, 45)}):Play()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main.Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main.Topbar.CornerRepair, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main.Topbar.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
    TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
    TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
    TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()

    if useMobilePrompt and MPrompt then
        TweenService:Create(MPrompt, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 120, 0, 30), Position = UDim2.new(0.5, 0, 0, 20), BackgroundTransparency = 0.3}):Play()
        TweenService:Create(MPrompt.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0.3}):Play()
    end

    for _, TopbarButton in ipairs(Topbar:GetChildren()) do
        if TopbarButton.ClassName == "ImageButton" then
            TweenService:Create(TopbarButton, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
        end
    end

    for _, tabbtn in ipairs(TabList:GetChildren()) do
        if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
            TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
            TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
            TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
            TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
        end
    end

    dragInteract.Visible = false

    for _, tab in ipairs(Elements:GetChildren()) do
        if tab.Name ~= "Template" and tab.ClassName == "ScrollingFrame" and tab.Name ~= "Placeholder" then
            for _, element in ipairs(tab:GetChildren()) do
                if element.ClassName == "Frame" then
                    if element.Name ~= "SectionSpacing" and element.Name ~= "Placeholder" then
                        if element.Name == "SectionTitle" or element.Name == 'SearchTitle-fsefsefesfsefesfesfThanks' then
                            TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
                        elseif element.Name == 'Divider' then
                            TweenService:Create(element.Divider, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
                        else
                            TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
                            TweenService:Create(element.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
                            TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
                        end
                        for _, child in ipairs(element:GetChildren()) do
                            if child.ClassName == "Frame" or child.ClassName == "TextLabel" or child.ClassName == "TextBox" or child.ClassName == "ImageButton" or child.ClassName == "ImageLabel" then
                                child.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end

    task.wait(0.5)
    Main.Visible = false
    Debounce = false
end

local function Maximise()
    Debounce = true
    Topbar.ChangeSize.Image = "rbxassetid://"..10137941941

    TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
    TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()
    TweenService:Create(Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7}):Play()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
    TweenService:Create(Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 45)}):Play()
    TabList.Visible = true
    task.wait(0.2)

    Elements.Visible = true

    for _, tab in ipairs(Elements:GetChildren()) do
        if tab.Name ~= "Template" and tab.ClassName == "ScrollingFrame" and tab.Name ~= "Placeholder" then
            for _, element in ipairs(tab:GetChildren()) do
                if element.ClassName == "Frame" then
                    if element.Name ~= "SectionSpacing" and element.Name ~= "Placeholder" then
                        if element.Name == "SectionTitle" or element.Name == 'SearchTitle-fsefsefesfsefesfesfThanks' then
                            TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.4}):Play()
                        elseif element.Name == 'Divider' then
                            TweenService:Create(element.Divider, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.85}):Play()
                        else
                            TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
                            TweenService:Create(element.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
                            TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
                        end
                        for _, child in ipairs(element:GetChildren()) do
                            if child.ClassName == "Frame" or child.ClassName == "TextLabel" or child.ClassName == "TextBox" or child.ClassName == "ImageButton" or child.ClassName == "ImageLabel" then
                                child.Visible = true
                            end
                        end
                    end
                end
            end
        end
    end

    task.wait(0.1)

    for _, tabbtn in ipairs(TabList:GetChildren()) do
        if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
            if tostring(Elements.UIPageLayout.CurrentPage) == tabbtn.Title.Text then
                TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
                TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
                TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
                TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
            else
                TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
                TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
                TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
                TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
            end

        end
    end

    task.wait(0.5)
    Debounce = false
end

local function Unhide()
    Debounce = true
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Visible = true
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
    TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 45)}):Play()
    TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main.Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main.Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main.Topbar.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

    if MPrompt then
        TweenService:Create(MPrompt, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 40, 0, 10), Position = UDim2.new(0.5, 0, 0, -50), BackgroundTransparency = 1}):Play()
        TweenService:Create(MPrompt.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

        task.spawn(function()
            task.wait(0.5)
            MPrompt.Visible = false
        end)
    end

    if Minimised then
        task.spawn(Maximise)
    end

    dragBar.Position = useMobileSizing and UDim2.new(0.5, 0, 0.5, dragOffsetMobile) or UDim2.new(0.5, 0, 0.5, dragOffset)

    dragInteract.Visible = true

    for _, TopbarButton in ipairs(Topbar:GetChildren()) do
        if TopbarButton.ClassName == "ImageButton" then
            TweenService:Create(TopbarButton, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
        end
    end

    task.wait(0.5)
    Hidden = false
    Debounce = false
end

local function Minimise()
    Debounce = true
    Elements.Visible = false
    TabList.Visible = false
    Topbar.ChangeSize.Image = "rbxassetid://"..10137941940

    TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.7}):Play()
    TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
    TweenService:Create(Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 45)}):Play()
    TweenService:Create(Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 45)}):Play()

    task.wait(0.5)
    Minimised = true
    Debounce = false
end

local function setKeybind(key, newKeybind)
    if key ~= nil and Find(Enum.KeyCode, key) then
        key = Enum.KeyCode[key]
    end

    if newKeybind ~= nil and typeof(newKeybind) == 'string' and Find(Enum.KeyCode, newKeybind) then
        newKeybind = Enum.KeyCode[newKeybind]
    end
    
    local setkey = newKeybind or key
    settingsTable.General.mythiczoneOpen.Value = setkey.Name
    
    local OldBind = Find(Enum.KeyCode, settingsTable.General.mythiczoneOpen.Value) and Enum.KeyCode[settingsTable.General.mythiczoneOpen.Value] or Enum.KeyCode.K
    local setKeybind

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent and input.KeyCode == setkey or input.KeyCode == setKeybind then
            if Hidden then
                task.spawn(Unhide)
                Hidden = false
            else
                task.spawn(Hide, true)
                Hidden = true
            end
        end
    end)

    local settingsContent = {}
    
    if writefile and isfolder and makefolder then
        settingsContent = HttpService:JSONEncode(settingsTable)
        
        if not isfolder(MythicFolder) then
            makefolder(MythicFolder)
        end
        
        if not isfolder(ConfigurationFolder) then
            makefolder(ConfigurationFolder)
        end
        
        writefile(MythicFolder..'/settings'..ConfigurationExtension, settingsContent)
    end
end

-- Set Default Keybind
setKeybind(Enum.KeyCode.K)

function MythicLibrary:LoadConfiguration(Configuration)
    if not Configuration or Configuration == '' then return end
    if CEnabled and not useStudio then
        local parsedConfig = isfile and isfile(ConfigurationFolder..'/'..Configuration..ConfigurationExtension) and readfile(ConfigurationFolder..'/'..Configuration..ConfigurationExtension) or nil
        if parsedConfig then
            CFileName = Configuration
            local changed = LoadConfiguration(parsedConfig)
            return changed
        end
    end
end

function MythicLibrary:SaveConfiguration(Configuration)
    if not Configuration or Configuration == '' then return end
    CFileName = Configuration
    CEnabled = true
    task.spawn(SaveConfiguration)
end

function MythicLibrary:CreateTab(TabConfig)
    -- Required arguments
    assert(TabConfig.Name, "MythicZone | Missing name argument from CreateTab")
    
    -- Optional arguments
    TabConfig.Image = TabConfig.Image or "grid"  -- Default icon if no image is provided

    local TabButtonWidth = 130
    local TabPage = Elements.Template:Clone()
    TabPage.Name = TabConfig.Name
    TabPage.Visible = true
    TabPage.LayoutOrder = #Elements:GetChildren()
    TabPage.Parent = Elements

    local TabButton = TabList.Template:Clone()
    TabButton.Name = TabConfig.Name
    TabButton.Title.Text = TabConfig.Name
    TabButton.Parent = TabList
    TabButton.Visible = true
    TabButton.LayoutOrder = #TabList:GetChildren()
    
    -- Handle tab icon
    if typeof(TabConfig.Image) == 'string' and Icons then
        local asset = getIcon(TabConfig.Image)
        TabButton.Image.Image = 'rbxassetid://'..asset.id
        TabButton.Image.ImageRectOffset = asset.imageRectOffset
        TabButton.Image.ImageRectSize = asset.imageRectSize
    else
        TabButton.Image.Image = getAssetUri(TabConfig.Image)
    end
    
    -- Set initial styling
    TabButton.BackgroundTransparency = 0.7
    TabButton.Title.TextTransparency = 0.2
    TabButton.Image.ImageTransparency = 0.2
    TabButton.UIStroke.Transparency = 0.5

    local firstTab = #Elements:GetChildren() <= 2

    TabButton.Interact.MouseButton1Click:Connect(function()
        Elements.UIPageLayout:JumpTo(TabPage)
        for _, button in pairs(TabList:GetChildren()) do
            if button.Name ~= "Template" and button.Name ~= "Placeholder" then
                if button.Name == TabConfig.Name then
                    TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
                    TweenService:Create(button.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
                    TweenService:Create(button.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
                    TweenService:Create(button.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
                    button.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
                    button.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
                else
                    TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
                    TweenService:Create(button.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
                    TweenService:Create(button.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
                    TweenService:Create(button.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
                    button.BackgroundColor3 = SelectedTheme.TabBackground
                    button.Title.TextColor3 = SelectedTheme.TabTextColor
                end
            end
        end
    end)

    if firstTab then
        task.spawn(function()
            TabButton.BackgroundTransparency = 0
            TabButton.Title.TextTransparency = 0
            TabButton.Image.ImageTransparency = 0
            TabButton.UIStroke.Transparency = 1
            TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
            TabButton.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
        end)
    end

    local TabLibrary = {}

    function TabLibrary:CreateSection(SectionName)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = "SectionTitle"
        SectionFrame.Parent = TabPage
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.Size = UDim2.new(1, 0, 0, 30)
        SectionFrame.LayoutOrder = #TabPage:GetChildren()

        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "Title"
        SectionTitle.Parent = SectionFrame
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Position = UDim2.new(0, 10, 0, 5)
        SectionTitle.Size = UDim2.new(1, -20, 1, -10)
        SectionTitle.Font = Enum.Font.Gotham
        SectionTitle.Text = SectionName
        SectionTitle.TextColor3 = SelectedTheme.TextColor
        SectionTitle.TextSize = 14
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.TextTransparency = 0.4
        SectionTitle.TextWrapped = true

        return SectionFrame
    end
    
    function TabLibrary:CreateDivider()
        local DividerFrame = Instance.new("Frame")
        DividerFrame.Name = "Divider"
        DividerFrame.Parent = TabPage
        DividerFrame.BackgroundTransparency = 1
        DividerFrame.Size = UDim2.new(1, 0, 0, 10)
        DividerFrame.LayoutOrder = #TabPage:GetChildren()

        local Divider = Instance.new("Frame")
        Divider.Name = "Divider"
        Divider.Parent = DividerFrame
        Divider.BackgroundColor3 = SelectedTheme.SecondaryElementStroke
        Divider.BorderSizePixel = 0
        Divider.Position = UDim2.new(0, 10, 0.5, 0)
        Divider.Size = UDim2.new(1, -20, 0, 1)
        Divider.BackgroundTransparency = 0.85

        return DividerFrame
    end

    function TabLibrary:CreateButton(ButtonConfig)
        assert(ButtonConfig.Name, "MythicZone | Missing name argument from CreateButton")
        ButtonConfig.Callback = ButtonConfig.Callback or function() end
        ButtonConfig.Info = ButtonConfig.Info or nil
        ButtonConfig.Icon = ButtonConfig.Icon or nil

        local Button = Elements.UIElementsTemplate.Button:Clone()
        Button.Name = ButtonConfig.Name
        Button.Title.Text = ButtonConfig.Name
        Button.Parent = TabPage
        Button.BackgroundColor3 = SelectedTheme.ElementBackground
        Button.UIStroke.Color = SelectedTheme.ElementStroke
        Button.LayoutOrder = #TabPage:GetChildren()

        if ButtonConfig.Icon then
            if typeof(ButtonConfig.Icon) == 'string' and Icons then
                local asset = getIcon(ButtonConfig.Icon)
                Button.Icon.Image = 'rbxassetid://'..asset.id
                Button.Icon.ImageRectOffset = asset.imageRectOffset
                Button.Icon.ImageRectSize = asset.imageRectSize
            else
                Button.Icon.Image = getAssetUri(ButtonConfig.Icon)
            end
            Button.Icon.Visible = true
            Button.Icon.ImageColor3 = SelectedTheme.TextColor
            Button.Title.Position = UDim2.new(0, 30, 0, 0)
        end

        Button.Interact.MouseButton1Click:Connect(function()
            local Success, Response = pcall(ButtonConfig.Callback)
            if not Success then
                warn("MythicZone | Button callback error: " .. tostring(Response))
            end
            TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
            wait(0.2)
            TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
        end)

        return Button
    end

    function TabLibrary:CreateToggle(ToggleConfig)
        assert(ToggleConfig.Name, "MythicZone | Missing name argument from CreateToggle")
        ToggleConfig.Flag = ToggleConfig.Flag or ToggleConfig.Name
        ToggleConfig.Default = ToggleConfig.Default or false
        ToggleConfig.Callback = ToggleConfig.Callback or function() end
        ToggleConfig.Info = ToggleConfig.Info or nil
        
        local Toggle = Elements.UIElementsTemplate.Toggle:Clone()
        Toggle.Name = ToggleConfig.Name
        Toggle.Title.Text = ToggleConfig.Name
        Toggle.Parent = TabPage
        Toggle.BackgroundColor3 = SelectedTheme.ElementBackground
        Toggle.UIStroke.Color = SelectedTheme.ElementStroke
        Toggle.LayoutOrder = #TabPage:GetChildren()

        local ToggleState = ToggleConfig.Default

        local ToggleElement = Toggle.ToggleFrame
        ToggleElement.BackgroundColor3 = ToggleState and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleBackground
        ToggleElement.UIStroke.Color = ToggleState and SelectedTheme.ToggleEnabledStroke or SelectedTheme.ToggleDisabledStroke
        ToggleElement.Indicator.Position = ToggleState and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        ToggleElement.Indicator.UIStroke.Color = ToggleState and SelectedTheme.ToggleEnabledOuterStroke or SelectedTheme.ToggleDisabledOuterStroke

        local ToggleFunction = {}
        
        function ToggleFunction:Set(Value)
            ToggleState = Value
            TweenService:Create(ToggleElement.Indicator, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { Position = ToggleState and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }):Play()
            TweenService:Create(ToggleElement, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { BackgroundColor3 = ToggleState and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled }):Play()
            TweenService:Create(ToggleElement.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { Color = ToggleState and SelectedTheme.ToggleEnabledStroke or SelectedTheme.ToggleDisabledStroke }):Play()
            TweenService:Create(ToggleElement.Indicator.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { Color = ToggleState and SelectedTheme.ToggleEnabledOuterStroke or SelectedTheme.ToggleDisabledOuterStroke }):Play()
            
            local Success, Response = pcall(function()
                ToggleConfig.Callback(ToggleState)
            end)
            if not Success then
                warn("MythicZone | Toggle callback error: " .. tostring(Response))
            end
        end

        ToggleFunction:Set(ToggleState)
        
        Toggle.Interact.MouseButton1Click:Connect(function()
            ToggleFunction:Set(not ToggleState)
        end)
        
        MythicLibrary.Flags[ToggleConfig.Flag] = ToggleFunction
        MythicLibrary.Flags[ToggleConfig.Flag].Type = "Toggle"
        MythicLibrary.Flags[ToggleConfig.Flag].CurrentValue = ToggleState
        
        return ToggleFunction
    end

    function TabLibrary:CreateSlider(SliderConfig)
        assert(SliderConfig.Name, "MythicZone | Missing name argument from CreateSlider")
        SliderConfig.Flag = SliderConfig.Flag or SliderConfig.Name
        SliderConfig.Min = SliderConfig.Min or 0
        SliderConfig.Max = SliderConfig.Max or 100
        SliderConfig.Default = SliderConfig.Default or SliderConfig.Min
        SliderConfig.Increment = SliderConfig.Increment or 1
        SliderConfig.Callback = SliderConfig.Callback or function() end
        SliderConfig.ValueName = SliderConfig.ValueName or ""
        SliderConfig.Info = SliderConfig.Info or nil

        local SliderValue = SliderConfig.Default
        local IsSliderDragging = false

        local Slider = Elements.UIElementsTemplate.Slider:Clone()
        Slider.Name = SliderConfig.Name
        Slider.Title.Text = SliderConfig.Name
        Slider.Parent = TabPage
        Slider.BackgroundColor3 = SelectedTheme.ElementBackground
        Slider.UIStroke.Color = SelectedTheme.ElementStroke
        Slider.LayoutOrder = #TabPage:GetChildren()

        local SliderFrame = Slider.SliderFrame
        SliderFrame.BackgroundColor3 = SelectedTheme.SliderBackground
        SliderFrame.UIStroke.Color = SelectedTheme.SliderStroke
        SliderFrame.Progress.BackgroundColor3 = SelectedTheme.SliderProgress
        
        SliderFrame.Value.PlaceholderText = tostring(SliderConfig.Default) .. " " .. SliderConfig.ValueName

        local function UpdateSliderValue(value)
            value = math.clamp(value, SliderConfig.Min, SliderConfig.Max)
            if SliderConfig.Increment then
                value = math.floor(value / SliderConfig.Increment + 0.5) * SliderConfig.Increment
            end
            
            if value < 0.01 then
                value = 0
            elseif value > SliderConfig.Max - 0.01 then
                value = SliderConfig.Max
            end

            value = tonumber(string.format("%.2f", value))
            
            SliderValue = value
            SliderFrame.Value.PlaceholderText = tostring(SliderValue) .. " " .. SliderConfig.ValueName
            local sliderSize = math.clamp((SliderValue - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1)
            TweenService:Create(SliderFrame.Progress, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {Size = UDim2.new(sliderSize, 0, 1, 0)}):Play()
            
            local Success, Response = pcall(function()
                SliderConfig.Callback(SliderValue)
            end)
            if not Success then
                warn("MythicZone | Slider callback error: " .. tostring(Response))
            end
        end

        UpdateSliderValue(SliderConfig.Default)

        SliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                IsSliderDragging = true
                local sliderPercent = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                local newValue = SliderConfig.Min + (sliderPercent * (SliderConfig.Max - SliderConfig.Min))
                UpdateSliderValue(newValue)
            end
        end)

        SliderFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                IsSliderDragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if IsSliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local sliderPercent = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                local newValue = SliderConfig.Min + (sliderPercent * (SliderConfig.Max - SliderConfig.Min))
                UpdateSliderValue(newValue)
            end
        end)

        SliderFrame.Value.FocusLost:Connect(function()
            local value = tonumber(SliderFrame.Value.Text)
            if value then
                UpdateSliderValue(value)
            else
                SliderFrame.Value.Text = ""
            end
        end)

        local SliderFunctions = {}

        function SliderFunctions:Set(Value)
            UpdateSliderValue(Value)
            MythicLibrary.Flags[SliderConfig.Flag].CurrentValue = Value
        end

        MythicLibrary.Flags[SliderConfig.Flag] = SliderFunctions
        MythicLibrary.Flags[SliderConfig.Flag].Type = "Slider"
        MythicLibrary.Flags[SliderConfig.Flag].CurrentValue = SliderValue

        return SliderFunctions
    end

    function TabLibrary:CreateDropdown(DropdownConfig)
        assert(DropdownConfig.Name, "MythicZone | Missing name argument from CreateDropdown")
        DropdownConfig.Flag = DropdownConfig.Flag or DropdownConfig.Name
        DropdownConfig.Options = DropdownConfig.Options or {}
        DropdownConfig.Default = DropdownConfig.Default or nil
        DropdownConfig.Callback = DropdownConfig.Callback or function() end
        DropdownConfig.Info = DropdownConfig.Info or nil

        local Dropdown = Elements.UIElementsTemplate.Dropdown:Clone()
        Dropdown.Name = DropdownConfig.Name
        Dropdown.Title.Text = DropdownConfig.Name
        Dropdown.Parent = TabPage
        Dropdown.BackgroundColor3 = SelectedTheme.ElementBackground
        Dropdown.UIStroke.Color = SelectedTheme.ElementStroke
        Dropdown.LayoutOrder = #TabPage:GetChildren()

        local DropdownFrame = Dropdown.DropdownFrame
        DropdownFrame.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
        DropdownFrame.UIStroke.Color = SelectedTheme.SecondaryElementStroke
        DropdownFrame.Selected.TextColor3 = SelectedTheme.TextColor
        DropdownFrame.Icon.ImageColor3 = SelectedTheme.TextColor
        
        local DropdownListContainer = Dropdown.OptionContainer
        DropdownListContainer.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
        DropdownListContainer.UIStroke.Color = SelectedTheme.SecondaryElementStroke
        
        local IsOpen = false
        local SelectedOption = DropdownConfig.Default or "Select..."
        DropdownFrame.Selected.Text = SelectedOption
        DropdownListContainer.Visible = false

        local function ShowOptions()
            IsOpen = true
            DropdownListContainer.Size = UDim2.new(1, -10, 0, 0)
            DropdownListContainer.Position = UDim2.new(0, 5, 0, 35)
            DropdownListContainer.Visible = true
            DropdownListContainer.ScrollBarThickness = 4
            TweenService:Create(DropdownFrame.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Rotation = 180}):Play()
            TweenService:Create(DropdownListContainer, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -10, 0, math.clamp(#DropdownListContainer:GetChildren() * 25, 0, 150))}):Play()
        end

        local function HideOptions()
            IsOpen = false
            TweenService:Create(DropdownFrame.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Rotation = 0}):Play()
            TweenService:Create(DropdownListContainer, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -10, 0, 0)}):Play()
            task.wait(0.3)
            DropdownListContainer.Visible = false
            DropdownListContainer.ScrollBarThickness = 0
        end

        local function SelectOption(option)
            SelectedOption = option
            DropdownFrame.Selected.Text = option
            
            local Success, Response = pcall(function()
                DropdownConfig.Callback(option)
            end)
            if not Success then
                warn("MythicZone | Dropdown callback error: " .. tostring(Response))
            end
            
            HideOptions()
        end

        for _, Option in pairs(DropdownListContainer:GetChildren()) do
            if Option:IsA("TextButton") then
                Option:Destroy()
            end
        end
        
        -- Populate options
        for _, option in ipairs(DropdownConfig.Options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = option
            OptionButton.Parent = DropdownListContainer
            OptionButton.BackgroundTransparency = 1
            OptionButton.Size = UDim2.new(1, 0, 0, 25)
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Text = option
            OptionButton.TextColor3 = SelectedTheme.TextColor
            OptionButton.TextSize = 14
            OptionButton.TextTransparency = 0.3
            
            OptionButton.MouseButton1Click:Connect(function()
                SelectOption(option)
            end)
            
            OptionButton.MouseEnter:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.15, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.8, TextTransparency = 0}):Play()
                OptionButton.BackgroundColor3 = SelectedTheme.DropdownSelected
            end)
            
            OptionButton.MouseLeave:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.15, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1, TextTransparency = 0.3}):Play()
            end)
        end

        DropdownFrame.Interact.MouseButton1Click:Connect(function()
            if IsOpen then
                HideOptions()
            else
                ShowOptions()
            end
        end)

        local DropdownFunctions = {}

        function DropdownFunctions:Set(Value)
            if table.find(DropdownConfig.Options, Value) then
                SelectOption(Value)
                MythicLibrary.Flags[DropdownConfig.Flag].CurrentOption = Value
            end
        end

        function DropdownFunctions:Refresh(NewOptions, KeepSelection)
            DropdownConfig.Options = NewOptions or {}
            
            -- Clear current options
            for _, Option in pairs(DropdownListContainer:GetChildren()) do
                if Option:IsA("TextButton") then
                    Option:Destroy()
                end
            end
            
            -- Add new options
            for _, option in ipairs(DropdownConfig.Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Parent = DropdownListContainer
                OptionButton.BackgroundTransparency = 1
                OptionButton.Size = UDim2.new(1, 0, 0, 25)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = option
                OptionButton.TextColor3 = SelectedTheme.TextColor
                OptionButton.TextSize = 14
                OptionButton.TextTransparency = 0.3
                
                OptionButton.MouseButton1Click:Connect(function()
                    SelectOption(option)
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.15, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.8, TextTransparency = 0}):Play()
                    OptionButton.BackgroundColor3 = SelectedTheme.DropdownSelected
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.15, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1, TextTransparency = 0.3}):Play()
                end)
            end
            
            if not KeepSelection or not table.find(DropdownConfig.Options, SelectedOption) then
                SelectedOption = "Select..."
                DropdownFrame.Selected.Text = SelectedOption
                MythicLibrary.Flags[DropdownConfig.Flag].CurrentOption = nil
            end
        end

        -- Set default
        if DropdownConfig.Default then
            SelectOption(DropdownConfig.Default)
        end

        MythicLibrary.Flags[DropdownConfig.Flag] = DropdownFunctions
        MythicLibrary.Flags[DropdownConfig.Flag].Type = "Dropdown"
        MythicLibrary.Flags[DropdownConfig.Flag].CurrentOption = SelectedOption == "Select..." and nil or SelectedOption

        return DropdownFunctions
    end

    function TabLibrary:CreateInput(InputConfig)
        assert(InputConfig.Name, "MythicZone | Missing name argument from CreateInput")
        InputConfig.Flag = InputConfig.Flag or InputConfig.Name
        InputConfig.Default = InputConfig.Default or ""
        InputConfig.PlaceholderText = InputConfig.PlaceholderText or "Enter text..."
        InputConfig.ClearTextOnFocus = InputConfig.ClearTextOnFocus ~= nil and InputConfig.ClearTextOnFocus or false
        InputConfig.Callback = InputConfig.Callback or function() end
        InputConfig.Info = InputConfig.Info or nil

        local Input = Elements.UIElementsTemplate.Input:Clone()
        Input.Name = InputConfig.Name
        Input.Title.Text = InputConfig.Name
        Input.Parent = TabPage
        Input.BackgroundColor3 = SelectedTheme.ElementBackground
        Input.UIStroke.Color = SelectedTheme.ElementStroke
        Input.LayoutOrder = #TabPage:GetChildren()

        local InputBox = Input.InputFrame.InputBox
        InputBox.PlaceholderText = InputConfig.PlaceholderText
        InputBox.Text = InputConfig.Default
        InputBox.ClearTextOnFocus = InputConfig.ClearTextOnFocus
        InputBox.TextColor3 = SelectedTheme.TextColor
        InputBox.PlaceholderColor3 = SelectedTheme.PlaceholderColor
        
        Input.InputFrame.BackgroundColor3 = SelectedTheme.InputBackground
        Input.InputFrame.UIStroke.Color = SelectedTheme.InputStroke

        InputBox.FocusLost:Connect(function(enterPressed)
            local Success, Response = pcall(function()
                InputConfig.Callback(InputBox.Text)
            end)
            if not Success then
                warn("MythicZone | Input callback error: " .. tostring(Response))
            end
        end)

        local InputFunctions = {}

        function InputFunctions:Set(Text)
            InputBox.Text = Text
            MythicLibrary.Flags[InputConfig.Flag].CurrentValue = Text
        end

        MythicLibrary.Flags[InputConfig.Flag] = InputFunctions
        MythicLibrary.Flags[InputConfig.Flag].Type = "Input"
        MythicLibrary.Flags[InputConfig.Flag].CurrentValue = InputConfig.Default

        return InputFunctions
    end

    return TabLibrary
end

-- Initialize UI
function MythicLibrary:Init()
    MythicZone.Enabled = true
    Main.Visible = true
    Main.Size = UDim2.new(0, 500, 0, 0)
    Main.Topbar.Title.TextTransparency = 1
    Main.BackgroundTransparency = 1
    Main.Topbar.BackgroundTransparency = 1
    Main.Topbar.Divider.BackgroundTransparency = 1
    Main.Shadow.Image.ImageTransparency = 1
    
    task.wait(0.5)
    TweenService:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0, Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
    TweenService:Create(Main.Topbar, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main.Topbar.Divider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main.Topbar.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
    TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()
    
    task.wait(0.5)
    
    TabList.Visible = true
    Elements.Visible = true
    
    makeDraggable(Main, Topbar, false)
    if dragBar then
        makeDraggable(Main, dragInteract, true, {dragOffset, dragOffsetMobile})
    end
    
    Elements.UIPageLayout:JumpToIndex(1)
    
    -- Configure Keybind Opener
    if MPrompt then
        MPrompt.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        MPrompt.MouseEnter:Connect(function()
            TweenService:Create(MPrompt.Title, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(MPrompt, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
        end)
        
        MPrompt.MouseLeave:Connect(function()
            TweenService:Create(MPrompt.Title, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(MPrompt, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
        end)
        
        MPrompt.MouseButton1Click:Connect(function()
            if not Hidden then return end
            
            task.spawn(Unhide)
            Hidden = false
        end)
    end
    
    -- Configure buttons
    Topbar.ChangeSize.MouseButton1Click:Connect(function()
        if Debounce then return end
        
        if Minimised then
            task.spawn(Maximise)
            Minimised = false
        else
            task.spawn(Minimise)
            Minimised = true
        end
    end)
    
    Topbar.Hide.MouseButton1Click:Connect(function()
        if Debounce then return end
        
        task.spawn(Hide, true)
        Hidden = true
    end)
    
    Topbar.Search.MouseButton1Click:Connect(function()
        if searchOpen then
            task.spawn(closeSearch)
        else
            task.spawn(openSearch)
        end
    end)
    
    Main.Search.Input:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = string.lower(Main.Search.Input.Text)
        
        if searchText == "" then
            for _, tab in ipairs(Elements:GetChildren()) do
                if tab.Name ~= "Template" and tab.ClassName == "ScrollingFrame" and tab.Name ~= "Placeholder" then
                    for _, element in ipairs(tab:GetChildren()) do
                        if element.ClassName == "Frame" and element.Name ~= "SectionSpacing" and element.Name ~= "Placeholder" and element.Name ~= "SearchTitle-fsefsefesfsefesfesfThanks" then
                            if element:FindFirstChild("Title") then
                                element.Visible = true
                            end
                        end
                    end
                end
            end
        else
            for _, tab in ipairs(Elements:GetChildren()) do
                if tab.Name ~= "Template" and tab.ClassName == "ScrollingFrame" and tab.Name ~= "Placeholder" then
                    for _, element in ipairs(tab:GetChildren()) do
                        if element.ClassName == "Frame" and element.Name ~= "SectionSpacing" and element.Name ~= "Placeholder" and element.Name ~= "SearchTitle-fsefsefesfsefesfesfThanks" then
                            if element:FindFirstChild("Title") then
                                if string.find(string.lower(element.Title.Text), searchText) then
                                    element.Visible = true
                                else
                                    element.Visible = false
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- Set theme
    ChangeTheme(MythicLibrary.Theme.Default)
    
    globalLoaded = true
    return MythicLibrary
end

return MythicLibrary
