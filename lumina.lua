--[[
    LuminaUI Interface Library
    A modern, responsive UI library for Roblox scripting
    
    Features:
    - Modern design with smooth animations
    - Customizable themes
    - Optimized performance
    - Enhanced element interactions
    - Simplified configuration
    - User privacy controls
    - Advanced component system
    - Flexible layout options
]]

local LuminaUI = {
    Flags = {},
    Version = "1.2.0",
    Theme = {
        Default = {
            TextColor = Color3.fromRGB(240, 240, 240),
            SubTextColor = Color3.fromRGB(200, 200, 200),
            Background = Color3.fromRGB(25, 25, 25),
            Topbar = Color3.fromRGB(34, 34, 34),
            Shadow = Color3.fromRGB(20, 20, 20),
            ElementBackground = Color3.fromRGB(35, 35, 35),
            ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
            ElementStroke = Color3.fromRGB(50, 50, 50),
            TabBackground = Color3.fromRGB(80, 80, 80),
            TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
            TabTextColor = Color3.fromRGB(240, 240, 240),
            SelectedTabTextColor = Color3.fromRGB(50, 50, 50),
            ToggleEnabled = Color3.fromRGB(0, 146, 214),
            ToggleDisabled = Color3.fromRGB(100, 100, 100),
            SliderBackground = Color3.fromRGB(50, 138, 220),
            SliderProgress = Color3.fromRGB(50, 138, 220),
            NotificationBackground = Color3.fromRGB(20, 20, 20),
            InputBackground = Color3.fromRGB(30, 30, 30),
            InputStroke = Color3.fromRGB(65, 65, 65),
            InputPlaceholder = Color3.fromRGB(160, 160, 160),
            DropdownSelected = Color3.fromRGB(40, 40, 40),
            DropdownUnselected = Color3.fromRGB(30, 30, 30),
            ColorPickerBackground = Color3.fromRGB(30, 30, 30),
            SectionBackground = Color3.fromRGB(30, 30, 30),
            ProgressBarBackground = Color3.fromRGB(40, 40, 40),
            ProgressBarFill = Color3.fromRGB(60, 145, 230),
            CheckboxChecked = Color3.fromRGB(0, 146, 214),
            CheckboxUnchecked = Color3.fromRGB(100, 100, 100),
            ScrollBarBackground = Color3.fromRGB(45, 45, 45),
            ScrollBarForeground = Color3.fromRGB(70, 70, 70)
        },
        Dark = {
            TextColor = Color3.fromRGB(220, 220, 220),
            SubTextColor = Color3.fromRGB(180, 180, 180),
            Background = Color3.fromRGB(15, 15, 15),
            Topbar = Color3.fromRGB(24, 24, 24),
            Shadow = Color3.fromRGB(10, 10, 10),
            ElementBackground = Color3.fromRGB(25, 25, 25),
            ElementBackgroundHover = Color3.fromRGB(30, 30, 30),
            ElementStroke = Color3.fromRGB(40, 40, 40),
            TabBackground = Color3.fromRGB(60, 60, 60),
            TabBackgroundSelected = Color3.fromRGB(180, 180, 180),
            TabTextColor = Color3.fromRGB(220, 220, 220),
            SelectedTabTextColor = Color3.fromRGB(40, 40, 40),
            ToggleEnabled = Color3.fromRGB(0, 126, 194),
            ToggleDisabled = Color3.fromRGB(80, 80, 80),
            SliderBackground = Color3.fromRGB(40, 118, 200),
            SliderProgress = Color3.fromRGB(40, 118, 200),
            NotificationBackground = Color3.fromRGB(15, 15, 15),
            InputBackground = Color3.fromRGB(20, 20, 20),
            InputStroke = Color3.fromRGB(55, 55, 55),
            InputPlaceholder = Color3.fromRGB(140, 140, 140),
            DropdownSelected = Color3.fromRGB(30, 30, 30),
            DropdownUnselected = Color3.fromRGB(20, 20, 20),
            ColorPickerBackground = Color3.fromRGB(20, 20, 20),
            SectionBackground = Color3.fromRGB(20, 20, 20),
            ProgressBarBackground = Color3.fromRGB(30, 30, 30),
            ProgressBarFill = Color3.fromRGB(50, 125, 200),
            CheckboxChecked = Color3.fromRGB(0, 126, 194),
            CheckboxUnchecked = Color3.fromRGB(80, 80, 80),
            ScrollBarBackground = Color3.fromRGB(25, 25, 25),
            ScrollBarForeground = Color3.fromRGB(50, 50, 50)
        },
        Ocean = {
            TextColor = Color3.fromRGB(230, 240, 240),
            SubTextColor = Color3.fromRGB(190, 210, 210),
            Background = Color3.fromRGB(20, 30, 40),
            Topbar = Color3.fromRGB(25, 40, 50),
            Shadow = Color3.fromRGB(15, 20, 25),
            ElementBackground = Color3.fromRGB(30, 40, 50),
            ElementBackgroundHover = Color3.fromRGB(35, 45, 55),
            ElementStroke = Color3.fromRGB(45, 55, 65),
            TabBackground = Color3.fromRGB(40, 60, 70),
            TabBackgroundSelected = Color3.fromRGB(100, 180, 200),
            TabTextColor = Color3.fromRGB(210, 230, 240),
            SelectedTabTextColor = Color3.fromRGB(20, 40, 50),
            ToggleEnabled = Color3.fromRGB(0, 130, 180),
            ToggleDisabled = Color3.fromRGB(70, 90, 100),
            SliderBackground = Color3.fromRGB(0, 110, 150),
            SliderProgress = Color3.fromRGB(0, 140, 180),
            NotificationBackground = Color3.fromRGB(25, 35, 45),
            InputBackground = Color3.fromRGB(30, 40, 50),
            InputStroke = Color3.fromRGB(50, 60, 70),
            InputPlaceholder = Color3.fromRGB(150, 170, 180),
            DropdownSelected = Color3.fromRGB(30, 50, 60),
            DropdownUnselected = Color3.fromRGB(25, 35, 45),
            ColorPickerBackground = Color3.fromRGB(25, 35, 45),
            SectionBackground = Color3.fromRGB(25, 35, 45),
            ProgressBarBackground = Color3.fromRGB(35, 45, 55),
            ProgressBarFill = Color3.fromRGB(40, 120, 170),
            CheckboxChecked = Color3.fromRGB(0, 130, 180),
            CheckboxUnchecked = Color3.fromRGB(70, 90, 100),
            ScrollBarBackground = Color3.fromRGB(30, 40, 50),
            ScrollBarForeground = Color3.fromRGB(45, 65, 80)
        },
        Purple = {
            TextColor = Color3.fromRGB(230, 230, 240),
            SubTextColor = Color3.fromRGB(200, 190, 220),
            Background = Color3.fromRGB(30, 25, 40),
            Topbar = Color3.fromRGB(40, 35, 50),
            Shadow = Color3.fromRGB(20, 15, 30),
            ElementBackground = Color3.fromRGB(40, 35, 50),
            ElementBackgroundHover = Color3.fromRGB(50, 45, 60),
            ElementStroke = Color3.fromRGB(60, 55, 70),
            TabBackground = Color3.fromRGB(60, 50, 80),
            TabBackgroundSelected = Color3.fromRGB(180, 160, 220),
            TabTextColor = Color3.fromRGB(220, 220, 240),
            SelectedTabTextColor = Color3.fromRGB(30, 25, 40),
            ToggleEnabled = Color3.fromRGB(130, 80, 200),
            ToggleDisabled = Color3.fromRGB(90, 80, 100),
            SliderBackground = Color3.fromRGB(110, 70, 170),
            SliderProgress = Color3.fromRGB(130, 80, 200),
            NotificationBackground = Color3.fromRGB(35, 30, 45),
            InputBackground = Color3.fromRGB(40, 35, 50),
            InputStroke = Color3.fromRGB(60, 55, 70),
            InputPlaceholder = Color3.fromRGB(160, 150, 180),
            DropdownSelected = Color3.fromRGB(50, 45, 65),
            DropdownUnselected = Color3.fromRGB(40, 35, 55),
            ColorPickerBackground = Color3.fromRGB(35, 30, 45),
            SectionBackground = Color3.fromRGB(35, 30, 45),
            ProgressBarBackground = Color3.fromRGB(45, 40, 55),
            ProgressBarFill = Color3.fromRGB(130, 80, 200),
            CheckboxChecked = Color3.fromRGB(130, 80, 200),
            CheckboxUnchecked = Color3.fromRGB(90, 80, 100),
            ScrollBarBackground = Color3.fromRGB(40, 35, 50),
            ScrollBarForeground = Color3.fromRGB(65, 55, 75)
        }
    }
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local SelectedTheme = LuminaUI.Theme.Default
local ConfigFolder = "LuminaUI"
local ConfigExtension = ".config"
local Library
local TooltipInstance
local DraggingInstance
local DragInput, DragStart, StartPos
local Utility = {}

-- Instance pool for improved performance
local InstancePool = {
    Instances = {},
    MaxPoolSize = 50
}

function InstancePool:Get(className)
    if not self.Instances[className] then
        self.Instances[className] = {}
    end
    
    local pool = self.Instances[className]
    if #pool > 0 then
        local instance = table.remove(pool)
        return instance
    else
        return Instance.new(className)
    end
end

function InstancePool:Release(instance)
    if not instance or not instance:IsA("Instance") then return end
    local className = instance.ClassName
    
    if not self.Instances[className] then
        self.Instances[className] = {}
    end
    
    -- Clear properties and prepare for reuse
    instance.Name = className
    instance.Parent = nil
    
    -- Clear specific properties based on class
    if className == "Frame" or className == "TextButton" or className == "ImageButton" then
        instance.BackgroundTransparency = 1
        instance.Position = UDim2.new(0, 0, 0, 0)
        instance.Size = UDim2.new(0, 0, 0, 0)
    elseif className == "TextLabel" or className == "TextBox" then
        instance.Text = ""
        instance.BackgroundTransparency = 1
    elseif className == "ImageLabel" then
        instance.Image = ""
        instance.BackgroundTransparency = 1
    end
    
    -- Add to pool if not full
    local pool = self.Instances[className]
    if #pool < self.MaxPoolSize then
        table.insert(pool, instance)
    end
end

-- Utility functions
function Utility.createInstance(className, properties)
    local instance = InstancePool:Get(className)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    return instance
end

function Utility.destroyInstance(instance)
    if not instance then return end
    InstancePool:Release(instance)
end

function Utility.debounce(func, wait)
    local lastCall = 0
    return function(...)
        local now = tick()
        if now - lastCall >= wait then
            lastCall = now
            return func(...)
        end
    end
end

function Utility.createStroke(instance, color, thickness, transparency)
    local stroke = Utility.createInstance("UIStroke", {
        Color = color or Color3.fromRGB(50, 50, 50),
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = instance
    })
    return stroke
end

function Utility.createCorner(instance, radius)
    local corner = Utility.createInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = instance
    })
    return corner
end

function Utility.loadIcon(id)
    if type(id) == "number" then
        return "rbxassetid://" .. id
    else
        return id
    end
end

function Utility.getTextBounds(text, font, size)
    return TextService:GetTextSize(text, size, font, Vector2.new(math.huge, math.huge))
end

function Utility.formatNumber(value)
    if value >= 1000000 then
        return string.format("%.1fm", value / 1000000)
    elseif value >= 1000 then
        return string.format("%.1fk", value / 1000)
    else
        return tostring(value)
    end
end

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

function Utility.createTooltip()
    if TooltipInstance then return TooltipInstance end
    
    local Tooltip = Utility.createInstance("Frame", {
        Name = "Tooltip",
        BackgroundColor3 = SelectedTheme.NotificationBackground,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 200, 0, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ZIndex = 1000,
        Parent = Library
    })
    
    Utility.createCorner(Tooltip, 4)
    Utility.createStroke(Tooltip, SelectedTheme.ElementStroke, 1)
    
    local TooltipText = Utility.createInstance("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = SelectedTheme.TextColor,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 1001,
        Parent = Tooltip
    })
    
    TooltipInstance = Tooltip
    return TooltipInstance
end

function Utility.showTooltip(text, parent, yOffset)
    local Tooltip = Utility.createTooltip()
    Tooltip.Text.Text = text
    
    local textBounds = Utility.getTextBounds(text, Enum.Font.Gotham, 13)
    Tooltip.Size = UDim2.new(0, math.min(textBounds.X + 16, 300), 0, textBounds.Y + 10)
    
    yOffset = yOffset or 5
    
    local updatePosition = function()
        local mousePos = UserInputService:GetMouseLocation()
        Tooltip.Position = UDim2.new(0, mousePos.X + 15, 0, mousePos.Y - Tooltip.AbsoluteSize.Y - yOffset)
        
        -- Adjust if off-screen
        local viewportSize = workspace.CurrentCamera.ViewportSize
        if Tooltip.AbsolutePosition.X + Tooltip.AbsoluteSize.X > viewportSize.X then
            Tooltip.Position = UDim2.new(0, mousePos.X - Tooltip.AbsoluteSize.X - 5, Tooltip.Position.Y.Scale, Tooltip.Position.Y.Offset)
        end
    end
    
    updatePosition()
    Tooltip.Visible = true
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if Tooltip.Visible then
            updatePosition()
        else
            connection:Disconnect()
        end
    end)
    
    return Tooltip
end

function Utility.hideTooltip()
    if TooltipInstance then
        TooltipInstance.Visible = false
    end
end

function Utility.makeDraggable(frame, handle)
    handle = handle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            DraggingInstance = frame
            DragStart = input.Position
            StartPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    DraggingInstance = nil
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)
end

-- Initialize drag tracking
UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and DraggingInstance then
        local delta = input.Position - DragStart
        DraggingInstance.Position = UDim2.new(
            StartPos.X.Scale, 
            StartPos.X.Offset + delta.X, 
            StartPos.Y.Scale, 
            StartPos.Y.Offset + delta.Y
        )
    end
end)

-- Configuration functions
function Utility.saveConfig(settings)
    if not settings.ConfigurationSaving or not settings.ConfigurationSaving.Enabled then return end
    
    local data = {
        UIPosition = {
            X = {
                Scale = settings.UIPosition and settings.UIPosition.X.Scale or 0.5,
                Offset = settings.UIPosition and settings.UIPosition.X.Offset or 0
            },
            Y = {
                Scale = settings.UIPosition and settings.UIPosition.Y.Scale or 0.5,
                Offset = settings.UIPosition and settings.UIPosition.Y.Offset or 0
            }
        },
        Elements = {}
    }
    
    for flag, element in pairs(LuminaUI.Flags) do
        if element.Type then
            data.Elements[flag] = {
                Type = element.Type,
                Value = element.Value
            }
        end
    end
    
    if writefile then
        if not isfolder(ConfigFolder) and makefolder then
            makefolder(ConfigFolder)
        end
        
        local configName = settings.ConfigurationSaving.FileName or "config"
        local content = HttpService:JSONEncode(data)
        writefile(ConfigFolder.."/"..configName..ConfigExtension, content)
    end
end

function Utility.loadConfig(settings)
    if not settings.ConfigurationSaving or not settings.ConfigurationSaving.Enabled then return {} end
    
    if isfile and readfile then
        local configName = settings.ConfigurationSaving.FileName or "config"
        local filePath = ConfigFolder.."/"..configName..ConfigExtension
        
        if isfile(filePath) then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(filePath))
            end)
            
            if success then
                -- Store position if present
                if data.UIPosition then
                    settings.UIPosition = UDim2.new(
                        data.UIPosition.X.Scale, 
                        data.UIPosition.X.Offset,
                        data.UIPosition.Y.Scale,
                        data.UIPosition.Y.Offset
                    )
                end
                
                -- Return element data
                if data.Elements then
                    return data.Elements
                end
            end
        end
    end
    
    return {}
end

-- Custom scrollbar function
function Utility.applyCustomScrollbar(scrollFrame, thickness)
    thickness = thickness or 4
    
    -- Remove default scrollbar
    scrollFrame.ScrollBarThickness = thickness
    scrollFrame.ScrollBarImageTransparency = 1
    
    -- Create custom scrollbar
    local scrollbar = Utility.createInstance("Frame", {
        Name = "CustomScrollbar",
        Size = UDim2.new(0, thickness, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = SelectedTheme.ScrollBarBackground,
        BackgroundTransparency = 0.5,
        Parent = scrollFrame
    })
    
    Utility.createCorner(scrollbar, thickness/2)
    
    local scrollThumb = Utility.createInstance("Frame", {
        Name = "ScrollThumb",
        Size = UDim2.new(1, 0, 0.2, 0),
        BackgroundColor3 = SelectedTheme.ScrollBarForeground,
        Parent = scrollbar
    })
    
    Utility.createCorner(scrollThumb, thickness/2)
    
    -- Update scrollbar position and size
    local function updateScrollbar()
        local canvasSize = scrollFrame.CanvasSize.Y.Offset
        local frameSize = scrollFrame.AbsoluteSize.Y
        
        if canvasSize <= frameSize then
            scrollbar.Visible = false
            return
        else
            scrollbar.Visible = true
        end
        
        local scrollPercent = scrollFrame.CanvasPosition.Y / (canvasSize - frameSize)
        local thumbSize = math.max(0.1, frameSize / canvasSize)
        
        scrollThumb.Size = UDim2.new(1, 0, thumbSize, 0)
        scrollThumb.Position = UDim2.new(0, 0, scrollPercent * (1 - thumbSize), 0)
    end
    
    scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(updateScrollbar)
    scrollFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScrollbar)
    scrollFrame:GetPropertyChangedSignal("CanvasSize"):Connect(updateScrollbar)
    
    -- Dragging functionality for scrollThumb
    local isThumbDragging = false
    local startY, startScroll
    
    scrollThumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isThumbDragging = true
            startY = input.Position.Y
            startScroll = scrollFrame.CanvasPosition.Y
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isThumbDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isThumbDragging then
            local delta = input.Position.Y - startY
            local canvasSize = scrollFrame.CanvasSize.Y.Offset
            local frameSize = scrollFrame.AbsoluteSize.Y
            
            local scrollMove = (delta / frameSize) * canvasSize
            scrollFrame.CanvasPosition = Vector2.new(0, math.clamp(startScroll + scrollMove, 0, canvasSize - frameSize))
        end
    end)
    
    -- Mouse wheel scrolling
    scrollFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local relativeY = input.Position.Y - scrollFrame.AbsolutePosition.Y
            local percentY = relativeY / scrollFrame.AbsoluteSize.Y
            
            local canvasSize = scrollFrame.CanvasSize.Y.Offset
            local frameSize = scrollFrame.AbsoluteSize.Y
            
            scrollFrame.CanvasPosition = Vector2.new(0, math.clamp((canvasSize - frameSize) * percentY, 0, canvasSize - frameSize))
        end
    end)
    
    -- Initial update
    updateScrollbar()
    return scrollbar
end

-- UI Creation Functions
function LuminaUI:CreateWindow(settings)
    settings = settings or {}
    settings.Name = settings.Name or "LuminaUI"
    settings.Theme = settings.Theme or "Default"
    settings.Size = settings.Size or UDim2.new(0, 550, 0, 475)
    settings.Icon = settings.Icon or 0
    settings.ConfigurationSaving = settings.ConfigurationSaving or {Enabled = false}
    settings.KeySystem = settings.KeySystem or {Enabled = false}
    
    -- Set theme
    if settings.Theme and LuminaUI.Theme[settings.Theme] then
        SelectedTheme = LuminaUI.Theme[settings.Theme]
    end
    
    -- Create base UI
    if Library then
        Library:Destroy()
    end
    
    Library = Utility.createInstance("ScreenGui", {
        Name = "LuminaUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 100
    })
    
    -- Use appropriate parent based on environment
    if gethui then
        Library.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(Library)
        Library.Parent = CoreGui
    else
        Library.Parent = CoreGui
    end
    
    -- Key system (if enabled)
    if settings.KeySystem and settings.KeySystem.Enabled then
        local keyAccepted = false
        
        local KeySystemFrame = Utility.createInstance("Frame", {
            Name = "KeySystem",
            Size = UDim2.new(0, 320, 0, 150),
            Position = settings.UIPosition or UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = SelectedTheme.Background,
            Parent = Library
        })
        
        Utility.createCorner(KeySystemFrame, 6)
        
        local KeyTitle = Utility.createInstance("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = "Key System",
            TextColor3 = SelectedTheme.TextColor,
            TextSize = 16,
            Parent = KeySystemFrame
        })
        
        local KeyDescription = Utility.createInstance("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 30),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = settings.KeySystem.Message or "Please enter the key to access this script",
            TextColor3 = SelectedTheme.SubTextColor,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = KeySystemFrame
        })
        
        local KeyTextbox = Utility.createInstance("TextBox", {
            Name = "KeyInput",
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 75),
            BackgroundColor3 = SelectedTheme.InputBackground,
            PlaceholderText = "Enter Key",
            PlaceholderColor3 = SelectedTheme.InputPlaceholder,
            Text = "",
            TextColor3 = SelectedTheme.TextColor,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            ClearTextOnFocus = false,
            Parent = KeySystemFrame
        })
        
        Utility.createCorner(KeyTextbox, 4)
        Utility.createStroke(KeyTextbox, SelectedTheme.InputStroke, 1)
        
        local SubmitButton = Utility.createInstance("TextButton", {
            Name = "Submit",
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 110),
            BackgroundColor3 = SelectedTheme.ElementBackground,
            Font = Enum.Font.GothamBold,
            Text = "Submit",
            TextColor3 = SelectedTheme.TextColor,
            TextSize = 14,
            Parent = KeySystemFrame
        })
        
        Utility.createCorner(SubmitButton, 4)
        Utility.createStroke(SubmitButton, SelectedTheme.ElementStroke, 1)
        
        -- Submit key button effects
        SubmitButton.MouseEnter:Connect(function()
            TweenService:Create(SubmitButton, TweenInfo.new(0.3), {
                BackgroundColor3 = SelectedTheme.ElementBackgroundHover
            }):Play()
        end)
        
        SubmitButton.MouseLeave:Connect(function()
            TweenService:Create(SubmitButton, TweenInfo.new(0.3), {
                BackgroundColor3 = SelectedTheme.ElementBackground
            }):Play()
        end)
        
        local function checkKey(key)
            return (settings.KeySystem.Key == key) or 
                   (settings.KeySystem.Keys and table.find(settings.KeySystem.Keys, key)) or
                   false
        end
        
        SubmitButton.MouseButton1Click:Connect(function()
            if checkKey(KeyTextbox.Text) then
                keyAccepted = true
                KeySystemFrame:Destroy()
                -- Continue with UI creation
            else
                KeyTextbox.Text = ""
                TweenService:Create(KeyTextbox, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                }):Play()
                
                wait(0.5)
                TweenService:Create(KeyTextbox, TweenInfo.new(0.3), {
                    BackgroundColor3 = SelectedTheme.InputBackground
                }):Play()
            end
        end)
        
        -- Make key system draggable
        Utility.makeDraggable(KeySystemFrame)
        
        -- Wait for key before continuing
        repeat wait() until keyAccepted
    end
    
    -- Load configuration data
    local savedConfig = Utility.loadConfig(settings)
    
    -- Main window frame
    local MainFrame = Utility.createInstance("Frame", {
        Name = "MainFrame",
        Size = settings.Size,
        Position = settings.UIPosition or UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = SelectedTheme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = Library
    })
    
    Utility.createCorner(MainFrame, 8)
    
    -- Shadow
    local Shadow = Utility.createInstance("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 35, 1, 35),
        ZIndex = 0,
        Image = "rbxassetid://5554236805",
        ImageColor3 = SelectedTheme.Shadow,
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        SliceScale = 1,
        Parent = MainFrame
    })
    
    -- Topbar
    local Topbar = Utility.createInstance("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = SelectedTheme.Topbar,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    Utility.createCorner(Topbar, 8)
    
    local TopbarCornerFix = Utility.createInstance("Frame", {
        Name = "CornerFix",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = SelectedTheme.Topbar,
        BorderSizePixel = 0,
        Parent = Topbar
    })
    
    local TopbarTitle = Utility.createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = settings.Name,
        TextColor3 = SelectedTheme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar
    })
    
    if settings.Icon and settings.Icon ~= 0 then
        local Icon = Utility.createInstance("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = Utility.loadIcon(settings.Icon),
            Parent = Topbar
        })
        
        TopbarTitle.Position = UDim2.new(0, 40, 0, 0)
    end
    
    -- Control buttons
    local CloseButton = Utility.createInstance("ImageButton", {
        Name = "Close",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -15, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10734953387",
        ImageColor3 = SelectedTheme.TextColor,
        ImageTransparency = 0.2,
        Parent = Topbar
    })
    
    local MinimizeButton = Utility.createInstance("ImageButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -45, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10734950966",
        ImageColor3 = SelectedTheme.TextColor,
        ImageTransparency = 0.2,
        Parent = Topbar
    })
    
    local SettingsButton = Utility.createInstance("ImageButton", {
        Name = "Settings",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -75, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031280882", -- Settings icon
        ImageColor3 = SelectedTheme.TextColor,
        ImageTransparency = 0.2,
        Parent = Topbar
    })
    
    -- Content container
    local ContentContainer = Utility.createInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -10, 1, -55),
        Position = UDim2.new(0, 5, 0, 50),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    -- Tab container
    local TabContainer = Utility.createInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 130, 1, 0),
        BackgroundTransparency = 1,
        Parent = ContentContainer
    })
    
    local TabScrollFrame = Utility.createInstance("ScrollingFrame", {
        Name = "TabScrollFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        BorderSizePixel = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = TabContainer
    })
    
    local TabListLayout = Utility.createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabScrollFrame
    })
    
    local TabPadding = Utility.createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        Parent = TabScrollFrame
    })
    
    -- Elements container
    local ElementsContainer = Utility.createInstance("Frame", {
        Name = "ElementsContainer",
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.new(0, 140, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = ContentContainer
    })
    
    local ElementsPageFolder = Utility.createInstance("Folder", {
        Name = "Pages",
        Parent = ElementsContainer
    })
    
    -- Settings page
    local SettingsPage = Utility.createInstance("ScrollingFrame", {
        Name = "Settings",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = ElementsPageFolder
    })
    
    local SettingsListLayout = Utility.createInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = SettingsPage
    })
    
    local SettingsPadding = Utility.createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = SettingsPage
    })
    
    local ThemeTitle = Utility.createInstance("Frame", {
        Name = "ThemeSection",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = SettingsPage
    })
    
    local ThemeTitleText = Utility.createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = "Theme Settings",
        TextColor3 = SelectedTheme.TextColor,
        TextSize = 14,
        TextTransparency = 0.4,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ThemeTitle
    })
    
    -- Theme selector buttons
    local function createThemeButton(themeName, position)
        local ThemeButton = Utility.createInstance("Frame", {
            Name = themeName.."Theme",
            Size = UDim2.new(0, 90, 0, 90),
            Position = position,
            BackgroundColor3 = LuminaUI.Theme[themeName].ElementBackground,
            Parent = SettingsPage
        })
        
        Utility.createCorner(ThemeButton, 6)
        Utility.createStroke(ThemeButton, SelectedTheme.ElementStroke, 1)
        
        local ThemePreview = Utility.createInstance("Frame", {
            Name = "Preview",
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundColor3 = LuminaUI.Theme[themeName].Topbar,
            Parent = ThemeButton
        })
        
        Utility.createCorner(ThemePreview, 4)
        
        local ThemeColor1 = Utility.createInstance("Frame", {
            Name = "Color1",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0, 40),
            BackgroundColor3 = LuminaUI.Theme[themeName].ToggleEnabled,
            Parent = ThemeButton
        })
        
        Utility.createCorner(ThemeColor1, 4)
        
        local ThemeColor2 = Utility.createInstance("Frame", {
            Name = "Color2",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 30, 0, 40),
            BackgroundColor3 = LuminaUI.Theme[themeName].SliderProgress,
            Parent = ThemeButton
        })
        
        Utility.createCorner(ThemeColor2, 4)
        
        local ThemeText = Utility.createInstance("TextLabel", {
            Name = "Text",
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 65),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = themeName,
            TextColor3 = LuminaUI.Theme[themeName].TextColor,
            TextSize = 12,
            Parent = ThemeButton
        })
        
        local ThemeButtonInteract = Utility.createInstance("TextButton", {
            Name = "Interact",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = ThemeButton
        })
        
        ThemeButtonInteract.MouseButton1Click:Connect(function()
            SelectedTheme = LuminaUI.Theme[themeName]
            settings.Theme = themeName
            
            -- Refresh UI with new theme
            -- This is a simple implementation. In a real scenario, you'd want to update all elements.
            MainFrame.BackgroundColor3 = SelectedTheme.Background
            Topbar.BackgroundColor3 = SelectedTheme.Topbar
            TopbarCornerFix.BackgroundColor3 = SelectedTheme.Topbar
        end)
        
        return ThemeButton
    end
    
    local ThemeButtonDefault = createThemeButton("Default", UDim2.new(0, 0, 0, 40))
    local ThemeButtonDark = createThemeButton("Dark", UDim2.new(0, 100, 0, 40))
    local ThemeButtonOcean = createThemeButton("Ocean", UDim2.new(0, 200, 0, 40))
    local ThemeButtonPurple = createThemeButton("Purple", UDim2.new(0, 300, 0, 40))
    
    -- Auto-size canvas for settings
    SettingsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SettingsPage.CanvasSize = UDim2.new(0, 0, 0, SettingsListLayout.AbsoluteContentSize.Y + 16)
    end)
    
    -- Apply custom scrollbar to settings
    Utility.applyCustomScrollbar(SettingsPage)
    
    -- Make the UI draggable
    Utility.makeDraggable(MainFrame, Topbar)
    
    -- Create notification container
    local Notifications = Utility.createInstance("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 260, 1, -10),
        Position = UDim2.new(1, -280, 0, 5),
        BackgroundTransparency = 1,
        Parent = Library
    })
    
    local NotificationListLayout = Utility.createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = Notifications
    })
    
    -- Button functionality
    CloseButton.MouseButton1Click:Connect(function()
        -- Capture position before closing for config saving
        local position = MainFrame.Position
        settings.UIPosition = position
        
        -- Save configuration
        Utility.saveConfig(settings)
        
        -- Close with animation
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 0),
            Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + MainFrame.Size.Y.Offset/2)
        }):Play()
        
        wait(0.3)
        Library:Destroy()
    end)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        if minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 45)
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                Size = settings.Size
            }):Play()
        end
    end)
    
    -- Settings button toggles settings page
    local settingsOpen = false
    SettingsButton.MouseButton1Click:Connect(function()
        settingsOpen = not settingsOpen
        
        for _, page in ipairs(ElementsPageFolder:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                page.Visible = page.Name == "Settings" and settingsOpen or (not settingsOpen and page.Visible)
            end
        end
    end)
    
    -- Button hover effects
    for _, button in ipairs({CloseButton, MinimizeButton, SettingsButton}) do
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.3), {ImageTransparency = 0.2}):Play()
        end)
    end
    
    -- Window API
    local Window = {}
    
    function Window:CreateNotification(notificationSettings)
        notificationSettings = notificationSettings or {}
        notificationSettings.Title = notificationSettings.Title or "Notification"
        notificationSettings.Content = notificationSettings.Content or "Content"
        notificationSettings.Duration = notificationSettings.Duration or 5
        notificationSettings.Icon = notificationSettings.Icon or 0
        
        local Notification = Utility.createInstance("Frame", {
            Name = "Notification",
            Size = UDim2.new(0, 260, 0, 80),
            BackgroundColor3 = SelectedTheme.NotificationBackground,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 0, 0),
            Parent = Notifications
        })
        
        Utility.createCorner(Notification, 6)
        
        local NotificationContent = Utility.createInstance("Frame", {
            Name = "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Parent = Notification
        })
        
        local hasIcon = notificationSettings.Icon ~= 0
        local iconSize = hasIcon and 24 or 0
        local iconPadding = hasIcon and 10 or 0
        
        local NotificationTitle = Utility.createInstance("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -(15 + iconSize + iconPadding), 0, 25),
            Position = UDim2.new(0, 15 + iconSize + iconPadding, 0, 5),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = notificationSettings.Title,
            TextColor3 = SelectedTheme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1,
            Parent = NotificationContent
        })
        
        local NotificationBody = Utility.createInstance("TextLabel", {
            Name = "Body",
            Size = UDim2.new(1, -(15 + iconSize + iconPadding), 0, 40),
            Position = UDim2.new(0, 15 + iconSize + iconPadding, 0, 30),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = notificationSettings.Content,
            TextColor3 = SelectedTheme.SubTextColor,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextTransparency = 1,
            Parent = NotificationContent
        })
        
        if hasIcon then
            local NotificationIcon = Utility.createInstance("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, iconSize, 0, iconSize),
                Position = UDim2.new(0, 15, 0, 15),
                BackgroundTransparency = 1,
                Image = Utility.loadIcon(notificationSettings.Icon),
                ImageTransparency = 1,
                Parent = NotificationContent
            })
            
            -- Animate icon
            TweenService:Create(NotificationIcon, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                ImageTransparency = 0
            }):Play()
        end
        
        -- Progress bar for duration
        local ProgressBar = Utility.createInstance("Frame", {
            Name = "ProgressBar",
            Size = UDim2.new(1, 0, 0, 3),
            Position = UDim2.new(0, 0, 1, -3),
            BackgroundColor3 = SelectedTheme.ProgressBarBackground,
            BackgroundTransparency = 0.5,
            Parent = Notification
        })
        
        local Progress = Utility.createInstance("Frame", {
            Name = "Progress",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = SelectedTheme.ProgressBarFill,
            Parent = ProgressBar
        })
        
        -- Close button
        local CloseNotification = Utility.createInstance("ImageButton", {
            Name = "Close",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -10, 0, 10),
            BackgroundTransparency = 1,
            Image = "rbxassetid://10734953387",
            ImageColor3 = SelectedTheme.TextColor,
            ImageTransparency = 1,
            Parent = NotificationContent
        })
        
        -- Close notification on click
        CloseNotification.MouseButton1Click:Connect(function()
            -- Stop all tweens
            for _, tween in ipairs(TweenService:GetChildren()) do
                if tween.Instance == Progress or tween.Instance == Notification or tween.Instance == NotificationTitle or tween.Instance == NotificationBody then
                    tween:Cancel()
                end
            end
            
            -- Fade out animation
            TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(NotificationTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(NotificationBody, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(CloseNotification, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                ImageTransparency = 1
            }):Play()
            
            wait(0.5)
            Notification:Destroy()
        end)
        
        -- Animation
        TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        TweenService:Create(NotificationTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            TextTransparency = 0
        }):Play()
        
        TweenService:Create(NotificationBody, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            TextTransparency = 0
        }):Play()
        
        TweenService:Create(CloseNotification, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            ImageTransparency = 0.2
        }):Play()
        
        -- Progress bar animation
        TweenService:Create(Progress, TweenInfo.new(notificationSettings.Duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 1, 0)
        }):Play()
        
        -- Remove after duration
        task.delay(notificationSettings.Duration, function()
            if not Notification or not Notification.Parent then return end
            
            TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(NotificationTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(NotificationBody, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(CloseNotification, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                ImageTransparency = 1
            }):Play()
            
            task.delay(0.5, function()
                if Notification and Notification.Parent then
                    Notification:Destroy()
                end
            end)
        end)
        
        return Notification
    end
    
    function Window:CreateTab(tabName, icon)
        local tabIcon = icon or 0
        
        -- Create tab button
        local TabButton = Utility.createInstance("Frame", {
            Name = tabName,
            Size = UDim2.new(1, -10, 0, 34),
            BackgroundColor3 = SelectedTheme.TabBackground,
            BackgroundTransparency = 0.7,
            Parent = TabScrollFrame
        })
        
        Utility.createCorner(TabButton, 6)
        
        local TabUIStroke = Utility.createStroke(TabButton, SelectedTheme.TabStroke, 1, 0.5)
        
        local tabIconSize = 16
        local tabIconPadding = tabIcon ~= 0 and 24 or 0
        
        local TabTitle = Utility.createInstance("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -(10 + tabIconPadding), 1, 0),
            Position = UDim2.new(0, tabIconPadding + 10, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = tabName,
            TextColor3 = SelectedTheme.TabTextColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.2,
            Parent = TabButton
        })
        
        -- Add tab icon if provided
        if tabIcon ~= 0 then
            local TabImage = Utility.createInstance("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, tabIconSize, 0, tabIconSize),
                Position = UDim2.new(0, 8, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image = Utility.loadIcon(tabIcon),
                ImageColor3 = SelectedTheme.TabTextColor,
                ImageTransparency = 0.2,
                Parent = TabButton
            })
        end
        
        local TabInteract = Utility.createInstance("TextButton", {
            Name = "Interact",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = TabButton
        })
        
        -- Create page for tab content
        local TabPage = Utility.createInstance("ScrollingFrame", {
            Name = tabName,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Parent = ElementsPageFolder
        })
        
        local ElementsListLayout = Utility.createInstance("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabPage
        })
        
        local ElementsPadding = Utility.createInstance("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            Parent = TabPage
        })
        
        -- Apply custom scrollbar
        Utility.applyCustomScrollbar(TabPage)
        
        -- Auto-size canvas
        ElementsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, ElementsListLayout.AbsoluteContentSize.Y + 16)
        end)
        
        -- Handle tab selection
        TabInteract.MouseButton1Click:Connect(function()
            for _, tab in ipairs(TabScrollFrame:GetChildren()) do
                if tab:IsA("Frame") and tab ~= TabButton then
                    -- Deselect other tabs
                    TweenService:Create(tab, TweenInfo.new(0.3), {
                        BackgroundColor3 = SelectedTheme.TabBackground,
                        BackgroundTransparency = 0.7
                    }):Play()
                    
                    if tab:FindFirstChild("Title") then
                        TweenService:Create(tab.Title, TweenInfo.new(0.3), {
                            TextColor3 = SelectedTheme.TabTextColor,
                            TextTransparency = 0.2
                        }):Play()
                    end
                    
                    if tab:FindFirstChild("Icon") then
                        TweenService:Create(tab.Icon, TweenInfo.new(0.3), {
                            ImageColor3 = SelectedTheme.TabTextColor,
                            ImageTransparency = 0.2
                        }):Play()
                    end
                    
                    local tabUIStroke = tab:FindFirstChildOfClass("UIStroke")
                    if tabUIStroke then
                        TweenService:Create(tabUIStroke, TweenInfo.new(0.3), {
                            Transparency = 0.5
                        }):Play()
                    end
                end
            end
            
            -- Hide all pages
            for _, page in ipairs(ElementsPageFolder:GetChildren()) do
                if page:IsA("ScrollingFrame") and page.Name ~= "Settings" then
                    page.Visible = false
                end
            end
            
            -- Select this tab
            TweenService:Create(TabButton, TweenInfo.new(0.3), {
                BackgroundColor3 = SelectedTheme.TabBackgroundSelected,
                BackgroundTransparency = 0
            }):Play()
            
            TweenService:Create(TabTitle, TweenInfo.new(0.3), {
                TextColor3 = SelectedTheme.SelectedTabTextColor,
                TextTransparency = 0
            }):Play()
            
            if TabButton:FindFirstChild("Icon") then
                TweenService:Create(TabButton.Icon, TweenInfo.new(0.3), {
                    ImageColor3 = SelectedTheme.SelectedTabTextColor,
                    ImageTransparency = 0
                }):Play()
            end
            
            if TabUIStroke then
                TweenService:Create(TabUIStroke, TweenInfo.new(0.3), {
                    Transparency = 0
                }):Play()
            end
            
            -- Show this page
            TabPage.Visible = true
            TabPage.CanvasPosition = Vector2.new(0, 0)
        end)
        
        -- Add Tab methods and return Tab object
        local Tab = {}
        
        function Tab:CreateSection(sectionName)
            local SectionContainer = Utility.createInstance("Frame", {
                Name = "Section_" .. sectionName,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Parent = TabPage
            })
            
            local SectionTitle = Utility.createInstance("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, 0, 0, 26),
                Position = UDim2.new(0, 0, 0, 5),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                Text = sectionName,
                TextColor3 = SelectedTheme.TextColor,
                TextSize = 14,
                TextTransparency = 0.2,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionContainer
            })
            
            local SectionLine = Utility.createInstance("Frame", {
                Name = "Line",
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = SelectedTheme.ElementStroke,
                BackgroundTransparency = 0.5,
                Parent = SectionContainer
            })
            
            return SectionContainer
        end
        
        return Tab
    end
    
    return Window
end

return LuminaUI
