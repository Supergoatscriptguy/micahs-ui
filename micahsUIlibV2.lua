--[[
    MicahsUI v2 - Enhanced UI Library
    Inspired by modern UI aesthetics and interactions.
]]

local MicahsUI = {}
MicahsUI.__index = MicahsUI

-- Roblox Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

-- Default Configuration & Themes
MicahsUI.Themes = {
    Default = {
        BackgroundColor = Color3.fromRGB(30, 30, 40),      -- Slightly darker base
        SecondaryColor = Color3.fromRGB(40, 40, 50),     -- Slightly darker secondary
        AccentColor = Color3.fromRGB(114, 137, 218),     -- Discord-like blue/purple
        AccentColorHover = Color3.fromRGB(134, 157, 238), -- Lighter accent for hover
        AccentColorActive = Color3.fromRGB(94, 117, 198), -- Darker accent for active/click
        TextColor = Color3.fromRGB(240, 240, 245),       -- Slightly off-white
        ElementBackgroundColor = Color3.fromRGB(50, 50, 60), -- Element base
        ElementBorderColor = Color3.fromRGB(70, 70, 80),   -- Subtle border/inactive color
        InactiveColor = Color3.fromRGB(100, 100, 110),    -- Darker inactive
        SuccessColor = Color3.fromRGB(87, 242, 135),
        WarningColor = Color3.fromRGB(254, 231, 92),
        ErrorColor = Color3.fromRGB(237, 66, 69),
        ShadowColor = Color3.fromRGB(10, 10, 15),
    },
    -- Add other themes (Dark, Light) here, adjusting colors similarly
    Dark = {
        BackgroundColor = Color3.fromRGB(20, 20, 20),
        SecondaryColor = Color3.fromRGB(28, 28, 28),
        AccentColor = Color3.fromRGB(0, 175, 255), -- Cyan
        AccentColorHover = Color3.fromRGB(50, 195, 255),
        AccentColorActive = Color3.fromRGB(0, 155, 235),
        TextColor = Color3.fromRGB(235, 235, 235),
        ElementBackgroundColor = Color3.fromRGB(35, 35, 35),
        ElementBorderColor = Color3.fromRGB(50, 50, 50),
        InactiveColor = Color3.fromRGB(90, 90, 90),
        SuccessColor = Color3.fromRGB(87, 242, 135),
        WarningColor = Color3.fromRGB(254, 231, 92),
        ErrorColor = Color3.fromRGB(237, 66, 69),
        ShadowColor = Color3.fromRGB(0, 0, 0),
    },
    Light = {
        BackgroundColor = Color3.fromRGB(245, 245, 248),
        SecondaryColor = Color3.fromRGB(235, 235, 240),
        AccentColor = Color3.fromRGB(0, 120, 215), -- Windows blue
        AccentColorHover = Color3.fromRGB(30, 140, 235),
        AccentColorActive = Color3.fromRGB(0, 100, 195),
        TextColor = Color3.fromRGB(30, 30, 30),
        ElementBackgroundColor = Color3.fromRGB(255, 255, 255),
        ElementBorderColor = Color3.fromRGB(200, 200, 205),
        InactiveColor = Color3.fromRGB(150, 150, 155),
        SuccessColor = Color3.fromRGB(16, 185, 129),
        WarningColor = Color3.fromRGB(245, 158, 11),
        ErrorColor = Color3.fromRGB(220, 38, 38),
        ShadowColor = Color3.fromRGB(180, 180, 190),
    }
}

-- Utility Functions
local function Create(instanceType, properties)
    local inst = Instance.new(instanceType)
    for prop, val in pairs(properties or {}) do
        inst[prop] = val
    end
    return inst
end

local function TweenProp(instance, property, endValue, duration, style, direction, callback)
    duration = duration or 0.2
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local goal = {}
    goal[property] = endValue
    local tween = TweenService:Create(instance, tweenInfo, goal)
    if callback then
        local connection
        connection = tween.Completed:Connect(function(state)
            connection:Disconnect()
            callback(state)
        end)
    end
    tween:Play()
    return tween
end

local function TweenProps(instance, properties, duration, style, direction, callback)
    duration = duration or 0.2
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    if callback then
        local connection
        connection = tween.Completed:Connect(function(state)
            connection:Disconnect()
            callback(state)
        end)
    end
    tween:Play()
    return tween
end

-- Main UI Creation Function
function MicahsUI:Create(config)
    local windowConfig = config or {}
    local title = windowConfig.Title or "MicahsUI v2"
    local themeName = windowConfig.Theme or "Default"
    local theme = self.Themes[themeName] or self.Themes.Default
    local initialSize = windowConfig.Size or UDim2.new(0, 600, 0, 400)
    local initialPosition = windowConfig.Position or UDim2.new(0.5, -initialSize.X.Offset / 2, 0.5, -initialSize.Y.Offset / 2)

    -- UI Instance Setup
    local UI = {
        _connections = {}, -- Store connections to disconnect later
        _activeTweens = {} -- Store active tweens to cancel if needed
    }
    setmetatable(UI, self)
    UI.Theme = theme

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "MicahsUI_" .. title:gsub("%s+", ""),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    table.insert(UI._connections, ScreenGui.Destroying:Connect(function()
        -- Clean up connections and tweens
        for _, conn in ipairs(UI._connections) do conn:Disconnect() end
        for _, tween in pairs(UI._activeTweens) do if tween then tween:Cancel() end end
    end))

    -- Main Frame (Window)
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = theme.BackgroundColor,
        BorderSizePixel = 0,
        Position = initialPosition,
        Size = initialSize,
        AnchorPoint = Vector2.new(0, 0), -- Use top-left for easier positioning if needed
        ClipsDescendants = true, -- Helps contain elements like shadows
    })
    UI.MainFrame = MainFrame

    Create("UICorner", { Parent = MainFrame, CornerRadius = UDim.new(0, 8) })

    -- Shadow (Optional, can be disabled via config)
    if windowConfig.ShadowEnabled ~= false then
        Create("ImageLabel", {
            Name = "Shadow",
            Parent = MainFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -10, 0, -10), -- Adjust offset as needed
            Size = UDim2.new(1, 20, 1, 20),      -- Adjust size as needed
            ZIndex = -1,
            Image = "rbxassetid://5028857084", -- Standard shadow asset
            ImageColor3 = theme.ShadowColor,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(24, 24, 276, 276),
            ImageTransparency = 0.6
        })
    end

    -- Title Bar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = theme.SecondaryColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36) -- Slightly shorter title bar
    })

    -- Title Text
    Create("TextLabel", {
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -50, 1, 0), -- Leave space for buttons
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = theme.TextColor,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Close Button
    local CloseButton = Create("TextButton", {
        Name = "CloseButton",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -36, 0, 0),
        Size = UDim2.new(0, 36, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "✕",
        TextColor3 = theme.InactiveColor, -- Start dimmer
        TextSize = 18
    })
    table.insert(UI._connections, CloseButton.MouseEnter:Connect(function()
        TweenProp(CloseButton, "TextColor3", theme.ErrorColor, 0.15)
    end))
    table.insert(UI._connections, CloseButton.MouseLeave:Connect(function()
        TweenProp(CloseButton, "TextColor3", theme.InactiveColor, 0.15)
    end))
    table.insert(UI._connections, CloseButton.MouseButton1Click:Connect(function()
        -- Optional: Add a fade-out animation before destroying
        TweenProps(MainFrame, {BackgroundTransparency = 1, Size = MainFrame.Size - UDim2.new(0, 20, 0, 20), Position = MainFrame.Position + UDim2.new(0, 10, 0, 10)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
            ScreenGui:Destroy()
        end)
    end))

    -- Main Content Area (Below Title Bar)
    local MainContent = Create("Frame", {
        Name = "MainContent",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 36), -- Position below title bar
        Size = UDim2.new(1, 0, 1, -36)    -- Fill remaining space
    })

    -- Tab Container (Left Side)
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = MainContent,
        BackgroundColor3 = theme.SecondaryColor, -- Match title bar
        BorderSizePixel = 0,
        Position = UDim2.new(0, 8, 0, 8), -- Padding from edges
        Size = UDim2.new(0, 140, 1, -16) -- Width for tabs, padding applied
    })
    Create("UICorner", { Parent = TabContainer, CornerRadius = UDim.new(0, 6) })

    -- Content Container (Right Side)
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = MainContent,
        BackgroundColor3 = theme.SecondaryColor, -- Match tab container
        BorderSizePixel = 0,
        Position = UDim2.new(0, 156, 0, 8), -- Position next to tabs + padding
        Size = UDim2.new(1, -164, 1, -16), -- Fill remaining space with padding
        ClipsDescendants = true -- Important for tab transition animations
    })
    Create("UICorner", { Parent = ContentContainer, CornerRadius = UDim.new(0, 6) })
    UI.ContentContainer = ContentContainer -- Expose for potential direct manipulation if needed

    -- ScrollingFrame for Tabs
    local TabScroll = Create("ScrollingFrame", {
        Name = "TabScroll",
        Parent = TabContainer,
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0), -- Fill TabContainer
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.AccentColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
    })
    UI.TabScroll = TabScroll

    Create("UIListLayout", {
        Parent = TabScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    Create("UIPadding", {
        Parent = TabScroll,
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5)
    })

    -- Store UI elements
    UI.ScreenGui = ScreenGui
    UI.Tabs = {}
    UI.ActiveTab = nil
    UI.ActiveTabPage = nil

    -- Make UI draggable
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    table.insert(UI._connections, TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            -- Optional: Bring to front visually if multiple UIs exist
            ScreenGui.DisplayOrder = ScreenGui.DisplayOrder + 1
        end
    end))
    table.insert(UI._connections, UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end))
    table.insert(UI._connections, UserInputService.InputEnded:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            isDragging = false
        end
    end))

    -- Tab Management
    function UI:AddTab(tabName, icon)
        local tabIndex = #self.Tabs + 1

        -- Create Tab Button
        local TabButton = Create("TextButton", {
            Name = "Tab_" .. tabName:gsub("%s+", ""),
            Parent = TabScroll,
            BackgroundColor3 = theme.ElementBackgroundColor,
            Size = UDim2.new(1, -10, 0, 36), -- Slightly smaller, centered by ListLayout
            Font = Enum.Font.GothamSemibold,
            Text = " " .. tabName, -- Add space for potential icon
            TextColor3 = theme.InactiveColor, -- Start inactive
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            LayoutOrder = tabIndex
        })
        Create("UICorner", { Parent = TabButton, CornerRadius = UDim.new(0, 4) })
        Create("UIPadding", { Parent = TabButton, PaddingLeft = UDim.new(0, 8) }) -- Padding for text/icon

        -- Icon (if provided)
        if icon then
            Create("ImageLabel", {
                Name = "Icon",
                Parent = TabButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 8, 0.5, -9), -- Position left
                Image = icon,
                ImageColor3 = theme.InactiveColor, -- Match text color initially
                ScaleType = Enum.ScaleType.Fit
            })
            TabButton.Text = "      " .. tabName -- Add more space if icon exists
        end

        -- Create Tab Content Page (ScrollingFrame)
        local TabPage = Create("ScrollingFrame", {
            Name = "Page_" .. tabName:gsub("%s+", ""),
            Parent = ContentContainer,
            BackgroundTransparency = 1, -- Fully transparent, content provides background
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = theme.AccentColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false, -- Initially hidden
            ClipsDescendants = true,
            -- Use GroupTransparency for fade effect
            GroupTransparency = 1 -- Start fully transparent
        })

        local ContentList = Create("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8), -- Consistent padding
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })

        Create("UIPadding", {
            Parent = TabPage,
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })

        -- Auto-adjust canvas size
        table.insert(UI._connections, ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, TabPage.AbsoluteSize.X, 0, ContentList.AbsoluteContentSize.Y + 20) -- Add bottom padding
        end))

        -- Tab Data Structure
        local tab = {
            Button = TabButton,
            Page = TabPage,
            Name = tabName,
            Index = tabIndex,
            IconInstance = TabButton:FindFirstChild("Icon")
        }
        table.insert(self.Tabs, tab)

        -- Tab Button Hover Effects & Click Handler
        table.insert(UI._connections, TabButton.MouseEnter:Connect(function()
            if self.ActiveTab ~= tabIndex then
                TweenProp(TabButton, "BackgroundColor3", theme.ElementBorderColor, 0.15)
                TweenProp(TabButton, "TextColor3", theme.TextColor, 0.15)
                if tab.IconInstance then TweenProp(tab.IconInstance, "ImageColor3", theme.TextColor, 0.15) end
            end
        end))
        table.insert(UI._connections, TabButton.MouseLeave:Connect(function()
            if self.ActiveTab ~= tabIndex then
                TweenProp(TabButton, "BackgroundColor3", theme.ElementBackgroundColor, 0.15)
                TweenProp(TabButton, "TextColor3", theme.InactiveColor, 0.15)
                if tab.IconInstance then TweenProp(tab.IconInstance, "ImageColor3", theme.InactiveColor, 0.15) end
            end
        end))
        table.insert(UI._connections, TabButton.MouseButton1Click:Connect(function()
            self:SelectTab(tabIndex)
        end))

        -- Update TabScroll canvas size after adding button
        task.wait() -- Wait a frame for layout to update
        local listLayout = TabScroll:FindFirstChildOfClass("UIListLayout")
        if listLayout then
            TabScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10) -- Add padding
        end

        -- Select the first tab by default
        if tabIndex == 1 then
            self:SelectTab(1)
        else
            -- Ensure inactive state visually
            TabButton.BackgroundColor3 = theme.ElementBackgroundColor
            TabButton.TextColor3 = theme.InactiveColor
            if tab.IconInstance then tab.IconInstance.ImageColor3 = theme.InactiveColor end
        end

        -- ========================== Elements API ==========================
        local Elements = {}

        -- Add Label
        function Elements:AddLabel(text, size)
            local labelSize = size or 14
            local Label = Create("TextLabel", {
                Name = "Label",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, labelSize + 6), -- Auto height based on text size + padding
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = theme.TextColor,
                TextSize = labelSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                LayoutOrder = #TabPage:GetChildren() -- Maintain order
            })
            return Label
        end

        -- Add Button
        function Elements:AddButton(config)
            local buttonConfig = config or {}
            local buttonText = buttonConfig.Text or "Button"
            local callback = buttonConfig.Callback or function() print("Button clicked: " .. buttonText) end
            local height = buttonConfig.Height or 36

            local Button = Create("TextButton", {
                Name = "Button_" .. buttonText:gsub("%s+", ""),
                Parent = TabPage,
                BackgroundColor3 = theme.AccentColor,
                Size = UDim2.new(1, -10, 0, height),
                Font = Enum.Font.GothamSemibold,
                Text = buttonText,
                TextColor3 = theme.TextColor,
                TextSize = 14,
                BorderSizePixel = 0,
                LayoutOrder = #TabPage:GetChildren()
            })
            Create("UICorner", { Parent = Button, CornerRadius = UDim.new(0, 4) })

            -- Hover & Click Animations
            local originalColor = theme.AccentColor
            local hoverColor = theme.AccentColorHover
            local activeColor = theme.AccentColorActive

            table.insert(UI._connections, Button.MouseEnter:Connect(function()
                TweenProp(Button, "BackgroundColor3", hoverColor, 0.15)
            end))
            table.insert(UI._connections, Button.MouseLeave:Connect(function()
                TweenProp(Button, "BackgroundColor3", originalColor, 0.15)
            end))
            table.insert(UI._connections, Button.MouseButton1Down:Connect(function()
                TweenProp(Button, "BackgroundColor3", activeColor, 0.1)
            end))
            table.insert(UI._connections, Button.MouseButton1Up:Connect(function()
                -- Check if mouse is still over button before tweening back to hover
                local mousePos = UserInputService:GetMouseLocation()
                local guiPos = Button.AbsolutePosition
                local guiSize = Button.AbsoluteSize
                if mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and
                   mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y then
                    TweenProp(Button, "BackgroundColor3", hoverColor, 0.1)
                else
                    TweenProp(Button, "BackgroundColor3", originalColor, 0.1)
                end
            end))
            table.insert(UI._connections, Button.MouseButton1Click:Connect(callback))

            return Button -- Return the instance for potential further manipulation
        end

        -- Add Toggle
        function Elements:AddToggle(config)
            local toggleConfig = config or {}
            local toggleText = toggleConfig.Text or "Toggle"
            local default = toggleConfig.Default or false
            local callback = toggleConfig.Callback or function(state) print("Toggle changed:", state) end

            local ToggleHolder = Create("Frame", {
                Name = "ToggleHolder_" .. toggleText:gsub("%s+", ""),
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 40), -- Standard height
                LayoutOrder = #TabPage:GetChildren()
            })

            local ToggleButton = Create("TextButton", { -- Use TextButton for easier click detection
                Name = "ToggleButton",
                Parent = ToggleHolder,
                BackgroundColor3 = theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "", -- No text on the button itself
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = ToggleButton, CornerRadius = UDim.new(0, 4) })

            Create("TextLabel", {
                Name = "ToggleLabel",
                Parent = ToggleButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0), -- Leave space for the switch
                Font = Enum.Font.Gotham,
                Text = toggleText,
                TextColor3 = theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            -- The visual switch part
            local SwitchTrack = Create("Frame", {
                Name = "SwitchTrack",
                Parent = ToggleButton,
                Position = UDim2.new(1, -50, 0.5, -10), -- Position right
                Size = UDim2.new(0, 36, 0, 20),        -- Standard switch size
                BackgroundColor3 = default and theme.AccentColor or theme.InactiveColor,
                BorderSizePixel = 0
            })
            Create("UICorner", { Parent = SwitchTrack, CornerRadius = UDim.new(1, 0) }) -- Fully rounded

            local SwitchThumb = Create("Frame", {
                Name = "SwitchThumb",
                Parent = SwitchTrack,
                Position = default and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), -- Start pos based on default
                AnchorPoint = Vector2.new(default and 1 or 0, 0.5),
                Size = UDim2.new(0, 16, 0, 16), -- Slightly smaller thumb
                BackgroundColor3 = theme.TextColor, -- White thumb
                BorderSizePixel = 0
            })
            Create("UICorner", { Parent = SwitchThumb, CornerRadius = UDim.new(1, 0) }) -- Fully rounded thumb

            local toggled = default

            local function updateToggleVisuals(animate)
                local duration = animate and 0.15 or 0
                local targetTrackColor = toggled and theme.AccentColor or theme.InactiveColor
                local targetThumbPos = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                local targetAnchor = Vector2.new(toggled and 1 or 0, 0.5)

                TweenProp(SwitchTrack, "BackgroundColor3", targetTrackColor, duration)
                -- Animate both Position and AnchorPoint for smooth slide
                TweenProps(SwitchThumb, { Position = targetThumbPos, AnchorPoint = targetAnchor }, duration)
            end

            table.insert(UI._connections, ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggleVisuals(true) -- Animate the change
                callback(toggled)
            end))

            -- Initial state (no animation)
            updateToggleVisuals(false)
            -- Initial callback call if default is true
            if default then task.defer(callback, true) end

            -- Return API for the toggle
            local toggleAPI = {}
            function toggleAPI:Set(value, silent)
                value = not not value -- Ensure boolean
                if value ~= toggled then
                    toggled = value
                    updateToggleVisuals(true)
                    if not silent then
                        callback(toggled)
                    end
                end
            end
            function toggleAPI:Get()
                return toggled
            end
            return toggleAPI
        end

        -- Add Slider
        function Elements:AddSlider(config)
            local sliderConfig = config or {}
            local sliderText = sliderConfig.Text or "Slider"
            local min = sliderConfig.Min or 0
            local max = sliderConfig.Max or 100
            local default = sliderConfig.Default or min
            local decimals = sliderConfig.Decimals or 0
            local callback = sliderConfig.Callback or function(value) print("Slider changed:", value) end
            local suffix = sliderConfig.Suffix or ""

            default = math.clamp(default, min, max)
            local currentValue = default

            local function formatValue(value)
                local format = "%." .. decimals .. "f"
                return string.format(format, value) .. suffix
            end

            local SliderHolder = Create("Frame", {
                Name = "SliderHolder_" .. sliderText:gsub("%s+", ""),
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 55), -- Slightly taller for labels
                LayoutOrder = #TabPage:GetChildren()
            })

            -- Top labels (Title and Value)
            local LabelFrame = Create("Frame", {
                Name = "LabelFrame",
                Parent = SliderHolder,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20)
            })
            Create("TextLabel", {
                Name = "SliderLabel", Parent = LabelFrame, BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0.7, 0, 1, 0),
                Font = Enum.Font.Gotham, Text = sliderText, TextColor3 = theme.TextColor,
                TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })
            local ValueLabel = Create("TextLabel", {
                Name = "ValueLabel", Parent = LabelFrame, BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0.3, 0, 1, 0),
                AnchorPoint = Vector2.new(1, 0), Font = Enum.Font.GothamSemibold,
                Text = formatValue(default), TextColor3 = theme.TextColor,
                TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right
            })

            -- Slider interaction area
            local SliderInteractArea = Create("Frame", {
                Name = "SliderInteractArea",
                Parent = SliderHolder,
                BackgroundTransparency = 1, -- Make this clickable area transparent
                Position = UDim2.new(0, 0, 0, 25), -- Below labels
                Size = UDim2.new(1, 0, 0, 30)      -- Height for interaction + track
            })

            -- Visual track background
            local SliderTrack = Create("Frame", {
                Name = "SliderTrack",
                Parent = SliderInteractArea,
                BackgroundColor3 = theme.ElementBackgroundColor,
                Position = UDim2.new(0, 0, 0.5, -3), -- Center vertically
                Size = UDim2.new(1, 0, 0, 6),       -- Thicker track
                BorderSizePixel = 0
            })
            Create("UICorner", { Parent = SliderTrack, CornerRadius = UDim.new(1, 0) })

            -- Visual fill/progress bar
            local SliderFill = Create("Frame", {
                Name = "SliderFill",
                Parent = SliderTrack,
                BackgroundColor3 = theme.AccentColor,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0), -- Initial fill based on default
                BorderSizePixel = 0
            })
            Create("UICorner", { Parent = SliderFill, CornerRadius = UDim.new(1, 0) })

            -- Visual thumb/handle
            local SliderThumb = Create("Frame", {
                Name = "SliderThumb",
                Parent = SliderFill, -- Parent to fill for easy positioning
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0), -- Position at the end of the fill
                Size = UDim2.new(0, 14, 0, 14),    -- Thumb size
                BackgroundColor3 = theme.TextColor,
                BorderSizePixel = 0
            })
            Create("UICorner", { Parent = SliderThumb, CornerRadius = UDim.new(1, 0) })

            local sliding = false

            local function updateSliderFromValue(value, animate)
                value = math.clamp(value, min, max)
                currentValue = value
                ValueLabel.Text = formatValue(value)

                local ratio = (value - min) / (max - min)
                local targetSize = UDim2.new(ratio, 0, 1, 0)

                if animate then
                    TweenProp(SliderFill, "Size", targetSize, 0.1)
                else
                    SliderFill.Size = targetSize
                end
            end

            local function updateSliderFromInput(input)
                local relativeX = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                relativeX = math.clamp(relativeX, 0, 1)
                local newValue = min + (relativeX * (max - min))

                -- Round to specified decimal places
                local factor = 10 ^ decimals
                newValue = math.round(newValue * factor) / factor

                if newValue ~= currentValue then
                    updateSliderFromValue(newValue, false) -- Don't animate during drag for responsiveness
                    callback(newValue)
                end
            end

            table.insert(UI._connections, SliderInteractArea.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    updateSliderFromInput(input)
                    -- Optional: Scale thumb slightly on grab
                    TweenProp(SliderThumb, "Size", UDim2.new(0, 16, 0, 16), 0.1)
                end
            end))

            table.insert(UI._connections, UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSliderFromInput(input)
                end
            end))

            table.insert(UI._connections, UserInputService.InputEnded:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    sliding = false
                    -- Optional: Return thumb to normal size
                    TweenProp(SliderThumb, "Size", UDim2.new(0, 14, 0, 14), 0.1)
                end
            end))

            -- Initial update
            updateSliderFromValue(default, false)
            task.defer(callback, default) -- Initial callback

            -- Return API
            local sliderAPI = {}
            function sliderAPI:Set(value, silent)
                value = math.clamp(value, min, max)
                if value ~= currentValue then
                    updateSliderFromValue(value, true) -- Animate programmatic sets
                    if not silent then
                        callback(value)
                    end
                end
            end
            function sliderAPI:Get()
                return currentValue
            end
            return sliderAPI
        end

        -- Add Dropdown (Simplified version, MultiSelect removed for brevity, can be added back)
        function Elements:AddDropdown(config)
            local dropConfig = config or {}
            local dropText = dropConfig.Text or "Dropdown"
            local options = dropConfig.Options or {"Option 1", "Option 2"}
            local default = dropConfig.Default or options[1]
            local callback = dropConfig.Callback or function(selected) print("Dropdown selected:", selected) end

            local currentSelection = default
            local dropdownOpen = false

            local DropdownHolder = Create("Frame", {
                Name = "DropdownHolder_" .. dropText:gsub("%s+", ""),
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 36), -- Initial height
                LayoutOrder = #TabPage:GetChildren(),
                ZIndex = 2 -- Ensure dropdown appears above elements below it
            })

            local DropdownButton = Create("TextButton", {
                Name = "DropdownButton",
                Parent = DropdownHolder,
                BackgroundColor3 = theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0), -- Fill holder initially
                Font = Enum.Font.Gotham,
                Text = "", -- Text managed by label inside
                BorderSizePixel = 0,
                ClipsDescendants = true -- Clip the options frame initially
            })
            Create("UICorner", { Parent = DropdownButton, CornerRadius = UDim.new(0, 4) })

            local SelectedLabel = Create("TextLabel", {
                Name = "SelectedLabel",
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -30, 1, 0), -- Leave space for arrow
                Font = Enum.Font.Gotham,
                Text = tostring(currentSelection),
                TextColor3 = theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ArrowLabel = Create("TextLabel", {
                Name = "ArrowLabel",
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -25, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0, 15, 0, 15),
                Font = Enum.Font.GothamBold,
                Text = "▼",
                TextColor3 = theme.InactiveColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            -- Options Frame (Scrollable)
            local OptionsScroll = Create("ScrollingFrame", {
                Name = "OptionsScroll",
                Parent = DropdownButton, -- Parent to button for clipping and positioning
                BackgroundColor3 = theme.ElementBackgroundColor,
                BorderSizePixel = 1, -- Add subtle border
                BorderColor3 = theme.ElementBorderColor,
                Position = UDim2.new(0, 0, 1, 2), -- Position below button with small gap
                Size = UDim2.new(1, 0, 0, 0), -- Start height 0
                Visible = false, -- Start hidden
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = theme.AccentColor,
                ZIndex = 3 -- Ensure options are above button content
            })
            Create("UICorner", { Parent = OptionsScroll, CornerRadius = UDim.new(0, 4) })
            Create("UIListLayout", { Parent = OptionsScroll, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })

            local optionButtons = {}

            local function updateDropdownVisuals()
                local targetHolderHeight = 36
                local targetOptionsHeight = 0
                local targetArrowRotation = 0 -- Down arrow

                if dropdownOpen then
                    local listLayout = OptionsScroll:FindFirstChildOfClass("UIListLayout")
                    local contentHeight = listLayout and listLayout.AbsoluteContentSize.Y or 0
                    targetOptionsHeight = math.min(contentHeight + 4, 150) -- Max height 150px
                    targetHolderHeight = 36 + targetOptionsHeight + 2 -- Button height + options height + gap
                    targetArrowRotation = 180 -- Up arrow
                end

                -- Animate holder size first
                TweenProp(DropdownHolder, "Size", UDim2.new(1, -10, 0, targetHolderHeight), 0.2)

                -- Animate options frame size and visibility
                if dropdownOpen then OptionsScroll.Visible = true end
                TweenProp(OptionsScroll, "Size", UDim2.new(1, 0, 0, targetOptionsHeight), 0.2, nil, nil, function(state)
                    if state == Enum.TweenStatus.Completed and not dropdownOpen then
                        OptionsScroll.Visible = false
                    end
                end)

                -- Animate arrow rotation
                TweenProp(ArrowLabel, "Rotation", targetArrowRotation, 0.2)
            end

            local function createOptionButton(option)
                local OptionButton = Create("TextButton", {
                    Name = "Option_" .. tostring(option):gsub("%s+", ""),
                    Parent = OptionsScroll,
                    BackgroundColor3 = theme.ElementBackgroundColor,
                    Size = UDim2.new(1, -4, 0, 30), -- Slightly less width for padding
                    Font = Enum.Font.Gotham,
                    Text = "  " .. tostring(option),
                    TextColor3 = theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                })
                Create("UICorner", { Parent = OptionButton, CornerRadius = UDim.new(0, 3) })

                table.insert(UI._connections, OptionButton.MouseEnter:Connect(function()
                    if option ~= currentSelection then
                        TweenProp(OptionButton, "BackgroundColor3", theme.ElementBorderColor, 0.1)
                    end
                end))
                table.insert(UI._connections, OptionButton.MouseLeave:Connect(function()
                    if option ~= currentSelection then
                        TweenProp(OptionButton, "BackgroundColor3", theme.ElementBackgroundColor, 0.1)
                    end
                end))
                table.insert(UI._connections, OptionButton.MouseButton1Click:Connect(function()
                    if option ~= currentSelection then
                        -- Deselect old button visual
                        if optionButtons[currentSelection] then
                            TweenProp(optionButtons[currentSelection], "BackgroundColor3", theme.ElementBackgroundColor, 0.1)
                        end
                        -- Select new button visual
                        TweenProp(OptionButton, "BackgroundColor3", theme.AccentColorActive, 0.1)

                        currentSelection = option
                        SelectedLabel.Text = tostring(currentSelection)
                        callback(currentSelection)
                    end
                    dropdownOpen = false -- Close dropdown after selection
                    updateDropdownVisuals()
                end))

                optionButtons[option] = OptionButton
                -- Highlight default selection
                if option == currentSelection then
                    OptionButton.BackgroundColor3 = theme.AccentColorActive
                end
            end

            -- Populate options
            for _, opt in ipairs(options) do
                createOptionButton(opt)
            end
            task.wait() -- Wait for layout
            local listLayout = OptionsScroll:FindFirstChildOfClass("UIListLayout")
            if listLayout then OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 4) end


            table.insert(UI._connections, DropdownButton.MouseButton1Click:Connect(function()
                dropdownOpen = not dropdownOpen
                updateDropdownVisuals()
            end))

            -- Return API
            local dropdownAPI = {}
            function dropdownAPI:Set(value, silent)
                local found = false
                for _, opt in ipairs(options) do
                    if opt == value then
                        found = true
                        break
                    end
                end

                if found and value ~= currentSelection then
                     -- Deselect old button visual
                    if optionButtons[currentSelection] then
                        TweenProp(optionButtons[currentSelection], "BackgroundColor3", theme.ElementBackgroundColor, 0.1)
                    end
                    -- Select new button visual
                    if optionButtons[value] then
                         TweenProp(optionButtons[value], "BackgroundColor3", theme.AccentColorActive, 0.1)
                    end

                    currentSelection = value
                    SelectedLabel.Text = tostring(currentSelection)
                    if not silent then
                        callback(currentSelection)
                    end
                end
            end
            function dropdownAPI:Get()
                return currentSelection
            end
            function dropdownAPI:Refresh(newOptions, newDefault)
                -- Clear existing
                for _, btn in pairs(optionButtons) do btn:Destroy() end
                optionButtons = {}
                options = newOptions or {}
                currentSelection = newDefault or (options[1] or nil)
                SelectedLabel.Text = tostring(currentSelection)

                -- Repopulate
                for _, opt in ipairs(options) do
                    createOptionButton(opt)
                end
                task.wait()
                local listLayout = OptionsScroll:FindFirstChildOfClass("UIListLayout")
                if listLayout then OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 4) end

                if dropdownOpen then -- Update visuals if open
                    updateDropdownVisuals()
                end
            end
            return dropdownAPI
        end

        -- Add TextBox
        function Elements:AddTextBox(config)
            local textConfig = config or {}
            local placeholderText = textConfig.PlaceholderText or "Enter text..."
            local defaultText = textConfig.Default or ""
            local clearOnFocus = textConfig.ClearOnFocus -- Default is true for TextBox instances
            local callback = textConfig.Callback or function(text, enterPressed) print("TextBox changed:", text, "Enter:", enterPressed) end
            local numeric = textConfig.Numeric or false -- New option

            local TextBoxHolder = Create("Frame", {
                Name = "TextBoxHolder",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 36),
                LayoutOrder = #TabPage:GetChildren()
            })

            local TextBox = Create("TextBox", {
                Name = "TextBox",
                Parent = TextBoxHolder,
                BackgroundColor3 = theme.ElementBackgroundColor,
                BorderSizePixel = 1,
                BorderColor3 = theme.ElementBorderColor, -- Subtle border
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholderText,
                Text = defaultText,
                TextColor3 = theme.TextColor,
                PlaceholderColor3 = theme.InactiveColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = clearOnFocus == nil or clearOnFocus, -- Default true if nil
                MultiLine = false,
            })
            Create("UICorner", { Parent = TextBox, CornerRadius = UDim.new(0, 4) })
            Create("UIPadding", { Parent = TextBox, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })

            -- Focus animation
            table.insert(UI._connections, TextBox.Focused:Connect(function()
                TweenProp(TextBox, "BorderColor3", theme.AccentColor, 0.15)
            end))
            table.insert(UI._connections, TextBox.FocusLost:Connect(function(enterPressed, inputThatCausedFocusLoss)
                TweenProp(TextBox, "BorderColor3", theme.ElementBorderColor, 0.15)
                -- Numeric validation
                if numeric then
                    local num = tonumber(TextBox.Text)
                    if num == nil then
                        TextBox.Text = tostring(textConfig.Min or 0) -- Reset to min or 0 if invalid
                    else
                        TextBox.Text = tostring(math.clamp(num, textConfig.Min or -math.huge, textConfig.Max or math.huge))
                    end
                end
                callback(TextBox.Text, enterPressed)
            end))

            -- Numeric filtering
            if numeric then
                 table.insert(UI._connections, TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                    -- Allow minus sign only at the start, and only one decimal point
                    local text = TextBox.Text
                    local filtered = ""
                    local hasDecimal = false
                    for i = 1, #text do
                        local char = text:sub(i, i)
                        if char:match("%d") then
                            filtered = filtered .. char
                        elseif char == "." and not hasDecimal then
                            filtered = filtered .. char
                            hasDecimal = true
                        elseif char == "-" and i == 1 and (text:sub(2,2) or ""):match("[%d%.]") then
                             filtered = filtered .. char
                        end
                    end

                    if TextBox.Text ~= filtered then
                        TextBox.Text = filtered -- This might re-trigger the event, be careful
                    end
                end))
            end

            -- Return API
            local textBoxAPI = {}
            function textBoxAPI:Set(text, silent)
                TextBox.Text = tostring(text)
                if not silent then
                    -- Manually trigger callback if needed, FocusLost handles normal cases
                    -- callback(TextBox.Text, false) -- Be cautious about triggering callbacks excessively
                end
            end
            function textBoxAPI:Get()
                return TextBox.Text
            end
            function textBoxAPI:Clear()
                TextBox.Text = ""
            end
            return textBoxAPI
        end

        -- Add ColorPicker (Simplified - uses built-in picker for now)
        --[[ A custom HSV picker like the original is complex and long.
             For a quicker "better" version, leveraging the built-in picker is an option.
             If the custom picker is essential, the original logic can be adapted/reintegrated.
        ]]
        function Elements:AddColorPicker(config)
            local colorConfig = config or {}
            local title = colorConfig.Title or "Color Picker"
            local default = colorConfig.Default or Color3.fromRGB(255, 255, 255)
            local callback = colorConfig.Callback or function(color) print("Color picked:", color) end

            local currentColor = default

            local ColorPickerHolder = Create("Frame", {
                Name = "ColorPickerHolder",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 36),
                LayoutOrder = #TabPage:GetChildren()
            })

            local ColorButton = Create("TextButton", { -- Use button to trigger picker
                Name = "ColorButton",
                Parent = ColorPickerHolder,
                BackgroundColor3 = theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = ColorButton, CornerRadius = UDim.new(0, 4) })

            Create("TextLabel", {
                Name = "ColorLabel", Parent = ColorButton, BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.Gotham, Text = title, TextColor3 = theme.TextColor,
                TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })

            local ColorDisplay = Create("Frame", {
                Name = "ColorDisplay", Parent = ColorButton,
                Position = UDim2.new(1, -35, 0.5, -10), Size = UDim2.new(0, 25, 0, 20),
                BackgroundColor3 = currentColor, BorderSizePixel = 1, BorderColor3 = theme.ElementBorderColor
            })
            Create("UICorner", { Parent = ColorDisplay, CornerRadius = UDim.new(0, 3) })

            table.insert(UI._connections, ColorButton.MouseButton1Click:Connect(function()
                -- This uses the CoreGui Color Picker - requires permissions if used outside Studio plugins/CoreScripts
                -- For regular game scripts, you'd need to implement the custom HSV picker.
                pcall(function()
                    local success, result = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui").Modules.ColorPicker:Show(currentColor) end)
                    if success and result then
                        local pickedColor = result:GetColor()
                        if pickedColor ~= currentColor then
                            currentColor = pickedColor
                            TweenProp(ColorDisplay, "BackgroundColor3", currentColor, 0.15)
                            callback(currentColor)
                        end
                    end
                end)
                -- Fallback/Alternative: Re-implement the custom HSV picker here if the CoreGui one isn't suitable/available.
                warn("Using built-in Color Picker (may require permissions). Re-implement custom picker if needed.")
            end))

            -- Return API
            local colorPickerAPI = {}
            function colorPickerAPI:Set(color, silent)
                if color ~= currentColor then
                    currentColor = color
                    TweenProp(ColorDisplay, "BackgroundColor3", currentColor, 0.15)
                    if not silent then
                        callback(currentColor)
                    end
                end
            end
            function colorPickerAPI:Get()
                return currentColor
            end
            return colorPickerAPI
        end

        -- Add Keybind
        function Elements:AddKeybind(config)
            local keyConfig = config or {}
            local title = keyConfig.Title or "Keybind"
            local default = keyConfig.Default -- Enum.KeyCode or nil
            local callback = keyConfig.Callback or function(key) print("Keybind activated:", key) end
            local triggerCallbackOnSet = keyConfig.TriggerOnSet or false -- Whether setting the keybind triggers the callback

            local selectedKey = default
            local listening = false

            local KeybindHolder = Create("Frame", {
                Name = "KeybindHolder", Parent = TabPage, BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 36), LayoutOrder = #TabPage:GetChildren()
            })

            local KeybindFrame = Create("Frame", {
                Name = "KeybindFrame", Parent = KeybindHolder, BackgroundColor3 = theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0
            })
            Create("UICorner", { Parent = KeybindFrame, CornerRadius = UDim.new(0, 4) })

            Create("TextLabel", {
                Name = "KeybindLabel", Parent = KeybindFrame, BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -90, 1, 0),
                Font = Enum.Font.Gotham, Text = title, TextColor3 = theme.TextColor,
                TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
            })

            local KeybindButton = Create("TextButton", {
                Name = "KeybindButton", Parent = KeybindFrame,
                BackgroundColor3 = theme.ElementBorderColor, -- Use border color for button background
                Position = UDim2.new(1, -80, 0.5, -13), Size = UDim2.new(0, 70, 0, 26),
                Font = Enum.Font.GothamSemibold, Text = "...", -- Initial text
                TextColor3 = theme.TextColor, TextSize = 12, BorderSizePixel = 0
            })
            Create("UICorner", { Parent = KeybindButton, CornerRadius = UDim.new(0, 3) })

            local function formatKeyName(keyCode)
                if not keyCode then return "..." end
                local name = tostring(keyCode):gsub("Enum.KeyCode.", "")
                -- Add common name replacements if desired (e.g., LeftControl -> LCtrl)
                local replacements = { LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift", LeftAlt = "LAlt", RightAlt = "RAlt", PageUp = "PgUp", PageDown = "PgDn", Insert = "Ins", Delete = "Del" }
                return replacements[name] or name
            end

            local function updateKeybindVisual(key)
                KeybindButton.Text = formatKeyName(key)
            end

            updateKeybindVisual(selectedKey) -- Set initial text

            table.insert(UI._connections, KeybindButton.MouseButton1Click:Connect(function()
                if not listening then
                    listening = true
                    KeybindButton.Text = "..."
                    TweenProp(KeybindButton, "BackgroundColor3", theme.AccentColor, 0.15)
                    -- Maybe add a subtle border pulse?
                end
            end))

            -- Global input listener for capturing the key
            local inputListener
            inputListener = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
                if gameProcessedEvent then return end -- Ignore if chat or other UI handled it

                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    selectedKey = input.KeyCode
                    updateKeybindVisual(selectedKey)
                    TweenProp(KeybindButton, "BackgroundColor3", theme.ElementBorderColor, 0.15)
                    listening = false
                    if triggerCallbackOnSet then callback(selectedKey) end -- Optional: trigger callback when key is set

                elseif not listening and selectedKey and input.KeyCode == selectedKey then
                    -- Trigger the callback if the bound key is pressed (and not listening)
                    callback(selectedKey)
                end
            end)
            table.insert(UI._connections, inputListener) -- Add to connections for cleanup

            -- Handle focus loss for the button (e.g., clicking elsewhere)
            table.insert(UI._connections, KeybindButton.FocusLost:Connect(function()
                 if listening then
                    listening = false
                    updateKeybindVisual(selectedKey) -- Revert text if nothing was pressed
                    TweenProp(KeybindButton, "BackgroundColor3", theme.ElementBorderColor, 0.15)
                 end
            end))


            -- Return API
            local keybindAPI = {}
            function keybindAPI:Set(key, silent)
                if key ~= selectedKey then
                    selectedKey = key
                    updateKeybindVisual(selectedKey)
                    if not silent and triggerCallbackOnSet then
                        callback(selectedKey)
                    end
                end
            end
            function keybindAPI:Get()
                return selectedKey
            end
            return keybindAPI
        end

        -- Add Section Separator
        function Elements:AddSection(title)
            local SectionHolder = Create("Frame", {
                Name = "Section_" .. title:gsub("%s+", ""),
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 25), -- Height for line and text
                LayoutOrder = #TabPage:GetChildren()
            })

            -- Line across the width
            Create("Frame", {
                Name = "SectionLine", Parent = SectionHolder,
                BackgroundColor3 = theme.ElementBorderColor, -- Use border color for the line
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, -1), -- Center vertically
                Size = UDim2.new(1, 0, 0, 1)        -- Thin line
            })

            -- Text label sitting on the line
            local SectionTitle = Create("TextLabel", {
                Name = "SectionTitle", Parent = SectionHolder,
                BackgroundColor3 = theme.SecondaryColor, -- Background matches content container
                Position = UDim2.new(0, 10, 0.5, 0), -- Positioned over the line start
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 0, 0, 18), -- Auto width, fixed height
                Font = Enum.Font.GothamBold,
                Text = "  " .. title .. "  ", -- Padding around text
                TextColor3 = theme.TextColor,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.X -- Auto-adjust width
            })

            return SectionHolder -- Return the frame if needed
        end

        -- Return the Elements API for this tab
        return Elements
    end -- End of UI:AddTab

    -- Select Tab Function (with animation)
    function UI:SelectTab(index)
        if index == self.ActiveTab or not self.Tabs[index] then return end -- Already selected or invalid index

        local previousTab = self.ActiveTab and self.Tabs[self.ActiveTab]
        local newTab = self.Tabs[index]

        -- Deselect previous tab (if any)
        if previousTab then
            TweenProp(previousTab.Button, "BackgroundColor3", theme.ElementBackgroundColor, 0.15)
            TweenProp(previousTab.Button, "TextColor3", theme.InactiveColor, 0.15)
            if previousTab.IconInstance then TweenProp(previousTab.IconInstance, "ImageColor3", theme.InactiveColor, 0.15) end

            -- Fade out previous page
            if self._activeTweens.pageFade then self._activeTweens.pageFade:Cancel() end
            previousTab.Page.Visible = true -- Ensure visible for fade out
            self._activeTweens.pageFade = TweenProp(previousTab.Page, "GroupTransparency", 1, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                if self.ActiveTab ~= previousTab.Index then -- Only hide if it's not the active tab anymore
                    previousTab.Page.Visible = false
                end
                self._activeTweens.pageFade = nil
            end)
        end

        -- Select new tab
        TweenProp(newTab.Button, "BackgroundColor3", theme.AccentColor, 0.15)
        TweenProp(newTab.Button, "TextColor3", theme.TextColor, 0.15)
        if newTab.IconInstance then TweenProp(newTab.IconInstance, "ImageColor3", theme.TextColor, 0.15) end

        -- Fade in new page
        if self._activeTweens.pageFade then self._activeTweens.pageFade:Cancel() end
        newTab.Page.GroupTransparency = 1 -- Reset transparency before fade in
        newTab.Page.Visible = true
        self._activeTweens.pageFade = TweenProp(newTab.Page, "GroupTransparency", 0, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
             self._activeTweens.pageFade = nil
        end)

        self.ActiveTab = index
        self.ActiveTabPage = newTab.Page -- Store reference to active page
    end

    -- Add Notification System (Simplified - can be expanded)
    local notificationContainers = {}
    function UI:Notify(config)
        local notifConfig = config or {}
        local title = notifConfig.Title or "Notification"
        local text = notifConfig.Text or ""
        local duration = notifConfig.Duration or 5
        local position = notifConfig.Position or "TopRight" -- TopRight, TopLeft, BottomRight, BottomLeft
        local nType = notifConfig.Type or "Info" -- Info, Success, Warning, Error
        local width = notifConfig.Width or 280

        local typeColor = theme.AccentColor
        if nType == "Success" then typeColor = theme.SuccessColor
        elseif nType == "Warning" then typeColor = theme.WarningColor
        elseif nType == "Error" then typeColor = theme.ErrorColor end

        -- Create container for this position if it doesn't exist
        if not notificationContainers[position] then
            local container = Create("Frame", {
                Name = "NotificationContainer_" .. position,
                Parent = ScreenGui, -- Parent to ScreenGui, not MainFrame
                BackgroundTransparency = 1,
                Size = UDim2.new(0, width, 1, 0), -- Fixed width, full height for alignment
                Position =
                    (position == "TopLeft" and UDim2.new(0, 10, 0, 10)) or
                    (position == "TopRight" and UDim2.new(1, -width - 10, 0, 10)) or
                    (position == "BottomLeft" and UDim2.new(0, 10, 1, -10)) or
                    (position == "BottomRight" and UDim2.new(1, -width - 10, 1, -10)) or
                    UDim2.new(1, -width - 10, 0, 10), -- Default TopRight
                AnchorPoint =
                    (position == "TopLeft" and Vector2.new(0, 0)) or
                    (position == "TopRight" and Vector2.new(1, 0)) or
                    (position == "BottomLeft" and Vector2.new(0, 1)) or
                    (position == "BottomRight" and Vector2.new(1, 1)) or
                    Vector2.new(1, 0), -- Default TopRight
                ZIndex = 100 -- Ensure notifications are on top
            })
            Create("UIListLayout", {
                Parent = container,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
                HorizontalAlignment = Enum.HorizontalAlignment.Right, -- Align items within container
                VerticalAlignment = (position:find("Bottom") and Enum.VerticalAlignment.Bottom or Enum.VerticalAlignment.Top)
            })
            notificationContainers[position] = container
        end
        local container = notificationContainers[position]

        -- Create Notification Frame
        local notification = Create("Frame", {
            Name = "Notification",
            Parent = container,
            BackgroundColor3 = theme.ElementBackgroundColor,
            Size = UDim2.new(1, 0, 0, 60), -- Initial size, will adjust
            BackgroundTransparency = 0.1, -- Slight transparency
            ClipsDescendants = true,
            LayoutOrder = tick() -- Use tick for ordering (newest usually at top/bottom depending on layout)
        })
        Create("UICorner", { Parent = notification, CornerRadius = UDim.new(0, 4) })
        Create("UIPadding", { Parent = notification, PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8), PaddingTop = UDim.new(0,5), PaddingBottom = UDim.new(0,8) })
        Create("UIStroke", { Parent = notification, Thickness = 1, Color = theme.ElementBorderColor, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })

        -- Type Indicator Bar
        Create("Frame", {
            Name = "TypeIndicator", Parent = notification, BackgroundColor3 = typeColor,
            Position = UDim2.new(0, -8, 0, 0), Size = UDim2.new(0, 4, 1, 0), -- Position left edge
            BorderSizePixel = 0
        })

        -- Title
        local TitleLabel = Create("TextLabel", {
            Name = "Title", Parent = notification, BackgroundTransparency = 1,
            Position = UDim2.new(0, 5, 0, 0), Size = UDim2.new(1, -30, 0, 20), -- Leave space for close button
            Font = Enum.Font.GothamBold, Text = title, TextColor3 = theme.TextColor,
            TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
        })

        -- Text Content
        local TextLabel = Create("TextLabel", {
            Name = "Text", Parent = notification, BackgroundTransparency = 1,
            Position = UDim2.new(0, 5, 0, 20), Size = UDim2.new(1, -10, 0, 20), -- Initial size
            Font = Enum.Font.Gotham, Text = text, TextColor3 = theme.TextColor,
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top
        })

        -- Adjust height based on text content
        task.wait() -- Wait for text bounds calculation
        local textBounds = TextService:GetTextSize(text, 12, Enum.Font.Gotham, Vector2.new(notification.AbsoluteSize.X - 18, math.huge))
        local requiredTextHeight = math.max(15, textBounds.Y)
        TextLabel.Size = UDim2.new(1, -10, 0, requiredTextHeight)
        local totalHeight = 5 + 20 + requiredTextHeight + 8 -- Paddings + Title + Text
        notification.Size = UDim2.new(1, 0, 0, totalHeight)

        -- Close Button
        local CloseNotifButton = Create("TextButton", {
            Name = "CloseButton", Parent = notification, BackgroundTransparency = 1,
            Position = UDim2.new(1, -20, 0, 0), Size = UDim2.new(0, 20, 0, 20),
            Font = Enum.Font.GothamBold, Text = "✕", TextColor3 = theme.InactiveColor, TextSize = 16
        })
        table.insert(UI._connections, CloseNotifButton.MouseEnter:Connect(function() TweenProp(CloseNotifButton, "TextColor3", theme.TextColor, 0.1) end))
        table.insert(UI._connections, CloseNotifButton.MouseLeave:Connect(function() TweenProp(CloseNotifButton, "TextColor3", theme.InactiveColor, 0.1) end))

        -- Progress Bar
        local ProgressBar = Create("Frame", {
            Name = "ProgressBar", Parent = notification, BackgroundColor3 = typeColor,
            Position = UDim2.new(0, 0, 1, -3), Size = UDim2.new(1, 0, 0, 3), -- Bottom edge
            BorderSizePixel = 0
        })

        -- Animation In (Slide + Fade)
        local startPosOffset = (position:find("Right") and 30 or -30)
        notification.Position = notification.Position + UDim2.new(0, startPosOffset, 0, 0)
        notification.BackgroundTransparency = 1
        TweenProps(notification, { Position = notification.Position - UDim2.new(0, startPosOffset, 0, 0), BackgroundTransparency = 0.1 }, 0.3, Enum.EasingStyle.Quad)

        -- Animation Out
        local active = true
        local function destroyNotification()
            if not active then return end
            active = false
            local outPosOffset = (position:find("Right") and 30 or -30)
            TweenProps(notification, { Position = notification.Position + UDim2.new(0, outPosOffset, 0, 0), BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
                notification:Destroy()
            end)
        end

        table.insert(UI._connections, CloseNotifButton.MouseButton1Click:Connect(destroyNotification))

        -- Progress bar tween and auto-destroy timer
        local progressTween = TweenProp(ProgressBar, "Size", UDim2.new(0, 0, 0, 3), duration, Enum.EasingStyle.Linear)
        table.insert(UI._connections, progressTween.Completed:Connect(destroyNotification))

        return notification -- Return instance if needed
    end


    -- Return the main UI object
    return UI
end

-- Return the library itself
return MicahsUI