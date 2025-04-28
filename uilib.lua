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
    return TweenInfo.new(
        speedOverride or Cosmic.SelectedTheme.AnimationSpeed or 0.2,
        styleOverride or Cosmic.SelectedTheme.EasingStyle or Enum.EasingStyle.Quad,
        directionOverride or Cosmic.SelectedTheme.EasingDirection or Enum.EasingDirection.Out
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
    local theme = Cosmic.SelectedTheme

    -- Basic Defaults
    if guiObject:IsA("GuiObject") then
        guiObject.BackgroundColor3 = theme.ElementBackground or Color3.fromRGB(35, 35, 35)
        guiObject.BorderSizePixel = 0
        if guiObject:IsA("Frame") or guiObject:IsA("ScrollingFrame") or guiObject:IsA("TextBox") or guiObject:IsA("TextButton") then
             guiObject.BackgroundTransparency = 0
        else
             guiObject.BackgroundTransparency = 1 -- Default others to transparent
        end
    end
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
        -- Update window elements
        ApplyThemeStyle(mainFrame, "Window")
        shadow.ImageColor3 = Cosmic.SelectedTheme.Shadow or Color3.fromRGB(0,0,0)
        dragBarCosmetic.BackgroundColor3 = Cosmic.SelectedTheme.Accent or Color3.fromRGB(0, 220, 255)
        if topBar then
            ApplyThemeStyle(topBar, "TitleBar")
            if titleIcon then titleIcon.ImageColor3 = Cosmic.SelectedTheme.TextColor end
            if titleLabel then titleLabel.TextColor3 = Cosmic.SelectedTheme.TextColor end -- Added check for titleLabel
            if hideButton then hideButton.ImageColor3 = Cosmic.SelectedTheme.TextSecondary or Cosmic.SelectedTheme.TextColor end -- Added check
            if sizeButton then sizeButton.ImageColor3 = Cosmic.SelectedTheme.TextSecondary or Cosmic.SelectedTheme.TextColor end -- Added check
            if searchButton then searchButton.ImageColor3 = Cosmic.SelectedTheme.TextSecondary or Cosmic.SelectedTheme.TextColor end -- Added check
            if settingsButton then settingsButton.ImageColor3 = Cosmic.SelectedTheme.TextSecondary or Cosmic.SelectedTheme.TextColor end -- Added check
        end
        ApplyThemeStyle(searchFrame, "TextBox")
        if searchIcon then searchIcon.ImageColor3 = Cosmic.SelectedTheme.PlaceholderColor end -- Added check
        ApplyThemeStyle(searchInput, "TextBox")
        ApplyThemeStyle(mobilePrompt, "Button")

        -- Update tabs
        for _, tab in ipairs(window.Tabs) do
            if tab.IsActive then
                ApplyThemeStyle(tab.Button, "TabButtonActive")
                tab.Label.TextColor3 = Cosmic.SelectedTheme.SelectedTabTextColor
                tab.Icon.ImageColor3 = Cosmic.SelectedTheme.SelectedTabTextColor
            else
                ApplyThemeStyle(tab.Button, "TabButton")
                tab.Label.TextColor3 = Cosmic.SelectedTheme.TabTextColor
                tab.Icon.ImageColor3 = Cosmic.SelectedTheme.TabTextColor
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

    -- Apply Initial Theme (Now UpdateElementThemes is defined)
    window:ModifyTheme(config.Theme, true) -- Apply silently

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
    ApplyThemeStyle(mainFrame, "Window")
    mainFrame.Parent = screenGui

    -- Taptic Drag Bar (Visual only)
    local dragBar = Instance.new("Frame")
    dragBar.Name = "DragBar"
    dragBar.Size = UDim2.new(0, 100, 0, 4)
    dragBar.AnchorPoint = Vector2.new(0.5, 0)
    -- Position set dynamically by makeDraggable
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
        ApplyThemeStyle(topBar, "TitleBar")
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
        -- settingsButton.Visible = (writefile and isfile) -- Conditionally show

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
    ApplyThemeStyle(searchFrame, "TextBox") -- Use TextBox style as base
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
    ApplyThemeStyle(searchInput, "TextBox") -- Apply text styles etc.
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
    ApplyThemeStyle(mobilePrompt, "Button") -- Use button style
    mobilePrompt.BackgroundTransparency = 0.3
    mobilePrompt.TextTransparency = 0.3
    mobilePrompt.TextSize = Cosmic.SelectedTheme.TextSizeSmall or 13
    mobilePrompt.TextColor3 = Cosmic.SelectedTheme.TextColor
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

    -- Add Theme Update Connection (This is now handled by UpdateElementThemes)
    -- function window:UpdateElementThemes() ... moved above ... end

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

--[[ Window Methods ]]--

function Cosmic:Show(immediate)
    if self.Visible then return end
    self.Visible = true
    self.ScreenGui.Enabled = true
    self.MainFrame.Visible = true
    self.DragBar.Visible = self.Config.Draggable -- Show drag bar only if draggable

    local targetPos = self.Config.Position or UDim2.new(0.5, 0, 0.5, 0)
    local startPos = targetPos + UDim2.fromOffset(0, 30) -- Start lower

    -- Hide mobile prompt if showing
    if self.MobilePrompt.Visible then
        PlayTween(self.MobilePrompt, {Position = UDim2.new(0.5, 0, 0, -50), BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
        task.delay(0.3, function() if self.MobilePrompt then self.MobilePrompt.Visible = false end end)
    end

    if immediate or self.IsMinimized then -- If minimized, just resize, don't animate position/transparency
        self.MainFrame.Position = targetPos
        self.MainFrame.Transparency = 0
        self.Shadow.ImageTransparency = 0.6
        if self.IsMinimized then
             self:Maximize(true) -- Maximize immediately
        end
    else
        self.MainFrame.Position = startPos
        self.MainFrame.Transparency = 1
        self.Shadow.ImageTransparency = 1
        PlayTween(self.MainFrame, { Position = targetPos, Transparency = 0 }, nil, Enum.EasingStyle.Back)
        PlayTween(self.Shadow, { ImageTransparency = 0.6 }, 0.4) -- Fade in shadow
    end
    self.OriginalPosition = targetPos -- Store intended position
end

function Cosmic:Hide(notify)
    if not self.Visible then return end
    self.Visible = false

    local currentPos = self.MainFrame.Position
    local targetPos = currentPos + UDim2.fromOffset(0, 30)

    -- Show mobile prompt if touch enabled
    local useMobilePrompt = UserInputService.TouchEnabled
    if useMobilePrompt then
        self.MobilePrompt.Visible = true
        PlayTween(self.MobilePrompt, {Position = UDim2.new(0.5, 0, 0, 20), BackgroundTransparency = 0.3, TextTransparency = 0.3}, 0.5)
    end

    if notify and not useMobilePrompt then
        local hideHotkey = settingsTable and settingsTable.General.rayfieldOpen.Value or "K"
        self:Notify({Title = "Interface Hidden", Content = `Press ${hideHotkey} to show.`, Duration = 5, Icon = Cosmic.SelectedTheme.Icons.Minimize})
    elseif notify and useMobilePrompt then
         self:Notify({Title = "Interface Hidden", Content = "Tap 'Show " .. self.Config.Name .. "' to show.", Duration = 5, Icon = Cosmic.SelectedTheme.Icons.Minimize})
    end

    local function OnHideComplete()
        if not self.Visible then
            self.MainFrame.Visible = false
            self.ScreenGui.Enabled = false
            self.DragBar.Visible = false
            -- Don't reset position, keep it where it was for potential minimize state
        end
    end

    PlayTween(self.MainFrame, { Position = targetPos, Transparency = 1 }, 0.3)
    local shadowTween = PlayTween(self.Shadow, { ImageTransparency = 1 }, 0.3)
    table.insert(self.Connections, shadowTween.Completed:Connect(OnHideComplete))
end

function Cosmic:ToggleVisibility()
    if self.Visible then self:Hide(true) else self:Show() end
end

function Cosmic:Minimize()
    if self.IsMinimized or not self.Visible then return end
    self.IsMinimized = true
    self.OriginalSize = self.MainFrame.Size -- Store current size before minimizing
    self.OriginalPosition = self.MainFrame.Position -- Store current position

    local minimizedHeight = self.Config.TopbarHeight or 35
    local targetSize = UDim2.new(self.OriginalSize.X.Scale, self.OriginalSize.X.Offset, 0, minimizedHeight)

    -- Update button icon
    if self.SizeButton then PlayTween(self.SizeButton, {Image = Cosmic.SelectedTheme.Icons.Maximize or "rbxassetid://11036884234"}, 0.1) end

    -- Hide content, tabs
    self.ContentFrame.Visible = false
    self.TabBar.Visible = false
    if self.SearchOpen then self:ToggleSearch(true) end -- Force close search immediately

    -- Animate size
    PlayTween(self.MainFrame, { Size = targetSize }, 0.3)
    PlayTween(self.Shadow, { Size = UDim2.new(targetSize.X.Scale, targetSize.X.Offset + 20, targetSize.Y.Scale, targetSize.Y.Offset + 20) }, 0.3)
    if self.TitleBar then PlayTween(self.TitleBar, { Size = UDim2.new(1, 0, 0, minimizedHeight) }, 0.3) end

    -- Adjust drag bar position
    if self.Config.Draggable then
        local tapticYOffset = minimizedHeight / 2 + 10
        PlayTween(self.DragBar, { Position = UDim2.fromOffset(self.MainFrame.Position.X.Offset, self.MainFrame.Position.Y.Offset + tapticYOffset) }, 0.3)
        -- Update drag offset for future drags while minimized
        local dragConnections = makeDraggable(self.MainFrame, self.TitleBar, true, self.DragBar, {tapticYOffset})
        -- Clear old drag connections and add new ones (simplified - ideally manage connections better)
        -- for _, conn in ipairs(self.Connections) do if conn related to dragging then conn:Disconnect() end end
        for _, conn in ipairs(dragConnections) do table.insert(self.Connections, conn) end
    end
end

function Cosmic:Maximize(immediate)
    if not self.IsMinimized or not self.Visible then return end
    self.IsMinimized = false

    local targetSize = self.OriginalSize
    local speed = immediate and 0.01 or 0.3 -- Very fast if immediate

    -- Update button icon
    if self.SizeButton then PlayTween(self.SizeButton, {Image = Cosmic.SelectedTheme.Icons.Restore or "rbxassetid://10137941941"}, 0.1) end

    -- Animate size back
    PlayTween(self.MainFrame, { Size = targetSize }, speed)
    PlayTween(self.Shadow, { Size = UDim2.new(targetSize.X.Scale, targetSize.X.Offset + 20, targetSize.Y.Scale, targetSize.Y.Offset + 20) }, speed)
    if self.TitleBar then PlayTween(self.TitleBar, { Size = UDim2.new(1, 0, 0, self.Config.TopbarHeight or 35) }, speed) end

    -- Show content, tabs after slight delay or immediately
    local function showContent()
        self.ContentFrame.Visible = true
        self.TabBar.Visible = true
    end
    if immediate then showContent() else task.delay(speed * 0.5, showContent) end

    -- Adjust drag bar position
    if self.Config.Draggable then
        local tapticYOffset = targetSize.Y.Offset / 2 + 10
        PlayTween(self.DragBar, { Position = UDim2.fromOffset(self.MainFrame.Position.X.Offset, self.MainFrame.Position.Y.Offset + tapticYOffset) }, speed)
        -- Update drag offset
        local dragConnections = makeDraggable(self.MainFrame, self.TitleBar, true, self.DragBar, {tapticYOffset})
        -- Clear old drag connections and add new ones
        for _, conn in ipairs(dragConnections) do table.insert(self.Connections, conn) end
    end
end

function Cosmic:Destroy()
    self:Hide(true) -- Hide immediately
    Cosmic.ActiveWindows[self] = nil
    -- Disconnect all stored connections
    for _, conn in ipairs(self.Connections) do if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end end
    for _, conn in ipairs(self.ThemeConnections) do if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end end
    self.Connections = {}
    self.ThemeConnections = {}
    -- Destroy flagged elements registry entry
    for flagName, element in pairs(Cosmic.Flags) do
        if element and element.Window == self then
            Cosmic.Flags[flagName] = nil
        end
    end
    if self.ScreenGui then self.ScreenGui:Destroy() end
    -- Clear self table
    for k in pairs(self) do self[k] = nil end
    print("Cosmic UI: Window destroyed.")
end

function Cosmic:ModifyTheme(themeInput, silent)
    local newTheme
    if type(themeInput) == "string" and Cosmic.Themes[themeInput] then
        newTheme = Cosmic.Themes[themeInput]
    elseif type(themeInput) == "table" then
        newTheme = themeInput -- Allow custom theme tables
    else
        if not silent then warn("CosmicUI: Invalid theme specified:", themeInput) end
        return
    end

    Cosmic.SelectedTheme = newTheme -- Update the global selected theme for new elements

    -- Update existing elements (This call is now safe)
    self:UpdateElementThemes()

    if not silent then
        self:Notify({Title = "Theme Changed", Content = "Theme set to " .. (newTheme.Name or "Custom"), Duration = 3, Icon = Cosmic.SelectedTheme.Icons.Settings})
    end
end

function Cosmic:Notify(data)
    -- Adapted Rayfield Notify Logic
    local theme = Cosmic.SelectedTheme
    local notification = Instance.new("Frame")
    notification.Name = data.Title or "Notification"
    notification.Size = UDim2.new(1, 0, 0, 0) -- Start height 0
    notification.BackgroundColor3 = theme.NotificationBackground or theme.Background
    notification.BackgroundTransparency = 1
    notification.ClipsDescendants = true
    notification.LayoutOrder = #self.NotificationsFrame:GetChildren() + 1
    ApplyThemeStyle(notification, "Label") -- Base style
    notification.Parent = self.NotificationsFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 45) -- Space for icon
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = notification

    local icon = CreateIcon(data.Icon or theme.Icons.NotificationDefault, notification,
        UDim2.fromOffset(24, 24),
        UDim2.new(0, 10, 0.5, 0), -- Position left-center
        theme.TextColor)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.ImageTransparency = 1
    icon.ZIndex = 2

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, theme.TextSizeTitle or 18)
    titleLabel.Text = data.Title or "Notification"
    titleLabel.Font = theme.FontBold or theme.Font
    titleLabel.TextSize = theme.TextSizeTitle or 18
    titleLabel.TextColor3 = theme.TextColor
    titleLabel.TextTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    titleLabel.BackgroundTransparency = 1
    titleLabel.ZIndex = 1
    titleLabel.Parent = notification

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.Size = UDim2.new(1, 0, 1, -(theme.TextSizeTitle or 18)) -- Fill remaining space
    contentLabel.Position = UDim2.new(0, 0, 0, theme.TextSizeTitle or 18)
    contentLabel.Text = data.Content or ""
    contentLabel.Font = theme.Font
    contentLabel.TextSize = theme.TextSize or 14
    contentLabel.TextColor3 = theme.TextSecondary or theme.TextColor
    contentLabel.TextTransparency = 1
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.BackgroundTransparency = 1
    contentLabel.ZIndex = 1
    contentLabel.Parent = notification

    -- Calculate required height
    local titleHeight = titleLabel.TextBounds.Y
    local contentHeight = contentLabel.TextBounds.Y
    local requiredHeight = titleHeight + contentHeight + padding.PaddingTop.Offset + padding.PaddingBottom.Offset + 5 -- Extra padding
    requiredHeight = math.max(requiredHeight, 50) -- Minimum height

    -- Show Animation
    PlayTween(notification, {Size = UDim2.new(1, 0, 0, requiredHeight), BackgroundTransparency = 0.1}, 0.4)
    PlayTween(icon, {ImageTransparency = 0}, 0.5, nil, Enum.EasingDirection.In)
    PlayTween(titleLabel, {TextTransparency = 0}, 0.5)
    PlayTween(contentLabel, {TextTransparency = 0.2}, 0.6)

    -- Auto-hide
    local waitDuration = data.Duration or math.clamp((#(data.Content or "") * 0.08) + 2.0, 3, 8) -- Adjusted calculation
    task.delay(waitDuration, function()
        if notification and notification.Parent then
            PlayTween(notification, {BackgroundTransparency = 1}, 0.3)
            PlayTween(icon, {ImageTransparency = 1}, 0.3)
            PlayTween(titleLabel, {TextTransparency = 1}, 0.3)
            PlayTween(contentLabel, {TextTransparency = 1}, 0.3)
            local sizeTween = PlayTween(notification, {Size = UDim2.new(1, 0, 0, 0)}, 0.4, nil, Enum.EasingDirection.In)
            sizeTween.Completed:Connect(function()
                if notification and notification.Parent then notification:Destroy() end
            end)
        end
    end)
end

function Cosmic:ToggleSearch(forceClose)
    local targetVisible = not self.SearchOpen
    if forceClose then targetVisible = false end

    if targetVisible then -- Open Search
        self.SearchOpen = true
        self.SearchFrame.Visible = true
        self.SearchFrame.BackgroundTransparency = 1
        self.SearchFrame.Position = UDim2.new(0, Cosmic.SelectedTheme.Padding or 10, 0, (self.Config.ShowTopbar and self.Config.TopbarHeight or 0) - 10) -- Start above final pos
        self.SearchInput.TextTransparency = 1
        self.SearchInput.PlaceholderColor3 = Color3.clear(1) -- Hide placeholder during anim

        PlayTween(self.SearchFrame, {
            BackgroundTransparency = 0,
            Position = UDim2.new(0, Cosmic.SelectedTheme.Padding or 10, 0, (self.Config.ShowTopbar and self.Config.TopbarHeight or 0) + 5)
        }, 0.3)
        PlayTween(self.SearchInput, {TextTransparency = 0}, 0.4)
        task.delay(0.1, function() if self.SearchInput then self.SearchInput.PlaceholderColor3 = Cosmic.SelectedTheme.PlaceholderColor end end) -- Restore placeholder

        -- Adjust TabBar position
        PlayTween(self.TabBar, {Position = UDim2.new(0, 0, 0, self.SearchFrame.Position.Y.Offset + self.SearchFrame.Size.Y.Offset + 5)}, 0.3)
        -- Adjust ContentFrame position and size
        local contentY = self.SearchFrame.Position.Y.Offset + self.SearchFrame.Size.Y.Offset + 5 + self.TabBar.Size.Y.Offset + (Cosmic.SelectedTheme.Padding or 10)
        PlayTween(self.ContentFrame, {
            Position = UDim2.new(0, Cosmic.SelectedTheme.Padding or 10, 0, contentY),
            Size = UDim2.new(1, -(Cosmic.SelectedTheme.Padding or 10) * 2, 1, -(contentY + (Cosmic.SelectedTheme.Padding or 10)))
        }, 0.3)

        self.SearchInput:CaptureFocus()
        self:_FilterTabContent() -- Initial filter (shows all)

    else -- Close Search
        self.SearchOpen = false
        self.SearchInput:ReleaseFocus()

        PlayTween(self.SearchFrame, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, Cosmic.SelectedTheme.Padding or 10, 0, (self.Config.ShowTopbar and self.Config.TopbarHeight or 0) - 10)
        }, 0.3)
        PlayTween(self.SearchInput, {TextTransparency = 1}, 0.2)

        local searchTween = PlayTween(self.SearchFrame, {BackgroundTransparency = 1}, 0.3)
        searchTween.Completed:Connect(function() if self.SearchFrame then self.SearchFrame.Visible = false end end)

        -- Restore TabBar position
        PlayTween(self.TabBar, {Position = UDim2.new(0, 0, 0, (self.Config.ShowTopbar and self.Config.TopbarHeight or 0))}, 0.3)
        -- Restore ContentFrame position and size
        local contentY = (self.Config.ShowTopbar and self.Config.TopbarHeight or 0) + self.TabBar.Size.Y.Offset + (Cosmic.SelectedTheme.Padding or 10)
        PlayTween(self.ContentFrame, {
            Position = UDim2.new(0, Cosmic.SelectedTheme.Padding or 10, 0, contentY),
            Size = UDim2.new(1, -(Cosmic.SelectedTheme.Padding or 10) * 2, 1, -(contentY + (Cosmic.SelectedTheme.Padding or 10)))
        }, 0.3)

        self.SearchInput.Text = "" -- Clear text on close
        self:_FilterTabContent() -- Reset filter (shows all)
    end
end

function Cosmic:_FilterTabContent()
    if not self.ActiveTab or not self.ActiveTab.ContentPage then return end

    local searchTerm = string.lower(self.SearchInput.Text)
    local hasSearchTerm = #searchTerm > 0
    local contentPage = self.ActiveTab.ContentPage
    local resultsTitle = contentPage:FindFirstChild("SearchResultsTitle")

    if hasSearchTerm and not resultsTitle then
        resultsTitle = self:_CreateLabel(self.ActiveTab, { -- Use internal label creation
            Name = "SearchResultsTitle",
            Text = "Results for '" .. searchTerm .. "'",
            Size = 1.2, -- Slightly larger
            _IsInternal = true, -- Flag to prevent saving/listing normally
        }).Instance -- Get the instance
        resultsTitle.LayoutOrder = -1000 -- Ensure it's at the top
        resultsTitle.TextColor3 = Cosmic.SelectedTheme.Accent or Cosmic.SelectedTheme.Primary
        resultsTitle.TextSize = (Cosmic.SelectedTheme.TextSize or 14) + 1
    elseif hasSearchTerm and resultsTitle then
        resultsTitle.Text = "Results for '" .. searchTerm .. "'"
    elseif not hasSearchTerm and resultsTitle then
        resultsTitle:Destroy()
        resultsTitle = nil
    end

    for _, element in ipairs(self.ActiveTab.Elements) do
        if element.Instance and not element.Config._IsInternal then -- Check if instance exists and not internal
            local elementName = string.lower(element.Config.Name or "")
            local isVisible = not hasSearchTerm or string.find(elementName, searchTerm, 1, true)

            -- Handle Sections/Dividers differently (hide if search active)
            if element.Type == "Section" or element.Type == "Divider" then
                isVisible = not hasSearchTerm
            end

            if element.Instance.Visible ~= isVisible then
                 -- Simple visibility toggle, add animations if desired
                 element.Instance.Visible = isVisible
            end
        end
    end
end

function Cosmic:ShowSettingsTab()
    -- Find or create the settings tab
    local settingsTab
    for _, tab in ipairs(self.Tabs) do
        if tab.Config._IsSettingsTab then
            settingsTab = tab
            break
        end
    end

    if not settingsTab then
        -- Create the settings tab if it doesn't exist
        settingsTab = self:AddTab({
            Name = "Settings",
            Icon = Cosmic.SelectedTheme.Icons.Settings,
            _IsSettingsTab = true, -- Internal flag
            _LayoutOrder = 1000 -- Ensure it appears last
        })
        self:_CreateSettingsContent(settingsTab) -- Populate with settings
    end

    self:SetActiveTab(settingsTab)
end

--[[ Tab & Element Functions ]]--

function Cosmic:AddTab(config)
    config = config or {}
    config.Name = config.Name or "Tab"
    config.Icon = config.Icon or Cosmic.SelectedTheme.Icons.DefaultTab

    local window = self
    local tab = {
        IsActive = false,
        Elements = {},
        Config = config,
        Connections = {},
        Window = window -- Reference back to the window
    }
    local tabOrder = config._LayoutOrder or (#window.Tabs + 1)

    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = config.Name:gsub("[^%w]+", "") .. "TabButton"
    -- Calculate width based on text/icon? For now, use fixed/semi-fixed
    local baseWidth = 100
    local textWidth = 0 -- Calculate text bounds if needed
    tabButton.Size = UDim2.new(0, baseWidth + textWidth, 1, 0)
    tabButton.Text = "" -- Text is handled by internal label
    tabButton.LayoutOrder = tabOrder
    tabButton.AutoButtonColor = false
    ApplyThemeStyle(tabButton, "TabButton") -- Applies inactive style
    tabButton.Parent = window.TabBar

    -- Icon
    local iconSize = tabButton.AbsoluteSize.Y * 0.6
    local tabIcon = CreateIcon(config.Icon, tabButton,
        UDim2.fromOffset(iconSize, iconSize),
        UDim2.new(0, Cosmic.SelectedTheme.SmallPadding or 5, 0.5, 0),
        Cosmic.SelectedTheme.TabTextColor)
    tabIcon.AnchorPoint = Vector2.new(0, 0.5)

    -- Text Label
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Name = "TabLabel"
    local labelX = (Cosmic.SelectedTheme.SmallPadding or 5) * 2 + iconSize
    tabLabel.Size = UDim2.new(1, -labelX - (Cosmic.SelectedTheme.SmallPadding or 5), 1, 0)
    tabLabel.Position = UDim2.new(0, labelX, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = config.Name
    tabLabel.Font = Cosmic.SelectedTheme.Font or Enum.Font.SourceSans
    tabLabel.TextSize = Cosmic.SelectedTheme.TextSizeSmall or 13
    tabLabel.TextColor3 = Cosmic.SelectedTheme.TabTextColor
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabButton

    -- Tab Content Page
    local contentPage = Instance.new("ScrollingFrame")
    contentPage.Name = config.Name:gsub("[^%w]+", "") .. "Content"
    contentPage.Size = UDim2.new(1, 0, 1, 0)
    contentPage.LayoutOrder = tabOrder
    ApplyThemeStyle(contentPage, "ScrollingFrame")
    contentPage.CanvasSize = UDim2.new(0,0,0,0) -- Auto-sized by layout
    contentPage.Parent = window.ContentFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, Cosmic.SelectedTheme.Padding or 10)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = contentPage

    -- Auto-canvas size
    table.insert(tab.Connections, contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentPage.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + (Cosmic.SelectedTheme.Padding or 10))
    end))

    -- Assign to tab object
    tab.Button = tabButton
    tab.Icon = tabIcon
    tab.Label = tabLabel
    tab.ContentPage = contentPage
    tab.ContentLayout = contentLayout

    -- Add element creation methods to the tab object (using internal functions)
    function tab:CreateButton(btnConfig) return Cosmic:_CreateButton(self, btnConfig) end
    function tab:CreateToggle(tglConfig) return Cosmic:_CreateToggle(self, tglConfig) end
    function tab:CreateDropdown(drpConfig) return Cosmic:_CreateDropdown(self, drpConfig) end
    function tab:CreateInput(inpConfig) return Cosmic:_CreateInput(self, inpConfig) end
    function tab:CreateLabel(lblConfig) return Cosmic:_CreateLabel(self, lblConfig) end
    function tab:CreateSlider(sldConfig) return Cosmic:_CreateSlider(self, sldConfig) end
    function tab:CreateKeybind(keyConfig) return Cosmic:_CreateKeybind(self, keyConfig) end
    function tab:CreateColorPicker(cpConfig) return Cosmic:_CreateColorPicker(self, cpConfig) end
    function tab:CreateSection(secName) return Cosmic:_CreateSection(self, secName) end
    function tab:CreateDivider() return Cosmic:_CreateDivider(self) end
    function tab:CreateParagraph(pConfig) return Cosmic:_CreateParagraph(self, pConfig) end

    table.insert(window.Tabs, tab)

    -- Activate the first non-settings tab added
    if not window.ActiveTab and not config._IsSettingsTab then
        window:SetActiveTab(tab, true) -- Activate immediately
    end

    -- Click listener
    table.insert(tab.Connections, tabButton.MouseButton1Click:Connect(function()
        window:SetActiveTab(tab)
    end))

    -- Hover effect for inactive tabs
    table.insert(tab.Connections, tabButton.MouseEnter:Connect(function()
        if not tab.IsActive then PlayTween(tabButton, { BackgroundTransparency = 0.3 }, 0.1) end
    end))
    table.insert(tab.Connections, tabButton.MouseLeave:Connect(function()
        if not tab.IsActive then PlayTween(tabButton, { BackgroundTransparency = (Cosmic.SelectedTheme.TabBackground and Cosmic.SelectedTheme.TabBackground.Transparency) or 0.7 }, 0.1) end -- Use theme transparency or default
    end))

    -- Connect theme updates for tab button
    table.insert(window.ThemeConnections, function()
        if tab.IsActive then
            ApplyThemeStyle(tabButton, "TabButtonActive")
            tabLabel.TextColor3 = Cosmic.SelectedTheme.SelectedTabTextColor
            tabIcon.ImageColor3 = Cosmic.SelectedTheme.SelectedTabTextColor
        else
            ApplyThemeStyle(tabButton, "TabButton")
            tabLabel.TextColor3 = Cosmic.SelectedTheme.TabTextColor
            tabIcon.ImageColor3 = Cosmic.SelectedTheme.TabTextColor
        end
    end)

    -- Connect search input changes to filter this tab when active
    table.insert(tab.Connections, window.SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        if window.ActiveTab == tab then window:_FilterTabContent() end
    end))


    return tab
end

function Cosmic:SetActiveTab(targetTab, immediate)
    if self.ActiveTab == targetTab or self.IsMinimized then return end

    local speed = immediate and 0 or nil
    local theme = Cosmic.SelectedTheme

    -- Deactivate previous tab
    if self.ActiveTab then
        local prevTab = self.ActiveTab
        prevTab.IsActive = false
        ApplyThemeStyle(prevTab.Button, "TabButton") -- Apply inactive style
        PlayTween(prevTab.Button, { BackgroundTransparency = theme.TabBackground and theme.TabBackground.Transparency or 0.7 }, speed)
        PlayTween(prevTab.Label, { TextColor3 = theme.TabTextColor }, speed)
        PlayTween(prevTab.Icon, { ImageColor3 = theme.TabTextColor }, speed)
    end

    -- Activate new tab
    targetTab.IsActive = true
    self.ActiveTab = targetTab
    ApplyThemeStyle(targetTab.Button, "TabButtonActive") -- Apply active style
    PlayTween(targetTab.Button, { BackgroundTransparency = theme.TabBackgroundSelected and theme.TabBackgroundSelected.Transparency or 0 }, speed)
    PlayTween(targetTab.Label, { TextColor3 = theme.SelectedTabTextColor }, speed)
    PlayTween(targetTab.Icon, { ImageColor3 = theme.SelectedTabTextColor }, speed)

    -- Switch page layout
    if immediate then
        self.PageLayout:JumpTo(targetTab.ContentPage)
    else
        self.PageLayout:ScrollTo(targetTab.ContentPage) -- Use ScrollTo for smoother transition
    end

    -- Re-apply search filter for the new tab
    self:_FilterTabContent()
end

--[[ Internal Element Creation Functions (Called by Tab methods) ]]--

-- Base Element Creation Helper
function Cosmic:_CreateBaseElement(parentTab, config, elementType, template)
    config = config or {}
    config.Name = config.Name or elementType
    config.Flag = config.Flag or nil -- For config saving
    config._IsInternal = config._IsInternal or false -- For internal elements like search results title

    local elementOrder = #parentTab.Elements + 1

    local elementFrame = template:Clone()
    elementFrame.Name = config.Name:gsub("[^%w]+", "") -- Sanitize name
    elementFrame.Visible = true
    elementFrame.LayoutOrder = elementOrder
    ApplyThemeStyle(elementFrame, elementType) -- Apply base style
    elementFrame.Parent = parentTab.ContentPage

    local element = {
        Type = elementType,
        Instance = elementFrame,
        Config = config,
        Connections = {},
        Window = parentTab.Window, -- Reference back to window
        Tab = parentTab, -- Reference back to tab
        -- Default Destroy method
        Destroy = function(self)
            for _, c in ipairs(self.Connections) do if typeof(c) == "RBXScriptConnection" then c:Disconnect() end end
            self.Instance:Destroy()
            -- Remove from parentTab.Elements
            for i, el in ipairs(parentTab.Elements) do if el == self then table.remove(parentTab.Elements, i); break end end
            -- Remove from global flags if necessary
            if self.Config.Flag and Cosmic.Flags[self.Config.Flag] == self then Cosmic.Flags[self.Config.Flag] = nil end
            for k in pairs(self) do self[k] = nil end -- Clear self
        end,
        -- Default UpdateTheme method (can be overridden)
        UpdateTheme = function(self)
            ApplyThemeStyle(self.Instance, self.Type)
            -- Add element-specific theme updates here if needed
        end
    }

    -- Register for configuration saving if flag exists and enabled
    if config.Flag and parentTab.Window.CEnabled and not config._IsInternal then
        if Cosmic.Flags[config.Flag] then
            warn("CosmicUI: Duplicate Flag detected:", config.Flag, "- Overwriting previous element.")
        end
        Cosmic.Flags[config.Flag] = element
    end

    -- Add hover effect (optional, can be overridden)
    if elementType ~= "Section" and elementType ~= "Divider" and elementType ~= "Label" and elementType ~= "Paragraph" then -- Exclude non-interactive
        table.insert(element.Connections, elementFrame.MouseEnter:Connect(function()
            if not element.IsDisabled then -- Check for disabled state if implemented
                PlayTween(elementFrame, { BackgroundColor3 = Cosmic.SelectedTheme.ElementBackgroundHover }, 0.1)
            end
        end))
        table.insert(element.Connections, elementFrame.MouseLeave:Connect(function()
             if not element.IsDisabled then
                PlayTween(elementFrame, { BackgroundColor3 = Cosmic.SelectedTheme.ElementBackground }, 0.1)
             end
        end))
    end

    -- Add to parent tab's element list unless internal
    if not config._IsInternal then
        table.insert(parentTab.Elements, element)
    end

    -- Initial animation (fade/slide in - optional)
    elementFrame.BackgroundTransparency = 1
    if elementFrame:FindFirstChild("BaseStroke") then elementFrame.BaseStroke.Transparency = 1 end
    if elementFrame:FindFirstChild("Title") then elementFrame.Title.TextTransparency = 1 end
    -- Add more initial transparency settings...

    task.delay(0.1 + (elementOrder * 0.02), function() -- Staggered animation
        if elementFrame and elementFrame.Parent then
            PlayTween(elementFrame, { BackgroundTransparency = 0 }, 0.3)
            if elementFrame:FindFirstChild("BaseStroke") then PlayTween(elementFrame.BaseStroke, { Transparency = 0 }, 0.3) end
            if elementFrame:FindFirstChild("Title") then PlayTween(elementFrame.Title, { TextTransparency = 0 }, 0.3) end
            -- Add more fade-in tweens...
        end
    end)


    return element
end

-- Button
function Cosmic:_CreateButton(parentTab, config)
    local template = parentTab.Window.ContentFrame.Template.Button -- Adjust path if needed
    local element = Cosmic:_CreateBaseElement(parentTab, config, "Button", template)
    local buttonFrame = element.Instance
    local titleLabel = buttonFrame:FindFirstChild("Title")
    local interactButton = buttonFrame:FindFirstChild("Interact")

    titleLabel.Text = config.Name
    ApplyThemeStyle(buttonFrame, "Button") -- Ensure button-specific style

    -- Click Animation & Callback
    table.insert(element.Connections, interactButton.MouseButton1Click:Connect(function()
        -- Click feedback
        PlayTween(buttonFrame, { BackgroundColor3 = Cosmic.SelectedTheme.Primary * 0.8 }, 0.05) -- Darker primary
        PlayTween(buttonFrame, { BackgroundColor3 = Cosmic.SelectedTheme.ElementBackgroundHover }, 0.1):Delay(0.05) -- Back to hover

        -- Callback
        local success, err = pcall(config.Callback or function() print("Button clicked:", config.Name) end)
        if not success then
            warn("CosmicUI: Button Callback Error for '" .. config.Name .. "':", err)
            parentTab.Window:Notify({Title = "Callback Error", Content = config.Name .. ": " .. tostring(err), Icon = Cosmic.SelectedTheme.Error})
            -- Visual error indication (optional)
            local originalColor = buttonFrame.BackgroundColor3
            buttonFrame.BackgroundColor3 = Cosmic.SelectedTheme.Error
            task.delay(0.5, function() if buttonFrame and buttonFrame.Parent then buttonFrame.BackgroundColor3 = originalColor end end)
        else
            if element.Config.Flag and element.Window.CEnabled then element.Window:SaveConfiguration() end -- Save on success if flagged
        end
    end))

    -- Override UpdateTheme if needed
    element.UpdateTheme = function(self)
        ApplyThemeStyle(self.Instance, "Button")
        self.Instance.Title.TextColor3 = Cosmic.SelectedTheme.SelectedTabTextColor or Cosmic.SelectedTheme.TextColor
    end
    element:UpdateTheme() -- Initial call

    return element
end

-- Toggle
function Cosmic:_CreateToggle(parentTab, config)
    config.CurrentValue = config.CurrentValue or false
    local template = parentTab.Window.ContentFrame.Template.Toggle
    local element = Cosmic:_CreateBaseElement(parentTab, config, "Toggle", template)
    local toggleFrame = element.Instance
    local titleLabel = toggleFrame:FindFirstChild("Title")
    local switchFrame = toggleFrame:FindFirstChild("Switch")
    local indicator = switchFrame:FindFirstChild("Indicator")
    local interactButton = toggleFrame:FindFirstChild("Interact")

    titleLabel.Text = config.Name
    element.CurrentValue = config.CurrentValue -- Store state

    local function UpdateVisuals(value, animate)
        local theme = Cosmic.SelectedTheme
        local speed = animate and 0.2 or 0
        local targetPos, indicatorColor, indicatorStroke, outerStroke
        if value then
            targetPos = UDim2.new(1, -indicator.AbsoluteSize.X - 3, 0.5, 0) -- Right side
            indicatorColor = theme.ToggleEnabled
            indicatorStroke = theme.ToggleEnabledStroke
            outerStroke = theme.ToggleEnabledOuterStroke
        else
            targetPos = UDim2.new(0, 3, 0.5, 0) -- Left side
            indicatorColor = theme.ToggleDisabled
            indicatorStroke = theme.ToggleDisabledStroke
            outerStroke = theme.ToggleDisabledOuterStroke
        end

        PlayTween(indicator, { Position = targetPos, BackgroundColor3 = indicatorColor }, speed, Enum.EasingStyle.Quart)
        if indicator:FindFirstChild("BaseStroke") then PlayTween(indicator.BaseStroke, { Color = indicatorStroke }, speed) end
        if switchFrame:FindFirstChild("BaseStroke") then PlayTween(switchFrame.BaseStroke, { Color = outerStroke }, speed) end
    end

    -- Initial state
    ApplyThemeStyle(switchFrame, "ToggleFrame")
    ApplyThemeStyle(indicator, "ToggleIndicator")
    UpdateVisuals(element.CurrentValue, false)

    -- Click Interaction
    table.insert(element.Connections, interactButton.MouseButton1Click:Connect(function()
        element.CurrentValue = not element.CurrentValue
        UpdateVisuals(element.CurrentValue, true)

        -- Callback
        local success, err = pcall(config.Callback or function(v) print("Toggle:", config.Name, v) end, element.CurrentValue)
        if not success then
            warn("CosmicUI: Toggle Callback Error for '" .. config.Name .. "':", err)
            parentTab.Window:Notify({Title = "Callback Error", Content = config.Name .. ": " .. tostring(err), Icon = Cosmic.SelectedTheme.Error})
            -- Revert state visually on error?
            element.CurrentValue = not element.CurrentValue
            UpdateVisuals(element.CurrentValue, true)
        else
             if element.Config.Flag and element.Window.CEnabled then element.Window:SaveConfiguration() end -- Save on success
        end
    end))

    -- Set Method
    element.Set = function(self, value, silent)
        value = value == true
        if self.CurrentValue == value then return end -- No change

        self.CurrentValue = value
        UpdateVisuals(self.CurrentValue, true)

        if not silent then
            local success, err = pcall(config.Callback or function() end, self.CurrentValue)
            if not success then warn("CosmicUI: Toggle Callback Error (Set) for '" .. config.Name .. "':", err) end
            if self.Config.Flag and self.Window.CEnabled then self.Window:SaveConfiguration() end
        end
    end

    -- Update Theme Method
    element.UpdateTheme = function(self)
        ApplyThemeStyle(self.Instance, "Toggle") -- Base frame
        ApplyThemeStyle(self.Instance.Switch, "ToggleFrame")
        ApplyThemeStyle(self.Instance.Switch.Indicator, "ToggleIndicator")
        UpdateVisuals(self.CurrentValue, false) -- Re-apply colors based on state
    end
    element:UpdateTheme() -- Initial call

    return element
end

-- Slider
function Cosmic:_CreateSlider(parentTab, config)
    config.Range = config.Range or {0, 100}
    config.Increment = config.Increment or 1
    config.CurrentValue = config.CurrentValue or config.Range[1]
    config.Suffix = config.Suffix or ""
    local template = parentTab.Window.ContentFrame.Template.Slider
    local element = Cosmic:_CreateBaseElement(parentTab, config, "Slider", template)
    local sliderFrame = element.Instance
    local titleLabel = sliderFrame:FindFirstChild("Title")
    local sliderMain = sliderFrame:FindFirstChild("Main")
    local progress = sliderMain:FindFirstChild("Progress")
    local infoLabel = sliderMain:FindFirstChild("Information")
    local interact = sliderMain:FindFirstChild("Interact")

    titleLabel.Text = config.Name
    element.CurrentValue = config.CurrentValue

    local function ValueToFraction(value)
        local min, max = config.Range[1], config.Range[2]
        return math.clamp((value - min) / (max - min), 0, 1)
    end

    local function FractionToValue(fraction)
        local min, max = config.Range[1], config.Range[2]
        local rawValue = min + fraction * (max - min)
        local steppedValue = math.floor(rawValue / config.Increment + 0.5) * config.Increment
        return math.clamp(steppedValue, min, max)
    end

    local function UpdateVisuals(value, animate)
        local fraction = ValueToFraction(value)
        local speed = animate and 0.1 or 0
        PlayTween(progress, { Size = UDim2.new(fraction, 0, 1, 0) }, speed)
        infoLabel.Text = tostring(value) .. (config.Suffix and (" " .. config.Suffix) or "")
    end

    -- Initial State
    ApplyThemeStyle(sliderMain, "SliderTrack")
    ApplyThemeStyle(progress, "SliderFill")
    UpdateVisuals(element.CurrentValue, false)

    -- Drag Interaction
    local dragging = false
    table.insert(element.Connections, interact.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            PlayTween(sliderMain.BaseStroke, { Transparency = 1 }, 0.1) -- Hide outer stroke
            PlayTween(progress.BaseStroke, { Transparency = 1 }, 0.1) -- Hide inner stroke
            -- Apply glow/highlight?
        end
    end))
    table.insert(element.Connections, interact.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                PlayTween(sliderMain.BaseStroke, { Transparency = 0.4 }, 0.1) -- Restore outer stroke
                PlayTween(progress.BaseStroke, { Transparency = 0.3 }, 0.1) -- Restore inner stroke
                -- Remove glow/highlight
                if element.Config.Flag and element.Window.CEnabled then element.Window:SaveConfiguration() end -- Save on drag end
            end
        end
    end))
    table.insert(element.Connections, interact.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = input.Position.X
            local startX = sliderMain.AbsolutePosition.X
            local width = sliderMain.AbsoluteSize.X
            local fraction = math.clamp((mouseX - startX) / width, 0, 1)
            local newValue = FractionToValue(fraction)

            if element.CurrentValue ~= newValue then
                element.CurrentValue = newValue
                UpdateVisuals(newValue, false) -- Update instantly during drag

                -- Continuous callback (optional)
                if config.ContinuousCallback then
                    pcall(config.Callback or function() end, newValue)
                end
            end
        end
    end))
     -- Click to set value
    table.insert(element.Connections, interact.MouseButton1Down:Connect(function()
        if not dragging then -- Only trigger on initial click, not during drag start
            local mouseX = UserInputService:GetMouseLocation().X
            local startX = sliderMain.AbsolutePosition.X
            local width = sliderMain.AbsoluteSize.X
            local fraction = math.clamp((mouseX - startX) / width, 0, 1)
            local newValue = FractionToValue(fraction)

            if element.CurrentValue ~= newValue then
                element.CurrentValue = newValue
                UpdateVisuals(newValue, true) -- Animate on click

                -- Trigger main callback
                local success, err = pcall(config.Callback or function() end, newValue)
                if not success then warn("CosmicUI: Slider Callback Error:", err) end
                -- No immediate save on click, save happens on drag end or Set
            end
        end
    end))


    -- Set Method
    element.Set = function(self, value, silent)
        value = math.clamp(value, config.Range[1], config.Range[2])
        value = FractionToValue(ValueToFraction(value)) -- Ensure it snaps to increment

        if self.CurrentValue == value then return end

        self.CurrentValue = value
        UpdateVisuals(self.CurrentValue, true)

        if not silent then
            local success, err = pcall(config.Callback or function() end, self.CurrentValue)
            if not success then warn("CosmicUI: Slider Callback Error (Set):", err) end
            if self.Config.Flag and self.Window.CEnabled then self.Window:SaveConfiguration() end
        end
    end

    -- Update Theme Method
    element.UpdateTheme = function(self)
        ApplyThemeStyle(self.Instance, "Slider") -- Base frame
        ApplyThemeStyle(self.Instance.Main, "SliderTrack")
        ApplyThemeStyle(self.Instance.Main.Progress, "SliderFill")
        self.Instance.Main.Information.TextColor3 = Cosmic.SelectedTheme.TextColor -- Update info label color
    end
    element:UpdateTheme() -- Initial call

    return element
end

-- Input
function Cosmic:_CreateInput(parentTab, config)
    config.CurrentValue = config.CurrentValue or ""
    config.PlaceholderText = config.PlaceholderText or "Enter text..."
    config.RemoveTextAfterFocusLost = config.RemoveTextAfterFocusLost or false
    local template = parentTab.Window.ContentFrame.Template.Input
    local element = Cosmic:_CreateBaseElement(parentTab, config, "Input", template)
    local inputFrame = element.Instance
    local titleLabel = inputFrame:FindFirstChild("Title")
    local inputInnerFrame = inputFrame:FindFirstChild("InputFrame")
    local inputBox = inputInnerFrame:FindFirstChild("InputBox")

    titleLabel.Text = config.Name
    inputBox.Text = config.CurrentValue
    inputBox.PlaceholderText = config.PlaceholderText
    element.CurrentValue = config.CurrentValue

    ApplyThemeStyle(inputInnerFrame, "TextBox") -- Style the inner frame

    -- Adaptive Width (like Rayfield)
    local function UpdateWidth()
        local textBoundsX = inputBox.TextBounds.X
        local minWidth = 50 -- Minimum width
        local maxWidth = inputFrame.AbsoluteSize.X - titleLabel.AbsoluteSize.X - 30 -- Max available width
        local targetWidth = math.clamp(textBoundsX + 24, minWidth, maxWidth)
        PlayTween(inputInnerFrame, { Size = UDim2.new(0, targetWidth, 1, 0) }, 0.1)
    end

    table.insert(element.Connections, inputBox:GetPropertyChangedSignal("Text"):Connect(UpdateWidth))
    UpdateWidth() -- Initial width

    -- Focus Lost / Enter Pressed
    table.insert(element.Connections, inputBox.FocusLost:Connect(function(enterPressed)
        local newValue = inputBox.Text
        if element.CurrentValue == newValue and not enterPressed and not config.RemoveTextAfterFocusLost then return end -- No change unless forced

        element.CurrentValue = newValue
        local success, err = pcall(config.Callback or function(t) print("Input:", config.Name, t) end, newValue)
        if not success then
            warn("CosmicUI: Input Callback Error:", err)
            parentTab.Window:Notify({Title = "Callback Error", Content = config.Name .. ": " .. tostring(err), Icon = Cosmic.SelectedTheme.Error})
            -- Revert text?
            -- inputBox.Text = element.CurrentValue -- Revert on error
        else
            if element.Config.Flag and element.Window.CEnabled then element.Window:SaveConfiguration() end -- Save on success
        end

        if config.RemoveTextAfterFocusLost then
            inputBox.Text = ""
            element.CurrentValue = "" -- Update internal state too
        end
        UpdateWidth()
    end))

    -- Set Method
    element.Set = function(self, text, silent)
        text = tostring(text)
        if self.CurrentValue == text then return end

        self.CurrentValue = text
        inputBox.Text = text
        UpdateWidth()

        if not silent then
            local success, err = pcall(config.Callback or function() end, self.CurrentValue)
            if not success then warn("CosmicUI: Input Callback Error (Set):", err) end
            if self.Config.Flag and self.Window.CEnabled then self.Window:SaveConfiguration() end
        end
    end

    -- Update Theme Method
    element.UpdateTheme = function(self)
        ApplyThemeStyle(self.Instance, "Input") -- Base frame
        ApplyThemeStyle(self.Instance.InputFrame, "TextBox") -- Inner frame
        self.Instance.InputFrame.InputBox.PlaceholderColor3 = Cosmic.SelectedTheme.PlaceholderColor
        self.Instance.InputFrame.InputBox.TextColor3 = Cosmic.SelectedTheme.TextColor
    end
    element:UpdateTheme() -- Initial call

    return element
end

-- Dropdown
function Cosmic:_CreateDropdown(parentTab, config)
    config.Options = config.Options or {}
    config.MultipleOptions = config.MultipleOptions or false
    config.CurrentOption = config.CurrentOption or (config.MultipleOptions and {} or (config.Options[1] and {config.Options[1]} or {})) -- Default selection logic
    local template = parentTab.Window.ContentFrame.Template.Dropdown
    local element = Cosmic:_CreateBaseElement(parentTab, config, "Dropdown", template)
    local dropdownFrame = element.Instance
    local titleLabel = dropdownFrame:FindFirstChild("Title")
    local selectedLabel = dropdownFrame:FindFirstChild("Selected")
    local toggleButton = dropdownFrame:FindFirstChild("Toggle")
    local listFrame = dropdownFrame:FindFirstChild("List")
    local listLayout = listFrame:FindFirstChild("UIListLayout")
    local interactButton = dropdownFrame:FindFirstChild("Interact")

    titleLabel.Text = config.Name
    element.CurrentOption = config.CurrentOption -- Store as table
    element.IsOpen = false

    local function UpdateSelectedText()
        if config.MultipleOptions then
            local count = #element.CurrentOption
            if count == 0 then selectedLabel.Text = "None"
            elseif count == 1 then selectedLabel.Text = element.CurrentOption[1]
            else selectedLabel.Text = "Various (" .. count .. ")" end
        else
            selectedLabel.Text = element.CurrentOption[1] or "None"
        end
    end

    local function PopulateOptions()
        -- Clear existing options
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "Template" then child:Destroy() end
        end
        -- Add new options
        for i, optionName in ipairs(config.Options) do
            local optionFrame = listFrame.Template:Clone()
            optionFrame.Name = optionName
            optionFrame.Visible = true
            optionFrame.LayoutOrder = i
            ApplyThemeStyle(optionFrame, "DropdownOption") -- Initial style
            optionFrame.Parent = listFrame

            local optionLabel = optionFrame:FindFirstChild("Title")
            optionLabel.Text = optionName

            local optionInteract = optionFrame:FindFirstChild("Interact")

            -- Check if selected and apply style
            if table.find(element.CurrentOption, optionName) then
                ApplyThemeStyle(optionFrame, "DropdownOptionSelected")
            end

            table.insert(element.Connections, optionInteract.MouseButton1Click:Connect(function()
                local wasSelected = table.find(element.CurrentOption, optionName)
                local changed = false

                if config.MultipleOptions then
                    if wasSelected then
                        table.remove(element.CurrentOption, table.find(element.CurrentOption, optionName))
                        ApplyThemeStyle(optionFrame, "DropdownOption") -- Deselect style
                        changed = true
                    else
                        table.insert(element.CurrentOption, optionName)
                        ApplyThemeStyle(optionFrame, "DropdownOptionSelected") -- Select style
                        changed = true
                    end
                else -- Single option selection
                    if not wasSelected then
                        -- Deselect previous
                        if element.CurrentOption[1] then
                            local prevOptionFrame = listFrame:FindFirstChild(element.CurrentOption[1])
                            if prevOptionFrame then ApplyThemeStyle(prevOptionFrame, "DropdownOption") end
                        end
                        -- Select new
                        element.CurrentOption = {optionName}
                        ApplyThemeStyle(optionFrame, "DropdownOptionSelected")
                        changed = true
                        element:_ToggleList(false) -- Close list on single select
                    end
                end

                if changed then
                    UpdateSelectedText()
                    local success, err = pcall(config.Callback or function(o) print("Dropdown:", config.Name, o) end, element.CurrentOption)
                    if not success then warn("CosmicUI: Dropdown Callback Error:", err) end
                    if element.Config.Flag and element.Window.CEnabled then element.Window:SaveConfiguration() end
                end
            end))

             -- Hover effect for options
            table.insert(element.Connections, optionInteract.MouseEnter:Connect(function()
                if not table.find(element.CurrentOption, optionName) then
                    PlayTween(optionFrame, { BackgroundColor3 = Cosmic.SelectedTheme.ElementBackgroundHover }, 0.1)
                end
            end))
            table.insert(element.Connections, optionInteract.MouseLeave:Connect(function()
                 if not table.find(element.CurrentOption, optionName) then
                    PlayTween(optionFrame, { BackgroundColor3 = Cosmic.SelectedTheme.DropdownUnselected }, 0.1)
                 end
            end))
        end
        -- Update list frame canvas size (important for scrolling)
        listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end

    element._ToggleList = function(self, forceState)
        local targetOpen = forceState == nil and not self.IsOpen or forceState
        if self.IsOpen == targetOpen then return end
        self.IsOpen = targetOpen

        local listHeight = math.min(listLayout.AbsoluteContentSize.Y + 10, 135) -- Max height 135
        local targetSizeY = (Cosmic.SelectedTheme.ElementHeight or 38) + (self.IsOpen and listHeight + 5 or 0)
        local targetRotation = self.IsOpen and 0 or 180

        PlayTween(dropdownFrame, { Size = UDim2.new(1, -10, 0, targetSizeY) }, 0.3)
        PlayTween(toggleButton, { Rotation = targetRotation }, 0.3)

        if self.IsOpen then
            listFrame.Visible = true
            ApplyThemeStyle(listFrame, "DropdownList") -- Style the list frame itself
            PlayTween(listFrame, { BackgroundTransparency = 0 }, 0.2)
            PlayTween(listFrame, { ScrollBarImageTransparency = 0.7 }, 0.2)
            -- Animate options visibility? (Optional)
        else
            PlayTween(listFrame, { BackgroundTransparency = 1 }, 0.2)
            PlayTween(listFrame, { ScrollBarImageTransparency = 1 }, 0.2)
            task.delay(0.2, function() if listFrame and not self.IsOpen then listFrame.Visible = false end end)
        end
    end

    -- Initial State
    ApplyThemeStyle(toggleButton, "ImageButton") -- Basic style for arrow
    toggleButton.Rotation = 180 -- Start closed
    listFrame.Visible = false
    PopulateOptions()
    UpdateSelectedText()

    -- Click to toggle list
    table.insert(element.Connections, interactButton.MouseButton1Click:Connect(function() element:_ToggleList() end))

    -- Set Method
    element.Set = function(self, options, silent) -- options should be a table
        if type(options) ~= "table" then options = {options} end -- Ensure table

        local newSelection = {}
        local changed = false
        for _, opt in ipairs(options) do
            if table.find(config.Options, opt) then -- Only add valid options
                table.insert(newSelection, opt)
            end
        end

        if not config.MultipleOptions and #newSelection > 1 then
            newSelection = {newSelection[1]} -- Take first if single select
        end

        -- Check if selection actually changed
        if #self.CurrentOption ~= #newSelection then
            changed = true
        else
            for i = 1, #newSelection do
                if self.CurrentOption[i] ~= newSelection[i] then changed = true; break end
            end
        end

        if not changed then return end

        self.CurrentOption = newSelection
        PopulateOptions() -- Repopulate to update visual selection state
        UpdateSelectedText()

        if not silent then
            local success, err = pcall(config.Callback or function() end, self.CurrentOption)
            if not success then warn("CosmicUI: Dropdown Callback Error (Set):", err) end
            if self.Config.Flag and self.Window.CEnabled then self.Window:SaveConfiguration() end
        end
    end

    -- Refresh Method (like Rayfield)
    element.Refresh = function(self, newOptionsTable)
        config.Options = newOptionsTable or {}
        -- Filter CurrentOption to remove options no longer present
        local validSelection = {}
        for _, opt in ipairs(self.CurrentOption) do
            if table.find(config.Options, opt) then table.insert(validSelection, opt) end
        end
        self.CurrentOption = validSelection
        -- Repopulate and update display
        PopulateOptions()
        UpdateSelectedText()
        -- Optionally trigger callback if selection changed due to refresh?
    end

    -- Update Theme Method
    element.UpdateTheme = function(self)
        ApplyThemeStyle(self.Instance, "Dropdown") -- Base frame
        ApplyThemeStyle(self.Instance.Toggle, "ImageButton") -- Arrow
        self.Instance.Selected.TextColor3 = Cosmic.SelectedTheme.TextSecondary -- Selected text color
        if self.IsOpen then ApplyThemeStyle(self.Instance.List, "DropdownList") end
        -- Update options theme
        for _, child in ipairs(self.Instance.List:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "Template" then
                if table.find(self.CurrentOption, child.Name) then
                    ApplyThemeStyle(child, "DropdownOptionSelected")
                else
                    ApplyThemeStyle(child, "DropdownOption")
                end
                child.Title.TextColor3 = Cosmic.SelectedTheme.TextColor
            end
        end
    end
    element:UpdateTheme() -- Initial call

    return element
end

-- Keybind
function Cosmic:_CreateKeybind(parentTab, config)
    config.CurrentKeybind = config.CurrentKeybind or "None"
    config.HoldToInteract = config.HoldToInteract or false
    config.CallOnChange = config.CallOnChange or false -- If true, callback runs when key is set, not pressed
    local template = parentTab.Window.ContentFrame.Template.Keybind
    local element = Cosmic:_CreateBaseElement(parentTab, config, "Keybind", template)
    local keybindFrame = element.Instance
    local titleLabel = keybindFrame:FindFirstChild("Title")
    local keybindInnerFrame = keybindFrame:FindFirstChild("KeybindFrame")
    local keybindBox = keybindInnerFrame:FindFirstChild("KeybindBox") -- This is a TextButton now

    titleLabel.Text = config.Name
    keybindBox.Text = config.CurrentKeybind
    element.CurrentKeybind = config.CurrentKeybind
    element.IsListening = false

    ApplyThemeStyle(keybindInnerFrame, "TextBox") -- Use input style for frame

    -- Click to Listen
    table.insert(element.Connections, keybindBox.MouseButton1Click:Connect(function()
        if not element.IsListening then
            element.IsListening = true
            keybindBox.Text = "..."
            keybindBox.TextColor3 = Cosmic.SelectedTheme.Accent or Cosmic.SelectedTheme.Primary
            -- Capture next input
        else -- Click again to cancel
            element.IsListening = false
            keybindBox.Text = element.CurrentKeybind
            keybindBox.TextColor3 = Cosmic.SelectedTheme.TextColor
        end
    end))

    -- Input Listener
    local inputConnection
    inputConnection = UserInputService.InputBegan:Connect(function(input, processed)
        if element.IsListening and not processed then
            local keyCode = input.KeyCode
            if keyCode ~= Enum.KeyCode.Unknown then
                local keyName = string.gsub(tostring(keyCode), "Enum.KeyCode.", "")

                -- Handle special keys / cancel
                if keyCode == Enum.KeyCode.Escape then
                    keyName = "None" -- Cancel binding
                elseif keyCode == Enum.KeyCode.Delete or keyCode == Enum.KeyCode.Backspace then
                     keyName = "None" -- Clear binding
                end

                element.IsListening = false
                element.CurrentKeybind = keyName
                keybindBox.Text = keyName
                keybindBox.TextColor3 = Cosmic.SelectedTheme.TextColor

                if config.CallOnChange then
                    local success, err = pcall(config.Callback or function(k) print("Keybind Set:", config.Name, k) end, keyName)
                    if not success then warn("CosmicUI: Keybind Callback Error (OnChange):", err) end
                end
                if element.Config.Flag and element.Window.CEnabled then element.Window:SaveConfiguration() end
            end
        elseif not config.CallOnChange and not element.IsListening and element.CurrentKeybind ~= "None" and input.KeyCode == Enum.KeyCode[element.CurrentKeybind] and not processed then
            -- Keybind Pressed Logic (HoldToInteract etc.)
            if not config.HoldToInteract then
                local success, err = pcall(config.Callback or function() print("Keybind Pressed:", config.Name) end)
                if not success then warn("CosmicUI: Keybind Callback Error (Press):", err) end
            else
                -- Hold logic
                local held = true
                local changedConn
                changedConn = input.Changed:Connect(function(prop)
                    if prop == "UserInputState" and input.UserInputState == Enum.UserInputState.End then
                        held = false
                        if changedConn then changedConn:Disconnect() end
                        pcall(config.Callback or function() end, false) -- Call with false when released
                    end
                end)
                task.spawn(function()
                    while held do
                        pcall(config.Callback or function() end, true) -- Call with true while held
                        RunService.Heartbeat:Wait() -- Wait a frame
                    end
                end)
            end
        end
    end)
    table.insert(element.Connections, inputConnection) -- Store connection for cleanup

    -- Set Method
    element.Set = function(self, keyName, silent)
        keyName = tostring(keyName)
        -- Validate keyName? (Check if Enum.KeyCode[keyName] exists?)
        if self.CurrentKeybind == keyName then return end

        self.CurrentKeybind = keyName
        keybindBox.Text = keyName
        if self.IsListening then -- Cancel listening if Set is called
            self.IsListening = false
            keybindBox.TextColor3 = Cosmic.SelectedTheme.TextColor
        end

        if not silent then
            if config.CallOnChange then
                local success, err = pcall(config.Callback or function() end, keyName)
                if not success then warn("CosmicUI: Keybind Callback Error (Set/OnChange):", err) end
            end
            if self.Config.Flag and self.Window.CEnabled then self.Window:SaveConfiguration() end
        end
    end

    -- Update Theme Method
    element.UpdateTheme = function(self)
        ApplyThemeStyle(self.Instance, "Keybind") -- Base frame
        ApplyThemeStyle(self.Instance.KeybindFrame, "TextBox") -- Inner frame
        self.Instance.KeybindFrame.KeybindBox.TextColor3 = self.IsListening and (Cosmic.SelectedTheme.Accent or Cosmic.SelectedTheme.Primary) or Cosmic.SelectedTheme.TextColor
    end
    element:UpdateTheme() -- Initial call

    return element
end

-- Label
function Cosmic:_CreateLabel(parentTab, config)
    local template = parentTab.Window.ContentFrame.Template.Label
    local element = Cosmic:_CreateBaseElement(parentTab, config, "Label", template)
    local labelFrame = element.Instance
    local titleLabel = labelFrame:FindFirstChild("Title")
    local icon = labelFrame:FindFirstChild("Icon")

    titleLabel.Text = config.Text or config.Name -- Use Text field, fallback to Name
    icon.Visible = false -- Hide icon by default

    -- Handle optional icon and color override (like Rayfield)
    if config.Icon then
        icon.Visible = true
        local asset = getIcon(config.Icon)
        icon.Image = "rbxassetid://" .. asset.id
        icon.ImageRectOffset = asset.imageRectOffset
        icon.ImageRectSize = asset.imageRectSize
        titleLabel.Position = UDim2.new(0, 45, 0.5, 0) -- Indent text
        titleLabel.Size = UDim2.new(1, -55, 1, 0)
    else
        titleLabel.Position = UDim2.new(0, 10, 0.5, 0)
        titleLabel.Size = UDim2.new(1, -20, 1, 0)
    end

    local ignoreTheme = config.IgnoreTheme or false
    local customColor = config.Color

    element.UpdateTheme = function(self)
        local theme = Cosmic.SelectedTheme
        ApplyThemeStyle(self.Instance, "Label") -- Apply base label style
        if ignoreTheme and customColor then
            self.Instance.BackgroundColor3 = customColor
            if self.Instance.BaseStroke then self.Instance.BaseStroke.Color = customColor * 0.8 end -- Darker stroke
            self.Instance.Title.TextColor3 = customColor.R*0.21 + customColor.G*0.72 + customColor.B*0.07 > 0.5 and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255) -- Auto text color
            self.Instance.Icon.ImageColor3 = self.Instance.Title.TextColor3
        else
            -- Use theme colors
            self.Instance.BackgroundColor3 = theme.SecondaryElementBackground or theme.ElementBackground
            if self.Instance.BaseStroke then self.Instance.BaseStroke.Color = theme.SecondaryElementStroke or theme.ElementStroke end
            self.Instance.Title.TextColor3 = theme.TextColor
            self.Instance.Icon.ImageColor3 = theme.TextColor
        end
    end

    element.Set = function(self, newText, newIcon, newColor)
        self.Instance.Title.Text = newText or self.Instance.Title.Text
        config.Text = newText or config.Text -- Update config text

        if newIcon ~= nil then
            config.Icon = newIcon
            if newIcon and newIcon ~= 0 then
                 self.Instance.Icon.Visible = true
                 local asset = getIcon(newIcon)
                 self.Instance.Icon.Image = "rbxassetid://" .. asset.id
                 self.Instance.Icon.ImageRectOffset = asset.imageRectOffset
                 self.Instance.Icon.ImageRectSize = asset.imageRectSize
                 self.Instance.Title.Position = UDim2.new(0, 45, 0.5, 0)
                 self.Instance.Title.Size = UDim2.new(1, -55, 1, 0)
            else
                 self.Instance.Icon.Visible = false
                 self.Instance.Title.Position = UDim2.new(0, 10, 0.5, 0)
                 self.Instance.Title.Size = UDim2.new(1, -20, 1, 0)
            end
        end
        if newColor ~= nil then
            config.Color = newColor
            customColor = newColor -- Update local override
        end
        self:UpdateTheme() -- Re-apply theme/color
    end

    element:UpdateTheme() -- Initial call

    return element
end

-- Paragraph
function Cosmic:_CreateParagraph(parentTab, config)
    local template = parentTab.Window.ContentFrame.Template.Paragraph
    local element = Cosmic:_CreateBaseElement(parentTab, config, "Paragraph", template)
    local paragraphFrame = element.Instance
    local titleLabel = paragraphFrame:FindFirstChild("Title")
    local contentLabel = paragraphFrame:FindFirstChild("Content")

    titleLabel.Text = config.Title or config.Name
    contentLabel.Text = config.Content or ""

    element.Set = function(self, newTitle, newContent)
        if newTitle then
            self.Instance.Title.Text = newTitle
            config.Title = newTitle
        end
        if newContent then
            self.Instance.Content.Text = newContent
            config.Content = newContent
            -- Might need to recalculate size if dynamic height is desired
        end
    end

    element.UpdateTheme = function(self)
        ApplyThemeStyle(self.Instance, "Paragraph") -- Base style
        self.Instance.BackgroundColor3 = Cosmic.SelectedTheme.SecondaryElementBackground or Cosmic.SelectedTheme.ElementBackground
        if self.Instance.BaseStroke then self.Instance.BaseStroke.Color = Cosmic.SelectedTheme.SecondaryElementStroke or Cosmic.SelectedTheme.ElementStroke end
        self.Instance.Title.TextColor3 = Cosmic.SelectedTheme.TextColor
        self.Instance.Content.TextColor3 = Cosmic.SelectedTheme.TextSecondary or Cosmic.SelectedTheme.TextColor
    end
    element:UpdateTheme()

    return element
end

-- Section
function Cosmic:_CreateSection(parentTab, sectionName)
    local config = { Name = sectionName, _IsInternal = true } -- Internal, no flag
    local template = parentTab.Window.ContentFrame.Template.SectionTitle
    local element = Cosmic:_CreateBaseElement(parentTab, config, "Section", template)
    local sectionFrame = element.Instance
    local titleLabel = sectionFrame:FindFirstChild("Title")

    titleLabel.Text = sectionName

    element.Set = function(self, newName)
        self.Instance.Title.Text = newName
        config.Name = newName
    end

    element.UpdateTheme = function(self)
        -- Sections usually don't have background/stroke, just text
        self.Instance.BackgroundTransparency = 1
        if self.Instance.BaseStroke then self.Instance.BaseStroke:Destroy() end
        if self.Instance:FindFirstChildWhichIsA("UICorner") then self.Instance:FindFirstChildWhichIsA("UICorner"):Destroy() end
        self.Instance.Title.TextColor3 = Cosmic.SelectedTheme.TextSecondary or Cosmic.SelectedTheme.TextColor
        self.Instance.Title.TextTransparency = 0.4 -- Dimmer like Rayfield
    end
    element:UpdateTheme()

    -- Add spacing before section if not the first element
    if element.Instance.LayoutOrder > 1 then
        local spacing = Instance.new("Frame")
        spacing.Name = "SectionSpacing"
        spacing.Size = UDim2.new(1, 0, 0, 5) -- Small vertical space
        spacing.BackgroundTransparency = 1
        spacing.LayoutOrder = element.Instance.LayoutOrder - 1 -- Place before section
        spacing.Parent = parentTab.ContentPage
        table.insert(element.Connections, spacing.Destroying:Connect(function() end)) -- Track for cleanup?
    end


    return element
end

-- Divider
function Cosmic:_CreateDivider(parentTab)
    local config = { Name = "Divider", _IsInternal = true }
    local template = parentTab.Window.ContentFrame.Template.Divider
    local element = Cosmic:_CreateBaseElement(parentTab, config, "Divider", template)
    local dividerFrame = element.Instance
    local line = dividerFrame:FindFirstChild("Divider")

    element.Set = function(self, visible) -- Allow hiding/showing
        self.Instance.Visible = visible == true
    end

    element.UpdateTheme = function(self)
        self.Instance.BackgroundTransparency = 1
        if self.Instance.BaseStroke then self.Instance.BaseStroke:Destroy() end
        if self.Instance:FindFirstChildWhichIsA("UICorner") then self.Instance:FindFirstChildWhichIsA("UICorner"):Destroy() end
        line.BackgroundColor3 = Cosmic.SelectedTheme.ElementStroke or Color3.fromRGB(50,50,50)
        line.BackgroundTransparency = 0.85 -- Subtle like Rayfield
    end
    element:UpdateTheme()

    return element
end

-- Color Picker (Structure based on Rayfield, simplified interaction)
function Cosmic:_CreateColorPicker(parentTab, config)
    config.Color = config.Color or Color3.new(1, 1, 1)
    local template = parentTab.Window.ContentFrame.Template.ColorPicker
    local element = Cosmic:_CreateBaseElement(parentTab, config, "ColorPicker", template)
    local cpFrame = element.Instance
    local titleLabel = cpFrame:FindFirstChild("Title")
    local display = cpFrame:FindFirstChild("Display") -- The small color preview square
    local interact = cpFrame:FindFirstChild("Interact")

    titleLabel.Text = config.Name
    element.Color = config.Color
    element.IsOpen = false

    ApplyThemeStyle(display, "ColorPickerDisplay")
    display.BackgroundColor3 = element.Color

    -- Placeholder: Full Color Picker UI (like Rayfield's) needs to be built here
    -- This would involve:
    -- 1. Creating the popup frame (Background, MainCP, ColorSlider, RGB inputs, Hex input)
    -- 2. Implementing the complex dragging logic for MainCP and ColorSlider
    -- 3. Handling HSV <-> RGB <-> Hex conversions and input validation
    -- 4. Animating the popup open/close

    local function TogglePicker(open)
        element.IsOpen = open
        if open then
            -- Show and animate the full picker UI
            print("Color Picker Opened (Not Implemented)")
            -- Example: TweenSize, TweenPosition, set transparencies
        else
            -- Hide and animate the full picker UI
            print("Color Picker Closed (Not Implemented)")
        end
    end

    table.insert(element.Connections, interact.MouseButton1Click:Connect(function()
        TogglePicker(not element.IsOpen)
    end))

    -- Set Method
    element.Set = function(self, color, silent)
        if type(color) ~= "Color3" then return end
        if self.Color == color then return end

        self.Color = color
        display.BackgroundColor3 = color
        -- Update internal picker UI state if open

        if not silent then
            local success, err = pcall(config.Callback or function(c) print("ColorPicker:", config.Name, c) end, self.Color)
            if not success then warn("CosmicUI: ColorPicker Callback Error (Set):", err) end
            if self.Config.Flag and self.Window.CEnabled then self.Window:SaveConfiguration() end
        end
    end

    -- Update Theme Method
    element.UpdateTheme = function(self)
        ApplyThemeStyle(self.Instance, "ColorPicker") -- Base frame
        ApplyThemeStyle(self.Instance.Display, "ColorPickerDisplay") -- Display square
        -- Update theme for the full picker UI elements when implemented
    end
    element:UpdateTheme()

    return element
end


--[[ Configuration Saving/Loading ]]--
function Cosmic:SaveConfiguration()
    if not self.CEnabled or not Cosmic.GlobalLoaded then return end
    if not writefile then return end -- Need file writing

    local data = {}
    for flagName, element in pairs(Cosmic.Flags) do
        -- Check if element belongs to this window instance
        if element and element.Window == self then
            local value
            if element.Type == "ColorPicker" then
                value = PackColor(element.Color)
            elseif element.Type == "Toggle" then
                value = element.CurrentValue
            elseif element.Type == "Slider" then
                value = element.CurrentValue
            elseif element.Type == "Input" then
                value = element.CurrentValue
            elseif element.Type == "Dropdown" then
                value = element.CurrentOption -- Save the table
            elseif element.Type == "Keybind" then
                value = element.CurrentKeybind
            end
            if value ~= nil then data[flagName] = value end
        end
    end

    local success, encodedData = pcall(HttpService.JSONEncode, HttpService, data)
    if success then
        local filePath = self.CFolderName .. "/" .. self.CFileName .. ".cosmic" -- Use .cosmic extension
        -- Ensure folder exists
        if not isfolder(self.CFolderName) then makefolder(self.CFolderName) end
        writefile(filePath, encodedData)
        print("CosmicUI: Configuration saved to", filePath)
    else
        warn("CosmicUI: Failed to encode configuration for saving:", encodedData)
    end
end

function Cosmic:LoadConfiguration()
    if not self.CEnabled then return end
    if not readfile or not isfile then return end -- Need file reading

    local filePath = self.CFolderName .. "/" .. self.CFileName .. ".cosmic"
    if not isfile(filePath) then
        print("CosmicUI: No configuration file found at", filePath)
        return
    end

    local fileContent = readfile(filePath)
    if not fileContent then
        warn("CosmicUI: Failed to read configuration file:", filePath)
        return
    end

    local success, decodedData = pcall(HttpService.JSONDecode, HttpService, fileContent)
    if not success or type(decodedData) ~= "table" then
        warn("CosmicUI: Failed to decode configuration file:", filePath, decodedData)
        return
    end

    local loadedCount = 0
    for flagName, savedValue in pairs(decodedData) do
        local element = Cosmic.Flags[flagName]
        -- Check if element exists and belongs to this window
        if element and element.Window == self and element.Set then
            local valueToSet = savedValue
            if element.Type == "ColorPicker" and type(savedValue) == "table" then
                valueToSet = UnpackColor(savedValue)
            end
            -- Add type checks/conversions if necessary for other types

            -- Use pcall to safely set the value silently
            local setSuccess, setError = pcall(element.Set, element, valueToSet, true) -- Pass true for silent
            if setSuccess then
                loadedCount = loadedCount + 1
            else
                 warn("CosmicUI: Error loading flag '" .. flagName .. "':", setError)
            end
        end
    end

    if loadedCount > 0 then
        self:Notify({Title = "Configuration Loaded", Content = loadedCount .. " settings loaded.", Duration = 4, Icon = Cosmic.SelectedTheme.Icons.Settings})
    end
    print("CosmicUI: Configuration loaded from", filePath)
end

--[[ Key System (Placeholder Logic) ]]--
function Cosmic:_CheckKeySystem()
    local keySettings = self.Config.KeySettings
    local fileName = keySettings.FileName or "CosmicKey"
    local keyFolder = "CosmicUI_Keys" -- Separate folder for keys

    -- 1. Check if key file exists and contains a valid key
    if isfolder and isfile and readfile then
        if not isfolder(keyFolder) then makefolder(keyFolder) end
        local filePath = keyFolder .. "/" .. fileName .. ".cosmicKey"
        if isfile(filePath) then
            local savedKey = readfile(filePath)
            if savedKey and self:_ValidateKey(savedKey) then
                print("CosmicUI: Valid key found in file.")
                return true -- Key is valid
            end
        end
    end

    -- 2. If no valid saved key, show Key UI (Not Implemented Here)
    --    This would involve creating a separate ScreenGui, handling input,
    --    validating against keySettings.Key (fetching if needed),
    --    saving the key if valid and keySettings.SaveKey is true,
    --    handling attempts, and kicking the player.
    warn("CosmicUI: Key System UI not implemented. Assuming key check fails.")
    self:Notify({Title = "Key Required", Content = "This script requires a key (Key System UI not implemented).", Duration = 10, Icon = Cosmic.SelectedTheme.Error})

    return false -- Assume key check fails if UI isn't shown/validated
end

function Cosmic:_ValidateKey(inputKey)
    local keySettings = self.Config.KeySettings
    local validKeys = keySettings.Key or {}
    if type(validKeys) == "string" then validKeys = {validKeys} end -- Ensure table

    -- Fetch keys if needed (Simplified - needs proper timeout/error handling)
    if keySettings.GrabKeyFromSite then
        local fetchedKeys = {}
        for _, keyUrl in ipairs(validKeys) do
            local success, content = pcall(game.HttpGet, game, keyUrl, true)
            if success and content then
                -- Basic cleaning, adjust as needed
                local cleanedKey = content:match("^%s*(.-)%s*$")
                if cleanedKey and #cleanedKey > 0 then table.insert(fetchedKeys, cleanedKey) end
            else
                warn("CosmicUI: Failed to fetch key from", keyUrl)
            end
        end
        validKeys = fetchedKeys
    end

    -- Check input against valid keys
    for _, validKey in ipairs(validKeys) do
        if inputKey == validKey then return true end
    end

    return false
end

--[[ Discord Invite (Placeholder Logic) ]]--
function Cosmic:_HandleDiscordInvite()
     local discordSettings = self.Config.Discord
     local inviteCode = discordSettings.Invite
     local remember = discordSettings.RememberJoins
     local inviteFolder = "CosmicUI_Invites"
     local filePath = inviteFolder .. "/" .. inviteCode .. ".invited"

     if not request then return end -- Need request function

     -- Check if already remembered
     if remember and isfolder and isfile and readfile then
         if not isfolder(inviteFolder) then makefolder(inviteFolder) end
         if isfile(filePath) then
             print("CosmicUI: Discord invite already remembered:", inviteCode)
             return
         end
     end

     -- Attempt to send invite request
     local success, result = pcall(request, {
         Url = 'http://127.0.0.1:6463/rpc?v=1',
         Method = 'POST',
         Headers = { ['Content-Type'] = 'application/json', Origin = 'https://discord.com' },
         Body = HttpService:JSONEncode({
             cmd = 'INVITE_BROWSER',
             nonce = HttpService:GenerateGUID(false),
             args = { code = inviteCode }
         })
     })

     if success then
         print("CosmicUI: Discord invite request sent for:", inviteCode)
         -- Remember if needed
         if remember and writefile then
             if not isfolder(inviteFolder) then makefolder(inviteFolder) end
             writefile(filePath, "Invited")
         end
     else
         warn("CosmicUI: Failed to send Discord invite request:", result)
     end
end

--[[ Settings Tab Content (Placeholder) ]]--
function Cosmic:_CreateSettingsContent(settingsTab)
    -- Placeholder: Add elements to the settingsTab based on internal settings
    -- Similar to Rayfield's createSettings function
    settingsTab:CreateLabel({ Text = "Cosmic UI Settings (Placeholder)" })
    settingsTab:CreateToggle({ Name = "Example Setting", CurrentValue = true, Callback = function(v) print("Setting toggled:", v) end})
    -- Add controls for theme selection, keybinds, etc.
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
