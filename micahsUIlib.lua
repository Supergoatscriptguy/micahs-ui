local MicahsUI = {}
MicahsUI.__index = MicahsUI

-- Library Configuration
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Theme and Colors
MicahsUI.Themes = {
    Default = {
        BackgroundColor = Color3.fromRGB(25, 25, 35),
        SecondaryColor = Color3.fromRGB(35, 35, 45),
        AccentColor = Color3.fromRGB(114, 137, 218), -- Discord-like blue/purple
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackgroundColor = Color3.fromRGB(40, 40, 50),
        ElementBorderColor = Color3.fromRGB(60, 60, 70),
        InactiveColor = Color3.fromRGB(160, 160, 160),
    },
    Dark = {
        BackgroundColor = Color3.fromRGB(20, 20, 20),
        SecondaryColor = Color3.fromRGB(30, 30, 30),
        AccentColor = Color3.fromRGB(0, 175, 255), -- Cyan
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackgroundColor = Color3.fromRGB(35, 35, 35),
        ElementBorderColor = Color3.fromRGB(50, 50, 50),
        InactiveColor = Color3.fromRGB(140, 140, 140),
    },
    Light = {
        BackgroundColor = Color3.fromRGB(240, 240, 240),
        SecondaryColor = Color3.fromRGB(230, 230, 230),
        AccentColor = Color3.fromRGB(0, 120, 215), -- Windows blue
        TextColor = Color3.fromRGB(30, 30, 30),
        ElementBackgroundColor = Color3.fromRGB(255, 255, 255),
        ElementBorderColor = Color3.fromRGB(200, 200, 200),
        InactiveColor = Color3.fromRGB(120, 120, 120),
    }
}

-- Utility Functions
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

local function Tween(instance, properties, duration, style, direction)
    local tween = TweenService:Create(
        instance, 
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

-- Create the main UI function
function MicahsUI:Create(config)
    local windowConfig = config or {}
    local title = windowConfig.Title or "MicahsUI"
    local theme = windowConfig.Theme or "Default"
    local themeColors = self.Themes[theme]
    
    -- Create UI instance
    local UI = {}
    setmetatable(UI, self)
    
    -- Create ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "MicahsUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Create Main Frame
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = themeColors.BackgroundColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        AnchorPoint = Vector2.new(0.5, 0.5),
    })
    
    -- Add corner radius
    local UICorner = CreateInstance("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Add shadow
    local Shadow = CreateInstance("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = -1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        ImageTransparency = 0.5
    })
    
    -- Create Title Bar
    local TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = themeColors.SecondaryColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    local TitleCorner = CreateInstance("UICorner", {
        Parent = TitleBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Fix corner radius for TitleBar (add frame to cover bottom corners)
    local TitleBarBottomCover = CreateInstance("Frame", {
        Parent = TitleBar,
        BackgroundColor3 = themeColors.SecondaryColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -10),
        Size = UDim2.new(1, 0, 0, 10)
    })
    
    -- Title Text
    local TitleText = CreateInstance("TextLabel", {
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = themeColors.TextColor,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Close Button
    local CloseButton = CreateInstance("TextButton", {
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "✕",
        TextColor3 = themeColors.TextColor,
        TextSize = 18
    })
    
    -- Container for Pages/Tabs
    local TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundColor3 = themeColors.SecondaryColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 50),
        Size = UDim2.new(0, 130, 1, -60)
    })
    
    local TabContainerCorner = CreateInstance("UICorner", {
        Parent = TabContainer,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Container for Tab Content
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundColor3 = themeColors.SecondaryColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 150, 0, 50),
        Size = UDim2.new(1, -160, 1, -60)
    })
    
    local ContentContainerCorner = CreateInstance("UICorner", {
        Parent = ContentContainer,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- ScrollingFrame for Tabs
    local TabScroll = CreateInstance("ScrollingFrame", {
        Name = "TabScroll",
        Parent = TabContainer,
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 5),
        Size = UDim2.new(1, 0, 1, -10),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = themeColors.AccentColor,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local TabList = CreateInstance("UIListLayout", {
        Parent = TabScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    local TabPadding = CreateInstance("UIPadding", {
        Parent = TabScroll,
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5)
    })
    
    -- Store UI elements in the UI table
    UI.ScreenGui = ScreenGui
    UI.MainFrame = MainFrame
    UI.TabContainer = TabContainer
    UI.TabScroll = TabScroll
    UI.ContentContainer = ContentContainer
    UI.Theme = themeColors
    UI.Tabs = {}
    UI.ActiveTab = nil
    
    -- Make UI draggable
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab management
    function UI:AddTab(tabName, icon)
        local tabIndex = #self.Tabs + 1
        
        -- Create tab button
        local TabButton = CreateInstance("TextButton", {
            Name = "Tab_" .. tabName,
            Parent = TabScroll,
            BackgroundColor3 = self.Theme.ElementBackgroundColor,
            Size = UDim2.new(1, 0, 0, 36),
            Font = Enum.Font.GothamSemibold,
            Text = tabName,
            TextColor3 = self.Theme.TextColor,
            TextSize = 14,
            BorderSizePixel = 0
        })
        
        local TabCorner = CreateInstance("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 6)
        })
        
        -- Create icon if provided
        if icon then
            local IconImage = CreateInstance("ImageLabel", {
                Name = "Icon",
                Parent = TabButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 8, 0.5, -10),
                Image = icon
            })
            
            TabButton.Text = "    " .. tabName
            TabButton.TextXAlignment = Enum.TextXAlignment.Center
        end
        
        -- Create tab content page
        local TabPage = CreateInstance("ScrollingFrame", {
            Name = "Page_" .. tabName,
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = self.Theme.AccentColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false
        })
        
        local ContentList = CreateInstance("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        local ContentPadding = CreateInstance("UIPadding", {
            Parent = TabPage,
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
        
        -- Auto-adjust canvas size
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Create tab data
        local tab = {
            Button = TabButton,
            Page = TabPage,
            Name = tabName
        }
        
        -- Tab button click handler
        TabButton.MouseButton1Click:Connect(function()
            self:SelectTab(tabIndex)
        end)
        
        -- Add tab to tabs table
        table.insert(self.Tabs, tab)
        
        -- Update TabScroll canvas size
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 10)
        
        -- Select first tab by default
        if tabIndex == 1 then
            self:SelectTab(1)
        end
        
        -- Elements Functions
        local Elements = {}
        
        -- Add Label
        function Elements:AddLabel(text)
            local Label = CreateInstance("TextLabel", {
                Name = "Label",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            return Label
        end
        
        -- Add Button
        function Elements:AddButton(config)
            local buttonConfig = config or {}
            local buttonText = buttonConfig.Text or "Button"
            local callback = buttonConfig.Callback or function() end
            
            local ButtonHolder = CreateInstance("Frame", {
                Name = "ButtonHolder",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40)
            })
            
            local Button = CreateInstance("TextButton", {
                Name = "Button",
                Parent = ButtonHolder,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = buttonText,
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                BorderSizePixel = 0
            })
            
            local ButtonCorner = CreateInstance("UICorner", {
                Parent = Button,
                CornerRadius = UDim.new(0, 6)
            })
            
            -- Click animation
            Button.MouseButton1Down:Connect(function()
                Tween(Button, {BackgroundColor3 = UI.Theme.AccentColor}, 0.1)
            end)
            
            Button.MouseButton1Up:Connect(function()
                Tween(Button, {BackgroundColor3 = UI.Theme.ElementBackgroundColor}, 0.1)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = UI.Theme.ElementBackgroundColor}, 0.1)
            end)
            
            Button.MouseButton1Click:Connect(function()
                callback()
            end)
            
            return Button
        end
        
        -- Add Toggle
        function Elements:AddToggle(config)
            local toggleConfig = config or {}
            local toggleText = toggleConfig.Text or "Toggle"
            local default = toggleConfig.Default or false
            local callback = toggleConfig.Callback or function() end
            
            local ToggleHolder = CreateInstance("Frame", {
                Name = "ToggleHolder",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40)
            })
            
            local ToggleFrame = CreateInstance("Frame", {
                Name = "ToggleFrame",
                Parent = ToggleHolder,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0),
                BorderSizePixel = 0
            })
            
            local ToggleCorner = CreateInstance("UICorner", {
                Parent = ToggleFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            local ToggleLabel = CreateInstance("TextLabel", {
                Name = "ToggleLabel",
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = toggleText,
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ToggleButton = CreateInstance("Frame", {
                Name = "ToggleButton",
                Parent = ToggleFrame,
                Position = UDim2.new(1, -50, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20),
                BackgroundColor3 = default and UI.Theme.AccentColor or UI.Theme.InactiveColor
            })
            
            local ToggleButtonCorner = CreateInstance("UICorner", {
                Parent = ToggleButton,
                CornerRadius = UDim.new(1, 0)
            })
            
            local ToggleCircle = CreateInstance("Frame", {
                Name = "ToggleCircle",
                Parent = ToggleButton,
                Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0
            })
            
            local ToggleCircleCorner = CreateInstance("UICorner", {
                Parent = ToggleCircle,
                CornerRadius = UDim.new(1, 0)
            })
            
            local toggled = default
            
            local function updateToggle()
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = UI.Theme.AccentColor}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = UI.Theme.InactiveColor}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                end
                callback(toggled)
            end
            
            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggled = not toggled
                    updateToggle()
                end
            end)
            
            -- Initial callback
            if default then
                callback(true)
            end
            
            -- Toggle Methods
            local toggleFunctions = {}
            
            function toggleFunctions:Set(value)
                toggled = value
                updateToggle()
            end
            
            function toggleFunctions:Get()
                return toggled
            end
            
            return toggleFunctions
        end
        
        -- Add Slider
        function Elements:AddSlider(config)
            local sliderConfig = config or {}
            local sliderText = sliderConfig.Text or "Slider"
            local min = sliderConfig.Min or 0
            local max = sliderConfig.Max or 100
            local default = sliderConfig.Default or min
            local decimals = sliderConfig.Decimals or 0
            local callback = sliderConfig.Callback or function() end
            
            -- Ensure default is within range
            default = math.clamp(default, min, max)
            
            -- Format value based on decimals
            local function formatValue(value)
                local format = "%." .. decimals .. "f"
                return string.format(format, value)
            end
            
            local SliderHolder = CreateInstance("Frame", {
                Name = "SliderHolder",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 60)
            })
            
            local SliderFrame = CreateInstance("Frame", {
                Name = "SliderFrame",
                Parent = SliderHolder,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0),
                BorderSizePixel = 0
            })
            
            local SliderCorner = CreateInstance("UICorner", {
                Parent = SliderFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            local SliderLabel = CreateInstance("TextLabel", {
                Name = "SliderLabel",
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 0, 30),
                Font = Enum.Font.GothamSemibold,
                Text = sliderText,
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = CreateInstance("TextLabel", {
                Name = "ValueLabel",
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -60, 0, 0),
                Size = UDim2.new(0, 50, 0, 30),
                Font = Enum.Font.GothamSemibold,
                Text = formatValue(default),
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local SliderBack = CreateInstance("Frame", {
                Name = "SliderBack",
                Parent = SliderFrame,
                Position = UDim2.new(0, 10, 0, 35),
                Size = UDim2.new(1, -20, 0, 10),
                BackgroundColor3 = UI.Theme.InactiveColor,
                BorderSizePixel = 0
            })
            
            local SliderBackCorner = CreateInstance("UICorner", {
                Parent = SliderBack,
                CornerRadius = UDim.new(1, 0)
            })
            
            local SliderFill = CreateInstance("Frame", {
                Name = "SliderFill",
                Parent = SliderBack,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = UI.Theme.AccentColor,
                BorderSizePixel = 0
            })
            
            local SliderFillCorner = CreateInstance("UICorner", {
                Parent = SliderFill,
                CornerRadius = UDim.new(1, 0)
            })
            
            local SliderBall = CreateInstance("Frame", {
                Name = "SliderBall",
                Parent = SliderFill,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0
            })
            
            local SliderBallCorner = CreateInstance("UICorner", {
                Parent = SliderBall,
                CornerRadius = UDim.new(1, 0)
            })
            
            local currentValue = default
            local sliding = false
            
            local function updateSlider(value)
                -- Calculate value based on slider position
                local newValue = math.clamp(value, min, max)
                
                -- Set new value
                currentValue = newValue
                ValueLabel.Text = formatValue(newValue)
                
                -- Update slider position
                local sliderRatio = (newValue - min) / (max - min)
                SliderFill:TweenSize(
                    UDim2.new(sliderRatio, 0, 1, 0),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quad,
                    0.1,
                    true
                )
                
                callback(newValue)
            end
            
            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    
                    -- Calculate value based on mouse position
                    local relativeX = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                    local newValue = min + (relativeX * (max - min))
                    
                    -- Round to specified decimal places if needed
                    if decimals > 0 then
                        local factor = 10 ^ decimals
                        newValue = math.floor(newValue * factor + 0.5) / factor
                    else
                        newValue = math.floor(newValue + 0.5)
                    end
                    
                    updateSlider(newValue)
                end
            end)
            
            SliderBack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    -- Calculate value based on mouse position
                    local relativeX = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                    local newValue = min + (relativeX * (max - min))
                    
                    -- Round to specified decimal places if needed
                    if decimals > 0 then
                        local factor = 10 ^ decimals
                        newValue = math.floor(newValue * factor + 0.5) / factor
                    else
                        newValue = math.floor(newValue + 0.5)
                    end
                    
                    updateSlider(newValue)
                end
            end)
            
            -- Slider Methods
            local sliderFunctions = {}
            
            function sliderFunctions:Set(value)
                updateSlider(value)
            end
            
            function sliderFunctions:Get()
                return currentValue
            end
            
            -- Initialize
            updateSlider(default)
            
            return sliderFunctions
        end
        
        -- Add Dropdown
        function Elements:AddDropdown(config)
            local dropConfig = config or {}
            local dropText = dropConfig.Text or "Dropdown"
            local options = dropConfig.Options or {}
            local default = dropConfig.Default or nil
            local callback = dropConfig.Callback or function() end
            local multiSelect = dropConfig.MultiSelect or false
            
            local DropdownHolder = CreateInstance("Frame", {
                Name = "DropdownHolder",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40)
            })
            
            local DropdownFrame = CreateInstance("Frame", {
                Name = "DropdownFrame",
                Parent = DropdownHolder,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0),
                ClipsDescendants = true,
                BorderSizePixel = 0
            })
            
            local DropdownCorner = CreateInstance("UICorner", {
                Parent = DropdownFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            local DropdownLabel = CreateInstance("TextLabel", {
                Name = "DropdownLabel",
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = dropText,
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ArrowButton = CreateInstance("TextButton", {
                Name = "ArrowButton",
                Parent = DropdownFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -40, 0, 0),
                Size = UDim2.new(0, 40, 0, 40),
                Font = Enum.Font.GothamBold,
                Text = "▼",
                TextColor3 = UI.Theme.TextColor,
                TextSize = 18
            })
            
            local OptionsFrame = CreateInstance("Frame", {
                Name = "OptionsFrame",
                Parent = DropdownFrame,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor,
                Position = UDim2.new(0, 0, 0, 40),
                Size = UDim2.new(1, 0, 0, 0),
                Visible = false,
                BorderSizePixel = 0,
                ZIndex = 5
            })
            
            local OptionsList = CreateInstance("UIListLayout", {
                Parent = OptionsFrame,
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            -- Add dropdown options
            local optionButtons = {}
            local selectedOptions = {}
            local dropdownOpen = false
            
            local function updateDropdownText()
                if multiSelect then
                    local selectedCount = 0
                    for _, selected in pairs(selectedOptions) do
                        if selected then selectedCount = selectedCount + 1 end
                    end
                    DropdownLabel.Text = dropText .. " (" .. selectedCount .. " selected)"
                else
                    for option, selected in pairs(selectedOptions) do
                        if selected then 
                            DropdownLabel.Text = dropText .. ": " .. option
                            break
                        end
                    end
                end
            end
            
            local function createOption(option)
                local OptionButton = CreateInstance("TextButton", {
                    Name = "Option_" .. option,
                    Parent = OptionsFrame,
                    BackgroundColor3 = selectedOptions[option] and UI.Theme.AccentColor or UI.Theme.ElementBackgroundColor,
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.GothamSemibold,
                    Text = "  " .. option,
                    TextColor3 = UI.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    ZIndex = 5
                })
                
                -- Add hoover effect
                OptionButton.MouseEnter:Connect(function()
                    if not selectedOptions[option] then
                        Tween(OptionButton, {BackgroundColor3 = UI.Theme.AccentColor:Lerp(UI.Theme.ElementBackgroundColor, 0.5)}, 0.2)
                    end
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    if not selectedOptions[option] then
                        Tween(OptionButton, {BackgroundColor3 = UI.Theme.ElementBackgroundColor}, 0.2)
                    end
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    if multiSelect then
                        selectedOptions[option] = not selectedOptions[option]
                        OptionButton.BackgroundColor3 = selectedOptions[option] and UI.Theme.AccentColor or UI.Theme.ElementBackgroundColor
                        callback(selectedOptions)
                        updateDropdownText()
                    else
                        for opt, _ in pairs(selectedOptions) do
                            selectedOptions[opt] = false
                            if optionButtons[opt] then
                                optionButtons[opt].BackgroundColor3 = UI.Theme.ElementBackgroundColor
                            end
                        end
                        selectedOptions[option] = true
                        OptionButton.BackgroundColor3 = UI.Theme.AccentColor
                        callback(option)
                        updateDropdownText()
                        toggleDropdown()
                    end
                end)
                
                optionButtons[option] = OptionButton
                return OptionButton
            end
            
            -- Add options
            for _, option in ipairs(options) do
                selectedOptions[option] = (option == default)
                createOption(option)
            end
            
            -- Update dropdown options frame height based on content
            OptionsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if dropdownOpen then
                    OptionsFrame.Size = UDim2.new(1, 0, 0, OptionsList.AbsoluteContentSize.Y)
                    DropdownHolder.Size = UDim2.new(1, 0, 0, 40 + OptionsList.AbsoluteContentSize.Y)
                else
                    DropdownHolder.Size = UDim2.new(1, 0, 0, 40)
                end
            end)
            
            -- Toggle dropdown
            function toggleDropdown()
                dropdownOpen = not dropdownOpen
                
                ArrowButton.Text = dropdownOpen and "▲" or "▼"
                OptionsFrame.Visible = true
                
                if dropdownOpen then
                    -- Expand dropdown
                    DropdownHolder:TweenSize(
                        UDim2.new(1, 0, 0, 40 + OptionsList.AbsoluteContentSize.Y),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                    OptionsFrame:TweenSize(
                        UDim2.new(1, 0, 0, OptionsList.AbsoluteContentSize.Y),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                else
                    -- Collapse dropdown
                    DropdownHolder:TweenSize(
                        UDim2.new(1, 0, 0, 40),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                    OptionsFrame:TweenSize(
                        UDim2.new(1, 0, 0, 0),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true,
                        function()
                            OptionsFrame.Visible = false
                        end
                    )
                end
            end
            
            ArrowButton.MouseButton1Click:Connect(toggleDropdown)
            
            -- Set default value
            if default then
                if multiSelect and type(default) == "table" then
                    for _, option in ipairs(default) do
                        selectedOptions[option] = true
                        if optionButtons[option] then
                            optionButtons[option].BackgroundColor3 = UI.Theme.AccentColor
                        end
                    end
                    callback(selectedOptions)
                else
                    selectedOptions[default] = true
                    if optionButtons[default] then
                        optionButtons[default].BackgroundColor3 = UI.Theme.AccentColor
                    end
                    callback(default)
                end
                updateDropdownText()
            end
            
            -- Dropdown methods
            local dropdownFunctions = {}
            
            function dropdownFunctions:Refresh(newOptions, keepSelection)
                for _, button in pairs(optionButtons) do
                    button:Destroy()
                end
                
                optionButtons = {}
                
                if not keepSelection then
                    selectedOptions = {}
                end
                
                for _, option in ipairs(newOptions) do
                    if not keepSelection then
                        selectedOptions[option] = false
                    end
                    createOption(option)
                end
                
                updateDropdownText()
            end
            
            function dropdownFunctions:Set(option)
                if multiSelect and type(option) == "table" then
                    for opt, _ in pairs(selectedOptions) do
                        selectedOptions[opt] = false
                        if optionButtons[opt] then
                            optionButtons[opt].BackgroundColor3 = UI.Theme.ElementBackgroundColor
                        end
                    end
                    
                    for _, opt in ipairs(option) do
                        selectedOptions[opt] = true
                        if optionButtons[opt] then
                            optionButtons[opt].BackgroundColor3 = UI.Theme.AccentColor
                        end
                    end
                else
                    for opt, _ in pairs(selectedOptions) do
                        selectedOptions[opt] = false
                        if optionButtons[opt] then
                            optionButtons[opt].BackgroundColor3 = UI.Theme.ElementBackgroundColor
                        end
                    end
                    
                    selectedOptions[option] = true
                    if optionButtons[option] then
                        optionButtons[option].BackgroundColor3 = UI.Theme.AccentColor
                    end
                end
                
                updateDropdownText()
                callback(multiSelect and selectedOptions or option)
            end
            
            return dropdownFunctions
        end
        
        -- Add TextBox
        function Elements:AddTextBox(config)
            local textConfig = config or {}
            local placeholderText = textConfig.PlaceholderText or "Enter text..."
            local defaultText = textConfig.Default or ""
            local clearOnFocus = textConfig.ClearOnFocus
            if clearOnFocus == nil then clearOnFocus = true end
            local callback = textConfig.Callback or function() end
            
            local TextBoxHolder = CreateInstance("Frame", {
                Name = "TextBoxHolder",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40)
            })
            
            local TextBoxFrame = CreateInstance("Frame", {
                Name = "TextBoxFrame",
                Parent = TextBoxHolder,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0),
                BorderSizePixel = 0
            })
            
            local TextBoxCorner = CreateInstance("UICorner", {
                Parent = TextBoxFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            local TextBox = CreateInstance("TextBox", {
                Name = "TextBox",
                Parent = TextBoxFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.GothamSemibold,
                PlaceholderText = placeholderText,
                Text = defaultText,
                TextColor3 = UI.Theme.TextColor,
                PlaceholderColor3 = UI.Theme.InactiveColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = clearOnFocus
            })
            
            -- Add a subtle border when focused
            TextBox.Focused:Connect(function()
                Tween(TextBoxFrame, {BackgroundColor3 = UI.Theme.AccentColor:Lerp(UI.Theme.ElementBackgroundColor, 0.7)}, 0.2)
            end)
            
            TextBox.FocusLost:Connect(function(enterPressed)
                Tween(TextBoxFrame, {BackgroundColor3 = UI.Theme.ElementBackgroundColor}, 0.2)
                callback(TextBox.Text, enterPressed)
            end)
            
            -- TextBox Methods
            local textBoxFunctions = {}
            
            function textBoxFunctions:Set(text)
                TextBox.Text = text
            end
            
            function textBoxFunctions:Get()
                return TextBox.Text
            end
            
            return textBoxFunctions
        end
        
        -- Add ColorPicker
        function Elements:AddColorPicker(config)
            local colorConfig = config or {}
            local title = colorConfig.Title or "Color Picker"
            local default = colorConfig.Default or Color3.fromRGB(255, 255, 255)
            local callback = colorConfig.Callback or function() end
            
            local ColorPickerHolder = CreateInstance("Frame", {
                Name = "ColorPickerHolder",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40)
            })
            
            local ColorPickerFrame = CreateInstance("Frame", {
                Name = "ColorPickerFrame",
                Parent = ColorPickerHolder,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0),
                BorderSizePixel = 0,
                ClipsDescendants = true
            })
            
            local ColorPickerCorner = CreateInstance("UICorner", {
                Parent = ColorPickerFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            local ColorPickerLabel = CreateInstance("TextLabel", {
                Name = "ColorPickerLabel",
                Parent = ColorPickerFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = title,
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ColorDisplay = CreateInstance("Frame", {
                Name = "ColorDisplay",
                Parent = ColorPickerFrame,
                Position = UDim2.new(1, -40, 0.5, -10),
                Size = UDim2.new(0, 30, 0, 20),
                BackgroundColor3 = default,
                BorderSizePixel = 0
            })
            
            local ColorDisplayCorner = CreateInstance("UICorner", {
                Parent = ColorDisplay,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Color picker popup
            local ColorPickerPopup = CreateInstance("Frame", {
                Name = "ColorPickerPopup",
                Parent = ColorPickerFrame,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor,
                Position = UDim2.new(0, 0, 0, 40),
                Size = UDim2.new(1, 0, 0, 0), -- Will expand when opened
                BorderSizePixel = 0,
                ZIndex = 10,
                Visible = false
            })
            
            local PopupCorner = CreateInstance("UICorner", {
                Parent = ColorPickerPopup,
                CornerRadius = UDim.new(0, 6)
            })
            
            -- HSV color picker
            local HueFrame = CreateInstance("Frame", {
                Name = "HueFrame",
                Parent = ColorPickerPopup,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0, 20, 0, 150),
                ZIndex = 10
            })
            
            local HueCorner = CreateInstance("UICorner", {
                Parent = HueFrame,
                CornerRadius = UDim.new(0, 4)
            })
            
            local HueGradient = CreateInstance("UIGradient", {
                Parent = HueFrame,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }),
                Rotation = 90
            })
            
            local HueSelector = CreateInstance("Frame", {
                Name = "HueSelector",
                Parent = HueFrame,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 1,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Position = UDim2.new(0, -2, 0, 0),
                Size = UDim2.new(1, 4, 0, 3),
                ZIndex = 11
            })
            
            local SatValFrame = CreateInstance("Frame", {
                Name = "SatValFrame",
                Parent = ColorPickerPopup,
                BackgroundColor3 = Color3.fromRGB(255, 0, 0), -- Will be set by hue
                Position = UDim2.new(0, 40, 0, 10),
                Size = UDim2.new(1, -50, 0, 150),
                ZIndex = 10
            })
            
            local SatValCorner = CreateInstance("UICorner", {
                Parent = SatValFrame,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Black gradient overlay (for value)
            local ValueGradient = CreateInstance("UIGradient", {
                Parent = SatValFrame,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                }),
                Rotation = 90
            })
            
            -- White gradient overlay (for saturation)
            local SaturationGradient = CreateInstance("Frame", {
                Name = "SaturationGradient",
                Parent = SatValFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                ZIndex = 11
            })
            
            local SaturationCorner = CreateInstance("UICorner", {
                Parent = SaturationGradient,
                CornerRadius = UDim.new(0, 4)
            })
            
            local SaturationOverlay = CreateInstance("UIGradient", {
                Parent = SaturationGradient,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255, 0))
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                })
            })
            
            local SatValSelector = CreateInstance("Frame", {
                Name = "SatValSelector",
                Parent = SatValFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(1, 0, 0, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ZIndex = 12
            })
            
            local SelectorCircle = CreateInstance("UICorner", {
                Parent = SatValSelector,
                CornerRadius = UDim.new(1, 0)
            })
            
            local SelectorOutline = CreateInstance("UIStroke", {
                Parent = SatValSelector,
                Color = Color3.fromRGB(255, 255, 255),
                Thickness = 2
            })
            
            -- Color input display
            local RGBHolder = CreateInstance("Frame", {
                Name = "RGBHolder",
                Parent = ColorPickerPopup,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 170),
                Size = UDim2.new(1, -20, 0, 25),
                ZIndex = 10
            })
            
            local RLabel = CreateInstance("TextLabel", {
                Name = "RLabel",
                Parent = RGBHolder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 25, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = "R:",
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                ZIndex = 10
            })
            
            local RInput = CreateInstance("TextBox", {
                Name = "RInput",
                Parent = RGBHolder,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor:Lerp(Color3.fromRGB(0, 0, 0), 0.3),
                Position = UDim2.new(0, 25, 0, 0),
                Size = UDim2.new(0, 40, 1, 0),
                Font = Enum.Font.GothamSemibold,
                PlaceholderText = "0-255",
                Text = tostring(math.floor(default.R * 255)),
                TextColor3 = UI.Theme.TextColor,
                PlaceholderColor3 = UI.Theme.InactiveColor,
                TextSize = 14,
                ZIndex = 10
            })
            
            local RInputCorner = CreateInstance("UICorner", {
                Parent = RInput,
                CornerRadius = UDim.new(0, 4)
            })
            
            local GLabel = CreateInstance("TextLabel", {
                Name = "GLabel",
                Parent = RGBHolder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 75, 0, 0),
                Size = UDim2.new(0, 25, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = "G:",
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                ZIndex = 10
            })
            
            local GInput = CreateInstance("TextBox", {
                Name = "GInput",
                Parent = RGBHolder,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor:Lerp(Color3.fromRGB(0, 0, 0), 0.3),
                Position = UDim2.new(0, 100, 0, 0),
                Size = UDim2.new(0, 40, 1, 0),
                Font = Enum.Font.GothamSemibold,
                PlaceholderText = "0-255",
                Text = tostring(math.floor(default.G * 255)),
                TextColor3 = UI.Theme.TextColor,
                PlaceholderColor3 = UI.Theme.InactiveColor,
                TextSize = 14,
                ZIndex = 10
            })
            
            local GInputCorner = CreateInstance("UICorner", {
                Parent = GInput,
                CornerRadius = UDim.new(0, 4)
            })
            
            local BLabel = CreateInstance("TextLabel", {
                Name = "BLabel",
                Parent = RGBHolder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 150, 0, 0),
                Size = UDim2.new(0, 25, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = "B:",
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                ZIndex = 10
            })
            
            local BInput = CreateInstance("TextBox", {
                Name = "BInput",
                Parent = RGBHolder,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor:Lerp(Color3.fromRGB(0, 0, 0), 0.3),
                Position = UDim2.new(0, 175, 0, 0),
                Size = UDim2.new(0, 40, 1, 0),
                Font = Enum.Font.GothamSemibold,
                PlaceholderText = "0-255",
                Text = tostring(math.floor(default.B * 255)),
                TextColor3 = UI.Theme.TextColor,
                PlaceholderColor3 = UI.Theme.InactiveColor,
                TextSize = 14,
                ZIndex = 10
            })
            
            local BInputCorner = CreateInstance("UICorner", {
                Parent = BInput,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Color picker functionality
            local isOpen = false
            local currentColor = default
            local h, s, v = 0, 0, 1 -- Default HSV (white)
            
            -- Convert RGB to HSV
            local function rgbToHsv(color)
                local r, g, b = color.R, color.G, color.B
                local max, min = math.max(r, g, b), math.min(r, g, b)
                local h, s, v
                v = max
                
                local d = max - min
                if max == 0 then s = 0 else s = d / max end
                
                if max == min then
                    h = 0
                else
                    if max == r then
                        h = (g - b) / d
                        if g < b then h = h + 6 end
                    elseif max == g then
                        h = (b - r) / d + 2
                    elseif max == b then
                        h = (r - g) / d + 4
                    end
                    h = h / 6
                end
                
                return h, s, v
            end
            
            -- Convert HSV to RGB
            local function hsvToRgb(h, s, v)
                local r, g, b
                
                local i = math.floor(h * 6)
                local f = h * 6 - i
                local p = v * (1 - s)
                local q = v * (1 - f * s)
                local t = v * (1 - (1 - f) * s)
                
                i = i % 6
                
                if i == 0 then r, g, b = v, t, p
                elseif i == 1 then r, g, b = q, v, p
                elseif i == 2 then r, g, b = p, v, t
                elseif i == 3 then r, g, b = p, q, v
                elseif i == 4 then r, g, b = t, p, v
                elseif i == 5 then r, g, b = v, p, q
                end
                
                return Color3.new(r, g, b)
            end
            
            -- Set initial HSV from default color
            h, s, v = rgbToHsv(default)
            
            local function updateColor()
                currentColor = hsvToRgb(h, s, v)
                ColorDisplay.BackgroundColor3 = currentColor
                SatValFrame.BackgroundColor3 = hsvToRgb(h, 1, 1) -- Pure hue
                
                -- Update selectors
                HueSelector.Position = UDim2.new(0, -2, h, -1)
                SatValSelector.Position = UDim2.new(s, 0, 1-v, 0)
                
                -- Update RGB inputs
                RInput.Text = tostring(math.floor(currentColor.R * 255))
                GInput.Text = tostring(math.floor(currentColor.G * 255))
                BInput.Text = tostring(math.floor(currentColor.B * 255))
                
                callback(currentColor)
            end
            
            -- Handle RGB input
            local function updateFromRGB()
                local r = tonumber(RInput.Text) or 0
                local g = tonumber(GInput.Text) or 0
                local b = tonumber(BInput.Text) or 0
                
                r = math.clamp(r, 0, 255) / 255
                g = math.clamp(g, 0, 255) / 255
                b = math.clamp(b, 0, 255) / 255
                
                currentColor = Color3.new(r, g, b)
                h, s, v = rgbToHsv(currentColor)
                updateColor()
            end
            
            RInput.FocusLost:Connect(function() updateFromRGB() end)
            GInput.FocusLost:Connect(function() updateFromRGB() end)
            BInput.FocusLost:Connect(function() updateFromRGB() end)
            
            -- Handle Hue selection
            local pickingHue = false
            
            HueFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    pickingHue = true
                end
            end)
            
            HueFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    pickingHue = false
                end
            end)
            
            -- Handle SatVal selection
            local pickingSatVal = false
            
            SatValFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    pickingSatVal = true
                end
            end)
            
            SatValFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    pickingSatVal = false
                end
            end)
            
            -- Mouse movement detection
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if pickingHue then
                        local huePos = (input.Position.Y - HueFrame.AbsolutePosition.Y) / HueFrame.AbsoluteSize.Y
                        h = math.clamp(huePos, 0, 1)
                        updateColor()
                    elseif pickingSatVal then
                        local satPos = (input.Position.X - SatValFrame.AbsolutePosition.X) / SatValFrame.AbsoluteSize.X
                        local valPos = 1 - (input.Position.Y - SatValFrame.AbsolutePosition.Y) / SatValFrame.AbsoluteSize.Y
                        s = math.clamp(satPos, 0, 1)
                        v = math.clamp(valPos, 0, 1)
                        updateColor()
                    end
                end
            end)
            
            -- Toggle color picker
            local function togglePicker()
                isOpen = not isOpen
                
                ColorPickerPopup.Visible = true
                
                if isOpen then
                    ColorPickerHolder:TweenSize(
                        UDim2.new(1, 0, 0, 240), -- Expanded size
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                    ColorPickerPopup:TweenSize(
                        UDim2.new(1, 0, 0, 200), -- Content size
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                else
                    ColorPickerHolder:TweenSize(
                        UDim2.new(1, 0, 0, 40), -- Original size
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                    ColorPickerPopup:TweenSize(
                        UDim2.new(1, 0, 0, 0),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true,
                        function()
                            ColorPickerPopup.Visible = false
                        end
                    )
                end
            end
            
            ColorPickerFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    togglePicker()
                end
            end)
            
            -- Update initial color
            updateColor()
            
            -- ColorPicker methods
            local colorPickerFunctions = {}
            
            function colorPickerFunctions:Set(color)
                currentColor = color
                h, s, v = rgbToHsv(color)
                updateColor()
            end
            
            function colorPickerFunctions:Get()
                return currentColor
            end
            
            return colorPickerFunctions
        end
        
        -- Add Keybind
        function Elements:AddKeybind(config)
            local keyConfig = config or {}
            local title = keyConfig.Title or "Keybind"
            local default = keyConfig.Default -- Can be nil or an enum
            local callback = keyConfig.Callback or function() end
            
            local KeybindHolder = CreateInstance("Frame", {
                Name = "KeybindHolder",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40)
            })
            
            local KeybindFrame = CreateInstance("Frame", {
                Name = "KeybindFrame",
                Parent = KeybindHolder,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 1, 0),
                BorderSizePixel = 0
            })
            
            local KeybindCorner = CreateInstance("UICorner", {
                Parent = KeybindFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            local KeybindLabel = CreateInstance("TextLabel", {
                Name = "KeybindLabel",
                Parent = KeybindFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -80, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = title,
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local KeybindButton = CreateInstance("TextButton", {
                Name = "KeybindButton",
                Parent = KeybindFrame,
                BackgroundColor3 = UI.Theme.ElementBackgroundColor:Lerp(Color3.fromRGB(0, 0, 0), 0.3),
                Position = UDim2.new(1, -70, 0.5, -15),
                Size = UDim2.new(0, 60, 0, 30),
                Font = Enum.Font.GothamSemibold,
                Text = default and string.sub(tostring(default), 14) or "...",
                TextColor3 = UI.Theme.TextColor,
                TextSize = 14,
                BorderSizePixel = 0
            })
            
            local KeybindButtonCorner = CreateInstance("UICorner", {
                Parent = KeybindButton,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Keybind functionality
            local selectedKey = default
            local listening = false
            
            local function updateKeybind()
                KeybindButton.Text = selectedKey and string.sub(tostring(selectedKey), 14) or "..."
            end
            
            KeybindButton.MouseButton1Click:Connect(function()
                if listening then return end
                
                listening = true
                KeybindButton.Text = "..."
                
                -- Change button color to indicate listening state
                Tween(KeybindButton, {BackgroundColor3 = UI.Theme.AccentColor}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    selectedKey = input.KeyCode
                    updateKeybind()
                    callback(selectedKey)
                    
                    -- Change button color back
                    Tween(KeybindButton, {BackgroundColor3 = UI.Theme.ElementBackgroundColor:Lerp(Color3.fromRGB(0, 0, 0), 0.3)}, 0.2)
                    listening = false
                elseif not listening and selectedKey and input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode == selectedKey then
                        callback(selectedKey)
                    end
                end
            end)
            
            -- Initial setup
            updateKeybind()
            
            -- Keybind methods
            local keybindFunctions = {}
            
            function keybindFunctions:Set(key)
                selectedKey = key
                updateKeybind()
                return keybindFunctions
            end
            
            function keybindFunctions:Get()
                return selectedKey
            end
            
            return keybindFunctions
        end
        
        -- Add Notification System
        function UI:AddNotification(config)
            local notifConfig = config or {}
            local title = notifConfig.Title or "Notification"
            local text = notifConfig.Text or ""
            local duration = notifConfig.Duration or 3
            local position = notifConfig.Position or "TopRight"
            local type = notifConfig.Type or "Info" -- Info, Success, Warning, Error
            
            -- Create notification container if it doesn't exist
            if not self.NotificationContainer then
                self.NotificationContainer = {}
                self.NotificationQueue = {}
                
                -- Create containers for each position
                local positions = {"TopLeft", "TopRight", "BottomLeft", "BottomRight"}
                
                for _, pos in ipairs(positions) do
                    self.NotificationContainer[pos] = CreateInstance("Frame", {
                        Name = "NotifContainer_" .. pos,
                        Parent = self.ScreenGui,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 300, 1, -20),
                        Position = 
                            pos == "TopLeft" and UDim2.new(0, 10, 0, 10) or
                            pos == "TopRight" and UDim2.new(1, -310, 0, 10) or
                            pos == "BottomLeft" and UDim2.new(0, 10, 1, -10) or
                            UDim2.new(1, -310, 1, -10)
                    })
                    
                    local ListLayout = CreateInstance("UIListLayout", {
                        Parent = self.NotificationContainer[pos],
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = 
                            pos == "BottomLeft" or pos == "BottomRight" 
                            and Enum.VerticalAlignment.Bottom 
                            or Enum.VerticalAlignment.Top,
                        Padding = UDim.new(0, 5)
                    })
                end
            end
            
            -- Color based on type
            local typeColor
            if type == "Success" then
                typeColor = Color3.fromRGB(0, 180, 0)
            elseif type == "Warning" then
                typeColor = Color3.fromRGB(255, 180, 0)
            elseif type == "Error" then
                typeColor = Color3.fromRGB(255, 0, 0)
            else -- Info
                typeColor = self.Theme.AccentColor
            end
            
            -- Create the notification
            local Notification = CreateInstance("Frame", {
                Name = "Notification",
                Parent = self.NotificationContainer[position],
                BackgroundColor3 = self.Theme.ElementBackgroundColor,
                Size = UDim2.new(1, 0, 0, 0), -- Start with 0 height, will tween to actual size
                BackgroundTransparency = 1, -- Start fully transparent
                ClipsDescendants = true
            })
            
            local NotificationCorner = CreateInstance("UICorner", {
                Parent = Notification,
                CornerRadius = UDim.new(0, 6)
            })
            
            local NotificationPadding = CreateInstance("UIPadding", {
                Parent = Notification,
                PaddingTop = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
            
            -- Indicator bar
            local TypeIndicator = CreateInstance("Frame", {
                Name = "TypeIndicator",
                Parent = Notification,
                BackgroundColor3 = typeColor,
                Size = UDim2.new(0, 4, 1, -16),
                Position = UDim2.new(0, 0, 0, 8),
                BorderSizePixel = 0
            })
            
            local IndicatorCorner = CreateInstance("UICorner", {
                Parent = TypeIndicator,
                CornerRadius = UDim.new(0, 2)
            })
            
            -- Title and text
            local NotificationTitle = CreateInstance("TextLabel", {
                Name = "Title",
                Parent = Notification,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 0, 24),
                Font = Enum.Font.GothamBold,
                Text = title,
                TextColor3 = self.Theme.TextColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local NotificationText = CreateInstance("TextLabel", {
                Name = "Text",
                Parent = Notification,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 24),
                Size = UDim2.new(1, -20, 0, 0), -- Height will be set based on text
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = self.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true
            })
            
            -- Calculate needed height
            local textSize = game:GetService("TextService"):GetTextSize(
                text,
                14,
                Enum.Font.Gotham,
                Vector2.new(Notification.AbsoluteSize.X - 40, math.huge)
            )
            
            local textHeight = math.max(textSize.Y, 20)
            NotificationText.Size = UDim2.new(1, -20, 0, textHeight)
            
            -- Total height: padding + title height + text height + padding
            local totalHeight = 16 + 24 + textHeight + 8
            
            -- Close button
            local CloseButton = CreateInstance("TextButton", {
                Name = "CloseButton",
                Parent = Notification,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -24, 0, 0),
                Size = UDim2.new(0, 24, 0, 24),
                Font = Enum.Font.GothamBold,
                Text = "×",
                TextColor3 = self.Theme.TextColor,
                TextSize = 18
            })
            
            -- Progress bar
            local ProgressBarBg = CreateInstance("Frame", {
                Name = "ProgressBarBg",
                Parent = Notification,
                BackgroundColor3 = self.Theme.ElementBorderColor,
                Position = UDim2.new(0, 0, 1, -2),
                Size = UDim2.new(1, 0, 0, 2),
                BorderSizePixel = 0
            })
            
            local ProgressBar = CreateInstance("Frame", {
                Name = "ProgressBar",
                Parent = ProgressBarBg,
                BackgroundColor3 = typeColor,
                Size = UDim2.new(1, 0, 1, 0),
                BorderSizePixel = 0
            })
            
            -- Animation
            local function animateIn()
                Notification.Size = UDim2.new(1, 0, 0, totalHeight)
                Tween(Notification, {BackgroundTransparency = 0}, 0.2)
            end
            
            local function animateOut()
                local tween = Tween(Notification, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                tween.Completed:Connect(function()
                    Notification:Destroy()
                end)
            end
            
            -- Progress bar animation
            local progressTween = Tween(ProgressBar, {Size = UDim2.new(0, 0, 1, 0)}, duration)
            
            -- Close button functionality
            CloseButton.MouseButton1Click:Connect(function()
                progressTween:Cancel()
                animateOut()
            end)
            
            -- Start animation
            animateIn()
            
            -- Set timeout for auto-close
            task.delay(duration, function()
                animateOut()
            end)
            
            return Notification
        end
        
        -- Add Section
        function Elements:AddSection(title)
            local SectionHolder = CreateInstance("Frame", {
                Name = "SectionHolder",
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30)
            })
            
            local SectionLine = CreateInstance("Frame", {
                Name = "SectionLine",
                Parent = SectionHolder,
                BackgroundColor3 = UI.Theme.AccentColor,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, -1),
                Size = UDim2.new(1, 0, 0, 2)
            })
            
            local SectionTitle = CreateInstance("TextLabel", {
                Name = "SectionTitle",
                Parent = SectionHolder,
                BackgroundColor3 = UI.Theme.SecondaryColor,
                BackgroundTransparency = 0,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(0, 0, 1, 0), -- Width will adjust to text
                Font = Enum.Font.GothamBold,
                Text = "  " .. title .. "  ",
                TextColor3 = UI.Theme.AccentColor,
                TextSize = 14,
                BorderSizePixel = 0
            })
            
            local SectionTitleCorner = CreateInstance("UICorner", {
                Parent = SectionTitle,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Auto-adjust width based on text
            local textSize = game:GetService("TextService"):GetTextSize(
                "  " .. title .. "  ",
                14,
                Enum.Font.GothamBold,
                Vector2.new(math.huge, SectionTitle.AbsoluteSize.Y)
            )
            
            SectionTitle.Size = UDim2.new(0, textSize.X + 10, 1, 0)
            
            return SectionHolder
        end
        
        return Elements
    end
    
    -- Select tab function
    function UI:SelectTab(index)
        for i, tab in ipairs(self.Tabs) do
            if i == index then
                Tween(tab.Button, {BackgroundColor3 = self.Theme.AccentColor}, 0.2)
                tab.Page.Visible = true
                self.ActiveTab = i
            else
                Tween(tab.Button, {BackgroundColor3 = self.Theme.ElementBackgroundColor}, 0.2)
                tab.Page.Visible = false
            end
        end
    end
    
    return UI
end

-- Return the library
return MicahsUI