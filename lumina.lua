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
    Version = "2.2.1-dev", -- Incremented version
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
// ...existing code...
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

    -- REMOVED LOADING SCREEN CODE

    -- Load configuration *before* creating main UI elements
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

    -- Create base ScreenGui for the main UI
    Library = Utility.createInstance("ScreenGui", {
        Name = "LuminaUI_" .. settings.Name:gsub("%s+", "_"), -- Unique name
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 1000, -- Display order
        IgnoreGuiInset = true, -- Render over the top bar inset
        -- BackgroundTransparency = 1 -- Keep transparent
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
            Padding = UDim.new(0, 12), -- Increased padding from 8 to 12
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
            Name = "ThemeGrid",
            AutomaticSize = Enum.AutomaticSize.Y, -- Automatically adjust height based on content
            BackgroundTransparency = 1,
            LayoutOrder = 2, Parent = SettingsPage
        })
        local ThemeGridLayout = Utility.createInstance("UIGridLayout", {
            CellPadding = UDim2.new(0, 10, 0, 10), CellSize = UDim2.new(0, 100, 0, 100),
            HorizontalAlignment = Enum.HorizontalAlignment.Left, SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal, -- Ensure horizontal filling
            StartCorner = Enum.StartCorner.TopLeft, -- Start placing items from the top-left
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
        if settings.ConfigurationSaving and settings.ConfigurationSaving.Enabled and MainFrame and MainFrame.Parent then
            Utility.saveConfig(MainFrame, settings)
        end

        -- Directly call destroy without fade animation
        LuminaUI:Destroy()
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
            local parent = options.Parent or TabPage -- Allow overriding parent (for sections)

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
                BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
            }, "Button", updateTheme) -- Track Button
            Utility.createCorner(ButtonFrame, 4)
            local stroke = Utility.createStroke(ButtonFrame, SelectedTheme.ElementStroke, 1)

            local textXOffset = elementPadding
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
        local parent = options.Parent or TabPage -- Allow overriding parent

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
           BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
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
        local parent = options.Parent or TabPage -- Allow overriding parent

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
           BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
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
        local parent = options.Parent or TabPage -- Allow overriding parent

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
               local listScroll = dropdownList:FindFirstChild("ListFrame")
               if listScroll then
                   for _, optionFrame in ipairs(listScroll:GetChildren()) do
                       if optionFrame:IsA("Frame") then
                           local optionLabel = optionFrame:FindFirstChild("Label")
                           local checkmark = optionFrame:FindFirstChild("Checkmark")
                           local isSelected = false
                           if optionLabel then -- Check if label exists before accessing text
                               if allowMultiSelect then
                                   isSelected = table.find(LuminaUI.Flags[flag].Value, optionLabel.Text)
                               else
                                   isSelected = LuminaUI.Flags[flag].Value == optionLabel.Text
                               end
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
        end

        local DropdownFrame = Utility.createInstance("Frame", {
           Name = "Dropdown_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
           BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #parent:GetChildren() + 1, Parent = parent, -- Use correct parent
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
-- ...existing code...
updateTheme(DropdownFrame) -- Update visuals with new selection
end
}
Tab.Elements[flag] = DropdownAPI -- Store API under flag name

return DropdownAPI
end

-- CreateColorPicker (Refactored with Theme Update)
function Tab:CreateColorPicker(options)
options = options or {}
local pickerName = options.Name or "Color Picker"
local flag = options.Flag -- Mandatory flag name
local defaultValue = options.Default or Color3.fromRGB(255, 255, 255)
local callback = options.Callback or function(value) print(pickerName .. " set to " .. tostring(value)) end
local icon = options.Icon
local tooltip = options.Tooltip
local parent = options.Parent or TabPage -- Allow overriding parent

if not flag then warn("LuminaUI: ColorPicker '" .. pickerName .. "' requires a 'Flag' option."); return end

local initialValue = registerFlag(flag, defaultValue, "ColorPicker")

local elementHeight = 36
local elementPadding = 10
local iconSize = 20
local colorPreviewSize = 24
local pickerOpen = false
local pickerFrame = nil -- Instance reference

local updateTheme = function(instance)
local colorPreview = instance:FindFirstChild("ColorPreview")
local iconLabel = instance:FindFirstChild("Icon")
local label = instance:FindFirstChild("Label")
local stroke = instance:FindFirstChildOfClass("UIStroke")

instance.BackgroundColor3 = SelectedTheme.ElementBackground
if stroke then stroke.Color = SelectedTheme.ElementStroke end
if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
if label then label.TextColor3 = SelectedTheme.TextColor end
if colorPreview then colorPreview.BackgroundColor3 = LuminaUI.Flags[flag].Value end -- Update preview color

-- Update picker theme if open
if pickerFrame and pickerFrame.Parent then
    pickerFrame.BackgroundColor3 = SelectedTheme.ElementBackground
    local pickerStroke = pickerFrame:FindFirstChildOfClass("UIStroke")
    if pickerStroke then pickerStroke.Color = SelectedTheme.ElementStroke end

    -- Update internal picker elements (saturation/value box, hue slider, etc.)
    local svBox = pickerFrame:FindFirstChild("SVBox")
    if svBox then
        local svStroke = svBox:FindFirstChildOfClass("UIStroke")
        if svStroke then svStroke.Color = SelectedTheme.ElementStroke end
        -- SV gradient doesn't change with theme, but cursor might
        local svCursor = svBox:FindFirstChild("Cursor")
        if svCursor then svCursor.BackgroundColor3 = SelectedTheme.TextColor end
    end
    local hueSlider = pickerFrame:FindFirstChild("HueSlider")
    if hueSlider then
        local hueStroke = hueSlider:FindFirstChildOfClass("UIStroke")
        if hueStroke then hueStroke.Color = SelectedTheme.ElementStroke end
        local hueCursor = hueSlider:FindFirstChild("Cursor")
        if hueCursor then hueCursor.BackgroundColor3 = SelectedTheme.TextColor end
    end
    local hexInput = pickerFrame:FindFirstChild("HexInput")
    if hexInput then
        hexInput.BackgroundColor3 = SelectedTheme.ElementBackgroundHover
        hexInput.TextColor3 = SelectedTheme.TextColor
        hexInput.PlaceholderColor3 = SelectedTheme.SubTextColor
        local hexStroke = hexInput:FindFirstChildOfClass("UIStroke")
        if hexStroke then hexStroke.Color = SelectedTheme.ElementStroke end
    end
end
end

local ColorPickerFrame = Utility.createInstance("Frame", {
Name = "ColorPicker_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #parent:GetChildren() + 1, Parent = parent, -- Use correct parent
ClipsDescendants = false -- Allow picker to show
}, "ColorPicker", updateTheme) -- Track ColorPicker
Utility.createCorner(ColorPickerFrame, 4)
local stroke = Utility.createStroke(ColorPickerFrame, SelectedTheme.ElementStroke, 1)

local textXOffset = elementPadding
if icon then
 local PickerIcon = Utility.createInstance("ImageLabel", {
     Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
     AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
     ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = ColorPickerFrame
 })
 textXOffset = elementPadding + iconSize + 8
end

-- Label
local PickerLabel = Utility.createInstance("TextLabel", {
Name = "Label", Size = UDim2.new(1, -(textXOffset + elementPadding + colorPreviewSize + 10), 1, 0), -- Adjust width for color preview
Position = UDim2.new(0, textXOffset, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
Text = pickerName, TextColor3 = SelectedTheme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = ColorPickerFrame
})

-- Color Preview Box
local ColorPreview = Utility.createInstance("Frame", {
Name = "ColorPreview", Size = UDim2.new(0, colorPreviewSize, 0, colorPreviewSize), Position = UDim2.new(1, -elementPadding, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = initialValue, BorderSizePixel = 0, Parent = ColorPickerFrame
})
Utility.createCorner(ColorPreview, 4)
Utility.createStroke(ColorPreview, SelectedTheme.ElementStroke, 1) -- Add stroke to preview

-- Interaction Button
local PickerInteract = Utility.createInstance("TextButton", {
Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 1, Parent = ColorPickerFrame
})

-- Function to toggle the color picker UI
local function toggleColorPickerUI(forceClose)
if pickerOpen and not forceClose then -- Close it
    pickerOpen = false
    if pickerFrame and pickerFrame.Parent then
        local pickerTween = TweenService:Create(pickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 })
        pickerTween:Play()
        Utility.Connect(pickerTween.Completed, function()
            Utility.destroyInstance(pickerFrame)
            pickerFrame = nil
        end)
    end
    stroke.Color = SelectedTheme.ElementStroke -- Reset stroke on close
    if tooltip then Utility.hideTooltip() end

elseif not pickerOpen and not forceClose then -- Open it
    pickerOpen = true
    stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled -- Highlight stroke when open

    local pickerHeight = 180 -- Adjust as needed
    local pickerYPos = elementHeight + 2

    -- Theme update function for the picker container
    local updatePickerContainerTheme = function(instance)
        instance.BackgroundColor3 = SelectedTheme.ElementBackground
        local pickerStroke = instance:FindFirstChildOfClass("UIStroke")
        if pickerStroke then pickerStroke.Color = SelectedTheme.ElementStroke end
        -- Internal element updates are handled by the main ColorPicker updateTheme
    end

    pickerFrame = Utility.createInstance("Frame", {
        Name = "ColorPickerUI", Size = UDim2.new(1, 0, 0, 0), -- Start height 0
        Position = UDim2.new(0, 0, 0, pickerYPos), BackgroundColor3 = SelectedTheme.ElementBackground,
        BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 100, Parent = ColorPickerFrame
    }, "ColorPickerContainer", updatePickerContainerTheme) -- Track picker container
    Utility.createCorner(pickerFrame, 4)
    Utility.createStroke(pickerFrame, SelectedTheme.ElementStroke, 1)

    local padding = 8
    local svBoxSize = pickerHeight - padding * 2 - 30 -- Leave space for hex input
    local hueSliderWidth = 20
    local hueSliderHeight = svBoxSize
    local svBoxWidth = pickerFrame.AbsoluteSize.X - padding * 3 - hueSliderWidth

    -- Saturation/Value Box
    local SVBox = Utility.createInstance("Frame", {
        Name = "SVBox", Size = UDim2.new(0, svBoxWidth, 0, svBoxSize), Position = UDim2.new(0, padding, 0, padding),
        BackgroundColor3 = Color3.new(1,1,1), -- Base color set later
        ClipsDescendants = true, Parent = pickerFrame
    })
    Utility.createCorner(SVBox, 3)
    Utility.createStroke(SVBox, SelectedTheme.ElementStroke, 1)

    local SaturationGradient = Utility.createInstance("UIGradient", { Name = "Saturation", Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(1,1,1))}), Rotation = 0, Parent = SVBox }) -- Hue sets end color
    local ValueGradient = Utility.createInstance("UIGradient", { Name = "Value", Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0,0,0,1)), ColorSequenceKeypoint.new(1, Color3.new(0,0,0,0))}), Rotation = 90, Parent = SVBox })

    local SVCursor = Utility.createInstance("Frame", {
        Name = "Cursor", Size = UDim2.new(0, 8, 0, 8), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = SelectedTheme.TextColor, BorderSizePixel = 0, ZIndex = 1, Parent = SVBox
    })
    Utility.createCorner(SVCursor, 4)
    Utility.createStroke(SVCursor, Color3.new(0,0,0), 1) -- Black stroke for visibility

    -- Hue Slider
    local HueSlider = Utility.createInstance("Frame", {
        Name = "HueSlider", Size = UDim2.new(0, hueSliderWidth, 0, hueSliderHeight), Position = UDim2.new(0, svBoxWidth + padding * 2, 0, padding),
        BackgroundColor3 = Color3.new(1,1,1), ClipsDescendants = true, Parent = pickerFrame
    })
    Utility.createCorner(HueSlider, 3)
    Utility.createStroke(HueSlider, SelectedTheme.ElementStroke, 1)

    local HueGradient = Utility.createInstance("UIGradient", {
        Name = "Hue",
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }), Rotation = 90, Parent = HueSlider
    })

    local HueCursor = Utility.createInstance("Frame", {
        Name = "Cursor", Size = UDim2.new(1, 4, 0, 4), Position = UDim2.new(0.5, 0, 0, 0), -- Y pos set later
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = SelectedTheme.TextColor, BorderSizePixel = 0, ZIndex = 1, Parent = HueSlider
    })
    Utility.createCorner(HueCursor, 2)
    Utility.createStroke(HueCursor, Color3.new(0,0,0), 1)

    -- Hex Input Box
    local HexInput = Utility.createInstance("TextBox", {
        Name = "HexInput", Size = UDim2.new(1, -padding * 2, 0, 24), Position = UDim2.new(0.5, 0, 1, -padding - 12),
        AnchorPoint = Vector2.new(0.5, 1), BackgroundColor3 = SelectedTheme.ElementBackgroundHover, BorderSizePixel = 0,
        Font = Enum.Font.GothamMono, Text = "", TextColor3 = SelectedTheme.TextColor, TextSize = 12,
        PlaceholderText = "#RRGGBB", PlaceholderColor3 = SelectedTheme.SubTextColor, ClearTextOnFocus = false, ZIndex = 1, Parent = pickerFrame
    })
    Utility.createCorner(HexInput, 3)
    Utility.createStroke(HexInput, SelectedTheme.ElementStroke, 1)

    -- Color Picker Logic
    local currentH, currentS, currentV = Color3.toHSV(LuminaUI.Flags[flag].Value)

    local function updatePickerVisuals(updateHex)
        local hueColor = Color3.fromHSV(currentH, 1, 1)
        SaturationGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, hueColor)})
        SVBox.BackgroundColor3 = hueColor -- Set background for transparency in value gradient

        SVCursor.Position = UDim2.new(currentS, 0, 1 - currentV, 0)
        HueCursor.Position = UDim2.new(0.5, 0, currentH, 0)

        local finalColor = Color3.fromHSV(currentH, currentS, currentV)
        ColorPreview.BackgroundColor3 = finalColor -- Update main preview

        if updateHex then
            HexInput.Text = Utility.colorToHex(finalColor)
        end
    end

    local function updateColorFromHSV(triggerCallback)
        local newColor = Color3.fromHSV(currentH, currentS, currentV)
        if LuminaUI.Flags[flag].Value == newColor then return end -- No change

        LuminaUI.Flags[flag].Value = newColor
        updatePickerVisuals(true) -- Update visuals and hex

        if triggerCallback then
            local success, err = pcall(callback, newColor)
            if not success then warn("LuminaUI ColorPicker Error:", err) end
        end
    end

    -- Initial setup
    updatePickerVisuals(true)

    -- Input Handling
    local svDragging = false
    local hueDragging = false

    Utility.Connect(SVBox.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
            local relPos = input.Position - SVBox.AbsolutePosition
            currentS = math.clamp(relPos.X / SVBox.AbsoluteSize.X, 0, 1)
            currentV = math.clamp(1 - (relPos.Y / SVBox.AbsoluteSize.Y), 0, 1)
            updateColorFromHSV(true)
            UserInputService.TextSelectionEnabled = false
        end
    end)
    Utility.Connect(HueSlider.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            local relPos = input.Position - HueSlider.AbsolutePosition
            currentH = math.clamp(relPos.Y / HueSlider.AbsoluteSize.Y, 0, 1)
            updateColorFromHSV(true)
            UserInputService.TextSelectionEnabled = false
        end
    end)

    Utility.Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if svDragging or hueDragging then UserInputService.TextSelectionEnabled = true end
            svDragging = false
            hueDragging = false
        end
    end)

    Utility.Connect(UserInputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if svDragging then
                local relPos = input.Position - SVBox.AbsolutePosition
                currentS = math.clamp(relPos.X / SVBox.AbsoluteSize.X, 0, 1)
                currentV = math.clamp(1 - (relPos.Y / SVBox.AbsoluteSize.Y), 0, 1)
                updateColorFromHSV(true)
            elseif hueDragging then
                local relPos = input.Position - HueSlider.AbsolutePosition
                currentH = math.clamp(relPos.Y / HueSlider.AbsoluteSize.Y, 0, 1)
                updateColorFromHSV(true)
            end
        end
    end)

    -- Hex Input Handling
    Utility.Connect(HexInput.FocusLost, function(enterPressed)
        if enterPressed then
            local hex = HexInput.Text
            local success, color = pcall(Utility.hexToColor, hex)
            if success and color then
                currentH, currentS, currentV = Color3.toHSV(color)
                updateColorFromHSV(true) -- Update everything including the hex box format
            else
                -- Revert to current color's hex if invalid input
                HexInput.Text = Utility.colorToHex(LuminaUI.Flags[flag].Value)
            end
        else
             -- Revert if focus lost without pressing enter
             HexInput.Text = Utility.colorToHex(LuminaUI.Flags[flag].Value)
        end
    end)

    -- Animate picker open
    local pickerTween = TweenService:Create(pickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, pickerHeight), BackgroundTransparency = 0 })
    pickerTween:Play()
end
end

-- Effects & Callback for main picker button
Utility.Connect(PickerInteract.MouseEnter, function()
if not pickerOpen then
    TweenService:Create(ColorPickerFrame, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
    stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled
end
if tooltip then Utility.showTooltip(tooltip) end
end)
Utility.Connect(PickerInteract.MouseLeave, function()
if not pickerOpen then
    TweenService:Create(ColorPickerFrame, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
    stroke.Color = SelectedTheme.ElementStroke
end
if tooltip then Utility.hideTooltip() end
end)
Utility.Connect(PickerInteract.MouseButton1Click, function()
toggleColorPickerUI()
end)

-- Close picker if clicked outside
local function checkClickOutsidePicker(input)
if not pickerOpen or not pickerFrame or not pickerFrame.Parent then return end

local mousePos = input.Position
local framePos = ColorPickerFrame.AbsolutePosition
local frameSize = ColorPickerFrame.AbsoluteSize
local pickerUIPos = pickerFrame.AbsolutePosition
local pickerUISize = pickerFrame.AbsoluteSize

local inFrame = mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y
local inPickerUI = mousePos.X >= pickerUIPos.X and mousePos.X <= pickerUIPos.X + pickerUISize.X and mousePos.Y >= pickerUIPos.Y and mousePos.Y <= pickerUIPos.Y + pickerUISize.Y

if not inFrame and not inPickerUI then
    toggleColorPickerUI(true) -- Force close
end
end
local pickerClickOutsideConnection = Utility.Connect(UserInputService.InputBegan, function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
     checkClickOutsidePicker(input)
 end
end)
Utility.storeConnection(ColorPickerFrame, pickerClickOutsideConnection)

-- API to update color picker state externally
local ColorPickerAPI = {
Instance = ColorPickerFrame,
Type = "ColorPicker",
Flag = flag,
SetValue = function(newValue)
    if typeof(newValue) == "Color3" then
        LuminaUI.Flags[flag].Value = newValue
        updateTheme(ColorPickerFrame) -- Update visuals (including picker if open)
        -- If picker is open, update its internal state too
        if pickerOpen and pickerFrame and pickerFrame.Parent then
            currentH, currentS, currentV = Color3.toHSV(newValue)
            updatePickerVisuals(true)
        end
    else
        warn("LuminaUI: Invalid value type for ColorPicker SetValue. Expected Color3.")
    end
end,
GetValue = function()
    return LuminaUI.Flags[flag].Value
end
}
Tab.Elements[flag] = ColorPickerAPI -- Store API under flag name

return ColorPickerAPI
end

-- CreateKeybind (Refactored with Theme Update and Centralized Handling)
function Tab:CreateKeybind(options)
options = options or {}
local keybindName = options.Name or "Keybind"
local flag = options.Flag -- Mandatory flag name
local defaultKey = options.Default or Enum.KeyCode.None -- Default to None
local defaultModifiers = options.DefaultModifiers or { Shift = false, Ctrl = false, Alt = false }
local callback = options.Callback or function() print(keybindName .. " triggered") end
local allowUnset = options.AllowUnset == nil and true or options.AllowUnset -- Allow setting to None
local icon = options.Icon
local tooltip = options.Tooltip
local parent = options.Parent or TabPage -- Allow overriding parent

if not flag then warn("LuminaUI: Keybind '" .. keybindName .. "' requires a 'Flag' option."); return end
if not settings.KeySystem or not settings.KeySystem.Enabled then
 warn("LuminaUI: Keybind system is disabled. Keybind '" .. keybindName .. "' will not function.")
 -- Optionally create a disabled visual element or just return nil
 return nil
end

-- Register flag (stores { Key = Enum.KeyCode, Modifiers = { Shift=bool, Ctrl=bool, Alt=bool } })
local initialValue = registerFlag(flag, { Key = defaultKey, Modifiers = defaultModifiers }, "Keybind")

-- Register the keybind with the central listener
local keybindId = flag -- Use flag as unique ID
LuminaUI._Keybinds[keybindId] = {
 Key = initialValue.Key,
 Modifiers = initialValue.Modifiers,
 Callback = callback,
 Element = nil -- Will be set later
}

local elementHeight = 36
local elementPadding = 10
local iconSize = 20
local keyTextWidth = 100 -- Adjust as needed

local isListening = false -- Track if waiting for input

local updateTheme = function(instance)
local keyLabel = instance:FindFirstChild("KeyLabel")
local iconLabel = instance:FindFirstChild("Icon")
local label = instance:FindFirstChild("Label")
local stroke = instance:FindFirstChildOfClass("UIStroke")

instance.BackgroundColor3 = SelectedTheme.ElementBackground
if stroke then stroke.Color = isListening and (SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled) or SelectedTheme.ElementStroke end
if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
if label then label.TextColor3 = SelectedTheme.TextColor end
if keyLabel then
    keyLabel.BackgroundColor3 = isListening and SelectedTheme.ElementBackgroundActive or SelectedTheme.ElementBackgroundHover
    keyLabel.TextColor3 = SelectedTheme.TextColor
    local keyStroke = keyLabel:FindFirstChildOfClass("UIStroke")
    if keyStroke then keyStroke.Color = SelectedTheme.ElementStroke end
end
end

local KeybindFrame = Utility.createInstance("Frame", {
Name = "Keybind_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
}, "Keybind", updateTheme) -- Track Keybind
Utility.createCorner(KeybindFrame, 4)
local stroke = Utility.createStroke(KeybindFrame, SelectedTheme.ElementStroke, 1)

local textXOffset = elementPadding
if icon then
 local KeybindIcon = Utility.createInstance("ImageLabel", {
     Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
     AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
     ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = KeybindFrame
 })
 textXOffset = elementPadding + iconSize + 8
end

-- Label
local KeybindLabel = Utility.createInstance("TextLabel", {
Name = "Label", Size = UDim2.new(1, -(textXOffset + elementPadding + keyTextWidth + 10), 1, 0), -- Adjust width for key text
Position = UDim2.new(0, textXOffset, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
Text = keybindName, TextColor3 = SelectedTheme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = KeybindFrame
})

-- Key Display/Input Button
local KeyLabel = Utility.createInstance("TextButton", {
Name = "KeyLabel", Size = UDim2.new(0, keyTextWidth, 0, 24), Position = UDim2.new(1, -elementPadding, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = SelectedTheme.ElementBackgroundHover, BorderSizePixel = 0,
Font = Enum.Font.Gotham, Text = "", -- Set later
TextColor3 = SelectedTheme.TextColor, TextSize = 12, AutoButtonColor = false, Parent = KeybindFrame
})
Utility.createCorner(KeyLabel, 3)
Utility.createStroke(KeyLabel, SelectedTheme.ElementStroke, 1)

-- Function to format key display text
local function formatKeyText(keyData)
if isListening then return "..." end
if not keyData or keyData.Key == Enum.KeyCode.None then return "None" end

local parts = {}
if keyData.Modifiers.Ctrl then table.insert(parts, "Ctrl") end
if keyData.Modifiers.Alt then table.insert(parts, "Alt") end
if keyData.Modifiers.Shift then table.insert(parts, "Shift") end

local keyName = keyData.Key.Name
-- Simplify common key names
keyName = keyName:gsub("LeftControl", "Ctrl"):gsub("RightControl", "Ctrl")
keyName = keyName:gsub("LeftShift", "Shift"):gsub("RightShift", "Shift")
keyName = keyName:gsub("LeftAlt", "Alt"):gsub("RightAlt", "Alt")
keyName = keyName:gsub("PageUp", "PgUp"):gsub("PageDown", "PgDn")
keyName = keyName:gsub("MouseButton1", "M1"):gsub("MouseButton2", "M2")
-- Add more simplifications if needed

table.insert(parts, keyName)
return table.concat(parts, " + ")
end

-- Initial text update
KeyLabel.Text = formatKeyText(initialValue)

-- Input Listening Logic
local inputConnection = nil
local function stopListening(updateKeyData)
if not isListening then return end
isListening = false
if inputConnection then
    inputConnection:Disconnect()
    inputConnection = nil
end
KeyLabel.Text = formatKeyText(updateKeyData or LuminaUI.Flags[flag].Value) -- Update text with new or current key
updateTheme(KeybindFrame) -- Update visuals (stroke, background)
-- Re-enable global keybinds if they were temporarily disabled (optional)
end

local function startListening()
if isListening then return end
isListening = true
KeyLabel.Text = "..."
updateTheme(KeybindFrame) -- Update visuals

-- Temporarily disable global keybinds? (Might be complex/risky)

inputConnection = Utility.Connect(UserInputService.InputBegan, function(input, gameProcessed)
    if gameProcessed then return end -- Ignore game-processed input

    local key = input.KeyCode
    -- Ignore modifier keys themselves as the primary key
    if key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift or
       key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.RightControl or
       key == Enum.KeyCode.LeftAlt or key == Enum.KeyCode.RightAlt then
        return
    end

    -- Allow Escape to cancel/unset
    if key == Enum.KeyCode.Escape then
        if allowUnset then
            local newKeyData = { Key = Enum.KeyCode.None, Modifiers = { Shift = false, Ctrl = false, Alt = false } }
            LuminaUI.Flags[flag].Value = newKeyData
            LuminaUI._Keybinds[keybindId].Key = newKeyData.Key
            LuminaUI._Keybinds[keybindId].Modifiers = newKeyData.Modifiers
            stopListening(newKeyData)
        else
            stopListening() -- Cancel without changing
        end
        return
    end

    local modifiers = {
        Shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift),
        Ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl),
        Alt = UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
    }

    local newKeyData = { Key = key, Modifiers = modifiers }
    LuminaUI.Flags[flag].Value = newKeyData
    LuminaUI._Keybinds[keybindId].Key = newKeyData.Key
    LuminaUI._Keybinds[keybindId].Modifiers = newKeyData.Modifiers

    stopListening(newKeyData)
end)
end

-- Effects & Callback for key label button
Utility.Connect(KeyLabel.MouseButton1Click, function()
if isListening then
    stopListening() -- Cancel listening if clicked again
else
    startListening()
end
end)
-- Hover effect on main frame (only when not listening)
Utility.Connect(KeybindFrame.MouseEnter, function()
if not isListening then stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled end
if tooltip then Utility.showTooltip(tooltip) end
end)
Utility.Connect(KeybindFrame.MouseLeave, function()
if not isListening then stroke.Color = SelectedTheme.ElementStroke end
if tooltip then Utility.hideTooltip() end
end)

-- Stop listening if clicked outside
local function checkClickOutsideKeybind(input)
if not isListening then return end
local mousePos = input.Position
local framePos = KeybindFrame.AbsolutePosition
local frameSize = KeybindFrame.AbsoluteSize
if not (mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y) then
    stopListening()
end
end
local keybindClickOutsideConnection = Utility.Connect(UserInputService.InputBegan, function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
     checkClickOutsideKeybind(input)
 end
end)
Utility.storeConnection(KeybindFrame, keybindClickOutsideConnection)

-- Store element reference in central keybind data
LuminaUI._Keybinds[keybindId].Element = KeybindFrame

-- API to update keybind state externally
local KeybindAPI = {
Instance = KeybindFrame,
Type = "Keybind",
Flag = flag,
SetValue = function(newValue)
    if type(newValue) == "table" and newValue.Key and newValue.Modifiers then
        -- Basic validation
        if typeof(newValue.Key) == "EnumItem" and newValue.Key.EnumType == Enum.KeyCode and
           type(newValue.Modifiers) == "table" and type(newValue.Modifiers.Shift) == "boolean" and
           type(newValue.Modifiers.Ctrl) == "boolean" and type(newValue.Modifiers.Alt) == "boolean" then

            LuminaUI.Flags[flag].Value = newValue
            LuminaUI._Keybinds[keybindId].Key = newValue.Key
            LuminaUI._Keybinds[keybindId].Modifiers = newValue.Modifiers
            KeyLabel.Text = formatKeyText(newValue)
            if isListening then stopListening(newValue) end -- Stop listening if active
        else
            warn("LuminaUI: Invalid keybind data structure for Keybind SetValue.")
        end
    else
        warn("LuminaUI: Invalid value type for Keybind SetValue. Expected { Key = Enum.KeyCode, Modifiers = { ... } }.")
    end
end,
GetValue = function()
    return LuminaUI.Flags[flag].Value
end
}
Tab.Elements[flag] = KeybindAPI -- Store API under flag name

return KeybindAPI
end

-- CreateTextbox (Refactored with Theme Update)
function Tab:CreateTextbox(options)
options = options or {}
local textboxName = options.Name or "Textbox"
local flag = options.Flag -- Mandatory flag name
local defaultValue = options.Default or ""
local placeholder = options.Placeholder or "Enter text..."
local clearOnFocus = options.ClearOnFocus == nil and false or options.ClearOnFocus
local multiLine = options.MultiLine or false -- New option for multi-line
local callback = options.Callback or function(value) print(textboxName .. " text: " .. value) end
local icon = options.Icon
local tooltip = options.Tooltip
local parent = options.Parent or TabPage -- Allow overriding parent

if not flag then warn("LuminaUI: Textbox '" .. textboxName .. "' requires a 'Flag' option."); return end

local initialValue = registerFlag(flag, defaultValue, "Textbox")

local elementHeight = multiLine and 80 or 36 -- Taller for multi-line
local elementPadding = 10
local iconSize = 20

local updateTheme = function(instance)
local textBox = instance:FindFirstChild("InputBox")
local iconLabel = instance:FindFirstChild("Icon")
local label = instance:FindFirstChild("Label")
local stroke = instance:FindFirstChildOfClass("UIStroke")

instance.BackgroundColor3 = SelectedTheme.ElementBackground
if stroke then stroke.Color = SelectedTheme.ElementStroke end
if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
if label then label.TextColor3 = SelectedTheme.TextColor end

if textBox then
    textBox.BackgroundColor3 = SelectedTheme.ElementBackgroundHover
    textBox.TextColor3 = SelectedTheme.TextColor
    textBox.PlaceholderColor3 = SelectedTheme.SubTextColor
    local boxStroke = textBox:FindFirstChildOfClass("UIStroke")
    if boxStroke then boxStroke.Color = SelectedTheme.ElementStroke end
end
end

local TextboxFrame = Utility.createInstance("Frame", {
Name = "Textbox_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
}, "Textbox", updateTheme) -- Track Textbox
Utility.createCorner(TextboxFrame, 4)
local stroke = Utility.createStroke(TextboxFrame, SelectedTheme.ElementStroke, 1)

local topContentHeight = 20 -- Height for icon and label if not multi-line
local boxYOffset = multiLine and topContentHeight + 5 or 0
local boxHeight = multiLine and (elementHeight - boxYOffset - elementPadding) or (elementHeight - elementPadding * 2)
local boxXOffset = elementPadding
local boxWidth = UDim.new(1, -(elementPadding * 2))

-- Icon and Label (only if multi-line, otherwise integrated)
if multiLine then
topContentHeight = 20
if icon then
    local TextboxIcon = Utility.createInstance("ImageLabel", {
        Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0, topContentHeight / 2),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
        ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = TextboxFrame
    })
    boxXOffset = elementPadding + iconSize + 8
end
local TextboxLabel = Utility.createInstance("TextLabel", {
    Name = "Label", Size = UDim2.new(1, -(boxXOffset + elementPadding), 0, topContentHeight), Position = UDim2.new(0, boxXOffset, 0, 0),
    BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = textboxName, TextColor3 = SelectedTheme.TextColor,
    TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Parent = TextboxFrame
})
-- Adjust box position and size for multi-line label/icon row
boxXOffset = elementPadding
boxWidth = UDim.new(1, -(elementPadding * 2))
else
-- Single line: Integrate icon/label space into textbox positioning
topContentHeight = elementHeight -- Use full height
if icon then
    local TextboxIcon = Utility.createInstance("ImageLabel", {
        Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
        ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = TextboxFrame
    })
    boxXOffset = elementPadding + iconSize + 8
end
boxWidth = UDim.new(1, -(boxXOffset + elementPadding))
boxYOffset = elementPadding
end


-- Input Box
local InputBox = Utility.createInstance("TextBox", {
Name = "InputBox", Size = UDim2.new(boxWidth.Scale, boxWidth.Offset, 0, boxHeight),
Position = UDim2.new(0, boxXOffset, 0, boxYOffset),
BackgroundColor3 = SelectedTheme.ElementBackgroundHover, BorderSizePixel = 0,
Font = Enum.Font.Gotham, Text = initialValue, TextColor3 = SelectedTheme.TextColor, TextSize = 13,
PlaceholderText = placeholder, PlaceholderColor3 = SelectedTheme.SubTextColor, ClearTextOnFocus = clearOnFocus,
MultiLine = multiLine, TextWrapped = multiLine, -- Enable multi-line features
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = multiLine and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center, -- Top align for multi-line
Parent = TextboxFrame
})
Utility.createCorner(InputBox, 3)
Utility.createStroke(InputBox, SelectedTheme.ElementStroke, 1)

-- Logic for updating flag and callback
local function updateValue(newValue)
if LuminaUI.Flags[flag].Value == newValue then return end -- No change
LuminaUI.Flags[flag].Value = newValue
local success, err = pcall(callback, newValue)
if not success then warn("LuminaUI Textbox Error:", err) end
end

-- Connect events
Utility.Connect(InputBox.FocusLost, function(enterPressed)
updateValue(InputBox.Text)
-- Optionally restore placeholder if text is empty?
stroke.Color = SelectedTheme.ElementStroke -- Reset main frame stroke
end)

Utility.Connect(InputBox.Focused, function()
stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled -- Highlight main frame stroke on focus
if tooltip then Utility.showTooltip(tooltip) end
end)
Utility.Connect(InputBox.FocusLost, function()
 if tooltip then Utility.hideTooltip() end
end)

-- API to update textbox state externally
local TextboxAPI = {
Instance = TextboxFrame,
Type = "Textbox",
Flag = flag,
SetValue = function(newValue)
    newValue = tostring(newValue) -- Ensure string
    LuminaUI.Flags[flag].Value = newValue
    InputBox.Text = newValue
end,
GetValue = function()
    return LuminaUI.Flags[flag].Value
end,
Clear = function()
    LuminaUI.Flags[flag].Value = ""
    InputBox.Text = ""
end,
Focus = function()
    InputBox:CaptureFocus()
end,
Unfocus = function()
    InputBox:ReleaseFocus()
end
}
Tab.Elements[flag] = TextboxAPI -- Store API under flag name

return TextboxAPI
end

-- CreateLabel (Refactored with Theme Update)
function Tab:CreateLabel(options)
options = options or {}
local text = options.Text or "Label"
local size = options.Size or 13 -- Text size
local alignment = options.Alignment or Enum.TextXAlignment.Left
local color = options.Color -- Optional override color
local font = options.Font or Enum.Font.Gotham -- Optional override font
local parent = options.Parent or TabPage -- Allow overriding parent

local updateTheme = function(instance)
instance.TextColor3 = color or SelectedTheme.TextColor -- Use override or theme color
instance.Font = font or Enum.Font.Gotham -- Use override or theme font
end

-- Estimate height based on text size (adjust multiplier as needed)
local estimatedHeight = size * 1.5

local Label = Utility.createInstance("TextLabel", {
Name = "Label_" .. text:sub(1, 15):gsub("%s+", "_"), -- Basic unique name
Size = UDim2.new(1, 0, 0, estimatedHeight), -- Auto height might be better if possible
AutomaticSize = Enum.AutomaticSize.Y, -- Let Y size adjust automatically
BackgroundTransparency = 1,
Font = font or SelectedTheme.Font, -- Use override or theme font
Text = text,
TextColor3 = color or SelectedTheme.TextColor, -- Use override or theme color
TextSize = size,
TextWrapped = true, -- Wrap text by default
TextXAlignment = alignment,
TextYAlignment = Enum.TextYAlignment.Top, -- Align top for wrapped text
LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
}, "Label", updateTheme) -- Track Label

Tab.Elements[Label.Name] = { Instance = Label, Type = "Label" } -- Store reference

-- API (simple, mostly for updating text)
local LabelAPI = {
Instance = Label,
Type = "Label",
SetText = function(newText)
    Label.Text = newText
end,
SetColor = function(newColor)
    color = newColor -- Store override
    Label.TextColor3 = newColor
end
}
-- No flag associated with labels usually

return LabelAPI
end

-- CreateDivider (Refactored with Theme Update)
function Tab:CreateDivider(options)
options = options or {}
local thickness = options.Thickness or 1
local color = options.Color -- Optional override color
local padding = options.Padding or 5 -- Vertical padding around divider
local parent = options.Parent or TabPage -- Allow overriding parent

local updateTheme = function(instance)
instance.BackgroundColor3 = color or SelectedTheme.ElementStroke -- Use override or theme color
end

local DividerFrame = Utility.createInstance("Frame", {
Name = "Divider",
Size = UDim2.new(1, 0, 0, thickness + padding * 2), -- Frame includes padding
BackgroundTransparency = 1, -- Frame itself is transparent
LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
}, "DividerContainer", function() end) -- Track container, no direct theme

local DividerLine = Utility.createInstance("Frame", {
Name = "Line",
Size = UDim2.new(1, -20, 0, thickness), -- Line has horizontal padding
Position = UDim2.new(0.5, 0, 0.5, 0), -- Centered
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = color or SelectedTheme.ElementStroke, -- Use override or theme color
BorderSizePixel = 0,
Parent = DividerFrame
}, "DividerLine", updateTheme) -- Track the line itself for theme updates
Utility.createCorner(DividerLine, thickness / 2) -- Round ends if thick enough

Tab.Elements["Divider_"..tostring(tick())] = { Instance = DividerFrame, Type = "Divider" } -- Store reference

-- API (simple, mostly for updating color/thickness)
local DividerAPI = {
Instance = DividerFrame,
Type = "Divider",
SetColor = function(newColor)
    color = newColor -- Store override
    DividerLine.BackgroundColor3 = newColor
end,
SetThickness = function(newThickness)
    thickness = newThickness
    DividerFrame.Size = UDim2.new(1, 0, 0, thickness + padding * 2)
    DividerLine.Size = UDim2.new(1, -20, 0, thickness)
    -- Update corner radius?
end
}

return DividerAPI
end

-- CreateSection (Container for grouping elements)
function Tab:CreateSection(options)
 options = options or {}
 local sectionName = options.Name or "Section"
 local initiallyCollapsed = options.Collapsed or false -- Start collapsed?
 local parent = options.Parent or TabPage -- Allow overriding parent

 local updateTheme = function(instance)
     local header = instance:FindFirstChild("SectionHeader")
     local arrow = header and header:FindFirstChild("Arrow")
     local label = header and header:FindFirstChild("Label")
     local line = header and header:FindFirstChild("Line")
     local contentFrame = instance:FindFirstChild("SectionContent")

     instance.BackgroundColor3 = SelectedTheme.SectionBackground or SelectedTheme.ElementBackground -- Use specific or fallback
     local stroke = instance:FindFirstChildOfClass("UIStroke")
     if stroke then stroke.Color = SelectedTheme.ElementStroke end

     if header then header.BackgroundColor3 = SelectedTheme.SectionHeader or SelectedTheme.ElementBackgroundHover end -- Header background
     if arrow then arrow.ImageColor3 = SelectedTheme.SubTextColor end
     if label then label.TextColor3 = SelectedTheme.TextColor end
     if line then line.BackgroundColor3 = SelectedTheme.ElementStroke end
     -- Content frame is transparent
 end

 local SectionFrame = Utility.createInstance("Frame", {
     Name = "Section_" .. sectionName:gsub("%s+", "_"),
     Size = UDim2.new(1, 0, 0, 30), -- Initial size for header only
     AutomaticSize = Enum.AutomaticSize.Y, -- Automatically adjust height based on content + header
     BackgroundColor3 = SelectedTheme.SectionBackground or SelectedTheme.ElementBackground,
     ClipsDescendants = true,
     LayoutOrder = #parent:GetChildren() + 1, Parent = parent
 }, "Section", updateTheme) -- Track Section
 Utility.createCorner(SectionFrame, 4)
 Utility.createStroke(SectionFrame, SelectedTheme.ElementStroke, 1)

 -- Header Frame
 local SectionHeader = Utility.createInstance("Frame", {
     Name = "SectionHeader", Size = UDim2.new(1, 0, 0, 30),
     BackgroundColor3 = SelectedTheme.SectionHeader or SelectedTheme.ElementBackgroundHover,
     Parent = SectionFrame
 })
 -- Top corners only for header
 Utility.createCorner(SectionHeader, 4)
 local bottomFix = Utility.createInstance("Frame", { -- Cover bottom corners
     Name = "BottomFix", Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.5,0),
     BackgroundColor3 = SectionHeader.BackgroundColor3, BorderSizePixel = 0, ZIndex = 0,
     Parent = SectionHeader
 })
 -- Line below header (optional visual separator)
 local HeaderLine = Utility.createInstance("Frame", {
     Name = "Line", Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), AnchorPoint = Vector2.new(0, 1),
     BackgroundColor3 = SelectedTheme.ElementStroke, BorderSizePixel = 0, ZIndex = 1, Parent = SectionHeader
 })


 -- Collapse Arrow
 local Arrow = Utility.createInstance("ImageLabel", {
     Name = "Arrow", Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 10, 0.5, 0),
     AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://6035048680", -- Chevron down
     ImageColor3 = SelectedTheme.SubTextColor, Rotation = initiallyCollapsed and -90 or 0, Parent = SectionHeader
 })

 -- Section Label
 local SectionLabel = Utility.createInstance("TextLabel", {
     Name = "Label", Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 30, 0, 0),
     BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = sectionName, TextColor3 = SelectedTheme.TextColor,
     TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = SectionHeader
 })

 -- Content Frame (holds the actual elements)
 local SectionContent = Utility.createInstance("Frame", {
     Name = "SectionContent", Size = UDim2.new(1, 0, 0, 0), -- Starts closed or opens based on initiallyCollapsed
     AutomaticSize = Enum.AutomaticSize.Y, -- Auto Y size based on content
     Position = UDim2.new(0, 0, 0, 30), -- Positioned below header
     BackgroundTransparency = 1, ClipsDescendants = true,
     Visible = not initiallyCollapsed, -- Set initial visibility
     Parent = SectionFrame
 })
 local ContentLayout = Utility.createInstance("UIListLayout", {
     Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
     HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = SectionContent
 })
 local ContentPadding = Utility.createInstance("UIPadding", {
     PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
     PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = SectionContent
 })

 -- Toggle Logic
 local isCollapsed = initiallyCollapsed
 local contentTween = nil

 local function toggleCollapse()
     isCollapsed = not isCollapsed

     -- Stop any existing tween
     if contentTween and contentTween.PlaybackState == Enum.PlaybackState.Playing then
         contentTween:Cancel()
     end

     local targetRotation = isCollapsed and -90 or 0
     TweenService:Create(Arrow, TweenInfo.new(0.2), { Rotation = targetRotation }):Play()

     if isCollapsed then
         -- Collapse: Animate content height to 0 then hide
         SectionContent.ClipsDescendants = true -- Ensure content clips during animation
         contentTween = TweenService:Create(SectionContent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 0) })
         contentTween:Play()
         Utility.Connect(contentTween.Completed, function(state)
             if state == Enum.TweenStatus.Completed and isCollapsed then -- Check if still collapsed
                 SectionContent.Visible = false
                 SectionContent.AutomaticSize = Enum.AutomaticSize.None -- Turn off auto-size when hidden
             end
             contentTween = nil
         end)
     else
         -- Expand: Show, set auto-size, then animate height (tricky with auto-size)
         -- We might need to calculate the target height based on ContentLayout.AbsoluteContentSize
         SectionContent.Size = UDim2.new(1, 0, 0, 0) -- Reset size before making visible
         SectionContent.Visible = true
         SectionContent.AutomaticSize = Enum.AutomaticSize.Y -- Re-enable auto-size
         -- Let auto-size calculate, then maybe animate? Or just let it pop open.
         -- For simplicity, let's just let AutomaticSize handle it after making visible.
         -- A smooth animation requires calculating the final height which can be complex.
         SectionContent.ClipsDescendants = false -- Allow content to overflow if needed (though should fit)
     end
 end

 -- Header Interaction
 local HeaderInteract = Utility.createInstance("TextButton", {
     Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 2, Parent = SectionHeader
 })
 Utility.Connect(HeaderInteract.MouseButton1Click, toggleCollapse)

 -- Section API (allows adding elements to this section)
 local SectionAPI = {}
 SectionAPI.Instance = SectionFrame
 SectionAPI.Content = SectionContent -- Expose content frame
 SectionAPI.Type = "Section"
 SectionAPI.IsCollapsed = function() return isCollapsed end
 SectionAPI.Expand = function() if isCollapsed then toggleCollapse() end end
 SectionAPI.Collapse = function() if not isCollapsed then toggleCollapse() end end

 -- Replicate element creation functions, but parented to SectionContent
 local elementFunctions = { "CreateButton", "CreateToggle", "CreateSlider", "CreateDropdown", "CreateColorPicker", "CreateKeybind", "CreateTextbox", "CreateLabel", "CreateDivider", "CreateSection" }
 for _, funcName in ipairs(elementFunctions) do
     SectionAPI[funcName] = function(self, options)
         options = options or {}
         options.Parent = SectionContent -- Override parent to section's content frame
         return Tab[funcName](Tab, options) -- Call original function from Tab context
     end
 end

 Tab.Elements[SectionFrame.Name] = SectionAPI -- Store reference

 return SectionAPI
end


-- ========================================================================
-- End of Element Creation Methods
-- ========================================================================

-- Select the first tab by default if none are selected yet
if not activePage and #TabScrollFrame:GetChildren() > 0 then
 local firstTabButton
 for _, child in ipairs(TabScrollFrame:GetChildren()) do
     if child:IsA("Frame") and child:FindFirstChild("Interact") then
         firstTabButton = child
         break
     end
 end
 if firstTabButton then
     Window:SelectTab(firstTabButton.Name)
 end
end

return Tab
end -- End of Window:CreateTab

-- Function to get a specific element API by flag/name
function Window:GetElement(identifier)
-- Search through all tabs
if LuminaUI.Tabs then
 for _, tabData in pairs(LuminaUI.Tabs) do
     if tabData.Elements and tabData.Elements[identifier] then
         return tabData.Elements[identifier]
     end
     -- Check sections within the tab
     if tabData.Elements then
         for _, elementData in pairs(tabData.Elements) do
             if elementData.Type == "Section" and elementData.Content then
                 -- Need a way to search within section content recursively or store section elements better
                 -- For now, direct children of sections aren't easily searchable this way.
             end
         end
     end
 end
end
warn("LuminaUI: Element with identifier '" .. identifier .. "' not found.")
return nil
end

-- Function to get all flag values
function Window:GetFlags()
local flagValues = {}
for flag, data in pairs(LuminaUI.Flags) do
 flagValues[flag] = data.Value
end
return flagValues
end

-- Function to set a flag value programmatically
function Window:SetFlag(flag, value)
if LuminaUI.Flags[flag] then
 local elementType = LuminaUI.Flags[flag].Type
 local elementAPI = Window:GetElement(flag) -- Find the element associated with the flag

 if elementAPI and elementAPI.SetValue then
     -- Use the element's SetValue method to ensure visuals update correctly
     elementAPI:SetValue(value)
 else
     -- Fallback: Directly set the flag value (visuals might not update)
     -- Perform basic type check if possible
     local expectedType = typeof(LuminaUI.Flags[flag].Default)
     if typeof(value) == expectedType or (expectedType == "Color3" and typeof(value) == "Color3") then
          LuminaUI.Flags[flag].Value = value
          warn("LuminaUI: SetFlag used directly for '"..flag.."'. Visuals might not update without element API.")
     else
         warn("LuminaUI: Type mismatch for SetFlag '"..flag.."'. Expected "..expectedType..", got "..typeof(value)..".")
     end
 end
else
 warn("LuminaUI: Flag '" .. flag .. "' not found for SetFlag.")
end
end

-- Function to get a flag value programmatically
function Window:GetFlag(flag)
if LuminaUI.Flags[flag] then
 return LuminaUI.Flags[flag].Value
else
 warn("LuminaUI: Flag '" .. flag .. "' not found for GetFlag.")
 return nil
end
end

-- Save current configuration manually
function Window:SaveConfig()
if settings.ConfigurationSaving and settings.ConfigurationSaving.Enabled and MainFrame and MainFrame.Parent then
 Utility.saveConfig(MainFrame, settings)
 print("LuminaUI: Configuration saved manually.")
else
 warn("LuminaUI: Configuration saving is disabled or UI not available.")
end
end

-- Load configuration manually (applies flags, theme, position)
function Window:LoadConfig()
if settings.ConfigurationSaving and settings.ConfigurationSaving.Enabled then
 local loaded = Utility.loadConfig(settings)
 if loaded then
     -- Apply Theme
     if loaded.Window and loaded.Window.Theme and LuminaUI.Theme[loaded.Window.Theme] then
         LuminaUI:ApplyTheme(loaded.Window.Theme)
         settings.Theme = loaded.Window.Theme -- Update setting for consistency
     end
     -- Apply Position
     if settings.RememberPosition and loaded.Window and loaded.Window.Position and MainFrame then
         MainFrame.Position = loaded.Window.Position
     end
     -- Apply Flags
     if loaded.Elements then
         for flag, elementData in pairs(loaded.Elements) do
             Window:SetFlag(flag, elementData.Value) -- Use SetFlag to try and update visuals
         end
     end
     print("LuminaUI: Configuration loaded manually.")
 else
     warn("LuminaUI: Failed to load configuration manually.")
 end
else
 warn("LuminaUI: Configuration saving is disabled.")
end
end


-- Store reference to the window API
LuminaUI.CurrentWindow = Window

-- Return the Window API table
return Window
end -- End of LuminaUI:CreateWindow


-- Function to destroy the UI and cleanup
function LuminaUI:Destroy()
if Library and Library.Parent then
-- Save config before destroying if enabled
if LuminaUI.CurrentWindow and LuminaUI.CurrentWindow._Settings and LuminaUI.CurrentWindow._Settings.ConfigurationSaving and LuminaUI.CurrentWindow._Settings.ConfigurationSaving.Enabled then
  local mainFrame = Library:FindFirstChild("MainFrame")
  if mainFrame then
    Utility.saveConfig(mainFrame, LuminaUI.CurrentWindow._Settings)
  end
end

Utility.destroyInstance(Library) -- This handles cleanup of tracked instances and connections
Library = nil
LuminaUI.Flags = {} -- Reset flags
LuminaUI.Tabs = {} -- Reset tabs
LuminaUI._Keybinds = {} -- Reset keybinds
LuminaUI.CurrentWindow = nil -- Clear window reference

-- Disconnect global keybind listener if it exists
if LuminaUI._KeybindListener then
 LuminaUI._KeybindListener:Disconnect()
 LuminaUI._KeybindListener = nil
end
print("LuminaUI: Destroyed.")
end
end

-- Function to add or update a theme
function LuminaUI:AddTheme(themeName, themeData)
if type(themeName) ~= "string" or type(themeData) ~= "table" then
warn("LuminaUI: AddTheme requires a theme name (string) and theme data (table).")
return
end
-- Basic validation of required fields (can be expanded)
if not themeData.Background or not themeData.TextColor or not themeData.ElementBackground then
warn("LuminaUI: Theme '" .. themeName .. "' is missing required fields (Background, TextColor, ElementBackground).")
return
end
-- Merge with default theme to ensure all keys exist (optional, but good practice)
local fullTheme = Utility.deepCopy(LuminaUI.Theme.Default) -- Start with default
for key, value in pairs(themeData) do
fullTheme[key] = value -- Overwrite with provided data
end
fullTheme.Name = themeName -- Ensure name is set correctly

LuminaUI.Theme[themeName] = fullTheme
print("LuminaUI: Theme '" .. themeName .. "' added/updated.")

-- If this theme is currently selected, re-apply it
if SelectedTheme and SelectedTheme.Name == themeName then
LuminaUI:ApplyTheme(themeName)
end
end


-- Return the main library table
return LuminaUI
```-- filepath: c:\Users\micah\Downloads\lumina.lua
-- ...existing code...
    updateTheme(DropdownFrame) -- Update visuals with new selection
end
}
Tab.Elements[flag] = DropdownAPI -- Store API under flag name

return DropdownAPI
end

-- CreateColorPicker (Refactored with Theme Update)
function Tab:CreateColorPicker(options)
options = options or {}
local pickerName = options.Name or "Color Picker"
local flag = options.Flag -- Mandatory flag name
local defaultValue = options.Default or Color3.fromRGB(255, 255, 255)
local callback = options.Callback or function(value) print(pickerName .. " set to " .. tostring(value)) end
local icon = options.Icon
local tooltip = options.Tooltip
local parent = options.Parent or TabPage -- Allow overriding parent

if not flag then warn("LuminaUI: ColorPicker '" .. pickerName .. "' requires a 'Flag' option."); return end

local initialValue = registerFlag(flag, defaultValue, "ColorPicker")

local elementHeight = 36
local elementPadding = 10
local iconSize = 20
local colorPreviewSize = 24
local pickerOpen = false
local pickerFrame = nil -- Instance reference

local updateTheme = function(instance)
local colorPreview = instance:FindFirstChild("ColorPreview")
local iconLabel = instance:FindFirstChild("Icon")
local label = instance:FindFirstChild("Label")
local stroke = instance:FindFirstChildOfClass("UIStroke")

instance.BackgroundColor3 = SelectedTheme.ElementBackground
if stroke then stroke.Color = SelectedTheme.ElementStroke end
if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
if label then label.TextColor3 = SelectedTheme.TextColor end
if colorPreview then colorPreview.BackgroundColor3 = LuminaUI.Flags[flag].Value end -- Update preview color

-- Update picker theme if open
if pickerFrame and pickerFrame.Parent then
    pickerFrame.BackgroundColor3 = SelectedTheme.ElementBackground
    local pickerStroke = pickerFrame:FindFirstChildOfClass("UIStroke")
    if pickerStroke then pickerStroke.Color = SelectedTheme.ElementStroke end

    -- Update internal picker elements (saturation/value box, hue slider, etc.)
    local svBox = pickerFrame:FindFirstChild("SVBox")
    if svBox then
        local svStroke = svBox:FindFirstChildOfClass("UIStroke")
        if svStroke then svStroke.Color = SelectedTheme.ElementStroke end
        -- SV gradient doesn't change with theme, but cursor might
        local svCursor = svBox:FindFirstChild("Cursor")
        if svCursor then svCursor.BackgroundColor3 = SelectedTheme.TextColor end
    end
    local hueSlider = pickerFrame:FindFirstChild("HueSlider")
    if hueSlider then
        local hueStroke = hueSlider:FindFirstChildOfClass("UIStroke")
        if hueStroke then hueStroke.Color = SelectedTheme.ElementStroke end
        local hueCursor = hueSlider:FindFirstChild("Cursor")
        if hueCursor then hueCursor.BackgroundColor3 = SelectedTheme.TextColor end
    end
    local hexInput = pickerFrame:FindFirstChild("HexInput")
    if hexInput then
        hexInput.BackgroundColor3 = SelectedTheme.ElementBackgroundHover
        hexInput.TextColor3 = SelectedTheme.TextColor
        hexInput.PlaceholderColor3 = SelectedTheme.SubTextColor
        local hexStroke = hexInput:FindFirstChildOfClass("UIStroke")
        if hexStroke then hexStroke.Color = SelectedTheme.ElementStroke end
    end
end
end

local ColorPickerFrame = Utility.createInstance("Frame", {
Name = "ColorPicker_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #parent:GetChildren() + 1, Parent = parent, -- Use correct parent
ClipsDescendants = false -- Allow picker to show
}, "ColorPicker", updateTheme) -- Track ColorPicker
Utility.createCorner(ColorPickerFrame, 4)
local stroke = Utility.createStroke(ColorPickerFrame, SelectedTheme.ElementStroke, 1)

local textXOffset = elementPadding
if icon then
 local PickerIcon = Utility.createInstance("ImageLabel", {
     Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
     AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
     ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = ColorPickerFrame
 })
 textXOffset = elementPadding + iconSize + 8
end

-- Label
local PickerLabel = Utility.createInstance("TextLabel", {
Name = "Label", Size = UDim2.new(1, -(textXOffset + elementPadding + colorPreviewSize + 10), 1, 0), -- Adjust width for color preview
Position = UDim2.new(0, textXOffset, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
Text = pickerName, TextColor3 = SelectedTheme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = ColorPickerFrame
})

-- Color Preview Box
local ColorPreview = Utility.createInstance("Frame", {
Name = "ColorPreview", Size = UDim2.new(0, colorPreviewSize, 0, colorPreviewSize), Position = UDim2.new(1, -elementPadding, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = initialValue, BorderSizePixel = 0, Parent = ColorPickerFrame
})
Utility.createCorner(ColorPreview, 4)
Utility.createStroke(ColorPreview, SelectedTheme.ElementStroke, 1) -- Add stroke to preview

-- Interaction Button
local PickerInteract = Utility.createInstance("TextButton", {
Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 1, Parent = ColorPickerFrame
})

-- Function to toggle the color picker UI
local function toggleColorPickerUI(forceClose)
if pickerOpen and not forceClose then -- Close it
    pickerOpen = false
    if pickerFrame and pickerFrame.Parent then
        local pickerTween = TweenService:Create(pickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 })
        pickerTween:Play()
        Utility.Connect(pickerTween.Completed, function()
            Utility.destroyInstance(pickerFrame)
            pickerFrame = nil
        end)
    end
    stroke.Color = SelectedTheme.ElementStroke -- Reset stroke on close
    if tooltip then Utility.hideTooltip() end

elseif not pickerOpen and not forceClose then -- Open it
    pickerOpen = true
    stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled -- Highlight stroke when open

    local pickerHeight = 180 -- Adjust as needed
    local pickerYPos = elementHeight + 2

    -- Theme update function for the picker container
    local updatePickerContainerTheme = function(instance)
        instance.BackgroundColor3 = SelectedTheme.ElementBackground
        local pickerStroke = instance:FindFirstChildOfClass("UIStroke")
        if pickerStroke then pickerStroke.Color = SelectedTheme.ElementStroke end
        -- Internal element updates are handled by the main ColorPicker updateTheme
    end

    pickerFrame = Utility.createInstance("Frame", {
        Name = "ColorPickerUI", Size = UDim2.new(1, 0, 0, 0), -- Start height 0
        Position = UDim2.new(0, 0, 0, pickerYPos), BackgroundColor3 = SelectedTheme.ElementBackground,
        BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 100, Parent = ColorPickerFrame
    }, "ColorPickerContainer", updatePickerContainerTheme) -- Track picker container
    Utility.createCorner(pickerFrame, 4)
    Utility.createStroke(pickerFrame, SelectedTheme.ElementStroke, 1)

    local padding = 8
    local svBoxSize = pickerHeight - padding * 2 - 30 -- Leave space for hex input
    local hueSliderWidth = 20
    local hueSliderHeight = svBoxSize
    local svBoxWidth = pickerFrame.AbsoluteSize.X - padding * 3 - hueSliderWidth

    -- Saturation/Value Box
    local SVBox = Utility.createInstance("Frame", {
        Name = "SVBox", Size = UDim2.new(0, svBoxWidth, 0, svBoxSize), Position = UDim2.new(0, padding, 0, padding),
        BackgroundColor3 = Color3.new(1,1,1), -- Base color set later
        ClipsDescendants = true, Parent = pickerFrame
    })
    Utility.createCorner(SVBox, 3)
    Utility.createStroke(SVBox, SelectedTheme.ElementStroke, 1)

    local SaturationGradient = Utility.createInstance("UIGradient", { Name = "Saturation", Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(1,1,1))}), Rotation = 0, Parent = SVBox }) -- Hue sets end color
    local ValueGradient = Utility.createInstance("UIGradient", { Name = "Value", Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0,0,0,1)), ColorSequenceKeypoint.new(1, Color3.new(0,0,0,0))}), Rotation = 90, Parent = SVBox })

    local SVCursor = Utility.createInstance("Frame", {
        Name = "Cursor", Size = UDim2.new(0, 8, 0, 8), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = SelectedTheme.TextColor, BorderSizePixel = 0, ZIndex = 1, Parent = SVBox
    })
    Utility.createCorner(SVCursor, 4)
    Utility.createStroke(SVCursor, Color3.new(0,0,0), 1) -- Black stroke for visibility

    -- Hue Slider
    local HueSlider = Utility.createInstance("Frame", {
        Name = "HueSlider", Size = UDim2.new(0, hueSliderWidth, 0, hueSliderHeight), Position = UDim2.new(0, svBoxWidth + padding * 2, 0, padding),
        BackgroundColor3 = Color3.new(1,1,1), ClipsDescendants = true, Parent = pickerFrame
    })
    Utility.createCorner(HueSlider, 3)
    Utility.createStroke(HueSlider, SelectedTheme.ElementStroke, 1)

    local HueGradient = Utility.createInstance("UIGradient", {
        Name = "Hue",
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }), Rotation = 90, Parent = HueSlider
    })

    local HueCursor = Utility.createInstance("Frame", {
        Name = "Cursor", Size = UDim2.new(1, 4, 0, 4), Position = UDim2.new(0.5, 0, 0, 0), -- Y pos set later
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = SelectedTheme.TextColor, BorderSizePixel = 0, ZIndex = 1, Parent = HueSlider
    })
    Utility.createCorner(HueCursor, 2)
    Utility.createStroke(HueCursor, Color3.new(0,0,0), 1)

    -- Hex Input Box
    local HexInput = Utility.createInstance("TextBox", {
        Name = "HexInput", Size = UDim2.new(1, -padding * 2, 0, 24), Position = UDim2.new(0.5, 0, 1, -padding - 12),
        AnchorPoint = Vector2.new(0.5, 1), BackgroundColor3 = SelectedTheme.ElementBackgroundHover, BorderSizePixel = 0,
        Font = Enum.Font.GothamMono, Text = "", TextColor3 = SelectedTheme.TextColor, TextSize = 12,
        PlaceholderText = "#RRGGBB", PlaceholderColor3 = SelectedTheme.SubTextColor, ClearTextOnFocus = false, ZIndex = 1, Parent = pickerFrame
    })
    Utility.createCorner(HexInput, 3)
    Utility.createStroke(HexInput, SelectedTheme.ElementStroke, 1)

    -- Color Picker Logic
    local currentH, currentS, currentV = Color3.toHSV(LuminaUI.Flags[flag].Value)

    local function updatePickerVisuals(updateHex)
        local hueColor = Color3.fromHSV(currentH, 1, 1)
        SaturationGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, hueColor)})
        SVBox.BackgroundColor3 = hueColor -- Set background for transparency in value gradient

        SVCursor.Position = UDim2.new(currentS, 0, 1 - currentV, 0)
        HueCursor.Position = UDim2.new(0.5, 0, currentH, 0)

        local finalColor = Color3.fromHSV(currentH, currentS, currentV)
        ColorPreview.BackgroundColor3 = finalColor -- Update main preview

        if updateHex then
            HexInput.Text = Utility.colorToHex(finalColor)
        end
    end

    local function updateColorFromHSV(triggerCallback)
        local newColor = Color3.fromHSV(currentH, currentS, currentV)
        if LuminaUI.Flags[flag].Value == newColor then return end -- No change

        LuminaUI.Flags[flag].Value = newColor
        updatePickerVisuals(true) -- Update visuals and hex

        if triggerCallback then
            local success, err = pcall(callback, newColor)
            if not success then warn("LuminaUI ColorPicker Error:", err) end
        end
    end

    -- Initial setup
    updatePickerVisuals(true)

    -- Input Handling
    local svDragging = false
    local hueDragging = false

    Utility.Connect(SVBox.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
            local relPos = input.Position - SVBox.AbsolutePosition
            currentS = math.clamp(relPos.X / SVBox.AbsoluteSize.X, 0, 1)
            currentV = math.clamp(1 - (relPos.Y / SVBox.AbsoluteSize.Y), 0, 1)
            updateColorFromHSV(true)
            UserInputService.TextSelectionEnabled = false
        end
    end)
    Utility.Connect(HueSlider.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            local relPos = input.Position - HueSlider.AbsolutePosition
            currentH = math.clamp(relPos.Y / HueSlider.AbsoluteSize.Y, 0, 1)
            updateColorFromHSV(true)
            UserInputService.TextSelectionEnabled = false
        end
    end)

    Utility.Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if svDragging or hueDragging then UserInputService.TextSelectionEnabled = true end
            svDragging = false
            hueDragging = false
        end
    end)

    Utility.Connect(UserInputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if svDragging then
                local relPos = input.Position - SVBox.AbsolutePosition
                currentS = math.clamp(relPos.X / SVBox.AbsoluteSize.X, 0, 1)
                currentV = math.clamp(1 - (relPos.Y / SVBox.AbsoluteSize.Y), 0, 1)
                updateColorFromHSV(true)
            elseif hueDragging then
                local relPos = input.Position - HueSlider.AbsolutePosition
                currentH = math.clamp(relPos.Y / HueSlider.AbsoluteSize.Y, 0, 1)
                updateColorFromHSV(true)
            end
        end
    end)

    -- Hex Input Handling
    Utility.Connect(HexInput.FocusLost, function(enterPressed)
        if enterPressed then
            local hex = HexInput.Text
            local success, color = pcall(Utility.hexToColor, hex)
            if success and color then
                currentH, currentS, currentV = Color3.toHSV(color)
                updateColorFromHSV(true) -- Update everything including the hex box format
            else
                -- Revert to current color's hex if invalid input
                HexInput.Text = Utility.colorToHex(LuminaUI.Flags[flag].Value)
            end
        else
             -- Revert if focus lost without pressing enter
             HexInput.Text = Utility.colorToHex(LuminaUI.Flags[flag].Value)
        end
    end)

    -- Animate picker open
    local pickerTween = TweenService:Create(pickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, pickerHeight), BackgroundTransparency = 0 })
    pickerTween:Play()
end
end

-- Effects & Callback for main picker button
Utility.Connect(PickerInteract.MouseEnter, function()
if not pickerOpen then
    TweenService:Create(ColorPickerFrame, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackgroundHover }):Play()
    stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled
end
if tooltip then Utility.showTooltip(tooltip) end
end)
Utility.Connect(PickerInteract.MouseLeave, function()
if not pickerOpen then
    TweenService:Create(ColorPickerFrame, TweenInfo.new(0.2), { BackgroundColor3 = SelectedTheme.ElementBackground }):Play()
    stroke.Color = SelectedTheme.ElementStroke
end
if tooltip then Utility.hideTooltip() end
end)
Utility.Connect(PickerInteract.MouseButton1Click, function()
toggleColorPickerUI()
end)

-- Close picker if clicked outside
local function checkClickOutsidePicker(input)
if not pickerOpen or not pickerFrame or not pickerFrame.Parent then return end

local mousePos = input.Position
local framePos = ColorPickerFrame.AbsolutePosition
local frameSize = ColorPickerFrame.AbsoluteSize
local pickerUIPos = pickerFrame.AbsolutePosition
local pickerUISize = pickerFrame.AbsoluteSize

local inFrame = mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y
local inPickerUI = mousePos.X >= pickerUIPos.X and mousePos.X <= pickerUIPos.X + pickerUISize.X and mousePos.Y >= pickerUIPos.Y and mousePos.Y <= pickerUIPos.Y + pickerUISize.Y

if not inFrame and not inPickerUI then
    toggleColorPickerUI(true) -- Force close
end
end
local pickerClickOutsideConnection = Utility.Connect(UserInputService.InputBegan, function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
     checkClickOutsidePicker(input)
 end
end)
Utility.storeConnection(ColorPickerFrame, pickerClickOutsideConnection)

-- API to update color picker state externally
local ColorPickerAPI = {
Instance = ColorPickerFrame,
Type = "ColorPicker",
Flag = flag,
SetValue = function(newValue)
    if typeof(newValue) == "Color3" then
        LuminaUI.Flags[flag].Value = newValue
        updateTheme(ColorPickerFrame) -- Update visuals (including picker if open)
        -- If picker is open, update its internal state too
        if pickerOpen and pickerFrame and pickerFrame.Parent then
            currentH, currentS, currentV = Color3.toHSV(newValue)
            updatePickerVisuals(true)
        end
    else
        warn("LuminaUI: Invalid value type for ColorPicker SetValue. Expected Color3.")
    end
end,
GetValue = function()
    return LuminaUI.Flags[flag].Value
end
}
Tab.Elements[flag] = ColorPickerAPI -- Store API under flag name

return ColorPickerAPI
end

-- CreateKeybind (Refactored with Theme Update and Centralized Handling)
function Tab:CreateKeybind(options)
options = options or {}
local keybindName = options.Name or "Keybind"
local flag = options.Flag -- Mandatory flag name
local defaultKey = options.Default or Enum.KeyCode.None -- Default to None
local defaultModifiers = options.DefaultModifiers or { Shift = false, Ctrl = false, Alt = false }
local callback = options.Callback or function() print(keybindName .. " triggered") end
local allowUnset = options.AllowUnset == nil and true or options.AllowUnset -- Allow setting to None
local icon = options.Icon
local tooltip = options.Tooltip
local parent = options.Parent or TabPage -- Allow overriding parent

if not flag then warn("LuminaUI: Keybind '" .. keybindName .. "' requires a 'Flag' option."); return end
if not settings.KeySystem or not settings.KeySystem.Enabled then
 warn("LuminaUI: Keybind system is disabled. Keybind '" .. keybindName .. "' will not function.")
 -- Optionally create a disabled visual element or just return nil
 return nil
end

-- Register flag (stores { Key = Enum.KeyCode, Modifiers = { Shift=bool, Ctrl=bool, Alt=bool } })
local initialValue = registerFlag(flag, { Key = defaultKey, Modifiers = defaultModifiers }, "Keybind")

-- Register the keybind with the central listener
local keybindId = flag -- Use flag as unique ID
LuminaUI._Keybinds[keybindId] = {
 Key = initialValue.Key,
 Modifiers = initialValue.Modifiers,
 Callback = callback,
 Element = nil -- Will be set later
}

local elementHeight = 36
local elementPadding = 10
local iconSize = 20
local keyTextWidth = 100 -- Adjust as needed

local isListening = false -- Track if waiting for input

local updateTheme = function(instance)
local keyLabel = instance:FindFirstChild("KeyLabel")
local iconLabel = instance:FindFirstChild("Icon")
local label = instance:FindFirstChild("Label")
local stroke = instance:FindFirstChildOfClass("UIStroke")

instance.BackgroundColor3 = SelectedTheme.ElementBackground
if stroke then stroke.Color = isListening and (SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled) or SelectedTheme.ElementStroke end
if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
if label then label.TextColor3 = SelectedTheme.TextColor end
if keyLabel then
    keyLabel.BackgroundColor3 = isListening and SelectedTheme.ElementBackgroundActive or SelectedTheme.ElementBackgroundHover
    keyLabel.TextColor3 = SelectedTheme.TextColor
    local keyStroke = keyLabel:FindFirstChildOfClass("UIStroke")
    if keyStroke then keyStroke.Color = SelectedTheme.ElementStroke end
end
end

local KeybindFrame = Utility.createInstance("Frame", {
Name = "Keybind_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
}, "Keybind", updateTheme) -- Track Keybind
Utility.createCorner(KeybindFrame, 4)
local stroke = Utility.createStroke(KeybindFrame, SelectedTheme.ElementStroke, 1)

local textXOffset = elementPadding
if icon then
 local KeybindIcon = Utility.createInstance("ImageLabel", {
     Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
     AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
     ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = KeybindFrame
 })
 textXOffset = elementPadding + iconSize + 8
end

-- Label
local KeybindLabel = Utility.createInstance("TextLabel", {
Name = "Label", Size = UDim2.new(1, -(textXOffset + elementPadding + keyTextWidth + 10), 1, 0), -- Adjust width for key text
Position = UDim2.new(0, textXOffset, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham,
Text = keybindName, TextColor3 = SelectedTheme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = KeybindFrame
})

-- Key Display/Input Button
local KeyLabel = Utility.createInstance("TextButton", {
Name = "KeyLabel", Size = UDim2.new(0, keyTextWidth, 0, 24), Position = UDim2.new(1, -elementPadding, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = SelectedTheme.ElementBackgroundHover, BorderSizePixel = 0,
Font = Enum.Font.Gotham, Text = "", -- Set later
TextColor3 = SelectedTheme.TextColor, TextSize = 12, AutoButtonColor = false, Parent = KeybindFrame
})
Utility.createCorner(KeyLabel, 3)
Utility.createStroke(KeyLabel, SelectedTheme.ElementStroke, 1)

-- Function to format key display text
local function formatKeyText(keyData)
if isListening then return "..." end
if not keyData or keyData.Key == Enum.KeyCode.None then return "None" end

local parts = {}
if keyData.Modifiers.Ctrl then table.insert(parts, "Ctrl") end
if keyData.Modifiers.Alt then table.insert(parts, "Alt") end
if keyData.Modifiers.Shift then table.insert(parts, "Shift") end

local keyName = keyData.Key.Name
-- Simplify common key names
keyName = keyName:gsub("LeftControl", "Ctrl"):gsub("RightControl", "Ctrl")
keyName = keyName:gsub("LeftShift", "Shift"):gsub("RightShift", "Shift")
keyName = keyName:gsub("LeftAlt", "Alt"):gsub("RightAlt", "Alt")
keyName = keyName:gsub("PageUp", "PgUp"):gsub("PageDown", "PgDn")
keyName = keyName:gsub("MouseButton1", "M1"):gsub("MouseButton2", "M2")
-- Add more simplifications if needed

table.insert(parts, keyName)
return table.concat(parts, " + ")
end

-- Initial text update
KeyLabel.Text = formatKeyText(initialValue)

-- Input Listening Logic
local inputConnection = nil
local function stopListening(updateKeyData)
if not isListening then return end
isListening = false
if inputConnection then
    inputConnection:Disconnect()
    inputConnection = nil
end
KeyLabel.Text = formatKeyText(updateKeyData or LuminaUI.Flags[flag].Value) -- Update text with new or current key
updateTheme(KeybindFrame) -- Update visuals (stroke, background)
-- Re-enable global keybinds if they were temporarily disabled (optional)
end

local function startListening()
if isListening then return end
isListening = true
KeyLabel.Text = "..."
updateTheme(KeybindFrame) -- Update visuals

-- Temporarily disable global keybinds? (Might be complex/risky)

inputConnection = Utility.Connect(UserInputService.InputBegan, function(input, gameProcessed)
    if gameProcessed then return end -- Ignore game-processed input

    local key = input.KeyCode
    -- Ignore modifier keys themselves as the primary key
    if key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift or
       key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.RightControl or
       key == Enum.KeyCode.LeftAlt or key == Enum.KeyCode.RightAlt then
        return
    end

    -- Allow Escape to cancel/unset
    if key == Enum.KeyCode.Escape then
        if allowUnset then
            local newKeyData = { Key = Enum.KeyCode.None, Modifiers = { Shift = false, Ctrl = false, Alt = false } }
            LuminaUI.Flags[flag].Value = newKeyData
            LuminaUI._Keybinds[keybindId].Key = newKeyData.Key
            LuminaUI._Keybinds[keybindId].Modifiers = newKeyData.Modifiers
            stopListening(newKeyData)
        else
            stopListening() -- Cancel without changing
        end
        return
    end

    local modifiers = {
        Shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift),
        Ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl),
        Alt = UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
    }

    local newKeyData = { Key = key, Modifiers = modifiers }
    LuminaUI.Flags[flag].Value = newKeyData
    LuminaUI._Keybinds[keybindId].Key = newKeyData.Key
    LuminaUI._Keybinds[keybindId].Modifiers = newKeyData.Modifiers

    stopListening(newKeyData)
end)
end

-- Effects & Callback for key label button
Utility.Connect(KeyLabel.MouseButton1Click, function()
if isListening then
    stopListening() -- Cancel listening if clicked again
else
    startListening()
end
end)
-- Hover effect on main frame (only when not listening)
Utility.Connect(KeybindFrame.MouseEnter, function()
if not isListening then stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled end
if tooltip then Utility.showTooltip(tooltip) end
end)
Utility.Connect(KeybindFrame.MouseLeave, function()
if not isListening then stroke.Color = SelectedTheme.ElementStroke end
if tooltip then Utility.hideTooltip() end
end)

-- Stop listening if clicked outside
local function checkClickOutsideKeybind(input)
if not isListening then return end
local mousePos = input.Position
local framePos = KeybindFrame.AbsolutePosition
local frameSize = KeybindFrame.AbsoluteSize
if not (mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y) then
    stopListening()
end
end
local keybindClickOutsideConnection = Utility.Connect(UserInputService.InputBegan, function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
     checkClickOutsideKeybind(input)
 end
end)
Utility.storeConnection(KeybindFrame, keybindClickOutsideConnection)

-- Store element reference in central keybind data
LuminaUI._Keybinds[keybindId].Element = KeybindFrame

-- API to update keybind state externally
local KeybindAPI = {
Instance = KeybindFrame,
Type = "Keybind",
Flag = flag,
SetValue = function(newValue)
    if type(newValue) == "table" and newValue.Key and newValue.Modifiers then
        -- Basic validation
        if typeof(newValue.Key) == "EnumItem" and newValue.Key.EnumType == Enum.KeyCode and
           type(newValue.Modifiers) == "table" and type(newValue.Modifiers.Shift) == "boolean" and
           type(newValue.Modifiers.Ctrl) == "boolean" and type(newValue.Modifiers.Alt) == "boolean" then

-- ...existing code...
LuminaUI.Flags[flag].Value = newValue
LuminaUI._Keybinds[keybindId].Key = newValue.Key
LuminaUI._Keybinds[keybindId].Modifiers = newValue.Modifiers
KeyLabel.Text = formatKeyText(newValue)
if isListening then stopListening(newValue) end -- Stop listening if active
else
warn("LuminaUI: Invalid keybind data structure for Keybind SetValue.")
end
else
warn("LuminaUI: Invalid value type for Keybind SetValue. Expected { Key = Enum.KeyCode, Modifiers = { ... } }.")
end
end,
GetValue = function()
return LuminaUI.Flags[flag].Value
end
}
Tab.Elements[flag] = KeybindAPI -- Store API under flag name

return KeybindAPI
end

-- CreateTextbox (Refactored with Theme Update)
function Tab:CreateTextbox(options)
options = options or {}
local textboxName = options.Name or "Textbox"
local flag = options.Flag -- Mandatory flag name
local defaultValue = options.Default or ""
local placeholder = options.Placeholder or "Enter text..."
local clearOnFocus = options.ClearOnFocus == nil and false or options.ClearOnFocus
local multiLine = options.MultiLine or false -- New option for multi-line
local callback = options.Callback or function(value) print(textboxName .. " text: " .. value) end
local icon = options.Icon
local tooltip = options.Tooltip
local parent = options.Parent or TabPage -- Allow overriding parent

if not flag then warn("LuminaUI: Textbox '" .. textboxName .. "' requires a 'Flag' option."); return end

local initialValue = registerFlag(flag, defaultValue, "Textbox")

local elementHeight = multiLine and 80 or 36 -- Taller for multi-line
local elementPadding = 10
local iconSize = 20

local updateTheme = function(instance)
local textBox = instance:FindFirstChild("InputBox")
local iconLabel = instance:FindFirstChild("Icon")
local label = instance:FindFirstChild("Label")
local stroke = instance:FindFirstChildOfClass("UIStroke")

instance.BackgroundColor3 = SelectedTheme.ElementBackground
if stroke then stroke.Color = SelectedTheme.ElementStroke end
if iconLabel then iconLabel.ImageColor3 = SelectedTheme.TextColor end
if label then label.TextColor3 = SelectedTheme.TextColor end

if textBox then
textBox.BackgroundColor3 = SelectedTheme.ElementBackgroundHover
textBox.TextColor3 = SelectedTheme.TextColor
textBox.PlaceholderColor3 = SelectedTheme.SubTextColor
local boxStroke = textBox:FindFirstChildOfClass("UIStroke")
if boxStroke then boxStroke.Color = SelectedTheme.ElementStroke end
end
end

local TextboxFrame = Utility.createInstance("Frame", {
Name = "Textbox_" .. flag, Size = UDim2.new(1, 0, 0, elementHeight),
BackgroundColor3 = SelectedTheme.ElementBackground, LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
}, "Textbox", updateTheme) -- Track Textbox
Utility.createCorner(TextboxFrame, 4)
local stroke = Utility.createStroke(TextboxFrame, SelectedTheme.ElementStroke, 1)

local topContentHeight = 20 -- Height for icon and label if not multi-line
local boxYOffset = multiLine and topContentHeight + 5 or 0
local boxHeight = multiLine and (elementHeight - boxYOffset - elementPadding) or (elementHeight - elementPadding * 2)
local boxXOffset = elementPadding
local boxWidth = UDim.new(1, -(elementPadding * 2))

-- Icon and Label (only if multi-line, otherwise integrated)
if multiLine then
topContentHeight = 20
if icon then
local TextboxIcon = Utility.createInstance("ImageLabel", {
Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0, topContentHeight / 2),
AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = TextboxFrame
})
boxXOffset = elementPadding + iconSize + 8
end
local TextboxLabel = Utility.createInstance("TextLabel", {
Name = "Label", Size = UDim2.new(1, -(boxXOffset + elementPadding), 0, topContentHeight), Position = UDim2.new(0, boxXOffset, 0, 0),
BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = textboxName, TextColor3 = SelectedTheme.TextColor,
TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Parent = TextboxFrame
})
-- Adjust box position and size for multi-line label/icon row
boxXOffset = elementPadding
boxWidth = UDim.new(1, -(elementPadding * 2))
else
-- Single line: Integrate icon/label space into textbox positioning
topContentHeight = elementHeight -- Use full height
if icon then
local TextboxIcon = Utility.createInstance("ImageLabel", {
Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, elementPadding, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(icon),
ImageColor3 = SelectedTheme.TextColor, ScaleType = Enum.ScaleType.Fit, Parent = TextboxFrame
})
boxXOffset = elementPadding + iconSize + 8
end
boxWidth = UDim.new(1, -(boxXOffset + elementPadding))
boxYOffset = elementPadding
end


-- Input Box
local InputBox = Utility.createInstance("TextBox", {
Name = "InputBox", Size = UDim2.new(boxWidth.Scale, boxWidth.Offset, 0, boxHeight),
Position = UDim2.new(0, boxXOffset, 0, boxYOffset),
BackgroundColor3 = SelectedTheme.ElementBackgroundHover, BorderSizePixel = 0,
Font = Enum.Font.Gotham, Text = initialValue, TextColor3 = SelectedTheme.TextColor, TextSize = 13,
PlaceholderText = placeholder, PlaceholderColor3 = SelectedTheme.SubTextColor, ClearTextOnFocus = clearOnFocus,
MultiLine = multiLine, TextWrapped = multiLine, -- Enable multi-line features
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = multiLine and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center, -- Top align for multi-line
Parent = TextboxFrame
})
Utility.createCorner(InputBox, 3)
Utility.createStroke(InputBox, SelectedTheme.ElementStroke, 1)

-- Logic for updating flag and callback
local function updateValue(newValue)
if LuminaUI.Flags[flag].Value == newValue then return end -- No change
LuminaUI.Flags[flag].Value = newValue
local success, err = pcall(callback, newValue)
if not success then warn("LuminaUI Textbox Error:", err) end
end

-- Connect events
Utility.Connect(InputBox.FocusLost, function(enterPressed)
updateValue(InputBox.Text)
-- Optionally restore placeholder if text is empty?
stroke.Color = SelectedTheme.ElementStroke -- Reset main frame stroke
end)

Utility.Connect(InputBox.Focused, function()
stroke.Color = SelectedTheme.AccentColor or SelectedTheme.ToggleEnabled -- Highlight main frame stroke on focus
if tooltip then Utility.showTooltip(tooltip) end
end)
Utility.Connect(InputBox.FocusLost, function()
if tooltip then Utility.hideTooltip() end
end)

-- API to update textbox state externally
local TextboxAPI = {
Instance = TextboxFrame,
Type = "Textbox",
Flag = flag,
SetValue = function(newValue)
newValue = tostring(newValue) -- Ensure string
LuminaUI.Flags[flag].Value = newValue
InputBox.Text = newValue
end,
GetValue = function()
return LuminaUI.Flags[flag].Value
end,
Clear = function()
LuminaUI.Flags[flag].Value = ""
InputBox.Text = ""
end,
Focus = function()
InputBox:CaptureFocus()
end,
Unfocus = function()
InputBox:ReleaseFocus()
end
}
Tab.Elements[flag] = TextboxAPI -- Store API under flag name

return TextboxAPI
end

-- CreateLabel (Refactored with Theme Update)
function Tab:CreateLabel(options)
options = options or {}
local text = options.Text or "Label"
local size = options.Size or 13 -- Text size
local alignment = options.Alignment or Enum.TextXAlignment.Left
local color = options.Color -- Optional override color
local font = options.Font or Enum.Font.Gotham -- Optional override font
local parent = options.Parent or TabPage -- Allow overriding parent

local updateTheme = function(instance)
instance.TextColor3 = color or SelectedTheme.TextColor -- Use override or theme color
instance.Font = font or Enum.Font.Gotham -- Use override or theme font
end

-- Estimate height based on text size (adjust multiplier as needed)
local estimatedHeight = size * 1.5

local Label = Utility.createInstance("TextLabel", {
Name = "Label_" .. text:sub(1, 15):gsub("%s+", "_"), -- Basic unique name
Size = UDim2.new(1, 0, 0, estimatedHeight), -- Auto height might be better if possible
AutomaticSize = Enum.AutomaticSize.Y, -- Let Y size adjust automatically
BackgroundTransparency = 1,
Font = font or SelectedTheme.Font, -- Use override or theme font
Text = text,
TextColor3 = color or SelectedTheme.TextColor, -- Use override or theme color
TextSize = size,
TextWrapped = true, -- Wrap text by default
TextXAlignment = alignment,
TextYAlignment = Enum.TextYAlignment.Top, -- Align top for wrapped text
LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
}, "Label", updateTheme) -- Track Label

Tab.Elements[Label.Name] = { Instance = Label, Type = "Label" } -- Store reference

-- API (simple, mostly for updating text)
local LabelAPI = {
Instance = Label,
Type = "Label",
SetText = function(newText)
Label.Text = newText
end,
SetColor = function(newColor)
color = newColor -- Store override
Label.TextColor3 = newColor
end
}
-- No flag associated with labels usually

return LabelAPI
end

-- CreateDivider (Refactored with Theme Update)
function Tab:CreateDivider(options)
options = options or {}
local thickness = options.Thickness or 1
local color = options.Color -- Optional override color
local padding = options.Padding or 5 -- Vertical padding around divider
local parent = options.Parent or TabPage -- Allow overriding parent

local updateTheme = function(instance)
instance.BackgroundColor3 = color or SelectedTheme.ElementStroke -- Use override or theme color
end

local DividerFrame = Utility.createInstance("Frame", {
Name = "Divider",
Size = UDim2.new(1, 0, 0, thickness + padding * 2), -- Frame includes padding
BackgroundTransparency = 1, -- Frame itself is transparent
LayoutOrder = #parent:GetChildren() + 1, Parent = parent -- Use correct parent
}, "DividerContainer", function() end) -- Track container, no direct theme

local DividerLine = Utility.createInstance("Frame", {
Name = "Line",
Size = UDim2.new(1, -20, 0, thickness), -- Line has horizontal padding
Position = UDim2.new(0.5, 0, 0.5, 0), -- Centered
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = color or SelectedTheme.ElementStroke, -- Use override or theme color
BorderSizePixel = 0,
Parent = DividerFrame
}, "DividerLine", updateTheme) -- Track the line itself for theme updates
Utility.createCorner(DividerLine, thickness / 2) -- Round ends if thick enough

Tab.Elements["Divider_"..tostring(tick())] = { Instance = DividerFrame, Type = "Divider" } -- Store reference

-- API (simple, mostly for updating color/thickness)
local DividerAPI = {
Instance = DividerFrame,
Type = "Divider",
SetColor = function(newColor)
color = newColor -- Store override
DividerLine.BackgroundColor3 = newColor
end,
SetThickness = function(newThickness)
thickness = newThickness
DividerFrame.Size = UDim2.new(1, 0, 0, thickness + padding * 2)
DividerLine.Size = UDim2.new(1, -20, 0, thickness)
-- Update corner radius?
end
}

return DividerAPI
end

-- CreateSection (Container for grouping elements)
function Tab:CreateSection(options)
options = options or {}
local sectionName = options.Name or "Section"
local initiallyCollapsed = options.Collapsed or false -- Start collapsed?
local parent = options.Parent or TabPage -- Allow overriding parent

local updateTheme = function(instance)
local header = instance:FindFirstChild("SectionHeader")
local arrow = header and header:FindFirstChild("Arrow")
local label = header and header:FindFirstChild("Label")
local line = header and header:FindFirstChild("Line")
local contentFrame = instance:FindFirstChild("SectionContent")

instance.BackgroundColor3 = SelectedTheme.SectionBackground or SelectedTheme.ElementBackground -- Use specific or fallback
local stroke = instance:FindFirstChildOfClass("UIStroke")
if stroke then stroke.Color = SelectedTheme.ElementStroke end

if header then header.BackgroundColor3 = SelectedTheme.SectionHeader or SelectedTheme.ElementBackgroundHover end -- Header background
if arrow then arrow.ImageColor3 = SelectedTheme.SubTextColor end
if label then label.TextColor3 = SelectedTheme.TextColor end
if line then line.BackgroundColor3 = SelectedTheme.ElementStroke end
-- Content frame is transparent
end

local SectionFrame = Utility.createInstance("Frame", {
Name = "Section_" .. sectionName:gsub("%s+", "_"),
Size = UDim2.new(1, 0, 0, 30), -- Initial size for header only
AutomaticSize = Enum.AutomaticSize.Y, -- Automatically adjust height based on content + header
BackgroundColor3 = SelectedTheme.SectionBackground or SelectedTheme.ElementBackground,
ClipsDescendants = true,
LayoutOrder = #parent:GetChildren() + 1, Parent = parent
}, "Section", updateTheme) -- Track Section
Utility.createCorner(SectionFrame, 4)
Utility.createStroke(SectionFrame, SelectedTheme.ElementStroke, 1)

-- Header Frame
local SectionHeader = Utility.createInstance("Frame", {
Name = "SectionHeader", Size = UDim2.new(1, 0, 0, 30),
BackgroundColor3 = SelectedTheme.SectionHeader or SelectedTheme.ElementBackgroundHover,
Parent = SectionFrame
})
-- Top corners only for header
Utility.createCorner(SectionHeader, 4)
local bottomFix = Utility.createInstance("Frame", { -- Cover bottom corners
Name = "BottomFix", Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.5,0),
BackgroundColor3 = SectionHeader.BackgroundColor3, BorderSizePixel = 0, ZIndex = 0,
Parent = SectionHeader
})
-- Line below header (optional visual separator)
local HeaderLine = Utility.createInstance("Frame", {
Name = "Line", Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), AnchorPoint = Vector2.new(0, 1),
BackgroundColor3 = SelectedTheme.ElementStroke, BorderSizePixel = 0, ZIndex = 1, Parent = SectionHeader
})


-- Collapse Arrow
local Arrow = Utility.createInstance("ImageLabel", {
Name = "Arrow", Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 10, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://6035048680", -- Chevron down
ImageColor3 = SelectedTheme.SubTextColor, Rotation = initiallyCollapsed and -90 or 0, Parent = SectionHeader
})

-- Section Label
local SectionLabel = Utility.createInstance("TextLabel", {
Name = "Label", Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 30, 0, 0),
BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = sectionName, TextColor3 = SelectedTheme.TextColor,
TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = SectionHeader
})

-- Content Frame (holds the actual elements)
local SectionContent = Utility.createInstance("Frame", {
Name = "SectionContent", Size = UDim2.new(1, 0, 0, 0), -- Starts closed or opens based on initiallyCollapsed
AutomaticSize = Enum.AutomaticSize.Y, -- Auto Y size based on content
Position = UDim2.new(0, 0, 0, 30), -- Positioned below header
BackgroundTransparency = 1, ClipsDescendants = true,
Visible = not initiallyCollapsed, -- Set initial visibility
Parent = SectionFrame
})
local ContentLayout = Utility.createInstance("UIListLayout", {
Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = SectionContent
})
local ContentPadding = Utility.createInstance("UIPadding", {
PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = SectionContent
})

-- Toggle Logic
local isCollapsed = initiallyCollapsed
local contentTween = nil

local function toggleCollapse()
isCollapsed = not isCollapsed

-- Stop any existing tween
if contentTween and contentTween.PlaybackState == Enum.PlaybackState.Playing then
contentTween:Cancel()
end

local targetRotation = isCollapsed and -90 or 0
TweenService:Create(Arrow, TweenInfo.new(0.2), { Rotation = targetRotation }):Play()

if isCollapsed then
-- Collapse: Animate content height to 0 then hide
SectionContent.ClipsDescendants = true -- Ensure content clips during animation
contentTween = TweenService:Create(SectionContent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 0) })
contentTween:Play()
Utility.Connect(contentTween.Completed, function(state)
 if state == Enum.TweenStatus.Completed and isCollapsed then -- Check if still collapsed
     SectionContent.Visible = false
     SectionContent.AutomaticSize = Enum.AutomaticSize.None -- Turn off auto-size when hidden
 end
 contentTween = nil
end)
else
-- Expand: Show, set auto-size, then animate height (tricky with auto-size)
-- We might need to calculate the target height based on ContentLayout.AbsoluteContentSize
SectionContent.Size = UDim2.new(1, 0, 0, 0) -- Reset size before making visible
SectionContent.Visible = true
SectionContent.AutomaticSize = Enum.AutomaticSize.Y -- Re-enable auto-size
-- Let auto-size calculate, then maybe animate? Or just let it pop open.
-- For simplicity, let's just let AutomaticSize handle it after making visible.
-- A smooth animation requires calculating the final height which can be complex.
SectionContent.ClipsDescendants = false -- Allow content to overflow if needed (though should fit)
end
end

-- Header Interaction
local HeaderInteract = Utility.createInstance("TextButton", {
Name = "Interact", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 2, Parent = SectionHeader
})
Utility.Connect(HeaderInteract.MouseButton1Click, toggleCollapse)

-- Section API (allows adding elements to this section)
local SectionAPI = {}
SectionAPI.Instance = SectionFrame
SectionAPI.Content = SectionContent -- Expose content frame
SectionAPI.Type = "Section"
SectionAPI.IsCollapsed = function() return isCollapsed end
SectionAPI.Expand = function() if isCollapsed then toggleCollapse() end end
SectionAPI.Collapse = function() if not isCollapsed then toggleCollapse() end end

-- Replicate element creation functions, but parented to SectionContent
local elementFunctions = { "CreateButton", "CreateToggle", "CreateSlider", "CreateDropdown", "CreateColorPicker", "CreateKeybind", "CreateTextbox", "CreateLabel", "CreateDivider", "CreateSection" }
for _, funcName in ipairs(elementFunctions) do
SectionAPI[funcName] = function(self, options)
options = options or {}
options.Parent = SectionContent -- Override parent to section's content frame
return Tab[funcName](Tab, options) -- Call original function from Tab context
end
end

Tab.Elements[SectionFrame.Name] = SectionAPI -- Store reference

return SectionAPI
end


-- ========================================================================
-- End of Element Creation Methods
-- ========================================================================

-- Select the first tab by default if none are selected yet
if not activePage and #TabScrollFrame:GetChildren() > 0 then
local firstTabButton
for _, child in ipairs(TabScrollFrame:GetChildren()) do
if child:IsA("Frame") and child:FindFirstChild("Interact") then
firstTabButton = child
break
end
end
if firstTabButton then
Window:SelectTab(firstTabButton.Name)
end
end

return Tab
end -- End of Window:CreateTab

-- Function to get a specific element API by flag/name
function Window:GetElement(identifier)
-- Search through all tabs
if LuminaUI.Tabs then
for _, tabData in pairs(LuminaUI.Tabs) do
if tabData.Elements and tabData.Elements[identifier] then
return tabData.Elements[identifier]
end
-- Check sections within the tab
if tabData.Elements then
for _, elementData in pairs(tabData.Elements) do
 if elementData.Type == "Section" and elementData.Content then
     -- Need a way to search within section content recursively or store section elements better
     -- For now, direct children of sections aren't easily searchable this way.
 end
end
end
end
end
warn("LuminaUI: Element with identifier '" .. identifier .. "' not found.")
return nil
end

-- Function to get all flag values
function Window:GetFlags()
local flagValues = {}
for flag, data in pairs(LuminaUI.Flags) do
flagValues[flag] = data.Value
end
return flagValues
end

-- Function to set a flag value programmatically
function Window:SetFlag(flag, value)
if LuminaUI.Flags[flag] then
local elementType = LuminaUI.Flags[flag].Type
local elementAPI = Window:GetElement(flag) -- Find the element associated with the flag

if elementAPI and elementAPI.SetValue then
-- Use the element's SetValue method to ensure visuals update correctly
elementAPI:SetValue(value)
else
-- Fallback: Directly set the flag value (visuals might not update)
-- Perform basic type check if possible
local expectedType = typeof(LuminaUI.Flags[flag].Default)
if typeof(value) == expectedType or (expectedType == "Color3" and typeof(value) == "Color3") then
LuminaUI.Flags[flag].Value = value
warn("LuminaUI: SetFlag used directly for '"..flag.."'. Visuals might not update without element API.")
else
warn("LuminaUI: Type mismatch for SetFlag '"..flag.."'. Expected "..expectedType..", got "..typeof(value)..".")
end
end
else
warn("LuminaUI: Flag '" .. flag .. "' not found for SetFlag.")
end
end

-- Function to get a flag value programmatically
function Window:GetFlag(flag)
if LuminaUI.Flags[flag] then
return LuminaUI.Flags[flag].Value
else
warn("LuminaUI: Flag '" .. flag .. "' not found for GetFlag.")
return nil
end
end

-- Save current configuration manually
function Window:SaveConfig()
if settings.ConfigurationSaving and settings.ConfigurationSaving.Enabled and MainFrame and MainFrame.Parent then
Utility.saveConfig(MainFrame, settings)
print("LuminaUI: Configuration saved manually.")
else
warn("LuminaUI: Configuration saving is disabled or UI not available.")
end
end

-- Load configuration manually (applies flags, theme, position)
function Window:LoadConfig()
if settings.ConfigurationSaving and settings.ConfigurationSaving.Enabled then
local loaded = Utility.loadConfig(settings)
if loaded then
-- Apply Theme
if loaded.Window and loaded.Window.Theme and LuminaUI.Theme[loaded.Window.Theme] then
LuminaUI:ApplyTheme(loaded.Window.Theme)
settings.Theme = loaded.Window.Theme -- Update setting for consistency
end
-- Apply Position
if settings.RememberPosition and loaded.Window and loaded.Window.Position and MainFrame then
MainFrame.Position = loaded.Window.Position
end
-- Apply Flags
if loaded.Elements then
for flag, elementData in pairs(loaded.Elements) do
 Window:SetFlag(flag, elementData.Value) -- Use SetFlag to try and update visuals
end
end
print("LuminaUI: Configuration loaded manually.")
else
warn("LuminaUI: Failed to load configuration manually.")
end
else
warn("LuminaUI: Configuration saving is disabled.")
end
end


-- Store reference to the window API
LuminaUI.CurrentWindow = Window

-- Return the Window API table
return Window
end -- End of LuminaUI:CreateWindow


-- Function to destroy the UI and cleanup
function LuminaUI:Destroy()
if Library and Library.Parent then
-- Save config before destroying if enabled
if LuminaUI.CurrentWindow and LuminaUI.CurrentWindow._Settings and LuminaUI.CurrentWindow._Settings.ConfigurationSaving and LuminaUI.CurrentWindow._Settings.ConfigurationSaving.Enabled then
local mainFrame = Library:FindFirstChild("MainFrame")
if mainFrame then
Utility.saveConfig(mainFrame, LuminaUI.CurrentWindow._Settings)
end
end

Utility.destroyInstance(Library) -- This handles cleanup of tracked instances and connections
Library = nil
LuminaUI.Flags = {} -- Reset flags
LuminaUI.Tabs = {} -- Reset tabs
LuminaUI._Keybinds = {} -- Reset keybinds
LuminaUI.CurrentWindow = nil -- Clear window reference

-- Disconnect global keybind listener if it exists
if LuminaUI._KeybindListener then
LuminaUI._KeybindListener:Disconnect()
LuminaUI._KeybindListener = nil
end
print("LuminaUI: Destroyed.")
end
end

-- Function to add or update a theme
function LuminaUI:AddTheme(themeName, themeData)
if type(themeName) ~= "string" or type(themeData) ~= "table" then
warn("LuminaUI: AddTheme requires a theme name (string) and theme data (table).")
return
end
-- Basic validation of required fields (can be expanded)
if not themeData.Background or not themeData.TextColor or not themeData.ElementBackground then
warn("LuminaUI: Theme '" .. themeName .. "' is missing required fields (Background, TextColor, ElementBackground).")
return
end
-- Merge with default theme to ensure all keys exist (optional, but good practice)
local fullTheme = Utility.deepCopy(LuminaUI.Theme.Default) -- Start with default
for key, value in pairs(themeData) do
fullTheme[key] = value -- Overwrite with provided data
end
fullTheme.Name = themeName -- Ensure name is set correctly

LuminaUI.Theme[themeName] = fullTheme
print("LuminaUI: Theme '" .. themeName .. "' added/updated.")

-- If this theme is currently selected, re-apply it
if SelectedTheme and SelectedTheme.Name == themeName then
LuminaUI:ApplyTheme(themeName)
end
end


-- Return the main library table
return LuminaUI
