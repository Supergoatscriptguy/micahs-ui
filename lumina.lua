--[[
    LuminaUI Interface Library v2.1 (Refactored + Features)
    A modern, responsive UI library for Roblox scripting

    Goals:
    - Inspired by top-tier libraries like Rayfield
    - Enhanced performance and stability
    - Fluent and intuitive API
    - Rich feature set (ColorPicker, Keybinds, etc.)
    - Robust theme management
    - Improved animations and visual feedback
]]

-- Core Library Table
local LuminaUI = {
    Flags = {},
    Version = "2.1.0-dev",
    Theme = { -- Keep original theme structure
        Default = {
            Name = "Default", -- Added Name for easier identification
            TextColor = Color3.fromRGB(240, 240, 240),
            SubTextColor = Color3.fromRGB(200, 200, 200),
            Background = Color3.fromRGB(25, 25, 25),
            Topbar = Color3.fromRGB(34, 34, 34),
            Shadow = Color3.fromRGB(15, 15, 15), -- Darker shadow
            ElementBackground = Color3.fromRGB(35, 35, 35),
            ElementBackgroundHover = Color3.fromRGB(45, 45, 45), -- More noticeable hover
            ElementBackgroundActive = Color3.fromRGB(55, 55, 55), -- Active/pressed state
            ElementStroke = Color3.fromRGB(55, 55, 55), -- Slightly adjusted stroke
            TabBackground = Color3.fromRGB(30, 30, 30), -- Darker inactive tab
            TabBackgroundSelected = Color3.fromRGB(50, 50, 50), -- Selected tab background
            TabTextColor = Color3.fromRGB(180, 180, 180), -- Dimmer inactive text
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255), -- Brighter selected text
            ToggleEnabled = Color3.fromRGB(0, 146, 214),
            ToggleDisabled = Color3.fromRGB(60, 60, 60), -- Darker disabled toggle
            SliderBackground = Color3.fromRGB(50, 50, 50), -- Consistent background
            SliderProgress = Color3.fromRGB(0, 146, 214), -- Use accent color
            NotificationBackground = Color3.fromRGB(30, 30, 30),
            InputBackground = Color3.fromRGB(40, 40, 40),
            InputStroke = Color3.fromRGB(65, 65, 65),
            InputPlaceholder = Color3.fromRGB(160, 160, 160),
            DropdownSelected = Color3.fromRGB(50, 50, 50),
            DropdownUnselected = Color3.fromRGB(40, 40, 40),
            ColorPickerBackground = Color3.fromRGB(30, 30, 30),
            SectionBackground = Color3.fromRGB(30, 30, 30),
            ProgressBarBackground = Color3.fromRGB(40, 40, 40),
            ProgressBarFill = Color3.fromRGB(0, 146, 214), -- Use accent color
            CheckboxChecked = Color3.fromRGB(0, 146, 214),
            CheckboxUnchecked = Color3.fromRGB(100, 100, 100),
            ScrollBarBackground = Color3.fromRGB(45, 45, 45),
            ScrollBarForeground = Color3.fromRGB(70, 70, 70),
            AccentColor = Color3.fromRGB(0, 146, 214), -- Added Accent Color
            ErrorColor = Color3.fromRGB(231, 76, 60), -- Added Error Color
            SuccessColor = Color3.fromRGB(46, 204, 113) -- Added Success Color
        },
        Dark = {
            Name = "Dark",
            TextColor = Color3.fromRGB(220, 220, 220),
            SubTextColor = Color3.fromRGB(180, 180, 180),
            Background = Color3.fromRGB(15, 15, 15),
            Topbar = Color3.fromRGB(24, 24, 24),
            Shadow = Color3.fromRGB(10, 10, 10),
            ElementBackground = Color3.fromRGB(25, 25, 25),
            ElementBackgroundHover = Color3.fromRGB(30, 30, 30),
            ElementBackgroundActive = Color3.fromRGB(40, 40, 40), -- Added Active state
            ElementStroke = Color3.fromRGB(40, 40, 40),
            TabBackground = Color3.fromRGB(20, 20, 20), -- Adjusted
            TabBackgroundSelected = Color3.fromRGB(35, 35, 35), -- Adjusted
            TabTextColor = Color3.fromRGB(180, 180, 180), -- Adjusted
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255), -- Adjusted
            ToggleEnabled = Color3.fromRGB(0, 126, 194),
            ToggleDisabled = Color3.fromRGB(50, 50, 50), -- Adjusted
            SliderBackground = Color3.fromRGB(40, 40, 40), -- Adjusted
            SliderProgress = Color3.fromRGB(0, 126, 194), -- Use accent
            NotificationBackground = Color3.fromRGB(20, 20, 20), -- Adjusted
            InputBackground = Color3.fromRGB(30, 30, 30), -- Adjusted
            InputStroke = Color3.fromRGB(55, 55, 55),
            InputPlaceholder = Color3.fromRGB(140, 140, 140),
            DropdownSelected = Color3.fromRGB(35, 35, 35), -- Adjusted
            DropdownUnselected = Color3.fromRGB(30, 30, 30), -- Adjusted
            ColorPickerBackground = Color3.fromRGB(20, 20, 20),
            SectionBackground = Color3.fromRGB(20, 20, 20),
            ProgressBarBackground = Color3.fromRGB(30, 30, 30),
            ProgressBarFill = Color3.fromRGB(0, 126, 194), -- Use accent
            CheckboxChecked = Color3.fromRGB(0, 126, 194),
            CheckboxUnchecked = Color3.fromRGB(80, 80, 80),
            ScrollBarBackground = Color3.fromRGB(25, 25, 25),
            ScrollBarForeground = Color3.fromRGB(50, 50, 50),
            AccentColor = Color3.fromRGB(0, 126, 194),
            ErrorColor = Color3.fromRGB(231, 76, 60),
            SuccessColor = Color3.fromRGB(46, 204, 113)
        },
        Ocean = {
            Name = "Ocean",
            TextColor = Color3.fromRGB(230, 240, 240),
            SubTextColor = Color3.fromRGB(190, 210, 210),
            Background = Color3.fromRGB(20, 30, 40),
            Topbar = Color3.fromRGB(25, 40, 50),
            Shadow = Color3.fromRGB(15, 20, 25),
            ElementBackground = Color3.fromRGB(30, 40, 50),
            ElementBackgroundHover = Color3.fromRGB(35, 45, 55),
            ElementBackgroundActive = Color3.fromRGB(40, 50, 60), -- Added Active state
            ElementStroke = Color3.fromRGB(45, 55, 65),
            TabBackground = Color3.fromRGB(25, 35, 45), -- Adjusted
            TabBackgroundSelected = Color3.fromRGB(40, 55, 65), -- Adjusted
            TabTextColor = Color3.fromRGB(190, 210, 210), -- Adjusted
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255), -- Adjusted
            ToggleEnabled = Color3.fromRGB(0, 140, 180), -- Use Accent
            ToggleDisabled = Color3.fromRGB(50, 60, 70), -- Adjusted
            SliderBackground = Color3.fromRGB(40, 50, 60), -- Adjusted
            SliderProgress = Color3.fromRGB(0, 140, 180), -- Use Accent
            NotificationBackground = Color3.fromRGB(25, 35, 45),
            InputBackground = Color3.fromRGB(35, 45, 55), -- Adjusted
            InputStroke = Color3.fromRGB(50, 60, 70),
            InputPlaceholder = Color3.fromRGB(150, 170, 180),
            DropdownSelected = Color3.fromRGB(40, 55, 65), -- Adjusted
            DropdownUnselected = Color3.fromRGB(35, 45, 55), -- Adjusted
            ColorPickerBackground = Color3.fromRGB(25, 35, 45),
            SectionBackground = Color3.fromRGB(25, 35, 45),
            ProgressBarBackground = Color3.fromRGB(35, 45, 55),
            ProgressBarFill = Color3.fromRGB(0, 140, 180), -- Use Accent
            CheckboxChecked = Color3.fromRGB(0, 140, 180), -- Use Accent
            CheckboxUnchecked = Color3.fromRGB(70, 90, 100),
            ScrollBarBackground = Color3.fromRGB(30, 40, 50),
            ScrollBarForeground = Color3.fromRGB(45, 65, 80),
            AccentColor = Color3.fromRGB(0, 140, 180),
            ErrorColor = Color3.fromRGB(231, 76, 60),
            SuccessColor = Color3.fromRGB(46, 204, 113)
        },
        Purple = {
            Name = "Purple",
            TextColor = Color3.fromRGB(230, 230, 240),
            SubTextColor = Color3.fromRGB(200, 190, 220),
            Background = Color3.fromRGB(30, 25, 40),
            Topbar = Color3.fromRGB(40, 35, 50),
            Shadow = Color3.fromRGB(20, 15, 30),
            ElementBackground = Color3.fromRGB(40, 35, 50),
            ElementBackgroundHover = Color3.fromRGB(50, 45, 60),
            ElementBackgroundActive = Color3.fromRGB(60, 55, 70), -- Added Active state
            ElementStroke = Color3.fromRGB(60, 55, 70),
            TabBackground = Color3.fromRGB(35, 30, 45), -- Adjusted
            TabBackgroundSelected = Color3.fromRGB(55, 50, 65), -- Adjusted
            TabTextColor = Color3.fromRGB(200, 190, 220), -- Adjusted
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255), -- Adjusted
            ToggleEnabled = Color3.fromRGB(130, 80, 200), -- Use Accent
            ToggleDisabled = Color3.fromRGB(70, 65, 80), -- Adjusted
            SliderBackground = Color3.fromRGB(50, 45, 60), -- Adjusted
            SliderProgress = Color3.fromRGB(130, 80, 200), -- Use Accent
            NotificationBackground = Color3.fromRGB(35, 30, 45),
            InputBackground = Color3.fromRGB(45, 40, 55), -- Adjusted
            InputStroke = Color3.fromRGB(60, 55, 70),
            InputPlaceholder = Color3.fromRGB(160, 150, 180),
            DropdownSelected = Color3.fromRGB(55, 50, 65), -- Adjusted
            DropdownUnselected = Color3.fromRGB(45, 40, 55), -- Adjusted
            ColorPickerBackground = Color3.fromRGB(35, 30, 45),
            SectionBackground = Color3.fromRGB(35, 30, 45),
            ProgressBarBackground = Color3.fromRGB(45, 40, 55),
            ProgressBarFill = Color3.fromRGB(130, 80, 200), -- Use Accent
            CheckboxChecked = Color3.fromRGB(130, 80, 200), -- Use Accent
            CheckboxUnchecked = Color3.fromRGB(90, 80, 100),
            ScrollBarBackground = Color3.fromRGB(40, 35, 50),
            ScrollBarForeground = Color3.fromRGB(65, 55, 75),
            AccentColor = Color3.fromRGB(130, 80, 200),
            ErrorColor = Color3.fromRGB(231, 76, 60),
            SuccessColor = Color3.fromRGB(46, 204, 113)
        }
    },
    _Connections = {}, -- Store connections for cleanup
    _Instances = {}, -- Store references to created instances for theme updates
    _Keybinds = {}, -- Store registered keybinds
    _KeybindListener = nil -- Connection for keybind input listener
}

-- Services (Original local style)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local VRService = game:GetService("VRService") -- For VR check

-- Environment Checks (for exploit context awareness)
local is_synapse = syn and syn.protect_gui
local is_scriptware = getexecutorname and getexecutorname() == "ScriptWare"
local is_fluxus = fluxus -- Basic check, might need refinement
local get_hui = gethui or (CoreGui and CoreGui.FindFirstChild("RobloxGui")) -- Fallback for standard Roblox environment

-- Variables (Original local style)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local SelectedTheme = LuminaUI.Theme.Default -- Default theme initially
local ConfigFolder = "LuminaUI_Config" -- Renamed to avoid conflicts
local ConfigExtension = ".json" -- Use JSON extension
local Library -- Main ScreenGui instance
local TooltipInstance
local DraggingInstance
local DragInput, DragStart, StartPos
local Utility = {} -- Table for utility functions

-- Instance pool (Original separate table)
local InstancePool = {
    Instances = {},
    MaxPoolSize = 100 -- Increased pool size slightly
}

-- Track instances created by the library for theme updates
function Utility.trackInstance(instance, elementType, updateFunc)
    if not instance then return end
    local id = instance:GetAttribute("LuminaID") or HttpService:GenerateGUID(false)
    instance:SetAttribute("LuminaID", id)
    instance:SetAttribute("LuminaType", elementType)
    LuminaUI._Instances[id] = {
        Instance = instance,
        Type = elementType,
        UpdateTheme = updateFunc -- Function to call when theme changes
    }
end

-- Untrack instance when destroyed/released
function Utility.untrackInstance(instance)
    if not instance then return end
    local id = instance:GetAttribute("LuminaID")
    if id and LuminaUI._Instances[id] then
        LuminaUI._Instances[id] = nil
    end
end

function InstancePool:Get(className)
    if not self.Instances[className] then
        self.Instances[className] = {}
    end

    local pool = self.Instances[className]
    if #pool > 0 then
        local instance = table.remove(pool)
        instance.Parent = nil -- Ensure parent is nil when retrieved
        pcall(function() instance.Visible = true end) -- Reset visibility
        return instance
    else
        return Instance.new(className)
    end
end

function InstancePool:Release(instance)
    if not instance or not instance:IsA("Instance") or instance.Parent ~= nil then return end -- Don't pool if still parented
    local className = instance.ClassName

    if not self.Instances[className] then
        self.Instances[className] = {}
    end

    -- Untrack before potentially destroying or pooling
    Utility.untrackInstance(instance)

    -- Basic reset (more specific resets can be done where needed)
    instance.Name = className -- Reset name
    pcall(function() instance.Visible = true end)
    pcall(function() instance.BackgroundTransparency = 1 end)
    pcall(function() instance.ImageTransparency = 1 end)
    pcall(function() instance.TextTransparency = 1 end)
    pcall(function() instance.Position = UDim2.new(0, 0, 0, 0) end)
    pcall(function() instance.Size = UDim2.new(0, 0, 0, 0) end)
    pcall(function() instance.Text = "" end)
    pcall(function() instance.Image = "" end)
    pcall(function() instance.ClearAllChildren() end) -- Clear children more aggressively

    -- Disconnect connections associated with the instance before pooling
    if LuminaUI._Connections[instance] then
        for _, connection in ipairs(LuminaUI._Connections[instance]) do
            connection:Disconnect()
        end
        LuminaUI._Connections[instance] = nil
    end

    -- Add to pool if not full
    local pool = self.Instances[className]
    if #pool < self.MaxPoolSize then
        table.insert(pool, instance)
    else
        -- If pool is full, destroy the instance instead
        instance:Destroy()
    end
end

-- Utility functions (Moved into Utility table)
function Utility.createInstance(className, properties, elementType, updateThemeFunc)
    local instance = InstancePool:Get(className)
    for prop, value in pairs(properties or {}) do
        -- Use pcall for properties that might not exist on all instances
        pcall(function() instance[prop] = value end)
    end
    -- Track instance if element type is provided
    if elementType then
        Utility.trackInstance(instance, elementType, updateThemeFunc)
    end
    return instance
end

-- Enhanced destroy function to use the pool
function Utility.destroyInstance(instance)
    if not instance then return end
    -- Recursively destroy children first
    for _, child in ipairs(instance:GetChildren()) do
        Utility.destroyInstance(child)
    end
    -- Release the instance itself to the pool (or destroy if pool is full/not applicable)
    InstancePool:Release(instance) -- This now handles untracking
end

-- Debounce function remains the same
function Utility.debounce(func, waitTime)
    local lastCall = 0
    return function(...)
        local now = tick()
        if now - lastCall >= waitTime then
            lastCall = now
            return func(...)
        end
    end
end

-- Store connections for later cleanup
function Utility.storeConnection(instance, connection)
    if not instance then return end -- Added check
    if not LuminaUI._Connections[instance] then
        LuminaUI._Connections[instance] = {}
    end
    table.insert(LuminaUI._Connections[instance], connection)
end

-- Wrapper for Connect that stores the connection
function Utility.Connect(signal, func)
    if not signal then warn("LuminaUI: Attempted to connect to a nil signal.") return end -- Added check
    local connection = signal:Connect(func)
    if signal.Instance then -- Store connection associated with the instance if possible
        Utility.storeConnection(signal.Instance, connection)
    end
    return connection
end


function Utility.createStroke(instance, color, thickness, transparency)
    local stroke = Utility.createInstance("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, -- Usually preferred
        Color = color or SelectedTheme.ElementStroke,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        LineJoinMode = Enum.LineJoinMode.Round, -- Smoother corners
        Parent = instance
    })
    -- No need to track stroke directly, parent update should handle it
    return stroke
end

function Utility.createCorner(instance, radius)
    local corner = Utility.createInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = instance
    })
    -- No need to track corner directly
    return corner
end

function Utility.loadIcon(id)
    if type(id) == "number" then
        return "rbxassetid://" .. id
    elseif type(id) == "string" and not id:match("^rbx") then
         -- Assume it's a local asset path or alias if not starting with rbx
         return id -- Or handle local asset loading if needed
    else
        return id -- Already formatted or invalid
    end
end

function Utility.getTextBounds(text, font, size, maxWidth)
    local sizeVector = Vector2.new(maxWidth or math.huge, math.huge)
    local success, result = pcall(TextService.GetTextSize, TextService, text, size, font, sizeVector)
    if success then
        return result
    else
        -- Fallback or default estimation if GetTextSize fails
        warn("LuminaUI: Failed to get text bounds for:", text, result)
        return Vector2.new(string.len(text) * (size / 2), size) -- Rough estimate
    end
end

-- FormatNumber remains the same
function Utility.formatNumber(value, decimals)
    decimals = decimals or 1
    local formatStr = "%." .. decimals .. "f"
    if value >= 1000000 then
        return string.format(formatStr .. "m", value / 1000000)
    elseif value >= 1000 then
        return string.format(formatStr .. "k", value / 1000)
    else
        -- Show decimals only if not an integer or if decimals > 0
        if value % 1 ~= 0 or decimals > 0 then
             return string.format(formatStr, value)
        else
             return tostring(math.floor(value))
        end
    end
end

-- Color manipulation functions remain the same
function Utility.darker(color, factor)
    factor = 1 - (factor or 0.2)
    return Color3.new(
        math.clamp(color.R * factor, 0, 1),
        math.clamp(color.G * factor, 0, 1),
        math.clamp(color.B * factor, 0, 1)
    )
end

function Utility.lighter(color, factor)
    factor = factor or 0.2
    return Color3.new(
        math.clamp(color.R + factor, 0, 1),
        math.clamp(color.G + factor, 0, 1),
        math.clamp(color.B + factor, 0, 1)
    )
end

-- Tooltip functions (using Utility functions)
function Utility.createTooltip()
    if TooltipInstance and TooltipInstance.Parent then return TooltipInstance end -- Check if still valid

    -- Destroy old one if it exists but is invalid
    if TooltipInstance then
        Utility.destroyInstance(TooltipInstance)
        TooltipInstance = nil
    end

    local tooltipParent = Library or get_hui() -- Ensure a valid parent

    local updateFunc = function(instance)
        instance.BackgroundColor3 = SelectedTheme.NotificationBackground
        local stroke = instance:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = SelectedTheme.ElementStroke end
        local text = instance:FindFirstChild("Text")
        if text then text.TextColor3 = SelectedTheme.TextColor end
    end

    TooltipInstance = Utility.createInstance("Frame", {
        Name = "LuminaTooltip",
        BackgroundColor3 = SelectedTheme.NotificationBackground,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 150, 0, 30), -- Initial size, will resize
        Position = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ZIndex = 10000, -- Ensure tooltip is on top
        Parent = tooltipParent
    }, "Tooltip", updateFunc) -- Track tooltip

    Utility.createCorner(TooltipInstance, 4)
    Utility.createStroke(TooltipInstance, SelectedTheme.ElementStroke, 1)

    local TooltipText = Utility.createInstance("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, -6), -- Padding
        Position = UDim2.new(0, 5, 0, 3),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = SelectedTheme.TextColor,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 10001,
        Parent = TooltipInstance
    })

    local TooltipPadding = Utility.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3),
        Parent = TooltipText -- Apply padding to text label itself for better wrapping calc
    })

    return TooltipInstance
end

-- showTooltip and hideTooltip remain largely the same, just ensure createTooltip is called
function Utility.showTooltip(text, yOffset)
    if not text or text == "" then return end -- Don't show empty tooltips

    local Tooltip = Utility.createTooltip() -- Ensures it's created and tracked
    if not Tooltip or not Tooltip.Parent then return end -- Ensure tooltip exists

    local TooltipText = Tooltip:FindFirstChild("Text")
    if not TooltipText then return end

    TooltipText.Text = text

    -- Calculate size based on text content
    local textBounds = Utility.getTextBounds(text, TooltipText.Font, TooltipText.TextSize, 280) -- Max width 280
    local tooltipWidth = math.min(textBounds.X + 16, 300) -- Add padding, max width 300
    local tooltipHeight = textBounds.Y + 10 -- Add padding

    Tooltip.Size = UDim2.new(0, tooltipWidth, 0, tooltipHeight)

    yOffset = yOffset or 15 -- Default offset below cursor

    local updatePosition = function()
        if not Tooltip or not Tooltip.Parent or not Tooltip.Visible then return end -- Check validity inside loop

        local mousePos = UserInputService:GetMouseLocation()
        local viewportSize = workspace.CurrentCamera.ViewportSize

        local newX = mousePos.X + 10
        local newY = mousePos.Y + yOffset

        -- Adjust if off-screen horizontally
        if newX + Tooltip.AbsoluteSize.X > viewportSize.X then
            newX = mousePos.X - Tooltip.AbsoluteSize.X - 10
        end

        -- Adjust if off-screen vertically
        if newY + Tooltip.AbsoluteSize.Y > viewportSize.Y then
            newY = mousePos.Y - Tooltip.AbsoluteSize.Y - 10
        end

        -- Clamp position to be within viewport bounds
        newX = math.clamp(newX, 0, viewportSize.X - Tooltip.AbsoluteSize.X)
        newY = math.clamp(newY, 0, viewportSize.Y - Tooltip.AbsoluteSize.Y)

        Tooltip.Position = UDim2.new(0, newX, 0, newY)
    end

    updatePosition() -- Initial position update
    Tooltip.Visible = true

    -- Use a single RenderStepped connection for tooltip updates
    if not LuminaUI._TooltipUpdateConnection or not LuminaUI._TooltipUpdateConnection.Connected then
        LuminaUI._TooltipUpdateConnection = Utility.Connect(RunService.RenderStepped, function()
            if TooltipInstance and TooltipInstance.Visible then
                updatePosition()
            else
                -- Disconnect if tooltip becomes invisible or destroyed
                if LuminaUI._TooltipUpdateConnection then
                    LuminaUI._TooltipUpdateConnection:Disconnect()
                    LuminaUI._TooltipUpdateConnection = nil
                end
            end
        end)
    end
end

function Utility.hideTooltip()
    if TooltipInstance then
        TooltipInstance.Visible = false
        -- Don't destroy, just hide. It will be reused.
    end
    -- Disconnect the update loop if it exists
    if LuminaUI._TooltipUpdateConnection and LuminaUI._TooltipUpdateConnection.Connected then
        LuminaUI._TooltipUpdateConnection:Disconnect()
        LuminaUI._TooltipUpdateConnection = nil
    end
end

-- Draggable function (using Utility functions) - Remains the same
function Utility.makeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false

    Utility.Connect(handle.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if DraggingInstance then return end -- Prevent dragging multiple things

            dragging = true
            DraggingInstance = frame
            DragStart = input.Position
            StartPos = frame.Position

            -- Bring frame to front (optional, can cause issues with overlapping UI)
            -- frame.ZIndex = frame.ZIndex + 1

            local changedConnection
            changedConnection = Utility.Connect(input.Changed, function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    DraggingInstance = nil
                    -- Reset ZIndex if changed
                    -- frame.ZIndex = frame.ZIndex - 1
                    if changedConnection then changedConnection:Disconnect() end -- Disconnect self
                    if LuminaUI._DragMoveConnection then LuminaUI._DragMoveConnection:Disconnect() end -- Disconnect move listener
                end
            end)

            -- Create move connection only when dragging starts
            if LuminaUI._DragMoveConnection then LuminaUI._DragMoveConnection:Disconnect() end -- Disconnect previous if any
            LuminaUI._DragMoveConnection = Utility.Connect(UserInputService.InputChanged, function(moveInput)
                 if dragging and DraggingInstance == frame and (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) then
                    local delta = moveInput.Position - DragStart
                    DraggingInstance.Position = UDim2.new(
                        StartPos.X.Scale,
                        StartPos.X.Offset + delta.X,
                        StartPos.Y.Scale,
                        StartPos.Y.Offset + delta.Y
                    )
                end
            end)
        end
    end)
end

-- Configuration functions (using Utility functions and HttpService) - Added Color3 saving
function Utility.saveConfig(windowInstance, settings)
    if not settings.ConfigurationSaving or not settings.ConfigurationSaving.Enabled then return end
    if not writefile then warn("LuminaUI: writefile is not available. Cannot save config.") return end

    local configName = settings.ConfigurationSaving.FileName or settings.Name or "Lumina_Config"
    local filePath = ConfigFolder.."/"..configName..ConfigExtension

    local data = {
        Window = {
            Position = {
                XScale = windowInstance.Position.X.Scale,
                XOffset = windowInstance.Position.X.Offset,
                YScale = windowInstance.Position.Y.Scale,
                YOffset = windowInstance.Position.Y.Offset
            },
            Theme = settings.Theme -- Save the currently selected theme name
        },
        Elements = {}
    }

    for flag, elementData in pairs(LuminaUI.Flags) do
        local value = elementData.Value
        local valueType = type(value)
        -- Only save if value is serializable (basic types + Color3)
        if valueType == "string" or valueType == "number" or valueType == "boolean" then
             data.Elements[flag] = {
                Type = elementData.Type,
                Value = value
            }
        elseif typeof(value) == "Color3" then
             data.Elements[flag] = {
                Type = elementData.Type,
                Value = { R = value.R, G = value.G, B = value.B } -- Save Color3 components
            }
        end
    end

    -- Ensure folder exists
    if not isfolder(ConfigFolder) then
        local success, err = pcall(makefolder, ConfigFolder)
        if not success then
            warn("LuminaUI: Failed to create config folder:", err)
            return
        end
    end

    local success, encodedData = pcall(HttpService.JSONEncode, HttpService, data)
    if success then
        local writeSuccess, writeErr = pcall(writefile, filePath, encodedData)
        if not writeSuccess then
            warn("LuminaUI: Failed to write config file:", writeErr)
        end
    else
        warn("LuminaUI: Failed to encode config data:", encodedData) -- encodedData is error message here
    end
end

function Utility.loadConfig(settings)
    local loadedData = { Window = {}, Elements = {} } -- Default structure
    if not settings.ConfigurationSaving or not settings.ConfigurationSaving.Enabled then return loadedData end
    if not isfile or not readfile then warn("LuminaUI: isfile/readfile not available. Cannot load config.") return loadedData end

    local configName = settings.ConfigurationSaving.FileName or settings.Name or "Lumina_Config"
    local filePath = ConfigFolder.."/"..configName..ConfigExtension

    if isfile(filePath) then
        local success, fileContent = pcall(readfile, filePath)
        if success and fileContent then
            local decodeSuccess, decodedData = pcall(HttpService.JSONDecode, HttpService, fileContent)
            if decodeSuccess and type(decodedData) == "table" then
                -- Validate structure before assigning
                if decodedData.Window and type(decodedData.Window.Position) == "table" then
                    loadedData.Window.Position = UDim2.new(
                        decodedData.Window.Position.XScale or 0.5,
                        decodedData.Window.Position.XOffset or 0,
                        decodedData.Window.Position.YScale or 0.5,
                        decodedData.Window.Position.YOffset or 0
                    )
                end
                 if decodedData.Window and type(decodedData.Window.Theme) == "string" and LuminaUI.Theme[decodedData.Window.Theme] then
                    loadedData.Window.Theme = decodedData.Window.Theme
                end
                if decodedData.Elements and type(decodedData.Elements) == "table" then
                    -- Process loaded elements, converting Color3 back
                    for flag, elementData in pairs(decodedData.Elements) do
                        if type(elementData.Value) == "table" and elementData.Value.R ~= nil and elementData.Value.G ~= nil and elementData.Value.B ~= nil then
                            -- Attempt to reconstruct Color3
                            loadedData.Elements[flag] = {
                                Type = elementData.Type,
                                Value = Color3.new(elementData.Value.R, elementData.Value.G, elementData.Value.B)
                            }
                        else
                            -- Keep other types as is
                            loadedData.Elements[flag] = elementData
                        end
                    end
                end
            else
                warn("LuminaUI: Failed to decode or invalid config data in:", filePath, decodedData)
            end
        else
            warn("LuminaUI: Failed to read config file:", filePath, fileContent)
        end
    end

    return loadedData
end

-- Custom scrollbar function (Refactored with Utility) - Added theme update logic
function Utility.applyCustomScrollbar(scrollFrame, thickness)
    thickness = thickness or 6 -- Slightly thicker default
    local scrollbarName = "LuminaCustomScrollbar"

    -- Remove existing custom scrollbar if present
    local existingScrollbar = scrollFrame:FindFirstChild(scrollbarName)
    if existingScrollbar then
        Utility.destroyInstance(existingScrollbar)
    end

    -- Hide default scrollbar
    scrollFrame.ScrollBarThickness = 0
    scrollFrame.ScrollingEnabled = true -- Ensure scrolling is enabled

    -- Theme update function for the scrollbar track
    local updateTrackTheme = function(instance)
        instance.BackgroundColor3 = SelectedTheme.ScrollBarBackground
        local thumb = instance:FindFirstChild("ScrollThumb")
        if thumb then
            thumb.BackgroundColor3 = SelectedTheme.ScrollBarForeground
        end
    end

    -- Create custom scrollbar track
    local scrollbar = Utility.createInstance("Frame", {
        Name = scrollbarName,
        Size = UDim2.new(0, thickness, 1, 0),
        Position = UDim2.new(1, -thickness, 0, 0),
        AnchorPoint = Vector2.new(0, 0), -- Anchor to top-right inside
        BackgroundColor3 = SelectedTheme.ScrollBarBackground,
        BackgroundTransparency = 0.3, -- Slightly less transparent
        BorderSizePixel = 0,
        ZIndex = scrollFrame.ZIndex + 10, -- Ensure above content
        Parent = scrollFrame
    }, "ScrollbarTrack", updateTrackTheme) -- Track the scrollbar track
    Utility.createCorner(scrollbar, thickness / 2)

    -- Create custom scrollbar thumb
    local scrollThumb = Utility.createInstance("Frame", {
        Name = "ScrollThumb",
        Size = UDim2.new(1, 0, 0.1, 0), -- Min size 10%
        BackgroundColor3 = SelectedTheme.ScrollBarForeground,
        BorderSizePixel = 0,
        ZIndex = scrollbar.ZIndex + 1,
        Parent = scrollbar
    })
    Utility.createCorner(scrollThumb, thickness / 2)

    -- Update scrollbar position and size function
    local function updateScrollbar()
        -- Check if instances are still valid
        if not scrollFrame or not scrollFrame.Parent or not scrollbar or not scrollbar.Parent or not scrollThumb or not scrollThumb.Parent then
             -- Clean up connections if instances are gone
             if LuminaUI._Connections[scrollFrame] then
                 for _, conn in ipairs(LuminaUI._Connections[scrollFrame]) do conn:Disconnect() end
                 LuminaUI._Connections[scrollFrame] = nil
             end
             return
        end

        local canvasSizeY = scrollFrame.CanvasSize.Y.Offset
        local frameSizeY = scrollFrame.AbsoluteSize.Y

        if canvasSizeY <= frameSizeY or frameSizeY <= 0 then
            scrollbar.Visible = false
            return
        else
            scrollbar.Visible = true
        end

        local scrollableDist = canvasSizeY - frameSizeY
        local scrollPercent = scrollableDist > 0 and math.clamp(scrollFrame.CanvasPosition.Y / scrollableDist, 0, 1) or 0 -- Avoid division by zero

        -- Calculate thumb size relative to the visible content ratio
        local thumbSizeScale = canvasSizeY > 0 and math.clamp(frameSizeY / canvasSizeY, 0.05, 1) or 1 -- Min 5% size, avoid division by zero
        local thumbHeight = frameSizeY * thumbSizeScale

        -- Calculate thumb position based on scroll percentage and available track space
        local trackHeight = frameSizeY
        local thumbY = scrollPercent * math.max(0, trackHeight - thumbHeight) -- Ensure non-negative position

        scrollThumb.Size = UDim2.new(1, 0, 0, thumbHeight) -- Use offset for precise height
        scrollThumb.Position = UDim2.new(0, 0, 0, thumbY) -- Use offset for precise position
    end

    -- Connect update events using Utility.Connect for cleanup
    Utility.Connect(scrollFrame:GetPropertyChangedSignal("CanvasPosition"), updateScrollbar)
    Utility.Connect(scrollFrame:GetPropertyChangedSignal("AbsoluteSize"), updateScrollbar)
    Utility.Connect(scrollFrame:GetPropertyChangedSignal("CanvasSize"), updateScrollbar)
    Utility.Connect(scrollFrame.ChildAdded, updateScrollbar) -- Update when content changes
    Utility.Connect(scrollFrame.ChildRemoved, updateScrollbar) -- Update when content changes

    -- Make thumb draggable
    local isDragging = false
    local dragStartMouseY, dragStartCanvasY

    Utility.Connect(scrollThumb.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStartMouseY = input.Position.Y
            dragStartCanvasY = scrollFrame.CanvasPosition.Y
            -- Prevent text selection while dragging scrollbar
            UserInputService.TextSelectionEnabled = false
        end
    end)

    Utility.Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isDragging then
            isDragging = false
            -- Re-enable text selection
            UserInputService.TextSelectionEnabled = true
        end
    end)

    Utility.Connect(UserInputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            local deltaY = input.Position.Y - dragStartMouseY
            local canvasSizeY = scrollFrame.CanvasSize.Y.Offset
            local frameSizeY = scrollFrame.AbsoluteSize.Y
            local thumbSizeY = scrollThumb.AbsoluteSize.Y
            local trackHeight = frameSizeY

            if canvasSizeY > frameSizeY and trackHeight > thumbSizeY then -- Check trackHeight > thumbSizeY
                -- Calculate how much the canvas should move per pixel of mouse movement
                local scrollRatio = (canvasSizeY - frameSizeY) / (trackHeight - thumbSizeY)
                local newCanvasY = dragStartCanvasY + (deltaY * scrollRatio)
                scrollFrame.CanvasPosition = Vector2.new(
                    scrollFrame.CanvasPosition.X,
                    math.clamp(newCanvasY, 0, canvasSizeY - frameSizeY)
                )
                -- No need to call updateScrollbar here, CanvasPosition change signal handles it
            end
        end
    end)

    -- Mouse wheel scrolling (ensure this doesn't conflict with other scroll logic)
    Utility.Connect(scrollFrame.InputChanged, function(input)
         if input.UserInputType == Enum.UserInputType.MouseWheel then
            -- Check if mouse is actually over the scrollFrame
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = scrollFrame.AbsolutePosition
            local frameSize = scrollFrame.AbsoluteSize
            if mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
               mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y then

                local scrollDelta = input.Position.Z * -40 -- Invert and adjust speed
                local canvasSizeY = scrollFrame.CanvasSize.Y.Offset
                local frameSizeY = scrollFrame.AbsoluteSize.Y
                local maxScroll = math.max(0, canvasSizeY - frameSizeY)
                local currentPos = scrollFrame.CanvasPosition.Y

                scrollFrame.CanvasPosition = Vector2.new(
                    scrollFrame.CanvasPosition.X,
                    math.clamp(currentPos + scrollDelta, 0, maxScroll)
                )
            end
        end
    end)

    -- Initial update
    task.wait() -- Wait a frame for sizes to calculate
    updateScrollbar()

    return scrollbar
end

-- Animation/Effect Utilities (using Utility functions) - Added Pulse
function Utility.rippleEffect(parent, color, speed)
    color = color or Color3.fromRGB(255, 255, 255)
    speed = speed or 0.4

    local ripple = Utility.createInstance("Frame", {
        Name = "Ripple",
        BackgroundColor3 = color,
        BackgroundTransparency = 0.75, -- Start slightly more transparent
        Size = UDim2.fromScale(0, 0),
        Position = UDim2.fromScale(0.5, 0.5), -- Center by default
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        ZIndex = (parent.ZIndex or 1) + 1, -- Ensure ripple is above parent
        Parent = parent
    })
    Utility.createCorner(ripple, 1) -- Make it circular

    -- Calculate position relative to parent's center if mouse isn't available/reliable
    local mousePos = UserInputService:GetMouseLocation()
    local parentPos = parent.AbsolutePosition
    local parentSize = parent.AbsoluteSize
    local relativeX = (mousePos.X - parentPos.X) / parentSize.X
    local relativeY = (mousePos.Y - parentPos.Y) / parentSize.Y
    ripple.Position = UDim2.new(relativeX, 0, relativeY, 0)

    local diameter = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5 -- Expand further

    local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {
        Size = UDim2.new(0, diameter, 0, diameter),
        BackgroundTransparency = 1
    }
    local tween = TweenService:Create(ripple, tweenInfo, goal)
    tween:Play()

    -- Use Utility.destroyInstance for cleanup
    Utility.Connect(tween.Completed, function()
        Utility.destroyInstance(ripple)
    end)
end

function Utility.pulseEffect(instance, scaleFactor, duration)
    scaleFactor = scaleFactor or 1.1
    duration = duration or 0.15
    local originalSize = instance.Size
    local originalAnchor = instance.AnchorPoint
    local tweenInfo = TweenInfo.new(duration / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- Scale up
    TweenService:Create(instance, tweenInfo, {
        Size = UDim2.new(originalSize.X.Scale * scaleFactor, originalSize.X.Offset * scaleFactor, originalSize.Y.Scale * scaleFactor, originalSize.Y.Offset * scaleFactor),
        -- Adjust anchor point slightly if needed to keep centered, depends on usage
    }):Play()

    -- Scale back down
    task.delay(duration / 2, function()
        TweenService:Create(instance, tweenInfo, { Size = originalSize }):Play()
    end)
end

-- Other utility functions like typewrite, blur/removeBlur can be added here similarly...

--[[
--------------------------------------------------------------------------
-- Main UI Creation Functions Start Here
--------------------------------------------------------------------------
]]

-- Function to apply theme updates to existing elements (More Robust)
function LuminaUI:ApplyTheme(themeName)
    if not LuminaUI.Theme[themeName] then
        warn("LuminaUI: Theme '" .. themeName .. "' not found.")
        return
    end
    SelectedTheme = LuminaUI.Theme[themeName]

    -- Iterate through tracked instances and call their update functions
    for id, data in pairs(LuminaUI._Instances) do
        if data.Instance and data.Instance.Parent and data.UpdateTheme then
            -- Use pcall to prevent one error from stopping all updates
            local success, err = pcall(data.UpdateTheme, data.Instance)
            if not success then
                warn("LuminaUI: Error applying theme to", data.Instance:GetFullName(), "-", err)
            end
        elseif not data.Instance or not data.Instance.Parent then
            -- Clean up tracked instances that no longer exist
            LuminaUI._Instances[id] = nil
        end
    end

    print("LuminaUI: Applied theme - " .. themeName)
end


-- Main Window Creation Function (Refactored + Watermark)
function LuminaUI:CreateWindow(settings)
    settings = settings or {}
    settings.Name = settings.Name or "LuminaUI Window"
    settings.Theme = settings.Theme or "Default"
    settings.Size = settings.Size or UDim2.new(0, 550, 0, 475)
    settings.Icon = settings.Icon -- Keep as is (nil or asset id/path)
    settings.ConfigurationSaving = settings.ConfigurationSaving or { Enabled = true, FileName = settings.Name } -- Default to enabled, use Name as filename
    settings.KeySystem = settings.KeySystem or { Enabled = true } -- Default key system to enabled
    settings.Draggable = settings.Draggable == nil and true or settings.Draggable -- Default true
    settings.RememberPosition = settings.RememberPosition == nil and true or settings.RememberPosition -- Default true
    settings.Watermark = settings.Watermark or { Enabled = true, Text = "LuminaUI v" .. LuminaUI.Version } -- Default watermark

    -- Destroy existing UI if it belongs to this library instance
    if Library and Library.Parent then
        Utility.destroyInstance(Library)
        Library = nil
        -- Clear tracked instances associated with the old library
        LuminaUI._Instances = {}
        -- Disconnect old keybind listener
        if LuminaUI._KeybindListener then
            LuminaUI._KeybindListener:Disconnect()
            LuminaUI._KeybindListener = nil
        end
    end

    -- Load configuration *before* creating UI elements
    local loadedConfig = Utility.loadConfig(settings)

    -- Apply loaded theme if available and valid
    if loadedConfig.Window and loadedConfig.Window.Theme and LuminaUI.Theme[loadedConfig.Window.Theme] then
        settings.Theme = loadedConfig.Window.Theme
    end
    SelectedTheme = LuminaUI.Theme[settings.Theme] -- Set the active theme

    -- Apply loaded position if available and enabled
    local initialPosition = settings.UIPosition or UDim2.new(0.5, -settings.Size.X.Offset / 2, 0.5, -settings.Size.Y.Offset / 2) -- Default center
    if settings.RememberPosition and loadedConfig.Window and loadedConfig.Window.Position then
        initialPosition = loadedConfig.Window.Position
    end

    -- Create base ScreenGui
    Library = Utility.createInstance("ScreenGui", {
        Name = "LuminaUI_" .. settings.Name:gsub("%s+", "_"), -- Unique name
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 1000, -- High display order
        IgnoreGuiInset = true -- Render over the top bar inset
    })

    -- Set Parent (handle different environments)
    local parentGui = get_hui and get_hui() or CoreGui
    if is_synapse then
        syn.protect_gui(Library)
        parentGui = CoreGui -- Synapse requires CoreGui after protection
    end
    Library.Parent = parentGui

    -- Keybind Listener Setup
    if settings.KeySystem and settings.KeySystem.Enabled then
        if not LuminaUI._KeybindListener or not LuminaUI._KeybindListener.Connected then
            LuminaUI._KeybindListener = Utility.Connect(UserInputService.InputBegan, function(input, gameProcessed)
                if gameProcessed then return end -- Ignore if chat or core GUI handled it

                local key = input.KeyCode
                local modifiers = {
                    Shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift),
                    Ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl),
                    Alt = UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
                }

                -- Check if any active text input is focused
                local focusedTextBox = UserInputService:GetFocusedTextBox()
                if focusedTextBox and focusedTextBox:IsDescendantOf(Library) then
                    return -- Don't trigger global keybinds if typing in UI
                end

                for id, keybindData in pairs(LuminaUI._Keybinds) do
                    if keybindData.Key == key and
                       (keybindData.Modifiers.Shift == modifiers.Shift) and
                       (keybindData.Modifiers.Ctrl == modifiers.Ctrl) and
                       (keybindData.Modifiers.Alt == modifiers.Alt) then

                        -- Execute callback in a protected call
                        local success, err = pcall(keybindData.Callback)
                        if not success then
                            warn("LuminaUI Keybind Error:", err)
                        end
                    end
                end
            end)
        end
    end

    -- Theme update function for the main frame
    local updateMainFrameTheme = function(instance)
        instance.BackgroundColor3 = SelectedTheme.Background
        local shadow = instance:FindFirstChild("Shadow")
        if shadow then shadow.ImageColor3 = SelectedTheme.Shadow end
        -- Topbar update is handled separately
        -- Content container background is transparent
    end

    -- Main window frame
    local MainFrame = Utility.createInstance("Frame", {
        Name = "MainFrame",
        Size = settings.Size,
        Position = initialPosition,
        BackgroundColor3 = SelectedTheme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = Library
    }, "MainFrame", updateMainFrameTheme) -- Track MainFrame
    Utility.createCorner(MainFrame, 8)

    -- Shadow (Optional, consider performance impact)
    local Shadow = Utility.createInstance("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 35, 1, 35), -- Slightly larger for softer shadow
        ZIndex = -1, -- Behind the main frame
        Image = "rbxassetid://5554236805", -- 9-slice shadow image
        ImageColor3 = SelectedTheme.Shadow,
        ImageTransparency = 0.5, -- Adjust transparency
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276), -- Adjust slice center based on image
        Parent = MainFrame
    })

    -- Theme update function for the topbar
    local updateTopbarTheme = function(instance)
        instance.BackgroundColor3 = SelectedTheme.Topbar
        local bottomFix = instance:FindFirstChild("BottomFix")
        if bottomFix then bottomFix.BackgroundColor3 = SelectedTheme.Topbar end
        local icon = instance:FindFirstChild("Icon")
        if icon then icon.ImageColor3 = SelectedTheme.TextColor end
        local title = instance:FindFirstChild("Title")
        if title then title.TextColor3 = SelectedTheme.TextColor end
        -- Control buttons are handled by their own update function
    end

    -- Topbar
    local Topbar = Utility.createInstance("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 40), -- Slightly shorter topbar
        BackgroundColor3 = SelectedTheme.Topbar,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = MainFrame
    }, "Topbar", updateTopbarTheme) -- Track Topbar
    -- Top corners only
    Utility.createCorner(Topbar, 8)
    local bottomFix = Utility.createInstance("Frame", { -- Cover bottom corners
        Name = "BottomFix",
        Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.5,0),
        BackgroundColor3 = SelectedTheme.Topbar, BorderSizePixel = 0, ZIndex = 0,
        Parent = Topbar
    })


    -- Icon (if provided)
    local titleLeftPadding = 15
    if settings.Icon then
        local Icon = Utility.createInstance("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 15, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = Utility.loadIcon(settings.Icon),
            ImageColor3 = SelectedTheme.TextColor, -- Use text color for icon tint
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 2,
            Parent = Topbar
        })
        titleLeftPadding = 45 -- Increase padding if icon exists
    end

    -- Title
    local TopbarTitle = Utility.createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -(titleLeftPadding + 100), 1, 0), -- Adjust size based on padding and buttons
        Position = UDim2.new(0, titleLeftPadding, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = settings.Name,
        TextColor3 = SelectedTheme.TextColor,
        TextSize = 15, -- Slightly larger title
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2,
        Parent = Topbar
    })

    -- Control buttons container
    local ControlButtons = Utility.createInstance("Frame", {
        Name = "ControlButtons",
        Size = UDim2.new(0, 100, 1, 0), -- Adjust size as needed
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = Topbar
    })
    local ControlLayout = Utility.createInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = ControlButtons
    })
     local ControlPadding = Utility.createInstance("UIPadding", {
        PaddingRight = UDim.new(0, 10),
        Parent = ControlButtons
    })

    -- Theme update function for control buttons
    local updateControlButtonTheme = function(instance)
        -- Update based on current state (hover, normal, active?) - tricky
        -- For now, just update the base color
        instance.ImageColor3 = SelectedTheme.SubTextColor
        -- Need to re-apply hover/active colors if state changes during theme update
    end

    -- Settings Button
    local SettingsButton = Utility.createInstance("ImageButton", {
        Name = "Settings",
        Size = UDim2.new(0, 18, 0, 18),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031280882", -- Settings icon
        ImageColor3 = SelectedTheme.SubTextColor, -- Use subtext color initially
        LayoutOrder = 1,
        Parent = ControlButtons
    }, "ControlButton", updateControlButtonTheme) -- Track

    -- Minimize Button
    local MinimizeButton = Utility.createInstance("ImageButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 18, 0, 18),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6035067836", -- Minimize icon
        ImageColor3 = SelectedTheme.SubTextColor,
        LayoutOrder = 2,
        Parent = ControlButtons
    }, "ControlButton", updateControlButtonTheme) -- Track

    -- Close Button
    local CloseButton = Utility.createInstance("ImageButton", {
        Name = "Close",
        Size = UDim2.new(0, 18, 0, 18),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6035047409", -- Close icon
        ImageColor3 = SelectedTheme.SubTextColor,
        LayoutOrder = 3,
        Parent = ControlButtons
    }, "ControlButton", updateControlButtonTheme) -- Track

    -- Button hover/click effects
    local function setupControlButton(button)
        Utility.Connect(button.MouseEnter, function()
            TweenService:Create(button, TweenInfo.new(0.2), { ImageColor3 = SelectedTheme.TextColor }):Play()
        end)
        Utility.Connect(button.MouseLeave, function()
            -- Check if it's the settings button and if settings are open
            local isSettingsActive = button == SettingsButton and settingsOpen
            local targetColor = isSettingsActive and (SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled) or SelectedTheme.SubTextColor
            TweenService:Create(button, TweenInfo.new(0.2), { ImageColor3 = targetColor }):Play()
        end)
         Utility.Connect(button.MouseButton1Down, function()
             TweenService:Create(button, TweenInfo.new(0.1), { ImageColor3 = Utility.darker(SelectedTheme.TextColor, 0.2) }):Play()
         end)
         Utility.Connect(button.MouseButton1Up, function()
             local isSettingsActive = button == SettingsButton and settingsOpen
             local targetColor = isSettingsActive and (SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled) or SelectedTheme.TextColor -- Go to TextColor if mouse is still over
             TweenService:Create(button, TweenInfo.new(0.1), { ImageColor3 = targetColor }):Play()
         end)
    end
    setupControlButton(SettingsButton)
    setupControlButton(MinimizeButton)
    setupControlButton(CloseButton)


    -- Content Area (Tabs + Elements)
    local ContentContainer = Utility.createInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, 0, 1, -Topbar.Size.Y.Offset), -- Fill remaining space
        Position = UDim2.new(0, 0, 0, Topbar.Size.Y.Offset),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainFrame
    })

    -- Theme update function for Tab Container
    local updateTabContainerTheme = function(instance)
        instance.BackgroundColor3 = SelectedTheme.Background
        local separator = instance:FindFirstChild("Separator")
        if separator then separator.BackgroundColor3 = SelectedTheme.ElementStroke end
        -- Tab buttons are handled by their own updates
    end

    -- Tab Container
    local tabContainerWidth = 140
    local TabContainer = Utility.createInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, tabContainerWidth, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = SelectedTheme.Background, -- Match main background or slightly different
        BackgroundTransparency = 0.5, -- Semi-transparent maybe?
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = ContentContainer
    }, "TabContainer", updateTabContainerTheme) -- Track TabContainer
     -- Line separating tabs and content
     local SeparatorLine = Utility.createInstance("Frame", {
        Name = "Separator",
        Size = UDim2.new(0, 1, 1, 0), -- 1 pixel wide
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = SelectedTheme.ElementStroke,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = TabContainer
    })


    local TabScrollFrame = Utility.createInstance("ScrollingFrame", {
        Name = "TabScrollFrame",
        Size = UDim2.new(1, 0, 1, 0), -- Fill TabContainer
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0), -- Auto-sized by layout
        ScrollBarThickness = 0, -- Use custom scrollbar
        Parent = TabContainer
    })
    Utility.applyCustomScrollbar(TabScrollFrame, 4) -- Apply thin custom scrollbar

    local TabListLayout = Utility.createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = TabScrollFrame
    })
    local TabPadding = Utility.createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = TabScrollFrame
    })

    -- Elements Container (Pages)
    local ElementsContainer = Utility.createInstance("Frame", {
        Name = "ElementsContainer",
        Size = UDim2.new(1, -tabContainerWidth, 1, 0), -- Fill remaining space
        Position = UDim2.new(0, tabContainerWidth, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 0,
        Parent = ContentContainer
    })

    local ElementsPageFolder = Utility.createInstance("Folder", {
        Name = "Pages",
        Parent = ElementsContainer
    })

    -- Settings Page (Refactored with Theme Updates and Keybind Section)
    local function createSettingsPage()
        local existingPage = ElementsPageFolder:FindFirstChild("LuminaSettingsPage")
        if existingPage then return existingPage end

        local SettingsPage = Utility.createInstance("ScrollingFrame", {
            Name = "LuminaSettingsPage",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0), -- Auto-sized
            Visible = false, -- Initially hidden
            Parent = ElementsPageFolder
        })
        Utility.applyCustomScrollbar(SettingsPage) -- Add scrollbar

        local SettingsListLayout = Utility.createInstance("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = SettingsPage
        })
        local SettingsPadding = Utility.createInstance("UIPadding", {
            PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
            Parent = SettingsPage
        })

         -- Auto-size canvas
        Utility.Connect(SettingsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            -- Check if SettingsPage and SettingsListLayout are still valid
            if SettingsPage and SettingsPage.Parent and SettingsListLayout and SettingsListLayout.Parent then
                 SettingsPage.CanvasSize = UDim2.new(0, SettingsListLayout.AbsoluteContentSize.X, 0, SettingsListLayout.AbsoluteContentSize.Y + 20) -- Add bottom padding
            end
        end)

        -- Theme update function for Settings Page elements
        local updateSettingsTheme = function(instance)
            -- Update titles, buttons, etc., within the settings page
            local themeTitle = instance:FindFirstChild("ThemeTitle")
            if themeTitle then themeTitle.TextColor3 = SelectedTheme.TextColor end
            local discordTitle = instance:FindFirstChild("DiscordTitle")
            if discordTitle then discordTitle.TextColor3 = SelectedTheme.TextColor end
            local keybindTitle = instance:FindFirstChild("KeybindTitle")
            if keybindTitle then keybindTitle.TextColor3 = SelectedTheme.TextColor end

            -- Update Theme Buttons
            local themeGrid = instance:FindFirstChild("ThemeGrid")
            if themeGrid then
                for _, buttonFrame in ipairs(themeGrid:GetChildren()) do
                    if buttonFrame:IsA("Frame") and buttonFrame:FindFirstChild("Interact") then
                        local themeName = buttonFrame.Name:gsub("ThemeButton", "")
                        local themeData = LuminaUI.Theme[themeName]
                        if themeData then
                            buttonFrame.BackgroundColor3 = themeData.ElementBackground
                            local stroke = buttonFrame:FindFirstChildOfClass("UIStroke")
                            local label = buttonFrame:FindFirstChild("Label")
                            local topbar = buttonFrame:FindFirstChild("PreviewTopbar")
                            local accent = buttonFrame:FindFirstChild("PreviewAccent")
                            local element = buttonFrame:FindFirstChild("PreviewElement")

                            if label then label.TextColor3 = themeData.TextColor end
                            if topbar then topbar.BackgroundColor3 = themeData.Topbar end
                            if accent then accent.BackgroundColor3 = themeData.AccentColor or themeData.ToggleEnabled end
                            if element then element.BackgroundColor3 = themeData.ElementBackgroundHover end
                            if stroke then
                                stroke.Color = (SelectedTheme.Name == themeName) and (SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled) or themeData.ElementStroke
                                stroke.Thickness = (SelectedTheme.Name == themeName) and 2 or 1
                                stroke.Transparency = 0
                            end
                        end
                    end
                end
            end

            -- Update Discord Button
            local discordButton = instance:FindFirstChild("DiscordButton")
            if discordButton then
                discordButton.BackgroundColor3 = SelectedTheme.ElementBackground
                local stroke = discordButton:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = SelectedTheme.ElementStroke end
                local icon = discordButton:FindFirstChild("Icon")
                if icon then icon.ImageColor3 = SelectedTheme.TextColor end
                local label = discordButton:FindFirstChild("Label")
                if label then label.TextColor3 = SelectedTheme.TextColor end
            end

            -- Update Keybind elements (if any visual elements are added later)
        end
        Utility.trackInstance(SettingsPage, "SettingsPage", updateSettingsTheme) -- Track settings page

        -- Add Theme Section Title
        local ThemeTitle = Utility.createInstance("TextLabel", {
            Name = "ThemeTitle", Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, Text = "Theme Selection", TextColor3 = SelectedTheme.TextColor,
            TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, Parent = SettingsPage
        })

        -- Theme selector container (using UIGridLayout)
        local ThemeGrid = Utility.createInstance("Frame", {
            Name = "ThemeGrid", Size = UDim2.new(1, 0, 0, 100), BackgroundTransparency = 1,
            LayoutOrder = 2, Parent = SettingsPage
        })
        local ThemeGridLayout = Utility.createInstance("UIGridLayout", {
            CellPadding = UDim2.new(0, 10, 0, 10), CellSize = UDim2.new(0, 100, 0, 100),
            HorizontalAlignment = Enum.HorizontalAlignment.Left, SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ThemeGrid
        })

        -- Function to create a single theme button
        local function createThemeButton(themeName, layoutOrder)
            local themeData = LuminaUI.Theme[themeName]
            local ThemeButtonFrame = Utility.createInstance("Frame", {
                Name = themeName .. "ThemeButton", Size = UDim2.new(0, 100, 0, 100),
                BackgroundColor3 = themeData.ElementBackground, LayoutOrder = layoutOrder, Parent = ThemeGrid
            })
            Utility.createCorner(ThemeButtonFrame, 6)
            local stroke = Utility.createStroke(ThemeButtonFrame, themeData.ElementStroke, 1)

            -- Simple preview elements
            local PreviewTopbar = Utility.createInstance("Frame", { Name="PreviewTopbar", Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0.5, 0, 0, 10), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = themeData.Topbar, Parent = ThemeButtonFrame })
            Utility.createCorner(PreviewTopbar, 4)
            local PreviewAccent = Utility.createInstance("Frame", { Name="PreviewAccent", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 10, 0, 40), BackgroundColor3 = themeData.AccentColor or themeData.ToggleEnabled, Parent = ThemeButtonFrame })
            Utility.createCorner(PreviewAccent, 10)
            local PreviewElement = Utility.createInstance("Frame", { Name="PreviewElement", Size = UDim2.new(0, 50, 0, 15), Position = UDim2.new(0, 40, 0, 42.5), BackgroundColor3 = themeData.ElementBackgroundHover, Parent = ThemeButtonFrame })
            Utility.createCorner(PreviewElement, 4)

            local ThemeLabel = Utility.createInstance("TextLabel", {
                Name = "Label", Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 1, -25), AnchorPoint = Vector2.new(0, 0),
                BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = themeName, TextColor3 = themeData.TextColor, TextSize = 12,
                Parent = ThemeButtonFrame
            })

            local ThemeInteract = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = ThemeButtonFrame })

            -- Highlight selected theme
            local function updateHighlight()
                 if SelectedTheme and SelectedTheme.Name == themeName then
                     stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled
                     stroke.Thickness = 2
                     stroke.Transparency = 0
                 else
                     stroke.Color = themeData.ElementStroke
                     stroke.Thickness = 1
                     stroke.Transparency = 0
                 end
            end
            updateHighlight() -- Initial check

            Utility.Connect(ThemeInteract.MouseButton1Click, function()
                LuminaUI:ApplyTheme(themeName) -- Apply the selected theme (this will trigger updates)
                settings.Theme = themeName -- Update settings object for potential saving
                -- No need to manually update highlights here, ApplyTheme handles it
            end)

             -- Add hover effect
             Utility.Connect(ThemeInteract.MouseEnter, function() if not SelectedTheme or SelectedTheme.Name ~= themeName then stroke.Transparency = 0.5 end end)
             Utility.Connect(ThemeInteract.MouseLeave, function() if not SelectedTheme or SelectedTheme.Name ~= themeName then stroke.Transparency = 0 end end)

            return ThemeButtonFrame
        end

        -- Create buttons for each theme
        local order = 1
        for themeName, themeData in pairs(LuminaUI.Theme) do
            createThemeButton(themeName, order)
            order = order + 1
        end

        -- Add Discord Button Section
        local DiscordTitle = Utility.createInstance("TextLabel", {
            Name = "DiscordTitle", Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, Text = "Community", TextColor3 = SelectedTheme.TextColor,
            TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 3, Parent = SettingsPage
        })

        local DiscordButton = Utility.createInstance("Frame", {
            Name = "DiscordButton", Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = SelectedTheme.ElementBackground,
            LayoutOrder = 4, Parent = SettingsPage
        })
        Utility.createCorner(DiscordButton, 4)
        local discordStroke = Utility.createStroke(DiscordButton, SelectedTheme.ElementStroke, 1)

        local discordIcon = Utility.createInstance("ImageLabel", {
            Name = "Icon", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 10, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1, Image = "rbxassetid://6031280882", -- Placeholder, replace with Discord icon if available
            ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = DiscordButton
        })

        local DiscordLabel = Utility.createInstance("TextLabel", {
            Name = "Label", Size = UDim2.new(1, -(10 + 20 + 8 + 10), 1, 0), Position = UDim2.new(0, 10 + 20 + 8, 0, 0),
            BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "Join the Discord", TextColor3 = SelectedTheme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = DiscordButton
        })

        local DiscordInteract = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = DiscordButton })

        -- Effects & Callback for Discord Button
        Utility.Connect(DiscordInteract.MouseEnter, function()
            TweenService:Create(DiscordButton, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
            discordStroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled
            Utility.showTooltip("Click to copy invite link!")
        end)
        Utility.Connect(DiscordInteract.MouseLeave, function()
            TweenService:Create(DiscordButton, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
            discordStroke.Color = SelectedTheme.ElementStroke
            Utility.hideTooltip()
        end)
         Utility.Connect(DiscordInteract.MouseButton1Down, function()
             TweenService:Create(DiscordButton, TweenInfo.new(0.1), { BackgroundColor3 = SelectedTheme.ElementBackgroundActive or Utility.darker(SelectedTheme.ElementBackgroundHover, 0.1) }):Play()
             Utility.rippleEffect(DiscordButton, Utility.lighter(SelectedTheme.ElementBackgroundHover, 0.2))
         end)
         Utility.Connect(DiscordInteract.MouseButton1Up, function()
             TweenService:Create(DiscordButton, TweenInfo.new(0.1), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
         end)
        Utility.Connect(DiscordInteract.MouseButton1Click, function()
            if setclipboard then
                setclipboard("https://discord.gg/KgvmCnZ88n")
                if Library and Library:FindFirstChild("MainFrame") and Window then -- Assuming Window is accessible
                     Window:CreateNotification({ Title = "Discord Invite Copied", Content = "Invite link copied to clipboard.", Duration = 3 })
                else
                     warn("LuminaUI: Could not create notification for Discord link.")
                end
            else
                warn("LuminaUI: 'setclipboard' function not available.")
            end
        end)

        -- Add Keybind Section Title (Placeholder - No UI elements yet)
        if settings.KeySystem and settings.KeySystem.Enabled then
            local KeybindTitle = Utility.createInstance("TextLabel", {
                Name = "KeybindTitle", Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold, Text = "Keybinds", TextColor3 = SelectedTheme.TextColor,
                TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 5, Parent = SettingsPage
            })
            -- TODO: Add UI elements here to display/modify keybinds registered via Tab:CreateKeybind
            local KeybindInfo = Utility.createInstance("TextLabel", {
                Name = "KeybindInfo", Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
                Font = Enum.Font.Gotham, Text = "(Keybind management UI not yet implemented)", TextColor3 = SelectedTheme.SubTextColor,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 6, Parent = SettingsPage
            })
        end

        return SettingsPage
    end

    -- Make the UI draggable (if enabled)
    if settings.Draggable then
        Utility.makeDraggable(MainFrame, Topbar)
    end

    -- Theme update function for Notifications container (mostly layout)
    local updateNotificationsTheme = function(instance)
        -- No direct visual properties to update on the container itself
        -- Individual notifications handle their own theme updates
    end

    -- Notification container (position relative to Library)
    local Notifications = Utility.createInstance("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 280, 0, 300), -- Max size
        Position = UDim2.new(1, -300, 1, -320), -- Default bottom-right corner
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 1000, -- Above main UI
        Parent = Library -- Parent to ScreenGui directly
    }, "NotificationsContainer", updateNotificationsTheme) -- Track
    local NotificationListLayout = Utility.createInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom, -- Notifications stack upwards
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = Notifications
    })

    -- Watermark (if enabled)
    local WatermarkLabel = nil
    if settings.Watermark and settings.Watermark.Enabled then
        local updateWatermarkTheme = function(instance)
            instance.TextColor3 = SelectedTheme.SubTextColor
        end
        WatermarkLabel = Utility.createInstance("TextLabel", {
            Name = "Watermark",
            Size = UDim2.new(0, 200, 0, 20),
            Position = UDim2.new(0, 10, 1, -25), -- Bottom-left corner of ScreenGui
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = settings.Watermark.Text or "LuminaUI",
            TextColor3 = SelectedTheme.SubTextColor,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 1001, -- Above notifications potentially
            Parent = Library -- Parent to ScreenGui
        }, "Watermark", updateWatermarkTheme) -- Track
    end


    -- Button Functionality
    Utility.Connect(CloseButton.MouseButton1Click, function()
        -- Save config before closing if enabled
        if settings.ConfigurationSaving and settings.ConfigurationSaving.Enabled then
            Utility.saveConfig(MainFrame, settings)
        end

        -- Optional: Fade out animation
        local fadeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(MainFrame, fadeInfo, { BackgroundTransparency = 1, Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset * 0.8, MainFrame.Size.Y.Scale, MainFrame.Size.Y.Offset * 0.8), Position = MainFrame.Position + UDim2.fromOffset(MainFrame.Size.X.Offset * 0.1, MainFrame.Size.Y.Offset * 0.1) }) -- Shrink and fade
        tween:Play()
        Utility.Connect(tween.Completed, function()
             Utility.destroyInstance(Library) -- Use pooled destroy
             Library = nil -- Clear reference
             LuminaUI._Instances = {} -- Clear tracked instances
             if LuminaUI._KeybindListener then LuminaUI._KeybindListener:Disconnect(); LuminaUI._KeybindListener = nil end -- Disconnect listener
        end)
    end)

    local minimized = false
    local originalSize = settings.Size
    Utility.Connect(MinimizeButton.MouseButton1Click, function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, Topbar.Size.Y.Offset) or originalSize
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(MainFrame, tweenInfo, { Size = targetSize }):Play()
        -- Optionally change minimize icon or hide content container
        ContentContainer.Visible = not minimized
        MinimizeButton.Rotation = minimized and 180 or 0 -- Rotate icon
    end)

    -- Settings button toggles settings page visibility
    local settingsOpen = false
    local previouslySelectedTab = nil -- Remember last tab

    -- Helper function to update tab visual state
    local function updateTabVisuals(tabButton, selected)
        if not tabButton or not tabButton:IsA("Frame") then return end
        local title = tabButton:FindFirstChild("Title")
        local icon = tabButton:FindFirstChild("Icon")

        if selected then
            tabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
            tabButton.BackgroundTransparency = 0
            if title then title.TextColor3 = SelectedTheme.SelectedTabTextColor; title.TextTransparency = 0 end
            if icon then icon.ImageColor3 = SelectedTheme.SelectedTabTextColor; icon.ImageTransparency = 0 end
        else
            tabButton.BackgroundColor3 = SelectedTheme.TabBackground
            tabButton.BackgroundTransparency = 0.7
            if title then title.TextColor3 = SelectedTheme.TabTextColor; title.TextTransparency = 0.2 end
            if icon then icon.ImageColor3 = SelectedTheme.TabTextColor; icon.ImageTransparency = 0.2 end
        end
    end

    Utility.Connect(SettingsButton.MouseButton1Click, function()
        settingsOpen = not settingsOpen
        local settingsPage = createSettingsPage() -- Ensure page exists

        if settingsOpen then
            -- Find currently selected tab/page and hide it
            previouslySelectedTab = nil
            for _, page in ipairs(ElementsPageFolder:GetChildren()) do
                if page.Visible and page ~= settingsPage then
                    previouslySelectedTab = page
                    page.Visible = false
                    -- Deselect corresponding tab button
                    local tabButton = TabScrollFrame:FindFirstChild(page.Name)
                    updateTabVisuals(tabButton, false)
                    break -- Assuming only one page is visible at a time
                end
            end
            -- If no specific tab was active, deselect all
            if not previouslySelectedTab then
                 for _, tabButton in ipairs(TabScrollFrame:GetChildren()) do
                     if tabButton:IsA("Frame") and tabButton:FindFirstChild("Interact") then
                         updateTabVisuals(tabButton, false)
                     end
                 end
            end

            settingsPage.Visible = true
            SettingsButton.ImageColor3 = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled -- Highlight settings icon
        else
            settingsPage.Visible = false
            SettingsButton.ImageColor3 = SelectedTheme.SubTextColor -- Reset settings icon color (MouseEnter/Leave will handle hover)

            -- Reselect the previously selected tab or the first tab
            local targetTabId = nil
            if previouslySelectedTab then
                targetTabId = previouslySelectedTab.Name
            else
                -- Find the first tab if none was previously selected
                local firstTabButton
                for _, child in ipairs(TabScrollFrame:GetChildren()) do
                    if child:IsA("Frame") and child:FindFirstChild("Interact") then
                        firstTabButton = child
                        break
                    end
                end
                if firstTabButton then
                    targetTabId = firstTabButton.Name
                end
            end

            if targetTabId then
                Window:SelectTab(targetTabId) -- Use SelectTab to handle visuals and page visibility
            end
        end
    end)


    -- Window API object (returned to the user)
    local Window = {}
    local activePage = nil -- Track the currently visible page

    -- Function to select a tab/page programmatically (Refactored)
    function Window:SelectTab(tabOrPageName)
        local targetPage = ElementsPageFolder:FindFirstChild(tabOrPageName)
        local targetTabButton = TabScrollFrame:FindFirstChild(tabOrPageName)

        if not targetPage or not targetTabButton or not targetTabButton:FindFirstChild("Interact") then
            warn("LuminaUI: Tab or Page not found:", tabOrPageName)
            return
        end

        -- Hide current page and deselect current tab
        if activePage and activePage ~= targetPage then
            activePage.Visible = false
            local activeTabButton = TabScrollFrame:FindFirstChild(activePage.Name)
            updateTabVisuals(activeTabButton, false)
        end

         -- Hide settings page if it's open and deselect settings button
         local settingsPage = ElementsPageFolder:FindFirstChild("LuminaSettingsPage")
         if settingsPage and settingsPage.Visible then
             settingsPage.Visible = false
             SettingsButton.ImageColor3 = SelectedTheme.SubTextColor -- Reset settings icon color
             settingsOpen = false
         end

        -- Show target page and select target tab
        targetPage.Visible = true
        activePage = targetPage
        targetPage.CanvasPosition = Vector2.zero -- Scroll to top
        updateTabVisuals(targetTabButton, true)

        -- Optional: Pulse effect on icon
        local icon = targetTabButton:FindFirstChild("Icon")
        if icon then Utility.pulseEffect(icon, 1.1, 0.15) end
    end


    -- Notification Function (Refactored with Theme Update)
    function Window:CreateNotification(notifSettings)
        notifSettings = notifSettings or {}
        local title = notifSettings.Title or "Notification"
        local content = notifSettings.Content or "This is a notification."
        local duration = notifSettings.Duration or 5
        local iconId = notifSettings.Icon -- nil or asset id/path
        local callback = notifSettings.Callback -- Function to call on click

        local notificationHeight = 65
        local padding = 10
        local iconSize = 24
        local textXOffset = padding + (iconId and (iconSize + padding) or 0)
        local textWidth = Notifications.Size.X.Offset - textXOffset - padding - 16 -- Subtract close button space

        -- Theme update function for individual notification
        local updateNotificationTheme = function(instance)
            instance.BackgroundColor3 = SelectedTheme.NotificationBackground
            local stroke = instance:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = SelectedTheme.ElementStroke end
            local icon = instance:FindFirstChild("Icon")
            if icon then icon.ImageColor3 = SelectedTheme.TextColor end
            local titleLabel = instance:FindFirstChild("Title")
            if titleLabel then titleLabel.TextColor3 = SelectedTheme.TextColor end
            local bodyLabel = instance:FindFirstChild("Body")
            if bodyLabel then bodyLabel.TextColor3 = SelectedTheme.SubTextColor end
            local durationBar = instance:FindFirstChild("DurationBar")
            if durationBar then durationBar.BackgroundColor3 = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled end
            local closeBtn = instance:FindFirstChild("Close")
            if closeBtn then closeBtn.ImageColor3 = SelectedTheme.SubTextColor end
        end

        local Notification = Utility.createInstance("Frame", {
            Name = "Notification_" .. HttpService:GenerateGUID(false),
            Size = UDim2.new(1, 0, 0, notificationHeight),
            BackgroundColor3 = SelectedTheme.NotificationBackground,
            BackgroundTransparency = 1, -- Start transparent for fade-in
            ClipsDescendants = true,
            LayoutOrder = tick(), -- Use tick for ordering
            Parent = Notifications
        }, "Notification", updateNotificationTheme) -- Track notification
        Utility.createCorner(Notification, 6)
        Utility.createStroke(Notification, SelectedTheme.ElementStroke, 1, 0.5)

        -- Icon
        if iconId then
            local NotifIcon = Utility.createInstance("ImageLabel", {
                Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, padding, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(iconId),
                ImageColor3 = SelectedTheme.TextColor, ImageTransparency = 1, Parent = Notification
            })
            TweenService:Create(NotifIcon, TweenInfo.new(0.3), { ImageTransparency = 0 }):Play()
        end

        -- Title
        local NotifTitle = Utility.createInstance("TextLabel", {
            Name = "Title", Size = UDim2.new(0, textWidth, 0, 18), Position = UDim2.new(0, textXOffset, 0, padding),
            BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = title, TextColor3 = SelectedTheme.TextColor,
            TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Parent = Notification
        })

        -- Content
        local NotifBody = Utility.createInstance("TextLabel", {
            Name = "Body", Size = UDim2.new(0, textWidth, 0, notificationHeight - 30 - padding), Position = UDim2.new(0, textXOffset, 0, padding + 18 + 2),
            BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = content, TextColor3 = SelectedTheme.SubTextColor,
            TextSize = 13, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
            TextTransparency = 1, Parent = Notification
        })

        -- Progress Bar (Optional)
        local ProgressBar = Utility.createInstance("Frame", {
            Name = "DurationBar", Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, 0), AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled, BackgroundTransparency = 0.5, Parent = Notification
        })
        Utility.createCorner(ProgressBar, 1.5)

        -- Close Button
        local CloseNotif = Utility.createInstance("ImageButton", {
            Name = "Close", Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -padding, 0, padding), AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1, Image = "rbxassetid://6035047409", ImageColor3 = SelectedTheme.SubTextColor,
            ImageTransparency = 1, ZIndex = 2, Parent = Notification
        })
         setupControlButton(CloseNotif) -- Apply standard hover effects

        -- Function to close/dismiss the notification
        local closeTween = nil
        local function dismissNotification()
            if closeTween and closeTween.PlaybackState == Enum.PlaybackState.Playing then return end -- Prevent double dismiss

            -- Cancel duration tween
            local durationTween = TweenService:GetTweensByTag("NotificationDuration_" .. Notification.Name)[1]
            if durationTween then durationTween:Cancel() end

            closeTween = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 0), -- Collapse height
                BackgroundTransparency = 1
            })
            closeTween:Play()
            Utility.Connect(closeTween.Completed, function()
                Utility.destroyInstance(Notification) -- This handles untracking
            end)
        end

        Utility.Connect(CloseNotif.MouseButton1Click, dismissNotification)

        -- Optional callback on clicking the main body
        if callback then
            local ClickDetector = Utility.createInstance("TextButton", {
                Name = "ClickDetector", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 1, Parent = Notification
            })
            Utility.Connect(ClickDetector.MouseButton1Click, function()
                callback()
                dismissNotification() -- Dismiss after callback
            end)
        end

        -- Fade-in Animation
        local fadeInTween = TweenService:Create(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.1 })
        TweenService:Create(NotifTitle, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
        TweenService:Create(NotifBody, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
        TweenService:Create(CloseNotif, TweenInfo.new(0.4), { ImageTransparency = 0.2 }):Play()
        fadeInTween:Play()

        -- Duration Animation & Auto-Dismiss
        local durationTween = TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 3) })
        durationTween.Tag = "NotificationDuration_" .. Notification.Name -- Tag for cancellation
        durationTween:Play()
        Utility.Connect(durationTween.Completed, dismissNotification)

        return Notification -- Return instance if needed
    end


    -- Tab Creation Function (Refactored with Theme Update)
    function Window:CreateTab(tabName, iconId)
        local tabId = tabName:gsub("%s+", "_") -- Create safe ID

        -- Check if tab already exists
        if TabScrollFrame:FindFirstChild(tabId) then
            warn("LuminaUI: Tab '" .. tabName .. "' already exists.")
            -- Find and return existing tab object if possible
            return LuminaUI.Tabs and LuminaUI.Tabs[tabId]
        end

        -- Theme update function for the tab button
        local updateTabButtonTheme = function(instance)
            local isSelected = activePage and activePage.Name == instance.Name
            updateTabVisuals(instance, isSelected) -- Use the helper function
        end

        -- Create Tab Button Frame
        local TabButton = Utility.createInstance("Frame", {
            Name = tabId,
            Size = UDim2.new(1, -10, 0, 36), -- Slightly taller tabs
            BackgroundColor3 = SelectedTheme.TabBackground,
            BackgroundTransparency = 0.7, -- Start deselected
            ClipsDescendants = true,
            LayoutOrder = #TabScrollFrame:GetChildren() + 1,
            Parent = TabScrollFrame
        }, "TabButton", updateTabButtonTheme) -- Track Tab Button
        Utility.createCorner(TabButton, 6)

        local iconSize = 18
        local leftPadding = 10
        local textLeftOffset = leftPadding

        -- Icon
        local TabIcon = nil
        if iconId then
            TabIcon = Utility.createInstance("ImageLabel", {
                Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, leftPadding, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(iconId),
                ImageColor3 = SelectedTheme.TabTextColor, ImageTransparency = 0.2, ScaleType = Enum.ScaleType.Fit, Parent = TabButton
            })
            textLeftOffset = leftPadding + iconSize + 8 -- Add padding between icon and text
        end

        -- Title
        local TabTitle = Utility.createInstance("TextLabel", {
            Name = "Title", Size = UDim2.new(1, -(textLeftOffset + 5), 1, 0), Position = UDim2.new(0, textLeftOffset, 0, 0),
            BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = tabName, TextColor3 = SelectedTheme.TabTextColor,
            TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 0.2, Parent = TabButton
        })

        -- Interaction Button (covers the whole tab)
        local TabInteract = Utility.createInstance("TextButton", {
            Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = TabButton
        })

        -- Create Content Page Frame
        local TabPage = Utility.createInstance("ScrollingFrame", {
            Name = tabId, -- Match tab button name
            Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0), BackgroundTransparency = 1,
            BorderSizePixel = 0, ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 0, Visible = false, Parent = ElementsPageFolder
        })
        Utility.applyCustomScrollbar(TabPage) -- Apply custom scrollbar

        local ElementsListLayout = Utility.createInstance("UIListLayout", {
            Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = TabPage
        })
        local ElementsPadding = Utility.createInstance("UIPadding", {
            PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = TabPage
        })

        -- Auto-size canvas height based on content
        Utility.Connect(ElementsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
             if TabPage and TabPage.Parent and ElementsListLayout and ElementsListLayout.Parent then
                 local contentHeight = ElementsListLayout.AbsoluteContentSize.Y
                 local paddingHeight = ElementsPadding.PaddingTop.Offset + ElementsPadding.PaddingBottom.Offset
                 TabPage.CanvasSize = UDim2.new(0, 0, 0, contentHeight + paddingHeight)
             end
        end)

        -- Handle Tab Selection via Click
        Utility.Connect(TabInteract.MouseButton1Click, function()
            Window:SelectTab(tabId) -- Use the SelectTab function
        end)

        -- Tab Object (API for adding elements)
        local Tab = {
            Name = tabName,
            Id = tabId,
            Instance = TabButton,
            Page = TabPage,
            Layout = ElementsListLayout,
            Elements = {} -- Store references to elements added to this tab
        }

        -- Store tab object for potential future reference
        if not LuminaUI.Tabs then LuminaUI.Tabs = {} end
        LuminaUI.Tabs[tabId] = Tab

        -- Helper function to register flag and handle loaded config
        local function registerFlag(flagName, defaultValue, elementType)
            if LuminaUI.Flags[flagName] then
                warn("LuminaUI: Flag '" .. flagName .. "' already exists. Overwriting is not recommended.")
            end
            local initialValue = defaultValue
            -- Check loaded config for this flag
            if loadedConfig and loadedConfig.Elements and loadedConfig.Elements[flagName] then
                 local loadedElement = loadedConfig.Elements[flagName]
                 -- Basic type check (and Color3 check)
                 if type(loadedElement.Value) == type(defaultValue) or (typeof(defaultValue) == "Color3" and typeof(loadedElement.Value) == "Color3") then
                     initialValue = loadedElement.Value
                 else
                     warn("LuminaUI: Mismatched type for loaded flag '" .. flagName .. "'. Using default.")
                 end
            end
            LuminaUI.Flags[flagName] = { Value = initialValue, Type = elementType, Default = defaultValue }
            return initialValue
        end

        -- ========================================================================
        -- Element Creation Methods Start Here
        -- ========================================================================

        -- CreateButton (Refactored with Theme Update)
        function Tab:CreateButton(options)
            options = options or {}
            local buttonName = options.Name or "Button"
            local callback = options.Callback or function() print(buttonName .. " clicked") end
            local icon = options.Icon
            local tooltip = options.Tooltip

            local elementHeight = 36
            local elementPadding = 10
            local iconSize = 20

            local updateTheme = function(instance)
                instance.BackgroundColor3 = SelectedTheme.ElementBackground
                local stroke = instance:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = SelectedTheme.ElementStroke end
                local iconLabel = instance:FindFirstChild("Icon")
                if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
                local label = instance:FindFirstChild("Label")
                if label then label.TextColor3 = SelectedTheme.TextColor end
            end

            local ButtonFrame = Utility.createInstance("Frame", {
                Name = "Button_" .. buttonName:gsub("%s+", "_"), Size = UDim2.new(1, 0, 0, elementHeight),
                BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #TabPage:GetChildren() + 1, Parent = TabPage
            }, "Button", updateTheme) -- Track Button
            Utility.createCorner(ButtonFrame, 4)
            local stroke = Utility.createStroke(ButtonFrame, SelectedTheme.ElementStroke, 1)

            local textXOffset = elementPadding
-- ...existing code...
if icon then
    local ButtonIcon = Utility.createInstance("ImageLabel", {
        Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
        ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = ButtonFrame
    })
    textXOffset = elementPadding + iconSize + 8 -- Add padding
end

local ButtonLabel = Utility.createInstance("TextLabel", {
   Name = "Label", Size = UDim2.new(1, -(textXOffset + elementPadding), 1, 0), Position = UDim2.new(0, textXOffset, 0, 0),
   BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = buttonName, TextColor3 = SelectedTheme.TextColor,
   TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = ButtonFrame
})

local ButtonInteract = Utility.createInstance("TextButton", {
   Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = ButtonFrame
})

-- Effects & Callback
Utility.Connect(ButtonInteract.MouseEnter, function()
   TweenService:Create(ButtonFrame, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
   stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled
   if tooltip then Utility.showTooltip(tooltip) end
end)
Utility.Connect(ButtonInteract.MouseLeave, function()
   TweenService:Create(ButtonFrame, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
   stroke.Color = SelectedTheme.ElementStroke
   if tooltip then Utility.hideTooltip() end
end)
Utility.Connect(ButtonInteract.MouseButton1Down, function()
    TweenService:Create(ButtonFrame, TweenInfo.new(0.1), { BackgroundColor3 = SelectedTheme.ElementBackgroundActive or Utility.darker(SelectedTheme.ElementBackgroundHover, 0.1) }):Play()
    Utility.rippleEffect(ButtonFrame, Utility.lighter(SelectedTheme.ElementBackgroundHover, 0.2))
end)
Utility.Connect(ButtonInteract.MouseButton1Up, function()
    TweenService:Create(ButtonFrame, TweenInfo.new(0.1), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
end)
Utility.Connect(ButtonInteract.MouseButton1Click, function()
   -- Execute callback in protected call
   local success, err = pcall(callback)
   if not success then warn("LuminaUI Button Error:", err) end
end)

Tab.Elements[buttonName] = { Instance = ButtonFrame, Type = "Button" }
return ButtonFrame -- Return instance for potential direct manipulation
end

-- CreateToggle (Refactored with Theme Update)
function Tab:CreateToggle(options)
options = options or {}
local toggleName = options.Name or "Toggle"
local flag = options.Flag -- Mandatory flag name
local defaultValue = options.Default or false
local callback = options.Callback or function(value) print(toggleName .. " set to " .. tostring(value)) end
local icon = options.Icon
local tooltip = options.Tooltip

if not flag then warn("LuminaUI: Toggle '" .. toggleName .. "' requires a 'Flag' option."); return end

local initialValue = registerFlag(flag, defaultValue, "Toggle")

local elementHeight = 36
local elementPadding = 10
local iconSize = 20
local toggleWidth = 40
local toggleHeight = 20
local knobSize = 16

local updateTheme = function(instance)
   local toggleSwitch = instance:FindFirstChild("ToggleSwitch")
   local knob = toggleSwitch and toggleSwitch:FindFirstChild("Knob")
   local iconLabel = instance:FindFirstChild("Icon")
   local label = instance:FindFirstChild("Label")
   local stroke = instance:FindFirstChildOfClass("UIStroke")

   instance.BackgroundColor3 = SelectedTheme.ElementBackground
   if stroke then stroke.Color = SelectedTheme.ElementStroke end
   if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
   if label then label.TextColor3 = SelectedTheme.TextColor end

   -- Update toggle colors based on current state
   local currentValue = LuminaUI.Flags[flag].Value
   if toggleSwitch then
       toggleSwitch.BackgroundColor3 = currentValue and (SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled) or SelectedTheme.ToggleDisabled
   end
   if knob then
       knob.BackgroundColor3 = SelectedTheme.TextColor -- Knob color usually constant
   end
end

local ToggleFrame = Utility.createInstance("Frame", {
   Name = "Toggle_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
   BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #TabPage:GetChildren() + 1, Parent = TabPage
}, "Toggle", updateTheme) -- Track Toggle
Utility.createCorner(ToggleFrame, 4)
local stroke = Utility.createStroke(ToggleFrame, SelectedTheme.ElementStroke, 1)

local textXOffset = elementPadding
if icon then
    local ToggleIcon = Utility.createInstance("ImageLabel", {
        Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
        ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = ToggleFrame
    })
    textXOffset = elementPadding + iconSize + 8
end

local ToggleLabel = Utility.createInstance("TextLabel", {
   Name = "Label", Size = UDim2.new(1, -(textXOffset + elementPadding + toggleWidth + 10), 1, 0), -- Adjust width for toggle switch
   Position = UDim2.new(0, textXOffset, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
   Text = toggleName, TextColor3 = SelectedTheme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = ToggleFrame
})

-- Toggle Switch Visual
local ToggleSwitch = Utility.createInstance("Frame", {
   Name = "ToggleSwitch", Size = UDim2.new(0, toggleWidth, 0, toggleHeight), Position = UDim2.new(1, -elementPadding, 0.5, 0),
   AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = initialValue and (SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled) or SelectedTheme.ToggleDisabled,
   Parent = ToggleFrame
})
Utility.createCorner(ToggleSwitch, toggleHeight / 2)

local ToggleKnob = Utility.createInstance("Frame", {
   Name = "Knob", Size = UDim2.new(0, knobSize, 0, knobSize), Position = initialValue and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
   AnchorPoint = initialValue and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), BackgroundColor3 = SelectedTheme.TextColor,
   Parent = ToggleSwitch
})
Utility.createCorner(ToggleKnob, knobSize / 2)

local ToggleInteract = Utility.createInstance("TextButton", {
   Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = ToggleFrame
})

-- Toggle Logic
local function setToggleState(newState, triggerCallback)
   triggerCallback = triggerCallback == nil and true or triggerCallback -- Default to true
   local oldState = LuminaUI.Flags[flag].Value
   if oldState == newState then return end -- No change

   LuminaUI.Flags[flag].Value = newState

   local targetColor = newState and (SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled) or SelectedTheme.ToggleDisabled
   local targetKnobPos = newState and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
   local targetKnobAnchor = newState and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)

   local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
   TweenService:Create(ToggleSwitch, tweenInfo, { BackgroundColor3 = targetColor }):Play()
   TweenService:Create(ToggleKnob, tweenInfo, { Position = targetKnobPos, AnchorPoint = targetKnobAnchor }):Play()

   if triggerCallback then
       local success, err = pcall(callback, newState)
       if not success then warn("LuminaUI Toggle Error:", err) end
   end
end

-- Effects & Callback
Utility.Connect(ToggleInteract.MouseEnter, function()
   TweenService:Create(ToggleFrame, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
   stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled
   if tooltip then Utility.showTooltip(tooltip) end
end)
Utility.Connect(ToggleInteract.MouseLeave, function()
   TweenService:Create(ToggleFrame, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
   stroke.Color = SelectedTheme.ElementStroke
   if tooltip then Utility.hideTooltip() end
end)
Utility.Connect(ToggleInteract.MouseButton1Click, function()
   setToggleState(not LuminaUI.Flags[flag].Value) -- Toggle state and trigger callback
end)

-- API to update toggle state externally
local ToggleAPI = {
   Instance = ToggleFrame,
   Type = "Toggle",
   Flag = flag,
   SetValue = function(newValue)
       setToggleState(newValue, false) -- Set value without triggering callback
   end,
   GetValue = function()
       return LuminaUI.Flags[flag].Value
   end
}
Tab.Elements[flag] = ToggleAPI -- Store API under flag name

return ToggleAPI
end

-- CreateSlider (Refactored with Theme Update)
function Tab:CreateSlider(options)
options = options or {}
local sliderName = options.Name or "Slider"
local flag = options.Flag -- Mandatory flag name
local min = options.Min or 0
local max = options.Max or 100
local step = options.Step or 1 -- Increment value
local defaultValue = options.Default or min
local units = options.Units or "" -- e.g., "%", "ms"
local callback = options.Callback or function(value) print(sliderName .. " set to " .. value) end
local icon = options.Icon
local tooltip = options.Tooltip

if not flag then warn("LuminaUI: Slider '" .. sliderName .. "' requires a 'Flag' option."); return end

-- Clamp default value and ensure it aligns with step
defaultValue = math.clamp(defaultValue, min, max)
defaultValue = math.floor((defaultValue - min) / step + 0.5) * step + min -- Snap to nearest step

local initialValue = registerFlag(flag, defaultValue, "Slider")

local elementHeight = 50 -- Taller for slider
local elementPadding = 10
local iconSize = 20
local sliderHeight = 6
local knobSize = 14

local updateTheme = function(instance)
   local sliderTrack = instance:FindFirstChild("SliderTrack")
   local progress = sliderTrack and sliderTrack:FindFirstChild("Progress")
   local knob = sliderTrack and sliderTrack:FindFirstChild("Knob")
   local iconLabel = instance:FindFirstChild("Icon")
   local label = instance:FindFirstChild("Label")
   local valueLabel = instance:FindFirstChild("ValueLabel")
   local stroke = instance:FindFirstChildOfClass("UIStroke")

   instance.BackgroundColor3 = SelectedTheme.ElementBackground
   if stroke then stroke.Color = SelectedTheme.ElementStroke end
   if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
   if label then label.TextColor3 = SelectedTheme.TextColor end
   if valueLabel then valueLabel.TextColor3 = SelectedTheme.SubTextColor end

   if sliderTrack then sliderTrack.BackgroundColor3 = SelectedTheme.SliderBackground end
   if progress then progress.BackgroundColor3 = SelectedTheme.AccentColor or SelectedTheme.SliderProgress end
   if knob then knob.BackgroundColor3 = SelectedTheme.TextColor end -- Knob color usually constant
end

local SliderFrame = Utility.createInstance("Frame", {
   Name = "Slider_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
   BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #TabPage:GetChildren() + 1, Parent = TabPage
}, "Slider", updateTheme) -- Track Slider
Utility.createCorner(SliderFrame, 4)
local stroke = Utility.createStroke(SliderFrame, SelectedTheme.ElementStroke, 1)

local topRowHeight = 20
local bottomRowY = topRowHeight + 5

-- Icon (Top Row)
local textXOffset = elementPadding
if icon then
    local SliderIcon = Utility.createInstance("ImageLabel", {
        Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0, topRowHeight / 2),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
        ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = SliderFrame
    })
    textXOffset = elementPadding + iconSize + 8
end

-- Label (Top Row)
local SliderLabel = Utility.createInstance("TextLabel", {
   Name = "Label", Size = UDim2.new(0.6, 0, 0, topRowHeight), Position = UDim2.new(0, textXOffset, 0, 0),
   BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = sliderName, TextColor3 = SelectedTheme.TextColor,
   TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Parent = SliderFrame
})

-- Value Label (Top Row)
local ValueLabel = Utility.createInstance("TextLabel", {
   Name = "ValueLabel", Size = UDim2.new(0.4, -elementPadding, 0, topRowHeight), Position = UDim2.new(1, -elementPadding, 0, 0),
   AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "", -- Updated later
   TextColor3 = SelectedTheme.SubTextColor, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, TextYAlignment = Enum.TextYAlignment.Center, Parent = SliderFrame
})

-- Slider Track (Bottom Row)
local SliderTrack = Utility.createInstance("Frame", {
   Name = "SliderTrack", Size = UDim2.new(1, -(elementPadding * 2), 0, sliderHeight), Position = UDim2.new(0.5, 0, 0, bottomRowY + sliderHeight / 2),
   AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = SelectedTheme.SliderBackground, Parent = SliderFrame
})
Utility.createCorner(SliderTrack, sliderHeight / 2)

-- Progress Bar
local Progress = Utility.createInstance("Frame", {
   Name = "Progress", Size = UDim2.new(0, 0, 1, 0), -- Width updated later
   BackgroundColor3 = SelectedTheme.AccentColor or SelectedTheme.SliderProgress, Parent = SliderTrack
})
Utility.createCorner(Progress, sliderHeight / 2)

-- Knob
local Knob = Utility.createInstance("Frame", {
   Name = "Knob", Size = UDim2.new(0, knobSize, 0, knobSize), Position = UDim2.new(0, 0, 0.5, 0), -- X updated later
   AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = SelectedTheme.TextColor, Parent = SliderTrack
})
Utility.createCorner(Knob, knobSize / 2)

-- Slider Logic
local isDragging = false
local function updateSlider(newValue, triggerCallback)
   triggerCallback = triggerCallback == nil and true or triggerCallback -- Default to true

   -- Clamp and snap to step
   newValue = math.clamp(newValue, min, max)
   newValue = math.floor((newValue - min) / step + 0.5) * step + min

   local oldValue = LuminaUI.Flags[flag].Value
   if oldValue == newValue then return end -- No change

   LuminaUI.Flags[flag].Value = newValue

   -- Update visuals
   local percent = (newValue - min) / (max - min)
   if max == min then percent = 0 end -- Avoid division by zero

   Progress.Size = UDim2.new(percent, 0, 1, 0)
   Knob.Position = UDim2.new(percent, 0, 0.5, 0)
   ValueLabel.Text = Utility.formatNumber(newValue, step < 1 and 1 or 0) .. units -- Show decimal if step is fractional

   if triggerCallback then
       local success, err = pcall(callback, newValue)
       if not success then warn("LuminaUI Slider Error:", err) end
   end
end

-- Initial update
updateSlider(initialValue, false)

-- Interaction
local SliderInteract = Utility.createInstance("TextButton", {
   Name = "Interact", Size = UDim2.new(1, 0, 0, elementHeight - bottomRowY + knobSize), -- Cover track and knob area
   Position = UDim2.new(0, 0, 0, bottomRowY - knobSize/2), BackgroundTransparency = 1, Text = "", ZIndex = 2, Parent = SliderFrame
})

local function handleInput(input)
   local mouseX = input.Position.X
   local trackStartX = SliderTrack.AbsolutePosition.X
   local trackWidth = SliderTrack.AbsoluteSize.X

   local relativeX = math.clamp((mouseX - trackStartX) / trackWidth, 0, 1)
   local newValue = min + relativeX * (max - min)
   updateSlider(newValue) -- Update and trigger callback
end

Utility.Connect(SliderInteract.InputBegan, function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton1 then
       isDragging = true
       handleInput(input) -- Update on initial click
       Utility.pulseEffect(Knob, 1.2, 0.1)
       if tooltip then Utility.showTooltip(tooltip) end
       -- Prevent text selection while dragging
       UserInputService.TextSelectionEnabled = false
   end
end)

Utility.Connect(UserInputService.InputEnded, function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton1 and isDragging then
       isDragging = false
       if tooltip then Utility.hideTooltip() end
       -- Re-enable text selection
       UserInputService.TextSelectionEnabled = true
   end
end)

Utility.Connect(UserInputService.InputChanged, function(input)
   if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
       handleInput(input)
   end
end)

-- Hover effect on the main frame
Utility.Connect(SliderFrame.MouseEnter, function()
    stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled
end)
Utility.Connect(SliderFrame.MouseLeave, function()
    if not isDragging then stroke.Color = SelectedTheme.ElementStroke end
end)

-- API to update slider state externally
local SliderAPI = {
   Instance = SliderFrame,
   Type = "Slider",
   Flag = flag,
   SetValue = function(newValue)
       updateSlider(newValue, false) -- Set value without triggering callback
   end,
   GetValue = function()
       return LuminaUI.Flags[flag].Value
   end
}
Tab.Elements[flag] = SliderAPI -- Store API under flag name

return SliderAPI
end

-- CreateDropdown (Refactored with Theme Update)
function Tab:CreateDropdown(options)
options = options or {}
local dropdownName = options.Name or "Dropdown"
local flag = options.Flag -- Mandatory flag name
local values = options.Values or {} -- List of strings
local defaultValue = options.Default or (values[1] or "")
local allowMultiSelect = options.MultiSelect or false
local callback = options.Callback or function(value) print(dropdownName .. " selected: " .. table.concat(value, ", ")) end
local icon = options.Icon
local tooltip = options.Tooltip

if not flag then warn("LuminaUI: Dropdown '" .. dropdownName .. "' requires a 'Flag' option."); return end
if #values == 0 then warn("LuminaUI: Dropdown '" .. dropdownName .. "' has no values."); return end

-- Validate default value(s)
local initialValue
if allowMultiSelect then
   defaultValue = type(defaultValue) == "table" and defaultValue or {defaultValue}
   initialValue = {}
   for _, v in ipairs(defaultValue) do
       if table.find(values, v) then table.insert(initialValue, v) end
   end
   if #initialValue == 0 and #values > 0 then initialValue = {} end -- Default to empty if invalid default provided
else
   if not table.find(values, defaultValue) then defaultValue = values[1] end
   initialValue = defaultValue
end

local currentValue = registerFlag(flag, initialValue, "Dropdown")

local elementHeight = 36
local elementPadding = 10
local iconSize = 20
local arrowSize = 12
local dropdownOpen = false
local dropdownList = nil -- Instance reference

local updateTheme = function(instance)
   local arrow = instance:FindFirstChild("Arrow")
   local iconLabel = instance:FindFirstChild("Icon")
   local label = instance:FindFirstChild("Label")
   local valueLabel = instance:FindFirstChild("ValueLabel")
   local stroke = instance:FindFirstChildOfClass("UIStroke")

   instance.BackgroundColor3 = SelectedTheme.ElementBackground
   if stroke then stroke.Color = SelectedTheme.ElementStroke end
   if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
   if label then label.TextColor3 = SelectedTheme.TextColor end
   if valueLabel then valueLabel.TextColor3 = SelectedTheme.SubTextColor end
   if arrow then arrow.ImageColor3 = SelectedTheme.SubTextColor end

   -- Update dropdown list theme if open
   if dropdownList and dropdownList.Parent then
       dropdownList.BackgroundColor3 = SelectedTheme.DropdownUnselected
       local listStroke = dropdownList:FindFirstChildOfClass("UIStroke")
       if listStroke then listStroke.Color = SelectedTheme.ElementStroke end
       -- Update individual option themes
       for _, optionFrame in ipairs(dropdownList.ListFrame:GetChildren()) do
           if optionFrame:IsA("Frame") then
               local optionLabel = optionFrame:FindFirstChild("Label")
               local checkmark = optionFrame:FindFirstChild("Checkmark")
               local isSelected = false
               if allowMultiSelect then
                   isSelected = table.find(LuminaUI.Flags[flag].Value, optionLabel.Text)
               else
                   isSelected = LuminaUI.Flags[flag].Value == optionLabel.Text
               end

               optionFrame.BackgroundColor3 = isSelected and SelectedTheme.DropdownSelected or SelectedTheme.DropdownUnselected
               if optionLabel then optionLabel.TextColor3 = SelectedTheme.TextColor end
               if checkmark then
                   checkmark.ImageColor3 = SelectedTheme.TextColor
                   checkmark.Visible = isSelected
               end
           end
       end
   end
end

local DropdownFrame = Utility.createInstance("Frame", {
   Name = "Dropdown_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
   BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #TabPage:GetChildren() + 1, Parent = TabPage,
   ClipsDescendants = false -- Allow dropdown list to show
}, "Dropdown", updateTheme) -- Track Dropdown
Utility.createCorner(DropdownFrame, 4)
local stroke = Utility.createStroke(DropdownFrame, SelectedTheme.ElementStroke, 1)

local textXOffset = elementPadding
if icon then
    local DropdownIcon = Utility.createInstance("ImageLabel", {
        Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
        ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = DropdownFrame
    })
    textXOffset = elementPadding + iconSize + 8
end

-- Label
local DropdownLabel = Utility.createInstance("TextLabel", {
   Name = "Label", Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, textXOffset, 0, 0),
   BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = dropdownName, TextColor3 = SelectedTheme.TextColor,
   TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = DropdownFrame
})

-- Value Label (Shows selected value/count)
local ValueLabel = Utility.createInstance("TextLabel", {
   Name = "ValueLabel", Size = UDim2.new(0.5, -(elementPadding + arrowSize + 5 + elementPadding), 1, 0), Position = UDim2.new(1, -(elementPadding + arrowSize + 5), 0, 0),
   AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "", -- Updated later
   TextColor3 = SelectedTheme.SubTextColor, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = DropdownFrame
})

-- Arrow Icon
local Arrow = Utility.createInstance("ImageLabel", {
   Name = "Arrow", Size = UDim2.new(0, arrowSize, 0, arrowSize), Position = UDim2.new(1, -elementPadding, 0.5, 0),
   AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://6035048680", -- Chevron down
   ImageColor3 = SelectedTheme.SubTextColor, Rotation = 0, Parent = DropdownFrame
})

-- Interaction Button
local DropdownInteract = Utility.createInstance("TextButton", {
   Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 1, Parent = DropdownFrame
})

-- Function to update the displayed value text
local function updateValueLabel()
   local currentVal = LuminaUI.Flags[flag].Value
   if allowMultiSelect then
       local count = #currentVal
       ValueLabel.Text = count .. (#values == count and " (All)" or " Selected")
   else
       ValueLabel.Text = currentVal
   end
end
updateValueLabel() -- Initial update

-- Function to create/destroy the dropdown list
local function toggleDropdownList(forceClose)
   if dropdownOpen and not forceClose then -- Close it
       dropdownOpen = false
       TweenService:Create(Arrow, TweenInfo.new(0.2), { Rotation = 0 }):Play()
       if dropdownList and dropdownList.Parent then
           local listTween = TweenService:Create(dropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 })
           listTween:Play()
           Utility.Connect(listTween.Completed, function()
               Utility.destroyInstance(dropdownList)
               dropdownList = nil
           end)
       end
       stroke.Color = SelectedTheme.ElementStroke -- Reset stroke on close
       if tooltip then Utility.hideTooltip() end -- Hide tooltip when closing

   elseif not dropdownOpen and not forceClose then -- Open it
       dropdownOpen = true
       TweenService:Create(Arrow, TweenInfo.new(0.2), { Rotation = 180 }):Play()
       stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled -- Highlight stroke when open

       local listHeight = math.min(#values * 30 + 10, 160) -- Max height 160px
       local listYPos = elementHeight + 2

       -- Theme update function for the list itself
       local updateListTheme = function(instance)
           instance.BackgroundColor3 = SelectedTheme.DropdownUnselected
           local listStroke = instance:FindFirstChildOfClass("UIStroke")
           if listStroke then listStroke.Color = SelectedTheme.ElementStroke end
           -- Option updates are handled by the main dropdown updateTheme
       end

       dropdownList = Utility.createInstance("Frame", {
           Name = "DropdownList", Size = UDim2.new(1, 0, 0, 0), -- Start height 0 for animation
           Position = UDim2.new(0, 0, 0, listYPos), BackgroundColor3 = SelectedTheme.DropdownUnselected,
           BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 100, Parent = DropdownFrame
       }, "DropdownListContainer", updateListTheme) -- Track list container
       Utility.createCorner(dropdownList, 4)
       Utility.createStroke(dropdownList, SelectedTheme.ElementStroke, 1)

       local listScroll = Utility.createInstance("ScrollingFrame", {
           Name = "ListFrame", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
           CanvasSize = UDim2.new(0, 0, 0, #values * 30), ScrollBarThickness = 4, Parent = dropdownList
       })
       Utility.applyCustomScrollbar(listScroll, 4) -- Apply thin scrollbar

       local listLayout = Utility.createInstance("UIListLayout", {
           Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder, Parent = listScroll
       })
       local listPadding = Utility.createInstance("UIPadding", {
           PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5),
           PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), Parent = listScroll
       })

       -- Create options
       for i, value in ipairs(values) do
           local isSelected
           if allowMultiSelect then
               isSelected = table.find(LuminaUI.Flags[flag].Value, value)
           else
               isSelected = LuminaUI.Flags[flag].Value == value
           end

           local OptionFrame = Utility.createInstance("Frame", {
               Name = "Option_" .. value:gsub("%s+", "_"), Size = UDim2.new(1, 0, 0, 30),
               BackgroundColor3 = isSelected and SelectedTheme.DropdownSelected or SelectedTheme.DropdownUnselected,
               LayoutOrder = i, Parent = listScroll
           })
           Utility.createCorner(OptionFrame, 3)

           local OptionLabel = Utility.createInstance("TextLabel", {
               Name = "Label", Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 10, 0, 0),
               BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = value, TextColor3 = SelectedTheme.TextColor,
               TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = OptionFrame
           })

           local Checkmark = nil
           if allowMultiSelect then
               Checkmark = Utility.createInstance("ImageLabel", {
                   Name = "Checkmark", Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -15, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
                   BackgroundTransparency = 1, Image = "rbxassetid://6031280882", -- Checkmark/Settings icon placeholder
                   ImageColor3 = SelectedTheme.TextColor, Visible = isSelected, Parent = OptionFrame
               })
           end

           local OptionInteract = Utility.createInstance("TextButton", {
               Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = OptionFrame
           })

           -- Option Interaction
           Utility.Connect(OptionInteract.MouseEnter, function()
               OptionFrame.BackgroundColor3 = SelectedTheme.ElementBackgroundHover
           end)
           Utility.Connect(OptionInteract.MouseLeave, function()
               local currentVal = LuminaUI.Flags[flag].Value
               local stillSelected
               if allowMultiSelect then stillSelected = table.find(currentVal, value) else stillSelected = currentVal == value end
               OptionFrame.BackgroundColor3 = stillSelected and SelectedTheme.DropdownSelected or SelectedTheme.DropdownUnselected
           end)
           Utility.Connect(OptionInteract.MouseButton1Click, function()
               local currentVal = LuminaUI.Flags[flag].Value
               local newValue
               if allowMultiSelect then
                   newValue = {} -- Create a new table for the updated selection
                   local found = false
                   for _, existingValue in ipairs(currentVal) do
                       if existingValue == value then
                           found = true
                       else
                           table.insert(newValue, existingValue)
                       end
                   end
                   if not found then
                       table.insert(newValue, value) -- Add if not found
                   end
                   table.sort(newValue) -- Keep it sorted (optional)
               else
                   newValue = value
               end

               -- Update flag and visuals
               LuminaUI.Flags[flag].Value = newValue
               updateValueLabel()
               updateTheme(DropdownFrame) -- Update all visuals including options

               -- Trigger callback
               local success, err = pcall(callback, newValue)
               if not success then warn("LuminaUI Dropdown Error:", err) end

               -- Close dropdown if not multi-select
               if not allowMultiSelect then
                   toggleDropdownList()
               end
           end)
       end

       -- Animate list open
       local listTween = TweenService:Create(dropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, listHeight), BackgroundTransparency = 0 })
       listTween:Play()
   end
end

-- Effects & Callback for main dropdown button
Utility.Connect(DropdownInteract.MouseEnter, function()
   if not dropdownOpen then
       TweenService:Create(DropdownFrame, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
       stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled
   end
   if tooltip then Utility.showTooltip(tooltip) end
end)
Utility.Connect(DropdownInteract.MouseLeave, function()
   if not dropdownOpen then
       TweenService:Create(DropdownFrame, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
       stroke.Color = SelectedTheme.ElementStroke
   end
    if tooltip then Utility.hideTooltip() end
end)
Utility.Connect(DropdownInteract.MouseButton1Click, function()
   toggleDropdownList()
end)

-- Close dropdown if clicked outside
local function checkClickOutside(input)
   if not dropdownOpen or not dropdownList or not dropdownList.Parent then return end

   local mousePos = input.Position
   local framePos = DropdownFrame.AbsolutePosition
   local frameSize = DropdownFrame.AbsoluteSize
   local listPos = dropdownList.AbsolutePosition
   local listSize = dropdownList.AbsoluteSize

   -- Check if click is outside both the main frame and the list
   local inFrame = mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y
   local inList = mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X and mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y

   if not inFrame and not inList then
       toggleDropdownList(true) -- Force close
   end
end
-- Use InputBegan on UserInputService for more reliable outside click detection
local clickOutsideConnection = Utility.Connect(UserInputService.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        checkClickOutside(input)
    end
end)
-- Disconnect this listener when the dropdown is destroyed (handled by Utility.destroyInstance)
Utility.storeConnection(DropdownFrame, clickOutsideConnection)


-- API to update dropdown state externally
local DropdownAPI = {
   Instance = DropdownFrame,
   Type = "Dropdown",
   Flag = flag,
   SetValue = function(newValue)
       -- Validate input based on multi-select
       local validValue
       if allowMultiSelect then
           validValue = {}
           newValue = type(newValue) == "table" and newValue or {newValue}
           for _, v in ipairs(newValue) do
               if table.find(values, v) then table.insert(validValue, v) end
           end
           table.sort(validValue)
       else
           if table.find(values, newValue) then
               validValue = newValue
           else
               warn("LuminaUI: Invalid value '"..tostring(newValue).."' for Dropdown '"..flag.."'. Setting to default.")
               validValue = values[1] -- Set to first option if invalid
           end
       end

       LuminaUI.Flags[flag].Value = validValue
       updateValueLabel()
       updateTheme(DropdownFrame) -- Update visuals
   end,
   GetValue = function()
       return LuminaUI.Flags[flag].Value
   end,
   SetValues = function(newValues) -- Function to update the list of options
       if type(newValues) ~= "table" then warn("LuminaUI: SetValues requires a table."); return end
       values = newValues
       -- Reset selection to default or first item if current selection is no longer valid
       local currentSelection = LuminaUI.Flags[flag].Value
       local newSelection
       if allowMultiSelect then
           newSelection = {}
           for _, v in ipairs(currentSelection) do
               if table.find(values, v) then table.insert(newSelection, v) end
           end
           table.sort(newSelection)
       else
           if not table.find(values, currentSelection) then
               newSelection = #values > 0 and values[1] or ""
           else
               newSelection = currentSelection
           end
       end
       LuminaUI.Flags[flag].Value = newSelection
       updateValueLabel()
       -- Rebuild dropdown if open
       if dropdownOpen then
           toggleDropdownList(true) -- Close first
           -- Optionally reopen immediately? toggleDropdownList()
       end
       updateTheme(DropdownFrame) -- Update visuals
   end
}
Tab.Elements[flag] = DropdownAPI -- Store API under flag name

return DropdownAPI
end

-- CreateTextbox (Refactored with Theme Update)
function Tab:CreateTextbox(options)
options = options or {}
local textboxName = options.Name or "Textbox"
local flag = options.Flag -- Mandatory flag name
local defaultValue = options.Default or ""
local placeholder = options.Placeholder or "Enter text..."
local clearOnFocus = options.ClearOnFocus or false -- Whether to clear placeholder on focus
local numeric = options.Numeric or false -- Only allow numbers (and optionally '.')
local maxLength = options.MaxLength or 100 -- Max input length
local callback = options.Callback or function(value) print(textboxName .. " text: " .. value) end
local finishedCallback = options.FinishedCallback or callback -- Called on FocusLost
local icon = options.Icon
local tooltip = options.Tooltip

if not flag then warn("LuminaUI: Textbox '" .. textboxName .. "' requires a 'Flag' option."); return end

local initialValue = registerFlag(flag, defaultValue, "Textbox")

local elementHeight = 36
local elementPadding = 10
local iconSize = 20

local updateTheme = function(instance)
   local textbox = instance:FindFirstChild("Input")
   local iconLabel = instance:FindFirstChild("Icon")
   local stroke = instance:FindFirstChildOfClass("UIStroke")

   instance.BackgroundColor3 = SelectedTheme.InputBackground
   if stroke then stroke.Color = SelectedTheme.InputStroke end
   if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end

   if textbox then
       textbox.TextColor3 = SelectedTheme.TextColor
       textbox.PlaceholderColor3 = SelectedTheme.InputPlaceholder
       -- Re-apply placeholder if needed (tricky, might need state tracking)
   end
end

local TextboxFrame = Utility.createInstance("Frame", {
   Name = "Textbox_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
   BackgroundColor3 = SelectedTheme.InputBackground, LayoutOrder = #TabPage:GetChildren() + 1, Parent = TabPage
}, "Textbox", updateTheme) -- Track Textbox
Utility.createCorner(TextboxFrame, 4)
local stroke = Utility.createStroke(TextboxFrame, SelectedTheme.InputStroke, 1)

local textXOffset = elementPadding
if icon then
    local TextboxIcon = Utility.createInstance("ImageLabel", {
        Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
        ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = TextboxFrame
    })
    textXOffset = elementPadding + iconSize + 8
end

local InputBox = Utility.createInstance("TextBox", {
   Name = "Input", Size = UDim2.new(1, -(textXOffset + elementPadding), 1, -6), -- Padding top/bottom
   Position = UDim2.new(0, textXOffset, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
   BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = initialValue, TextColor3 = SelectedTheme.TextColor,
   TextSize = 13, PlaceholderText = placeholder, PlaceholderColor3 = SelectedTheme.InputPlaceholder,
   ClearTextOnFocus = clearOnFocus, TextXAlignment = Enum.TextXAlignment.Left, MultiLine = false,
   Parent = TextboxFrame
})

-- Numeric filtering
if numeric then
   Utility.Connect(InputBox:GetPropertyChangedSignal("Text"), function()
       local text = InputBox.Text
       local filtered = text:gsub("[^%d%.%-]", "") -- Allow digits, period, minus
       -- Ensure only one decimal point and minus at the start
       local minusCount = 0
       local decimalCount = 0
       local finalFiltered = ""
       for i = 1, #filtered do
           local char = filtered:sub(i, i)
           if char == "-" then
               if i == 1 and minusCount == 0 then
                   finalFiltered = finalFiltered .. char
                   minusCount = minusCount + 1
               end
           elseif char == "." then
               if decimalCount == 0 then
                   finalFiltered = finalFiltered .. char
                   decimalCount = decimalCount + 1
               end
           else
               finalFiltered = finalFiltered .. char
           end
       end

       if InputBox.Text ~= finalFiltered then
           InputBox.Text = finalFiltered
       end
   end)
end

-- Max length handling (simple truncation)
if maxLength > 0 then
    Utility.Connect(InputBox:GetPropertyChangedSignal("Text"), function()
       if string.len(InputBox.Text) > maxLength then
           InputBox.Text = string.sub(InputBox.Text, 1, maxLength)
       end
   end)
end

-- Callbacks
Utility.Connect(InputBox:GetPropertyChangedSignal("Text"), function()
   local newValue = InputBox.Text
   if numeric and newValue ~= "" and newValue ~= "-" and newValue ~= "." and newValue ~= "-." then
       newValue = tonumber(newValue) or 0 -- Convert to number if possible
   end
   if LuminaUI.Flags[flag].Value ~= newValue then
       LuminaUI.Flags[flag].Value = newValue
       local success, err = pcall(callback, newValue)
       if not success then warn("LuminaUI Textbox Error:", err) end
   end
end)

Utility.Connect(InputBox.FocusLost, function(enterPressed)
   if enterPressed then
       local newValue = InputBox.Text
       if numeric and newValue ~= "" and newValue ~= "-" and newValue ~= "." and newValue ~= "-." then
           newValue = tonumber(newValue) or 0
       end
       -- Ensure flag is updated before calling finishedCallback
       if LuminaUI.Flags[flag].Value ~= newValue then
            LuminaUI.Flags[flag].Value = newValue
            -- Call regular callback too if value changed on focus lost
            local cb_success, cb_err = pcall(callback, newValue)
            if not cb_success then warn("LuminaUI Textbox Error:", cb_err) end
       end
       -- Call finished callback
       local success, err = pcall(finishedCallback, newValue)
       if not success then warn("LuminaUI Textbox Finish Error:", err) end
   end
   -- Reset placeholder if needed and box is empty
   if InputBox.Text == "" then
       InputBox.ClearTextOnFocus = clearOnFocus -- Reset property just in case
   end
   stroke.Color = SelectedTheme.InputStroke -- Reset stroke color
   if tooltip then Utility.hideTooltip() end
end)

Utility.Connect(InputBox.Focused, function()
   stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled -- Highlight on focus
   if tooltip then Utility.showTooltip(tooltip) end
end)

-- API to update textbox state externally
local TextboxAPI = {
   Instance = TextboxFrame,
   Type = "Textbox",
   Flag = flag,
   SetValue = function(newValue)
       InputBox.Text = tostring(newValue) -- Update TextBox text
       -- Flag will be updated by the TextChanged signal
   end,
   GetValue = function()
       return LuminaUI.Flags[flag].Value
   end,
   Focus = function() InputBox:CaptureFocus() end,
   Unfocus = function() InputBox:ReleaseFocus() end
}
Tab.Elements[flag] = TextboxAPI -- Store API under flag name

return TextboxAPI
end

-- CreateLabel (Refactored with Theme Update)
function Tab:CreateLabel(options)
options = options or {}
local text = options.Name or "Label Text" -- Use Name as text if Text not provided
text = options.Text or text
local size = options.Size or 13
local alignment = options.Alignment or Enum.TextXAlignment.Left
local wrap = options.Wrap or false
local icon = options.Icon

local elementPadding = 10
local iconSize = 16 -- Smaller icon for labels usually

local updateTheme = function(instance)
   local iconLabel = instance:FindFirstChild("Icon")
   local textLabel = instance:FindFirstChild("Text")
   if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
   if textLabel then textLabel.TextColor3 = SelectedTheme.TextColor end
end

-- Calculate required height if wrapping
local textBounds = Utility.getTextBounds(text, Enum.Font.Gotham, size, ElementsContainer.AbsoluteSize.X - (ElementsPadding.PaddingLeft.Offset + ElementsPadding.PaddingRight.Offset) - (icon and (iconSize + 8) or 0) - (elementPadding * 2))
local elementHeight = wrap and math.max(20, textBounds.Y + 10) or 20 -- Min height 20

local LabelFrame = Utility.createInstance("Frame", {
   Name = "Label_" .. text:gsub("%s+", "_"):sub(1, 20), -- Create somewhat unique name
   Size = UDim2.new(1, 0, 0, elementHeight), BackgroundTransparency = 1,
   LayoutOrder = #TabPage:GetChildren() + 1, Parent = TabPage
}, "Label", updateTheme) -- Track Label

local textXOffset = elementPadding
if icon then
    local LabelIcon = Utility.createInstance("ImageLabel", {
        Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
        ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = LabelFrame
    })
    textXOffset = elementPadding + iconSize + 8
end

local Text = Utility.createInstance("TextLabel", {
   Name = "Text", Size = UDim2.new(1, -(textXOffset + elementPadding), 1, 0), Position = UDim2.new(0, textXOffset, 0, 0),
   BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = text, TextColor3 = SelectedTheme.TextColor,
   TextSize = size, TextWrapped = wrap, TextXAlignment = alignment, TextYAlignment = Enum.TextYAlignment.Center, Parent = LabelFrame
})

-- API for label
local LabelAPI = {
   Instance = LabelFrame,
   Type = "Label",
   SetText = function(newText)
       Text.Text = newText
       -- Recalculate height if wrapping enabled
       if wrap then
           local newBounds = Utility.getTextBounds(newText, Text.Font, Text.TextSize, ElementsContainer.AbsoluteSize.X - (ElementsPadding.PaddingLeft.Offset + ElementsPadding.PaddingRight.Offset) - (icon and (iconSize + 8) or 0) - (elementPadding * 2))
           LabelFrame.Size = UDim2.new(1, 0, 0, math.max(20, newBounds.Y + 10))
       end
   end,
   SetIcon = function(newIconId)
        local iconLabel = LabelFrame:FindFirstChild("Icon")
        if newIconId then
            if iconLabel then
                iconLabel.Image = Utility.loadIcon(newIconId)
            else
                -- Create icon if it didn't exist
                iconLabel = Utility.createInstance("ImageLabel", {
                    Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(newIconId),
                    ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = LabelFrame
                })
                textXOffset = elementPadding + iconSize + 8
                Text.Position = UDim2.new(0, textXOffset, 0, 0)
                Text.Size = UDim2.new(1, -(textXOffset + elementPadding), 1, 0)
            end
        elseif iconLabel then
            -- Remove icon if newIconId is nil/false
            Utility.destroyInstance(iconLabel)
            textXOffset = elementPadding
            Text.Position = UDim2.new(0, textXOffset, 0, 0)
            Text.Size = UDim2.new(1, -(textXOffset + elementPadding), 1, 0)
        end
   end
}
Tab.Elements["Label_" .. text:gsub("%s+", "_"):sub(1, 20)] = LabelAPI -- Store API

return LabelAPI
end

-- CreateDivider (Refactored with Theme Update)
function Tab:CreateDivider(options)
options = options or {}
local thickness = options.Thickness or 1
local color = options.Color -- Optional override
local padding = options.Padding or 5 -- Vertical padding

local updateTheme = function(instance)
   instance.BackgroundColor3 = color or SelectedTheme.ElementStroke
   instance.BackgroundTransparency = color and 0 or 0.8 -- Make default less prominent
end

local DividerFrame = Utility.createInstance("Frame", {
   Name = "Divider", Size = UDim2.new(1, 0, 0, thickness), BackgroundColor3 = color or SelectedTheme.ElementStroke,
   BackgroundTransparency = color and 0 or 0.8, BorderSizePixel = 0, LayoutOrder = #TabPage:GetChildren() + 1, Parent = TabPage
}, "Divider", updateTheme) -- Track Divider

-- Add padding using margins (simpler than extra frames)
DividerFrame.LayoutMargin = UDim.new(0, padding) -- Apply vertical margin

-- API for divider
local DividerAPI = {
   Instance = DividerFrame,
   Type = "Divider",
   SetColor = function(newColor)
       color = newColor -- Store override
       DividerFrame.BackgroundColor3 = newColor
       DividerFrame.BackgroundTransparency = 0
   end,
   SetThickness = function(newThickness)
       DividerFrame.Size = UDim2.new(1, 0, 0, newThickness)
   end
}
Tab.Elements["Divider_" .. #TabPage:GetChildren()] = DividerAPI -- Store API

return DividerAPI
end

-- CreateKeybind (Refactored with Theme Update and Key System Integration)
function Tab:CreateKeybind(options)
options = options or {}
local keybindName = options.Name or "Keybind"
local flag = options.Flag -- Mandatory flag name
local defaultKey = options.Default or Enum.KeyCode.None -- Default key
local defaultModifiers = options.Modifiers or { Shift = false, Ctrl = false, Alt = false }
local callback = options.Callback or function() print(keybindName .. " triggered") end
local allowMouse = options.AllowMouse or false -- Allow mouse buttons?
local tooltip = options.Tooltip

if not flag then warn("LuminaUI: Keybind '" .. keybindName .. "' requires a 'Flag' option."); return end
if not settings.KeySystem or not settings.KeySystem.Enabled then warn("LuminaUI: Key System disabled, Keybind element will not function."); return end

-- Register flag with default key data structure
local initialValue = registerFlag(flag, { Key = defaultKey, Modifiers = defaultModifiers }, "Keybind")

local elementHeight = 36
local elementPadding = 10
local keyWidth = 100
local listening = false -- Is this keybind currently waiting for input?

local updateTheme = function(instance)
   local keyButton = instance:FindFirstChild("KeyButton")
   local label = instance:FindFirstChild("Label")
   local stroke = instance:FindFirstChildOfClass("UIStroke")

   instance.BackgroundColor3 = SelectedTheme.ElementBackground
   if stroke then stroke.Color = SelectedTheme.ElementStroke end
   if label then label.TextColor3 = SelectedTheme.TextColor end

   if keyButton then
       keyButton.BackgroundColor3 = SelectedTheme.InputBackground
       local keyStroke = keyButton:FindFirstChildOfClass("UIStroke")
       if keyStroke then keyStroke.Color = SelectedTheme.InputStroke end
       local keyLabel = keyButton:FindFirstChild("KeyLabel")
       if keyLabel then keyLabel.TextColor3 = SelectedTheme.TextColor end
   end
end

local KeybindFrame = Utility.createInstance("Frame", {
   Name = "Keybind_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
   BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #TabPage:GetChildren() + 1, Parent = TabPage
}, "Keybind", updateTheme) -- Track Keybind
Utility.createCorner(KeybindFrame, 4)
local stroke = Utility.createStroke(KeybindFrame, SelectedTheme.ElementStroke, 1)

-- Label
local KeybindLabel = Utility.createInstance("TextLabel", {
   Name = "Label", Size = UDim2.new(1, -(elementPadding * 2 + keyWidth), 1, 0), Position = UDim2.new(0, elementPadding, 0, 0),
   BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = keybindName, TextColor3 = SelectedTheme.TextColor,
   TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = KeybindFrame
})

-- Key Button
local KeyButton = Utility.createInstance("TextButton", {
   Name = "KeyButton", Size = UDim2.new(0, keyWidth, 1, -10), Position = UDim2.new(1, -elementPadding, 0.5, 0),
   AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = SelectedTheme.InputBackground, Font = Enum.Font.GothamBold,
   Text = "", TextColor3 = SelectedTheme.TextColor, TextSize = 12, ZIndex = 1, Parent = KeybindFrame
})
Utility.createCorner(KeyButton, 4)
local keyStroke = Utility.createStroke(KeyButton, SelectedTheme.InputStroke, 1)
local KeyLabel = KeyButton -- Use TextButton directly for text

-- Function to format key display text
local function formatKeyText(keyData)
   if listening then return "..." end
   if not keyData or keyData.Key == Enum.KeyCode.None then return "None" end

   local text = ""
   if keyData.Modifiers.Ctrl then text = text .. "Ctrl + " end
   if keyData.Modifiers.Alt then text = text .. "Alt + " end
   if keyData.Modifiers.Shift then text = text .. "Shift + " end

   local keyName = keyData.Key.Name
   -- Simple replacements for common mouse buttons if allowed
   if allowMouse then
       if keyData.Key == Enum.UserInputType.MouseButton1 then keyName = "MB1"
       elseif keyData.Key == Enum.UserInputType.MouseButton2 then keyName = "MB2"
       elseif keyData.Key == Enum.UserInputType.MouseButton3 then keyName = "MB3" end
   end
   text = text .. keyName

   return text
end

-- Function to register/unregister the actual keybind listener
local function updateKeyListener()
   local keyData = LuminaUI.Flags[flag].Value
   local keybindId = "LuminaKeybind_" .. flag

   -- Remove existing listener for this flag
   if LuminaUI._Keybinds[keybindId] then
       LuminaUI._Keybinds[keybindId] = nil
   end

   -- Add new listener if key is set
   if keyData and keyData.Key ~= Enum.KeyCode.None then
       LuminaUI._Keybinds[keybindId] = {
           Key = keyData.Key,
           Modifiers = keyData.Modifiers,
           Callback = callback,
           SourceInstance = KeybindFrame -- Reference to UI element
       }
   end
end

-- Initial setup
KeyLabel.Text = formatKeyText(initialValue)
updateKeyListener()

-- Input Listening Logic
local inputConnection = nil
local function stopListening(newKeyData)
   if not listening then return end
   listening = false
   if inputConnection then inputConnection:Disconnect(); inputConnection = nil end

   -- Restore focus behavior? Maybe not needed for keybinds.

   if newKeyData then
       -- Validate (e.g., don't allow modifier keys alone?)
       if newKeyData.Key == Enum.KeyCode.LeftShift or newKeyData.Key == Enum.KeyCode.RightShift or
          newKeyData.Key == Enum.KeyCode.LeftControl or newKeyData.Key == Enum.KeyCode.RightControl or
          newKeyData.Key == Enum.KeyCode.LeftAlt or newKeyData.Key == Enum.KeyCode.RightAlt then
           warn("LuminaUI: Modifier keys cannot be assigned alone.")
           KeyLabel.Text = formatKeyText(LuminaUI.Flags[flag].Value) -- Revert text
       else
           LuminaUI.Flags[flag].Value = newKeyData
           KeyLabel.Text = formatKeyText(newKeyData)
           updateKeyListener() -- Update the actual listener
       end
   else
       -- Clicked outside or Esc pressed, revert text
       KeyLabel.Text = formatKeyText(LuminaUI.Flags[flag].Value)
   end

   -- Reset visual state
   keyStroke.Color = SelectedTheme.InputStroke
   KeyLabel.TextColor3 = SelectedTheme.TextColor
   if tooltip then Utility.hideTooltip() end
end

Utility.Connect(KeyButton.MouseButton1Click, function()
   if listening then return end -- Already listening
   listening = true
   KeyLabel.Text = "..."
   keyStroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled
   KeyLabel.TextColor3 = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled
   if tooltip then Utility.showTooltip("Press any key or Esc to cancel...") end

   -- Start listening for the next input
   inputConnection = Utility.Connect(UserInputService.InputBegan, function(input, gameProcessed)
       if gameProcessed then return end -- Ignore game processed input

       local inputType = input.UserInputType
       local keyCode = input.KeyCode

       -- Check if it's an allowed key type
       if inputType == Enum.UserInputType.Keyboard or (allowMouse and (inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.MouseButton2 or inputType == Enum.UserInputType.MouseButton3)) then
           -- Escape key cancels
           if keyCode == Enum.KeyCode.Escape then
               stopListening(nil)
               return
           end

           -- Capture key and modifiers
           local modifiers = {
               Shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift),
               Ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl),
               Alt = UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
           }
           -- Use UserInputType for mouse buttons, KeyCode for keyboard
           local capturedKey = inputType == Enum.UserInputType.Keyboard and keyCode or inputType

           stopListening({ Key = capturedKey, Modifiers = modifiers })
       end
   end)
end)

-- Stop listening if clicked outside the button
local clickOutsideKeyListener = Utility.Connect(UserInputService.InputBegan, function(input)
    if listening and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        -- Check if the click was on the KeyButton itself
        local mousePos = input.Position
        local buttonPos = KeyButton.AbsolutePosition
        local buttonSize = KeyButton.AbsoluteSize
        if not (mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y) then
            stopListening(nil) -- Clicked outside, cancel
        end
    end
end)
Utility.storeConnection(KeybindFrame, clickOutsideKeyListener)

-- API to update keybind state externally
local KeybindAPI = {
   Instance = KeybindFrame,
   Type = "Keybind",
   Flag = flag,
   SetValue = function(newKeyData) -- Expects { Key = Enum.KeyCode/UserInputType, Modifiers = { Shift=bool, Ctrl=bool, Alt=bool } }
       if type(newKeyData) == "table" and newKeyData.Key and newKeyData.Modifiers then
            -- Basic validation
            if (type(newKeyData.Key) == "EnumItem" and newKeyData.Key.EnumType == Enum.KeyCode) or
               (allowMouse and type(newKeyData.Key) == "EnumItem" and newKeyData.Key.EnumType == Enum.UserInputType) then

                LuminaUI.Flags[flag].Value = newKeyData
                KeyLabel.Text = formatKeyText(newKeyData)
                updateKeyListener()
            else
                warn("LuminaUI: Invalid key data provided for SetValue on Keybind '"..flag.."'")
            end
       else
            warn("LuminaUI: Invalid format for SetValue on Keybind '"..flag.."'")
       end
   end,
   GetValue = function()
       return LuminaUI.Flags[flag].Value
   end,
   Trigger = function() -- Manually trigger the callback
       callback()
   end
}
Tab.Elements[flag] = KeybindAPI -- Store API under flag name

return KeybindAPI
end

-- CreateColorPicker (Refactored with Theme Update)
function Tab:CreateColorPicker(options)
options = options or {}
local pickerName = options.Name or "Color Picker"
local flag = options.Flag -- Mandatory flag name
local defaultValue = options.Default or Color3.fromRGB(255, 255, 255)
local callback = options.Callback or function(value) print(pickerName .. " color: " .. tostring(value)) end
local icon = options.Icon
local tooltip = options.Tooltip

if not flag then warn("LuminaUI: ColorPicker '" .. pickerName .. "' requires a 'Flag' option."); return end
if typeof(defaultValue) ~= "Color3" then warn("LuminaUI: Default value for ColorPicker '" .. flag .. "' must be a Color3."); defaultValue = Color3.new(1,1,1) end

local initialValue = registerFlag(flag, defaultValue, "ColorPicker")

local elementHeight = 36
local elementPadding = 10
local iconSize = 20
local swatchSize = 24
local pickerOpen = false
local pickerFrame = nil -- Instance reference

local updateTheme = function(instance)
   local swatch = instance:FindFirstChild("ColorSwatch")
   local iconLabel = instance:FindFirstChild("Icon")
   local label = instance:FindFirstChild("Label")
   local stroke = instance:FindFirstChildOfClass("UIStroke")

   instance.BackgroundColor3 = SelectedTheme.ElementBackground
   if stroke then stroke.Color = SelectedTheme.ElementStroke end
   if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
   if label then label.TextColor3 = SelectedTheme.TextColor end

   if swatch then
       -- Swatch color is the actual value, no theme update needed unless adding border?
       local swatchStroke = swatch:FindFirstChildOfClass("UIStroke")
       if swatchStroke then swatchStroke.Color = SelectedTheme.ElementStroke end
   end

   -- Update picker frame theme if open
   if pickerFrame and pickerFrame.Parent then
       pickerFrame.BackgroundColor3 = SelectedTheme.ColorPickerBackground
       local pickerStroke = pickerFrame:FindFirstChildOfClass("UIStroke")
       if pickerStroke then pickerStroke.Color = SelectedTheme.ElementStroke end
       -- Update internal elements (saturation/value box, hue slider, etc.)
       local svBox = pickerFrame:FindFirstChild("SV_Box")
       if svBox then
           -- Update gradient? Tricky. Maybe just border/cursor.
           local svCursor = svBox:FindFirstChild("Cursor")
           if svCursor then svCursor.BackgroundColor3 = SelectedTheme.TextColor end
       end
       local hueSlider = pickerFrame:FindFirstChild("Hue_Slider")
       if hueSlider then
           -- Update gradient? Tricky. Maybe just border/cursor.
           local hueCursor = hueSlider:FindFirstChild("Cursor")
           if hueCursor then hueCursor.BackgroundColor3 = SelectedTheme.TextColor end
       end
   end
end

local PickerFrame = Utility.createInstance("Frame", {
   Name = "ColorPicker_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
   BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #TabPage:GetChildren() + 1, Parent = TabPage,
   ClipsDescendants = false -- Allow picker popup
}, "ColorPicker", updateTheme) -- Track ColorPicker
Utility.createCorner(PickerFrame, 4)
local stroke = Utility.createStroke(PickerFrame, SelectedTheme.ElementStroke, 1)

local textXOffset = elementPadding
if icon then
    local PickerIcon = Utility.createInstance("ImageLabel", {
        Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
        ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = PickerFrame
    })
    textXOffset = elementPadding + iconSize + 8
end

-- Label
local PickerLabel = Utility.createInstance("TextLabel", {
   Name = "Label", Size = UDim2.new(1, -(textXOffset + elementPadding + swatchSize + 10), 1, 0), -- Adjust width for swatch
   Position = UDim2.new(0, textXOffset, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
   Text = pickerName, TextColor3 = SelectedTheme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = PickerFrame
})

-- Color Swatch Button
local ColorSwatch = Utility.createInstance("TextButton", { -- Use TextButton for interaction
   Name = "ColorSwatch", Size = UDim2.new(0, swatchSize, 0, swatchSize), Position = UDim2.new(1, -elementPadding, 0.5, 0),
   AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = initialValue, Text = "", ZIndex = 1, Parent = PickerFrame
})
Utility.createCorner(ColorSwatch, 4)
Utility.createStroke(ColorSwatch, SelectedTheme.ElementStroke, 1) -- Add stroke to swatch

-- Function to toggle the color picker popup
local function togglePickerPopup(forceClose)
   if pickerOpen and not forceClose then -- Close it
       pickerOpen = false
       if pickerFrame and pickerFrame.Parent then
           local pickerTween = TweenService:Create(pickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(pickerFrame.Size.X.Scale, pickerFrame.Size.X.Offset, 0, 0), BackgroundTransparency = 1 })
           pickerTween:Play()
           Utility.Connect(pickerTween.Completed, function()
               Utility.destroyInstance(pickerFrame)
               pickerFrame = nil
           end)
       end
       stroke.Color = SelectedTheme.ElementStroke -- Reset main frame stroke
       if tooltip then Utility.hideTooltip() end

   elseif not pickerOpen and not forceClose then -- Open it
       pickerOpen = true
       stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled -- Highlight main frame stroke

       local pickerWidth = 200
       local pickerHeight = 230
       local pickerYPos = elementHeight + 2

       -- Theme update function for the picker popup itself
       local updatePopupTheme = function(instance)
           instance.BackgroundColor3 = SelectedTheme.ColorPickerBackground
           local popupStroke = instance:FindFirstChildOfClass("UIStroke")
           if popupStroke then popupStroke.Color = SelectedTheme.ElementStroke end
           -- Theme updates for internal elements are handled by the main updateTheme
       end

       pickerFrame = Utility.createInstance("Frame", {
           Name = "PickerPopup", Size = UDim2.new(0, pickerWidth, 0, 0), -- Start height 0
           Position = UDim2.new(1, -elementPadding - pickerWidth, 0, pickerYPos), -- Position top-right relative to main frame
           AnchorPoint = Vector2.new(0, 0), BackgroundColor3 = SelectedTheme.ColorPickerBackground,
           BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 100, Parent = PickerFrame
       }, "ColorPickerPopup", updatePopupTheme) -- Track popup
       Utility.createCorner(pickerFrame, 6)
       Utility.createStroke(pickerFrame, SelectedTheme.ElementStroke, 1)

       -- Internal Picker Elements (Saturation/Value Box, Hue Slider)
       local svBoxSize = 170
       local hueSliderWidth = 15
       local padding = (pickerWidth - svBoxSize - hueSliderWidth) / 3

       -- Saturation/Value Box
       local SV_Box = Utility.createInstance("Frame", {
           Name = "SV_Box", Size = UDim2.new(0, svBoxSize, 0, svBoxSize), Position = UDim2.new(0, padding, 0, padding),
           BackgroundColor3 = Color3.new(1,1,1), -- Updated by hue
           ClipsDescendants = true, Parent = pickerFrame
       })
       Utility.createCorner(SV_Box, 4)
       local SaturationGradient = Utility.createInstance("UIGradient", {
           Name = "Saturation", Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)), -- White -> Hue Color
           Rotation = 90, Parent = SV_Box
       })
       local ValueGradient = Utility.createInstance("UIGradient", {
           Name = "Value", Color = ColorSequence.new(Color3.new(0, 0, 0, 1), Color3.new(0, 0, 0, 0)), -- Transparent -> Black
           Rotation = 0, Parent = SV_Box
       })
       local SV_Cursor = Utility.createInstance("Frame", {
           Name = "Cursor", Size = UDim2.new(0, 8, 0, 8), Position = UDim2.fromScale(0.5, 0.5), -- Updated later
           AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = SelectedTheme.TextColor, BorderSizePixel = 1, BorderColor3 = Color3.new(0,0,0),
           ZIndex = 2, Parent = SV_Box
       })
       Utility.createCorner(SV_Cursor, 4)

       -- Hue Slider
       local Hue_Slider = Utility.createInstance("Frame", {
           Name = "Hue_Slider", Size = UDim2.new(0, hueSliderWidth, 0, svBoxSize), Position = UDim2.new(0, padding + svBoxSize + padding, 0, padding),
           BackgroundColor3 = Color3.new(1,1,1), ClipsDescendants = true, Parent = pickerFrame
       })
       Utility.createCorner(Hue_Slider, hueSliderWidth / 2)
       local Hue_Gradient = Utility.createInstance("UIGradient", {
           Name = "Gradient", Rotation = 0, Parent = Hue_Slider,
           Color = ColorSequence.new({
               ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),   -- Red
               ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 255, 0)), -- Yellow
               ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0, 255, 0)),   -- Lime
               ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0, 255, 255)), -- Cyan
               ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0, 0, 255)),   -- Blue
               ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255, 0, 255)), -- Magenta
               ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))    -- Red (wrap)
           })
       })
       local Hue_Cursor = Utility.createInstance("Frame", {
           Name = "Cursor", Size = UDim2.new(1, 4, 0, 4), Position = UDim2.fromScale(0.5, 0), -- Y updated later
           AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = SelectedTheme.TextColor, BorderSizePixel = 1, BorderColor3 = Color3.new(0,0,0),
           ZIndex = 2, Parent = Hue_Slider
       })
       Utility.createCorner(Hue_Cursor, 2)

       -- Hex Input (Optional) - Add below SV box and Hue slider
       local HexInput = Utility.createInstance("TextBox", {
           Name = "HexInput", Size = UDim2.new(1, -(padding*2), 0, 25), Position = UDim2.new(0, padding, 0, padding + svBoxSize + padding),
           BackgroundColor3 = SelectedTheme.InputBackground, Font = Enum.Font.Gotham, Text = "", PlaceholderText = "Hex: #FFFFFF",
           TextColor3 = SelectedTheme.TextColor, PlaceholderColor3 = SelectedTheme.InputPlaceholder, TextSize = 12, ClearTextOnFocus = false,
           Parent = pickerFrame
       })
       Utility.createCorner(HexInput, 4)
       Utility.createStroke(HexInput, SelectedTheme.InputStroke, 1)

       -- Picker Logic
       local currentH, currentS, currentV = Color3.toHSV(LuminaUI.Flags[flag].Value)
       local svDragging = false
       local hueDragging = false

       local function updateColor(newH, newS, newV, triggerCallback, updateHex)
           triggerCallback = triggerCallback == nil and true or triggerCallback
           updateHex = updateHex == nil and true or updateHex

           currentH, currentS, newV = newH, newS, newV -- Update state
           local newColor = Color3.fromHSV(currentH, currentS, currentV)

           -- Update Flag and Swatch
           LuminaUI.Flags[flag].Value = newColor
           ColorSwatch.BackgroundColor3 = newColor

           -- Update SV Box background (hue part) and Saturation gradient
           local hueColor = Color3.fromHSV(currentH, 1, 1)
           SV_Box.BackgroundColor3 = hueColor
           SaturationGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), hueColor)

           -- Update Cursors
           SV_Cursor.Position = UDim2.fromScale(currentS, 1 - currentV)
           Hue_Cursor.Position = UDim2.fromScale(0.5, currentH)

           -- Update Hex Input
           if updateHex then
               HexInput.Text = string.format("#%02X%02X%02X", newColor.R * 255, newColor.G * 255, newColor.B * 255)
           end

           -- Trigger Callback
           if triggerCallback then
               local success, err = pcall(callback, newColor)
               if not success then warn("LuminaUI ColorPicker Error:", err) end
           end
       end

       -- Initial update for picker state
       updateColor(currentH, currentS, currentV, false, true)

       -- SV Box Interaction
       local svInteract = Utility.createInstance("TextButton", { Name="Interact", Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=1, Parent=SV_Box })
       local function handleSVInput(input)
           local mousePos = input.Position
           local boxPos = SV_Box.AbsolutePosition
           local boxSize = SV_Box.AbsoluteSize
           local relativeX = math.clamp((mousePos.X - boxPos.X) / boxSize.X, 0, 1) -- Saturation
           local relativeY = math.clamp((mousePos.Y - boxPos.Y) / boxSize.Y, 0, 1) -- 1 - Value
           updateColor(currentH, relativeX, 1 - relativeY)
       end
       Utility.Connect(svInteract.InputBegan, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = true; handleSVInput(input); UserInputService.TextSelectionEnabled = false; end end)
       Utility.Connect(UserInputService.InputEnded, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 and svDragging then svDragging = false; UserInputService.TextSelectionEnabled = true; end end)
       Utility.Connect(UserInputService.InputChanged, function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and svDragging then handleSVInput(input) end end)

       -- Hue Slider Interaction
       local hueInteract = Utility.createInstance("TextButton", { Name="Interact", Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Text="", ZIndex=1, Parent=Hue_Slider })
       local function handleHueInput(input)
           local mouseY = input.Position.Y
           local sliderPos = Hue_Slider.AbsolutePosition
           local sliderSize = Hue_Slider.AbsoluteSize
           local relativeY = math.clamp((mouseY - sliderPos.Y) / sliderSize.Y, 0, 1) -- Hue
           updateColor(relativeY, currentS, currentV)
       end
       Utility.Connect(hueInteract.InputBegan, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = true; handleHueInput(input); UserInputService.TextSelectionEnabled = false; end end)
       Utility.Connect(UserInputService.InputEnded, function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 and hueDragging then hueDragging = false; UserInputService.TextSelectionEnabled = true; end end)
       Utility.Connect(UserInputService.InputChanged, function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and hueDragging then handleHueInput(input) end end)

       -- Hex Input Interaction
       Utility.Connect(HexInput.FocusLost, function(enterPressed)
           if enterPressed then
               local text = HexInput.Text:gsub("#", "")
               if text:match("^[0-9a-fA-F]{6}$") then
                   local r = tonumber("0x"..text:sub(1,2)) / 255
                   local g = tonumber("0x"..text:sub(3,4)) / 255
                   local b = tonumber("0x"..text:sub(5,6)) / 255
                   local newColor = Color3.new(r, g, b)
                   local h, s, v = Color3.toHSV(newColor)
                   updateColor(h, s, v, true, false) -- Update picker from hex, don't re-update hex box
               else
                   -- Revert to current color if invalid hex
                   local currentColor = LuminaUI.Flags[flag].Value
                   HexInput.Text = string.format("#%02X%02X%02X", currentColor.R * 255, currentColor.G * 255, currentColor.B * 255)
               end
           end
       end)

       -- Animate picker open
       local pickerTween = TweenService:Create(pickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, pickerWidth, 0, pickerHeight), BackgroundTransparency = 0 })
       pickerTween:Play()
   end
end

-- Effects & Callback for swatch button
Utility.Connect(ColorSwatch.MouseEnter, function() if tooltip then Utility.showTooltip(tooltip) end end)
Utility.Connect(ColorSwatch.MouseLeave, function() if tooltip then Utility.hideTooltip() end end)
Utility.Connect(ColorSwatch.MouseButton1Click, function()
   togglePickerPopup()
end)

-- Close picker if clicked outside
local clickOutsidePickerConnection = Utility.Connect(UserInputService.InputBegan, function(input)
    if pickerOpen and pickerFrame and pickerFrame.Parent and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position
        local framePos = PickerFrame.AbsolutePosition
        local frameSize = PickerFrame.AbsoluteSize
        local popupPos = pickerFrame.AbsolutePosition
        local popupSize = pickerFrame.AbsoluteSize

        -- Check if click is outside both the main frame and the popup
        local inFrame = mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y
        local inPopup = mousePos.X >= popupPos.X and mousePos.X <= popupPos.X + popupSize.X and mousePos.Y >= popupPos.Y and mousePos.Y <= popupPos.Y + popupSize.Y

        if not inFrame and not inPopup then
            togglePickerPopup(true) -- Force close
        end
    end
end)
Utility.storeConnection(PickerFrame, clickOutsidePickerConnection)

-- API to update color picker state externally
local ColorPickerAPI = {
   Instance = PickerFrame,
   Type = "ColorPicker",
   Flag = flag,
   SetValue = function(newColor)
       if typeof(newColor) == "Color3" then
           local h, s, v = Color3.toHSV(newColor)
           if pickerOpen then
               updateColor(h, s, v, false) -- Update picker visuals if open, don't trigger callback
           else
               -- Just update flag and swatch if picker is closed
               LuminaUI.Flags[flag].Value = newColor
               ColorSwatch.BackgroundColor3 = newColor
           end
       else
           warn("LuminaUI: Invalid value for SetValue on ColorPicker '"..flag.."'. Expected Color3.")
       end
   end,
   GetValue = function()
       return LuminaUI.Flags[flag].Value
   end
}
Tab.Elements[flag] = ColorPickerAPI -- Store API under flag name

return ColorPickerAPI
end

-- CreateSection (Container for grouping elements)
function Tab:CreateSection(options)
options = options or {}
local sectionName = options.Name or "Section"
local defaultOpen = options.DefaultOpen == nil and true or options.DefaultOpen -- Default to open

local sectionOpen = defaultOpen
local contentFrame = nil
local arrowIcon = nil

local updateTheme = function(instance)
   local header = instance:FindFirstChild("Header")
   local arrow = header and header:FindFirstChild("Arrow")
   local label = header and header:FindFirstChild("Label")
   local content = instance:FindFirstChild("Content")

   instance.BackgroundColor3 = SelectedTheme.SectionBackground
   if header then header.BackgroundColor3 = SelectedTheme.ElementBackground -- Header distinct?
       local headerStroke = header:FindFirstChildOfClass("UIStroke")
       if headerStroke then headerStroke.Color = SelectedTheme.ElementStroke end
   end
   if arrow then arrow.ImageColor3 = SelectedTheme.TextColor end
   if label then label.TextColor3 = SelectedTheme.TextColor end
   if content then
       -- Content background matches section background
       content.BackgroundColor3 = SelectedTheme.SectionBackground
   end
end

local SectionFrame = Utility.createInstance("Frame", {
   Name = "Section_" .. sectionName:gsub("%s+", "_"), Size = UDim2.new(1, 0, 0, 30), -- Initial height for header
   BackgroundColor3 = SelectedTheme.SectionBackground, BackgroundTransparency = 0.2, ClipsDescendants = true,
   LayoutOrder = #TabPage:GetChildren() + 1, Parent = TabPage
}, "Section", updateTheme) -- Track Section
Utility.createCorner(SectionFrame, 4)
-- No main stroke, rely on header/content visuals

-- Header Frame
local HeaderFrame = Utility.createInstance("Frame", {
   Name = "Header", Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = SelectedTheme.ElementBackground, Parent = SectionFrame
})
-- Utility.createCorner(HeaderFrame, 4) -- Apply corner to main frame instead
Utility.createStroke(HeaderFrame, SelectedTheme.ElementStroke, 1) -- Stroke on header

-- Arrow Icon
arrowIcon = Utility.createInstance("ImageLabel", {
   Name = "Arrow", Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 10, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
   BackgroundTransparency = 1, Image = "rbxassetid://6035048680", ImageColor3 = SelectedTheme.TextColor, Rotation = sectionOpen and 90 or 0, Parent = HeaderFrame
})

-- Label
local SectionLabel = Utility.createInstance("TextLabel", {
   Name = "Label", Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 30, 0, 0), BackgroundTransparency = 1,
   Font = Enum.Font.GothamBold, Text = sectionName, TextColor3 = SelectedTheme.TextColor, TextSize = 13,
   TextXAlignment = Enum.TextXAlignment.Left, Parent = HeaderFrame
})

-- Header Interaction
local HeaderInteract = Utility.createInstance("TextButton", {
   Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = HeaderFrame
})

-- Content Frame (holds child elements)
contentFrame = Utility.createInstance("Frame", {
   Name = "Content", Size = UDim2.new(1, 0, 0, 0), -- Height calculated later
   Position = UDim2.new(0, 0, 0, 30), BackgroundColor3 = SelectedTheme.SectionBackground, BackgroundTransparency = 0,
   ClipsDescendants = true, Visible = sectionOpen, Parent = SectionFrame
})
local contentLayout = Utility.createInstance("UIListLayout", {
   Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = contentFrame
})
local contentPadding = Utility.createInstance("UIPadding", {
   PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
   PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = contentFrame
})

-- Function to toggle section visibility and animate
local contentHeight = 0 -- Store calculated content height
   -- ... inside CreateSection function ...
   local function toggleSection()
    sectionOpen = not sectionOpen
    contentFrame.Visible = true -- Make visible before animation starts

    local targetRotation = sectionOpen and 90 or 0
    local targetHeight = sectionOpen and contentHeight or 0
    -- Calculate target height including padding
    local targetFrameHeight = sectionOpen and (30 + contentHeight + contentPadding.PaddingTop.Offset + contentPadding.PaddingBottom.Offset) or 30

    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(arrowIcon, tweenInfo, { Rotation = targetRotation }):Play()
    TweenService:Create(contentFrame, tweenInfo, { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
    local frameTween = TweenService:Create(SectionFrame, tweenInfo, { Size = UDim2.new(1, 0, 0, targetFrameHeight) })
    frameTween:Play()

    Utility.Connect(frameTween.Completed, function()
        if not sectionOpen then
            contentFrame.Visible = false -- Hide after collapsing
        end
        -- Force layout update on parent tab page after animation
        if TabPage and TabPage.Parent and ElementsListLayout and ElementsListLayout.Parent then
            local currentCanvasSize = TabPage.CanvasSize
            local paddingHeight = ElementsPadding.PaddingTop.Offset + ElementsPadding.PaddingBottom.Offset
            TabPage.CanvasSize = UDim2.new(0,0,0, ElementsListLayout.AbsoluteContentSize.Y + paddingHeight)
        end
    end)
 end

 Utility.Connect(HeaderInteract.MouseButton1Click, toggleSection)

 -- Function to recalculate content height (call after adding/removing elements)
 local function recalculateContentHeight()
    -- Use AbsoluteContentSize from the layout
    contentHeight = contentLayout.AbsoluteContentSize.Y
    if sectionOpen then
        -- Update frame sizes immediately if already open
        local newFrameHeight = 30 + contentHeight + contentPadding.PaddingTop.Offset + contentPadding.PaddingBottom.Offset
        contentFrame.Size = UDim2.new(1, 0, 0, contentHeight)
        SectionFrame.Size = UDim2.new(1, 0, 0, newFrameHeight)
    end
 end

 -- Connect to layout changes to auto-recalculate
 Utility.Connect(contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), recalculateContentHeight)
 -- Also connect to child added/removed for robustness
 Utility.Connect(contentFrame.ChildAdded, function(child) task.wait(); recalculateContentHeight() end) -- Wait a frame
 Utility.Connect(contentFrame.ChildRemoved, function(child) task.wait(); recalculateContentHeight() end) -- Wait a frame


 -- Section API (allows adding elements *inside* the section)
 local SectionAPI = {
    Instance = SectionFrame,
    Type = "Section",
    Container = contentFrame, -- Expose content frame
    Layout = contentLayout, -- Expose layout
    Recalculate = recalculateContentHeight, -- Expose recalculate function
    Toggle = toggleSection, -- Expose toggle function
    IsOpen = function() return sectionOpen end,
    -- Re-implement element creation methods, parenting to contentFrame
    CreateButton = function(opts) opts.Parent = contentFrame; return Tab:CreateButton(opts) end,
    CreateToggle = function(opts) opts.Parent = contentFrame; return Tab:CreateToggle(opts) end,
    CreateSlider = function(opts) opts.Parent = contentFrame; return Tab:CreateSlider(opts) end,
    CreateDropdown = function(opts) opts.Parent = contentFrame; return Tab:CreateDropdown(opts) end,
    CreateTextbox = function(opts) opts.Parent = contentFrame; return Tab:CreateTextbox(opts) end,
    CreateLabel = function(opts) opts.Parent = contentFrame; return Tab:CreateLabel(opts) end,
    CreateDivider = function(opts) opts.Parent = contentFrame; return Tab:CreateDivider(opts) end,
    CreateKeybind = function(opts) opts.Parent = contentFrame; return Tab:CreateKeybind(opts) end,
    CreateColorPicker = function(opts) opts.Parent = contentFrame; return Tab:CreateColorPicker(opts) end,
    -- Note: Cannot create nested sections this way easily, would need adjustments
 }

 -- Need to override the Parent property in options for elements added via SectionAPI
 -- This wrapper ensures elements added directly to the Tab go to Tab.Page,
 -- while elements added via SectionAPI go to SectionAPI.Container (contentFrame).
 local function wrapCreateFunction(originalFunc)
     return function(apiSelf, options) -- apiSelf can be Tab or SectionAPI
         options = options or {}
         -- If called on SectionAPI, parent is Container, otherwise default to Tab.Page
         options.Parent = (apiSelf == SectionAPI and SectionAPI.Container) or options.Parent or Tab.Page
         return originalFunc(Tab, options) -- Always call the original Tab method
     end
 end

 -- Wrap functions for the SectionAPI specifically
 SectionAPI.CreateButton = wrapCreateFunction(Tab.CreateButton)
 SectionAPI.CreateToggle = wrapCreateFunction(Tab.CreateToggle)
 SectionAPI.CreateSlider = wrapCreateFunction(Tab.CreateSlider)
 SectionAPI.CreateDropdown = wrapCreateFunction(Tab.CreateDropdown)
 SectionAPI.CreateTextbox = wrapCreateFunction(Tab.CreateTextbox)
 SectionAPI.CreateLabel = wrapCreateFunction(Tab.CreateLabel)
 SectionAPI.CreateDivider = wrapCreateFunction(Tab.CreateDivider)
 SectionAPI.CreateKeybind = wrapCreateFunction(Tab.CreateKeybind)
 SectionAPI.CreateColorPicker = wrapCreateFunction(Tab.CreateColorPicker)
 -- Section creation doesn't need wrapping as it's always parented to TabPage

 Tab.Elements["Section_" .. sectionName:gsub("%s+", "_")] = SectionAPI -- Store API

 -- Initial calculation after a frame to allow layout to settle
 task.wait()
 recalculateContentHeight()

 return SectionAPI
end


         -- ========================================================================
         -- Element Creation Methods End Here
         -- ========================================================================

         -- Select this tab if it's the first one created
         if not activePage then
             Window:SelectTab(tabId)
         end

         return Tab -- Return the Tab object
     end -- End of Window:CreateTab

     -- Return the Window object
     return Window
 end -- End of LuminaUI:CreateWindow

 -- Cleanup function (Optional but good practice)
 function LuminaUI:Destroy()
     if Library and Library.Parent then
         -- Save config before destroying if enabled
         -- Need access to settings here, might need to store them in LuminaUI instance
         -- if settings and settings.ConfigurationSaving and settings.ConfigurationSaving.Enabled then
         --     Utility.saveConfig(Library:FindFirstChild("MainFrame"), settings)
         -- end
         Utility.destroyInstance(Library)
     end
     -- Clear all internal state
     Library = nil
     LuminaUI._Instances = {}
     LuminaUI._Connections = {}
     LuminaUI._Keybinds = {}
     LuminaUI.Flags = {}
     LuminaUI.Tabs = {}
     if LuminaUI._KeybindListener then LuminaUI._KeybindListener:Disconnect(); LuminaUI._KeybindListener = nil end
     if LuminaUI._TooltipUpdateConnection then LuminaUI._TooltipUpdateConnection:Disconnect(); LuminaUI._TooltipUpdateConnection = nil end
     if LuminaUI._DragMoveConnection then LuminaUI._DragMoveConnection:Disconnect(); LuminaUI._DragMoveConnection = nil end
     -- Clear instance pool? Maybe not, could be reused by another LuminaUI instance.
 end

 -- Return the main library table
 return LuminaUI
