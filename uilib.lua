-- Starlight UI Library - Foundation
-- Version 0.1

--[[ Services ]]--
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService") -- For inset information

--[[ Library Object ]]--
local Starlight = {}
Starlight.__index = Starlight
Starlight.Elements = {} -- Registry for created elements if needed later
Starlight.ActiveWindows = {} -- Track active windows

--[[ Default Space Theme ]]--
Starlight.Theme = {
    Name = "Nebula",

    -- Colors (Deep space blues, purples, neon accents)
    Background = Color3.fromRGB(15, 15, 30),       -- Very dark blue/purple
    Primary = Color3.fromRGB(120, 100, 220),     -- Vibrant purple for interaction
    Secondary = Color3.fromRGB(30, 30, 55),       -- Darker element background
    Accent = Color3.fromRGB(0, 200, 255),       -- Bright cyan/blue accent
    Accent2 = Color3.fromRGB(200, 0, 255),      -- Bright magenta accent (optional)
    Text = Color3.fromRGB(220, 220, 255),       -- Off-white / very light lavender
    TextSecondary = Color3.fromRGB(160, 160, 190), -- Dimmer text for descriptions
    TextDisabled = Color3.fromRGB(100, 100, 120),
    Hover = Color3.fromRGB(45, 45, 75),         -- Hover background
    Click = Color3.fromRGB(60, 60, 95),         -- Click feedback background
    Stroke = Color3.fromRGB(60, 60, 90),         -- Subtle border/stroke
    StrokeHighlight = Color3.fromRGB(0, 200, 255), -- Accent stroke on hover/focus
    Error = Color3.fromRGB(255, 80, 80),
    Warning = Color3.fromRGB(255, 180, 80),
    Success = Color3.fromRGB(80, 255, 120),

    -- Fonts (Consider futuristic/clean fonts)
    Font = Enum.Font.SourceSans,
    FontBold = Enum.Font.SourceSansBold,
    FontTitle = Enum.Font.SourceSansSemibold, -- Or a distinct title font

    -- Sizes & Padding
    TextSize = 14,
    TextSizeSmall = 12,
    TextSizeTitle = 18,
    Padding = UDim.new(0, 8),
    SmallPadding = UDim.new(0, 4),
    ElementHeight = 36,
    TitleBarHeight = 32,

    -- Rounding
    CornerRadius = UDim.new(0, 6),
    SmallCornerRadius = UDim.new(0, 3),

    -- Icons (Placeholders - Use Asset IDs)
    Icons = {
        DefaultTab = "rbxassetid://6031069821", -- Example: Gear icon
        Close = "rbxassetid://5108077919", -- Example: Close X
        Minimize = "rbxassetid://5108077471", -- Example: Minimize line
        Maximize = "rbxassetid://5108077600", -- Example: Maximize square
        Settings = "rbxassetid://6031069821", -- Example: Gear
        Search = "rbxassetid://6031069821", -- Example: Magnifying glass
        DropdownArrow = "rbxassetid://6031069821", -- Example: Chevron down
        ToggleOn = "rbxassetid://6031069821", -- Example: Checkmark
        ToggleOff = "rbxassetid://6031069821", -- Example: Empty circle
        Info = "rbxassetid://6031069821",
        Warning = "rbxassetid://6031069821",
        Error = "rbxassetid://6031069821",
    },

    -- Animations
    AnimationSpeed = 0.25, -- Base speed for tweens
    EasingStyle = Enum.EasingStyle.Quart, -- Smooth easing
    EasingDirection = Enum.EasingDirection.Out,
}

--[[ Internal Helper Functions ]]--

-- Creates a standard tween info object
local function CreateTweenInfo(speedOverride)
    return TweenInfo.new(
        speedOverride or Starlight.Theme.AnimationSpeed,
        Starlight.Theme.EasingStyle,
        Starlight.Theme.EasingDirection
    )
end

-- Creates and plays a tween
local function PlayTween(object, propertyTable, speedOverride)
    local tweenInfo = CreateTweenInfo(speedOverride)
    local tween = TweenService:Create(object, tweenInfo, propertyTable)
    tween:Play()
    return tween
end

-- Applies basic theme properties (can be expanded)
local function ApplyThemeStyle(guiObject, elementType)
    -- Find or create UICorner
    local corner = guiObject:FindFirstChildWhichIsA("UICorner")
    if not corner and elementType ~= "Window" and elementType ~= "TitleBar" then -- Avoid double-creating for window/title if created explicitly
        corner = Instance.new("UICorner")
        corner.Parent = guiObject
    end
    -- Apply corner radius if corner exists
    if corner then
        corner.CornerRadius = Starlight.Theme.CornerRadius -- Default radius
    end

    -- Find or create UIStroke
    local stroke = guiObject:FindFirstChildWhichIsA("UIStroke")
    if not stroke and elementType ~= "Window" and elementType ~= "TitleBar" and elementType ~= "TabButton" then -- Avoid double strokes
        stroke = Instance.new("UIStroke")
        stroke.Parent = guiObject
    end
    -- Apply stroke style if stroke exists
    if stroke then
        stroke.Color = Starlight.Theme.Stroke
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end

    -- Apply text styles
    if guiObject:IsA("TextLabel") or guiObject:IsA("TextButton") or guiObject:IsA("TextBox") then
        guiObject.Font = Starlight.Theme.Font
        guiObject.TextColor3 = Starlight.Theme.Text
        guiObject.TextSize = Starlight.Theme.TextSize
        guiObject.TextWrapped = true -- Default to wrapped
        guiObject.TextXAlignment = Enum.TextXAlignment.Left
        guiObject.TextYAlignment = Enum.TextYAlignment.Center
    end

    -- Specific element type styling
    if elementType == "Window" then
        guiObject.BackgroundColor3 = Starlight.Theme.Background
        guiObject.BorderSizePixel = 0
        -- Ensure window corner radius is set (corner should exist now)
        local windowCorner = guiObject:FindFirstChildWhichIsA("UICorner")
        if windowCorner then
             windowCorner.CornerRadius = Starlight.Theme.CornerRadius -- Ensure main window radius
        end
    elseif elementType == "TitleBar" then
        guiObject.BackgroundColor3 = Starlight.Theme.Secondary -- Slightly different title bar
        guiObject.BorderSizePixel = 0
        -- Title bar doesn't usually need its own corner if window has one and ClipsDescendants=true
        local titleCorner = guiObject:FindFirstChildWhichIsA("UICorner")
        if titleCorner then titleCorner:Destroy() end -- Remove if exists
        local titleStroke = guiObject:FindFirstChildWhichIsA("UIStroke")
        if titleStroke then titleStroke:Destroy() end -- Remove if exists
    elseif elementType == "Button" then
        guiObject.BackgroundColor3 = Starlight.Theme.Primary
        guiObject.TextColor3 = Starlight.Theme.Text -- Ensure text is readable on primary
        -- Ensure buttons don't get a stroke from the universal logic
        local btnStroke = guiObject:FindFirstChildWhichIsA("UIStroke")
        if btnStroke then btnStroke:Destroy() end
        -- Ensure button corner uses main radius
        local btnCorner = guiObject:FindFirstChildWhichIsA("UICorner")
        if btnCorner then btnCorner.CornerRadius = Starlight.Theme.CornerRadius end

    elseif elementType == "TabButton" then
         guiObject.BackgroundColor3 = Starlight.Theme.Secondary
         guiObject.BorderSizePixel = 0
         -- Ensure tab button corner uses small radius
         local tabCorner = guiObject:FindFirstChildWhichIsA("UICorner")
         if tabCorner then tabCorner.CornerRadius = Starlight.Theme.SmallCornerRadius end
         -- Hide stroke by default
         local tabStroke = guiObject:FindFirstChildWhichIsA("UIStroke")
         if tabStroke then tabStroke.Transparency = 1 end
    elseif elementType == "TabContent" then
         guiObject.BackgroundColor3 = Starlight.Theme.Background -- Match window background
         guiObject.BorderSizePixel = 0
         -- Content frame shouldn't need corner/stroke usually
         local contentCorner = guiObject:FindFirstChildWhichIsA("UICorner")
         if contentCorner then contentCorner:Destroy() end
         local contentStroke = guiObject:FindFirstChildWhichIsA("UIStroke")
         if contentStroke then contentStroke:Destroy() end
    elseif elementType == "ListFrame" then -- Style for dropdown list
        guiObject.BackgroundColor3 = Starlight.Theme.Secondary
        local listCorner = guiObject:FindFirstChildWhichIsA("UICorner") or Instance.new("UICorner")
        listCorner.CornerRadius = Starlight.Theme.SmallCornerRadius
        listCorner.Parent = guiObject
        local listStroke = guiObject:FindFirstChildWhichIsA("UIStroke") or Instance.new("UIStroke")
        listStroke.Color = Starlight.Theme.Stroke
        listStroke.Thickness = 1
        listStroke.Parent = guiObject
    elseif elementType == "DropdownOption" then -- Style for dropdown options
        guiObject.Font = Starlight.Theme.Font
        guiObject.TextSize = Starlight.Theme.TextSizeSmall
        guiObject.TextColor3 = Starlight.Theme.Text
        -- No corner or stroke needed usually
        local ddOptCorner = guiObject:FindFirstChildWhichIsA("UICorner")
        if ddOptCorner then ddOptCorner:Destroy() end
        local ddOptStroke = guiObject:FindFirstChildWhichIsA("UIStroke")
        if ddOptStroke then ddOptStroke:Destroy() end
    elseif elementType == "Label" then -- Basic label styling
        guiObject.BackgroundTransparency = 1
        guiObject.TextColor3 = Starlight.Theme.TextSecondary
        guiObject.TextXAlignment = Enum.TextXAlignment.Left
        guiObject.TextYAlignment = Enum.TextYAlignment.Center
    end
end

--[[ Window ]]--
function Starlight:CreateWindow(config)
    -- config = { Title = "Starlight UI", Size = UDim2.new(0, 550, 0, 400), Position = nil, Draggable = true, StartVisible = true, ShowTopbar = true, TopbarHeight = 32, MinSize = UDim2.new(0, 300, 0, 200) }

    local window = {}
    setmetatable(window, Starlight) -- Inherit library methods

    -- Configuration Defaults
    config.Title = config.Title or "Starlight UI"
    config.Size = config.Size or UDim2.new(0, 550, 0, 400)
    config.Draggable = config.Draggable ~= false -- Default true
    config.StartVisible = config.StartVisible ~= false -- Default true
    config.ShowTopbar = config.ShowTopbar ~= false -- Default true
    config.TopbarHeight = config.TopbarHeight or Starlight.Theme.TitleBarHeight
    config.MinSize = config.MinSize or UDim2.new(0, 300, 0, 200)

    -- State Variables
    window.Visible = false -- Will be set by Show/Hide
    window.IsDragging = false
    window.DragStart = nil
    window.StartPos = nil
    window.Tabs = {}
    window.ActiveTab = nil
    window.Elements = {} -- Elements specific to this window instance

    -- Create Core GUI Objects
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.Title:gsub("%s+", "") .. "UI" -- Remove spaces for name
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 1000 -- High display order

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = config.Size
    mainFrame.Position = config.Position or UDim2.new(0.5, -config.Size.X.Offset / 2, 0.5, -config.Size.Y.Offset / 2)
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false -- Controlled by Show/Hide
    mainFrame.AnchorPoint = Vector2.new(0, 0) -- Default top-left anchor
    mainFrame.Parent = screenGui

    window.MainWindow = mainFrame

    -- Explicitly create the main frame's UICorner early
    local mainCorner = Instance.new("UICorner")
    mainCorner.Name = "UICorner" -- Explicitly name it if needed, though FindFirstChildWhichIsA is better
    mainCorner.Parent = mainFrame

    -- Apply Theme Style (Corner, Stroke) - Still deferred for other styles
    task.defer(ApplyThemeStyle, mainFrame, "Window")

    -- Shadow (Optional, simple inset shadow)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 4, 1, 4) -- Slightly larger
    shadow.Position = UDim2.new(0, -2, 0, -2) -- Offset slightly
    shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadow.BackgroundTransparency = 0.75
    shadow.ZIndex = mainFrame.ZIndex - 1
    shadow.Parent = mainFrame
    local shadowCorner = Instance.new("UICorner")
    -- Use theme's corner radius directly + offset
    shadowCorner.CornerRadius = UDim.new(Starlight.Theme.CornerRadius.Scale, Starlight.Theme.CornerRadius.Offset + 2) -- Line 229 area
    shadowCorner.Parent = shadow

    -- Top Bar (Optional)
    local topBar
    if config.ShowTopbar then
        topBar = Instance.new("Frame")
        topBar.Name = "TitleBar"
        topBar.Size = UDim2.new(1, 0, 0, config.TopbarHeight)
        topBar.LayoutOrder = -1 -- Ensure it's above content
        topBar.Parent = mainFrame
        task.defer(ApplyThemeStyle, topBar, "TitleBar") -- Defer topBar styling

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "TitleLabel"
        titleLabel.Size = UDim2.new(1, -80, 1, 0) -- Leave space for buttons
        titleLabel.Position = UDim2.new(0, Starlight.Theme.Padding.Offset, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Starlight.Theme.FontTitle
        titleLabel.TextSize = Starlight.Theme.TextSizeTitle
        titleLabel.TextColor3 = Starlight.Theme.Text
        titleLabel.Text = config.Title
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = topBar

        -- Close Button (Example)
        local closeButton = Instance.new("ImageButton")
        closeButton.Name = "CloseButton"
        closeButton.Size = UDim2.new(0, config.TopbarHeight - 8, 0, config.TopbarHeight - 8)
        closeButton.Position = UDim2.new(1, -config.TopbarHeight + 4, 0.5, -(config.TopbarHeight - 8)/2)
        closeButton.BackgroundTransparency = 1
        closeButton.Image = Starlight.Theme.Icons.Close
        closeButton.ImageColor3 = Starlight.Theme.TextSecondary
        closeButton.Parent = topBar

        closeButton.MouseEnter:Connect(function() PlayTween(closeButton, { ImageColor3 = Starlight.Theme.Error }, 0.1) end)
        closeButton.MouseLeave:Connect(function() PlayTween(closeButton, { ImageColor3 = Starlight.Theme.TextSecondary }, 0.1) end)
        closeButton.MouseButton1Click:Connect(function() window:Hide() end)

        -- Dragging Logic
        if config.Draggable then
            topBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if window.Visible then -- Only allow dragging if visible
                        window.IsDragging = true
                        window.DragStart = input.Position
                        window.StartPos = mainFrame.Position
                        local connection
                        connection = input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                window.IsDragging = false
                                window.DragStart = nil
                                window.StartPos = nil
                                if connection then connection:Disconnect() end
                            end
                        end)
                    end
                end
            end)

            UserInputService.InputChanged:Connect(function(input) -- Use UserInputService for smoother dragging
                if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and window.IsDragging and window.DragStart then
                    local delta = input.Position - window.DragStart
                    local newPos = UDim2.new(window.StartPos.X.Scale, window.StartPos.X.Offset + delta.X,
                                             window.StartPos.Y.Scale, window.StartPos.Y.Offset + delta.Y)

                    -- Clamp position to screen bounds (basic example)
                    local viewportSize = workspace.CurrentCamera.ViewportSize
                    local guiInset = GuiService:GetGuiInset()
                    local absSize = mainFrame.AbsoluteSize
                    newPos = UDim2.new(
                        newPos.X.Scale, math.clamp(newPos.X.Offset, -absSize.X + 50, viewportSize.X - 50), -- Allow slight offscreen
                        newPos.Y.Scale, math.clamp(newPos.Y.Offset, guiInset.Y, viewportSize.Y - guiInset.Y - absSize.Y) -- Respect top bar inset
                    )
                    mainFrame.Position = newPos
                end
            end)
        end
    end

    -- Tab Bar Area
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 40) -- Example height
    tabBar.Position = UDim2.new(0, 0, config.ShowTopbar and config.TopbarHeight or 0, 0)
    tabBar.BackgroundTransparency = 1 -- Transparent background, relies on mainFrame
    tabBar.Parent = mainFrame

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.VerticalAlignment = Enum.VerticalAlignment.Center
    tabList.Padding = Starlight.Theme.SmallPadding
    tabList.Parent = tabBar

    -- Content Area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -(config.ShowTopbar and config.TopbarHeight or 0) - tabBar.Size.Y.Offset)
    contentFrame.Position = UDim2.new(0, 0, 0, tabBar.Position.Y.Offset + tabBar.Size.Y.Offset)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = mainFrame

    local pageLayout = Instance.new("UIPageLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.TweenTime = Starlight.Theme.AnimationSpeed * 1.5 -- Slightly longer tween for page transitions
    pageLayout.EasingStyle = Starlight.Theme.EasingStyle
    pageLayout.EasingDirection = Starlight.Theme.EasingDirection
    pageLayout.Parent = contentFrame

    -- Assign GUI References to window object
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.Shadow = shadow
    window.TitleBar = topBar
    window.TabBar = tabBar
    window.TabListLayout = tabList
    window.ContentFrame = contentFrame
    window.PageLayout = pageLayout

    -- Methods
    function window:Show()
        if self.Visible then return end
        self.Visible = true
        self.ScreenGui.Enabled = true -- Enable the whole ScreenGui
        self.MainFrame.Visible = true

        -- Animation: Fade In + Scale Up from center
        self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center temporarily
        -- Multiply components individually
        self.MainFrame.Size = UDim2.new(config.Size.X.Scale * 0.9, config.Size.X.Offset * 0.9, config.Size.Y.Scale * 0.9, config.Size.Y.Offset * 0.9)
        self.MainFrame.Transparency = 1
        self.Shadow.BackgroundTransparency = 1

        PlayTween(self.MainFrame, {
            Transparency = 0,
            Size = config.Size,
            Position = config.Position or UDim2.new(0.5, -config.Size.X.Offset / 2, 0.5, -config.Size.Y.Offset / 2), -- Restore original position
            AnchorPoint = Vector2.new(0, 0) -- Restore anchor point
        })
        PlayTween(self.Shadow, { BackgroundTransparency = 0.75 })
    end

    function window:Hide()
        if not self.Visible then return end
        self.Visible = false

        -- Animation: Fade Out + Scale Down to center
        self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Center anchor for scaling
        local currentPos = self.MainFrame.AbsolutePosition + self.MainFrame.AbsoluteSize * 0.5
        local currentPosUDim = UDim2.fromOffset(currentPos.X, currentPos.Y)

        local hideTween = PlayTween(self.MainFrame, {
            Transparency = 1,
            -- Multiply components individually
            Size = UDim2.new(config.Size.X.Scale * 0.9, config.Size.X.Offset * 0.9, config.Size.Y.Scale * 0.9, config.Size.Y.Offset * 0.9),
            Position = currentPosUDim -- Stay centered while scaling
        })
        PlayTween(self.Shadow, { BackgroundTransparency = 1 })

        hideTween.Completed:Connect(function()
            if not self.Visible then -- Check again in case shown during animation
                self.MainFrame.Visible = false
                self.ScreenGui.Enabled = false -- Disable ScreenGui when fully hidden
                -- Reset properties for next show
                self.MainFrame.Size = config.Size
                self.MainFrame.Position = config.Position or UDim2.new(0.5, -config.Size.X.Offset / 2, 0.5, -config.Size.Y.Offset / 2)
                self.MainFrame.AnchorPoint = Vector2.new(0, 0)
            end
        end)
    end

    function window:Toggle()
        if self.Visible then self:Hide() else self:Show() end
    end

    function window:Destroy()
        self:Hide() -- Animate out first
        task.wait(Starlight.Theme.AnimationSpeed + 0.1) -- Wait for animation
        if self.ScreenGui then self.ScreenGui:Destroy() end
        -- Clean up references
        Starlight.ActiveWindows[self] = nil
        for k in pairs(self) do self[k] = nil end
        print("Starlight: Window destroyed.")
    end

    function window:AddTab(title, iconAsset)
        local tab = {}
        local tabOrder = #self.Tabs + 1

        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = title:gsub("%s+", "") .. "TabButton"
        tabButton.Size = UDim2.new(0, 100, 1, -Starlight.Theme.SmallPadding.Offset * 2) -- Auto width based on text later?
        tabButton.Text = "  " .. title -- Padding for icon
        tabButton.LayoutOrder = tabOrder
        tabButton.AutoButtonColor = false
        tabButton.Parent = self.TabBar
        ApplyThemeStyle(tabButton, "TabButton")
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.TextColor3 = Starlight.Theme.TextSecondary -- Dimmer when inactive

        local tabIcon = CreateIcon(iconAsset or Starlight.Theme.Icons.DefaultTab, tabButton, UDim2.new(0, 18, 0, 18), UDim2.new(0, Starlight.Theme.SmallPadding.Offset * 2, 0.5, -9), Starlight.Theme.TextSecondary)

        -- Tab Content Page
        local contentPage = Instance.new("ScrollingFrame") -- Use ScrollingFrame for content
        contentPage.Name = title:gsub("%s+", "") .. "Content"
        contentPage.Size = UDim2.new(1, 0, 1, 0)
        contentPage.BackgroundTransparency = 1
        contentPage.BorderSizePixel = 0
        contentPage.LayoutOrder = tabOrder
        contentPage.ScrollBarThickness = 6
        contentPage.ScrollBarImageColor3 = Starlight.Theme.Accent
        contentPage.ScrollingDirection = Enum.ScrollingDirection.Y
        contentPage.CanvasSize = UDim2.new(0,0,0,0) -- Auto-sized by layout
        contentPage.Parent = self.ContentFrame

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = Starlight.Theme.Padding
        contentLayout.Parent = contentPage
        -- Auto-canvas size
        contentLayout.Changed:Connect(function()
            contentPage.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
        end)

        -- Tab Object
        tab.Title = title
        tab.Button = tabButton
        tab.Icon = tabIcon
        tab.ContentPage = contentPage
        tab.ContentLayout = contentLayout
        tab.IsActive = false
        tab.Elements = {} -- Elements specific to this tab

        -- Add methods to the tab object (closures)
        function tab:AddButton(btnConfig) return Starlight:_CreateButton(self, btnConfig) end
        function tab:AddToggle(tglConfig) return Starlight:_CreateToggle(self, tglConfig) end
        function tab:AddDropdown(drpConfig) return Starlight:_CreateDropdown(self, drpConfig) end
        function tab:AddInput(inpConfig) return Starlight:_CreateInput(self, inpConfig) end
        function tab:AddLabel(lblConfig) return Starlight:_CreateLabel(self, lblConfig) end
        function tab:AddParagraph(paraConfig) return Starlight:_CreateLabel(self, paraConfig) end -- Alias for Label
        function tab:AddSection(title) return Starlight:_CreateSection(self, title) end
        function tab:AddSlider(sldConfig) return Starlight:_CreateSlider(self, sldConfig) end
        -- ... Add other element creation methods here ...

        -- Activate the first tab added
        if tabOrder == 1 then
            self:SetActiveTab(tab)
        else
            -- Ensure inactive tabs are styled correctly initially
            tabButton.BackgroundColor3 = Starlight.Theme.Secondary
            tabButton.TextColor3 = Starlight.Theme.TextSecondary
            tabIcon.ImageColor3 = Starlight.Theme.TextSecondary
            if tabButton:FindFirstChildWhichIsA("UIStroke") then tabButton.UIStroke.Transparency = 1 end
        end

        return tab
    end

    function window:SetActiveTab(targetTab)
        if self.ActiveTab == targetTab then return end -- Already active

        -- Deactivate previous tab
        if self.ActiveTab then
            self.ActiveTab.IsActive = false
            PlayTween(self.ActiveTab.Button, { BackgroundColor3 = Starlight.Theme.Secondary, TextColor3 = Starlight.Theme.TextSecondary }, 0.15)
            PlayTween(self.ActiveTab.Icon, { ImageColor3 = Starlight.Theme.TextSecondary }, 0.15)
            if self.ActiveTab.Button:FindFirstChildWhichIsA("UIStroke") then PlayTween(self.ActiveTab.Button.UIStroke, { Transparency = 1 }, 0.15) end -- Hide stroke
        end

        -- Activate new tab
        targetTab.IsActive = true
        self.ActiveTab = targetTab
        PlayTween(targetTab.Button, { BackgroundColor3 = Starlight.Theme.Background, TextColor3 = Starlight.Theme.Accent }, 0.15) -- Use main background, accent text
        PlayTween(targetTab.Icon, { ImageColor3 = Starlight.Theme.Accent }, 0.15)
        if targetTab.Button:FindFirstChildWhichIsA("UIStroke") then PlayTween(targetTab.Button.UIStroke, { Transparency = 0, Color = Starlight.Theme.Accent }, 0.15) end -- Show accent stroke

        -- Switch page layout
        self.PageLayout:JumpTo(targetTab.ContentPage)
    end

    -- Initial visibility
    if config.StartVisible then
        window:Show()
    else
        window.ScreenGui.Enabled = false -- Keep disabled if not starting visible
    end

    Starlight.ActiveWindows[window] = true -- Register the window
    print("Starlight: Window '" .. config.Title .. "' created.")
    return window
end


--[[ Element Creation Functions (Internal - Called by Tab methods) ]]--

-- Button Element
function Starlight:_CreateButton(parentTab, config)
    -- config = { Name = "Action", Text = "Click Me", Tooltip = "Performs an action", Callback = function() end }
    local btnConfig = config or {}
    btnConfig.Name = btnConfig.Name or "Button"
    btnConfig.Text = btnConfig.Text or "Button"
    btnConfig.Callback = btnConfig.Callback or function() print("Button '"..btnConfig.Name.."' clicked.") end

    local elementOrder = #parentTab.Elements + 1

    local buttonFrame = Instance.new("Frame") -- Use a frame for better layout control if needed later
    buttonFrame.Name = btnConfig.Name:gsub("%s+", "") .. "ButtonFrame"
    buttonFrame.Size = UDim2.new(1, 0, 0, Starlight.Theme.ElementHeight) -- Full width, standard height
    buttonFrame.BackgroundTransparency = 1 -- Frame is transparent
    buttonFrame.LayoutOrder = elementOrder
    buttonFrame.Parent = parentTab.ContentPage -- Parent to the scrolling frame

    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0) -- Fill the frame
    button.Text = btnConfig.Text
    button.AutoButtonColor = false
    button.Parent = buttonFrame
    ApplyThemeStyle(button, "Button")
    button.TextXAlignment = Enum.TextXAlignment.Center

    -- Tooltip (Simple example using MouseEnter/MouseLeave on the frame)
    if btnConfig.Tooltip then
        -- TODO: Implement a proper tooltip display system (e.g., a shared tooltip frame)
        buttonFrame.MouseEnter:Connect(function() print("Tooltip:", btnConfig.Tooltip) end)
        buttonFrame.MouseLeave:Connect(function() print("Tooltip cleared") end)
    end

    -- Interaction Animations
    local originalColor = button.BackgroundColor3
    local scale = Instance.new("UIScale") -- Add UIScale for animations
    scale.Parent = button

    button.MouseEnter:Connect(function()
        PlayTween(button, { BackgroundColor3 = originalColor:Lerp(Color3.new(1,1,1), 0.1) }, 0.1) -- Slightly lighter
        PlayTween(scale, { Scale = 1.02 }, 0.1) -- Slight grow
    end)
    button.MouseLeave:Connect(function()
        PlayTween(button, { BackgroundColor3 = originalColor }, 0.1)
        PlayTween(scale, { Scale = 1.0 }, 0.1)
    end)
    button.MouseButton1Down:Connect(function()
        PlayTween(button, { BackgroundColor3 = originalColor:Lerp(Color3.new(0,0,0), 0.1) }, 0.05) -- Slightly darker
        PlayTween(scale, { Scale = 0.98 }, 0.05) -- Slight shrink
    end)
    button.MouseButton1Up:Connect(function()
        PlayTween(button, { BackgroundColor3 = originalColor:Lerp(Color3.new(1,1,1), 0.1) }, 0.1) -- Back to hover state if mouse is still over
        PlayTween(scale, { Scale = 1.02 }, 0.1)
    end)

    -- Callback Execution
    button.MouseButton1Click:Connect(function()
        local success, err = pcall(btnConfig.Callback)
        if not success then
            warn("Starlight: Error in button callback for '"..btnConfig.Name.."':", err)
            -- Optional: Visual error feedback on the button
            local originalBtnColor = button.BackgroundColor3
            button.BackgroundColor3 = Starlight.Theme.Error
            PlayTween(button, { BackgroundColor3 = originalBtnColor }, 1.0) -- Flash error color
        end
    end)

    -- Element Object (for potential future use like :SetEnabled)
    local element = {
        Type = "Button",
        Name = btnConfig.Name,
        Instance = buttonFrame, -- Reference to the main GUI object
        Button = button,
        SetConfig = function(newConfig) -- Example method
             button.Text = newConfig.Text or button.Text
             btnConfig.Callback = newConfig.Callback or btnConfig.Callback
             -- Update tooltip etc.
        end,
        SetEnabled = function(enabled)
            button.Selectable = enabled
            button.Transparency = enabled and 0 or 0.5
            button.TextColor3 = enabled and Starlight.Theme.Text or Starlight.Theme.TextDisabled
            -- TODO: Disable animations/interactions
        end
    }
    table.insert(parentTab.Elements, element)

    return element
end

-- Toggle Element
function Starlight:_CreateToggle(parentTab, config)
    -- config = { Name = "Feature", Text = "Enable Feature", Tooltip = "Toggles the feature", Default = false, Callback = function(value) end }
    local tglConfig = config or {}
    tglConfig.Name = tglConfig.Name or "Toggle"
    tglConfig.Text = tglConfig.Text or "Toggle"
    tglConfig.Default = tglConfig.Default or false
    tglConfig.Callback = tglConfig.Callback or function(v) print("Toggle '"..tglConfig.Name.."' changed to:", v) end

    local elementOrder = #parentTab.Elements + 1
    local currentValue = tglConfig.Default

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = tglConfig.Name:gsub("%s+", "") .. "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, 0, 0, Starlight.Theme.ElementHeight)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.LayoutOrder = elementOrder
    toggleFrame.Parent = parentTab.ContentPage

    local toggleButton = Instance.new("TextButton") -- Clickable area
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Text = ""
    toggleButton.AutoButtonColor = false
    toggleButton.BackgroundTransparency = 1
    toggleButton.Parent = toggleFrame

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Size = UDim2.new(1, -Starlight.Theme.ElementHeight - Starlight.Theme.Padding.Offset, 1, 0) -- Leave space for the switch
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = tglConfig.Text
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleButton
    ApplyThemeStyle(toggleLabel, "Label")

    -- Visual Switch
    local switchSize = Starlight.Theme.ElementHeight * 0.6
    local switchTrack = Instance.new("Frame")
    switchTrack.Name = "SwitchTrack"
    switchTrack.Size = UDim2.new(0, switchSize * 1.8, 0, switchSize * 0.8)
    switchTrack.Position = UDim2.new(1, -switchSize * 1.8 - Starlight.Theme.SmallPadding.Offset, 0.5, -switchSize * 0.4)
    switchTrack.BackgroundColor3 = Starlight.Theme.Secondary
    switchTrack.BorderSizePixel = 0
    switchTrack.Parent = toggleButton
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0.5, 0) -- Pill shape
    trackCorner.Parent = switchTrack

    local switchThumb = Instance.new("Frame")
    switchThumb.Name = "SwitchThumb"
    switchThumb.Size = UDim2.new(0, switchSize, 0, switchSize)
    switchThumb.Position = UDim2.new(0, 0, 0.5, -switchSize / 2) -- Start left
    switchThumb.BackgroundColor3 = Starlight.Theme.TextSecondary -- Off color
    switchThumb.BorderSizePixel = 0
    switchThumb.Parent = switchTrack
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0.5, 0) -- Circle
    thumbCorner.Parent = switchThumb

    -- Element Object
    local element = {
        Type = "Toggle",
        Name = tglConfig.Name,
        Instance = toggleFrame,
        Button = toggleButton,
        Label = toggleLabel,
        Value = currentValue,
        SetConfig = function(newConfig) end, -- TODO
        SetEnabled = function(enabled) end, -- TODO
        SetValue = nil -- Defined below
    }

    -- Update Visual Function
    local function UpdateVisuals(value, animate)
        local targetColor = value and Starlight.Theme.Accent or Starlight.Theme.Secondary
        local targetThumbColor = value and Starlight.Theme.Primary or Starlight.Theme.TextSecondary
        local targetThumbPos = value and UDim2.new(1, -switchSize, 0.5, -switchSize / 2) or UDim2.new(0, 0, 0.5, -switchSize / 2)

        if animate then
            PlayTween(switchTrack, { BackgroundColor3 = targetColor }, 0.15)
            PlayTween(switchThumb, { BackgroundColor3 = targetThumbColor, Position = targetThumbPos }, 0.15)
        else
            switchTrack.BackgroundColor3 = targetColor
            switchThumb.BackgroundColor3 = targetThumbColor
            switchThumb.Position = targetThumbPos
        end
    end

    -- Set Value Method
    function element:SetValue(value, suppressCallback)
        value = not not value -- Ensure boolean
        if element.Value == value then return end -- No change

        element.Value = value
        UpdateVisuals(value, true)

        if not suppressCallback then
            local success, err = pcall(tglConfig.Callback, value)
            if not success then
                warn("Starlight: Error in toggle callback for '"..tglConfig.Name.."':", err)
            end
        end
    end

    -- Interaction
    toggleButton.MouseButton1Click:Connect(function()
        element:SetValue(not element.Value)
    end)

    -- Initial State
    UpdateVisuals(currentValue, false)

    table.insert(parentTab.Elements, element)
    return element
end

-- Dropdown Element
function Starlight:_CreateDropdown(parentTab, config)
    -- config = { Name = "Select", Text = "Select Option", Tooltip = "Choose an item", Values = {"One", "Two", "Three"}, Default = 1, AllowNull = false, Callback = function(value, index) end }
    local drpConfig = config or {}
    drpConfig.Name = drpConfig.Name or "Dropdown"
    drpConfig.Text = drpConfig.Text or "Select Option"
    drpConfig.Values = drpConfig.Values or {}
    drpConfig.Default = drpConfig.Default or (drpConfig.AllowNull and 0 or 1)
    drpConfig.Callback = drpConfig.Callback or function(v, i) print("Dropdown '"..drpConfig.Name.."' changed to:", v, "(Index: "..tostring(i)..")") end

    local elementOrder = #parentTab.Elements + 1
    local currentIndex = drpConfig.Default
    local currentValue = drpConfig.Values[currentIndex]
    local isOpen = false

    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = drpConfig.Name:gsub("%s+", "") .. "DropdownFrame"
    dropdownFrame.Size = UDim2.new(1, 0, 0, Starlight.Theme.ElementHeight)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.LayoutOrder = elementOrder
    dropdownFrame.Parent = parentTab.ContentPage
    dropdownFrame.ClipsDescendants = false -- Allow dropdown list to overflow
    dropdownFrame.ZIndex = 2 -- Ensure dropdown list appears above subsequent elements

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.Text = ""
    dropdownButton.AutoButtonColor = false
    dropdownButton.Parent = dropdownFrame
    ApplyThemeStyle(dropdownButton, "Button") -- Use button style as base
    dropdownButton.BackgroundColor3 = Starlight.Theme.Secondary -- Override to secondary

    local dropdownLabel = Instance.new("TextLabel")
    dropdownLabel.Name = "Label"
    dropdownLabel.Size = UDim2.new(1, -Starlight.Theme.ElementHeight, 1, 0) -- Space for arrow
    dropdownLabel.Position = UDim2.new(0, Starlight.Theme.SmallPadding.Offset, 0, 0)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Text = drpConfig.Text .. ": " .. (currentValue or "None")
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    dropdownLabel.Parent = dropdownButton
    ApplyThemeStyle(dropdownLabel, "Label")

    local arrowIcon = CreateIcon(Starlight.Theme.Icons.DropdownArrow, dropdownButton,
        UDim2.new(0, 16, 0, 16),
        UDim2.new(1, -Starlight.Theme.ElementHeight*0.8, 0.5, -8),
        Starlight.Theme.TextSecondary)
    arrowIcon.ImageRotation = 0

    -- Dropdown List Frame
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Name = "ListFrame"
    listFrame.Size = UDim2.new(1, 0, 0, 0) -- Height calculated later
    listFrame.Position = UDim2.new(0, 0, 1, Starlight.Theme.SmallPadding.Offset) -- Position below button
    listFrame.BackgroundColor3 = Starlight.Theme.Secondary
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ClipsDescendants = true
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = Starlight.Theme.Accent
    listFrame.CanvasSize = UDim2.new(0,0,0,0)
    listFrame.Parent = dropdownFrame -- Parent to main frame for ZIndex
    ApplyThemeStyle(listFrame, "ListFrame")

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    -- Element Object
    local element = {
        Type = "Dropdown",
        Name = drpConfig.Name,
        Instance = dropdownFrame,
        Button = dropdownButton,
        Label = dropdownLabel,
        ListFrame = listFrame,
        Values = drpConfig.Values,
        CurrentIndex = currentIndex,
        CurrentValue = currentValue,
        IsOpen = isOpen,
        SetConfig = function(newConfig) end, -- TODO
        SetEnabled = function(enabled) end, -- TODO
        SetValue = nil, -- Defined below
        UpdateValues = nil -- Defined below
    }

    -- Populate List Function
    local function PopulateList()
        -- Clear existing
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local totalHeight = 0
        local optionHeight = Starlight.Theme.ElementHeight * 0.8

        -- Add 'None' option if allowed
        if drpConfig.AllowNull then
            local optionButton = Instance.new("TextButton")
            optionButton.Name = "Option_None"
            optionButton.Size = UDim2.new(1, 0, 0, optionHeight)
            optionButton.Text = "  None"
            optionButton.LayoutOrder = 0
            optionButton.AutoButtonColor = false
            optionButton.BackgroundTransparency = 1
            optionButton.TextXAlignment = Enum.TextXAlignment.Left
            optionButton.Parent = listFrame
            ApplyThemeStyle(optionButton, "DropdownOption")
            optionButton.TextColor3 = (element.CurrentIndex == 0) and Starlight.Theme.Accent or Starlight.Theme.Text

            optionButton.MouseEnter:Connect(function() if element.CurrentIndex ~= 0 then optionButton.BackgroundColor3 = Starlight.Theme.Hover end end)
            optionButton.MouseLeave:Connect(function() optionButton.BackgroundColor3 = Color3.new(0,0,0); optionButton.BackgroundTransparency = 1 end)
            optionButton.MouseButton1Click:Connect(function()
                element:SetValue(nil, 0)
            end)
            totalHeight = totalHeight + optionHeight + listLayout.Padding.Offset
        end

        -- Add value options
        for i, v in ipairs(element.Values) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = "Option_" .. i
            optionButton.Size = UDim2.new(1, 0, 0, optionHeight)
            optionButton.Text = "  " .. tostring(v)
            optionButton.LayoutOrder = i
            optionButton.AutoButtonColor = false
            optionButton.BackgroundTransparency = 1
            optionButton.TextXAlignment = Enum.TextXAlignment.Left
            optionButton.Parent = listFrame
            ApplyThemeStyle(optionButton, "DropdownOption")
            optionButton.TextColor3 = (element.CurrentIndex == i) and Starlight.Theme.Accent or Starlight.Theme.Text

            optionButton.MouseEnter:Connect(function() if element.CurrentIndex ~= i then optionButton.BackgroundColor3 = Starlight.Theme.Hover end end)
            optionButton.MouseLeave:Connect(function() optionButton.BackgroundColor3 = Color3.new(0,0,0); optionButton.BackgroundTransparency = 1 end)
            optionButton.MouseButton1Click:Connect(function()
                element:SetValue(v, i)
            end)
            totalHeight = totalHeight + optionHeight + listLayout.Padding.Offset
        end

        -- Adjust list frame height (limited)
        local maxHeight = Starlight.Theme.ElementHeight * 5.5 -- Max height for ~5 items
        local targetHeight = math.min(totalHeight, maxHeight)
        listFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        listFrame.Size = UDim2.new(1, 0, 0, targetHeight)
    end

    -- Open/Close List Function
    local function SetOpen(open)
        if element.IsOpen == open then return end
        element.IsOpen = open
        dropdownFrame.ClipsDescendants = not open -- Allow overflow when open
        dropdownFrame.ZIndex = open and 10 or 2 -- Bring to front when open

        if open then
            PopulateList() -- Repopulate in case values changed
            listFrame.Visible = true
            PlayTween(arrowIcon, { ImageRotation = 180 }, 0.15)
            PlayTween(listFrame, { Size = UDim2.new(1, 0, 0, listFrame.Size.Y.Offset) }, 0.15) -- Animate height (already calculated in PopulateList)
        else
            PlayTween(arrowIcon, { ImageRotation = 0 }, 0.15)
            local closeTween = PlayTween(listFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.15) -- Animate height closed
            closeTween.Completed:Connect(function()
                if not element.IsOpen then listFrame.Visible = false end -- Hide only after animation if still closed
            end)
        end
    end

    -- Set Value Method
    function element:SetValue(value, index, suppressCallback)
        index = index or 0 -- Default to 0 if only value is passed (e.g., for null)
        if element.CurrentIndex == index then
            SetOpen(false) -- Close if clicking the same value
            return
        end

        element.CurrentValue = value
        element.CurrentIndex = index
        element.Label.Text = drpConfig.Text .. ": " .. (value or "None")
        SetOpen(false) -- Close the dropdown

        if not suppressCallback then
            local success, err = pcall(drpConfig.Callback, value, index)
            if not success then
                warn("Starlight: Error in dropdown callback for '"..drpConfig.Name.."':", err)
            end
        end
    end

    -- Update Values Method
    function element:UpdateValues(newValues, newDefaultIndex)
        element.Values = newValues or {}
        local defaultIdx = newDefaultIndex or (drpConfig.AllowNull and 0 or 1)
        local defaultValue = element.Values[defaultIdx]
        element:SetValue(defaultValue, defaultIdx, true) -- Set new default value without triggering callback
        if element.IsOpen then PopulateList() end -- Refresh list if open
    end

    -- Interaction
    dropdownButton.MouseButton1Click:Connect(function()
        SetOpen(not element.IsOpen)
    end)

    -- Close when clicking elsewhere (basic implementation)
    UserInputService.InputBegan:Connect(function(input)
        if not element.IsOpen then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local guiObject = input.UserInputState == Enum.UserInputState.Begin and input.GuiObject or nil
            if not guiObject or not (guiObject == dropdownFrame or guiObject:IsDescendantOf(dropdownFrame)) then
                SetOpen(false)
            end
        end
    end)

    -- Initial State
    element:SetValue(currentValue, currentIndex, true) -- Set initial value without callback

    table.insert(parentTab.Elements, element)
    return element
end

-- Input Element
function Starlight:_CreateInput(parentTab, config)
    -- config = { Name = "Setting", Text = "Enter Value:", Tooltip = "Input field", Placeholder = "Value...", Default = "", Numeric = false, Secret = false, Finished = false, Callback = function(text) end }
    local inpConfig = config or {}
    inpConfig.Name = inpConfig.Name or "Input"
    inpConfig.Text = inpConfig.Text or "Input:"
    inpConfig.Placeholder = inpConfig.Placeholder or "..."
    inpConfig.Default = inpConfig.Default or ""
    inpConfig.Callback = inpConfig.Callback or function(t) print("Input '"..inpConfig.Name.."' changed to:", t) end

    local elementOrder = #parentTab.Elements + 1
    local currentValue = inpConfig.Default

    local inputFrame = Instance.new("Frame")
    inputFrame.Name = inpConfig.Name:gsub("%s+", "") .. "InputFrame"
    inputFrame.Size = UDim2.new(1, 0, 0, Starlight.Theme.ElementHeight)
    inputFrame.BackgroundTransparency = 1
    inputFrame.LayoutOrder = elementOrder
    inputFrame.Parent = parentTab.ContentPage

    local inputLabel = Instance.new("TextLabel")
    inputLabel.Name = "Label"
    inputLabel.Size = UDim2.new(0.4, 0, 1, 0) -- Label takes ~40% width
    inputLabel.Position = UDim2.new(0, 0, 0, 0)
    inputLabel.BackgroundTransparency = 1
    inputLabel.Text = inpConfig.Text
    inputLabel.TextXAlignment = Enum.TextXAlignment.Left
    inputLabel.Parent = inputFrame
    ApplyThemeStyle(inputLabel, "Label")

    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(0.6, -Starlight.Theme.SmallPadding.Offset, 1, 0) -- TextBox takes remaining width
    textBox.Position = UDim2.new(0.4, Starlight.Theme.SmallPadding.Offset, 0, 0)
    textBox.Text = currentValue
    textBox.PlaceholderText = inpConfig.Placeholder
    textBox.ClearTextOnFocus = false
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.Parent = inputFrame
    ApplyThemeStyle(textBox, "Input")
    textBox.BackgroundColor3 = Starlight.Theme.Secondary
    textBox.PlaceholderColor3 = Starlight.Theme.TextDisabled

    if inpConfig.Numeric then
        textBox.Text = tostring(tonumber(currentValue) or 0)
        textBox:GetPropertyChangedSignal("Text"):Connect(function()
            local num = tonumber(textBox.Text)
            if num == nil and textBox.Text ~= "" and textBox.Text ~= "-" then
                -- Revert to last valid number (or 0)
                textBox.Text = tostring(tonumber(currentValue) or 0)
            end
        end)
    end

    if inpConfig.Secret then
        textBox.TextMasked = true
    end

    -- Element Object
    local element = {
        Type = "Input",
        Name = inpConfig.Name,
        Instance = inputFrame,
        Label = inputLabel,
        TextBox = textBox,
        Value = currentValue,
        SetConfig = function(newConfig) end, -- TODO
        SetEnabled = function(enabled) end, -- TODO
        SetValue = nil -- Defined below
    }

    -- Set Value Method
    function element:SetValue(value, suppressCallback)
        value = tostring(value)
        if inpConfig.Numeric then
            value = tostring(tonumber(value) or 0)
        end
        if element.Value == value then return end

        element.Value = value
        textBox.Text = value

        if not suppressCallback then
            local success, err = pcall(inpConfig.Callback, value)
            if not success then
                warn("Starlight: Error in input callback for '"..inpConfig.Name.."':", err)
            end
        end
    end

    -- Interaction and Callback Trigger
    textBox.FocusLost:Connect(function(enterPressed)
        local newValue = textBox.Text
        if inpConfig.Numeric then
            newValue = tostring(tonumber(newValue) or 0)
            textBox.Text = newValue -- Ensure displayed text is cleaned number
        end

        if element.Value ~= newValue then
            element:SetValue(newValue) -- This calls the callback internally
        end
    end)

    -- Highlight on focus
    textBox.Focused:Connect(function()
        PlayTween(textBox.UIStroke, { Color = Starlight.Theme.StrokeHighlight, Thickness = 1.5 }, 0.1)
    end)
    textBox.FocusLost:Connect(function()
        PlayTween(textBox.UIStroke, { Color = Starlight.Theme.Stroke, Thickness = 1 }, 0.1)
    end)

    table.insert(parentTab.Elements, element)
    return element
end

-- Label / Paragraph Element
function Starlight:_CreateLabel(parentTab, config)
    -- config = { Name = "Info", Text = "Some information", Size = 1, Center = false, Bold = false }
    local lblConfig = config or {}
    lblConfig.Name = lblConfig.Name or "Label"
    lblConfig.Text = lblConfig.Text or "Label"
    lblConfig.Size = lblConfig.Size or 1 -- Multiplier for standard height

    local elementOrder = #parentTab.Elements + 1

    local labelFrame = Instance.new("Frame")
    labelFrame.Name = lblConfig.Name:gsub("%s+", "") .. "LabelFrame"
    labelFrame.Size = UDim2.new(1, 0, 0, Starlight.Theme.ElementHeight * lblConfig.Size)
    labelFrame.BackgroundTransparency = 1
    labelFrame.LayoutOrder = elementOrder
    labelFrame.Parent = parentTab.ContentPage

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -Starlight.Theme.Padding.Offset * 2, 1, 0) -- Padding
    label.Position = UDim2.new(0, Starlight.Theme.Padding.Offset, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = lblConfig.Text
    label.TextWrapped = true
    label.TextXAlignment = lblConfig.Center and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top -- Usually better for multi-line
    label.Font = lblConfig.Bold and Starlight.Theme.FontBold or Starlight.Theme.Font
    label.TextColor3 = Starlight.Theme.TextSecondary -- Use secondary color for info
    label.Parent = labelFrame
    -- ApplyThemeStyle(label, "Label") -- Basic style applied, specific overrides here

    -- Element Object
    local element = {
        Type = "Label",
        Name = lblConfig.Name,
        Instance = labelFrame,
        Label = label,
        SetText = function(newText)
            label.Text = newText
            lblConfig.Text = newText
        end
    }
    table.insert(parentTab.Elements, element)
    return element
end

-- Section Element
function Starlight:_CreateSection(parentTab, title)
    title = title or "Section"
    local elementOrder = #parentTab.Elements + 1

    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = title:gsub("%s+", "") .. "SectionFrame"
    sectionFrame.Size = UDim2.new(1, 0, 0, Starlight.Theme.TextSizeTitle + Starlight.Theme.SmallPadding.Offset * 2) -- Height based on title size
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.LayoutOrder = elementOrder
    sectionFrame.Parent = parentTab.ContentPage

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "Label"
    sectionLabel.Size = UDim2.new(1, -Starlight.Theme.Padding.Offset * 2, 1, 0)
    sectionLabel.Position = UDim2.new(0, Starlight.Theme.Padding.Offset, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = title
    sectionLabel.Font = Starlight.Theme.FontTitle
    sectionLabel.TextSize = Starlight.Theme.TextSizeTitle
    sectionLabel.TextColor3 = Starlight.Theme.Text -- Use primary text color for titles
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame

    local line = Instance.new("Frame") -- Separator line
    line.Name = "Separator"
    line.Size = UDim2.new(1, -Starlight.Theme.Padding.Offset * 2, 0, 1)
    line.Position = UDim2.new(0, Starlight.Theme.Padding.Offset, 1, -Starlight.Theme.SmallPadding.Offset)
    line.BackgroundColor3 = Starlight.Theme.Stroke
    line.BorderSizePixel = 0
    line.Parent = sectionFrame

    -- Element Object (mainly for structure, no interaction)
    local element = {
        Type = "Section",
        Name = title,
        Instance = sectionFrame
    }
    table.insert(parentTab.Elements, element)
    return element
end

-- Slider Element
function Starlight:_CreateSlider(parentTab, config)
    -- config = { Name="Value", Text="Adjust Value", Tooltip="", Min=0, Max=100, Default=50, Increment=1, Suffix="%", Callback=function(value) end }
    local sldConfig = config or {}
    sldConfig.Name = sldConfig.Name or "Slider"
    sldConfig.Text = sldConfig.Text or "Slider"
    sldConfig.Min = sldConfig.Min or 0
    sldConfig.Max = sldConfig.Max or 100
    sldConfig.Default = sldConfig.Default or sldConfig.Min
    sldConfig.Increment = sldConfig.Increment or 1
    sldConfig.Suffix = sldConfig.Suffix or ""
    sldConfig.Callback = sldConfig.Callback or function(v) print("Slider '"..sldConfig.Name.."' changed to:", v) end

    local elementOrder = #parentTab.Elements + 1
    local currentValue = math.clamp(sldConfig.Default, sldConfig.Min, sldConfig.Max)
    local isDragging = false

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = sldConfig.Name:gsub("%s+", "") .. "SliderFrame"
    sliderFrame.Size = UDim2.new(1, 0, 0, Starlight.Theme.ElementHeight * 1.5) -- Slightly taller for label
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.LayoutOrder = elementOrder
    sliderFrame.Parent = parentTab.ContentPage

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Size = UDim2.new(0.7, 0, 0, Starlight.Theme.ElementHeight * 0.5) -- Top part for label
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = sldConfig.Text
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    ApplyThemeStyle(sliderLabel, "Label")
    sliderLabel.TextColor3 = Starlight.Theme.TextSecondary

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0.3, -Starlight.Theme.SmallPadding.Offset, 0, Starlight.Theme.ElementHeight * 0.5)
    valueLabel.Position = UDim2.new(0.7, Starlight.Theme.SmallPadding.Offset, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = ""
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    ApplyThemeStyle(valueLabel, "ValueLabel")
    valueLabel.TextColor3 = Starlight.Theme.Accent
    valueLabel.Font = Starlight.Theme.FontBold

    -- Slider Track
    local trackYPos = Starlight.Theme.ElementHeight * 0.75
    local trackHeight = 6
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, -Starlight.Theme.Padding.Offset * 2, 0, trackHeight)
    track.Position = UDim2.new(0, Starlight.Theme.Padding.Offset, 0, trackYPos - trackHeight / 2)
    track.BackgroundColor3 = Starlight.Theme.Secondary
    track.BorderSizePixel = 0
    track.Parent = sliderFrame
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0.5, 0)
    trackCorner.Parent = track

    -- Filled Track
    local filledTrack = Instance.new("Frame")
    filledTrack.Name = "FilledTrack"
    filledTrack.Size = UDim2.new(0, 0, 1, 0) -- Width calculated based on value
    filledTrack.Position = UDim2.new(0, 0, 0, 0)
    filledTrack.BackgroundColor3 = Starlight.Theme.Primary
    filledTrack.BorderSizePixel = 0
    filledTrack.Parent = track
    local filledCorner = Instance.new("UICorner")
    filledCorner.CornerRadius = UDim.new(0.5, 0)
    filledCorner.Parent = filledTrack

    -- Thumb
    local thumbSize = Starlight.Theme.ElementHeight * 0.5
    local thumb = Instance.new("ImageButton") -- Use ImageButton for potential custom thumb later
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, thumbSize, 0, thumbSize)
    thumb.Position = UDim2.new(0, 0, 0, trackYPos - thumbSize / 2) -- Y centered on track
    thumb.BackgroundColor3 = Starlight.Theme.Accent
    thumb.BorderSizePixel = 0
    thumb.AutoButtonColor = false
    thumb.BackgroundTransparency = 0 -- Visible thumb
    thumb.Parent = sliderFrame
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0.5, 0) -- Circle
    thumbCorner.Parent = thumb
    local thumbScale = Instance.new("UIScale") -- For animation
    thumbScale.Parent = thumb

    -- Element Object
    local element = {
        Type = "Slider",
        Name = sldConfig.Name,
        Instance = sliderFrame,
        Label = sliderLabel,
        ValueLabel = valueLabel,
        Value = currentValue,
        SetConfig = function(newConfig) end, -- TODO
        SetEnabled = function(enabled) end, -- TODO
        SetValue = nil -- Defined below
    }

    -- Round value to increment
    local function RoundToIncrement(value)
        return math.floor(value / sldConfig.Increment + 0.5) * sldConfig.Increment
    end

    -- Update Visuals Function
    local function UpdateVisuals(value, animate)
        value = math.clamp(value, sldConfig.Min, sldConfig.Max)
        local percentage = (value - sldConfig.Min) / (sldConfig.Max - sldConfig.Min)
        percentage = math.clamp(percentage, 0, 1)

        local targetFilledSize = UDim2.new(percentage, 0, 1, 0)
        -- Position thumb centered over the end of the filled track
        local thumbX = track.AbsolutePosition.X + track.AbsoluteSize.X * percentage
        local targetThumbPos = UDim2.fromOffset(thumbX - thumbSize / 2, trackYPos - thumbSize / 2)

        valueLabel.Text = string.format("%.*f", sldConfig.Increment < 1 and 1 or 0, value) .. sldConfig.Suffix

        if animate then
            PlayTween(filledTrack, { Size = targetFilledSize }, 0.1)
            PlayTween(thumb, { Position = targetThumbPos }, 0.1)
        else
            filledTrack.Size = targetFilledSize
            thumb.Position = targetThumbPos
        end
    end

    -- Set Value Method
    function element:SetValue(value, suppressCallback)
        value = RoundToIncrement(value)
        value = math.clamp(value, sldConfig.Min, sldConfig.Max)

        if element.Value == value then return end -- No change

        element.Value = value
        UpdateVisuals(value, true)

        if not suppressCallback then
            local success, err = pcall(sldConfig.Callback, value)
            if not success then
                warn("Starlight: Error in slider callback for '"..sldConfig.Name.."':", err)
            end
        end
    end

    -- Dragging Logic
    local function HandleInput(inputPos)
        local relativeX = inputPos.X - track.AbsolutePosition.X
        local percentage = math.clamp(relativeX / track.AbsoluteSize.X, 0, 1)
        local newValue = sldConfig.Min + (sldConfig.Max - sldConfig.Min) * percentage
        element:SetValue(newValue) -- This rounds, clamps, updates visuals, and calls callback
    end

    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            PlayTween(thumbScale, { Scale = 1.2 }, 0.1) -- Grow thumb on drag start
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                    PlayTween(thumbScale, { Scale = 1.0 }, 0.1) -- Shrink thumb on drag end
                    if connection then connection:Disconnect() end
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            HandleInput(input.Position)
        end
    end)

    -- Allow clicking on the track
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
             HandleInput(input.Position)
             -- Optionally start dragging from track click (more complex)
        end
    end)

    -- Initial State
    UpdateVisuals(currentValue, false)

    table.insert(parentTab.Elements, element)
    return element
end

--[[ TODO: Implement other elements like:
function Starlight:_CreateColorPicker(parentTab, config) ... end
function Starlight:_CreateKeybind(parentTab, config) ... end
]]

--[[ Initialization ]]--
function Starlight.Init(customTheme)
    -- Merge custom theme if provided (simple merge, override)
    if customTheme and type(customTheme) == "table" then
        for k, v in pairs(customTheme) do
            if type(v) == "table" and type(Starlight.Theme[k]) == "table" then
                -- Deep merge for nested tables like Icons (optional)
                for sk, sv in pairs(v) do Starlight.Theme[k][sk] = sv end
            else
                Starlight.Theme[k] = v
            end
        end
        print("Starlight: Custom theme applied.")
    end

    print("Starlight UI Initialized. Theme:", Starlight.Theme.Name)
    -- Return the library table itself, user calls methods like Starlight:CreateWindow()
    return Starlight
end

return Starlight.Init() -- Initialize and return the library instance immediately
