-- Cosmic UI Library - v2.0 (Rayfield Feature Integration)
-- A futuristic, animated UI library for Roblox, inspired by Rayfield features.

--[[ Services ]]--
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

--[[ Environment & Polyfills ]]--
local useStudio = RunService:IsStudio()
local writefile = writefile or function() warn("CosmicUI: writefile not available.") end
local readfile = readfile or function() warn("CosmicUI: readfile not available."); return nil end
local isfolder = isfolder or function() warn("CosmicUI: isfolder not available."); return false end
local makefolder = makefolder or function() warn("CosmicUI: makefolder not available.") end
local isfile = isfile or function() warn("CosmicUI: isfile not available."); return false end
local request = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request or function() warn("CosmicUI: request not available.") end
local gethui = gethui or function() return CoreGui end -- Basic fallback

--[[ Library Object ]]--
local Cosmic = {}
Cosmic.__index = Cosmic
Cosmic.ActiveWindows = {}
Cosmic.Flags = {} -- For configuration saving
Cosmic.GlobalLoaded = false -- Track if LoadConfiguration has run
Cosmic.BuildVersion = "Cosmic-2.0" -- Example build info

--[[ Icons (Placeholder - Requires Lucide Integration like Rayfield) ]]--
-- In a real scenario, load the Icons table like Rayfield does
local Icons = nil -- Load the icon library here if available
local function getIcon(name)
    if not Icons then return { id = 0, imageRectSize = Vector2.zero, imageRectOffset = Vector2.zero } end
    -- Add Rayfield's getIcon logic here
    name = string.match(string.lower(name), "^%s*(.*)%s*$") :: string
    local sizedicons = Icons['48px'] -- Assuming 48px icons
    local r = sizedicons and sizedicons[name]
    if not r then
        warn(`CosmicUI Icons: Failed to find icon by the name of "{name}"`)
        return { id = 0, imageRectSize = Vector2.zero, imageRectOffset = Vector2.zero }
    end
    local rirs = r[2]
    local riro = r[3]
    if type(r[1]) ~= "number" or type(rirs) ~= "table" or type(riro) ~= "table" then
        warn("CosmicUI Icons: Internal error: Invalid asset entry")
        return { id = 0, imageRectSize = Vector2.zero, imageRectOffset = Vector2.zero }
    end
    local irs = Vector2.new(rirs[1], rirs[2])
    local iro = Vector2.new(riro[1], riro[2])
    return { id = r[1], imageRectSize = irs, imageRectOffset = iro }
end
local function getAssetUri(idOrName)
    if type(idOrName) == "number" then
        return "rbxassetid://" .. idOrName
    elseif type(idOrName) == "string" and Icons then
        local asset = getIcon(idOrName)
        return "rbxassetid://" .. asset.id
    elseif type(idOrName) == "string" and not Icons then
        warn("CosmicUI: Cannot use icon names as icon library is not loaded.")
        return "rbxassetid://0"
    else
        return "rbxassetid://0" -- Default/Error
    end
end


--[[ Cosmic Themes (Ported & Adapted from Rayfield + Original Cosmic) ]]--
Cosmic.Themes = {
    ["Cosmic Dark"] = { -- Original Cosmic Theme
        Name = "Cosmic Dark",
        TextColor = Color3.fromRGB(230, 230, 255),
        TextSecondary = Color3.fromRGB(150, 150, 180),
        TextDisabled = Color3.fromRGB(80, 80, 100),
        Background = Color3.fromRGB(10, 5, 25),
        Topbar = Color3.fromRGB(15, 10, 35), -- Slightly lighter topbar
        Shadow = Color3.fromRGB(5, 0, 15), -- Darker shadow
        NotificationBackground = Color3.fromRGB(20, 15, 40),
        TabBackground = Color3.fromRGB(20, 15, 40),
        TabStroke = Color3.fromRGB(40, 30, 70),
        TabBackgroundSelected = Color3.fromRGB(100, 80, 255), -- Primary color
        TabTextColor = Color3.fromRGB(150, 150, 180),
        SelectedTabTextColor = Color3.fromRGB(255, 255, 255), -- Bright white
        ElementBackground = Color3.fromRGB(20, 15, 40),
        ElementBackgroundHover = Color3.fromRGB(35, 30, 60),
        SecondaryElementBackground = Color3.fromRGB(15, 10, 35), -- e.g., Labels
        ElementStroke = Color3.fromRGB(40, 30, 70),
        SecondaryElementStroke = Color3.fromRGB(30, 20, 50),
        SliderBackground = Color3.fromRGB(30, 25, 55), -- Dimmer track
        SliderProgress = Color3.fromRGB(100, 80, 255), -- Primary
        SliderStroke = Color3.fromRGB(0, 220, 255), -- Accent
        ToggleBackground = Color3.fromRGB(30, 25, 55),
        ToggleEnabled = Color3.fromRGB(0, 220, 255), -- Accent
        ToggleDisabled = Color3.fromRGB(80, 80, 100),
        ToggleEnabledStroke = Color3.fromRGB(100, 240, 255), -- Brighter Accent
        ToggleDisabledStroke = Color3.fromRGB(100, 100, 120),
        ToggleEnabledOuterStroke = Color3.fromRGB(0, 180, 220), -- Slightly darker Accent
        ToggleDisabledOuterStroke = Color3.fromRGB(50, 40, 80),
        DropdownSelected = Color3.fromRGB(35, 30, 60), -- Hover color
        DropdownUnselected = Color3.fromRGB(20, 15, 40), -- Element Background
        InputBackground = Color3.fromRGB(15, 10, 35), -- Darker Input
        InputStroke = Color3.fromRGB(0, 220, 255), -- Accent Stroke
        PlaceholderColor = Color3.fromRGB(80, 80, 100),
        GlowColor = Color3.fromRGB(0, 220, 255),
        Accent = Color3.fromRGB(0, 220, 255),
        Primary = Color3.fromRGB(100, 80, 255),
        Error = Color3.fromRGB(255, 60, 100),
        Font = Enum.Font.TitilliumWeb,
        FontBold = Enum.Font.TitilliumWeb,
        FontTitle = Enum.Font.TitilliumWeb,
        TextSize = 15,
        TextSizeSmall = 13,
        TextSizeTitle = 18,
        Padding = 10,
        SmallPadding = 5,
        ElementHeight = 38,
        TitleBarHeight = 35,
        ScrollBarThickness = 5,
        CornerRadius = UDim.new(0, 4),
        SmallCornerRadius = UDim.new(0, 2),
        AnimationSpeed = 0.2,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out,
        Icons = { -- Default Icons (Placeholders)
            DefaultTab = "rbxassetid://6031069821",
            Close = "rbxassetid://5108077919",
            Minimize = "rbxassetid://5108077471", -- Placeholder for Hide
            Maximize = "rbxassetid://11036884234", -- Placeholder for Maximize
            Restore = "rbxassetid://10137941941", -- Placeholder for Restore
            Search = "rbxassetid://6031069821", -- Placeholder
            Settings = "rbxassetid://6031069821", -- Placeholder
            DropdownArrow = "rbxassetid://6031069821",
            Keybind = "rbxassetid://6031069821",
            NotificationDefault = "rbxassetid://4370033185",
        }
    },
    -- Add other Rayfield themes here, adapting colors slightly if needed for the Cosmic style
    -- ["Default"] = RayfieldLibrary.Theme.Default, -- Assuming RayfieldLibrary is accessible or copy themes
    -- ["Ocean"] = RayfieldLibrary.Theme.Ocean,
    -- ["AmberGlow"] = RayfieldLibrary.Theme.AmberGlow,
    -- ["Light"] = RayfieldLibrary.Theme.Light,
    -- ["Amethyst"] = RayfieldLibrary.Theme.Amethyst,
    -- ["Green"] = RayfieldLibrary.Theme.Green,
    -- ["Bloom"] = RayfieldLibrary.Theme.Bloom,
    -- ["DarkBlue"] = RayfieldLibrary.Theme.DarkBlue,
    -- ["Serenity"] = RayfieldLibrary.Theme.Serenity,
    -- Add more themes...
    -- TODO: Copy the actual theme data from Rayfield themes here instead of referencing RayfieldLibrary
    -- Example structure for a copied theme:
    -- ["Ocean"] = {
    --    Name = "Ocean",
    --    TextColor = Color3.fromRGB(210, 220, 255),
    --    Background = Color3.fromRGB(20, 30, 50),
    --    -- ... other properties copied from Rayfield's Ocean theme ...
    --    Icons = { -- Ensure Icons table exists for each theme or handle fallback
    --        DefaultTab = "rbxassetid://...",
    --        -- ... other icons ...
    --    }
    -- },
}
Cosmic.SelectedTheme = Cosmic.Themes["Cosmic Dark"] -- Default theme

--[[ Utility Functions ]]--
local function CreateTweenInfo(speedOverride, styleOverride, directionOverride)
    -- Add nil check for Cosmic.SelectedTheme just in case
    local theme = Cosmic.SelectedTheme or {}
    return TweenInfo.new(
        speedOverride or theme.AnimationSpeed or 0.2,
        styleOverride or theme.EasingStyle or Enum.EasingStyle.Quad,
        directionOverride or theme.EasingDirection or Enum.EasingDirection.Out
    )
end

local function PlayTween(object, propertyTable, speedOverride, styleOverride, directionOverride)
    local tweenInfo = CreateTweenInfo(speedOverride, styleOverride, directionOverride)
    local tween = TweenService:Create(object, tweenInfo, propertyTable)
    tween:Play()
    return tween
end

local function ApplyGlow(guiObject, color, transparency, thickness)
    -- Simplified glow using UIStroke for broader compatibility
    local glow = guiObject:FindFirstChild("GlowStroke") or Instance.new("UIStroke")
    glow.Name = "GlowStroke"
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Color = color or Cosmic.SelectedTheme.GlowColor or Cosmic.SelectedTheme.Accent
    glow.Transparency = transparency or 0.7
    glow.Thickness = thickness or 1.5
    glow.LineJoinMode = Enum.LineJoinMode.Round
    glow.Enabled = true
    glow.Parent = guiObject
    return glow
end

local function ApplyThemeStyle(guiObject, elementType)
    -- Add a check at the very beginning to prevent errors if guiObject is nil
    if not guiObject then
        warn("CosmicUI: ApplyThemeStyle called with nil guiObject for type:", elementType)
        return
    end

    local theme = Cosmic.SelectedTheme or {} -- Use empty table as fallback

    -- Basic Defaults
    -- Check if guiObject is valid before calling methods
    if typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject") then
        guiObject.BackgroundColor3 = theme.ElementBackground or Color3.fromRGB(35, 35, 35)
        guiObject.BorderSizePixel = 0
        if guiObject:IsA("Frame") or guiObject:IsA("ScrollingFrame") or guiObject:IsA("TextBox") or guiObject:IsA("TextButton") then
             guiObject.BackgroundTransparency = 0
        else
             guiObject.BackgroundTransparency = 1 -- Default others to transparent
        end
    else
        -- If it's not a valid GuiObject, exit early
        warn("CosmicUI: ApplyThemeStyle called with invalid object:", guiObject, "for type:", elementType)
        return
    end

    -- Continue with the rest of the styling, now knowing guiObject is valid
    if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
        guiObject.Font = theme.Font or Enum.Font.SourceSans
        guiObject.TextColor3 = theme.TextColor or Color3.fromRGB(240, 240, 240)
        guiObject.TextSize = theme.TextSize or 14
        guiObject.TextWrapped = true
        guiObject.TextXAlignment = Enum.TextXAlignment.Left
        guiObject.TextYAlignment = Enum.TextYAlignment.Center
    end
    if guiObject:IsA("ImageLabel") or guiObject:IsA("ImageButton") then
        guiObject.ImageColor3 = theme.TextColor or Color3.fromRGB(240, 240, 240)
        guiObject.BackgroundTransparency = 1
    end

    -- Corner Radius
    local corner = guiObject:FindFirstChildWhichIsA("UICorner") or Instance.new("UICorner")
    corner.CornerRadius = theme.CornerRadius or UDim.new(0, 4)
    corner.Parent = guiObject

    -- Stroke
    local stroke = guiObject:FindFirstChild("BaseStroke") or Instance.new("UIStroke")
    stroke.Name = "BaseStroke"
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = theme.ElementStroke or Color3.fromRGB(50, 50, 50)
    stroke.Thickness = 1
    stroke.Transparency = 0
    stroke.Enabled = true
    stroke.Parent = guiObject

    -- Element Specific Overrides (Simplified - expand as needed based on Rayfield themes)
    if elementType == "Window" then
        guiObject.BackgroundColor3 = theme.Background
        if stroke then stroke.Color = theme.Shadow or theme.Background; stroke.Thickness = 2; end -- Use shadow as border
    elseif elementType == "TitleBar" then
        guiObject.BackgroundColor3 = theme.Topbar
        if corner then corner.Parent = nil; corner:Destroy() end
        if stroke then stroke.Enabled = false end
    elseif elementType == "Button" then
        guiObject.BackgroundColor3 = theme.Primary or theme.ElementBackground
        guiObject.TextColor3 = theme.SelectedTabTextColor or theme.TextColor
        corner.CornerRadius = theme.SmallCornerRadius or UDim.new(0, 2)
        if stroke then stroke.Enabled = false end
    elseif elementType == "TabButton" then
        guiObject.BackgroundColor3 = theme.TabBackground
        guiObject.TextColor3 = theme.TabTextColor
        corner.CornerRadius = theme.SmallCornerRadius or UDim.new(0, 2)
        stroke.Color = theme.TabStroke
        stroke.Transparency = 0.5
    elseif elementType == "TabButtonActive" then
        guiObject.BackgroundColor3 = theme.TabBackgroundSelected
        guiObject.TextColor3 = theme.SelectedTabTextColor
        corner.CornerRadius = theme.SmallCornerRadius or UDim.new(0, 2)
        if stroke then stroke.Transparency = 1 end -- Hide stroke when active
    elseif elementType == "TabContent" then
        guiObject.BackgroundColor3 = theme.Background
        if corner then corner.Parent = nil; corner:Destroy() end
        if stroke then stroke.Enabled = false end
    elseif elementType == "ScrollingFrame" then
        guiObject.BackgroundColor3 = Color3.clear(1)
        guiObject.BorderSizePixel = 0
        guiObject.ScrollBarThickness = theme.ScrollBarThickness or 6
        guiObject.ScrollBarImageColor3 = theme.Accent or theme.SliderProgress
        if corner then corner.Parent = nil; corner:Destroy() end
        if stroke then stroke.Enabled = false end
    elseif elementType == "TextBox" then
        guiObject.BackgroundColor3 = theme.InputBackground
        guiObject.TextColor3 = theme.TextColor
        guiObject.PlaceholderColor3 = theme.PlaceholderColor or theme.TextDisabled
        corner.CornerRadius = theme.SmallCornerRadius or UDim.new(0, 2)
        stroke.Color = theme.InputStroke
        stroke.Enabled = true
    elseif elementType == "Label" then
        guiObject.BackgroundColor3 = theme.SecondaryElementBackground or theme.ElementBackground
        guiObject.TextColor3 = theme.TextColor
        stroke.Color = theme.SecondaryElementStroke or theme.ElementStroke
    elseif elementType == "DropdownList" then -- The dropdown frame itself when open
        guiObject.BackgroundColor3 = theme.Background -- Match window bg
        stroke.Color = theme.ElementStroke
        stroke.Thickness = 1.5
    elseif elementType == "DropdownOption" then
        guiObject.BackgroundColor3 = theme.DropdownUnselected
        guiObject.TextColor3 = theme.TextColor
        corner.CornerRadius = theme.SmallCornerRadius or UDim.new(0, 2)
        stroke.Color = theme.ElementStroke
        stroke.Transparency = 0.5
    elseif elementType == "DropdownOptionSelected" then
        guiObject.BackgroundColor3 = theme.DropdownSelected
        guiObject.TextColor3 = theme.SelectedTabTextColor or theme.TextColor -- Use brighter text
        corner.CornerRadius = theme.SmallCornerRadius or UDim.new(0, 2)
        stroke.Color = theme.ElementStroke
        stroke.Transparency = 0
    elseif elementType == "SliderTrack" then
        guiObject.BackgroundColor3 = theme.SliderBackground
        corner.CornerRadius = UDim.new(1, 0) -- Pill shape
        stroke.Color = theme.SliderStroke
        stroke.Transparency = 0.4
    elseif elementType == "SliderFill" then
        guiObject.BackgroundColor3 = theme.SliderProgress
        corner.CornerRadius = UDim.new(1, 0)
        stroke.Color = theme.SliderStroke
        stroke.Transparency = 0.3
    elseif elementType == "ToggleFrame" then
        guiObject.BackgroundColor3 = theme.ToggleBackground
        corner.CornerRadius = UDim.new(1, 0) -- Pill shape
        stroke.Color = theme.ToggleDisabledOuterStroke -- Start with disabled outer stroke
        stroke.Enabled = true
    elseif elementType == "ToggleIndicator" then
        guiObject.BackgroundColor3 = theme.ToggleDisabled -- Start disabled
        corner.CornerRadius = UDim.new(0.5, 0) -- Circle
        stroke.Color = theme.ToggleDisabledStroke -- Start disabled inner stroke
        stroke.Enabled = true
    elseif elementType == "ColorPickerDisplay" then
        corner.CornerRadius = theme.SmallCornerRadius or UDim.new(0, 2)
        stroke.Color = theme.ElementStroke
        stroke.Enabled = true
    -- Add more specific styles based on Rayfield's themes
    end
end

-- Helper to create an icon using ImageLabel or TextLabel (if using icon fonts)
local function CreateIcon(assetIdOrName, parent, size, position, color)
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.BackgroundTransparency = 1
    icon.Size = size or UDim2.new(0, 18, 0, 18)
    icon.Position = position or UDim2.fromScale(0, 0.5)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.ImageColor3 = color or Cosmic.SelectedTheme.TextColor
    icon.ScaleType = Enum.ScaleType.Fit

    if type(assetIdOrName) == "number" then
        icon.Image = "rbxassetid://" .. assetIdOrName
    elseif type(assetIdOrName) == "string" and Icons then
        local asset = getIcon(assetIdOrName)
        icon.Image = "rbxassetid://" .. asset.id
        icon.ImageRectOffset = asset.imageRectOffset
        icon.ImageRectSize = asset.imageRectSize
    else
        icon.Image = "rbxassetid://0" -- Default/Error
    end

    icon.Parent = parent
    return icon
end

-- Draggable Functionality (Adapted from Rayfield)
local function makeDraggable(object, dragObject, enableTaptic, tapticBar, tapticOffset)
    local dragging = false
    local relative = nil
    local screenGui = object:FindFirstAncestorWhichIsA("ScreenGui")
    local offset = (screenGui and screenGui.IgnoreGuiInset) and GuiService:GetGuiInset() or Vector2.zero

    local tapticBarCosmetic = tapticBar and tapticBar:FindFirstChild("Drag")

    local function updateTapticBar(state)
        if not tapticBar or not tapticBarCosmetic or not enableTaptic then return end
        if state == "dragging" then
            PlayTween(tapticBarCosmetic, {Size = UDim2.new(0, 110, 0, 4), BackgroundTransparency = 0}, 0.35, Enum.EasingStyle.Back)
        elseif state == "hover" then
            PlayTween(tapticBarCosmetic, {BackgroundTransparency = 0.5, Size = UDim2.new(0, 120, 0, 4)}, 0.25, Enum.EasingStyle.Back)
        else -- normal / leave
            PlayTween(tapticBarCosmetic, {BackgroundTransparency = 0.7, Size = UDim2.new(0, 100, 0, 4)}, 0.25, Enum.EasingStyle.Back)
        end
    end

    local connections = {}

    if enableTaptic and tapticBar then
        table.insert(connections, tapticBar.MouseEnter:Connect(function() if not dragging then updateTapticBar("hover") end end))
        table.insert(connections, tapticBar.MouseLeave:Connect(function() if not dragging then updateTapticBar("normal") end end))
    end

    table.insert(connections, dragObject.InputBegan:Connect(function(input, processed)
        if processed then return end
        local inputType = input.UserInputType
        if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
            dragging = true
            relative = object.AbsolutePosition + object.AbsoluteSize * object.AnchorPoint - UserInputService:GetMouseLocation()
            updateTapticBar("dragging")
            input:GetPropertyChangedSignal("UserInputState"):Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    -- Check if mouse is still over the taptic bar on release
                    local mousePos = UserInputService:GetMouseLocation()
                    local barPos = tapticBar.AbsolutePosition
                    local barSize = tapticBar.AbsoluteSize
                    if enableTaptic and mousePos.X >= barPos.X and mousePos.X <= barPos.X + barSize.X and mousePos.Y >= barPos.Y and mousePos.Y <= barPos.Y + barSize.Y then
                        updateTapticBar("hover")
                    else
                        updateTapticBar("normal")
                    end
                end
            end)
        end
    end))

    table.insert(connections, RunService.RenderStepped:Connect(function()
        if dragging then
            local position = UserInputService:GetMouseLocation() + relative + offset
            -- Basic screen clamping
            local viewportSize = workspace.CurrentCamera.ViewportSize
            local guiInset = GuiService:GetGuiInset()
            local absSize = object.AbsoluteSize
            local anchor = object.AnchorPoint
            local minX = absSize.X * anchor.X
            local maxX = viewportSize.X - absSize.X * (1 - anchor.X)
            local minY = guiInset.Y + absSize.Y * anchor.Y
            local maxY = viewportSize.Y - absSize.Y * (1 - anchor.Y)

            position = Vector2.new(math.clamp(position.X, minX, maxX), math.clamp(position.Y, minY, maxY))

            local targetPos = UDim2.fromOffset(position.X, position.Y)

            if enableTaptic and tapticOffset then
                PlayTween(object, {Position = targetPos}, 0.1, Enum.EasingStyle.Exponential) -- Faster tween for main window
                if tapticBar then
                    local tapticYOffset = tapticOffset[1] -- Use index 1 for offset
                    PlayTween(tapticBar, {Position = UDim2.fromOffset(position.X, position.Y + tapticYOffset)}, 0.05, Enum.EasingStyle.Exponential)
                end
            else
                object.Position = targetPos
                if tapticBar and tapticOffset then
                    local tapticYOffset = tapticOffset[1]
                    tapticBar.Position = UDim2.fromOffset(position.X, position.Y + tapticYOffset)
                end
            end
        end
    end))

    -- Return connections table for cleanup
    return connections
end

-- Configuration Saving Utilities (Adapted from Rayfield)
local function PackColor(color)
    return {R = math.floor(color.R * 255 + 0.5), G = math.floor(color.G * 255 + 0.5), B = math.floor(color.B * 255 + 0.5)}
end
local function UnpackColor(colorTable)
    return Color3.fromRGB(colorTable.R or 0, colorTable.G or 0, colorTable.B or 0)
end

--[[ Window ]]--
function Cosmic:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "Cosmic UI"
    config.Title = config.Title or config.Name -- Use Name if Title missing
    config.Size = config.Size or UDim2.new(0, 550, 0, 400)
    config.Position = config.Position -- Default to centered in Show() if nil
    config.Draggable = config.Draggable ~= false
    config.StartVisible = config.StartVisible ~= false
    config.ShowTopbar = config.ShowTopbar ~= false
    config.Icon = config.Icon -- Asset ID or Lucide Name
    config.Theme = config.Theme or "Cosmic Dark" -- Theme name or table

    -- Ensure selected theme exists before accessing properties
    local selectedThemeData = (type(config.Theme) == "string" and Cosmic.Themes[config.Theme]) or (type(config.Theme) == "table" and config.Theme) or Cosmic.SelectedTheme
    if not selectedThemeData then
        warn("CosmicUI: Specified or default theme ('" .. tostring(config.Theme) .. "' or 'Cosmic Dark') not found. Falling back to basic defaults.")
        selectedThemeData = Cosmic.Themes["Cosmic Dark"] or {} -- Fallback to Cosmic Dark or empty table
    end

    config.TopbarHeight = config.TopbarHeight or selectedThemeData.TitleBarHeight or 35

    -- Rayfield specific configs
    config.ConfigurationSaving = config.ConfigurationSaving or { Enabled = false }
    config.ConfigurationSaving.FolderName = config.ConfigurationSaving.FolderName or "CosmicUI_Configs"
    config.ConfigurationSaving.FileName = config.ConfigurationSaving.FileName or tostring(game.PlaceId or "default")
    config.Discord = config.Discord or { Enabled = false }
    config.KeySystem = config.KeySystem or false
    config.KeySettings = config.KeySettings or {}
    config.DisableRayfieldPrompts = config.DisableRayfieldPrompts -- Keep name for compatibility

    local window = {
        Visible = false,
        IsDragging = false,
        DragStart = nil,
        StartPos = nil,
        Tabs = {},
        ActiveTab = nil,
        Elements = {}, -- For elements not in tabs (like settings)
        Config = config,
        Connections = {},
        IsMinimized = false,
        OriginalSize = config.Size,
        OriginalPosition = nil, -- Store position before minimize/hide
        ThemeConnections = {}, -- Connections to update theme
        SearchOpen = false,
        CFileName = config.ConfigurationSaving.FileName,
        CFolderName = config.ConfigurationSaving.FolderName,
        CEnabled = config.ConfigurationSaving.Enabled,
    }
    setmetatable(window, Cosmic)

    -- Define UpdateElementThemes function *before* calling ModifyTheme
    function window:UpdateElementThemes()
        -- Add nil checks for elements that might not exist yet during initial call
        if mainFrame then ApplyThemeStyle(mainFrame, "Window") end
        if shadow then shadow.ImageColor3 = (Cosmic.SelectedTheme or {}).Shadow or Color3.fromRGB(0,0,0) end
        if dragBarCosmetic then dragBarCosmetic.BackgroundColor3 = (Cosmic.SelectedTheme or {}).Accent or Color3.fromRGB(0, 220, 255) end
        if topBar then
            ApplyThemeStyle(topBar, "TitleBar")
            if titleIcon then titleIcon.ImageColor3 = (Cosmic.SelectedTheme or {}).TextColor end
            if titleLabel then titleLabel.TextColor3 = (Cosmic.SelectedTheme or {}).TextColor end
            if hideButton then hideButton.ImageColor3 = (Cosmic.SelectedTheme or {}).TextSecondary or (Cosmic.SelectedTheme or {}).TextColor end
            if sizeButton then sizeButton.ImageColor3 = (Cosmic.SelectedTheme or {}).TextSecondary or (Cosmic.SelectedTheme or {}).TextColor end
            if searchButton then searchButton.ImageColor3 = (Cosmic.SelectedTheme or {}).TextSecondary or (Cosmic.SelectedTheme or {}).TextColor end
            if settingsButton then settingsButton.ImageColor3 = (Cosmic.SelectedTheme or {}).TextSecondary or (Cosmic.SelectedTheme or {}).TextColor end
        end
        if searchFrame then ApplyThemeStyle(searchFrame, "TextBox") end
        if searchIcon then searchIcon.ImageColor3 = (Cosmic.SelectedTheme or {}).PlaceholderColor end
        if searchInput then ApplyThemeStyle(searchInput, "TextBox") end
        if mobilePrompt then ApplyThemeStyle(mobilePrompt, "Button") end

        -- Update tabs (These loops will be empty on initial call, safe)
        for _, tab in ipairs(window.Tabs) do
            if tab.IsActive then
                ApplyThemeStyle(tab.Button, "TabButtonActive")
                tab.Label.TextColor3 = (Cosmic.SelectedTheme or {}).SelectedTabTextColor
                tab.Icon.ImageColor3 = (Cosmic.SelectedTheme or {}).SelectedTabTextColor
            else
                ApplyThemeStyle(tab.Button, "TabButton")
                tab.Label.TextColor3 = (Cosmic.SelectedTheme or {}).TabTextColor
                tab.Icon.ImageColor3 = (Cosmic.SelectedTheme or {}).TabTextColor
            end
            -- Update elements within tab
            for _, element in ipairs(tab.Elements) do
                if element.UpdateTheme then element:UpdateTheme() end
            end
        end
         -- Update settings elements if any
        for _, element in ipairs(window.Elements) do
             if element.UpdateTheme then element:UpdateTheme() end
        end
    end

    -- Apply Initial Theme (Moved down, but keep UpdateElementThemes definition above)
    -- window:ModifyTheme(config.Theme, true) -- Apply silently -- MOVED

    -- Core GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.Name:gsub("[^%w]+", "") .. "UI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 10000
    screenGui.Enabled = false
    screenGui.IgnoreGuiInset = true -- Match Rayfield behavior
    screenGui.Parent = gethui() -- Use gethui or fallback

    -- Shadow (like Rayfield)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.fromScale(0.5, 0.5)
    shadow.Size = UDim2.new(1, 20, 1, 20) -- Slightly larger for shadow effect
    shadow.Image = "rbxassetid://10137941941" -- 9-slice shadow image (replace if needed)
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118) -- Adjust slice center for shadow image
    shadow.ImageColor3 = Cosmic.SelectedTheme.Shadow or Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.6
    shadow.ZIndex = 0
    shadow.Parent = screenGui -- Parent to ScreenGui, behind MainFrame

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = config.Size
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.ZIndex = 1
    mainFrame.Parent = screenGui

    -- Taptic Drag Bar (Visual only)
    local dragBar = Instance.new("Frame")
    dragBar.Name = "DragBar"
    dragBar.Size = UDim2.new(0, 100, 0, 4)
    dragBar.AnchorPoint = Vector2.new(0.5, 0)
    dragBar.BackgroundTransparency = 1 -- Fully transparent container
    dragBar.ZIndex = 2
    dragBar.Parent = screenGui

    local dragBarCosmetic = Instance.new("Frame")
    dragBarCosmetic.Name = "Drag"
    dragBarCosmetic.Size = UDim2.fromScale(1, 1)
    dragBarCosmetic.AnchorPoint = Vector2.new(0.5, 0.5)
    dragBarCosmetic.Position = UDim2.fromScale(0.5, 0.5)
    dragBarCosmetic.BackgroundColor3 = Cosmic.SelectedTheme.Accent or Color3.fromRGB(0, 220, 255)
    dragBarCosmetic.BackgroundTransparency = 0.7
    local dragCorner = Instance.new("UICorner")
    dragCorner.CornerRadius = UDim.new(1, 0)
    dragCorner.Parent = dragBarCosmetic
    dragBarCosmetic.Parent = dragBar

    -- Top Bar
    local topBar, titleIcon, titleLabel, hideButton, sizeButton, searchButton, settingsButton -- Declare variables used in UpdateElementThemes
    if config.ShowTopbar then
        topBar = Instance.new("Frame")
        topBar.Name = "TitleBar"
        topBar.Size = UDim2.new(1, 0, 0, config.TopbarHeight)
        topBar.Position = UDim2.new(0, 0, 0, 0)
        topBar.Parent = mainFrame

        -- Icon
        if config.Icon then
            titleIcon = CreateIcon(config.Icon, topBar,
                UDim2.fromOffset(config.TopbarHeight * 0.6, config.TopbarHeight * 0.6),
                UDim2.new(0, Cosmic.SelectedTheme.Padding or 10, 0.5, 0),
                Cosmic.SelectedTheme.TextColor)
            titleIcon.AnchorPoint = Vector2.new(0, 0.5)
        end

        -- Title Label
        titleLabel = Instance.new("TextLabel")
        local titleX = (titleIcon and titleIcon.AbsoluteSize.X + (Cosmic.SelectedTheme.Padding or 10) * 1.5) or (Cosmic.SelectedTheme.Padding or 10)
        local controlsWidth = (config.TopbarHeight * 3) + (Cosmic.SelectedTheme.Padding or 10) -- Approx width for 3 buttons
        titleLabel.Size = UDim2.new(1, -(titleX + controlsWidth), 1, 0)
        titleLabel.Position = UDim2.new(0, titleX, 0, 0)
        titleLabel.Font = Cosmic.SelectedTheme.FontTitle or Enum.Font.SourceSansBold
        titleLabel.TextSize = Cosmic.SelectedTheme.TextSizeTitle or 18
        titleLabel.TextColor3 = Cosmic.SelectedTheme.TextColor
        titleLabel.Text = config.Title
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.BackgroundTransparency = 1
        titleLabel.Parent = topBar

        -- Topbar Controls (Hide, Minimize/Maximize, Search, Settings)
        local controlButtonSize = config.TopbarHeight - (Cosmic.SelectedTheme.SmallPadding or 5) * 2
        local controlX = -(controlButtonSize + (Cosmic.SelectedTheme.SmallPadding or 5))
        local controlY = UDim.new(0.5, -controlButtonSize / 2)

        -- Hide Button (Rayfield's Minimize equivalent)
        hideButton = Instance.new("ImageButton")
        hideButton.Name = "HideButton"
        hideButton.Size = UDim2.fromOffset(controlButtonSize, controlButtonSize)
        hideButton.Position = UDim2.new(1, controlX, controlY.Scale, controlY.Offset)
        hideButton.BackgroundTransparency = 1
        hideButton.Image = Cosmic.SelectedTheme.Icons.Minimize or "rbxassetid://5108077471"
        hideButton.ImageColor3 = Cosmic.SelectedTheme.TextSecondary or theme.TextColor
        hideButton.ScaleType = Enum.ScaleType.Fit
        hideButton.Parent = topBar
        controlX = controlX - (controlButtonSize + (Cosmic.SelectedTheme.SmallPadding or 5))

        -- Minimize/Maximize Button
        sizeButton = Instance.new("ImageButton")
        sizeButton.Name = "SizeButton"
        sizeButton.Size = UDim2.fromOffset(controlButtonSize, controlButtonSize)
        sizeButton.Position = UDim2.new(1, controlX, controlY.Scale, controlY.Offset)
        sizeButton.BackgroundTransparency = 1
        sizeButton.Image = Cosmic.SelectedTheme.Icons.Restore or "rbxassetid://10137941941" -- Start assuming maximized
        sizeButton.ImageColor3 = Cosmic.SelectedTheme.TextSecondary or theme.TextColor
        sizeButton.ScaleType = Enum.ScaleType.Fit
        sizeButton.Parent = topBar
        controlX = controlX - (controlButtonSize + (Cosmic.SelectedTheme.SmallPadding or 5))

        -- Search Button
        searchButton = Instance.new("ImageButton")
        searchButton.Name = "SearchButton"
        searchButton.Size = UDim2.fromOffset(controlButtonSize, controlButtonSize)
        searchButton.Position = UDim2.new(1, controlX, controlY.Scale, controlY.Offset)
        searchButton.BackgroundTransparency = 1
        searchButton.Image = Cosmic.SelectedTheme.Icons.Search or "rbxassetid://6031069821"
        searchButton.ImageColor3 = Cosmic.SelectedTheme.TextSecondary or theme.TextColor
        searchButton.ScaleType = Enum.ScaleType.Fit
        searchButton.Parent = topBar
        controlX = controlX - (controlButtonSize + (Cosmic.SelectedTheme.SmallPadding or 5))

        -- Settings Button (Optional - Add logic to show/hide based on file system availability)
        settingsButton = Instance.new("ImageButton")
        settingsButton.Name = "SettingsButton"
        settingsButton.Size = UDim2.fromOffset(controlButtonSize, controlButtonSize)
        settingsButton.Position = UDim2.new(1, controlX, controlY.Scale, controlY.Offset)
        settingsButton.BackgroundTransparency = 1
        settingsButton.Image = Cosmic.SelectedTheme.Icons.Settings or "rbxassetid://6031069821"
        settingsButton.ImageColor3 = Cosmic.SelectedTheme.TextSecondary or theme.TextColor
        settingsButton.ScaleType = Enum.ScaleType.Fit
        settingsButton.Parent = topBar

        -- Button Hover Effects (like Rayfield)
        local function setupControlHover(button)
            table.insert(window.Connections, button.MouseEnter:Connect(function() PlayTween(button, { ImageColor3 = Cosmic.SelectedTheme.TextColor }, 0.1) end))
            table.insert(window.Connections, button.MouseLeave:Connect(function() PlayTween(button, { ImageColor3 = Cosmic.SelectedTheme.TextSecondary or Cosmic.SelectedTheme.TextColor }, 0.1) end))
        end
        setupControlHover(hideButton)
        setupControlHover(sizeButton)
        setupControlHover(searchButton)
        setupControlHover(settingsButton)

        -- Button Actions
        table.insert(window.Connections, hideButton.MouseButton1Click:Connect(function() window:Hide(true) end)) -- Pass true for notification
        table.insert(window.Connections, sizeButton.MouseButton1Click:Connect(function() if window.IsMinimized then window:Maximize() else window:Minimize() end end))
        table.insert(window.Connections, searchButton.MouseButton1Click:Connect(function() window:ToggleSearch() end))
        table.insert(window.Connections, settingsButton.MouseButton1Click:Connect(function() window:ShowSettingsTab() end))

        -- Dragging Logic
        if config.Draggable then
            local dragConnections = makeDraggable(mainFrame, topBar, true, dragBar, {config.Size.Y.Offset / 2 + 10}) -- Offset drag bar below
            for _, conn in ipairs(dragConnections) do table.insert(window.Connections, conn) end
        end
    end

    -- Search Bar Frame (Initially Hidden)
    local searchFrame = Instance.new("Frame")
    searchFrame.Name = "SearchFrame"
    searchFrame.Size = UDim2.new(1, -(Cosmic.SelectedTheme.Padding or 10)*2, 0, 35)
    searchFrame.Position = UDim2.new(0, Cosmic.SelectedTheme.Padding or 10, 0, (config.ShowTopbar and config.TopbarHeight or 0) + 5)
    searchFrame.BackgroundTransparency = 1
    searchFrame.Visible = false
    searchFrame.ClipsDescendants = true
    searchFrame.ZIndex = 3
    searchFrame.Parent = mainFrame

    local searchIcon = CreateIcon(Cosmic.SelectedTheme.Icons.Search or "rbxassetid://6031069821", searchFrame,
        UDim2.fromOffset(20, 20),
        UDim2.new(0, 5, 0.5, 0),
        Cosmic.SelectedTheme.PlaceholderColor)
    searchIcon.AnchorPoint = Vector2.new(0, 0.5)

    local searchInput = Instance.new("TextBox")
    searchInput.Name = "SearchInput"
    searchInput.Size = UDim2.new(1, -30, 1, 0)
    searchInput.Position = UDim2.new(0, 28, 0, 0)
    searchInput.PlaceholderText = "Search elements..."
    searchInput.ClearTextOnFocus = false
    searchInput.Text = ""
    searchInput.BackgroundTransparency = 1 -- Make textbox itself transparent
    searchInput.BorderSizePixel = 0
    if searchInput:FindFirstChild("BaseStroke") then searchInput.BaseStroke:Destroy() end -- Remove inner stroke
    if searchInput:FindFirstChildWhichIsA("UICorner") then searchInput:FindFirstChildWhichIsA("UICorner"):Destroy() end -- Remove inner corner
    searchInput.Parent = searchFrame

    -- Tab Bar Area
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 40) -- Standard tab bar height
    tabBar.Position = UDim2.new(0, 0, 0, (config.ShowTopbar and config.TopbarHeight or 0)) -- Position below topbar or search
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = mainFrame

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.VerticalAlignment = Enum.VerticalAlignment.Center
    tabList.Padding = UDim.new(0, Cosmic.SelectedTheme.SmallPadding or 5)
    tabList.Parent = tabBar

    -- Content Area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    local contentY = tabBar.Position.Y.Offset + tabBar.Size.Y.Offset + (Cosmic.SelectedTheme.Padding or 10)
    contentFrame.Size = UDim2.new(1, -(Cosmic.SelectedTheme.Padding or 10) * 2, 1, -(contentY + (Cosmic.SelectedTheme.Padding or 10)))
    contentFrame.Position = UDim2.new(0, Cosmic.SelectedTheme.Padding or 10, 0, contentY)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = mainFrame

    local pageLayout = Instance.new("UIPageLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.TweenTime = (Cosmic.SelectedTheme.AnimationSpeed or 0.2) * 1.5
    pageLayout.EasingStyle = Cosmic.SelectedTheme.EasingStyle or Enum.EasingStyle.Quad
    pageLayout.EasingDirection = Cosmic.SelectedTheme.EasingDirection or Enum.EasingDirection.Out
    pageLayout.Parent = contentFrame

    -- Notifications Area (like Rayfield)
    local notificationsFrame = Instance.new("Frame")
    notificationsFrame.Name = "Notifications"
    notificationsFrame.Size = UDim2.new(0, 300, 1, 0) -- Fixed width, full height
    notificationsFrame.Position = UDim2.new(1, 10, 0, 0) -- Position outside right
    notificationsFrame.BackgroundTransparency = 1
    notificationsFrame.ZIndex = 10
    notificationsFrame.Parent = screenGui

    local notificationLayout = Instance.new("UIListLayout")
    notificationLayout.FillDirection = Enum.FillDirection.Vertical
    notificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    notificationLayout.Padding = UDim.new(0, 8)
    notificationLayout.Parent = notificationsFrame

    -- Mobile Prompt (like Rayfield)
    local mobilePrompt = Instance.new("TextButton")
    mobilePrompt.Name = "MobilePrompt"
    mobilePrompt.Size = UDim2.new(0, 120, 0, 30)
    mobilePrompt.AnchorPoint = Vector2.new(0.5, 0)
    mobilePrompt.Position = UDim2.new(0.5, 0, 0, -50) -- Start hidden above screen
    mobilePrompt.Text = "Show " .. config.Name
    mobilePrompt.Visible = false -- Initially hidden
    mobilePrompt.ZIndex = 100
    mobilePrompt.AutoButtonColor = false
    mobilePrompt.Parent = screenGui

    table.insert(window.Connections, mobilePrompt.MouseButton1Click:Connect(function() window:Show() end))

    -- Assign References
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.Shadow = shadow
    window.TitleBar = topBar
    window.TabBar = tabBar
    window.ContentFrame = contentFrame
    window.PageLayout = pageLayout
    window.NotificationsFrame = notificationsFrame
    window.NotificationLayout = notificationLayout
    window.DragBar = dragBar -- Reference to the taptic bar container
    window.MobilePrompt = mobilePrompt
    window.SearchFrame = searchFrame
    window.SearchInput = searchInput
    window.SizeButton = sizeButton -- Reference to minimize/maximize button

    -- Apply Initial Theme (Moved here, after all base elements are created)
    window:ModifyTheme(config.Theme, true) -- Apply silently

    -- Initial Load/Setup
    Cosmic.ActiveWindows[window] = true
    print("Cosmic UI: Window '" .. config.Title .. "' created.")

    -- Configuration Loading Notice (like Rayfield)
    if window.CEnabled then
        local notice = Instance.new("Frame")
        notice.Name = "ConfigNotice"
        notice.Size = UDim2.new(0, 280, 0, 35)
        notice.AnchorPoint = Vector2.new(0.5, 1)
        notice.Position = UDim2.new(0.5, 0, 0, -10) -- Position above topbar
        notice.BackgroundTransparency = 0.5
        notice.ZIndex = 10
        ApplyThemeStyle(notice, "Label") -- Use label style
        notice.Parent = mainFrame

        local noticeLabel = Instance.new("TextLabel")
        noticeLabel.Name = "Title"
        noticeLabel.Size = UDim2.fromScale(1, 1)
        noticeLabel.BackgroundTransparency = 1
        noticeLabel.Text = "Loading Configuration..."
        noticeLabel.Font = Cosmic.SelectedTheme.Font or Enum.Font.SourceSans
        noticeLabel.TextSize = Cosmic.SelectedTheme.TextSizeSmall or 13
        noticeLabel.TextColor3 = Cosmic.SelectedTheme.TextColor
        noticeLabel.TextTransparency = 0.1
        noticeLabel.Parent = notice
        window.ConfigNotice = notice -- Store reference

        -- Fade in notice
        PlayTween(notice, {BackgroundTransparency = 0.5, Position = UDim2.new(0.5, 0, 0, -10)}, 0.5)
        PlayTween(noticeLabel, {TextTransparency = 0.1}, 0.5)
    end

    -- Key System Check (Placeholder - Needs full UI and logic)
    if config.KeySystem then
        local keyValid = window:_CheckKeySystem()
        if not keyValid then
            -- Show Key UI, handle input, validation etc.
            warn("CosmicUI: Key System validation failed or not implemented. UI loading aborted.")
            window:Destroy() -- Abort if key fails
            return nil -- Indicate failure
        end
    end

    -- Discord Invite (like Rayfield)
    if config.Discord.Enabled and config.Discord.Invite and not useStudio then
        window:_HandleDiscordInvite()
    end

    -- Auto-show or start hidden
    if config.StartVisible then
        window:Show(true) -- Show immediately without animation
    else
        -- Ensure correct initial hidden state without animation
        mainFrame.Visible = false
        screenGui.Enabled = false
        dragBar.Visible = false
        window.Visible = false
    end

    -- Load Configuration after a delay (like Rayfield)
    task.delay(4, function()
        if window and window.CEnabled then
            window:LoadConfiguration()
        end
        Cosmic.GlobalLoaded = true
        -- Fade out notice
        if window and window.ConfigNotice then
            PlayTween(window.ConfigNotice, {BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0, -50)}, 0.5)
            PlayTween(window.ConfigNotice.Title, {TextTransparency = 1}, 0.3)
            task.delay(0.5, function() if window.ConfigNotice then window.ConfigNotice:Destroy() window.ConfigNotice = nil end end)
        end
    end)

    -- Setup Hide Hotkey
    local hideHotkey = settingsTable and settingsTable.General.rayfieldOpen.Value or "K" -- Use Rayfield's setting name
    table.insert(window.Connections, UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode[hideHotkey] then
            window:ToggleVisibility()
        end
    end))

    return window
end

--[[ Initialization ]]--
function Cosmic.Init(customThemes)
    -- Merge custom themes
    if customThemes and type(customThemes) == "table" then
        for name, themeData in pairs(customThemes) do
            if type(themeData) == "table" then
                Cosmic.Themes[name] = themeData
                print("Cosmic UI: Added/Updated custom theme:", name)
            end
        end
    end

    print("Cosmic UI Initialized. Version:", Cosmic.BuildVersion)
    return Cosmic -- Return the library table itself
end

-- Return the initialized library
return Cosmic.Init()
