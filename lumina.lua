--[[
    LuminaUI Interface Library (Refactored)
    A modern, responsive UI library for Roblox scripting

    Version: 1.3.0 (Refactored)
    Features:
    - Modern design with smooth animations
    - Customizable themes with dynamic updates
    - Optimized performance (task library, connection management)
    - Enhanced element interactions
    - Simplified configuration
    - Advanced component system
    - Flexible layout options
    - Improved error handling
]]

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local CollectionService = game:GetService("CollectionService") -- For theme updates

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse() -- Keep for ripple effect, consider replacing if possible
local ConfigFolder = "LuminaUI"
local ConfigExtension = ".config"

-- Forward Declarations
local LuminaUI = {
    Flags = {},
    Version = "1.3.0",
    Theme = {} -- Themes defined below
}
local Utility = {}
local InstancePool = {}
local ThemedElementsRegistry = {} -- Stores elements needing theme updates
local ActiveDropdown = nil -- Track currently open dropdown
local GlobalInputConnection = nil -- For closing dropdowns

-- Themes (Same as original)
LuminaUI.Theme = {
    Default = {
        TextColor = Color3.fromRGB(240, 240, 240), SubTextColor = Color3.fromRGB(200, 200, 200), Background = Color3.fromRGB(25, 25, 25), Topbar = Color3.fromRGB(34, 34, 34), Shadow = Color3.fromRGB(20, 20, 20), ElementBackground = Color3.fromRGB(35, 35, 35), ElementBackgroundHover = Color3.fromRGB(40, 40, 40), ElementStroke = Color3.fromRGB(50, 50, 50), TabBackground = Color3.fromRGB(80, 80, 80), TabBackgroundSelected = Color3.fromRGB(210, 210, 210), TabTextColor = Color3.fromRGB(240, 240, 240), SelectedTabTextColor = Color3.fromRGB(50, 50, 50), ToggleEnabled = Color3.fromRGB(0, 146, 214), ToggleDisabled = Color3.fromRGB(100, 100, 100), SliderBackground = Color3.fromRGB(50, 138, 220), SliderProgress = Color3.fromRGB(50, 138, 220), NotificationBackground = Color3.fromRGB(20, 20, 20), InputBackground = Color3.fromRGB(30, 30, 30), InputStroke = Color3.fromRGB(65, 65, 65), InputPlaceholder = Color3.fromRGB(160, 160, 160), DropdownSelected = Color3.fromRGB(40, 40, 40), DropdownUnselected = Color3.fromRGB(30, 30, 30), ColorPickerBackground = Color3.fromRGB(30, 30, 30), SectionBackground = Color3.fromRGB(30, 30, 30), ProgressBarBackground = Color3.fromRGB(40, 40, 40), ProgressBarFill = Color3.fromRGB(60, 145, 230), CheckboxChecked = Color3.fromRGB(0, 146, 214), CheckboxUnchecked = Color3.fromRGB(100, 100, 100), ScrollBarBackground = Color3.fromRGB(45, 45, 45), ScrollBarForeground = Color3.fromRGB(70, 70, 70)
    },
    Dark = {
        TextColor = Color3.fromRGB(220, 220, 220), SubTextColor = Color3.fromRGB(180, 180, 180), Background = Color3.fromRGB(15, 15, 15), Topbar = Color3.fromRGB(24, 24, 24), Shadow = Color3.fromRGB(10, 10, 10), ElementBackground = Color3.fromRGB(25, 25, 25), ElementBackgroundHover = Color3.fromRGB(30, 30, 30), ElementStroke = Color3.fromRGB(40, 40, 40), TabBackground = Color3.fromRGB(60, 60, 60), TabBackgroundSelected = Color3.fromRGB(180, 180, 180), TabTextColor = Color3.fromRGB(220, 220, 220), SelectedTabTextColor = Color3.fromRGB(40, 40, 40), ToggleEnabled = Color3.fromRGB(0, 126, 194), ToggleDisabled = Color3.fromRGB(80, 80, 80), SliderBackground = Color3.fromRGB(40, 118, 200), SliderProgress = Color3.fromRGB(40, 118, 200), NotificationBackground = Color3.fromRGB(15, 15, 15), InputBackground = Color3.fromRGB(20, 20, 20), InputStroke = Color3.fromRGB(55, 55, 55), InputPlaceholder = Color3.fromRGB(140, 140, 140), DropdownSelected = Color3.fromRGB(30, 30, 30), DropdownUnselected = Color3.fromRGB(20, 20, 20), ColorPickerBackground = Color3.fromRGB(20, 20, 20), SectionBackground = Color3.fromRGB(20, 20, 20), ProgressBarBackground = Color3.fromRGB(30, 30, 30), ProgressBarFill = Color3.fromRGB(50, 125, 200), CheckboxChecked = Color3.fromRGB(0, 126, 194), CheckboxUnchecked = Color3.fromRGB(80, 80, 80), ScrollBarBackground = Color3.fromRGB(25, 25, 25), ScrollBarForeground = Color3.fromRGB(50, 50, 50)
    },
    Ocean = {
        TextColor = Color3.fromRGB(230, 240, 240), SubTextColor = Color3.fromRGB(190, 210, 210), Background = Color3.fromRGB(20, 30, 40), Topbar = Color3.fromRGB(25, 40, 50), Shadow = Color3.fromRGB(15, 20, 25), ElementBackground = Color3.fromRGB(30, 40, 50), ElementBackgroundHover = Color3.fromRGB(35, 45, 55), ElementStroke = Color3.fromRGB(45, 55, 65), TabBackground = Color3.fromRGB(40, 60, 70), TabBackgroundSelected = Color3.fromRGB(100, 180, 200), TabTextColor = Color3.fromRGB(210, 230, 240), SelectedTabTextColor = Color3.fromRGB(20, 40, 50), ToggleEnabled = Color3.fromRGB(0, 130, 180), ToggleDisabled = Color3.fromRGB(70, 90, 100), SliderBackground = Color3.fromRGB(0, 110, 150), SliderProgress = Color3.fromRGB(0, 140, 180), NotificationBackground = Color3.fromRGB(25, 35, 45), InputBackground = Color3.fromRGB(30, 40, 50), InputStroke = Color3.fromRGB(50, 60, 70), InputPlaceholder = Color3.fromRGB(150, 170, 180), DropdownSelected = Color3.fromRGB(30, 50, 60), DropdownUnselected = Color3.fromRGB(25, 35, 45), ColorPickerBackground = Color3.fromRGB(25, 35, 45), SectionBackground = Color3.fromRGB(25, 35, 45), ProgressBarBackground = Color3.fromRGB(35, 45, 55), ProgressBarFill = Color3.fromRGB(40, 120, 170), CheckboxChecked = Color3.fromRGB(0, 130, 180), CheckboxUnchecked = Color3.fromRGB(70, 90, 100), ScrollBarBackground = Color3.fromRGB(30, 40, 50), ScrollBarForeground = Color3.fromRGB(45, 65, 80)
    },
    Purple = {
        TextColor = Color3.fromRGB(230, 230, 240), SubTextColor = Color3.fromRGB(200, 190, 220), Background = Color3.fromRGB(30, 25, 40), Topbar = Color3.fromRGB(40, 35, 50), Shadow = Color3.fromRGB(20, 15, 30), ElementBackground = Color3.fromRGB(40, 35, 50), ElementBackgroundHover = Color3.fromRGB(50, 45, 60), ElementStroke = Color3.fromRGB(60, 55, 70), TabBackground = Color3.fromRGB(60, 50, 80), TabBackgroundSelected = Color3.fromRGB(180, 160, 220), TabTextColor = Color3.fromRGB(220, 220, 240), SelectedTabTextColor = Color3.fromRGB(30, 25, 40), ToggleEnabled = Color3.fromRGB(130, 80, 200), ToggleDisabled = Color3.fromRGB(90, 80, 100), SliderBackground = Color3.fromRGB(110, 70, 170), SliderProgress = Color3.fromRGB(130, 80, 200), NotificationBackground = Color3.fromRGB(35, 30, 45), InputBackground = Color3.fromRGB(40, 35, 50), InputStroke = Color3.fromRGB(60, 55, 70), InputPlaceholder = Color3.fromRGB(160, 150, 180), DropdownSelected = Color3.fromRGB(50, 45, 65), DropdownUnselected = Color3.fromRGB(40, 35, 55), ColorPickerBackground = Color3.fromRGB(35, 30, 45), SectionBackground = Color3.fromRGB(35, 30, 45), ProgressBarBackground = Color3.fromRGB(45, 40, 55), ProgressBarFill = Color3.fromRGB(130, 80, 200), CheckboxChecked = Color3.fromRGB(130, 80, 200), CheckboxUnchecked = Color3.fromRGB(90, 80, 100), ScrollBarBackground = Color3.fromRGB(40, 35, 50), ScrollBarForeground = Color3.fromRGB(65, 55, 75)
    }
}

-- Instance Pool Implementation
do
    local instances = {}
    local maxPoolSize = 50

    function InstancePool:Get(className)
        if not instances[className] then
            instances[className] = {}
        end

        local pool = instances[className]
        if #pool > 0 then
            local instance = table.remove(pool)
            instance.Parent = nil -- Ensure parent is nil
            return instance
        else
            return Instance.new(className)
        end
    end

    function InstancePool:Release(instance)
        if not instance or not typeof(instance) == "Instance" then return end
        local className = instance.ClassName

        if not instances[className] then
            instances[className] = {}
        end

        -- Basic reset
        instance.Name = className
        instance.Parent = nil
        instance.Archivable = false -- Prevent accidental saving

        -- Clear common properties
        if instance:IsA("GuiObject") then
            instance.BackgroundTransparency = 1
            instance.Position = UDim2.new(0, 0, 0, 0)
            instance.Size = UDim2.new(0, 0, 0, 0)
            instance.Visible = true
            instance.Rotation = 0
            instance.AnchorPoint = Vector2.new(0, 0)
            instance.ZIndex = 1
        end
        if instance:IsA("GuiButton") then
            instance.AutoButtonColor = false
        end
        if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
            instance.Text = ""
            instance.TextTransparency = 0
            instance.TextWrapped = false
            instance.TextXAlignment = Enum.TextXAlignment.Center
            instance.TextYAlignment = Enum.TextYAlignment.Center
        end
        if instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
            instance.Image = ""
            instance.ImageTransparency = 0
            instance.ImageColor3 = Color3.new(1, 1, 1)
            instance.ScaleType = Enum.ScaleType.Stretch
            instance.SliceCenter = Rect.new(0, 0, 0, 0)
        end
        if instance:IsA("ScrollingFrame") then
            instance.CanvasSize = UDim2.new(0, 0, 0, 0)
            instance.CanvasPosition = Vector2.new(0, 0)
            instance.ScrollingEnabled = true
        end

        -- Clear children (important!)
        for _, child in ipairs(instance:GetChildren()) do
            InstancePool:Release(child) -- Recursively release children
        end

        -- Add to pool if not full
        local pool = instances[className]
        if #pool < maxPoolSize then
            table.insert(pool, instance)
        else
            -- If pool is full, just destroy the instance
            instance:Destroy()
        end
    end

    function InstancePool:Clear()
        for className, pool in pairs(instances) do
            for _, instance in ipairs(pool) do
                instance:Destroy()
            end
            instances[className] = {}
        end
    end
end

-- Utility Functions
do
    local tooltipInstance = nil
    local tooltipConnection = nil
    local draggingInstance = nil
    local dragInput, dragStart, startPos

    -- Safely execute a function
    function Utility.safeCall(func, ...)
        local success, result = pcall(func, ...)
        if not success then
            warn("[LuminaUI] Error in callback:", result)
        end
        return success, result
    end

    -- Create instance using pool
    function Utility.createInstance(className, properties)
        local instance = InstancePool:Get(className)
        for prop, value in pairs(properties or {}) do
            instance[prop] = value
        end
        return instance
    end

    -- Release instance to pool
    function Utility.destroyInstance(instance)
        if not instance then return end
        InstancePool:Release(instance)
    end

    -- Debounce function using os.clock
    function Utility.debounce(func, waitTime)
        local lastCall = 0
        return function(...)
            local now = os.clock()
            if now - lastCall >= waitTime then
                lastCall = now
                return Utility.safeCall(func, ...)
            end
        end
    end

    -- Create UIStroke
    function Utility.createStroke(instance, color, thickness, transparency)
        local stroke = Utility.createInstance("UIStroke", {
            Color = color or Color3.fromRGB(50, 50, 50),
            Thickness = thickness or 1,
            Transparency = transparency or 0,
            Parent = instance
        })
        Utility.registerThemedElement(stroke, "Color", "ElementStroke") -- Register for theme updates
        return stroke
    end

    -- Create UICorner
    function Utility.createCorner(instance, radius)
        local corner = Utility.createInstance("UICorner", {
            CornerRadius = UDim.new(0, radius or 6),
            Parent = instance
        })
        return corner
    end

    -- Load icon asset ID
    function Utility.loadIcon(id)
        if type(id) == "number" then
            return "rbxassetid://" .. id
        elseif type(id) == "string" and string.match(id, "^%d+$") then -- Handle numeric strings
             return "rbxassetid://" .. id
        else
            return id -- Assume it's already a full asset path or empty
        end
    end

    -- Get text bounds
    function Utility.getTextBounds(text, font, size, maxWidth)
        maxWidth = maxWidth or math.huge
        return TextService:GetTextSize(text, size, font, Vector2.new(maxWidth, math.huge))
    end

    -- Format numbers (k, m)
    function Utility.formatNumber(value)
        if value >= 1000000 then
            return string.format("%.1fm", value / 1000000)
        elseif value >= 1000 then
            return string.format("%.1fk", value / 1000)
        else
            return tostring(math.floor(value)) -- Ensure whole numbers for smaller values
        end
    end

    -- Darken color
    function Utility.darker(color, factor)
        factor = 1 - (factor or 0.2)
        return Color3.new(
            math.clamp(color.R * factor, 0, 1),
            math.clamp(color.G * factor, 0, 1),
            math.clamp(color.B * factor, 0, 1)
        )
    end

    -- Lighten color
    function Utility.lighter(color, factor)
        factor = factor or 0.2
        return Color3.new(
            math.clamp(color.R + factor, 0, 1),
            math.clamp(color.G + factor, 0, 1),
            math.clamp(color.B + factor, 0, 1)
        )
    end

    -- Manage connections for an object
    function Utility.manageConnections(object)
        if object._connections then return end -- Already managed

        object._connections = {}
        local originalDestroy = object.Destroy or function() end -- Handle cases where Destroy might not exist initially

        function object:AddConnection(connection)
            table.insert(self._connections, connection)
        end

        function object:DisconnectAll()
            if not self._connections then return end
            for _, conn in ipairs(self._connections) do
                Utility.safeCall(function() conn:Disconnect() end)
            end
            self._connections = {}
        end

        -- Override Destroy to disconnect connections first
        function object:Destroy()
            self:DisconnectAll()
            -- Call original destroy or pool release
            if self.Instance then -- If it's a wrapper object
                Utility.destroyInstance(self.Instance)
            else -- If it's a raw Instance
                 Utility.destroyInstance(self)
            end
            -- originalDestroy(self) -- Avoid calling original if we use pooling
        end
    end

    -- Create Tooltip (Singleton)
    function Utility.createTooltip(libraryInstance, theme)
        if tooltipInstance and tooltipInstance.Parent then return tooltipInstance end

        tooltipInstance = Utility.createInstance("Frame", {
            Name = "Tooltip",
            BackgroundColor3 = theme.NotificationBackground,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 0, 0), -- Auto-sized
            Position = UDim2.new(0, 0, 0, 0),
            Visible = false,
            ZIndex = 1000,
            Parent = libraryInstance,
            ClipsDescendants = true
        })
        Utility.createCorner(tooltipInstance, 4)
        local stroke = Utility.createStroke(tooltipInstance, theme.ElementStroke, 1)
        Utility.registerThemedElement(tooltipInstance, "BackgroundColor3", "NotificationBackground")
        Utility.registerThemedElement(stroke, "Color", "ElementStroke")

        local textLabel = Utility.createInstance("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 1, -10), -- Padding
            Position = UDim2.new(0, 5, 0, 5),
            Font = Enum.Font.Gotham,
            Text = "",
            TextColor3 = theme.TextColor,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top, -- Use Top for wrapping
            ZIndex = 1001,
            Parent = tooltipInstance
        })
        Utility.registerThemedElement(textLabel, "TextColor3", "TextColor")

        -- Manage connections for the tooltip itself
        Utility.manageConnections(tooltipInstance)

        return tooltipInstance
    end

    -- Show Tooltip
    function Utility.showTooltip(text, theme, yOffset)
        local tooltip = Utility.createTooltip(LuminaUI.RootInstance, theme) -- Ensure RootInstance is set
        if not tooltip or not tooltip.Parent then return end -- Guard against race conditions

        local textLabel = tooltip:FindFirstChild("Text")
        if not textLabel then return end

        textLabel.Text = text
        local textBounds = Utility.getTextBounds(text, textLabel.Font, textLabel.TextSize, 280) -- Max width
        tooltip.Size = UDim2.new(0, math.min(textBounds.X + 16, 300), 0, textBounds.Y + 16)

        yOffset = yOffset or 5

        local function updatePosition()
            if not tooltip or not tooltip.Parent then
                if tooltipConnection then tooltipConnection:Disconnect() tooltipConnection = nil end
                return
            end
            local mousePos = UserInputService:GetMouseLocation()
            local viewportSize = workspace.CurrentCamera.ViewportSize

            local posX = mousePos.X + 15
            local posY = mousePos.Y - tooltip.AbsoluteSize.Y - yOffset

            -- Adjust X if off-screen right
            if posX + tooltip.AbsoluteSize.X > viewportSize.X then
                posX = mousePos.X - tooltip.AbsoluteSize.X - 15
            end
            -- Adjust X if off-screen left
            if posX < 0 then
                posX = 5
            end
             -- Adjust Y if off-screen top
            if posY < 0 then
                 posY = mousePos.Y + 15 -- Show below cursor if no space above
            end

            tooltip.Position = UDim2.new(0, posX, 0, posY)
        end

        updatePosition()
        tooltip.Visible = true

        -- Disconnect previous connection if exists
        if tooltipConnection then tooltipConnection:Disconnect() end

        -- Create new connection and store it
        tooltipConnection = RunService.RenderStepped:Connect(updatePosition)
        -- No need to add to tooltipInstance._connections as it's managed globally here
    end

    -- Hide Tooltip
    function Utility.hideTooltip()
        if tooltipConnection then
            tooltipConnection:Disconnect()
            tooltipConnection = nil
        end
        if tooltipInstance and tooltipInstance.Parent then
            tooltipInstance.Visible = false
        end
    end

    -- Make Draggable
    function Utility.makeDraggable(frame, handle)
        handle = handle or frame
        local connections = {}

        local inputBeganConn = handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if draggingInstance then return end -- Prevent multiple drags

                draggingInstance = frame
                dragStart = input.Position
                startPos = frame.Position

                local inputChangedConn
                inputChangedConn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        draggingInstance = nil
                        if inputChangedConn then inputChangedConn:Disconnect() end
                    end
                end)
                table.insert(connections, inputChangedConn) -- Track this connection
            end
        end)
        table.insert(connections, inputBeganConn)

        local inputChangedOuterConn = handle.InputChanged:Connect(function(input)
             if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if draggingInstance == frame then -- Only track if this handle initiated the drag
                    dragInput = input
                end
            end
        end)
         table.insert(connections, inputChangedOuterConn)

         -- Add a cleanup method to disconnect these specific drag connections
         frame._dragConnections = connections
         frame.Destroying:Connect(function()
             for _, conn in ipairs(frame._dragConnections or {}) do
                 Utility.safeCall(function() conn:Disconnect() end)
             end
             frame._dragConnections = nil
             if draggingInstance == frame then draggingInstance = nil end -- Clear global state if destroyed while dragging
         end)
    end

    -- Global Drag Update Logic (Consider moving inside CreateWindow if Library instance needed)
    task.spawn(function()
        local lastInput = nil
        RunService.Heartbeat:Connect(function()
            if draggingInstance and dragInput and dragInput ~= lastInput then
                local delta = dragInput.Position - dragStart
                local newPos = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )

                -- Clamp position to viewport (optional but good practice)
                local viewport = workspace.CurrentCamera.ViewportSize
                local absSize = draggingInstance.AbsoluteSize
                local anchor = draggingInstance.AnchorPoint
                local absPos = Vector2.new(newPos.X.Offset + viewport.X * newPos.X.Scale, newPos.Y.Offset + viewport.Y * newPos.Y.Scale)
                local topLeft = absPos - (absSize * anchor)
                local bottomRight = topLeft + absSize

                -- Clamp X
                if topLeft.X < 0 then newPos = UDim2.new(newPos.X.Scale, newPos.X.Offset - topLeft.X, newPos.Y.Scale, newPos.Y.Offset) end
                if bottomRight.X > viewport.X then newPos = UDim2.new(newPos.X.Scale, newPos.X.Offset - (bottomRight.X - viewport.X), newPos.Y.Scale, newPos.Y.Offset) end
                -- Clamp Y
                if topLeft.Y < 0 then newPos = UDim2.new(newPos.X.Scale, newPos.X.Offset, newPos.Y.Scale, newPos.Y.Offset - topLeft.Y) end
                if bottomRight.Y > viewport.Y then newPos = UDim2.new(newPos.X.Scale, newPos.X.Offset, newPos.Y.Scale, newPos.Y.Offset - (bottomRight.Y - viewport.Y)) end

                draggingInstance.Position = newPos
                lastInput = dragInput
            elseif not draggingInstance then
                dragInput = nil -- Clear input if not dragging
                lastInput = nil
            end
        end)
    end)

    -- Configuration Saving
    function Utility.saveConfig(settings, uiPosition)
        if not settings.ConfigurationSaving or not settings.ConfigurationSaving.Enabled then return end
        if not writefile then warn("[LuminaUI] 'writefile' function not available. Configuration saving disabled.") return end

        local data = {
            UIPosition = {
                X = { Scale = uiPosition.X.Scale, Offset = uiPosition.X.Offset },
                Y = { Scale = uiPosition.Y.Scale, Offset = uiPosition.Y.Offset }
            },
            Elements = {}
        }

        for flag, elementData in pairs(LuminaUI.Flags) do
            -- Only save if it has a known type and value
            if elementData and elementData.Type and elementData.Value ~= nil then
                 data.Elements[flag] = {
                    Type = elementData.Type,
                    Value = elementData.Value
                }
            end
        end

        local success, encodedData = Utility.safeCall(HttpService.JSONEncode, HttpService, data)
        if not success then
            warn("[LuminaUI] Failed to encode configuration:", encodedData)
            return
        end

        local configName = settings.ConfigurationSaving.FileName or "config"
        local filePath = ConfigFolder.."/"..configName..ConfigExtension

        -- Ensure folder exists
        if not isfolder(ConfigFolder) then
            if makefolder then
                local folderSuccess, folderErr = Utility.safeCall(makefolder, ConfigFolder)
                if not folderSuccess then
                    warn("[LuminaUI] Failed to create config folder:", folderErr)
                    return
                end
            else
                 warn("[LuminaUI] 'makefolder' function not available. Cannot create config folder.")
                 return
            end
        end

        local writeSuccess, writeErr = Utility.safeCall(writefile, filePath, encodedData)
        if not writeSuccess then
            warn("[LuminaUI] Failed to write configuration file:", writeErr)
        end
    end

    -- Configuration Loading
    function Utility.loadConfig(settings)
        local loadedData = { UIPosition = nil, Elements = {} }
        if not settings.ConfigurationSaving or not settings.ConfigurationSaving.Enabled then return loadedData end
        if not isfile or not readfile then warn("[LuminaUI] 'isfile' or 'readfile' not available. Configuration loading disabled.") return loadedData end

        local configName = settings.ConfigurationSaving.FileName or "config"
        local filePath = ConfigFolder.."/"..configName..ConfigExtension

        if not isfile(filePath) then return loadedData end -- No config file exists yet

        local success, content = Utility.safeCall(readfile, filePath)
        if not success or not content then
            warn("[LuminaUI] Failed to read configuration file:", content)
            return loadedData
        end

        local decodeSuccess, data = Utility.safeCall(HttpService.JSONDecode, HttpService, content)
        if not decodeSuccess or typeof(data) ~= "table" then
            warn("[LuminaUI] Failed to decode configuration file or data is invalid:", data)
            return loadedData
        end

        -- Load Position
        if typeof(data.UIPosition) == "table" and
           typeof(data.UIPosition.X) == "table" and typeof(data.UIPosition.Y) == "table" and
           typeof(data.UIPosition.X.Scale) == "number" and typeof(data.UIPosition.X.Offset) == "number" and
           typeof(data.UIPosition.Y.Scale) == "number" and typeof(data.UIPosition.Y.Offset) == "number" then
            loadedData.UIPosition = UDim2.new(
                data.UIPosition.X.Scale, data.UIPosition.X.Offset,
                data.UIPosition.Y.Scale, data.UIPosition.Y.Offset
            )
        end

        -- Load Elements
        if typeof(data.Elements) == "table" then
            for flag, elementData in pairs(data.Elements) do
                if typeof(elementData) == "table" and elementData.Type and elementData.Value ~= nil then
                    loadedData.Elements[flag] = { Type = elementData.Type, Value = elementData.Value }
                end
            end
        end

        return loadedData
    end

    -- Apply Custom Scrollbar
    function Utility.applyCustomScrollbar(scrollFrame, theme, thickness)
        thickness = thickness or 4
        local connections = {}

        -- Remove default scrollbar
        scrollFrame.ScrollBarThickness = 0
        scrollFrame.ScrollBarImageTransparency = 1
        scrollFrame.ScrollingEnabled = true -- Ensure scrolling is enabled

        -- Create custom scrollbar elements
        local scrollbar = Utility.createInstance("Frame", {
            Name = "CustomScrollbar",
            Size = UDim2.new(0, thickness, 1, 0),
            Position = UDim2.new(1, -thickness, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = theme.ScrollBarBackground,
            BackgroundTransparency = 0.5,
            ZIndex = scrollFrame.ZIndex + 10,
            Parent = scrollFrame
        })
        Utility.createCorner(scrollbar, thickness / 2)
        Utility.registerThemedElement(scrollbar, "BackgroundColor3", "ScrollBarBackground")

        local scrollThumb = Utility.createInstance("Frame", {
            Name = "ScrollThumb",
            Size = UDim2.new(1, 0, 0.2, 0), -- Initial size, will be updated
            BackgroundColor3 = theme.ScrollBarForeground,
            ZIndex = scrollbar.ZIndex + 1,
            Parent = scrollbar
        })
        Utility.createCorner(scrollThumb, thickness / 2)
        Utility.registerThemedElement(scrollThumb, "BackgroundColor3", "ScrollBarForeground")

        local function updateScrollbar()
            if not scrollFrame or not scrollFrame.Parent then return end -- Check if valid

            local canvasSizeY = scrollFrame.CanvasSize.Y.Offset
            local frameSizeY = scrollFrame.AbsoluteSize.Y

            if frameSizeY <= 0 then frameSizeY = 1 end -- Avoid division by zero

            if canvasSizeY <= frameSizeY then
                scrollbar.Visible = false
                return
            else
                scrollbar.Visible = true
            end

            local scrollableDist = canvasSizeY - frameSizeY
            if scrollableDist <= 0 then scrollableDist = 1 end -- Avoid division by zero

            local scrollPercent = math.clamp(scrollFrame.CanvasPosition.Y / scrollableDist, 0, 1)
            local thumbSizeScale = math.clamp(frameSizeY / canvasSizeY, 0.05, 1) -- Min size

            scrollThumb.Size = UDim2.new(1, 0, thumbSizeScale, 0)
            scrollThumb.Position = UDim2.new(0, 0, scrollPercent * (1 - thumbSizeScale), 0)
        end

        -- Connect update events
        table.insert(connections, scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(updateScrollbar))
        table.insert(connections, scrollFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScrollbar))
        table.insert(connections, scrollFrame:GetPropertyChangedSignal("CanvasSize"):Connect(updateScrollbar))

        -- Thumb dragging logic
        local isDragging = false
        local dragStartMouseY, dragStartCanvasY

        table.insert(connections, scrollThumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStartMouseY = input.Position.Y
                dragStartCanvasY = scrollFrame.CanvasPosition.Y
                -- Prevent text selection while dragging scrollbar
                UserInputService.TextSelectionEnabled = false
            end
        end))

        table.insert(connections, UserInputService.InputEnded:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                isDragging = false
                UserInputService.TextSelectionEnabled = true -- Re-enable text selection
            end
        end))

        table.insert(connections, UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local deltaY = input.Position.Y - dragStartMouseY
                local canvasSizeY = scrollFrame.CanvasSize.Y.Offset
                local frameSizeY = scrollFrame.AbsoluteSize.Y
                local scrollableDist = canvasSizeY - frameSizeY

                if scrollableDist > 0 then
                    local thumbSizeScale = scrollThumb.Size.Y.Scale
                    local trackSize = frameSizeY * (1 - thumbSizeScale)
                    if trackSize <= 0 then trackSize = 1 end -- Avoid division by zero

                    local scrollMultiplier = scrollableDist / trackSize
                    local newCanvasY = dragStartCanvasY + (deltaY * scrollMultiplier)
                    scrollFrame.CanvasPosition = Vector2.new(scrollFrame.CanvasPosition.X, math.clamp(newCanvasY, 0, scrollableDist))
                end
            end
        end))

        -- Mouse wheel scrolling (applied directly to the scrollFrame)
        table.insert(connections, scrollFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                local scrollDelta = input.Position.Z
                local currentPos = scrollFrame.CanvasPosition.Y
                local canvasSizeY = scrollFrame.CanvasSize.Y.Offset
                local frameSizeY = scrollFrame.AbsoluteSize.Y
                local maxScroll = canvasSizeY - frameSizeY

                if maxScroll > 0 then
                    local scrollAmount = scrollDelta * -60 -- Adjust multiplier as needed, negative for natural scroll
                    scrollFrame.CanvasPosition = Vector2.new(
                        scrollFrame.CanvasPosition.X,
                        math.clamp(currentPos + scrollAmount, 0, maxScroll)
                    )
                end
            end
        end))

        -- Initial update
        task.wait() -- Wait a frame for sizes to be calculated
        updateScrollbar()

        -- Cleanup
        scrollFrame:SetAttribute("__LuminaScrollbarConnections", connections) -- Store connections
        scrollFrame.Destroying:Connect(function()
            local conns = scrollFrame:GetAttribute("__LuminaScrollbarConnections")
            if conns then
                for _, conn in ipairs(conns) do
                    Utility.safeCall(function() conn:Disconnect() end)
                end
            end
            -- Ensure thumb dragging state is reset
            if isDragging then
                 UserInputService.TextSelectionEnabled = true
            end
        end)

        return scrollbar
    end

    -- Ripple Effect
    function Utility.rippleEffect(parent, color)
        color = color or Color3.fromRGB(255, 255, 255)
        local mousePos = UserInputService:GetMouseLocation()

        local ripple = Utility.createInstance("Frame", {
            Name = "Ripple",
            BackgroundColor3 = color,
            BackgroundTransparency = 0.7,
            Position = UDim2.new(0, mousePos.X - parent.AbsolutePosition.X, 0, mousePos.Y - parent.AbsolutePosition.Y),
            Size = UDim2.new(0, 0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = (parent:IsA("GuiObject") and parent.ZIndex or 1) + 1, -- Ensure ripple is above parent
            Parent = parent,
            ClipsDescendants = true -- Keep ripple contained
        })
        Utility.createCorner(ripple, 100) -- Make it circular

        local diameter = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 1.5 -- Adjust size multiplier

        local tween = TweenService:Create(ripple, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, diameter, 0, diameter),
            BackgroundTransparency = 1
        })
        tween:Play()

        tween.Completed:Connect(function()
            Utility.destroyInstance(ripple)
        end)
    end

    -- Pulse Effect
    function Utility.pulseEffect(object, scaleIncrease, duration)
        scaleIncrease = scaleIncrease or 1.05
        duration = duration or 0.15 -- Faster pulse

        local originalSize = object.Size
        local targetSize = UDim2.new(
            originalSize.X.Scale * scaleIncrease, originalSize.X.Offset * scaleIncrease,
            originalSize.Y.Scale * scaleIncrease, originalSize.Y.Offset * scaleIncrease
        )

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenUp = TweenService:Create(object, tweenInfo, { Size = targetSize })
        local tweenDown = TweenService:Create(object, tweenInfo, { Size = originalSize })

        tweenUp:Play()
        tweenUp.Completed:Connect(function()
            -- Ensure object still exists before playing next tween
            if object and object.Parent then
                tweenDown:Play()
            end
        end)
    end

    -- Typewrite Effect
    function Utility.typewriteEffect(textLabel, text, speed)
        speed = speed or 0.03
        textLabel.Text = ""
        local currentCoroutine = coroutine.running()

        local connection
        connection = textLabel.Destroying:Connect(function()
             -- Stop the effect if the label is destroyed
             if currentCoroutine then
                 task.cancel(currentCoroutine)
             end
             if connection then connection:Disconnect() end -- Disconnect self
        end)

        for i = 1, #text do
            if not textLabel or not textLabel.Parent then break end -- Stop if label is gone
            textLabel.Text = string.sub(text, 1, i)
            task.wait(speed)
        end

        if connection then connection:Disconnect() end -- Clean up connection
        currentCoroutine = nil
    end

    -- Create Blur
    function Utility.createBlur(parent, strength)
        strength = strength or 10
        local blur = Utility.createInstance("BlurEffect", {
            Size = 0,
            Parent = parent
        })
        TweenService:Create(blur, TweenInfo.new(0.3), { Size = strength }):Play()
        return blur
    end

    -- Remove Blur
    function Utility.removeBlur(blur)
        if not blur or not blur.Parent then return end
        local tween = TweenService:Create(blur, TweenInfo.new(0.3), { Size = 0 })
        tween:Play()
        tween.Completed:Connect(function()
            Utility.destroyInstance(blur)
        end)
    end

    -- Register element for theme updates
    function Utility.registerThemedElement(instance, property, themeKey, hoverThemeKey)
        if not instance or not instance.Parent then return end
        local id = HttpService:GenerateGUID(false)
        instance:SetAttribute("LuminaThemeID", id)
        ThemedElementsRegistry[id] = {
            Instance = instance,
            Property = property,
            ThemeKey = themeKey,
            HoverThemeKey = hoverThemeKey -- Optional: For hover states
        }
    end

    -- Unregister element from theme updates
    function Utility.unregisterThemedElement(instance)
        if not instance or not instance:GetAttribute("LuminaThemeID") then return end
        local id = instance:GetAttribute("LuminaThemeID")
        if ThemedElementsRegistry[id] then
            ThemedElementsRegistry[id] = nil
        end
        instance:SetAttribute("LuminaThemeID", nil)
    end

    -- Apply theme to all registered elements
    function Utility.applyThemeToAll(theme)
        for id, data in pairs(ThemedElementsRegistry) do
            local instance = data.Instance
            if instance and instance.Parent then -- Check if instance still exists
                local value = theme[data.ThemeKey]
                if value then
                    -- Use pcall for safety, though direct assignment is usually fine
                    Utility.safeCall(function() instance[data.Property] = value end)
                else
                    warn("[LuminaUI] Theme key not found:", data.ThemeKey)
                end
            else
                -- Instance was destroyed, remove from registry
                ThemedElementsRegistry[id] = nil
            end
        end
        -- Update tooltip theme separately if it exists
        if tooltipInstance and tooltipInstance.Parent then
             local textLabel = tooltipInstance:FindFirstChild("Text")
             local stroke = tooltipInstance:FindFirstChildOfClass("UIStroke")
             tooltipInstance.BackgroundColor3 = theme.NotificationBackground
             if textLabel then textLabel.TextColor3 = theme.TextColor end
             if stroke then stroke.Color = theme.ElementStroke end
        end
    end

    -- Cleanup registry (e.g., when UI is destroyed)
    function Utility.clearThemeRegistry()
        ThemedElementsRegistry = {}
    end

    -- Global click listener for dropdowns
    function Utility.setupGlobalInputListener()
        if GlobalInputConnection then GlobalInputConnection:Disconnect() end
        GlobalInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end -- Ignore clicks handled by Roblox core UI (like chat)

            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and ActiveDropdown then
                -- Check if the click was outside the active dropdown's container
                local clickedInstance = input.UserInputState == Enum.UserInputState.Begin and input.Target or nil -- Get the instance clicked
                local isDescendant = false
                if clickedInstance then
                    isDescendant = clickedInstance:IsDescendantOf(ActiveDropdown.Instance)
                end

                if not isDescendant then
                    ActiveDropdown:ToggleOpen(false) -- Close the dropdown
                    ActiveDropdown = nil -- Clear the active dropdown reference
                end
            end
        end)
    end

    function Utility.cleanupGlobalInputListener()
        if GlobalInputConnection then
            GlobalInputConnection:Disconnect()
            GlobalInputConnection = nil
        end
        ActiveDropdown = nil -- Ensure cleared on cleanup
    end

end

-- ==================================
--      UI Creation (Refactored)
-- ==================================

-- Private Helper Functions
local function _createBaseUI(settings)
    -- Destroy existing UI and clear resources
    if LuminaUI.RootInstance then
        Utility.safeCall(function() LuminaUI.RootInstance:Destroy() end)
        LuminaUI.RootInstance = nil
        Utility.clearThemeRegistry()
        Utility.cleanupGlobalInputListener()
        InstancePool:Clear() -- Clear pool on full UI recreation
    end

    local screenGui = Utility.createInstance("ScreenGui", {
        Name = "LuminaUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 100,
        -- Parent is set after protection
    })
    LuminaUI.RootInstance = screenGui -- Store root reference

    -- Apply protection and set parent
    if gethui then
        screenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        Utility.safeCall(syn.protect_gui, screenGui)
        screenGui.Parent = CoreGui
    else
        screenGui.Parent = CoreGui
    end

    -- Setup global listener for dropdowns
    Utility.setupGlobalInputListener()

    -- Cleanup on destroy
    screenGui.Destroying:Connect(function()
        Utility.clearThemeRegistry()
        Utility.cleanupGlobalInputListener()
        Utility.hideTooltip() -- Ensure tooltip is hidden
        if LuminaUI.RootInstance == screenGui then LuminaUI.RootInstance = nil end
    end)

    return screenGui
end

local function _createKeySystem(parent, settings, theme)
    if not settings.KeySystem or not settings.KeySystem.Enabled then return true end -- Key system not enabled or needed

    local keyAccepted = false
    local connections = {}

    local keySystemFrame = Utility.createInstance("Frame", {
        Name = "KeySystem",
        Size = UDim2.new(0, 320, 0, 150),
        Position = settings.UIPosition or UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Background,
        Parent = parent
    })
    Utility.createCorner(keySystemFrame, 6)
    Utility.registerThemedElement(keySystemFrame, "BackgroundColor3", "Background")
    Utility.manageConnections(keySystemFrame) -- Manage connections for this frame

    local keyTitle = Utility.createInstance("TextLabel", {
        Name = "Title", Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "Key System", TextColor3 = theme.TextColor, TextSize = 16, Parent = keySystemFrame
    })
    Utility.registerThemedElement(keyTitle, "TextColor3", "TextColor")

    local keyDescription = Utility.createInstance("TextLabel", {
        Name = "Description", Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = settings.KeySystem.Message or "Please enter the key to access this script", TextColor3 = theme.SubTextColor, TextSize = 14, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center, Parent = keySystemFrame
    })
    Utility.registerThemedElement(keyDescription, "TextColor3", "SubTextColor")

    local keyTextbox = Utility.createInstance("TextBox", {
        Name = "KeyInput", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 75), BackgroundColor3 = theme.InputBackground, PlaceholderText = "Enter Key", PlaceholderColor3 = theme.InputPlaceholder, Text = "", TextColor3 = theme.TextColor, Font = Enum.Font.Gotham, TextSize = 14, ClearTextOnFocus = false, Parent = keySystemFrame
    })
    Utility.createCorner(keyTextbox, 4)
    local keyStroke = Utility.createStroke(keyTextbox, theme.InputStroke, 1)
    Utility.registerThemedElement(keyTextbox, "BackgroundColor3", "InputBackground")
    Utility.registerThemedElement(keyTextbox, "PlaceholderColor3", "InputPlaceholder")
    Utility.registerThemedElement(keyTextbox, "TextColor3", "TextColor")
    Utility.registerThemedElement(keyStroke, "Color", "InputStroke")

    local submitButton = Utility.createInstance("TextButton", {
        Name = "Submit", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 110), BackgroundColor3 = theme.ElementBackground, Font = Enum.Font.GothamBold, Text = "Submit", TextColor3 = theme.TextColor, TextSize = 14, Parent = keySystemFrame
    })
    Utility.createCorner(submitButton, 4)
    local submitStroke = Utility.createStroke(submitButton, theme.ElementStroke, 1)
    Utility.registerThemedElement(submitButton, "BackgroundColor3", "ElementBackground")
    Utility.registerThemedElement(submitButton, "TextColor3", "TextColor")
    Utility.registerThemedElement(submitStroke, "Color", "ElementStroke")

    -- Effects
    keySystemFrame:AddConnection(submitButton.MouseEnter:Connect(function() TweenService:Create(submitButton, TweenInfo.new(0.2), { BackgroundColor3 = theme.ElementBackgroundHover }):Play() end))
    keySystemFrame:AddConnection(submitButton.MouseLeave:Connect(function() TweenService:Create(submitButton, TweenInfo.new(0.2), { BackgroundColor3 = theme.ElementBackground }):Play() end))

    local function checkKey(key)
        return (settings.KeySystem.Key == key) or
               (type(settings.KeySystem.Keys) == "table" and table.find(settings.KeySystem.Keys, key)) or
               false
    end

    keySystemFrame:AddConnection(submitButton.MouseButton1Click:Connect(function()
        if checkKey(keyTextbox.Text) then
            keyAccepted = true
            keySystemFrame:Destroy() -- Destroys frame and disconnects its connections
        else
            keyTextbox.Text = ""
            local originalColor = keyTextbox.BackgroundColor3
            TweenService:Create(keyTextbox, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), { BackgroundColor3 = Color3.fromRGB(255, 80, 80) }):Play()
        end
    end))

    -- Make draggable
    Utility.makeDraggable(keySystemFrame)

    -- Wait for key
    while not keyAccepted do
        task.wait()
        if not keySystemFrame or not keySystemFrame.Parent then return false end -- Stop if UI closed during key entry
    end
    return true
end

local function _createMainFrame(parent, settings, theme, initialPos)
    local mainFrame = Utility.createInstance("Frame", {
        Name = "MainFrame",
        Size = settings.Size,
        Position = initialPos or UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true, -- Important for minimize animation
        Parent = parent
    })
    Utility.createCorner(mainFrame, 8)
    Utility.registerThemedElement(mainFrame, "BackgroundColor3", "Background")
    Utility.manageConnections(mainFrame) -- Manage connections

    -- Shadow
    local shadow = Utility.createInstance("ImageLabel", {
        Name = "Shadow", AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 35, 1, 35), ZIndex = -1, Image = "rbxassetid://5554236805", ImageColor3 = theme.Shadow, ImageTransparency = 0.6, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(23, 23, 277, 277), SliceScale = 1, Parent = mainFrame
    })
    Utility.registerThemedElement(shadow, "ImageColor3", "Shadow")

    return mainFrame
end

local function _createTopbar(parent, settings, theme)
    local topbar = Utility.createInstance("Frame", {
        Name = "Topbar", Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = theme.Topbar, BorderSizePixel = 0, Parent = parent, ZIndex = 2
    })
    Utility.createCorner(topbar, 8) -- Apply corner to topbar itself
    Utility.registerThemedElement(topbar, "BackgroundColor3", "Topbar")

    -- Corner fix (covers bottom corners of the topbar's rounding)
    local cornerFix = Utility.createInstance("Frame", {
        Name = "CornerFix", Size = UDim2.new(1, 0, 0.5, 1), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = theme.Topbar, BorderSizePixel = 0, ZIndex = 1, Parent = topbar
    })
    Utility.registerThemedElement(cornerFix, "BackgroundColor3", "Topbar")

    local titleX = 15
    if settings.Icon and settings.Icon ~= 0 then
        local icon = Utility.createInstance("ImageLabel", {
            Name = "Icon", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 12, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(settings.Icon), ZIndex = 3, Parent = topbar
        })
        -- No theme registration needed for icon image itself unless colorable
        titleX = 40
    end

    local topbarTitle = Utility.createInstance("TextLabel", {
        Name = "Title", Size = UDim2.new(1, -(titleX + 90), 1, 0), Position = UDim2.new(0, titleX, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = settings.Name, TextColor3 = theme.TextColor, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3, Parent = topbar
    })
    Utility.registerThemedElement(topbarTitle, "TextColor3", "TextColor")

    -- Control Buttons
    local buttonSize = UDim2.new(0, 18, 0, 18)
    local buttonY = 0.5
    local buttonTransparency = 0.2 -- Initial transparency

    local closeButton = Utility.createInstance("ImageButton", {
        Name = "Close", Size = buttonSize, Position = UDim2.new(1, -15, buttonY, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://6035047409", ImageColor3 = theme.TextColor, ImageTransparency = buttonTransparency, ZIndex = 3, Parent = topbar
    })
    Utility.registerThemedElement(closeButton, "ImageColor3", "TextColor")

    local minimizeButton = Utility.createInstance("ImageButton", {
        Name = "Minimize", Size = buttonSize, Position = UDim2.new(1, -45, buttonY, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://6035067836", ImageColor3 = theme.TextColor, ImageTransparency = buttonTransparency, ZIndex = 3, Parent = topbar
    })
    Utility.registerThemedElement(minimizeButton, "ImageColor3", "TextColor")

    local settingsButton = Utility.createInstance("ImageButton", {
        Name = "Settings", Size = buttonSize, Position = UDim2.new(1, -75, buttonY, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://6031280882", ImageColor3 = theme.TextColor, ImageTransparency = buttonTransparency, ZIndex = 3, Parent = topbar
    })
    Utility.registerThemedElement(settingsButton, "ImageColor3", "TextColor")

    -- Hover Effects for controls
    local tweenInfoHover = TweenInfo.new(0.2)
    for _, button in ipairs({closeButton, minimizeButton, settingsButton}) do
        parent:AddConnection(button.MouseEnter:Connect(function() TweenService:Create(button, tweenInfoHover, { ImageTransparency = 0 }):Play() end))
        parent:AddConnection(button.MouseLeave:Connect(function() TweenService:Create(button, tweenInfoHover, { ImageTransparency = buttonTransparency }):Play() end))
        parent:AddConnection(button.MouseButton1Click:Connect(function() Utility.rippleEffect(button, Color3.new(1,1,1)) end)) -- Add ripple
    end

    return topbar, closeButton, minimizeButton, settingsButton
end

local function _createContentContainer(parent)
    local container = Utility.createInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -10, 1, -55 - 30), -- Adjusted for credits height
        Position = UDim2.new(0, 5, 0, 50),
        BackgroundTransparency = 1,
        Parent = parent,
        ZIndex = 1
    })
    return container
end

local function _createTabContainer(parent, theme)
    local tabContainer = Utility.createInstance("Frame", {
        Name = "TabContainer", Size = UDim2.new(0, 130, 1, 0), BackgroundTransparency = 1, Parent = parent
    })

    local tabScrollFrame = Utility.createInstance("ScrollingFrame", {
        Name = "TabScrollFrame", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(0,0,0,0), Parent = tabContainer
    })
    Utility.applyCustomScrollbar(tabScrollFrame, theme, 4) -- Apply scrollbar

    Utility.createInstance("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabScrollFrame })
    Utility.createInstance("UIPadding", { PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), Parent = tabScrollFrame })

    return tabContainer, tabScrollFrame
end

local function _createElementsContainer(parent)
    local elementsContainer = Utility.createInstance("Frame", {
        Name = "ElementsContainer", Size = UDim2.new(1, -140, 1, 0), Position = UDim2.new(0, 140, 0, 0), BackgroundTransparency = 1, ClipsDescendants = true, Parent = parent
    })

    local elementsPageFolder = Utility.createInstance("Folder", { Name = "Pages", Parent = elementsContainer })

    return elementsContainer, elementsPageFolder
end

local function _createSettingsPage(parentFolder, settings, theme, windowApi)
    local settingsPage = Utility.createInstance("ScrollingFrame", {
        Name = "Settings", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), Visible = false, Parent = parentFolder
    })
    Utility.manageConnections(settingsPage) -- Manage connections

    local listLayout = Utility.createInstance("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = settingsPage })
    Utility.createInstance("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = settingsPage }) -- Added bottom padding

    -- Auto-size canvas
    settingsPage:AddConnection(listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        settingsPage.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16) -- Add padding to bottom
    end))

    -- Apply custom scrollbar
    Utility.applyCustomScrollbar(settingsPage, theme)

    -- Theme Section Title
    local themeTitleFrame = Utility.createInstance("Frame", { Name = "ThemeSectionTitle", Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = settingsPage, LayoutOrder = 1 })
    local themeTitleText = Utility.createInstance("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "Theme Settings", TextColor3 = theme.TextColor, TextSize = 14, TextTransparency = 0.4, TextXAlignment = Enum.TextXAlignment.Left, Parent = themeTitleFrame })
    Utility.registerThemedElement(themeTitleText, "TextColor3", "TextColor")

    -- Theme Buttons Container (using UIGridLayout)
    local themeButtonsContainer = Utility.createInstance("Frame", {
        Name = "ThemeButtonsContainer",
        Size = UDim2.new(1, 0, 0, 100), -- Initial height, adjust based on grid
        BackgroundTransparency = 1,
        Parent = settingsPage,
        LayoutOrder = 2
    })
    local gridLayout = Utility.createInstance("UIGridLayout", {
        CellPadding = UDim2.new(0, 10, 0, 10),
        CellSize = UDim2.new(0, 90, 0, 90),
        StartCorner = Enum.StartCorner.TopLeft,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = themeButtonsContainer
    })

    local function createThemeButton(themeName)
        local themeData = LuminaUI.Theme[themeName]
        local buttonFrame = Utility.createInstance("Frame", { Name = themeName.."Theme", Size = UDim2.new(0, 90, 0, 90), BackgroundColor3 = themeData.ElementBackground, Parent = themeButtonsContainer })
        Utility.createCorner(buttonFrame, 6)
        local stroke = Utility.createStroke(buttonFrame, theme.ElementStroke, 1) -- Use current theme for stroke initially
        -- Register for updates based on the theme it represents
        Utility.registerThemedElement(buttonFrame, "BackgroundColor3", "ElementBackground") -- This will update based on the *selected* theme, maybe not ideal? Let's keep it simple for now.
        Utility.registerThemedElement(stroke, "Color", "ElementStroke")

        local preview = Utility.createInstance("Frame", { Name = "Preview", Size = UDim2.new(1, -10, 0, 30), Position = UDim2.new(0, 5, 0, 5), BackgroundColor3 = themeData.Topbar, Parent = buttonFrame })
        Utility.createCorner(preview, 4)

        local color1 = Utility.createInstance("Frame", { Name = "Color1", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 5, 0, 40), BackgroundColor3 = themeData.ToggleEnabled, Parent = buttonFrame })
        Utility.createCorner(color1, 4)

        local color2 = Utility.createInstance("Frame", { Name = "Color2", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 30, 0, 40), BackgroundColor3 = themeData.SliderProgress, Parent = buttonFrame })
        Utility.createCorner(color2, 4)

        local text = Utility.createInstance("TextLabel", { Name = "Text", Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 65), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = themeName, TextColor3 = themeData.TextColor, TextSize = 12, Parent = buttonFrame })

        local interact = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = buttonFrame })

        settingsPage:AddConnection(interact.MouseButton1Click:Connect(function()
            windowApi:SetTheme(themeName) -- Use the API method to apply theme
        end))
        settingsPage:AddConnection(interact.MouseEnter:Connect(function() TweenService:Create(buttonFrame, TweenInfo.new(0.2), { BackgroundColor3 = Utility.lighter(buttonFrame.BackgroundColor3, 0.1) }):Play() end))
        settingsPage:AddConnection(interact.MouseLeave:Connect(function() TweenService:Create(buttonFrame, TweenInfo.new(0.2), { BackgroundColor3 = themeData.ElementBackground }):Play() end)) -- Revert to its own theme bg

        return buttonFrame
    end

    -- Create buttons for each theme
    for themeName, _ in pairs(LuminaUI.Theme) do
        createThemeButton(themeName)
    end

    -- Adjust container height based on grid content
    task.wait() -- Wait for grid layout
    local contentHeight = gridLayout.AbsoluteContentSize.Y
    themeButtonsContainer.Size = UDim2.new(1, 0, 0, contentHeight)

    return settingsPage
end

local function _createNotificationsContainer(parent)
    local notifications = Utility.createInstance("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 260, 1, -10), -- Size relative to parent (ScreenGui)
        Position = UDim2.new(1, -280, 0, 5), -- Position relative to parent
        BackgroundTransparency = 1,
        Parent = parent,
        ZIndex = 500 -- High ZIndex for notifications
    })

    Utility.createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom, -- Show newest at bottom
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = notifications
    })

    return notifications
end

local function _createCreditsSection(parent, theme, windowApi)
     local creditsSection = Utility.createInstance("Frame", {
        Name = "Credits",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 1, -30), -- Anchor to bottom
        AnchorPoint = Vector2.new(0, 1), -- Anchor to bottom
        BackgroundColor3 = Utility.darker(theme.ElementBackground, 0.1),
        Parent = parent,
        ZIndex = 2
    })
    Utility.registerThemedElement(creditsSection, "BackgroundColor3", "ElementBackground", nil, function(c) return Utility.darker(c, 0.1) end) -- Special darker logic

    local creditText = Utility.createInstance("TextLabel", {
        Name = "CreditText", Size = UDim2.new(0.7, -120, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "LuminaUI by Supergoatscriptguy", TextColor3 = theme.SubTextColor, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0, 10, 0, 0), Parent = creditsSection
    })
    Utility.registerThemedElement(creditText, "TextColor3", "SubTextColor")

    local discordButton = Utility.createInstance("TextButton", {
        Name = "DiscordButton", Size = UDim2.new(0, 100, 0, 22), Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(88, 101, 242), Font = Enum.Font.GothamBold, Text = "Join Discord", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Parent = creditsSection
    })
    Utility.createCorner(discordButton, 4)

    parent:AddConnection(discordButton.MouseButton1Click:Connect(function()
        local discordLink = "https://discord.gg/KgvmCnZ88n" -- Updated link
        if setclipboard then
            local success, err = Utility.safeCall(setclipboard, discordLink)
            if success then
                windowApi:CreateNotification({ Title = "Discord", Content = "Invite link copied!", Duration = 3 })
            else
                 windowApi:CreateNotification({ Title = "Error", Content = "Failed to copy link.", Duration = 3 })
                 warn("[LuminaUI] Failed to set clipboard:", err)
            end
        else
            windowApi:CreateNotification({ Title = "Error", Content = "'setclipboard' not available.", Duration = 3 })
        end
    end))
     parent:AddConnection(discordButton.MouseEnter:Connect(function() Utility.pulseEffect(discordButton, 1.03, 0.1) end))

    return creditsSection
end


-- Main Window Creation Function
function LuminaUI:CreateWindow(settings)
    settings = settings or {}
    settings.Name = settings.Name or "LuminaUI"
    settings.Theme = settings.Theme or "Default"
    settings.Size = settings.Size or UDim2.new(0, 550, 0, 475)
    settings.Icon = settings.Icon or 0
    settings.ConfigurationSaving = settings.ConfigurationSaving or { Enabled = true, FileName = "LuminaConfig" } -- Default enabled
    settings.KeySystem = settings.KeySystem or { Enabled = false }

    -- Select initial theme
    local currentThemeName = settings.Theme
    local currentTheme = LuminaUI.Theme[currentThemeName] or LuminaUI.Theme.Default
    if not LuminaUI.Theme[currentThemeName] then
        warn("[LuminaUI] Invalid theme name '"..tostring(currentThemeName).."' provided. Using Default.")
        currentThemeName = "Default"
    end

    -- Create Base ScreenGui
    local screenGui = _createBaseUI(settings)

    -- Load Configuration (before creating main frame to get position)
    local loadedConfig = Utility.loadConfig(settings)
    local initialPosition = loadedConfig.UIPosition or settings.UIPosition -- Use loaded position if available

    -- Create Key System (if enabled, waits for key)
    local keyCheckPassed = _createKeySystem(screenGui, settings, currentTheme)
    if not keyCheckPassed then
        -- UI was likely closed during key entry, cleanup and exit
        if screenGui and screenGui.Parent then screenGui:Destroy() end
        return nil
    end

    -- Create Main UI Elements
    local mainFrame = _createMainFrame(screenGui, settings, currentTheme, initialPosition)
    local topbar, closeButton, minimizeButton, settingsButton = _createTopbar(mainFrame, settings, currentTheme)
    local contentContainer = _createContentContainer(mainFrame)
    local tabContainer, tabScrollFrame = _createTabContainer(contentContainer, currentTheme)
    local elementsContainer, elementsPageFolder = _createElementsContainer(contentContainer)
    local notificationsContainer = _createNotificationsContainer(screenGui) -- Parent to ScreenGui

    -- Window API Table (forward declaration needed for settings page and credits)
    local Window = {
        Instance = mainFrame,
        Tabs = {},
        TabGroups = {},
        CurrentTheme = currentTheme,
        CurrentThemeName = currentThemeName,
        Settings = settings, -- Store settings
        _connections = {}, -- For window-level connections
        _components = {}, -- Store references to created components (buttons, sliders etc.) for theme updates
        _activeTab = nil,
        _activePage = nil,
        _settingsPage = nil,
        _tabScrollFrame = tabScrollFrame,
        _elementsPageFolder = elementsPageFolder,
        _notificationsContainer = notificationsContainer
    }
    Utility.manageConnections(Window) -- Manage connections for the Window object itself

    -- Create Settings Page (needs Window API reference for SetTheme)
    local settingsPage = _createSettingsPage(elementsPageFolder, settings, currentTheme, Window)
    Window._settingsPage = settingsPage

    -- Create Credits Section (needs Window API for notifications)
    local creditsSection = _createCreditsSection(mainFrame, currentTheme, Window)

    -- Apply loaded element values (after elements are potentially created)
    local function applyLoadedConfigValues()
         if loadedConfig.Elements then
            for flag, data in pairs(loadedConfig.Elements) do
                if LuminaUI.Flags[flag] and LuminaUI.Flags[flag].ComponentRef and LuminaUI.Flags[flag].ComponentRef.SetValue then
                    -- Check type match for safety? Maybe not strictly necessary if flags are unique.
                    -- if LuminaUI.Flags[flag].Type == data.Type then
                        Utility.safeCall(LuminaUI.Flags[flag].ComponentRef.SetValue, LuminaUI.Flags[flag].ComponentRef, data.Value)
                    -- end
                end
            end
        end
    end

    -- Function to select a tab visually and show its page
    function Window:_selectTab(tabButton, tabPage)
        if not tabButton or not tabPage then return end
        if self._activeTab == tabButton then return end -- Already selected

        local isSettings = (tabButton == settingsButton) -- Check if settings button triggered this

        -- Deselect previous tab and hide previous page
        if self._activeTab and self._activeTab.Parent then
            local prevTabTitle = self._activeTab:FindFirstChild("Title")
            local prevTabIcon = self._activeTab:FindFirstChild("Icon")
            local prevStroke = self._activeTab:FindFirstChildOfClass("UIStroke")

            TweenService:Create(self._activeTab, TweenInfo.new(0.2), { BackgroundColor3 = self.CurrentTheme.TabBackground, BackgroundTransparency = 0.7 }):Play()
            if prevTabTitle then TweenService:Create(prevTabTitle, TweenInfo.new(0.2), { TextColor3 = self.CurrentTheme.TabTextColor, TextTransparency = 0.2 }):Play() end
            if prevTabIcon then TweenService:Create(prevTabIcon, TweenInfo.new(0.2), { ImageColor3 = self.CurrentTheme.TabTextColor, ImageTransparency = 0.2 }):Play() end
            if prevStroke then prevStroke.Enabled = true end
        end
        if self._activePage and self._activePage.Parent then
            self._activePage.Visible = false
        end

        -- Select new tab and show new page
        local tabTitle = tabButton:FindFirstChild("Title")
        local tabIcon = tabButton:FindFirstChild("Icon")
        local stroke = tabButton:FindFirstChildOfClass("UIStroke")

        if not isSettings then -- Don't highlight tab button if settings opened
             TweenService:Create(tabButton, TweenInfo.new(0.2), { BackgroundColor3 = self.CurrentTheme.TabBackgroundSelected, BackgroundTransparency = 0 }):Play()
             if tabTitle then TweenService:Create(tabTitle, TweenInfo.new(0.2), { TextColor3 = self.CurrentTheme.SelectedTabTextColor, TextTransparency = 0 }):Play() end
             if tabIcon then
                 TweenService:Create(tabIcon, TweenInfo.new(0.2), { ImageColor3 = self.CurrentTheme.SelectedTabTextColor, ImageTransparency = 0 }):Play()
                 Utility.pulseEffect(tabIcon)
             end
             if stroke then stroke.Enabled = false end -- Hide stroke on selected tab
             self._activeTab = tabButton
        else
             self._activeTab = nil -- No tab is active when settings are open
        end

        tabPage.Visible = true
        if tabPage:IsA("ScrollingFrame") then
            tabPage.CanvasPosition = Vector2.new(0, 0) -- Scroll to top
        end
        self._activePage = tabPage

        -- Ensure settings page is hidden if a regular tab is selected
        if not isSettings and self._settingsPage then
            self._settingsPage.Visible = false
        end
    end

    -- Topbar Button Functionality
    Window:AddConnection(closeButton.MouseButton1Click:Connect(function()
        local position = mainFrame.Position
        Utility.saveConfig(settings, position) -- Save config before closing

        -- Close animation
        local tweenInfoClose = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local sizeTween = TweenService:Create(mainFrame, tweenInfoClose, { Size = UDim2.new(settings.Size.X.Scale, settings.Size.X.Offset, 0, 0) })
        local posTween = TweenService:Create(mainFrame, tweenInfoClose, { Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + mainFrame.AbsoluteSize.Y / 2) })

        sizeTween:Play()
        posTween:Play()

        posTween.Completed:Connect(function()
            screenGui:Destroy() -- Destroy the root ScreenGui
        end)
    end))

    local minimized = false
    local restoreButton = nil
    Window:AddConnection(minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize
        local tweenInfoMinimize = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        if minimized then
            targetSize = UDim2.new(settings.Size.X.Scale, settings.Size.X.Offset, 0, topbar.AbsoluteSize.Y)
            minimizeButton.Visible = false

            -- Create restore button if it doesn't exist
            if not restoreButton or not restoreButton.Parent then
                restoreButton = Utility.createInstance("ImageButton", {
                    Name = "Restore", Size = minimizeButton.Size, Position = minimizeButton.Position, AnchorPoint = minimizeButton.AnchorPoint, BackgroundTransparency = 1, Image = minimizeButton.Image, ImageColor3 = minimizeButton.ImageColor3, ImageTransparency = 0, Rotation = 180, ZIndex = 3, Parent = topbar
                })
                Utility.registerThemedElement(restoreButton, "ImageColor3", "TextColor") -- Theme registration
                -- Add hover effects for restore button
                 mainFrame:AddConnection(restoreButton.MouseEnter:Connect(function() TweenService:Create(restoreButton, TweenInfo.new(0.2), { ImageTransparency = 0 }):Play() end))
                 mainFrame:AddConnection(restoreButton.MouseLeave:Connect(function() TweenService:Create(restoreButton, TweenInfo.new(0.2), { ImageTransparency = 0.2 }):Play() end))
                 mainFrame:AddConnection(restoreButton.MouseButton1Click:Connect(function() minimizeButton.MouseButton1Click:Fire() end)) -- Trigger minimize logic again to restore
            end
            restoreButton.Visible = true

        else
            targetSize = settings.Size
            minimizeButton.Visible = true
            if restoreButton and restoreButton.Parent then
                restoreButton.Visible = false -- Hide restore button
            end
        end

        TweenService:Create(mainFrame, tweenInfoMinimize, { Size = targetSize }):Play()
    end))

    Window:AddConnection(settingsButton.MouseButton1Click:Connect(function()
        local isOpeningSettings = not self._settingsPage.Visible
        if isOpeningSettings then
            self:_selectTab(settingsButton, self._settingsPage) -- Pass settingsButton to indicate settings context
        else
            -- If closing settings, select the first available tab
            local firstTabButton = nil
            for _, child in ipairs(self._tabScrollFrame:GetChildren()) do
                 if child:IsA("Frame") and child:FindFirstChild("Interact") and child.Name ~= "Header" then -- Find first actual tab button
                    firstTabButton = child
                    break
                 end
            end
            if firstTabButton then
                 local page = self._elementsPageFolder:FindFirstChild(firstTabButton.Name)
                 if page then
                     self:_selectTab(firstTabButton, page)
                 end
            else
                 -- No tabs exist, just hide settings
                 self._settingsPage.Visible = false
                 self._activePage = nil
                 self._activeTab = nil
            end
        end
    end))

    -- Make draggable
    Utility.makeDraggable(mainFrame, topbar)

    -- Window API Methods
    function Window:SetTheme(themeName)
        if not LuminaUI.Theme[themeName] then
            warn("[LuminaUI] Invalid theme name:", themeName)
            return
        end
        self.CurrentThemeName = themeName
        self.CurrentTheme = LuminaUI.Theme[themeName]
        self.Settings.Theme = themeName -- Update settings table

        -- Apply theme to all registered elements
        Utility.applyThemeToAll(self.CurrentTheme)

        -- Manually update elements not easily covered by registry (like hover states if needed)
        -- Example: Re-apply scrollbar themes
        for _, child in ipairs(self._elementsPageFolder:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                 local scrollbar = child:FindFirstChild("CustomScrollbar")
                 if scrollbar then
                     local thumb = scrollbar:FindFirstChild("ScrollThumb")
                     scrollbar.BackgroundColor3 = self.CurrentTheme.ScrollBarBackground
                     if thumb then thumb.BackgroundColor3 = self.CurrentTheme.ScrollBarForeground end
                 end
            end
        end
         local tabScrollbar = self._tabScrollFrame:FindFirstChild("CustomScrollbar")
         if tabScrollbar then
             local thumb = tabScrollbar:FindFirstChild("ScrollThumb")
             tabScrollbar.BackgroundColor3 = self.CurrentTheme.ScrollBarBackground
             if thumb then thumb.BackgroundColor3 = self.CurrentTheme.ScrollBarForeground end
         end
    end

    function Window:CreateNotification(notificationSettings)
        notificationSettings = notificationSettings or {}
        local title = notificationSettings.Title or "Notification"
        local content = notificationSettings.Content or "Content"
        local duration = notificationSettings.Duration or 5
        local iconId = notificationSettings.Icon or 0
        local theme = self.CurrentTheme

        local notification = Utility.createInstance("Frame", {
            Name = "Notification",
            Size = UDim2.new(1, 0, 0, 65), -- Fixed height based on content below
            BackgroundColor3 = theme.NotificationBackground,
            BackgroundTransparency = 1, -- Start transparent
            Position = UDim2.new(0, 0, 0, 20), -- Start offset for animation
            Parent = self._notificationsContainer,
            ClipsDescendants = true
        })
        Utility.createCorner(notification, 6)
        Utility.manageConnections(notification) -- Manage connections

        local contentPadding = 8
        local iconSize = (iconId ~= 0) and 24 or 0
        local textX = contentPadding + (iconId ~= 0 and (iconSize + contentPadding) or 0)
        local textWidth = notification.AbsoluteSize.X - textX - contentPadding - 16 -- Subtract close button space

        if iconId ~= 0 then
            local icon = Utility.createInstance("ImageLabel", {
                Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, contentPadding, 0.5, -iconSize/2 - 5), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(iconId), ImageTransparency = 1, Parent = notification
            })
             TweenService:Create(icon, TweenInfo.new(0.4), { ImageTransparency = 0 }):Play()
        end

        local titleLabel = Utility.createInstance("TextLabel", {
            Name = "Title", Size = UDim2.new(0, textWidth, 0, 18), Position = UDim2.new(0, textX, 0, contentPadding), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = title, TextColor3 = theme.TextColor, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, Parent = notification
        })

        local bodyLabel = Utility.createInstance("TextLabel", {
            Name = "Body", Size = UDim2.new(0, textWidth, 0, 30), Position = UDim2.new(0, textX, 0, contentPadding + 20), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = content, TextColor3 = theme.SubTextColor, TextSize = 13, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextTransparency = 1, Parent = notification
        })

        -- Adjust height based on text bounds if needed (more complex)
        -- local titleBounds = Utility.getTextBounds(title, titleLabel.Font, titleLabel.TextSize, textWidth)
        -- local bodyBounds = Utility.getTextBounds(content, bodyLabel.Font, bodyLabel.TextSize, textWidth)
        -- local requiredHeight = contentPadding * 2 + titleBounds.Y + bodyBounds.Y + 4 -- Approx
        -- notification.Size = UDim2.new(1, 0, 0, math.max(65, requiredHeight))

        -- Progress Bar
        local progressBar = Utility.createInstance("Frame", { Name = "ProgressBar", Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, -3), AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = theme.ProgressBarBackground, BackgroundTransparency = 0.5, Parent = notification })
        local progressFill = Utility.createInstance("Frame", { Name = "Progress", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = theme.ProgressBarFill, Parent = progressBar })
        Utility.createCorner(progressFill, 3) -- Round the fill bar

        -- Close Button
        local closeNotifButton = Utility.createInstance("ImageButton", { Name = "Close", Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -contentPadding, 0, contentPadding), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Image = "rbxassetid://6035047409", ImageColor3 = theme.TextColor, ImageTransparency = 1, ZIndex = notification.ZIndex + 1, Parent = notification })

        local function destroyNotification(animated)
            if not notification or not notification.Parent then return end
            local notifRef = notification -- Keep reference
            notification = nil -- Prevent re-entry

            notifRef:DisconnectAll() -- Disconnect listeners

            if animated then
                local outTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(notifRef, outTweenInfo, { BackgroundTransparency = 1, Position = notifRef.Position + UDim2.new(0, 0, 0, 20) }):Play()
                TweenService:Create(titleLabel, outTweenInfo, { TextTransparency = 1 }):Play()
                TweenService:Create(bodyLabel, outTweenInfo, { TextTransparency = 1 }):Play()
                if closeNotifButton and closeNotifButton.Parent then TweenService:Create(closeNotifButton, outTweenInfo, { ImageTransparency = 1 }):Play() end
                -- Fade out icon if exists
                local icon = notifRef:FindFirstChild("Icon")
                if icon then TweenService:Create(icon, outTweenInfo, { ImageTransparency = 1 }):Play() end

                task.wait(0.3)
            end
            Utility.destroyInstance(notifRef)
        end

        notification:AddConnection(closeNotifButton.MouseButton1Click:Connect(function() destroyNotification(true) end))
        notification:AddConnection(closeNotifButton.MouseEnter:Connect(function() TweenService:Create(closeNotifButton, TweenInfo.new(0.2), { ImageTransparency = 0 }):Play() end))
        notification:AddConnection(closeNotifButton.MouseLeave:Connect(function() TweenService:Create(closeNotifButton, TweenInfo.new(0.2), { ImageTransparency = 0.5 }):Play() end))

        -- Intro Animation
        local inTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out) -- Use Back easing
        TweenService:Create(notification, inTweenInfo, { BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0) }):Play()
        TweenService:Create(titleLabel, inTweenInfo, { TextTransparency = 0 }):Play()
        TweenService:Create(bodyLabel, inTweenInfo, { TextTransparency = 0 }):Play()
        TweenService:Create(closeNotifButton, inTweenInfo, { ImageTransparency = 0.5 }):Play()

        -- Progress and Auto-Destroy
        local progressTween = TweenService:Create(progressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) })
        progressTween:Play()
        notification:AddConnection(progressTween.Completed:Connect(function() destroyNotification(true) end))

        return notification -- Return the instance if needed externally
    end

    function Window:CreateTab(tabName, iconId)
        local theme = self.CurrentTheme
        local tabIconId = iconId or 0

        local tabButton = Utility.createInstance("Frame", {
            Name = tabName, Size = UDim2.new(1, -10, 0, 34), BackgroundColor3 = theme.TabBackground, BackgroundTransparency = 0.7, Parent = self._tabScrollFrame
        })
        Utility.createCorner(tabButton, 6)
        local stroke = Utility.createStroke(tabButton, theme.ElementStroke, 1, 0.5) -- Use ElementStroke for tabs
        stroke.Name = "TabStroke" -- For potential specific theme updates
        Utility.registerThemedElement(tabButton, "BackgroundColor3", "TabBackground")
        Utility.registerThemedElement(stroke, "Color", "ElementStroke")
        Utility.manageConnections(tabButton) -- Manage connections

        local iconSize = 16
        local iconPadding = (tabIconId ~= 0) and (iconSize + 8) or 0 -- Space for icon + padding

        if tabIconId ~= 0 then
            local tabIcon = Utility.createInstance("ImageLabel", {
                Name = "Icon", Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(tabIconId), ImageColor3 = theme.TabTextColor, ImageTransparency = 0.2, Parent = tabButton
            })
            Utility.registerThemedElement(tabIcon, "ImageColor3", "TabTextColor")
        end

        local tabTitle = Utility.createInstance("TextLabel", {
            Name = "Title", Size = UDim2.new(1, -(10 + iconPadding + 10), 1, 0), -- Left padding + icon area + right padding
            Position = UDim2.new(0, 10 + iconPadding, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = tabName, TextColor3 = theme.TabTextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 0.2, Parent = tabButton
        })
        Utility.registerThemedElement(tabTitle, "TextColor3", "TabTextColor")

        local tabInteract = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = tabButton })

        -- Create Page
        local tabPage = Utility.createInstance("ScrollingFrame", {
            Name = tabName, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), Visible = false, ScrollingDirection = Enum.ScrollingDirection.Y, Parent = self._elementsPageFolder
        })
        Utility.manageConnections(tabPage) -- Manage page connections

        local listLayout = Utility.createInstance("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabPage })
        Utility.createInstance("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = tabPage })

        -- Auto-size canvas
        tabPage:AddConnection(listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabPage.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16) -- Add padding
        end))

        -- Apply custom scrollbar
        Utility.applyCustomScrollbar(tabPage, theme)

        -- Tab Selection Logic
        tabButton:AddConnection(tabInteract.MouseButton1Click:Connect(function()
            self:_selectTab(tabButton, tabPage)
        end))

        -- Tab Object API
        local Tab = {
            Instance = tabButton,
            Page = tabPage,
            _connections = {},
            _components = {} -- Store components created within this tab
        }
        Utility.manageConnections(Tab) -- Manage connections for the Tab object itself

        -- Register tab button and page for potential theme updates (though handled by _selectTab mostly)
        table.insert(self.Tabs, Tab)

        -- Component Creation Methods (Nested within Tab)
        function Tab:CreateSection(sectionName)
            local sectionContainer = Utility.createInstance("Frame", { Name = "Section_" .. sectionName, Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = self.Page })
            Utility.manageConnections(sectionContainer) -- Manage connections

            local sectionTitle = Utility.createInstance("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 0, 26), Position = UDim2.new(0, 0, 0, 5), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = sectionName, TextColor3 = Window.CurrentTheme.TextColor, TextSize = 14, TextTransparency = 0.2, TextXAlignment = Enum.TextXAlignment.Left, Parent = sectionContainer })
            Utility.registerThemedElement(sectionTitle, "TextColor3", "TextColor")

            local sectionLine = Utility.createInstance("Frame", { Name = "Line", Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -5), AnchorPoint = Vector2.new(0,1), BackgroundColor3 = Window.CurrentTheme.ElementStroke, BackgroundTransparency = 0.5, Parent = sectionContainer })
            Utility.registerThemedElement(sectionLine, "BackgroundColor3", "ElementStroke")

            table.insert(self._components, sectionContainer) -- Track for potential cleanup/theming
            return sectionContainer -- Return instance for layout order or direct manipulation
        end

        function Tab:CreateButton(options)
            options = options or {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end
            local iconId = options.Icon or 0
            local tooltipText = options.Tooltip or nil
            local theme = Window.CurrentTheme

            local buttonContainer = Utility.createInstance("Frame", { Name = "Button_" .. name, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = theme.ElementBackground, Parent = self.Page })
            Utility.createCorner(buttonContainer, 4)
            Utility.registerThemedElement(buttonContainer, "BackgroundColor3", "ElementBackground", "ElementBackgroundHover") -- Register hover state key
            Utility.manageConnections(buttonContainer)

            local iconPadding = 0
            if iconId ~= 0 then
                local buttonIcon = Utility.createInstance("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(iconId), ImageColor3 = theme.TextColor, Parent = buttonContainer })
                Utility.registerThemedElement(buttonIcon, "ImageColor3", "TextColor")
                iconPadding = 30
            end

            local buttonTitle = Utility.createInstance("TextLabel", { Name = "Title", Size = UDim2.new(1, -(10 + iconPadding), 1, 0), Position = UDim2.new(0, 10 + iconPadding, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = name, TextColor3 = theme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = buttonContainer })
            Utility.registerThemedElement(buttonTitle, "TextColor3", "TextColor")

            local buttonInteract = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = buttonContainer })

            -- Effects & Callback
            local hoverColor = theme.ElementBackgroundHover
            local normalColor = theme.ElementBackground
            local clickColor = Utility.darker(hoverColor, 0.1)
            local tweenInfo = TweenInfo.new(0.15)

            buttonContainer:AddConnection(buttonInteract.MouseEnter:Connect(function()
                TweenService:Create(buttonContainer, tweenInfo, { BackgroundColor3 = hoverColor }):Play()
                if tooltipText then Utility.showTooltip(tooltipText, theme) end
            end))
            buttonContainer:AddConnection(buttonInteract.MouseLeave:Connect(function()
                TweenService:Create(buttonContainer, tweenInfo, { BackgroundColor3 = normalColor }):Play()
                if tooltipText then Utility.hideTooltip() end
            end))
            buttonContainer:AddConnection(buttonInteract.MouseButton1Down:Connect(function()
                TweenService:Create(buttonContainer, tweenInfo, { BackgroundColor3 = clickColor }):Play()
            end))
            buttonContainer:AddConnection(buttonInteract.MouseButton1Up:Connect(function()
                TweenService:Create(buttonContainer, tweenInfo, { BackgroundColor3 = hoverColor }):Play() -- Revert to hover color on release
            end))
            buttonContainer:AddConnection(buttonInteract.MouseButton1Click:Connect(function()
                 Utility.rippleEffect(buttonContainer)
                 Utility.safeCall(callback)
            end))

            -- Component API
            local ButtonComponent = {
                Instance = buttonContainer,
                SetText = function(self, text) name = text; buttonTitle.Text = text; end,
                SetIcon = function(self, newIconId)
                    local icon = self.Instance:FindFirstChild("Icon")
                    if newIconId and newIconId ~= 0 then
                        if icon then
                            icon.Image = Utility.loadIcon(newIconId)
                        else -- Create icon if it didn't exist
                            icon = Utility.createInstance("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(newIconId), ImageColor3 = Window.CurrentTheme.TextColor, Parent = self.Instance })
                            Utility.registerThemedElement(icon, "ImageColor3", "TextColor")
                            buttonTitle.Position = UDim2.new(0, 10 + 30, 0, 0) -- Adjust title pos
                            buttonTitle.Size = UDim2.new(1, -(10 + 30), 1, 0)
                        end
                    elseif icon then -- Remove icon if newId is 0 or nil
                        Utility.destroyInstance(icon)
                        buttonTitle.Position = UDim2.new(0, 10, 0, 0)
                        buttonTitle.Size = UDim2.new(1, -10, 1, 0)
                    end
                end,
                SetTooltip = function(self, text) tooltipText = text end,
                Destroy = function(self) Utility.destroyInstance(self.Instance) end -- Use utility destroy
            }
            table.insert(self._components, ButtonComponent) -- Track component
            return ButtonComponent
        end

        function Tab:CreateToggle(options)
            options = options or {}
            local name = options.Name or "Toggle"
            local currentValue = options.CurrentValue or false
            local flag = options.Flag or nil
            local callback = options.Callback or function() end
            local iconId = options.Icon or 0
            local tooltipText = options.Tooltip or nil
            local theme = Window.CurrentTheme

            local toggleContainer = Utility.createInstance("Frame", { Name = "Toggle_" .. name, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = theme.ElementBackground, Parent = self.Page })
            Utility.createCorner(toggleContainer, 4)
            Utility.registerThemedElement(toggleContainer, "BackgroundColor3", "ElementBackground", "ElementBackgroundHover")
            Utility.manageConnections(toggleContainer)

            local iconPadding = 0
            if iconId ~= 0 then
                local toggleIcon = Utility.createInstance("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(iconId), ImageColor3 = theme.TextColor, Parent = toggleContainer })
                Utility.registerThemedElement(toggleIcon, "ImageColor3", "TextColor")
                iconPadding = 30
            end

            local toggleTitle = Utility.createInstance("TextLabel", { Name = "Title", Size = UDim2.new(1, -(60 + iconPadding), 1, 0), Position = UDim2.new(0, 10 + iconPadding, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = name, TextColor3 = theme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = toggleContainer })
            Utility.registerThemedElement(toggleTitle, "TextColor3", "TextColor")

            local toggleFrame = Utility.createInstance("Frame", { Name = "Toggle", Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -46, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = currentValue and theme.ToggleEnabled or theme.ToggleDisabled, Parent = toggleContainer })
            Utility.createCorner(toggleFrame, 9) -- Fully rounded
            -- No direct theme registration needed here, updated via SetValue

            local toggleBall = Utility.createInstance("Frame", { Name = "Ball", Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, currentValue and 20 or 2, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255), Parent = toggleFrame })
            Utility.createCorner(toggleBall, 7) -- Fully rounded

            local toggleInteract = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = toggleContainer })

            -- Component API first to use SetValue internally
            local ToggleComponent = { Instance = toggleContainer, Value = currentValue }
            function ToggleComponent:SetValue(value, skipCallback)
                value = not not value -- Ensure boolean
                if self.Value == value then return end -- No change

                self.Value = value
                local theme = Window.CurrentTheme -- Get current theme

                -- Update UI
                local targetColor = value and theme.ToggleEnabled or theme.ToggleDisabled
                local targetPos = UDim2.new(0, value and 20 or 2, 0.5, 0)
                TweenService:Create(toggleFrame, TweenInfo.new(0.2), { BackgroundColor3 = targetColor }):Play()
                TweenService:Create(toggleBall, TweenInfo.new(0.2), { Position = targetPos }):Play()

                -- Update flags
                if flag then
                    LuminaUI.Flags[flag] = { Type = "Toggle", Value = value, ComponentRef = self }
                end

                -- Execute callback
                if not skipCallback then
                    Utility.safeCall(callback, value)
                end
            end
            function ToggleComponent:SetVisible(visible) self.Instance.Visible = visible end
            function ToggleComponent:SetTooltip(text) tooltipText = text end
            function ToggleComponent:Destroy() Utility.destroyInstance(self.Instance) end

             -- Store flag reference immediately
            if flag then
                LuminaUI.Flags[flag] = { Type = "Toggle", Value = currentValue, ComponentRef = ToggleComponent }
            end

            -- Effects & Interaction
            local hoverColor = theme.ElementBackgroundHover
            local normalColor = theme.ElementBackground
            local tweenInfo = TweenInfo.new(0.15)

            toggleContainer:AddConnection(toggleInteract.MouseEnter:Connect(function()
                TweenService:Create(toggleContainer, tweenInfo, { BackgroundColor3 = hoverColor }):Play()
                if tooltipText then Utility.showTooltip(tooltipText, theme) end
            end))
            toggleContainer:AddConnection(toggleInteract.MouseLeave:Connect(function()
                TweenService:Create(toggleContainer, tweenInfo, { BackgroundColor3 = normalColor }):Play()
                if tooltipText then Utility.hideTooltip() end
            end))
            toggleContainer:AddConnection(toggleInteract.MouseButton1Click:Connect(function()
                ToggleComponent:SetValue(not ToggleComponent.Value) -- Use SetValue to handle updates
            end))

            table.insert(self._components, ToggleComponent)
            return ToggleComponent
        end

-- ...existing code...

function Tab:CreateSlider(options)
    options = options or {}
    local name = options.Name or "Slider"
    local range = options.Range or {0, 100}
    local increment = options.Increment or 1
    local suffix = options.Suffix or ""
    local currentValue = options.CurrentValue or range[1]
    local flag = options.Flag or nil
    local callback = options.Callback or function() end
    local iconId = options.Icon or 0
    local tooltipText = options.Tooltip or nil
    local theme = Window.CurrentTheme

    local min, max = range[1], range[2]
    currentValue = math.clamp(currentValue, min, max) -- Clamp initial value

    local sliderContainer = Utility.createInstance("Frame", { Name = "Slider_" .. name, Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = theme.ElementBackground, Parent = self.Page })
    Utility.createCorner(sliderContainer, 4)
    Utility.registerThemedElement(sliderContainer, "BackgroundColor3", "ElementBackground", "ElementBackgroundHover")
    Utility.manageConnections(sliderContainer)

    local iconPadding = 0
    if iconId ~= 0 then
        local sliderIcon = Utility.createInstance("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 8, 0, 8), BackgroundTransparency = 1, Image = Utility.loadIcon(iconId), ImageColor3 = theme.TextColor, Parent = sliderContainer })
        Utility.registerThemedElement(sliderIcon, "ImageColor3", "TextColor")
        iconPadding = 30
    end

    local sliderTitle = Utility.createInstance("TextLabel", { Name = "Title", Size = UDim2.new(1, -(10 + iconPadding + 60), 0, 20), Position = UDim2.new(0, 10 + iconPadding, 0, 6), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = name, TextColor3 = theme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = sliderContainer })
    Utility.registerThemedElement(sliderTitle, "TextColor3", "TextColor")

    local valueDisplay = Utility.createInstance("TextLabel", { Name = "Value", Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(1, -60, 0, 6), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = Utility.formatNumber(currentValue) .. suffix, TextColor3 = theme.SubTextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = sliderContainer })
    Utility.registerThemedElement(valueDisplay, "TextColor3", "SubTextColor")

    local sliderBackground = Utility.createInstance("Frame", { Name = "Background", Size = UDim2.new(1, -20, 0, 8), Position = UDim2.new(0, 10, 0, 32), BackgroundColor3 = Utility.darker(theme.SliderBackground, 0.5), Parent = sliderContainer })
    Utility.createCorner(sliderBackground, 4)
    Utility.registerThemedElement(sliderBackground, "BackgroundColor3", "SliderBackground", nil, function(c) return Utility.darker(c, 0.5) end) -- Special darker logic

    local initialPercent = (max > min) and (currentValue - min) / (max - min) or 0
    local sliderFill = Utility.createInstance("Frame", { Name = "Fill", Size = UDim2.new(initialPercent, 0, 1, 0), BackgroundColor3 = theme.SliderProgress, Parent = sliderBackground })
    Utility.createCorner(sliderFill, 4)
    Utility.registerThemedElement(sliderFill, "BackgroundColor3", "SliderProgress")

    local sliderInteract = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = sliderBackground })

    -- Component API
    local SliderComponent = { Instance = sliderContainer, Value = currentValue }
    function SliderComponent:SetValue(value, skipCallback)
        value = math.clamp(value, min, max)
        local snappedValue = min + math.floor((value - min) / increment + 0.5) * increment
        snappedValue = math.clamp(snappedValue, min, max) -- Clamp again after snapping

        if self.Value == snappedValue then return end -- No change

        self.Value = snappedValue
        local percent = (max > min) and (snappedValue - min) / (max - min) or 0

        -- Update UI
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        valueDisplay.Text = Utility.formatNumber(snappedValue) .. suffix

        -- Update flags
        if flag then
            LuminaUI.Flags[flag] = { Type = "Slider", Value = snappedValue, ComponentRef = self }
        end

        -- Execute callback
        if not skipCallback then
            Utility.safeCall(callback, snappedValue)
        end
    end
    function SliderComponent:SetRange(newMin, newMax, newIncrement)
         min = newMin or min
         max = newMax or max
         increment = newIncrement or increment
         range = {min, max} -- Update internal range table
         self:SetValue(self.Value) -- Re-snap and update UI
    end
    function SliderComponent:SetSuffix(newSuffix) suffix = newSuffix; self:SetValue(self.Value) end
    function SliderComponent:SetTooltip(text) tooltipText = text end
    function SliderComponent:Destroy() Utility.destroyInstance(self.Instance) end

    -- Store flag reference immediately
    if flag then
        LuminaUI.Flags[flag] = { Type = "Slider", Value = currentValue, ComponentRef = SliderComponent }
    end

    -- Interaction Logic
    local isDragging = false
    local function updateSliderFromInput(inputPos)
        local relativeX = inputPos.X - sliderBackground.AbsolutePosition.X
        local width = sliderBackground.AbsoluteSize.X
        local percent = (width > 0) and math.clamp(relativeX / width, 0, 1) or 0
        local rawValue = min + (max - min) * percent
        SliderComponent:SetValue(rawValue) -- Use SetValue to handle snapping, UI update, and callback
    end

    sliderContainer:AddConnection(sliderInteract.MouseButton1Down:Connect(function()
        isDragging = true
        updateSliderFromInput(UserInputService:GetMouseLocation())
        UserInputService.TextSelectionEnabled = false -- Prevent text selection
    end))
    sliderContainer:AddConnection(UserInputService.InputEnded:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
            UserInputService.TextSelectionEnabled = true -- Re-enable
        end
    end))
    sliderContainer:AddConnection(UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSliderFromInput(input.Position)
        end
    end))

    -- Hover Effects
    local hoverColor = theme.ElementBackgroundHover
    local normalColor = theme.ElementBackground
    local tweenInfo = TweenInfo.new(0.15)
    sliderContainer:AddConnection(sliderContainer.MouseEnter:Connect(function() -- Use container for hover
        TweenService:Create(sliderContainer, tweenInfo, { BackgroundColor3 = hoverColor }):Play()
        if tooltipText then Utility.showTooltip(tooltipText, theme) end
    end))
    sliderContainer:AddConnection(sliderContainer.MouseLeave:Connect(function()
        TweenService:Create(sliderContainer, tweenInfo, { BackgroundColor3 = normalColor }):Play()
        if tooltipText then Utility.hideTooltip() end
    end))

    table.insert(self._components, SliderComponent)
    return SliderComponent
end

function Tab:CreateDropdown(options)
    options = options or {}
    local name = options.Name or "Dropdown"
    local opts = options.Options or {}
    local currentOption = options.CurrentOption or (opts[1] or "")
    local flag = options.Flag or nil
    local callback = options.Callback or function() end
    local iconId = options.Icon or 0
    local tooltipText = options.Tooltip or nil
    local theme = Window.CurrentTheme

    local isOpen = false
    local listContainer = nil -- Forward declare

    local dropdownContainer = Utility.createInstance("Frame", { Name = "Dropdown_" .. name, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = theme.ElementBackground, ClipsDescendants = true, Parent = self.Page, ZIndex = 10 }) -- Higher ZIndex when closed
    Utility.createCorner(dropdownContainer, 4)
    Utility.registerThemedElement(dropdownContainer, "BackgroundColor3", "ElementBackground", "ElementBackgroundHover")
    Utility.manageConnections(dropdownContainer)

    local iconPadding = 0
    if iconId ~= 0 then
        local dropdownIcon = Utility.createInstance("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(iconId), ImageColor3 = theme.TextColor, Parent = dropdownContainer })
        Utility.registerThemedElement(dropdownIcon, "ImageColor3", "TextColor")
        iconPadding = 30
    end

    local dropdownTitle = Utility.createInstance("TextLabel", { Name = "Title", Size = UDim2.new(1, -(70 + iconPadding), 1, 0), Position = UDim2.new(0, 10 + iconPadding, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = name, TextColor3 = theme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = dropdownContainer })
    Utility.registerThemedElement(dropdownTitle, "TextColor3", "TextColor")

    local selectedOptionLabel = Utility.createInstance("TextLabel", { Name = "Selected", Size = UDim2.new(0, 120, 1, 0), Position = UDim2.new(1, -30, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = currentOption, TextColor3 = theme.SubTextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = dropdownContainer })
    Utility.registerThemedElement(selectedOptionLabel, "TextColor3", "SubTextColor")

    local dropdownArrow = Utility.createInstance("ImageLabel", { Name = "Arrow", Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -12, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://10483855823", ImageColor3 = theme.SubTextColor, Rotation = 0, Parent = dropdownContainer })
    Utility.registerThemedElement(dropdownArrow, "ImageColor3", "SubTextColor")

    local dropdownInteract = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = dropdownContainer })

    -- Component API
    local DropdownComponent = { Instance = dropdownContainer, Value = currentOption, Options = opts }

    local function updateListItems()
        if not listContainer then return end
        local theme = Window.CurrentTheme -- Get current theme

        -- Clear existing items
        for _, child in ipairs(listContainer:GetChildren()) do
            if not (child:IsA("UIListLayout") or child:IsA("UIPadding")) then
                Utility.destroyInstance(child)
            end
        end

        -- Create new items
        for i, optionText in ipairs(DropdownComponent.Options) do
            local isSelected = (optionText == DropdownComponent.Value)
            local itemFrame = Utility.createInstance("Frame", { Name = "Item_" .. i, Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = isSelected and theme.DropdownSelected or theme.DropdownUnselected, Parent = listContainer })
            Utility.createCorner(itemFrame, 4)
            Utility.manageConnections(itemFrame) -- Manage item connections

            local itemLabel = Utility.createInstance("TextLabel", { Name = "Label", Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = optionText, TextColor3 = isSelected and theme.TextColor or theme.SubTextColor, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = itemFrame })
            local itemButton = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = itemFrame })

            -- Hover effects
            local itemNormalColor = itemFrame.BackgroundColor3
            local itemHoverColor = Utility.lighter(itemNormalColor, 0.1)
            itemFrame:AddConnection(itemButton.MouseEnter:Connect(function() if not isSelected then TweenService:Create(itemFrame, TweenInfo.new(0.15), { BackgroundColor3 = itemHoverColor }):Play() end end))
            itemFrame:AddConnection(itemButton.MouseLeave:Connect(function() if not isSelected then TweenService:Create(itemFrame, TweenInfo.new(0.15), { BackgroundColor3 = itemNormalColor }):Play() end end))

            -- Selection
            itemFrame:AddConnection(itemButton.MouseButton1Click:Connect(function()
                DropdownComponent:SetValue(optionText)
                DropdownComponent:ToggleOpen(false) -- Close after selection
            end))
        end

        -- Update list container size (defer might be needed if layout updates async)
        task.defer(function()
             if listContainer and listContainer:FindFirstChildOfClass("UIListLayout") then
                 local contentHeight = listContainer.UIListLayout.AbsoluteContentSize.Y
                 listContainer.Size = UDim2.new(1, -10, 0, contentHeight + 10) -- Add padding
                 if isOpen then -- Adjust parent size if already open
                     dropdownContainer.Size = UDim2.new(1, 0, 0, 36 + listContainer.Size.Y.Offset + 4) -- 36 header + list + padding
                 end
             end
        end)
    end

    function DropdownComponent:ToggleOpen(state)
        if isOpen == state then return end
        isOpen = state

        if not listContainer then -- Create list container on first open
            listContainer = Utility.createInstance("Frame", { Name = "List", Size = UDim2.new(1, -10, 0, 0), Position = UDim2.new(0, 5, 0, 40), BackgroundColor3 = Utility.darker(Window.CurrentTheme.ElementBackground, 0.1), Visible = false, ClipsDescendants = true, Parent = dropdownContainer, ZIndex = dropdownContainer.ZIndex - 1 }) -- Below main dropdown frame
            Utility.createCorner(listContainer, 4)
            Utility.createInstance("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = listContainer })
            Utility.createInstance("UIPadding", { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), Parent = listContainer })
            Utility.registerThemedElement(listContainer, "BackgroundColor3", "ElementBackground", nil, function(c) return Utility.darker(c, 0.1) end)
            updateListItems() -- Populate items now
        end

        local targetSizeY
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        if isOpen then
            listContainer.Visible = true
            targetSizeY = 36 + listContainer.Size.Y.Offset + 4 -- Header + List + Padding
            dropdownContainer.ClipsDescendants = false -- Allow list to show
            dropdownContainer.ZIndex = 100 -- Bring to front when open
            ActiveDropdown = self -- Register as active dropdown
            TweenService:Create(dropdownArrow, tweenInfo, { Rotation = 180 }):Play()
        else
            targetSizeY = 36
            dropdownContainer.ClipsDescendants = true -- Clip list before shrinking
            dropdownContainer.ZIndex = 10 -- Reset ZIndex
            if ActiveDropdown == self then ActiveDropdown = nil end -- Unregister
            TweenService:Create(dropdownArrow, tweenInfo, { Rotation = 0 }):Play()
        end

        local sizeTween = TweenService:Create(dropdownContainer, tweenInfo, { Size = UDim2.new(1, 0, 0, targetSizeY) })
        sizeTween:Play()

        if not isOpen then
            sizeTween.Completed:Connect(function()
                -- Hide list container *after* animation completes if closing
                if listContainer and not isOpen then listContainer.Visible = false end
            end)
        end

        -- Force layout update after animation (might help with scroll frame canvas size issues)
        task.delay(tweenInfo.Time + 0.05, function()
            if self.Instance and self.Instance.Parent and self.Instance.Parent:FindFirstChildOfClass("UIListLayout") then
                self.Instance.Parent.UIListLayout:ApplyLayout()
            end
        end)
    end

    function DropdownComponent:SetValue(option, skipCallback)
        if not table.find(self.Options, option) then
            warn("[LuminaUI] Option not found in dropdown:", option)
            return
        end
        if self.Value == option then return end -- No change

        self.Value = option
        selectedOptionLabel.Text = option

        -- Update flags
        if flag then
            LuminaUI.Flags[flag] = { Type = "Dropdown", Value = option, ComponentRef = self }
        end

        -- Update visual selection in the list (if open)
        if listContainer then updateListItems() end

        -- Execute callback
        if not skipCallback then
            Utility.safeCall(callback, option)
        end
    end

    function DropdownComponent:Refresh(newOptions, newValue)
        self.Options = newOptions or self.Options
        local valueToSet = self.Value -- Keep current value if possible

        if newValue and table.find(self.Options, newValue) then
            valueToSet = newValue
        elseif not table.find(self.Options, self.Value) then -- Current value no longer valid
            valueToSet = self.Options[1] or "" -- Default to first or empty
        end

        self:SetValue(valueToSet, true) -- Set value without triggering callback
        if listContainer then updateListItems() end -- Update list visuals
    end
    function DropdownComponent:SetTooltip(text) tooltipText = text end
    function DropdownComponent:Destroy() Utility.destroyInstance(self.Instance) end

    -- Store flag reference immediately
    if flag then
        LuminaUI.Flags[flag] = { Type = "Dropdown", Value = currentOption, ComponentRef = DropdownComponent }
    end

    -- Interaction
    dropdownContainer:AddConnection(dropdownInteract.MouseButton1Click:Connect(function()
        DropdownComponent:ToggleOpen(not isOpen)
    end))

    -- Hover Effects
    local hoverColor = theme.ElementBackgroundHover
    local normalColor = theme.ElementBackground
    local tweenInfo = TweenInfo.new(0.15)
    dropdownContainer:AddConnection(dropdownInteract.MouseEnter:Connect(function()
        TweenService:Create(dropdownContainer, tweenInfo, { BackgroundColor3 = hoverColor }):Play()
        if tooltipText then Utility.showTooltip(tooltipText, theme) end
    end))
    dropdownContainer:AddConnection(dropdownInteract.MouseLeave:Connect(function()
        TweenService:Create(dropdownContainer, tweenInfo, { BackgroundColor3 = normalColor }):Play()
        if tooltipText then Utility.hideTooltip() end
    end))

    table.insert(self._components, DropdownComponent)
    return DropdownComponent
end

function Tab:CreateInput(options)
    options = options or {}
    local name = options.Name or "Input"
    local placeholder = options.Placeholder or "Enter text..."
    local currentValue = options.CurrentValue or ""
    local clearOnFocus = options.ClearOnFocus or false
    local flag = options.Flag or nil
    local callback = options.Callback or function() end
    local iconId = options.Icon or 0
    local tooltipText = options.Tooltip or nil
    local theme = Window.CurrentTheme

    local inputContainer = Utility.createInstance("Frame", { Name = "Input_" .. name, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = theme.ElementBackground, Parent = self.Page })
    Utility.createCorner(inputContainer, 4)
    Utility.registerThemedElement(inputContainer, "BackgroundColor3", "ElementBackground", "ElementBackgroundHover")
    Utility.manageConnections(inputContainer)

    local iconPadding = 0
    if iconId ~= 0 then
        local inputIcon = Utility.createInstance("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(iconId), ImageColor3 = theme.TextColor, Parent = inputContainer })
        Utility.registerThemedElement(inputIcon, "ImageColor3", "TextColor")
        iconPadding = 30
    end

    local inputTitle = Utility.createInstance("TextLabel", { Name = "Title", Size = UDim2.new(1, -(10 + iconPadding + 10), 1, 0), Position = UDim2.new(0, 10 + iconPadding, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = name, TextColor3 = theme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = inputContainer })
    Utility.registerThemedElement(inputTitle, "TextColor3", "TextColor")

    local textBox = Utility.createInstance("TextBox", {
        Name = "InputBox", Size = UDim2.new(0, 150, 0, 24), Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = theme.InputBackground, PlaceholderText = placeholder, PlaceholderColor3 = theme.InputPlaceholder, Text = currentValue, TextColor3 = theme.TextColor, Font = Enum.Font.Gotham, TextSize = 13, ClearTextOnFocus = clearOnFocus, Parent = inputContainer
    })
    Utility.createCorner(textBox, 4)
    local stroke = Utility.createStroke(textBox, theme.InputStroke, 1)
    Utility.registerThemedElement(textBox, "BackgroundColor3", "InputBackground")
    Utility.registerThemedElement(textBox, "PlaceholderColor3", "InputPlaceholder")
    Utility.registerThemedElement(textBox, "TextColor3", "TextColor")
    Utility.registerThemedElement(stroke, "Color", "InputStroke")

    -- Component API
    local InputComponent = { Instance = inputContainer, Value = currentValue }
    function InputComponent:SetValue(value, skipCallback)
        value = tostring(value)
        if self.Value == value then return end

        self.Value = value
        textBox.Text = value

        -- Update flags
        if flag then
            LuminaUI.Flags[flag] = { Type = "Input", Value = value, ComponentRef = self }
        end

        -- Execute callback
        if not skipCallback then
            Utility.safeCall(callback, value)
        end
    end
    function InputComponent:SetPlaceholder(text) placeholder = text; textBox.PlaceholderText = text; end
    function InputComponent:SetTooltip(text) tooltipText = text end
    function InputComponent:Destroy() Utility.destroyInstance(self.Instance) end

    -- Store flag reference immediately
    if flag then
        LuminaUI.Flags[flag] = { Type = "Input", Value = currentValue, ComponentRef = InputComponent }
    end

    -- Interaction
    inputContainer:AddConnection(textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            InputComponent:SetValue(textBox.Text) -- Trigger callback on enter
        else
            -- Optionally trigger callback on focus lost even without enter?
            -- InputComponent:SetValue(textBox.Text)
            InputComponent.Value = textBox.Text -- Update internal value without callback
            if flag then LuminaUI.Flags[flag].Value = textBox.Text end -- Update flag value directly
        end
    end))

    -- Hover Effects (on container)
    local hoverColor = theme.ElementBackgroundHover
    local normalColor = theme.ElementBackground
    local tweenInfo = TweenInfo.new(0.15)
    inputContainer:AddConnection(inputContainer.MouseEnter:Connect(function()
        TweenService:Create(inputContainer, tweenInfo, { BackgroundColor3 = hoverColor }):Play()
        if tooltipText then Utility.showTooltip(tooltipText, theme) end
    end))
    inputContainer:AddConnection(inputContainer.MouseLeave:Connect(function()
        TweenService:Create(inputContainer, tweenInfo, { BackgroundColor3 = normalColor }):Play()
        if tooltipText then Utility.hideTooltip() end
    end))

    table.insert(self._components, InputComponent)
    return InputComponent
end

function Tab:CreateColorPicker(options)
    options = options or {}
    local name = options.Name or "Color Picker"
    local currentColor = options.CurrentColor or Color3.new(1, 1, 1)
    local flag = options.Flag or nil
    local callback = options.Callback or function() end
    local iconId = options.Icon or 0
    local tooltipText = options.Tooltip or nil
    local theme = Window.CurrentTheme

    local isOpen = false
    local pickerFrame = nil -- Forward declare

    local colorPickerContainer = Utility.createInstance("Frame", { Name = "ColorPicker_" .. name, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = theme.ElementBackground, ClipsDescendants = true, Parent = self.Page, ZIndex = 10 })
    Utility.createCorner(colorPickerContainer, 4)
    Utility.registerThemedElement(colorPickerContainer, "BackgroundColor3", "ElementBackground", "ElementBackgroundHover")
    Utility.manageConnections(colorPickerContainer)

    local iconPadding = 0
    if iconId ~= 0 then
        local pickerIcon = Utility.createInstance("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(iconId), ImageColor3 = theme.TextColor, Parent = colorPickerContainer })
        Utility.registerThemedElement(pickerIcon, "ImageColor3", "TextColor")
        iconPadding = 30
    end

    local pickerTitle = Utility.createInstance("TextLabel", { Name = "Title", Size = UDim2.new(1, -(70 + iconPadding), 1, 0), Position = UDim2.new(0, 10 + iconPadding, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = name, TextColor3 = theme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = colorPickerContainer })
    Utility.registerThemedElement(pickerTitle, "TextColor3", "TextColor")

    local colorPreview = Utility.createInstance("Frame", { Name = "Preview", Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -30, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = currentColor, Parent = colorPickerContainer })
    Utility.createCorner(colorPreview, 4)
    local previewStroke = Utility.createStroke(colorPreview, theme.ElementStroke, 1)
    Utility.registerThemedElement(previewStroke, "Color", "ElementStroke")

    local pickerInteract = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = colorPickerContainer })

    -- Component API
    local ColorPickerComponent = { Instance = colorPickerContainer, Value = currentColor }

    local function createPickerUI()
        if pickerFrame then return end -- Already created

        pickerFrame = Utility.createInstance("Frame", { Name = "PickerUI", Size = UDim2.new(0, 200, 0, 230), Position = UDim2.new(0.5, 0, 0, 40), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = theme.ColorPickerBackground, Visible = false, Parent = colorPickerContainer, ZIndex = colorPickerContainer.ZIndex - 1 })
        Utility.createCorner(pickerFrame, 4)
        local pickerStroke = Utility.createStroke(pickerFrame, theme.ElementStroke, 1)
        Utility.registerThemedElement(pickerFrame, "BackgroundColor3", "ColorPickerBackground")
        Utility.registerThemedElement(pickerStroke, "Color", "ElementStroke")

        -- Saturation/Value Box
        local svBox = Utility.createInstance("ImageLabel", { Name = "SVBox", Size = UDim2.new(0, 180, 0, 150), Position = UDim2.new(0.5, 0, 0, 10), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Color3.fromHSV(0, 1, 1), Image = "rbxassetid://6031280882", -- Placeholder, needs gradient texture
            ImageColor3 = Color3.new(1,1,1), ImageTransparency = 0, Parent = pickerFrame })
        Utility.createCorner(svBox, 4)
        -- Add gradient textures (requires specific assets or procedural generation)
        local satGradient = Utility.createInstance("UIGradient", { Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(1,1,1))}), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}), Rotation = 90, Parent = svBox })
        local valGradient = Utility.createInstance("UIGradient", { Color = ColorSequence.new(Color3.new(0,0,0)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}), Rotation = 0, Parent = svBox })

        local svPicker = Utility.createInstance("Frame", { Name = "SVPicker", Size = UDim2.new(0, 10, 0, 10), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 2, BorderColor3 = Color3.new(0,0,0), Parent = svBox })
        Utility.createCorner(svPicker, 5)

        -- Hue Slider
        local hueSlider = Utility.createInstance("ImageLabel", { Name = "HueSlider", Size = UDim2.new(0, 180, 0, 15), Position = UDim2.new(0.5, 0, 0, 170), AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, Image = "rbxassetid://6031280882", -- Placeholder, needs hue gradient texture
            ImageColor3 = Color3.new(1,1,1), Parent = pickerFrame })
        Utility.createCorner(hueSlider, 7.5)
        local hueGradient = Utility.createInstance("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            }),
            Rotation = 90, Parent = hueSlider
        })

        local huePicker = Utility.createInstance("Frame", { Name = "HuePicker", Size = UDim2.new(0, 8, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 2, BorderColor3 = Color3.new(0,0,0), Parent = hueSlider })
        Utility.createCorner(huePicker, 4)

        -- Input Fields (Optional)
        -- ... create TextBoxes for R, G, B, Hex ...

        -- Update Logic
        local currentH, currentS, currentV = Color3.toHSV(ColorPickerComponent.Value)

        local function updateColorFromHSV()
            local newColor = Color3.fromHSV(currentH, currentS, currentV)
            ColorPickerComponent:SetValue(newColor) -- Use SetValue to update preview, flag, and call callback
            svBox.BackgroundColor3 = Color3.fromHSV(currentH, 1, 1) -- Update SV box base color
        end

        local function updatePickersFromHSV()
            svPicker.Position = UDim2.new(currentS, 0, 1 - currentV, 0)
            huePicker.Position = UDim2.new(currentH, 0, 0.5, 0)
        end

        -- SV Box Interaction
        local svDragging = false
        svBox:AddConnection(svBox.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = true end
        end))
        svBox:AddConnection(svBox.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = false end
        end))
        svBox:AddConnection(svBox.InputChanged:Connect(function(input)
            if svDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                currentS = relX
                currentV = 1 - relY
                updatePickersFromHSV()
                updateColorFromHSV()
            end
        end))

        -- Hue Slider Interaction
        local hueDragging = false
        hueSlider:AddConnection(hueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = true end
        end))
        hueSlider:AddConnection(hueSlider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = false end
        end))
        hueSlider:AddConnection(hueSlider.InputChanged:Connect(function(input)
            if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local relX = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
                currentH = relX
                updatePickersFromHSV()
                updateColorFromHSV()
            end
        end))

        updatePickersFromHSV() -- Set initial picker positions
    end

    function ColorPickerComponent:ToggleOpen(state)
        if isOpen == state then return end
        isOpen = state

        createPickerUI() -- Ensure UI exists

        local targetSizeY
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        if isOpen then
            pickerFrame.Visible = true
            targetSizeY = 36 + pickerFrame.Size.Y.Offset + 4 -- Header + Picker + Padding
            colorPickerContainer.ClipsDescendants = false
            colorPickerContainer.ZIndex = 100
            ActiveDropdown = self -- Use same mechanism as dropdown to close on outside click
        else
            targetSizeY = 36
            colorPickerContainer.ClipsDescendants = true
            colorPickerContainer.ZIndex = 10
            if ActiveDropdown == self then ActiveDropdown = nil end
        end

        local sizeTween = TweenService:Create(colorPickerContainer, tweenInfo, { Size = UDim2.new(1, 0, 0, targetSizeY) })
        sizeTween:Play()

        if not isOpen then
            sizeTween.Completed:Connect(function()
                if pickerFrame and not isOpen then pickerFrame.Visible = false end
            end)
        end
         -- Force layout update
        task.delay(tweenInfo.Time + 0.05, function()
            if self.Instance and self.Instance.Parent and self.Instance.Parent:FindFirstChildOfClass("UIListLayout") then
                self.Instance.Parent.UIListLayout:ApplyLayout()
            end
        end)
    end

    function ColorPickerComponent:SetValue(value, skipCallback)
        if not typeof(value) == "Color3" then return end
        if self.Value == value then return end

        self.Value = value
        colorPreview.BackgroundColor3 = value

        -- Update picker UI if it exists
        if pickerFrame then
            local h, s, v = Color3.toHSV(value)
            local svBox = pickerFrame:FindFirstChild("SVBox")
            local hueSlider = pickerFrame:FindFirstChild("HueSlider")
            if svBox then svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1) end
            local svPicker = svBox and svBox:FindFirstChild("SVPicker")
            local huePicker = hueSlider and hueSlider:FindFirstChild("HuePicker")
            if svPicker then svPicker.Position = UDim2.new(s, 0, 1 - v, 0) end
            if huePicker then huePicker.Position = UDim2.new(h, 0, 0.5, 0) end
        end

        -- Update flags
        if flag then
            LuminaUI.Flags[flag] = { Type = "ColorPicker", Value = value, ComponentRef = self }
        end

        -- Execute callback
        if not skipCallback then
            Utility.safeCall(callback, value)
        end
    end
    function ColorPickerComponent:SetTooltip(text) tooltipText = text end
    function ColorPickerComponent:Destroy() Utility.destroyInstance(self.Instance) end

    -- Store flag reference immediately
    if flag then
        LuminaUI.Flags[flag] = { Type = "ColorPicker", Value = currentColor, ComponentRef = ColorPickerComponent }
    end

    -- Interaction
    colorPickerContainer:AddConnection(pickerInteract.MouseButton1Click:Connect(function()
        ColorPickerComponent:ToggleOpen(not isOpen)
    end))

    -- Hover Effects
    local hoverColor = theme.ElementBackgroundHover
    local normalColor = theme.ElementBackground
    local tweenInfo = TweenInfo.new(0.15)
    colorPickerContainer:AddConnection(pickerInteract.MouseEnter:Connect(function()
        TweenService:Create(colorPickerContainer, tweenInfo, { BackgroundColor3 = hoverColor }):Play()
        if tooltipText then Utility.showTooltip(tooltipText, theme) end
    end))
    colorPickerContainer:AddConnection(pickerInteract.MouseLeave:Connect(function()
        TweenService:Create(colorPickerContainer, tweenInfo, { BackgroundColor3 = normalColor }):Play()
        if tooltipText then Utility.hideTooltip() end
    end))

    table.insert(self._components, ColorPickerComponent)
    return ColorPickerComponent
end

function Tab:CreateCheckbox(options)
    options = options or {}
    local name = options.Name or "Checkbox"
    local currentValue = options.CurrentValue or false
    local flag = options.Flag or nil
    local callback = options.Callback or function() end
    local iconId = options.Icon or 0
    local tooltipText = options.Tooltip or nil
    local theme = Window.CurrentTheme

    local checkboxContainer = Utility.createInstance("Frame", { Name = "Checkbox_" .. name, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = theme.ElementBackground, Parent = self.Page })
    Utility.createCorner(checkboxContainer, 4)
    Utility.registerThemedElement(checkboxContainer, "BackgroundColor3", "ElementBackground", "ElementBackgroundHover")
    Utility.manageConnections(checkboxContainer)

    local iconPadding = 0
    if iconId ~= 0 then
        local checkboxIcon = Utility.createInstance("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Utility.loadIcon(iconId), ImageColor3 = theme.TextColor, Parent = checkboxContainer })
        Utility.registerThemedElement(checkboxIcon, "ImageColor3", "TextColor")
        iconPadding = 30
    end

    local checkboxTitle = Utility.createInstance("TextLabel", { Name = "Title", Size = UDim2.new(1, -(60 + iconPadding), 1, 0), Position = UDim2.new(0, 10 + iconPadding, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = name, TextColor3 = theme.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = checkboxContainer })
    Utility.registerThemedElement(checkboxTitle, "TextColor3", "TextColor")

    local checkboxFrame = Utility.createInstance("Frame", { Name = "Checkbox", Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -46, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = currentValue and theme.CheckboxChecked or theme.CheckboxUnchecked, Parent = checkboxContainer })
    Utility.createCorner(checkboxFrame, 4)
    -- No direct theme registration needed here, updated via SetValue

    local checkmark = Utility.createInstance("ImageLabel", { Name = "Checkmark", Size = UDim2.new(0.8, 0, 0.8, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://3926307971", ImageColor3 = Color3.fromRGB(255, 255, 255), ImageTransparency = currentValue and 0 or 1, Parent = checkboxFrame })

    local checkboxInteract = Utility.createInstance("TextButton", { Name = "Interact", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = checkboxContainer })

    -- Component API
    local CheckboxComponent = { Instance = checkboxContainer, Value = currentValue }
    function CheckboxComponent:SetValue(value, skipCallback)
        value = not not value -- Ensure boolean
        if self.Value == value then return end

        self.Value = value
        local theme = Window.CurrentTheme

        -- Update UI
        local targetColor = value and theme.CheckboxChecked or theme.CheckboxUnchecked
        local targetTransparency = value and 0 or 1
        TweenService:Create(checkboxFrame, TweenInfo.new(0.2), { BackgroundColor3 = targetColor }):Play()
        TweenService:Create(checkmark, TweenInfo.new(0.2), { ImageTransparency = targetTransparency }):Play()

        -- Update flags
        if flag then
            LuminaUI.Flags[flag] = { Type = "Checkbox", Value = value, ComponentRef = self }
        end

        -- Execute callback
        if not skipCallback then
            Utility.safeCall(callback, value)
        end
    end
    function CheckboxComponent:SetVisible(visible) self.Instance.Visible = visible end
    function CheckboxComponent:SetTooltip(text) tooltipText = text end
    function CheckboxComponent:Destroy() Utility.destroyInstance(self.Instance) end

    -- Store flag reference immediately
    if flag then
        LuminaUI.Flags[flag] = { Type = "Checkbox", Value = currentValue, ComponentRef = CheckboxComponent }
    end

    -- Effects & Interaction
    local hoverColor = theme.ElementBackgroundHover
    local normalColor = theme.ElementBackground
    local tweenInfo = TweenInfo.new(0.15)

    checkboxContainer:AddConnection(checkboxInteract.MouseEnter:Connect(function()
        TweenService:Create(checkboxContainer, tweenInfo, { BackgroundColor3 = hoverColor }):Play()
        if tooltipText then Utility.showTooltip(tooltipText, theme) end
    end))
    checkboxContainer:AddConnection(checkboxInteract.MouseLeave:Connect(function()
        TweenService:Create(checkboxContainer, tweenInfo, { BackgroundColor3 = normalColor }):Play()
        if tooltipText then Utility.hideTooltip() end
    end))
    checkboxContainer:AddConnection(checkboxInteract.MouseButton1Click:Connect(function()
        CheckboxComponent:SetValue(not CheckboxComponent.Value)
    end))

    table.insert(self._components, CheckboxComponent)
    return CheckboxComponent
end

function Tab:CreateLabel(options)
    options = options or {}
    local text = options.Text or "Label"
    local size = options.Size or 13
    local alignment = options.Alignment or Enum.TextXAlignment.Left
    local wrap = options.Wrap or false
    local theme = Window.CurrentTheme

    local labelContainer = Utility.createInstance("Frame", { Name = "Label_" .. text:sub(1,10), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = self.Page })
    Utility.manageConnections(labelContainer) -- Manage connections

    local textLabel = Utility.createInstance("TextLabel", {
        Name = "Text", Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = text, TextColor3 = theme.SubTextColor, TextSize = size, TextXAlignment = alignment, TextWrapped = wrap, Parent = labelContainer
    })
    Utility.registerThemedElement(textLabel, "TextColor3", "SubTextColor")

    -- Auto-adjust height if wrapped
    if wrap then
        labelContainer.Size = UDim2.new(1, 0, 0, 0) -- Let text determine height initially
        labelContainer:AddConnection(textLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
            labelContainer.Size = UDim2.new(1, 0, 0, textLabel.TextBounds.Y + 4) -- Add padding
        end))
        task.wait() -- Allow initial bounds calculation
        labelContainer.Size = UDim2.new(1, 0, 0, textLabel.TextBounds.Y + 4)
    end

    -- Component API
    local LabelComponent = { Instance = labelContainer }
    function LabelComponent:SetText(newText)
        text = newText
        textLabel.Text = newText
    end
    function LabelComponent:SetColor(color) textLabel.TextColor3 = color end
    function LabelComponent:SetVisible(visible) self.Instance.Visible = visible end
    function LabelComponent:Destroy() Utility.destroyInstance(self.Instance) end

    table.insert(self._components, LabelComponent)
    return LabelComponent
end

function Tab:CreateProgressBar(options)
    options = options or {}
    local name = options.Name or "Progress"
    local currentValue = options.CurrentValue or 0 -- Value between 0 and 1
    local displayText = options.DisplayText or nil -- Optional text overlay
    local theme = Window.CurrentTheme

    local progressContainer = Utility.createInstance("Frame", { Name = "Progress_" .. name, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = theme.ElementBackground, Parent = self.Page })
    Utility.createCorner(progressContainer, 4)
    Utility.registerThemedElement(progressContainer, "BackgroundColor3", "ElementBackground")
    Utility.manageConnections(progressContainer)

    local progressBackground = Utility.createInstance("Frame", { Name = "Background", Size = UDim2.new(1, -20, 0, 12), Position = UDim2.new(0, 10, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = theme.ProgressBarBackground, Parent = progressContainer })
    Utility.createCorner(progressBackground, 6)
    Utility.registerThemedElement(progressBackground, "BackgroundColor3", "ProgressBarBackground")

    local progressFill = Utility.createInstance("Frame", { Name = "Fill", Size = UDim2.new(math.clamp(currentValue, 0, 1), 0, 1, 0), BackgroundColor3 = theme.ProgressBarFill, Parent = progressBackground })
    Utility.createCorner(progressFill, 6)
    Utility.registerThemedElement(progressFill, "BackgroundColor3", "ProgressBarFill")

    local progressText = Utility.createInstance("TextLabel", { Name = "Text", Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = displayText or string.format("%.0f%%", currentValue * 100), TextColor3 = theme.TextColor, TextSize = 10, TextStrokeTransparency = 0.5, Parent = progressBackground, ZIndex = progressBackground.ZIndex + 1 })
    Utility.registerThemedElement(progressText, "TextColor3", "TextColor")

    -- Component API
    local ProgressBarComponent = { Instance = progressContainer, Value = currentValue }
    function ProgressBarComponent:SetValue(value, textOverride)
        value = math.clamp(value, 0, 1)
        if self.Value == value and (textOverride == nil or textOverride == progressText.Text) then return end

        self.Value = value
        local displayTextValue = textOverride or string.format("%.0f%%", value * 100)

        -- Update UI
        progressFill:TweenSize(UDim2.new(value, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        progressText.Text = displayTextValue
    end
    function ProgressBarComponent:SetVisible(visible) self.Instance.Visible = visible end
    function ProgressBarComponent:Destroy() Utility.destroyInstance(self.Instance) end

    table.insert(self._components, ProgressBarComponent)
    return ProgressBarComponent
end

-- Auto-select first tab after creation (defer needed)
task.defer(function()
    if not Window._activeTab and #Window.Tabs > 0 and Window.Tabs[1] == Tab then
         Window:_selectTab(Tab.Instance, Tab.Page)
    end
    -- Apply loaded config values after the first tab might be selected
    applyLoadedConfigValues()
end)

return Tab
end

--[[
-- CreateTabGroup (Example Structure - Implementation similar to Tab)
function Window:CreateTabGroup(groupName)
-- Create group header frame (similar to a button/section)
-- Create content frame (parent for tabs in this group)
-- Add collapse/expand logic to header click
-- Store tabs created within this group
local TabGroup = { Name = groupName, Tabs = {}, Visible = true, Instance = groupContainer }
function TabGroup:CreateTab(tabName, icon)
    local newTab = Window:CreateTab(tabName, icon)
    newTab.Instance.Parent = groupContentFrame -- Move tab instance
    table.insert(self.Tabs, newTab)
    -- Adjust group container size based on content
    return newTab
end
table.insert(self.TabGroups, TabGroup)
return TabGroup
end
]]

-- Finalize Window Setup
Window:SetTheme(currentThemeName) -- Apply initial theme to all elements

-- Auto select first tab (if exists and none selected yet)
task.defer(function() -- Defer to ensure all tabs are created
if not Window._activeTab and #Window.Tabs > 0 then
    local firstTab = Window.Tabs[1]
    Window:_selectTab(firstTab.Instance, firstTab.Page)
end
end)

return Window
end

-- Loading Screen Function
function LuminaUI:CreateLoadingScreen(callback)
-- Create loading screen container
local screenGui = Utility.createInstance("ScreenGui", { Name = "LuminaLoadingScreen", DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Global })
Utility.manageConnections(screenGui) -- Manage connections

-- Screen protection and parenting
if syn and syn.protect_gui then Utility.safeCall(syn.protect_gui, screenGui) end
screenGui.Parent = gethui and gethui() or CoreGui

local loadingFrame = Utility.createInstance("Frame", { Name = "LoadingFrame", BackgroundColor3 = Color3.fromRGB(25, 35, 45), Position = UDim2.new(0.5, -150, 0.5, -60), Size = UDim2.new(0, 300, 0, 120), Parent = screenGui })
Utility.createCorner(loadingFrame, 8)

local title = Utility.createInstance("TextLabel", { Name = "Title", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 15), Font = Enum.Font.GothamBold, Text = "LuminaUI", TextColor3 = Color3.fromRGB(230, 240, 240), TextSize = 18, Parent = loadingFrame })
local status = Utility.createInstance("TextLabel", { Name = "Status", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 45), Font = Enum.Font.Gotham, Text = "Loading...", TextColor3 = Color3.fromRGB(200, 210, 210), TextSize = 14, Parent = loadingFrame })

local progressBar = Utility.createInstance("Frame", { Name = "ProgressBar", BackgroundColor3 = Color3.fromRGB(35, 45, 55), Position = UDim2.new(0.1, 0, 0, 80), Size = UDim2.new(0.8, 0, 0, 10), Parent = loadingFrame })
Utility.createCorner(progressBar, 4)
local progressFill = Utility.createInstance("Frame", { Name = "Fill", BackgroundColor3 = Color3.fromRGB(0, 140, 180), Size = UDim2.new(0, 0, 1, 0), Parent = progressBar })
Utility.createCorner(progressFill, 4)

-- API for updating the loading screen
local LoadingScreen = { Instance = screenGui }
Utility.manageConnections(LoadingScreen) -- Manage connections for the API object

function LoadingScreen:UpdateProgress(progress, statusText)
if not progressFill or not progressFill.Parent then return end -- Guard
progress = math.clamp(progress, 0, 1)
progressFill:TweenSize(UDim2.new(progress, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
if statusText and status and status.Parent then status.Text = statusText end
end

function LoadingScreen:Destroy()
if not self.Instance or not self.Instance.Parent then return end -- Guard against double destroy
local screenGuiRef = self.Instance
self.Instance = nil -- Prevent re-entry

local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad)
local fadeTween = TweenService:Create(loadingFrame, tweenInfo, { BackgroundTransparency = 1 })
TweenService:Create(title, tweenInfo, { TextTransparency = 1 }):Play()
TweenService:Create(status, tweenInfo, { TextTransparency = 1 }):Play()
TweenService:Create(progressBar, tweenInfo, { BackgroundTransparency = 1 }):Play()
TweenService:Create(progressFill, tweenInfo, { BackgroundTransparency = 1 }):Play()
fadeTween:Play()

fadeTween.Completed:Connect(function()
    Utility.destroyInstance(screenGuiRef) -- Use pooled destroy
end)
end

-- Execute callback safely in a new thread
if callback then
task.spawn(Utility.safeCall, callback, LoadingScreen)
end

return LoadingScreen
end


return LuminaUI
