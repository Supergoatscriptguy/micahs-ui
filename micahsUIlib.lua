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
]]

local LuminaUI = {
    Flags = {},
    Version = "1.0.0",
    Theme = {
        Default = {
            TextColor = Color3.fromRGB(240, 240, 240),
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
            DropdownSelected = Color3.fromRGB(40, 40, 40),
            DropdownUnselected = Color3.fromRGB(30, 30, 30)
        },
        Dark = {
            TextColor = Color3.fromRGB(220, 220, 220),
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
            DropdownSelected = Color3.fromRGB(30, 30, 30),
            DropdownUnselected = Color3.fromRGB(20, 20, 20)
        },
        Ocean = {
            TextColor = Color3.fromRGB(230, 240, 240),
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
            DropdownSelected = Color3.fromRGB(30, 50, 60),
            DropdownUnselected = Color3.fromRGB(25, 35, 45)
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

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local SelectedTheme = LuminaUI.Theme.Default
local ConfigFolder = "LuminaUI"
local ConfigExtension = ".config"
local Library

-- Utility functions
local function createInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    return instance
end

local function loadIcon(id)
    if type(id) == "number" then
        return "rbxassetid://" .. id
    else
        return id
    end
end

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Configuration functions
local function saveConfig(settings)
    if not settings.ConfigurationSaving or not settings.ConfigurationSaving.Enabled then return end
    
    local data = {}
    for flag, element in pairs(LuminaUI.Flags) do
        if element.Type then
            if element.Type == "Toggle" or element.Type == "Slider" then
                data[flag] = element.Value
            elseif element.Type == "Dropdown" then
                data[flag] = element.Value
            end
        end
    end
    
    if writefile then
        if not isfolder(ConfigFolder) and makefolder then
            makefolder(ConfigFolder)
        end
        
        local configName = settings.ConfigurationSaving.FileName or "config"
        writefile(ConfigFolder.."/"..configName..ConfigExtension, HttpService:JSONEncode(data))
    end
end

local function loadConfig(settings)
    if not settings.ConfigurationSaving or not settings.ConfigurationSaving.Enabled then return {} end
    
    if isfile and readfile then
        local configName = settings.ConfigurationSaving.FileName or "config"
        local filePath = ConfigFolder.."/"..configName..ConfigExtension
        
        if isfile(filePath) then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(filePath))
            end)
            
            if success then
                return data
            end
        end
    end
    
    return {}
end

-- UI Creation Functions
function LuminaUI:CreateWindow(settings)
    settings = settings or {}
    settings.Name = settings.Name or "LuminaUI"
    settings.Theme = settings.Theme or "Default"
    settings.Size = settings.Size or UDim2.new(0, 550, 0, 475)
    settings.Icon = settings.Icon or 0
    settings.ConfigurationSaving = settings.ConfigurationSaving or {Enabled = false}
    
    -- Set theme
    if settings.Theme and LuminaUI.Theme[settings.Theme] then
        SelectedTheme = LuminaUI.Theme[settings.Theme]
    end
    
    -- Create base UI
    if Library then
        Library:Destroy()
    end
    
    Library = createInstance("ScreenGui", {
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
    
    -- Main window frame
    local MainFrame = createInstance("Frame", {
        Name = "MainFrame",
        Size = settings.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = SelectedTheme.Background,
        BorderSizePixel = 0,
        Parent = Library
    })
    
    local UICorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    -- Shadow
    local Shadow = createInstance("ImageLabel", {
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
    local Topbar = createInstance("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = SelectedTheme.Topbar,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local TopbarCorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Topbar
    })
    
    local TopbarCornerFix = createInstance("Frame", {
        Name = "CornerFix",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = SelectedTheme.Topbar,
        BorderSizePixel = 0,
        Parent = Topbar
    })
    
    local TopbarTitle = createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -45, 1, 0),
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
        local Icon = createInstance("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = loadIcon(settings.Icon),
            Parent = Topbar
        })
        
        TopbarTitle.Position = UDim2.new(0, 40, 0, 0)
    end
    
    -- Control buttons
    local CloseButton = createInstance("ImageButton", {
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
    
    local MinimizeButton = createInstance("ImageButton", {
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
    
    -- Content container
    local ContentContainer = createInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -10, 1, -55),
        Position = UDim2.new(0, 5, 0, 50),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    -- Tab container
    local TabContainer = createInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 130, 1, 0),
        BackgroundTransparency = 1,
        Parent = ContentContainer
    })
    
    local TabScrollFrame = createInstance("ScrollingFrame", {
        Name = "TabScrollFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        BorderSizePixel = 0,
        Parent = TabContainer
    })
    
    local TabListLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabScrollFrame
    })
    
    local TabPadding = createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        Parent = TabScrollFrame
    })
    
    -- Elements container
    local ElementsContainer = createInstance("Frame", {
        Name = "ElementsContainer",
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.new(0, 140, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = ContentContainer
    })
    
    local ElementsPageFolder = createInstance("Folder", {
        Name = "Pages",
        Parent = ElementsContainer
    })
    
    -- Make the UI draggable
    makeDraggable(MainFrame, Topbar)
    
    -- Create notification container
    local Notifications = createInstance("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 260, 1, -10),
        Position = UDim2.new(1, -280, 0, 5),
        BackgroundTransparency = 1,
        Parent = Library
    })
    
    local NotificationListLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = Notifications
    })
    
    -- Button functionality
    CloseButton.MouseButton1Click:Connect(function()
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
    
    -- Button hover effects
    for _, button in ipairs({CloseButton, MinimizeButton}) do
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
        
        local Notification = createInstance("Frame", {
            Name = "Notification",
            Size = UDim2.new(0, 260, 0, 80),
            BackgroundColor3 = SelectedTheme.NotificationBackground,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 0, 0),
            Parent = Notifications
        })
        
        local NotificationCorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = Notification
        })
        
        local NotificationTitle = createInstance("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -15, 0, 25),
            Position = UDim2.new(0, 15, 0, 5),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = notificationSettings.Title,
            TextColor3 = SelectedTheme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1,
            Parent = Notification
        })
        
        local NotificationContent = createInstance("TextLabel", {
            Name = "Content",
            Size = UDim2.new(1, -15, 0, 40),
            Position = UDim2.new(0, 15, 0, 30),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = notificationSettings.Content,
            TextColor3 = SelectedTheme.TextColor,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextTransparency = 1,
            Parent = Notification
        })
        
        -- Animation
        TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        TweenService:Create(NotificationTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            TextTransparency = 0
        }):Play()
        
        TweenService:Create(NotificationContent, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            TextTransparency = 0
        }):Play()
        
        -- Remove after duration
        task.delay(notificationSettings.Duration, function()
            if not Notification or not Notification.Parent then return end
            
            TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(NotificationTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(NotificationContent, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
                TextTransparency = 1
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
        local TabButton = createInstance("Frame", {
            Name = tabName,
            Size = UDim2.new(1, -10, 0, 34),
            BackgroundColor3 = SelectedTheme.TabBackground,
            BackgroundTransparency = 0.7,
            Parent = TabScrollFrame
        })
        
        local TabUICorner = createInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })
        
        local TabUIStroke = createInstance("UIStroke", {
            Color = SelectedTheme.TabStroke,
            Thickness = 1,
            Transparency = 0.5,
            Parent = TabButton
        })
        
        local TabTitle = createInstance("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 32, 0, 0),
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
            local TabImage = createInstance("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 8, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image = loadIcon(tabIcon),
                ImageColor3 = SelectedTheme.TabTextColor,
                ImageTransparency = 0.2,
                Parent = TabButton
            })
        else
            TabTitle.Position = UDim2.new(0, 10, 0, 0)
        end
        
        local TabInteract = createInstance("TextButton", {
            Name = "Interact",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = TabButton
        })
        
        -- Create page for tab content
        local TabPage = createInstance("ScrollingFrame", {
            Name = tabName,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = SelectedTheme.ElementStroke,
            ScrollBarImageTransparency = 0.5,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = ElementsPageFolder
        })
        
        local ElementsListLayout = createInstance("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabPage
        })
        
        local ElementsPadding = createInstance("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            Parent = TabPage
        })
        
        -- Auto-size canvas
        ElementsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, ElementsListLayout.AbsoluteContentSize.Y + 16)
        end)
        
        -- Handle tab selection
        TabInteract.MouseButton1Click:Connect(function()
            for _, tab in ipairs(TabScrollFrame:GetChildren()) do
                if tab:IsA("Frame") and tab ~= TabButton then
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
                    
                    TweenService:Create(tab:FindFirstChild("UIStroke"), TweenInfo.new(0.3), {
                        Transparency = 0.5
                    }):Play()
                end
            end
            
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
            
            TweenService:Create(TabUIStroke, TweenInfo.new(0.3), {
                Transparency = 1
            }):Play()
            
            for _, page in ipairs(ElementsPageFolder:GetChildren()) do
                if page:IsA("ScrollingFrame") then
                    page.Visible = page.Name == tabName
                end
            end
        end)
        
        -- Select first tab by default
        if #TabScrollFrame:GetChildren() == 2 then -- 1 tab + UIListLayout
            TabInteract.MouseButton1Click:Fire()
        end
        
        -- Tab API
        local Tab = {}
        
        -- Create section
        function Tab:CreateSection(sectionName)
            local SectionTitle = createInstance("Frame", {
                Name = "SectionTitle",
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = TabPage
            })
            
            local SectionText = createInstance("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                Text = sectionName,
                TextColor3 = SelectedTheme.TextColor,
                TextSize = 14,
                TextTransparency = 0.4,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionTitle
            })
            
            return {
                Set = function(_, newName)
                    SectionText.Text = newName
                end
            }
        end
        
        -- Create button
        function Tab:CreateButton(buttonSettings)
            buttonSettings = buttonSettings or {}
            buttonSettings.Name = buttonSettings.Name or "Button"
            buttonSettings.Callback = buttonSettings.Callback or function() end
            
            local Button = createInstance("Frame", {
                Name = buttonSettings.Name,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = SelectedTheme.ElementBackground,
                Parent = TabPage
            })
            
            local ButtonUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Button
            })
            
            local ButtonUIStroke = createInstance("UIStroke", {
                Color = SelectedTheme.ElementStroke,
                Thickness = 1,
                Parent = Button
            })
            
            local ButtonTitle = createInstance("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = buttonSettings.Name,
                TextColor3 = SelectedTheme.TextColor,
                TextSize = 14,
                Parent = Button
            })
            
            local ButtonInteract = createInstance("TextButton", {
                Name = "Interact",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = Button
            })
            
            -- Button effects
            ButtonInteract.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.3), {
                    BackgroundColor3 = SelectedTheme.ElementBackgroundHover
                }):Play()
            end)
            
            ButtonInteract.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.3), {
                    BackgroundColor3 = SelectedTheme.ElementBackground
                }):Play()
            end)
            
            ButtonInteract.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = SelectedTheme.ElementBackgroundHover
                }):Play()
                
                task.spawn(function()
                    pcall(buttonSettings.Callback)
                end)
                
                task.wait(0.2)
                TweenService:Create(Button, TweenInfo.new(0.3), {
                    BackgroundColor3 = SelectedTheme.ElementBackground
                }):Play()
            end)
            
            return {
                Set = function(_, newName)
                    ButtonTitle.Text = newName
                    Button.Name = newName
                end
            }
        end
        
        -- Create toggle
        function Tab:CreateToggle(toggleSettings)
            toggleSettings = toggleSettings or {}
            toggleSettings.Name = toggleSettings.Name or "Toggle"
            toggleSettings.CurrentValue = toggleSettings.CurrentValue or false
            toggleSettings.Flag = toggleSettings.Flag or toggleSettings.Name
            toggleSettings.Callback = toggleSettings.Callback or function() end
            
            local Toggle = createInstance("Frame", {
                Name = toggleSettings.Name,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = SelectedTheme.ElementBackground,
                Parent = TabPage
            })
            
            local ToggleUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Toggle
            })
            
            local ToggleUIStroke = createInstance("UIStroke", {
                Color = SelectedTheme.ElementStroke,
                Thickness = 1,
                Parent = Toggle
            })
            
            local ToggleTitle = createInstance("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, -56, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = toggleSettings.Name,
                TextColor3 = SelectedTheme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Toggle
            })
            
            local ToggleSwitch = createInstance("Frame", {
                Name = "Switch",
                Size = UDim2.new(0, 38, 0, 20),
                Position = UDim2.new(1, -48, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = SelectedTheme.ToggleBackground,
                Parent = Toggle
            })
            
            local SwitchUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = ToggleSwitch
            })
            
            local SwitchUIStroke = createInstance("UIStroke", {
                Color = toggleSettings.CurrentValue and SelectedTheme.ToggleEnabled or SelectedTheme.ElementStroke,
                Thickness = 1,
                Parent = ToggleSwitch
            })
            
            local SwitchIndicator = createInstance("Frame", {
                Name = "Indicator",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, toggleSettings.CurrentValue and 20 or 2, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = toggleSettings.CurrentValue and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled,
                Parent = ToggleSwitch
            })
            
            local IndicatorUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = SwitchIndicator
            })
            
            local ToggleInteract = createInstance("TextButton", {
                Name = "Interact",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = Toggle
            })
            
            -- Toggle interaction
            local function updateToggle(value)
                toggleSettings.CurrentValue = value
                
                if value then
                    TweenService:Create(SwitchIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                        Position = UDim2.new(0, 20, 0.5, 0),
                        BackgroundColor3 = SelectedTheme.ToggleEnabled
                    }):Play()
                    
                    TweenService:Create(SwitchUIStroke, TweenInfo.new(0.3), {
                        Color = SelectedTheme.ToggleEnabled
                    }):Play()
                else
                    TweenService:Create(SwitchIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                        Position = UDim2.new(0, 2, 0.5, 0),
                        BackgroundColor3 = SelectedTheme.ToggleDisabled
                    }):Play()
                    
                    TweenService:Create(SwitchUIStroke, TweenInfo.new(0.3), {
                        Color = SelectedTheme.ElementStroke
                    }):Play()
                end
                
                pcall(toggleSettings.Callback, value)
                saveConfig(settings)
            end
            
            ToggleInteract.MouseButton1Click:Connect(function()
                updateToggle(not toggleSettings.CurrentValue)
            end)
            
            -- Button effects
            ToggleInteract.MouseEnter:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.3), {
                    BackgroundColor3 = SelectedTheme.ElementBackgroundHover
                }):Play()
            end)
            
            ToggleInteract.MouseLeave:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.3), {
                    BackgroundColor3 = SelectedTheme.ElementBackground
                }):Play()
            end)
            
            -- Set up flag
            local ToggleObject = {
                Type = "Toggle",
                Value = toggleSettings.CurrentValue,
                Set = function(_, value)
                    updateToggle(value)
                end
            }
            
            LuminaUI.Flags[toggleSettings.Flag] = ToggleObject
            return ToggleObject
        end
        
        -- Create slider
        function Tab:CreateSlider(sliderSettings)
            sliderSettings = sliderSettings or {}
            sliderSettings.Name = sliderSettings.Name or "Slider"
            sliderSettings.Range = sliderSettings.Range or {0, 100}
            sliderSettings.Increment = sliderSettings.Increment or 1
            sliderSettings.CurrentValue = sliderSettings.CurrentValue or 50
            sliderSettings.Suffix = sliderSettings.Suffix or ""
            sliderSettings.Flag = sliderSettings.Flag or sliderSettings.Name
            sliderSettings.Callback = sliderSettings.Callback or function() end
            
            -- Clamp the current value to range
            sliderSettings.CurrentValue = math.clamp(
                sliderSettings.CurrentValue, 
                sliderSettings.Range[1], 
                sliderSettings.Range[2]
            )
            
            local Slider = createInstance("Frame", {
                Name = sliderSettings.Name,
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = SelectedTheme.ElementBackground,
                Parent = TabPage
            })
            
            local SliderUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Slider
            })
            
            local SliderUIStroke = createInstance("UIStroke", {
                Color = SelectedTheme.ElementStroke,
                Thickness = 1,
                Parent = Slider
            })
            
            local SliderTitle = createInstance("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, -150, 0, 20),
                Position = UDim2.new(0, 10, 0, 6),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = sliderSettings.Name,
                TextColor3 = SelectedTheme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Slider
            })
            
            local SliderValue = createInstance("TextLabel", {
                Name = "Value",
                Size = UDim2.new(0, 140, 0, 20),
                Position = UDim2.new(1, -150, 0, 6),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = sliderSettings.CurrentValue .. " " .. sliderSettings.Suffix,
                TextColor3 = SelectedTheme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = Slider
            })
            
            local SliderBar = createInstance("Frame", {
                Name = "Bar",
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 36),
                BackgroundColor3 = SelectedTheme.SliderBackground,
                BackgroundTransparency = 0.7,
                Parent = Slider
            })
            
            local SliderBarUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 3),
                Parent = SliderBar
            })
            
            local SliderProgress = createInstance("Frame", {
                Name = "Progress",
                Size = UDim2.new(
                    (sliderSettings.CurrentValue - sliderSettings.Range[1]) / 
                    (sliderSettings.Range[2] - sliderSettings.Range[1]),
                    0, 1, 0
                ),
                BackgroundColor3 = SelectedTheme.SliderProgress,
                Parent = SliderBar
            })
            
            local SliderProgressUICorner = createInstance("UICorner", {
                CornerRadius = UDim.new(0, 3),
                Parent = SliderProgress
            })
            
            local SliderInteract = createInstance("TextButton", {
                Name = "Interact",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = SliderBar
            })
            
            -- Slider functionality
            local isDragging = false
            
            local function updateSlider(input)
                local sliderPos = input.Position.X - SliderBar.AbsolutePosition.X
                local sliderWidth = SliderBar.AbsoluteSize.X
                
                local percent = math.clamp(sliderPos / sliderWidth, 0, 1)
                local rawValue = sliderSettings.Range[1] + ((sliderSettings.Range[2] - sliderSettings.Range[1]) * percent)
                
                -- Apply increment
                local value = sliderSettings.Range[1] + (math.floor((rawValue - sliderSettings.Range[1]) / sliderSettings.Increment + 0.5) * sliderSettings.Increment)
                value = math.clamp(value, sliderSettings.Range[1], sliderSettings.Range[2])
                
                -- Update UI
                TweenService:Create(SliderProgress, TweenInfo.new(0.1), {
                    Size = UDim2.new((value - sliderSettings.Range[1]) / (sliderSettings.Range[2] - sliderSettings.Range[1]), 0, 1, 0)
                }):Play()
                
                SliderValue.Text = value .. " " .. sliderSettings.Suffix
                
                if value ~= sliderSettings.CurrentValue then
                    sliderSettings.CurrentValue = value
                    LuminaUI.Flags[sliderSettings.Flag].Value = value
                    pcall(sliderSettings.Callback, value)
                    saveConfig(settings)
                end
            end
            
            SliderInteract.MouseButton1Down:Connect(function()
                isDragging = true
                updateSlider({Position = Mouse.X})
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
                    updateSlider(input)
                end
            end)
            
            -- Button effects
            Slider.MouseEnter:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.3), {
                    BackgroundColor3 = SelectedTheme.ElementBackgroundHover
                }):Play()
            end)
            
            Slider.MouseLeave:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.3), {
                    BackgroundColor3 = SelectedTheme.ElementBackground
                }):Play()
            end)
            
            -- Set up flag
            local SliderObject = {
                Type = "Slider",
                Value = sliderSettings.CurrentValue,
                Set = function(_, value)
                    value = math.clamp(value, sliderSettings.Range[1], sliderSettings.Range[2])
                    sliderSettings.CurrentValue = value
                    
                    SliderValue.Text = value .. " " .. sliderSettings.Suffix
                    TweenService:Create(SliderProgress, TweenInfo.new(0.3), {
                        Size = UDim2.new((value - sliderSettings.Range[1]) / (sliderSettings.Range[2] - sliderSettings.Range[1]), 0, 1, 0)
                    }):Play()
                    
                    pcall(sliderSettings.Callback, value)
                    saveConfig(settings)
                end
            }
            
            LuminaUI.Flags[sliderSettings.Flag] = SliderObject
            return SliderObject
        end
        
        return Tab
    end
    
    -- Load saved configuration
    local savedConfig = loadConfig(settings)
    for flag, value in pairs(savedConfig) do
        if LuminaUI.Flags[flag] then
            task.spawn(function()
                LuminaUI.Flags[flag]:Set(value)
            end)
        end
    end
    
    return Window
end

return LuminaUI
