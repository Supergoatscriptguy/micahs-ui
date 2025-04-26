--[[
    LuminaUI Interface Library (Refactored v1.3.1)
    A modern, responsive UI library for Roblox scripting

    Version: 1.3.1
    Changes:
    - Reviewed layout container transparencies and ZIndex.
    - Enhanced comments and structure.
    - Maintained features from v1.3.0.
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
    Version = "1.3.1",
    Theme = {} -- Themes defined below
}
local Utility = {}
local InstancePool = {}
local ThemedElementsRegistry = {} -- Stores elements needing theme updates
local ActiveDropdown = nil -- Track currently open dropdown
local GlobalInputConnection = nil -- For closing dropdowns

-- Themes (Same as original v1.3.0)
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

-- ==================================
--      Instance Pool
-- ==================================
do
    local instances = {}
    local maxPoolSize = 50 -- Max instances of each type to keep pooled

    -- Get an instance from the pool or create a new one
    function InstancePool:Get(className)
        if not instances[className] then
            instances[className] = {}
        end

        local pool = instances[className]
        if #pool > 0 then
            local instance = table.remove(pool)
            instance.Parent = nil -- Ensure parent is nil before reuse
            instance.Name = className -- Reset name
            return instance
        else
            -- Pool is empty, create a new instance
            return Instance.new(className)
        end
    end

    -- Release an instance back to the pool (or destroy if pool is full)
    function InstancePool:Release(instance)
        if not instance or not typeof(instance) == "Instance" then return end
        local className = instance.ClassName

        if not instances[className] then
            instances[className] = {}
        end

        -- Basic reset before pooling
        instance.Parent = nil
        instance.Archivable = false -- Prevent accidental saving

        -- Clear common properties to avoid visual glitches on reuse
        if instance:IsA("GuiObject") then
            instance.BackgroundTransparency = 1
            instance.Position = UDim2.new(0, 0, 0, 0)
            instance.Size = UDim2.new(0, 0, 0, 0)
            instance.Visible = true
            instance.Rotation = 0
            instance.AnchorPoint = Vector2.new(0, 0)
            instance.ZIndex = 1
            instance.LayoutOrder = 0
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
            instance.Font = Enum.Font.SourceSans -- Reset to default
            instance.TextSize = 14 -- Reset to default
            instance.TextColor3 = Color3.new(1, 1, 1) -- Reset to default
        end
        if instance:IsA("TextBox") then
            instance.PlaceholderText = ""
            instance.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
            instance.ClearTextOnFocus = true
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
            instance.ScrollBarThickness = 0 -- Reset custom scrollbar state
        end
        if instance:IsA("UILayout") then
            -- Reset common layout properties if needed
        end
        if instance:IsA("UIConstraint") then
            -- Reset constraint properties if needed
        end

        -- Clear attributes (important for theme IDs etc.)
        for attr, _ in pairs(instance:GetAttributes()) do
            instance:SetAttribute(attr, nil)
        end

        -- Clear children (important!)
        for _, child in ipairs(instance:GetChildren()) do
            InstancePool:Release(child) -- Recursively release children
        end

        -- Disconnect any managed connections
        if instance.DisconnectAll then
            Utility.safeCall(instance.DisconnectAll, instance)
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

    -- Destroy all instances currently in the pool
    function InstancePool:Clear()
        for className, pool in pairs(instances) do
            for _, instance in ipairs(pool) do
                instance:Destroy()
            end
            instances[className] = {} -- Clear the pool table
        end
    end
end

-- ==================================
--      Utility Functions
-- ==================================
do
    local tooltipInstance = nil
    local tooltipConnection = nil
    local draggingInstance = nil
    local dragInput, dragStart, startPos

    -- Safely execute a function and print errors
    function Utility.safeCall(func, ...)
        local success, result = pcall(func, ...)
        if not success then
            warn("[LuminaUI] Error:", result)
            -- Optionally print stack trace: debug.traceback(result)
        end
        return success, result
    end

    -- Create instance using pool and apply properties
    function Utility.createInstance(className, properties)
        local instance = InstancePool:Get(className)
        for prop, value in pairs(properties or {}) do
            -- Use pcall for property assignment in case of invalid values
            local success, err = pcall(function() instance[prop] = value end)
            if not success then
                warn(("[LuminaUI] Failed to set property '%s' on %s: %s"):format(tostring(prop), className, tostring(err)))
            end
        end
        return instance
    end

    -- Release instance to pool (preferred over direct :Destroy())
    function Utility.destroyInstance(instance)
        if not instance then return end
        InstancePool:Release(instance)
    end

    -- Debounce function using os.clock for higher precision
    function Utility.debounce(func, waitTime)
        waitTime = waitTime or 0.1 -- Default wait time
        local lastCall = 0
        return function(...)
            local now = os.clock()
            if now - lastCall >= waitTime then
                lastCall = now
                return Utility.safeCall(func, ...)
            end
        end
    end

    -- Create UIStroke with theme registration
    function Utility.createStroke(instance, color, thickness, transparency, themeKey)
        themeKey = themeKey or "ElementStroke" -- Default theme key
        local stroke = Utility.createInstance("UIStroke", {
            Color = color or Color3.fromRGB(50, 50, 50),
            Thickness = thickness or 1,
            Transparency = transparency or 0,
            Parent = instance
        })
        Utility.registerThemedElement(stroke, "Color", themeKey) -- Register for theme updates
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

    -- Load icon asset ID, handling numbers and strings
    function Utility.loadIcon(id)
        if not id or id == 0 then return "" end -- Handle nil or 0
        if type(id) == "number" then
            return "rbxassetid://" .. id
        elseif type(id) == "string" then
            if string.match(id, "^%d+$") then -- Handle numeric strings
                 return "rbxassetid://" .. id
            else
                return id -- Assume it's already a full asset path or empty
            end
        else
            return "" -- Invalid type
        end
    end

    -- Get text bounds using TextService
    function Utility.getTextBounds(text, font, size, maxWidth)
        maxWidth = maxWidth or math.huge
        local success, result = Utility.safeCall(TextService.GetTextSize, TextService, text, size, font, Vector2.new(maxWidth, math.huge))
        if success then
            return result
        else
            -- Fallback or default size if GetTextSize fails
            return Vector2.new(string.len(text) * (size / 2), size) -- Rough estimate
        end
    end

    -- Format numbers (k, m, b, etc.) - Improved
    function Utility.formatNumber(value)
        if type(value) ~= "number" then return tostring(value) end
        local suffixes = {"", "k", "m", "b", "t"} -- Add more as needed
        local i = 1
        while value >= 1000 and i < #suffixes do
            value = value / 1000
            i = i + 1
        end
        if i == 1 then
            return string.format("%.0f", value) -- Whole number if less than 1k
        else
            return string.format("%.1f%s", value, suffixes[i]) -- One decimal place otherwise
        end
    end

    -- Darken color by a factor (0 to 1)
    function Utility.darker(color, factor)
        factor = math.clamp(1 - (factor or 0.2), 0, 1)
        return Color3.new(color.R * factor, color.G * factor, color.B * factor)
    end

    -- Lighten color by a factor (0 to 1)
    function Utility.lighter(color, factor)
        factor = factor or 0.2
        return Color3.new(
            math.clamp(color.R + (1 - color.R) * factor, 0, 1),
            math.clamp(color.G + (1 - color.G) * factor, 0, 1),
            math.clamp(color.B + (1 - color.B) * factor, 0, 1)
        )
    end

    -- Manage connections for an object (Instance or Lua table)
    function Utility.manageConnections(object)
        if object._connections then return end -- Already managed

        object._connections = {}

        -- Add a connection to the managed list
        function object:AddConnection(connection)
            if not self._connections then self._connections = {} end
            table.insert(self._connections, connection)
        end

        -- Disconnect all managed connections
        function object:DisconnectAll()
            if not self._connections then return end
            for i = #self._connections, 1, -1 do -- Iterate backwards for safe removal
                local conn = self._connections[i]
                Utility.safeCall(conn.Disconnect, conn)
                table.remove(self._connections, i)
            end
        end

        -- If it's an Instance, hook into Destroying
        if typeof(object) == "Instance" then
            -- Store original Destroy if needed, but pooling handles cleanup
            -- local originalDestroy = object.Destroy

            -- Connect to Destroying event for cleanup
            local destroyingConn
            destroyingConn = object.Destroying:Connect(function()
                object:DisconnectAll()
                -- Also disconnect the Destroying connection itself
                if destroyingConn then Utility.safeCall(destroyingConn.Disconnect, destroyingConn) end
                -- If not using pooling, call originalDestroy here
                -- Note: Pooling's Release function already calls DisconnectAll
            end)
            -- No need to add destroyingConn to _connections list
        end
    end

    -- Create Tooltip (Singleton Pattern)
    function Utility.createTooltip(libraryInstance, theme)
        if tooltipInstance and tooltipInstance.Parent then return tooltipInstance end -- Return existing if valid

        tooltipInstance = Utility.createInstance("Frame", {
            Name = "LuminaTooltip",
            BackgroundColor3 = theme.NotificationBackground,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 0, 0), -- Auto-sized based on text
            Position = UDim2.new(0, 0, 0, 0), -- Position updated dynamically
            Visible = false,
            ZIndex = 1000, -- High ZIndex to be on top
            Parent = libraryInstance,
            ClipsDescendants = true
        })
        Utility.createCorner(tooltipInstance, 4)
        local stroke = Utility.createStroke(tooltipInstance, theme.ElementStroke, 1, 0, "ElementStroke") -- Use specific theme key
        Utility.registerThemedElement(tooltipInstance, "BackgroundColor3", "NotificationBackground")
        -- Stroke is already registered by createStroke

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

        -- Manage connections for the tooltip itself to clean up RenderStepped
        Utility.manageConnections(tooltipInstance)

        return tooltipInstance
    end

    -- Show Tooltip with text and optional offset
    function Utility.showTooltip(text, theme, yOffset)
        if not LuminaUI.RootInstance then return end -- Ensure UI root exists
        local tooltip = Utility.createTooltip(LuminaUI.RootInstance, theme)
        if not tooltip or not tooltip.Parent then return end -- Guard against race conditions

        local textLabel = tooltip:FindFirstChild("Text")
        if not textLabel then return end

        textLabel.Text = text
        local textBounds = Utility.getTextBounds(text, textLabel.Font, textLabel.TextSize, 280) -- Max width 280px
        tooltip.Size = UDim2.new(0, math.min(textBounds.X + 16, 300), 0, textBounds.Y + 16) -- Add padding, max width 300

        yOffset = yOffset or 5 -- Default vertical offset from mouse

        local function updatePosition()
            -- Check if tooltip still exists and is visible
            if not tooltip or not tooltip.Parent or not tooltip.Visible then
                if tooltipConnection then
                    tooltipConnection:Disconnect()
                    tooltipConnection = nil
                end
                return
            end

            local mousePos = UserInputService:GetMouseLocation()
            local viewportSize = workspace.CurrentCamera.ViewportSize

            -- Calculate desired position (above and to the right of cursor)
            local posX = mousePos.X + 15
            local posY = mousePos.Y - tooltip.AbsoluteSize.Y - yOffset

            -- Adjust X if off-screen right
            if posX + tooltip.AbsoluteSize.X > viewportSize.X then
                posX = mousePos.X - tooltip.AbsoluteSize.X - 15 -- Move to the left
            end
            -- Adjust X if off-screen left (less common)
            if posX < 0 then
                posX = 5 -- Keep slightly offset from edge
            end
             -- Adjust Y if off-screen top
            if posY < 0 then
                 posY = mousePos.Y + 15 -- Show below cursor if no space above
            end
             -- Adjust Y if off-screen bottom (if showing below cursor)
             if posY + tooltip.AbsoluteSize.Y > viewportSize.Y then
                 posY = viewportSize.Y - tooltip.AbsoluteSize.Y - 5 -- Keep slightly offset from edge
             end

            tooltip.Position = UDim2.new(0, posX, 0, posY)
        end

        -- Initial position update
        updatePosition()
        tooltip.Visible = true

        -- Disconnect previous connection if exists
        if tooltipConnection then tooltipConnection:Disconnect() end

        -- Create new connection and store it globally (not on the tooltip instance itself)
        tooltipConnection = RunService.RenderStepped:Connect(updatePosition)
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

    -- Make a frame draggable by its handle (or itself)
    function Utility.makeDraggable(frame, handle)
        handle = handle or frame -- Default handle to the frame itself
        local connections = {} -- Store connections specific to this draggable instance

        local inputBeganConn = handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if draggingInstance then return end -- Prevent dragging multiple items simultaneously

                draggingInstance = frame -- Set the globally tracked dragging instance
                dragStart = input.Position -- Record starting mouse/touch position
                startPos = frame.Position -- Record starting frame position

                -- Connection to detect when dragging ends
                local inputChangedConn
                inputChangedConn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if draggingInstance == frame then -- Only clear if this was the instance being dragged
                            draggingInstance = nil
                        end
                        if inputChangedConn then inputChangedConn:Disconnect() end
                        -- Remove from connections table? Not strictly necessary if using Destroying cleanup
                    end
                end)
                table.insert(connections, inputChangedConn) -- Track this connection
            end
        end)
        table.insert(connections, inputBeganConn)

        -- Connection to track mouse/touch movement *while the button is held down*
        local inputChangedOuterConn = UserInputService.InputChanged:Connect(function(input)
             if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if draggingInstance == frame then -- Only update global dragInput if this instance is being dragged
                    dragInput = input -- Update the global input object for the Heartbeat update
                end
            end
        end)
         table.insert(connections, inputChangedOuterConn)

         -- Add a cleanup method to disconnect these specific drag connections when the frame is destroyed
         frame._dragConnections = connections -- Store on the frame instance
         local destroyingConn = frame.Destroying:Connect(function()
             for _, conn in ipairs(frame._dragConnections or {}) do
                 Utility.safeCall(conn.Disconnect, conn)
             end
             frame._dragConnections = nil
             if draggingInstance == frame then draggingInstance = nil end -- Clear global state if destroyed while dragging
         end)
         -- No need to track destroyingConn itself, it disconnects automatically
    end

    -- Global Drag Update Logic (Runs continuously)
    task.spawn(function()
        local lastInputProcessed = nil
        RunService.Heartbeat:Connect(function(dt) -- Use Heartbeat for physics-related updates like position
            if draggingInstance and dragInput and dragInput ~= lastInputProcessed then
                local delta = dragInput.Position - dragStart
                local newPos = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )

                -- Clamp position to viewport boundaries
                local viewport = workspace.CurrentCamera.ViewportSize
                local absSize = draggingInstance.AbsoluteSize
                local anchor = draggingInstance.AnchorPoint

                -- Calculate the top-left corner's desired absolute position
                local absPosX = newPos.X.Offset + viewport.X * newPos.X.Scale
                local absPosY = newPos.Y.Offset + viewport.Y * newPos.Y.Scale
                local topLeftX = absPosX - (absSize.X * anchor.X)
                local topLeftY = absPosY - (absSize.Y * anchor.Y)

                -- Clamp X
                local clampedOffsetX = newPos.X.Offset
                if topLeftX < 0 then
                    clampedOffsetX = newPos.X.Offset - topLeftX
                elseif topLeftX + absSize.X > viewport.X then
                    clampedOffsetX = newPos.X.Offset - (topLeftX + absSize.X - viewport.X)
                end

                -- Clamp Y
                local clampedOffsetY = newPos.Y.Offset
                if topLeftY < 0 then
                    clampedOffsetY = newPos.Y.Offset - topLeftY
                elseif topLeftY + absSize.Y > viewport.Y then
                    clampedOffsetY = newPos.Y.Offset - (topLeftY + absSize.Y - viewport.Y)
                end

                -- Apply the clamped position
                draggingInstance.Position = UDim2.new(newPos.X.Scale, clampedOffsetX, newPos.Y.Scale, clampedOffsetY)

                lastInputProcessed = dragInput -- Mark this input as processed
            elseif not draggingInstance then
                -- Reset global drag state if nothing is being dragged
                dragInput = nil
                lastInputProcessed = nil
            end
        end)
    end)

    -- Configuration Saving (Requires Synapse/Executor environment functions)
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

        -- Iterate through registered flags to get current values
        for flag, elementData in pairs(LuminaUI.Flags) do
            -- Only save if it has a known type and value
            if elementData and elementData.Type and elementData.Value ~= nil then
                 data.Elements[flag] = {
                    Type = elementData.Type,
                    Value = elementData.Value
                }
                -- Special handling for Color3 values (convert to table)
                if typeof(elementData.Value) == "Color3" then
                    data.Elements[flag].Value = {
                        R = elementData.Value.R,
                        G = elementData.Value.G,
                        B = elementData.Value.B
                    }
                end
            end
        end

        local success, encodedData = Utility.safeCall(HttpService.JSONEncode, HttpService, data)
        if not success then
            warn("[LuminaUI] Failed to encode configuration:", encodedData)
            return
        end

        local configName = settings.ConfigurationSaving.FileName or "LuminaConfig" -- Use setting or default
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

        -- Write the file
        local writeSuccess, writeErr = Utility.safeCall(writefile, filePath, encodedData)
        if not writeSuccess then
            warn("[LuminaUI] Failed to write configuration file:", writeErr)
        end
    end

    -- Configuration Loading (Requires Synapse/Executor environment functions)
    function Utility.loadConfig(settings)
        local loadedData = { UIPosition = nil, Elements = {} }
        if not settings.ConfigurationSaving or not settings.ConfigurationSaving.Enabled then return loadedData end
        if not isfile or not readfile then warn("[LuminaUI] 'isfile' or 'readfile' not available. Configuration loading disabled.") return loadedData end

        local configName = settings.ConfigurationSaving.FileName or "LuminaConfig"
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
            -- Consider attempting to delete the corrupted file here: Utility.safeCall(delfile, filePath)
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
                    -- Special handling for Color3 values (convert back from table)
                    if elementData.Type == "ColorPicker" and typeof(elementData.Value) == "table" and
                       elementData.Value.R ~= nil and elementData.Value.G ~= nil and elementData.Value.B ~= nil then
                        loadedData.Elements[flag] = {
                            Type = elementData.Type,
                            Value = Color3.new(elementData.Value.R, elementData.Value.G, elementData.Value.B)
                        }
                    else
                        loadedData.Elements[flag] = { Type = elementData.Type, Value = elementData.Value }
                    end
                end
            end
        end

        return loadedData
    end

    -- Apply Custom Scrollbar to a ScrollingFrame
    function Utility.applyCustomScrollbar(scrollFrame, theme, thickness)
        if not scrollFrame:IsA("ScrollingFrame") then
            warn("[LuminaUI] applyCustomScrollbar called on non-ScrollingFrame:", scrollFrame)
            return
        end
        -- Check if already applied
        if scrollFrame:FindFirstChild("CustomScrollbar") then return end

        thickness = thickness or 4
        local connections = {} -- Store connections related to this scrollbar

        -- Hide default scrollbar
        scrollFrame.ScrollBarThickness = 0
        scrollFrame.ScrollBarImageTransparency = 1
        scrollFrame.ScrollingEnabled = true -- Ensure scrolling is enabled

        -- Create custom scrollbar elements
        local scrollbar = Utility.createInstance("Frame", {
            Name = "CustomScrollbar",
            Size = UDim2.new(0, thickness, 1, 0),
            Position = UDim2.new(1, -thickness, 0, 0), -- Positioned to the right
            AnchorPoint = Vector2.new(1, 0), -- Anchored to top-right
            BackgroundColor3 = theme.ScrollBarBackground,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            ZIndex = scrollFrame.ZIndex + 10, -- Ensure above content
            Parent = scrollFrame,
            Visible = false -- Initially hidden until needed
        })
        Utility.createCorner(scrollbar, thickness / 2)
        Utility.registerThemedElement(scrollbar, "BackgroundColor3", "ScrollBarBackground")

        local scrollThumb = Utility.createInstance("Frame", {
            Name = "ScrollThumb",
            Size = UDim2.new(1, 0, 0.1, 0), -- Initial size, will be updated dynamically
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = theme.ScrollBarForeground,
            BorderSizePixel = 0,
            ZIndex = scrollbar.ZIndex + 1, -- Above scrollbar background
            Parent = scrollbar
        })
        Utility.createCorner(scrollThumb, thickness / 2)
        Utility.registerThemedElement(scrollThumb, "BackgroundColor3", "ScrollBarForeground")

        -- Function to update scrollbar visibility and thumb size/position
        local function updateScrollbar()
            -- Check if instances are still valid
            if not scrollFrame or not scrollFrame.Parent or not scrollbar or not scrollbar.Parent or not scrollThumb or not scrollThumb.Parent then
                return
            end

            local canvasSizeY = scrollFrame.CanvasSize.Y.Offset
            local frameSizeY = scrollFrame.AbsoluteSize.Y

            -- Avoid division by zero or invalid calculations
            if frameSizeY <= 0 then frameSizeY = 1 end

            -- Determine if scrollbar is needed
            if canvasSizeY <= frameSizeY then
                scrollbar.Visible = false
                return
            else
                scrollbar.Visible = true
            end

            local scrollableDist = canvasSizeY - frameSizeY
            if scrollableDist <= 0 then scrollableDist = 1 end -- Avoid division by zero

            -- Calculate thumb size (proportional to visible content ratio)
            local thumbSizeScale = math.clamp(frameSizeY / canvasSizeY, 0.05, 1) -- Min 5% height, max 100%

            -- Calculate thumb position based on CanvasPosition
            local scrollPercent = math.clamp(scrollFrame.CanvasPosition.Y / scrollableDist, 0, 1)
            local thumbPosScale = scrollPercent * (1 - thumbSizeScale) -- Position within the available track space

            scrollThumb.Size = UDim2.new(1, 0, thumbSizeScale, 0)
            scrollThumb.Position = UDim2.new(0, 0, thumbPosScale, 0)
        end

        -- Connect update events
        table.insert(connections, scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(updateScrollbar))
        table.insert(connections, scrollFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScrollbar))
        table.insert(connections, scrollFrame:GetPropertyChangedSignal("CanvasSize"):Connect(updateScrollbar))

        -- Thumb dragging logic
        local isDraggingThumb = false
        local dragStartMouseY, dragStartCanvasY

        table.insert(connections, scrollThumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingThumb = true
                dragStartMouseY = input.Position.Y
                dragStartCanvasY = scrollFrame.CanvasPosition.Y
                -- Prevent text selection while dragging scrollbar
                UserInputService.TextSelectionEnabled = false
                -- Optional: Slightly change thumb appearance on drag
                -- TweenService:Create(scrollThumb, TweenInfo.new(0.1), { BackgroundTransparency = 0.3 }):Play()
            end
        end))

        -- Use global InputEnded/InputChanged to handle dragging state reliably
        table.insert(connections, UserInputService.InputEnded:Connect(function(input)
            if isDraggingThumb and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                isDraggingThumb = false
                UserInputService.TextSelectionEnabled = true -- Re-enable text selection
                -- Optional: Revert thumb appearance
                -- TweenService:Create(scrollThumb, TweenInfo.new(0.1), { BackgroundTransparency = 0 }):Play()
            end
        end))

        table.insert(connections, UserInputService.InputChanged:Connect(function(input)
            if isDraggingThumb and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local deltaY = input.Position.Y - dragStartMouseY
                local canvasSizeY = scrollFrame.CanvasSize.Y.Offset
                local frameSizeY = scrollFrame.AbsoluteSize.Y
                local scrollableDist = canvasSizeY - frameSizeY

                if scrollableDist > 0 then
                    local thumbSizeScale = scrollThumb.Size.Y.Scale
                    local trackSize = frameSizeY * (1 - thumbSizeScale) -- The pixel height the thumb can move within
                    if trackSize <= 0 then trackSize = 1 end -- Avoid division by zero

                    -- Calculate how much the canvas should move per pixel of thumb movement
                    local scrollMultiplier = scrollableDist / trackSize
                    local newCanvasY = dragStartCanvasY + (deltaY * scrollMultiplier)

                    -- Update CanvasPosition directly, clamping ensures it stays within bounds
                    scrollFrame.CanvasPosition = Vector2.new(
                        scrollFrame.CanvasPosition.X,
                        math.clamp(newCanvasY, 0, scrollableDist)
                    )
                end
            end
        end))

        -- Mouse wheel scrolling (applied directly to the scrollFrame)
        table.insert(connections, scrollFrame.MouseEnter:Connect(function() scrollFrame:SetAttribute("MouseOver", true) end))
        table.insert(connections, scrollFrame.MouseLeave:Connect(function() scrollFrame:SetAttribute("MouseOver", false) end))
        table.insert(connections, UserInputService.InputChanged:Connect(function(input)
            -- Only scroll if mouse is over this specific scroll frame
            if scrollFrame:GetAttribute("MouseOver") and input.UserInputType == Enum.UserInputType.MouseWheel then
                local scrollDelta = input.Position.Z -- Z indicates wheel delta
                local currentPos = scrollFrame.CanvasPosition.Y
                local canvasSizeY = scrollFrame.CanvasSize.Y.Offset
                local frameSizeY = scrollFrame.AbsoluteSize.Y
                local maxScroll = math.max(0, canvasSizeY - frameSizeY) -- Ensure maxScroll is not negative

                if maxScroll > 0 then
                    -- Adjust multiplier for desired scroll speed, negative for natural scroll direction
                    local scrollAmount = scrollDelta * -60
                    scrollFrame.CanvasPosition = Vector2.new(
                        scrollFrame.CanvasPosition.X,
                        math.clamp(currentPos + scrollAmount, 0, maxScroll)
                    )
                end
            end
        end))

        -- Initial update (defer slightly for sizes to calculate)
        task.defer(updateScrollbar)

        -- Cleanup: Store connections on the scrollFrame and disconnect on Destroying
        scrollFrame:SetAttribute("__LuminaScrollbarConnections", connections)
        local destroyingConn = scrollFrame.Destroying:Connect(function()
            local conns = scrollFrame:GetAttribute("__LuminaScrollbarConnections")
            if conns then
                for _, conn in ipairs(conns) do
                    Utility.safeCall(conn.Disconnect, conn)
                end
            end
            -- Ensure thumb dragging state is reset if destroyed mid-drag
            if isDraggingThumb then
                 UserInputService.TextSelectionEnabled = true
            end
            -- Destroy the scrollbar elements manually if pooling isn't used,
            -- but pooling's Release should handle children.
            -- Utility.destroyInstance(scrollbar) -- Let pooling handle this via parent release
        end)
        -- No need to track destroyingConn itself

        return scrollbar
    end

    -- Ripple Effect on click
    function Utility.rippleEffect(parent, color, speed)
        if not parent:IsA("GuiObject") then return end -- Only works on GuiObjects

        color = color or Color3.fromRGB(255, 255, 255)
        speed = speed or 0.4
        local mousePos = UserInputService:GetMouseLocation()

        -- Calculate position relative to the parent's top-left corner
        local relativePos = mousePos - parent.AbsolutePosition

        local ripple = Utility.createInstance("Frame", {
            Name = "Ripple",
            BackgroundColor3 = color,
            BackgroundTransparency = 0.7,
            Position = UDim2.new(0, relativePos.X, 0, relativePos.Y),
            Size = UDim2.new(0, 0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = (parent.ZIndex or 1) + 1, -- Ensure ripple is visually above parent
            Parent = parent,
            ClipsDescendants = true -- Keep ripple contained within parent bounds
        })
        Utility.createCorner(ripple, 1000) -- Make it circular (large radius)

        -- Calculate target diameter (slightly larger than the parent's diagonal)
        local sizeX, sizeY = parent.AbsoluteSize.X, parent.AbsoluteSize.Y
        local diameter = math.sqrt(sizeX^2 + sizeY^2) * 1.2 -- Adjust multiplier as needed

        local tween = TweenService:Create(ripple, TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, diameter, 0, diameter),
            BackgroundTransparency = 1
        })
        tween:Play()

        -- Use pooling for cleanup
        tween.Completed:Connect(function()
            Utility.destroyInstance(ripple)
        end)
    end

    -- Pulse Effect (scale animation)
    function Utility.pulseEffect(object, scaleIncrease, duration)
        if not object or not object.Parent then return end -- Guard

        scaleIncrease = scaleIncrease or 1.05
        duration = duration or 0.15 -- Faster pulse

        local originalSize = object.Size
        local targetSize = UDim2.new(
            originalSize.X.Scale * scaleIncrease, originalSize.X.Offset * scaleIncrease,
            originalSize.Y.Scale * scaleIncrease, originalSize.Y.Offset * scaleIncrease
        )

        local tweenInfo = TweenInfo.new(duration / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenUp = TweenService:Create(object, tweenInfo, { Size = targetSize })
        local tweenDown = TweenService:Create(object, tweenInfo, { Size = originalSize })

        tweenUp:Play()
        tweenUp.Completed:Connect(function(playbackState)
            -- Ensure object still exists and tween completed normally before playing next part
            if playbackState == Enum.PlaybackState.Completed and object and object.Parent then
                tweenDown:Play()
            end
        end)
    end

    -- Typewrite Effect for TextLabels
    function Utility.typewriteEffect(textLabel, text, speed)
        if not textLabel or not textLabel:IsA("TextLabel") then return end

        speed = speed or 0.03
        textLabel.Text = ""
        local currentCoroutine = coroutine.running()
        local cancelled = false

        local connection
        connection = textLabel.Destroying:Connect(function()
             -- Stop the effect if the label is destroyed
             cancelled = true
             if currentCoroutine then
                 task.cancel(currentCoroutine) -- Attempt to cancel the coroutine
             end
             if connection then connection:Disconnect() end -- Disconnect self
        end)

        for i = 1, #text do
            if cancelled or not textLabel or not textLabel.Parent then break end -- Stop if cancelled or label is gone
            textLabel.Text = string.sub(text, 1, i)
            task.wait(speed)
        end

        if connection then connection:Disconnect() end -- Clean up connection
        currentCoroutine = nil -- Clear reference
    end

    -- Create Blur Effect (animated)
    function Utility.createBlur(parent, strength)
        strength = strength or 10
        local blur = Utility.createInstance("BlurEffect", {
            Size = 0, -- Start at 0
            Parent = parent
        })
        local tween = TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = strength })
        tween:Play()
        -- Manage cleanup via pooling when parent is destroyed or manually removed
        return blur
    end

    -- Remove Blur Effect (animated)
    function Utility.removeBlur(blur)
        if not blur or not blur.Parent then return end
        local tween = TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 0 })
        tween:Play()
        tween.Completed:Connect(function(playbackState)
            -- Use pooled destroy after animation completes
            if playbackState == Enum.PlaybackState.Completed then
                Utility.destroyInstance(blur)
            end
        end)
    end

    -- Register element for theme updates using attributes
    function Utility.registerThemedElement(instance, property, themeKey, hoverThemeKey, transformFunc)
        if not instance or not instance.Parent then return end
        -- Store theme info directly as attributes on the instance
        instance:SetAttribute("LuminaThemeKey_"..property, themeKey)
        if hoverThemeKey then
            instance:SetAttribute("LuminaThemeHoverKey_"..property, hoverThemeKey)
        end
        -- Store transform function (needs serialization or a different approach if saving/loading needed)
        -- For now, transformFunc is applied directly during theme application if provided.
        -- If transformFunc is needed, it might be better to handle it in the component's theme update logic.

        -- Apply initial theme value immediately
        local theme = LuminaUI.CurrentTheme -- Assumes LuminaUI.CurrentTheme is set
        if theme then
            local value = theme[themeKey]
            if value then
                if transformFunc then value = transformFunc(value) end
                Utility.safeCall(function() instance[property] = value end)
            else
                 warn("[LuminaUI] Initial theme key not found:", themeKey)
            end
        end
    end

    -- Unregister element from theme updates (remove attributes)
    function Utility.unregisterThemedElement(instance, property)
        if not instance then return end
        instance:SetAttribute("LuminaThemeKey_"..property, nil)
        instance:SetAttribute("LuminaThemeHoverKey_"..property, nil)
    end

    -- Apply theme to all registered elements by iterating through descendants with attributes
    function Utility.applyThemeToAll(rootInstance, theme)
        if not rootInstance or not theme then return end
        LuminaUI.CurrentTheme = theme -- Update global reference

        for _, instance in ipairs(rootInstance:GetDescendants()) do
            local attributes = instance:GetAttributes()
            for attrName, themeKey in pairs(attributes) do
                if string.sub(attrName, 1, 15) == "LuminaThemeKey_" then
                    local property = string.sub(attrName, 16) -- Extract property name
                    local value = theme[themeKey]
                    if value then
                        -- Check for a transform function (this part is tricky with attributes)
                        -- Simplification: Assume no transform needed here, handle in component logic if necessary.
                        Utility.safeCall(function() instance[property] = value end)
                    else
                        warn("[LuminaUI] Theme key not found during update:", themeKey)
                    end
                end
                -- Note: Hover keys are not applied here, they are typically handled by MouseEnter/Leave events
            end
        end

        -- Update tooltip theme separately if it exists
        if tooltipInstance and tooltipInstance.Parent then
             local textLabel = tooltipInstance:FindFirstChild("Text")
             local stroke = tooltipInstance:FindFirstChildOfClass("UIStroke")
             if tooltipInstance:GetAttribute("LuminaThemeKey_BackgroundColor3") then
                 tooltipInstance.BackgroundColor3 = theme[tooltipInstance:GetAttribute("LuminaThemeKey_BackgroundColor3")] or theme.NotificationBackground
             end
             if textLabel and textLabel:GetAttribute("LuminaThemeKey_TextColor3") then
                 textLabel.TextColor3 = theme[textLabel:GetAttribute("LuminaThemeKey_TextColor3")] or theme.TextColor
             end
             if stroke and stroke:GetAttribute("LuminaThemeKey_Color") then
                 stroke.Color = theme[stroke:GetAttribute("LuminaThemeKey_Color")] or theme.ElementStroke
             end
        end
    end

    -- Cleanup registry (No longer needed with attribute-based system)
    -- function Utility.clearThemeRegistry() end -- Deprecated

    -- Global click listener for closing dropdowns/pickers
    function Utility.setupGlobalInputListener()
        if GlobalInputConnection then GlobalInputConnection:Disconnect() end -- Disconnect previous if any

        GlobalInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end -- Ignore clicks handled by Roblox core UI (like chat)

            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and ActiveDropdown then
                -- Check if the click was outside the active dropdown/picker's container instance
                local clickedInstance = input.Target -- Get the instance clicked
                local isDescendant = false
                if clickedInstance and ActiveDropdown.Instance then
                    isDescendant = clickedInstance:IsDescendantOf(ActiveDropdown.Instance)
                end

                -- If the click was not on the dropdown/picker itself or one of its children
                if not isDescendant then
                    -- Call the ToggleOpen method (assuming it exists) to close it
                    if ActiveDropdown.ToggleOpen then
                        Utility.safeCall(ActiveDropdown.ToggleOpen, ActiveDropdown, false)
                    end
                    ActiveDropdown = nil -- Clear the active dropdown reference
                end
            end
        end)
    end

    -- Cleanup global listener
    function Utility.cleanupGlobalInputListener()
        if GlobalInputConnection then
            GlobalInputConnection:Disconnect()
            GlobalInputConnection = nil
        end
        ActiveDropdown = nil -- Ensure cleared on cleanup
    end

end

-- ==================================
--      UI Creation (Core Structure)
-- ==================================

-- Private Helper Functions

-- Creates the base ScreenGui and handles protection
local function _createBaseUI(settings)
    -- Destroy existing UI and clear resources first
    if LuminaUI.RootInstance then
        Utility.safeCall(LuminaUI.RootInstance.Destroy, LuminaUI.RootInstance) -- Use safeCall
        LuminaUI.RootInstance = nil
        Utility.cleanupGlobalInputListener()
        InstancePool:Clear() -- Clear pool on full UI recreation
    end

    local screenGui = Utility.createInstance("ScreenGui", {
        Name = "LuminaUI_" .. (settings.Name or "Window"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global, -- Use global ZIndex behavior
        DisplayOrder = 100, -- Control render order relative to other ScreenGuis
        -- Parent is set after protection
    })
    LuminaUI.RootInstance = screenGui -- Store root reference globally

    -- Apply protection and set parent (handle different executor environments)
    local parentSuccess = false
    if gethui then -- Synapse X, etc.
        screenGui.Parent = gethui()
        parentSuccess = true
    elseif syn and syn.protect_gui then -- Older Synapse
        Utility.safeCall(syn.protect_gui, screenGui)
        screenGui.Parent = CoreGui
        parentSuccess = true
    end
    -- Fallback to CoreGui if no specific environment detected or parenting failed
    if not parentSuccess then
        screenGui.Parent = CoreGui
    end

    -- Setup global listener for dropdowns/pickers
    Utility.setupGlobalInputListener()

    -- Cleanup on destroy
    screenGui.Destroying:Connect(function()
        Utility.cleanupGlobalInputListener()
        Utility.hideTooltip() -- Ensure tooltip is hidden
        if LuminaUI.RootInstance == screenGui then LuminaUI.RootInstance = nil end
        -- Instance pool is cleared on next creation, not necessarily on destroy
    end)

    return screenGui
end

-- Creates the Key System UI if enabled
local function _createKeySystem(parent, settings, theme)
    if not settings.KeySystem or not settings.KeySystem.Enabled then return true end -- Key system not enabled or needed

    local keyAccepted = Instance.new("BindableEvent") -- Use an event to signal completion
    local keySystemFrame = nil -- Forward declare for cleanup

    keySystemFrame = Utility.createInstance("Frame", {
        Name = "KeySystem",
        Size = UDim2.new(0, 320, 0, 150),
        Position = settings.UIPosition or UDim2.new(0.5, 0, 0.5, 0), -- Use loaded/default UI position
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Parent = parent
    })
    Utility.createCorner(keySystemFrame, 6)
    Utility.registerThemedElement(keySystemFrame, "BackgroundColor3", "Background")
    Utility.manageConnections(keySystemFrame) -- Manage connections for this frame

    local keyTitle = Utility.createInstance("TextLabel", {
        Name = "Title", Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 5), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "Key System", TextColor3 = theme.TextColor, TextSize = 16, Parent = keySystemFrame
    })
    Utility.registerThemedElement(keyTitle, "TextColor3", "TextColor")

    local keyDescription = Utility.createInstance("TextLabel", {
        Name = "Description", Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0, 10, 0, 35), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = settings.KeySystem.Message or "Please enter the key to continue.", TextColor3 = theme.SubTextColor, TextSize = 14, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center, Parent = keySystemFrame
    })
    Utility.registerThemedElement(keyDescription, "TextColor3", "SubTextColor")

    local keyTextbox = Utility.createInstance("TextBox", {
        Name = "KeyInput", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 75), BackgroundColor3 = theme.InputBackground, PlaceholderText = "Enter Key", PlaceholderColor3 = theme.InputPlaceholder, Text = "", TextColor3 = theme.TextColor, Font = Enum.Font.Gotham, TextSize = 14, ClearTextOnFocus = false, Parent = keySystemFrame
    })
    Utility.createCorner(keyTextbox, 4)
    local keyStroke = Utility.createStroke(keyTextbox, theme.InputStroke, 1, 0, "InputStroke")
    Utility.registerThemedElement(keyTextbox, "BackgroundColor3", "InputBackground")
    Utility.registerThemedElement(keyTextbox, "PlaceholderColor3", "InputPlaceholder")
    Utility.registerThemedElement(keyTextbox, "TextColor3", "TextColor")
    -- Stroke already registered

    local submitButton = Utility.createInstance("TextButton", {
        Name = "Submit", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 110), BackgroundColor3 = theme.ElementBackground, Font = Enum.Font.GothamBold, Text = "Submit", TextColor3 = theme.TextColor, TextSize = 14, Parent = keySystemFrame
    })
    Utility.createCorner(submitButton, 4)
    local submitStroke = Utility.createStroke(submitButton, theme.ElementStroke, 1)
    Utility.registerThemedElement(submitButton, "BackgroundColor3", "ElementBackground", "ElementBackgroundHover")
    Utility.registerThemedElement(submitButton, "TextColor3", "TextColor")
    -- Stroke already registered

    -- Effects
    local normalColor = theme.ElementBackground
    local hoverColor = theme.ElementBackgroundHover
    keySystemFrame:AddConnection(submitButton.MouseEnter:Connect(function() TweenService:Create(submitButton, TweenInfo.new(0.2), { BackgroundColor3 = hoverColor }):Play() end))
    keySystemFrame:AddConnection(submitButton.MouseLeave:Connect(function() TweenService:Create(submitButton, TweenInfo.new(0.2), { BackgroundColor3 = normalColor }):Play() end))
    keySystemFrame:AddConnection(submitButton.MouseButton1Click:Connect(function() Utility.rippleEffect(submitButton) end))

    -- Key Check Logic
    local function checkKey(key)
        if not key or key == "" then return false end
        return (settings.KeySystem.Key == key) or
               (type(settings.KeySystem.Keys) == "table" and table.find(settings.KeySystem.Keys, key)) or
               false
    end

    local function onSubmit()
        if checkKey(keyTextbox.Text) then
            keyAccepted:Fire(true) -- Signal success
            Utility.destroyInstance(keySystemFrame) -- Use pooled destroy
        else
            keyTextbox.Text = "" -- Clear input on failure
            -- Flash red effect
            local originalColor = keyTextbox.BackgroundColor3
            local errorColor = Color3.fromRGB(255, 80, 80)
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true) -- Auto-reverse
            local flashTween = TweenService:Create(keyTextbox, tweenInfo, { BackgroundColor3 = errorColor })
            flashTween:Play()
            flashTween.Completed:Connect(function()
                -- Ensure color reverts fully even if interrupted
                if keyTextbox and keyTextbox.Parent then keyTextbox.BackgroundColor3 = originalColor end
            end)
        end
    end

    keySystemFrame:AddConnection(submitButton.MouseButton1Click:Connect(onSubmit))
    -- Allow submitting with Enter key
    keySystemFrame:AddConnection(keyTextbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then onSubmit() end
    end))

    -- Make draggable
    Utility.makeDraggable(keySystemFrame)

    -- Wait for the keyAccepted event to fire
    local success = keyAccepted.Event:Wait()
    keyAccepted:Destroy() -- Clean up the event

    return success -- Return true if key was accepted, false otherwise (e.g., if UI closed)
end

-- Creates the main window frame and shadow
local function _createMainFrame(parent, settings, theme, initialPos)
    local mainFrame = Utility.createInstance("Frame", {
        Name = "MainFrame",
        Size = settings.Size,
        Position = initialPos or UDim2.new(0.5, 0, 0.5, 0), -- Use loaded/default or center
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true, -- Important for minimize animation and rounded corners
        Parent = parent,
        ZIndex = 0 -- Base ZIndex for the window
    })
    Utility.createCorner(mainFrame, 8)
    Utility.registerThemedElement(mainFrame, "BackgroundColor3", "Background")
    Utility.manageConnections(mainFrame) -- Manage connections for the frame

    -- Shadow (using 9-slice)
    local shadow = Utility.createInstance("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 35, 1, 35), -- Slightly larger than frame for shadow effect
        ZIndex = -1, -- Behind the main frame
        Image = "rbxassetid://5554236805", -- Standard 9-slice shadow asset
        ImageColor3 = theme.Shadow,
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277), -- Adjust slice center as needed for the asset
        SliceScale = 1, -- Render at 1:1 pixel density
        Parent = mainFrame
    })
    Utility.registerThemedElement(shadow, "ImageColor3", "Shadow")

    return mainFrame
end

-- Creates the top bar with title, icon, and control buttons
local function _createTopbar(parent, settings, theme)
    local topbarHeight = 45
    local topbar = Utility.createInstance("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, topbarHeight),
        BackgroundColor3 = theme.Topbar,
        BorderSizePixel = 0,
        Parent = parent,
        ZIndex = 2 -- Above main background, below potential popups
    })
    -- Apply corner only to top-left and top-right visually by covering bottom
    Utility.createCorner(topbar, 8)
    Utility.registerThemedElement(topbar, "BackgroundColor3", "Topbar")

    -- Corner fix (covers bottom corners of the topbar's rounding inside the main frame)
    local cornerFix = Utility.createInstance("Frame", {
        Name = "CornerFix",
        Size = UDim2.new(1, 0, 0.5, 1), -- Half height, full width
        Position = UDim2.new(0, 0, 0.5, 0), -- Positioned at the bottom half
        BackgroundColor3 = theme.Topbar,
        BorderSizePixel = 0,
        ZIndex = 1, -- Below topbar content, above main frame content
        Parent = topbar
    })
    Utility.registerThemedElement(cornerFix, "BackgroundColor3", "Topbar")

    -- Icon (optional)
    local titleXOffset = 15 -- Default left padding for title
    if settings.Icon and settings.Icon ~= 0 then
        local iconSize = 20
        local iconPadding = 12
        local icon = Utility.createInstance("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, iconSize, 0, iconSize),
            Position = UDim2.new(0, iconPadding, 0.5, 0), -- Positioned left, centered vertically
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = Utility.loadIcon(settings.Icon),
            -- ImageColor3 can be themed if the icon is single-color
            ZIndex = 3, -- Above corner fix and topbar background
            Parent = topbar
        })
        titleXOffset = iconPadding + iconSize + 8 -- Adjust title start position
    end

    -- Title
    local topbarTitle = Utility.createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -(titleXOffset + 90), 1, 0), -- Calculate width dynamically (total width - left offset - right buttons area)
        Position = UDim2.new(0, titleXOffset, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = settings.Name,
        TextColor3 = theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3, -- Above corner fix and topbar background
        Parent = topbar
    })
    Utility.registerThemedElement(topbarTitle, "TextColor3", "TextColor")

    -- Control Buttons (Close, Minimize, Settings)
    local controls = {} -- Store buttons for easier handling
    local buttonSize = 18
    local buttonSpacing = 12
    local buttonTransparency = 0.2 -- Initial transparency for hover effect
    local buttonY = 0.5 -- Center vertically

    local buttonData = {
        { Name = "Close", Image = "rbxassetid://6035047409" },
        { Name = "Minimize", Image = "rbxassetid://6035067836" },
        { Name = "Settings", Image = "rbxassetid://6031280882" },
    }

    for i, data in ipairs(buttonData) do
        local button = Utility.createInstance("ImageButton", {
            Name = data.Name,
            Size = UDim2.new(0, buttonSize, 0, buttonSize),
            -- Position from right edge: (i * spacing) + ((i-1) * buttonSize) - simplified:
            Position = UDim2.new(1, -(buttonSpacing + (i-1)*(buttonSize + buttonSpacing)), buttonY, 0),
            AnchorPoint = Vector2.new(1, 0.5), -- Anchor to right-center
            BackgroundTransparency = 1,
            Image = data.Image,
            ImageColor3 = theme.TextColor,
            ImageTransparency = buttonTransparency,
            ZIndex = 3, -- Above corner fix and topbar background
            Parent = topbar
        })
        Utility.registerThemedElement(button, "ImageColor3", "TextColor")
        controls[data.Name] = button -- Store reference by name

        -- Hover Effects & Ripple
        local tweenInfoHover = TweenInfo.new(0.2)
        parent:AddConnection(button.MouseEnter:Connect(function() TweenService:Create(button, tweenInfoHover, { ImageTransparency = 0 }):Play() end))
        parent:AddConnection(button.MouseLeave:Connect(function() TweenService:Create(button, tweenInfoHover, { ImageTransparency = buttonTransparency }):Play() end))
        parent:AddConnection(button.MouseButton1Click:Connect(function() Utility.rippleEffect(button, Color3.new(1,1,1), 0.3) end)) -- Add ripple
    end

    return topbar, controls.Close, controls.Minimize, controls.Settings
end

-- Creates the main content area below the topbar and above credits
local function _createContentContainer(parent, theme, topbarHeight, creditsHeight)
    local container = Utility.createInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -10, 1, -(topbarHeight + creditsHeight + 5)), -- Size relative to parent, accounting for padding, topbar, credits
        Position = UDim2.new(0, 5, 0, topbarHeight), -- Position below topbar, with padding
        BackgroundTransparency = 1, -- Should be transparent
        BorderSizePixel = 0,
        ClipsDescendants = false, -- Allow dropdowns etc. to potentially overflow visually if needed (though contained by mainFrame)
        Parent = parent,
        ZIndex = 1 -- Above main background, below topbar
    })
    return container
end

-- Creates the container and scroll frame for tabs on the left
local function _createTabContainer(parent, theme)
    local tabContainerWidth = 130
    local tabContainer = Utility.createInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, tabContainerWidth, 1, 0), -- Fixed width, full height of content container
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1, -- Should be transparent
        BorderSizePixel = 0,
        Parent = parent,
        ZIndex = 2 -- Above content container background
    })

    local tabScrollFrame = Utility.createInstance("ScrollingFrame", {
        Name = "TabScrollFrame",
        Size = UDim2.new(1, 0, 1, 0), -- Full size of tab container
        BackgroundTransparency = 1, -- Should be transparent
        BorderSizePixel = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0,0,0,0), -- Auto-sized by layout
        ScrollBarThickness = 0, -- Hide default scrollbar
        Parent = tabContainer
        -- Custom scrollbar applied later
    })

    -- Layout for tab buttons
    Utility.createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = tabScrollFrame
    })
    -- Padding within the scroll frame
    Utility.createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        Parent = tabScrollFrame
    })

    -- Apply custom scrollbar
    Utility.applyCustomScrollbar(tabScrollFrame, theme, 4)

    return tabContainer, tabScrollFrame, tabContainerWidth
end

-- Creates the container for element pages on the right
local function _createElementsContainer(parent, tabContainerWidth)
    local elementsContainer = Utility.createInstance("Frame", {
        Name = "ElementsContainer",
        Size = UDim2.new(1, -(tabContainerWidth + 5), 1, 0), -- Fill remaining width (content width - tab width - padding)
        Position = UDim2.new(0, tabContainerWidth + 5, 0, 0), -- Position to the right of the tab container + padding
        BackgroundTransparency = 1, -- Should be transparent
        BorderSizePixel = 0,
        ClipsDescendants = true, -- Clip pages within this area
        Parent = parent,
        ZIndex = 2 -- Same level as tab container
    })

    -- Folder to hold the actual pages (ScrollingFrames)
    local elementsPageFolder = Utility.createInstance("Folder", {
        Name = "Pages",
        Parent = elementsContainer
    })

    return elementsContainer, elementsPageFolder
end

-- Creates the Credits section at the bottom
local function _createCreditsSection(parent, theme, windowApi, creditsHeight)
     local creditsSection = Utility.createInstance("Frame", {
        Name = "Credits",
        Size = UDim2.new(1, 0, 0, creditsHeight),
        Position = UDim2.new(0, 0, 1, 0), -- Anchor to bottom
        AnchorPoint = Vector2.new(0, 1), -- Anchor point at bottom-left
        BackgroundColor3 = Utility.darker(theme.ElementBackground, 0.1), -- Slightly darker background
        BorderSizePixel = 0,
        Parent = parent, -- Parent is the mainFrame
        ZIndex = 2 -- Above main background, same level as topbar
    })
    -- Register with a transform function for the darker color
    Utility.registerThemedElement(creditsSection, "BackgroundColor3", "ElementBackground", nil, function(c) return Utility.darker(c, 0.1) end)
    Utility.manageConnections(creditsSection)

    -- Credit Text
    local creditText = Utility.createInstance("TextLabel", {
        Name = "CreditText",
        Size = UDim2.new(0.7, -120, 1, 0), -- Adjust width calculation as needed
        Position = UDim2.new(0, 10, 0, 0), -- Left aligned with padding
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = "LuminaUI by Supergoatscriptguy",
        TextColor3 = theme.SubTextColor,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = creditsSection
    })
    Utility.registerThemedElement(creditText, "TextColor3", "SubTextColor")

    -- Discord Button
    local discordButton = Utility.createInstance("TextButton", {
        Name = "DiscordButton",
        Size = UDim2.new(0, 100, 0, 22), -- Fixed size button
        Position = UDim2.new(1, -10, 0.5, 0), -- Right aligned, centered vertically
        AnchorPoint = Vector2.new(1, 0.5), -- Anchor to right-center
        BackgroundColor3 = Color3.fromRGB(88, 101, 242), -- Discord brand color
        Font = Enum.Font.GothamBold,
        Text = "Join Discord",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Parent = creditsSection
    })
    Utility.createCorner(discordButton, 4)

    -- Discord Button Interaction
    creditsSection:AddConnection(discordButton.MouseButton1Click:Connect(function()
        local discordLink = "https://discord.gg/KgvmCnZ88n" -- Your Discord link
        if setclipboard then
            local success, err = Utility.safeCall(setclipboard, discordLink)
            if success then
                windowApi:CreateNotification({ Title = "Discord", Content = "Invite link copied!", Duration = 3 })
            else
                 windowApi:CreateNotification({ Title = "Error", Content = "Failed to copy link.", Duration = 3 })
                 warn("[LuminaUI] Failed to set clipboard:", err)
            end
        else
            -- Provide feedback even if setclipboard isn't available
            windowApi:CreateNotification({ Title = "Discord Link", Content = discordLink, Duration = 5 })
            warn("[LuminaUI] 'setclipboard' not available. Link:", discordLink)
        end
    end))
    -- Add pulse effect on hover
    creditsSection:AddConnection(discordButton.MouseEnter:Connect(function() Utility.pulseEffect(discordButton, 1.03, 0.1) end))

    return creditsSection
end

-- ==================================
--      Main Window Creation
-- ==================================

-- Main function to create the UI window
function LuminaUI:CreateWindow(settings)
    settings = settings or {}
    -- Default settings
    settings.Name = settings.Name or "LuminaUI"
    settings.Theme = settings.Theme or "Default"
    settings.Size = settings.Size or UDim2.new(0, 550, 0, 475)
    settings.Icon = settings.Icon -- Keep nil if not provided, handled by loadIcon
    settings.ConfigurationSaving = settings.ConfigurationSaving or { Enabled = true, FileName = "LuminaConfig" }
    settings.ConfigurationSaving.Enabled = settings.ConfigurationSaving.Enabled ~= false -- Default true
    settings.ConfigurationSaving.FileName = settings.ConfigurationSaving.FileName or "LuminaConfig"
    settings.KeySystem = settings.KeySystem or { Enabled = false }
    settings.KeySystem.Enabled = settings.KeySystem.Enabled == true -- Default false

    -- Select initial theme
    local currentThemeName = settings.Theme
    local currentTheme = LuminaUI.Theme[currentThemeName]
    if not currentTheme then
        warn("[LuminaUI] Invalid theme name '"..tostring(currentThemeName).."' provided. Using Default.")
        currentThemeName = "Default"
        currentTheme = LuminaUI.Theme.Default
    end
    LuminaUI.CurrentTheme = currentTheme -- Set globally for utilities during creation

    -- Create Base ScreenGui (clears previous UI)
    local screenGui = _createBaseUI(settings)
    if not screenGui or not screenGui.Parent then
        warn("[LuminaUI] Failed to create ScreenGui or parent it.")
        return nil -- Critical failure
    end

    -- Load Configuration (before creating main frame to get position)
    local loadedConfig = Utility.loadConfig(settings)
    local initialPosition = loadedConfig.UIPosition or settings.UIPosition -- Use loaded position if available

    -- Create Key System (if enabled, this blocks until key is accepted or UI is closed)
    local keyCheckPassed = _createKeySystem(screenGui, settings, currentTheme)
    if not keyCheckPassed then
        -- Key system failed or UI was closed during key entry
        if screenGui and screenGui.Parent then Utility.destroyInstance(screenGui) end -- Cleanup ScreenGui
        warn("[LuminaUI] Key system failed or was cancelled.")
        return nil
    end

    -- Define constants for layout
    local topbarHeight = 45
    local creditsHeight = 30

    -- Create Main UI Structure
    local mainFrame = _createMainFrame(screenGui, settings, currentTheme, initialPosition)
    local topbar, closeButton, minimizeButton, settingsButton = _createTopbar(mainFrame, settings, currentTheme)
    local contentContainer = _createContentContainer(mainFrame, currentTheme, topbarHeight, creditsHeight)
    local tabContainer, tabScrollFrame, tabContainerWidth = _createTabContainer(contentContainer, currentTheme)
    local elementsContainer, elementsPageFolder = _createElementsContainer(contentContainer, tabContainerWidth)
    local notificationsContainer = _createNotificationsContainer(screenGui) -- Parent directly to ScreenGui for global positioning

    -- Window API Table (forward declaration needed for settings page, credits, etc.)
    local Window = {
        Instance = mainFrame,
        ScreenGui = screenGui, -- Reference to the root
        Tabs = {}, -- Stores Tab API objects
        TabGroups = {}, -- For future implementation
        CurrentTheme = currentTheme,
        CurrentThemeName = currentThemeName,
        Settings = settings, -- Store merged settings
        _connections = {}, -- For window-level connections (e.g., button clicks)
        _components = {}, -- Stores references to created components (buttons, sliders etc.) - May not be needed with attribute theming
        _activeTabButton = nil, -- Reference to the currently selected tab *button* Frame
        _activePage = nil, -- Reference to the currently visible page ScrollingFrame
        _settingsPage = nil, -- Reference to the settings page ScrollingFrame
        _tabScrollFrame = tabScrollFrame, -- Reference to the tab list scroll frame
        _elementsPageFolder = elementsPageFolder, -- Reference to the folder holding pages
        _notificationsContainer = notificationsContainer, -- Reference to notification area
        _minimized = false, -- Track minimize state
        _restoreButton = nil -- Reference to the restore button when minimized
    }
    Utility.manageConnections(Window) -- Manage connections for the Window API object itself (rarely needed)

    -- Create Credits Section (needs Window API for notifications)
    local creditsSection = _createCreditsSection(mainFrame, currentTheme, Window, creditsHeight)

    -- Create Settings Page (needs Window API reference for SetTheme)
    -- Moved creation after Window object exists, but before component methods are defined
    local settingsPage = _createSettingsPage(elementsPageFolder, settings, currentTheme, Window)
    Window._settingsPage = settingsPage

    -- Apply loaded element values (defer slightly after UI structure exists)
    task.defer(function()
        if loadedConfig.Elements then
            for flag, data in pairs(loadedConfig.Elements) do
                -- Find the component associated with the flag
                local flagData = LuminaUI.Flags[flag]
                if flagData and flagData.ComponentRef and flagData.ComponentRef.SetValue then
                    -- Check type match for safety? Optional.
                    -- if flagData.Type == data.Type then
                        Utility.safeCall(flagData.ComponentRef.SetValue, flagData.ComponentRef, data.Value, true) -- Pass true to skip callback on load
                    -- end
                end
            end
        end
    end)

    -- Function to select a tab visually and show its page
    function Window:_selectTab(tabButtonToSelect, pageToShow)
        if not tabButtonToSelect or not pageToShow then return end
        if self._activeTabButton == tabButtonToSelect then return end -- Already selected

        local isSettings = (pageToShow == self._settingsPage) -- Check if settings page is being shown

        local theme = self.CurrentTheme -- Use the current theme for styling

        -- Deselect previous tab and hide previous page
        if self._activeTabButton and self._activeTabButton.Parent then
            local prevTab = self._activeTabButton
            local prevTabTitle = prevTab:FindFirstChild("Title")
            local prevTabIcon = prevTab:FindFirstChild("Icon")
            local prevStroke = prevTab:FindFirstChild("TabStroke") -- Find by name

            -- Animate deselection
            TweenService:Create(prevTab, TweenInfo.new(0.2), { BackgroundColor3 = theme.TabBackground, BackgroundTransparency = 0.7 }):Play()
            if prevTabTitle then TweenService:Create(prevTabTitle, TweenInfo.new(0.2), { TextColor3 = theme.TabTextColor, TextTransparency = 0.2 }):Play() end
            if prevTabIcon then TweenService:Create(prevTabIcon, TweenInfo.new(0.2), { ImageColor3 = theme.TabTextColor, ImageTransparency = 0.2 }):Play() end
            if prevStroke then prevStroke.Enabled = true end -- Show stroke on deselected
        end
        if self._activePage and self._activePage.Parent then
            self._activePage.Visible = false
        end

        -- Select new tab and show new page
        local newTab = tabButtonToSelect
        local newTabTitle = newTab:FindFirstChild("Title")
        local newTabIcon = newTab:FindFirstChild("Icon")
        local newStroke = newTab:FindFirstChild("TabStroke")

        if not isSettings then -- Don't highlight a tab button if settings are opened via the gear icon
             -- Animate selection
             TweenService:Create(newTab, TweenInfo.new(0.2), { BackgroundColor3 = theme.TabBackgroundSelected, BackgroundTransparency = 0 }):Play()
             if newTabTitle then TweenService:Create(newTabTitle, TweenInfo.new(0.2), { TextColor3 = theme.SelectedTabTextColor, TextTransparency = 0 }):Play() end
             if newTabIcon then
                 TweenService:Create(newTabIcon, TweenInfo.new(0.2), { ImageColor3 = theme.SelectedTabTextColor, ImageTransparency = 0 }):Play()
                 Utility.pulseEffect(newTabIcon) -- Pulse effect on selection
             end
             if newStroke then newStroke.Enabled = false end -- Hide stroke on selected tab
             self._activeTabButton = newTab -- Store the selected button
        else
             self._activeTabButton = nil -- No tab button is "active" when settings are open
        end

        -- Show the corresponding page
        pageToShow.Visible = true
        if pageToShow:IsA("ScrollingFrame") then
            pageToShow.CanvasPosition = Vector2.new(0, 0) -- Scroll to top when page becomes visible
        end
        self._activePage = pageToShow

        -- Ensure settings page is hidden if a regular tab is selected
        if not isSettings and self._settingsPage and self._settingsPage.Visible then
            self._settingsPage.Visible = false
        end
    end

    -- Topbar Button Functionality
    Window:AddConnection(closeButton.MouseButton1Click:Connect(function()
        local position = mainFrame.Position
        Utility.saveConfig(settings, position) -- Save config before closing

        -- Close animation (Fade and shrink)
        local tweenInfoClose = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        -- Fade out main frame content first
        for _, child in ipairs(mainFrame:GetChildren()) do
            if child ~= topbar and child ~= creditsSection and child:IsA("GuiObject") then -- Don't fade topbar/credits initially
                TweenService:Create(child, tweenInfoClose, { Transparency = 1 }):Play()
            end
        end
        -- Animate size and fade out frame/topbar/credits
        local sizeTween = TweenService:Create(mainFrame, tweenInfoClose, { Size = UDim2.new(settings.Size.X.Scale, settings.Size.X.Offset * 0.8, 0, 0), Transparency = 1 })
        local posTween = TweenService:Create(mainFrame, tweenInfoClose, { Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + mainFrame.AbsoluteSize.Y * 0.1) }) -- Move down slightly

        sizeTween:Play()
        posTween:Play()

        -- Destroy the entire ScreenGui after animation
        sizeTween.Completed:Connect(function()
            if screenGui and screenGui.Parent then
                Utility.destroyInstance(screenGui) -- Use pooled destroy for the root
            end
        end)
    end))

    Window:AddConnection(minimizeButton.MouseButton1Click:Connect(function()
        Window._minimized = not Window._minimized
        local targetSize
        local tweenInfoMinimize = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        if Window._minimized then
            -- Minimizing: Shrink to topbar height
            targetSize = UDim2.new(settings.Size.X.Scale, settings.Size.X.Offset, 0, topbarHeight)
            minimizeButton.Visible = false -- Hide minimize icon

            -- Create/Show restore button
            if not Window._restoreButton or not Window._restoreButton.Parent then
                Window._restoreButton = Utility.createInstance("ImageButton", {
                    Name = "Restore",
                    Size = minimizeButton.Size,
                    Position = minimizeButton.Position, -- Same position as minimize button
                    AnchorPoint = minimizeButton.AnchorPoint,
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://6035067836", -- Use minimize icon image
                    ImageColor3 = minimizeButton.ImageColor3,
                    ImageTransparency = 0, -- Start visible
                    Rotation = 180, -- Rotate to indicate restore
                    ZIndex = 3,
                    Parent = topbar
                })
                Utility.registerThemedElement(Window._restoreButton, "ImageColor3", "TextColor")
                -- Add hover/click effects for restore button
                 mainFrame:AddConnection(Window._restoreButton.MouseEnter:Connect(function() TweenService:Create(Window._restoreButton, TweenInfo.new(0.2), { ImageTransparency = 0 }):Play() end))
                 mainFrame:AddConnection(Window._restoreButton.MouseLeave:Connect(function() TweenService:Create(Window._restoreButton, TweenInfo.new(0.2), { ImageTransparency = buttonTransparency }):Play() end))
                 mainFrame:AddConnection(Window._restoreButton.MouseButton1Click:Connect(function() minimizeButton.MouseButton1Click:Fire() end)) -- Trigger minimize logic again to restore
            end
            Window._restoreButton.Visible = true

        else
            -- Restoring: Expand back to original size
            targetSize = settings.Size
            minimizeButton.Visible = true -- Show minimize icon
            if Window._restoreButton and Window._restoreButton.Parent then
                Window._restoreButton.Visible = false -- Hide restore button
            end
        end

        -- Animate the main frame size
        TweenService:Create(mainFrame, tweenInfoMinimize, { Size = targetSize }):Play()
    end))

    Window:AddConnection(settingsButton.MouseButton1Click:Connect(function()
        local isOpeningSettings = not self._settingsPage.Visible
        if isOpeningSettings then
            -- Select the settings page, passing the settingsButton as context (though not strictly needed for highlighting)
            self:_selectTab(settingsButton, self._settingsPage)
        else
            -- Closing settings: Select the previously active tab or the first available tab
            local targetTabButton = self._activeTabButton -- Try to return to the tab that was active before settings
            local targetPage = nil

            if not targetTabButton then -- If no tab was active (e.g., just opened settings), find the first one
                for _, child in ipairs(self._tabScrollFrame:GetChildren()) do
                     -- Find first actual tab button (Frame with an Interact child, not a header)
                     if child:IsA("Frame") and child:FindFirstChild("Interact") and child.Name ~= "Header" then
                        targetTabButton = child
                        break
                     end
                end
            end

            if targetTabButton then
                 targetPage = self._elementsPageFolder:FindFirstChild(targetTabButton.Name)
            end

            if targetTabButton and targetPage then
                 self:_selectTab(targetTabButton, targetPage)
            else
                 -- No tabs exist, or couldn't find page, just hide settings and clear active state
                 self._settingsPage.Visible = false
                 self._activePage = nil
                 self._activeTabButton = nil
                 -- Deselect the (now hidden) settings page visually if needed (though _selectTab handles deselection)
            end
        end
    end))

    -- Make draggable using the topbar as the handle
    Utility.makeDraggable(mainFrame, topbar)

    -- ============================ --
    --      Window API Methods      --
    -- ============================ --

    -- Set Theme dynamically
    function Window:SetTheme(themeName)
        if not LuminaUI.Theme[themeName] then
            warn("[LuminaUI] Invalid theme name:", themeName)
            return
        end
        self.CurrentThemeName = themeName
        self.CurrentTheme = LuminaUI.Theme[themeName]
        self.Settings.Theme = themeName -- Update settings table

        -- Apply theme to all registered elements using the attribute system
        Utility.applyThemeToAll(self.ScreenGui, self.CurrentTheme)

        -- Manually update elements/styles not easily covered by simple attribute registration
        -- e.g., Re-apply scrollbar themes (could also be done via attributes on scrollbar parts)
        for _, frame in ipairs(self.ScreenGui:GetDescendants()) do
            if frame:IsA("ScrollingFrame") and frame:FindFirstChild("CustomScrollbar") then
                local scrollbar = frame.CustomScrollbar
                local thumb = scrollbar:FindFirstChild("ScrollThumb")
                if scrollbar:GetAttribute("LuminaThemeKey_BackgroundColor3") then
                    scrollbar.BackgroundColor3 = self.CurrentTheme.ScrollBarBackground
                end
                if thumb and thumb:GetAttribute("LuminaThemeKey_BackgroundColor3") then
                    thumb.BackgroundColor3 = self.CurrentTheme.ScrollBarForeground
                end
            end
            -- Update hover colors stored in component logic if necessary (complex)
            -- This might require iterating through self._components if that registry is maintained
        end

        -- Re-style the currently selected tab
        if self._activeTabButton and self._activeTabButton.Parent then
            local tab = self._activeTabButton
            local title = tab:FindFirstChild("Title")
            local icon = tab:FindFirstChild("Icon")
            tab.BackgroundColor3 = self.CurrentTheme.TabBackgroundSelected
            if title then title.TextColor3 = self.CurrentTheme.SelectedTabTextColor end
            if icon then icon.ImageColor3 = self.CurrentTheme.SelectedTabTextColor end
        end
    end

    -- Create Notification
    function Window:CreateNotification(notificationSettings)
        notificationSettings = notificationSettings or {}
        local title = notificationSettings.Title or "Notification"
        local content = notificationSettings.Content or "Content"
        local duration = notificationSettings.Duration or 5
        local iconId = notificationSettings.Icon -- nil or 0 if not provided
        local theme = self.CurrentTheme

        local notificationHeight = 65 -- Base height
        local contentPadding = 8
        local iconSize = (iconId and iconId ~= 0) and 24 or 0
        local closeButtonSize = 14

        local notification = Utility.createInstance("Frame", {
            Name = "Notification",
            Size = UDim2.new(1, 0, 0, notificationHeight),
            BackgroundColor3 = theme.NotificationBackground,
            BackgroundTransparency = 1, -- Start transparent for fade-in
            Position = UDim2.new(0, 0, 0, 20), -- Start offset down for animation
            Parent = self._notificationsContainer, -- Parent to the dedicated container
            ClipsDescendants = true
        })
        Utility.createCorner(notification, 6)
        Utility.manageConnections(notification) -- Manage connections for auto-cleanup

        -- Icon (Optional)
        local textX = contentPadding
        if iconSize > 0 then
            textX = contentPadding + iconSize + contentPadding -- Adjust text start position
            local icon = Utility.createInstance("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, iconSize, 0, iconSize),
                Position = UDim2.new(0, contentPadding, 0.5, 0), -- Position left, centered vertically
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image = Utility.loadIcon(iconId),
                ImageTransparency = 1, -- Start transparent
                ZIndex = notification.ZIndex + 1,
                Parent = notification
            })
             -- Fade in icon with main animation
             TweenService:Create(icon, TweenInfo.new(0.4), { ImageTransparency = 0 }):Play()
        end

        -- Close Button
        local closeNotifButton = Utility.createInstance("ImageButton", {
            Name = "Close",
            Size = UDim2.new(0, closeButtonSize, 0, closeButtonSize),
            Position = UDim2.new(1, -contentPadding, 0, contentPadding), -- Top-right corner
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6035047409", -- Close icon
            ImageColor3 = theme.TextColor,
            ImageTransparency = 1, -- Start transparent
            ZIndex = notification.ZIndex + 2, -- Above content
            Parent = notification
        })
        Utility.registerThemedElement(closeNotifButton, "ImageColor3", "TextColor")

        -- Calculate available width for text (Container width - left padding - textX - close button area - right padding)
        local textWidth = notification.AbsoluteSize.X - textX - (closeButtonSize + contentPadding * 2)

        -- Title Label
        local titleLabel = Utility.createInstance("TextLabel", {
            Name = "Title",
            Size = UDim2.new(0, textWidth, 0, 18), -- Fixed height for title
            Position = UDim2.new(0, textX, 0, contentPadding), -- Positioned below icon/padding
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = theme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1, -- Start transparent
            ZIndex = notification.ZIndex + 1,
            Parent = notification
        })
        Utility.registerThemedElement(titleLabel, "TextColor3", "TextColor")

        -- Body Label
        local bodyLabel = Utility.createInstance("TextLabel", {
            Name = "Body",
            Size = UDim2.new(0, textWidth, 0, notificationHeight - contentPadding * 3 - 18 - 3), -- Calculate remaining height (Total - top pad - title - mid pad - progress bar)
            Position = UDim2.new(0, textX, 0, contentPadding + 18 + 4), -- Position below title
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = content,
            TextColor3 = theme.SubTextColor,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextTransparency = 1, -- Start transparent
            ZIndex = notification.ZIndex + 1,
            Parent = notification
        })
        Utility.registerThemedElement(bodyLabel, "TextColor3", "SubTextColor")

        -- Auto-adjust height based on text bounds (more complex, optional)
        -- task.defer(function()
        --     local titleBounds = Utility.getTextBounds(title, titleLabel.Font, titleLabel.TextSize, textWidth)
        --     local bodyBounds = Utility.getTextBounds(content, bodyLabel.Font, bodyLabel.TextSize, textWidth)
        --     local requiredTextHeight = titleBounds.Y + bodyBounds.Y + 4 -- Approx text height + spacing
        --     local requiredTotalHeight = contentPadding * 3 + requiredTextHeight + 3 -- Paddings + text + progress bar
        --     notification.Size = UDim2.new(1, 0, 0, math.max(notificationHeight, requiredTotalHeight))
        --     bodyLabel.Size = UDim2.new(0, textWidth, 0, bodyBounds.Y) -- Adjust body label size too
        -- end)

        -- Progress Bar
        local progressBarHeight = 3
        local progressBar = Utility.createInstance("Frame", {
            Name = "ProgressBar",
            Size = UDim2.new(1, 0, 0, progressBarHeight),
            Position = UDim2.new(0, 0, 1, 0), -- Positioned at the bottom
            AnchorPoint = Vector2.new(0, 1), -- Anchored to bottom-left
            BackgroundColor3 = theme.ProgressBarBackground,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            ZIndex = notification.ZIndex + 1,
            Parent = notification
        })
        Utility.createCorner(progressBar, progressBarHeight / 2) -- Round the background
        Utility.registerThemedElement(progressBar, "BackgroundColor3", "ProgressBarBackground")

-- ...existing code... (End of first chunk, inside Window:CreateNotification)

local progressFill = Utility.createInstance("Frame", {
    Name = "Progress",
    Size = UDim2.new(1, 0, 1, 0), -- Start full width
    BackgroundColor3 = theme.ProgressBarFill,
    BorderSizePixel = 0,
    ZIndex = progressBar.ZIndex + 1,
    Parent = progressBar
})
Utility.createCorner(progressFill, progressBarHeight / 2) -- Round the fill bar
Utility.registerThemedElement(progressFill, "BackgroundColor3", "ProgressBarFill")

-- Function to destroy the notification with animation
local function destroyNotification(animated)
    if not notification or not notification.Parent then return end -- Already destroyed
    local notifRef = notification -- Keep reference for animation callbacks
    notification = nil -- Prevent re-entry / double destroy calls

    notifRef:DisconnectAll() -- Disconnect listeners immediately

    if animated then
        local outTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In) -- Use In for exit
        -- Fade out main frame and move down
        TweenService:Create(notifRef, outTweenInfo, { BackgroundTransparency = 1, Position = notifRef.Position + UDim2.new(0, 0, 0, 20) }):Play()
        -- Fade out text and controls
        for _, child in ipairs(notifRef:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("ImageLabel") or child:IsA("ImageButton") then
                local prop = child:IsA("TextLabel") and "TextTransparency" or "ImageTransparency"
                TweenService:Create(child, outTweenInfo, { [prop] = 1 }):Play()
            elseif child.Name == "ProgressBar" then -- Fade out progress bar too
                 TweenService:Create(child, outTweenInfo, { BackgroundTransparency = 1 }):Play()
                 local fill = child:FindFirstChild("Progress")
                 if fill then TweenService:Create(fill, outTweenInfo, { BackgroundTransparency = 1 }):Play() end
            end
        end

        -- Use pooled destroy after animation
        task.delay(outTweenInfo.Time, function()
            Utility.destroyInstance(notifRef)
        end)
    else
        Utility.destroyInstance(notifRef) -- Destroy immediately if not animated
    end
end

-- Close button interaction
notification:AddConnection(closeNotifButton.MouseButton1Click:Connect(function() destroyNotification(true) end))
notification:AddConnection(closeNotifButton.MouseEnter:Connect(function() TweenService:Create(closeNotifButton, TweenInfo.new(0.2), { ImageTransparency = 0 }):Play() end))
notification:AddConnection(closeNotifButton.MouseLeave:Connect(function() TweenService:Create(closeNotifButton, TweenInfo.new(0.2), { ImageTransparency = 0.5 }):Play() end))

-- Intro Animation
local inTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out) -- Use Back easing for entry
TweenService:Create(notification, inTweenInfo, { BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0) }):Play()
TweenService:Create(titleLabel, inTweenInfo, { TextTransparency = 0 }):Play()
TweenService:Create(bodyLabel, inTweenInfo, { TextTransparency = 0 }):Play()
TweenService:Create(closeNotifButton, inTweenInfo, { ImageTransparency = 0.5 }):Play()

-- Progress and Auto-Destroy
local progressTween = TweenService:Create(progressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) })
progressTween:Play()
-- Connect Completed to the destroy function
notification:AddConnection(progressTween.Completed:Connect(function(playbackState)
    -- Ensure it completed normally before destroying
    if playbackState == Enum.PlaybackState.Completed then
        destroyNotification(true)
    end
end))

return notification -- Return the instance if needed externally
end

-- Create Tab
function Window:CreateTab(tabSettings)
tabSettings = tabSettings or {}
local name = tabSettings.Name or "Tab"
local iconId = tabSettings.Icon -- nil or 0 if not provided
local order = tabSettings.Order or (#self.Tabs + 1) -- Default order based on creation
local theme = self.CurrentTheme

-- Create the Tab Button Frame
local tabButton = Utility.createInstance("Frame", {
    Name = name, -- Use tab name for the button frame name (used for page lookup)
    Size = UDim2.new(1, -10, 0, 35), -- Full width (-padding), fixed height
    BackgroundColor3 = theme.TabBackground,
    BackgroundTransparency = 0.7, -- Start slightly transparent
    LayoutOrder = order,
    Parent = self._tabScrollFrame -- Parent to the tab scroll frame
})
Utility.createCorner(tabButton, 4)
Utility.manageConnections(tabButton) -- Manage connections for the tab button

-- Stroke (initially visible)
local tabStroke = Utility.createStroke(tabButton, theme.ElementStroke, 1, 0, "ElementStroke")
tabStroke.Name = "TabStroke" -- Name for easy lookup

-- Icon (Optional)
local titleX = 10 -- Default left padding for title
if iconId and iconId ~= 0 then
    titleX = 10 + 18 + 5 -- Padding + Icon Size + Spacing
    local icon = Utility.createInstance("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Image = Utility.loadIcon(iconId),
        ImageColor3 = theme.TabTextColor,
        ImageTransparency = 0.2, -- Start slightly transparent
        ZIndex = tabButton.ZIndex + 1,
        Parent = tabButton
    })
    Utility.registerThemedElement(icon, "ImageColor3", "TabTextColor", "SelectedTabTextColor") -- Register for theme updates
end

-- Title
local title = Utility.createInstance("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -(titleX + 5), 1, 0), -- Fill remaining width
    Position = UDim2.new(0, titleX, 0, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = name,
    TextColor3 = theme.TabTextColor,
    TextSize = 13,
    TextTransparency = 0.2, -- Start slightly transparent
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = tabButton.ZIndex + 1,
    Parent = tabButton
})
Utility.registerThemedElement(title, "TextColor3", "TabTextColor", "SelectedTabTextColor") -- Register for theme updates

-- Interaction Button (covers the whole tab area)
local interact = Utility.createInstance("TextButton", {
    Name = "Interact",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1, -- Fully transparent
    Text = "",
    ZIndex = tabButton.ZIndex + 2, -- Above text/icon
    Parent = tabButton
})

-- Create the corresponding Page (ScrollingFrame)
local page = Utility.createInstance("ScrollingFrame", {
    Name = name, -- Match the tab button name
    Size = UDim2.new(1, 0, 1, 0), -- Full size of elements container
    BackgroundTransparency = 1, -- Transparent background
    BorderSizePixel = 0,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0), -- Auto-sized by layout
    ScrollBarThickness = 0, -- Hide default scrollbar
    Visible = false, -- Initially hidden
    Parent = self._elementsPageFolder -- Parent to the page folder
})
Utility.manageConnections(page) -- Manage connections for the page

-- Layout for elements within the page
local pageLayout = Utility.createInstance("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Parent = page
})
-- Padding within the page scroll frame
Utility.createInstance("UIPadding", {
    PaddingTop = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10),
    Parent = page
})

-- Apply custom scrollbar to the page
Utility.applyCustomScrollbar(page, theme, 4)

-- Tab Button Interaction
tabButton:AddConnection(interact.MouseButton1Click:Connect(function()
    self:_selectTab(tabButton, page)
end))

-- Hover Effects (applied to the main tabButton frame)
local tweenInfoHover = TweenInfo.new(0.2)
tabButton:AddConnection(interact.MouseEnter:Connect(function()
    if self._activeTabButton ~= tabButton then -- Only apply hover if not selected
        TweenService:Create(tabButton, tweenInfoHover, { BackgroundTransparency = 0.5 }):Play()
        if title then TweenService:Create(title, tweenInfoHover, { TextTransparency = 0 }):Play() end
        local icon = tabButton:FindFirstChild("Icon")
        if icon then TweenService:Create(icon, tweenInfoHover, { ImageTransparency = 0 }):Play() end
    end
end))
tabButton:AddConnection(interact.MouseLeave:Connect(function()
    if self._activeTabButton ~= tabButton then -- Only revert hover if not selected
        TweenService:Create(tabButton, tweenInfoHover, { BackgroundTransparency = 0.7 }):Play()
        if title then TweenService:Create(title, tweenInfoHover, { TextTransparency = 0.2 }):Play() end
        local icon = tabButton:FindFirstChild("Icon")
        if icon then TweenService:Create(icon, tweenInfoHover, { ImageTransparency = 0.2 }):Play() end
    end
end))

-- Tab API Table
local Tab = {
    Instance = page, -- Reference to the ScrollingFrame page
    ButtonInstance = tabButton, -- Reference to the tab button Frame
    Layout = pageLayout, -- Reference to the UIListLayout
    _window = self, -- Reference back to the main Window API
    _connections = {}, -- Connections specific to this tab API object
    _components = {} -- Components added to this tab
}
Utility.manageConnections(Tab) -- Manage connections for the Tab API object

-- ============================ --
--      Tab API Methods         --
-- ============================ --

-- Add Component (Generic function to add any created component)
function Tab:AddComponent(componentInstance, componentApi)
    if not componentInstance or not componentInstance:IsA("GuiObject") then
        warn("[LuminaUI] Invalid component instance passed to AddComponent.")
        return
    end
    componentInstance.Parent = self.Instance -- Parent the component's main frame to the tab page
    table.insert(self._components, componentApi or componentInstance) -- Store API or instance
    return componentApi or componentInstance -- Return the API if provided, else the instance
end

-- Add Label
function Tab:AddLabel(labelSettings)
    labelSettings = labelSettings or {}
    local text = labelSettings.Text or "Label"
    local size = labelSettings.Size or UDim2.new(1, 0, 0, 20)
    local order = labelSettings.Order or (#self._components + 1)
    local theme = self._window.CurrentTheme

    local label = Utility.createInstance("TextLabel", {
        Name = "Label_" .. text,
        Size = size,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = theme.TextColor,
        TextSize = 14,
        TextXAlignment = labelSettings.Align or Enum.TextXAlignment.Left,
        TextWrapped = labelSettings.Wrap or false,
        LayoutOrder = order,
        -- Parent is set by AddComponent
    })
    Utility.registerThemedElement(label, "TextColor3", "TextColor")

    -- Add tooltip if provided
    if labelSettings.Tooltip then
         self:AddConnection(label.MouseEnter:Connect(function() Utility.showTooltip(labelSettings.Tooltip, theme) end))
         self:AddConnection(label.MouseLeave:Connect(function() Utility.hideTooltip() end))
    end

    return self:AddComponent(label)
end

-- Add Button
function Tab:AddButton(buttonSettings)
    buttonSettings = buttonSettings or {}
    local text = buttonSettings.Text or "Button"
    local order = buttonSettings.Order or (#self._components + 1)
    local callback = buttonSettings.Callback or function() print("[LuminaUI] Button '"..text.."' clicked.") end
    local theme = self._window.CurrentTheme

    local button = Utility.createInstance("TextButton", {
        Name = "Button_" .. text,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = theme.ElementBackground,
        Font = Enum.Font.GothamBold,
        Text = text,
        TextColor3 = theme.TextColor,
        TextSize = 14,
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    Utility.createCorner(button, 4)
    local stroke = Utility.createStroke(button, theme.ElementStroke, 1)
    Utility.registerThemedElement(button, "BackgroundColor3", "ElementBackground", "ElementBackgroundHover")
    Utility.registerThemedElement(button, "TextColor3", "TextColor")
    -- Stroke already registered

    -- API Object
    local ButtonApi = { Instance = button, _connections = {} }
    Utility.manageConnections(ButtonApi)

    -- Effects & Interaction
    local normalColor = theme.ElementBackground
    local hoverColor = theme.ElementBackgroundHover
    ButtonApi:AddConnection(button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = hoverColor }):Play()
        if buttonSettings.Tooltip then Utility.showTooltip(buttonSettings.Tooltip, theme) end
    end))
    ButtonApi:AddConnection(button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = normalColor }):Play()
        Utility.hideTooltip()
    end))
    ButtonApi:AddConnection(button.MouseButton1Click:Connect(function()
        Utility.rippleEffect(button)
        Utility.safeCall(callback) -- Execute callback
    end))

    -- Update hover colors on theme change (requires tracking)
    -- This is complex with the current attribute system. A simpler approach is to re-fetch colors on hover.
    -- Or, store theme keys and re-fetch inside the hover events.
    -- Let's try re-fetching inside hover:
    ButtonApi:AddConnection(button.MouseEnter:Connect(function()
        local currentTheme = self._window.CurrentTheme -- Get current theme
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = currentTheme.ElementBackgroundHover }):Play()
        if buttonSettings.Tooltip then Utility.showTooltip(buttonSettings.Tooltip, currentTheme) end
    end))
    ButtonApi:AddConnection(button.MouseLeave:Connect(function()
        local currentTheme = self._window.CurrentTheme -- Get current theme
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = currentTheme.ElementBackground }):Play()
        Utility.hideTooltip()
    end))


    return self:AddComponent(button, ButtonApi)
end

-- Add Toggle
function Tab:AddToggle(toggleSettings)
    toggleSettings = toggleSettings or {}
    local text = toggleSettings.Text or "Toggle"
    local flag = toggleSettings.Flag -- Mandatory for saving/loading
    local defaultValue = toggleSettings.Default or false
    local order = toggleSettings.Order or (#self._components + 1)
    local callback = toggleSettings.Callback or function(value) print("[LuminaUI] Toggle '"..text.."' set to:", value) end
    local theme = self._window.CurrentTheme

    if not flag then warn("[LuminaUI] Toggle '"..text.."' is missing a 'Flag' for configuration saving.") end

    local currentValue = defaultValue

    local toggleFrame = Utility.createInstance("Frame", {
        Name = "Toggle_" .. text,
        Size = UDim2.new(1, 0, 0, 30), -- Slightly smaller height
        BackgroundTransparency = 1,
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    Utility.manageConnections(toggleFrame)

    local toggleButton = Utility.createInstance("TextButton", { -- Use TextButton for easier interaction handling
        Name = "ToggleButton",
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -10, 0.5, 0), -- Positioned right, centered vertically
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = defaultValue and theme.ToggleEnabled or theme.ToggleDisabled,
        Text = "", -- No text on the button itself
        Parent = toggleFrame
    })
    Utility.createCorner(toggleButton, 10) -- Rounded corners for the track
    Utility.registerThemedElement(toggleButton, "BackgroundColor3", "ToggleDisabled") -- Base color is disabled

    local toggleCircle = Utility.createInstance("Frame", {
        Name = "Circle",
        Size = UDim2.new(0, 16, 0, 16), -- Slightly smaller than button height
        Position = defaultValue and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), -- Position left/right based on default
        AnchorPoint = Vector2.new(defaultValue and 1 or 0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), -- White circle
        BorderSizePixel = 0,
        Parent = toggleButton
    })
    Utility.createCorner(toggleCircle, 8) -- Make it circular

    local label = Utility.createInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -(10 + 40 + 10), 1, 0), -- Width = Frame width - left pad - button width - right pad
        Position = UDim2.new(0, 10, 0, 0), -- Positioned left
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggleFrame
    })
    Utility.registerThemedElement(label, "TextColor3", "TextColor")

    -- API Object
    local ToggleApi = { Instance = toggleFrame, _connections = {}, Value = currentValue }
    Utility.manageConnections(ToggleApi)

    -- Update function
    function ToggleApi:SetValue(value, skipCallback)
        value = value == true -- Ensure boolean
        if self.Value == value then return end -- No change

        self.Value = value
        currentValue = value -- Update local state

        local targetColor = value and self._window.CurrentTheme.ToggleEnabled or self._window.CurrentTheme.ToggleDisabled
        local targetPos = value and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local targetAnchor = value and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)

        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(toggleButton, tweenInfo, { BackgroundColor3 = targetColor }):Play()
        TweenService:Create(toggleCircle, tweenInfo, { Position = targetPos, AnchorPoint = targetAnchor }):Play()

        -- Update flag registry
        if flag and LuminaUI.Flags[flag] then
            LuminaUI.Flags[flag].Value = value
        end

        -- Trigger callback if not skipped
        if not skipCallback then
            Utility.safeCall(callback, value)
        end
    end

    -- Interaction
    ToggleApi:AddConnection(toggleButton.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value) -- Toggle the value
    end))

    -- Tooltip
    if toggleSettings.Tooltip then
         ToggleApi:AddConnection(toggleFrame.MouseEnter:Connect(function() Utility.showTooltip(toggleSettings.Tooltip, self._window.CurrentTheme) end))
         ToggleApi:AddConnection(toggleFrame.MouseLeave:Connect(function() Utility.hideTooltip() end))
    end

    -- Register flag for saving/loading
    if flag then
        LuminaUI.Flags[flag] = { Value = currentValue, Type = "Toggle", ComponentRef = ToggleApi }
    end

    return self:AddComponent(toggleFrame, ToggleApi)
end

-- Add Slider
function Tab:AddSlider(sliderSettings)
    sliderSettings = sliderSettings or {}
    local text = sliderSettings.Text or "Slider"
    local flag = sliderSettings.Flag -- Mandatory
    local min = sliderSettings.Min or 0
    local max = sliderSettings.Max or 100
    local step = sliderSettings.Step or 1
    local defaultValue = sliderSettings.Default or min
    local unit = sliderSettings.Unit or ""
    local order = sliderSettings.Order or (#self._components + 1)
    local callback = sliderSettings.Callback or function(value) print("[LuminaUI] Slider '"..text.."' set to:", value) end
    local theme = self._window.CurrentTheme

    if not flag then warn("[LuminaUI] Slider '"..text.."' is missing a 'Flag' for configuration saving.") end

    -- Clamp default value and ensure it aligns with step
    defaultValue = math.clamp(defaultValue, min, max)
    defaultValue = math.floor((defaultValue - min) / step + 0.5) * step + min

    local currentValue = defaultValue

    local sliderFrame = Utility.createInstance("Frame", {
        Name = "Slider_" .. text,
        Size = UDim2.new(1, 0, 0, 50), -- Taller frame for label + slider
        BackgroundTransparency = 1,
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    Utility.manageConnections(sliderFrame)

    local label = Utility.createInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.5, -5, 0, 20), -- Half width for label
        Position = UDim2.new(0, 10, 0, 5), -- Position top-left
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sliderFrame
    })
    Utility.registerThemedElement(label, "TextColor3", "TextColor")

    local valueLabel = Utility.createInstance("TextLabel", {
        Name = "ValueLabel",
        Size = UDim2.new(0.5, -5, 0, 20), -- Half width for value
        Position = UDim2.new(1, -10, 0, 5), -- Position top-right
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = Utility.formatNumber(currentValue) .. unit,
        TextColor3 = theme.SubTextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = sliderFrame
    })
    Utility.registerThemedElement(valueLabel, "TextColor3", "SubTextColor")

    local sliderTrack = Utility.createInstance("Frame", {
        Name = "Track",
        Size = UDim2.new(1, -20, 0, 6), -- Full width (-padding), fixed height
        Position = UDim2.new(0, 10, 0, 30), -- Position below labels
        BackgroundColor3 = theme.ElementBackground,
        Parent = sliderFrame
    })
    Utility.createCorner(sliderTrack, 3)
    Utility.registerThemedElement(sliderTrack, "BackgroundColor3", "ElementBackground")

    local progressTrack = Utility.createInstance("Frame", {
        Name = "Progress",
        Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0), -- Initial progress based on default
        BackgroundColor3 = theme.SliderProgress,
        Parent = sliderTrack
    })
    Utility.createCorner(progressTrack, 3)
    Utility.registerThemedElement(progressTrack, "BackgroundColor3", "SliderProgress")

    local sliderThumb = Utility.createInstance("Frame", {
        Name = "Thumb",
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((currentValue - min) / (max - min), 0, 0.5, 0), -- Position based on default
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.SliderProgress,
        BorderSizePixel = 0,
        ZIndex = sliderTrack.ZIndex + 1,
        Parent = sliderTrack
    })
    Utility.createCorner(sliderThumb, 7) -- Circular thumb
    Utility.registerThemedElement(sliderThumb, "BackgroundColor3", "SliderProgress")

    -- API Object
    local SliderApi = { Instance = sliderFrame, _connections = {}, Value = currentValue }
    Utility.manageConnections(SliderApi)

    local isDragging = false

    -- Update function
    function SliderApi:SetValue(value, skipCallback)
        -- Clamp and snap value to step
        value = math.clamp(value, min, max)
        value = math.floor((value - min) / step + 0.5) * step + min

        if self.Value == value then return end -- No change

        self.Value = value
        currentValue = value -- Update local state

        local percent = (value - min) / (max - min)
        if max == min then percent = 0 end -- Avoid division by zero

        -- Update UI elements
        progressTrack.Size = UDim2.new(percent, 0, 1, 0)
        sliderThumb.Position = UDim2.new(percent, 0, 0.5, 0)
        valueLabel.Text = Utility.formatNumber(value) .. unit

        -- Update flag registry
        if flag and LuminaUI.Flags[flag] then
            LuminaUI.Flags[flag].Value = value
        end

        -- Trigger callback if not skipped
        if not skipCallback then
            Utility.safeCall(callback, value)
        end
    end

    -- Interaction Logic
    local function updateFromInput(input)
        local mouseX = input.Position.X
        local trackStartX = sliderTrack.AbsolutePosition.X
        local trackWidth = sliderTrack.AbsoluteSize.X
        if trackWidth <= 0 then return end -- Avoid division by zero

        local percent = math.clamp((mouseX - trackStartX) / trackWidth, 0, 1)
        local newValue = min + percent * (max - min)
        self:SetValue(newValue) -- SetValue handles clamping, stepping, and callback
    end

    SliderApi:AddConnection(sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateFromInput(input) -- Update immediately on click
            Utility.pulseEffect(sliderThumb, 1.2, 0.1) -- Pulse effect on drag start
            -- Prevent text selection while dragging
            UserInputService.TextSelectionEnabled = false
        end
    end))

    -- Use global InputEnded/InputChanged for reliable drag end detection
    SliderApi:AddConnection(UserInputService.InputEnded:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            isDragging = false
            Utility.pulseEffect(sliderThumb, 1 / 1.2, 0.1) -- Revert pulse effect
            -- Re-enable text selection
            UserInputService.TextSelectionEnabled = true
        end
    end))

    SliderApi:AddConnection(UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end))

    -- Tooltip
    if sliderSettings.Tooltip then
         SliderApi:AddConnection(sliderFrame.MouseEnter:Connect(function() Utility.showTooltip(sliderSettings.Tooltip, self._window.CurrentTheme) end))
         SliderApi:AddConnection(sliderFrame.MouseLeave:Connect(function() Utility.hideTooltip() end))
    end

    -- Register flag for saving/loading
    if flag then
        LuminaUI.Flags[flag] = { Value = currentValue, Type = "Slider", ComponentRef = SliderApi }
    end

    return self:AddComponent(sliderFrame, SliderApi)
end

-- Add Dropdown
function Tab:AddDropdown(dropdownSettings)
    dropdownSettings = dropdownSettings or {}
    local text = dropdownSettings.Text or "Dropdown"
    local flag = dropdownSettings.Flag -- Mandatory
    local options = dropdownSettings.Options or {}
    local defaultValue = dropdownSettings.Default or options[1] -- Default to first option
    local allowSearch = dropdownSettings.Search or false -- Allow searching options
    local order = dropdownSettings.Order or (#self._components + 1)
    local callback = dropdownSettings.Callback or function(value) print("[LuminaUI] Dropdown '"..text.."' selected:", value) end
    local theme = self._window.CurrentTheme

    if not flag then warn("[LuminaUI] Dropdown '"..text.."' is missing a 'Flag' for configuration saving.") end
    if not table.find(options, defaultValue) then defaultValue = options[1] end -- Ensure default is valid

    local currentValue = defaultValue
    local isOpen = false

    local dropdownFrame = Utility.createInstance("Frame", {
        Name = "Dropdown_" .. text,
        Size = UDim2.new(1, 0, 0, 35), -- Standard height
        BackgroundTransparency = 1,
        LayoutOrder = order,
        ZIndex = 5, -- Base ZIndex for dropdown, options list will be higher
        -- Parent set by AddComponent
    })
    Utility.manageConnections(dropdownFrame)

    local label = Utility.createInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.4, -10, 1, 0), -- Adjust width as needed
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dropdownFrame
    })
    Utility.registerThemedElement(label, "TextColor3", "TextColor")

    local dropdownButton = Utility.createInstance("TextButton", {
        Name = "DropdownButton",
        Size = UDim2.new(0.6, -10, 1, -10), -- Adjust width, slight vertical padding
        Position = UDim2.new(1, -10, 0.5, 0), -- Position right, centered vertically
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = theme.InputBackground,
        Font = Enum.Font.Gotham,
        Text = tostring(currentValue), -- Display current value
        TextColor3 = theme.TextColor,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, -- Align text left within button
        Parent = dropdownFrame
    })
    Utility.createCorner(dropdownButton, 4)
    local buttonStroke = Utility.createStroke(dropdownButton, theme.InputStroke, 1)
    Utility.registerThemedElement(dropdownButton, "BackgroundColor3", "InputBackground", "ElementBackgroundHover") -- Use ElementBackgroundHover for consistency
    Utility.registerThemedElement(dropdownButton, "TextColor3", "TextColor")
    -- Stroke already registered

    -- Padding for button text
    Utility.createInstance("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 25), -- Space for the arrow
        Parent = dropdownButton
    })

    -- Dropdown Arrow Icon
    local arrowIcon = Utility.createInstance("ImageLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -10, 0.5, 0), -- Position inside button, right edge
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031280882", -- Re-use settings icon (down arrow-like)
        ImageColor3 = theme.SubTextColor,
        Rotation = 90, -- Rotate to point down
        ZIndex = dropdownButton.ZIndex + 1,
        Parent = dropdownButton
    })
    Utility.registerThemedElement(arrowIcon, "ImageColor3", "SubTextColor")

    -- Options List Container (created on demand)
    local optionsList = nil

    -- API Object
    local DropdownApi = { Instance = dropdownFrame, _connections = {}, Value = currentValue, Options = options }
    Utility.manageConnections(DropdownApi)

    -- Function to create/destroy the options list
    function DropdownApi:ToggleOpen(forceState)
        isOpen = (forceState ~= nil) and forceState or not isOpen

        -- Close any other active dropdown first
        if isOpen and ActiveDropdown and ActiveDropdown ~= self then
            Utility.safeCall(ActiveDropdown.ToggleOpen, ActiveDropdown, false)
        end

        if isOpen then
            ActiveDropdown = self -- Set this as the active dropdown

            -- Create options list if it doesn't exist
            if not optionsList or not optionsList.Parent then
                optionsList = Utility.createInstance("Frame", {
                    Name = "OptionsList",
                    Size = UDim2.new(0, dropdownButton.AbsoluteSize.X, 0, 0), -- Width matches button, height calculated later
                    Position = UDim2.new(0, dropdownButton.AbsolutePosition.X, 0, dropdownButton.AbsolutePosition.Y + dropdownButton.AbsoluteSize.Y + 2), -- Position below button
                    BackgroundColor3 = theme.DropdownUnselected,
                    BorderSizePixel = 1,
                    BorderColor3 = theme.InputStroke,
                    ClipsDescendants = true,
                    Visible = false, -- Start invisible for animation
                    ZIndex = 100, -- High ZIndex to appear above other elements
                    Parent = self._window.ScreenGui -- Parent to ScreenGui for global positioning
                })
                Utility.createCorner(optionsList, 4)
                Utility.registerThemedElement(optionsList, "BackgroundColor3", "DropdownUnselected")
                Utility.registerThemedElement(optionsList, "BorderColor3", "InputStroke")
                Utility.manageConnections(optionsList) -- Manage connections for the list itself

                local listLayout = Utility.createInstance("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = optionsList
                })
                Utility.createInstance("UIPadding", {
                    PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
                    Parent = optionsList
                })

                -- Search Bar (Optional)
                if allowSearch then
                    local searchBar = Utility.createInstance("TextBox", {
                        Name = "SearchBar",
                        Size = UDim2.new(1, -8, 0, 25), -- Full width (-padding), fixed height
                        Position = UDim2.new(0.5, 0, 0, 4),
                        AnchorPoint = Vector2.new(0.5, 0),
                        BackgroundColor3 = theme.InputBackground,
                        PlaceholderText = "Search...",
                        PlaceholderColor3 = theme.InputPlaceholder,
                        Text = "", TextColor3 = theme.TextColor, Font = Enum.Font.Gotham, TextSize = 13,
                        ClearTextOnFocus = false,
                        LayoutOrder = -1, -- Ensure it's at the top
                        Parent = optionsList
                    })
                    Utility.createCorner(searchBar, 3)
                    Utility.createStroke(searchBar, theme.InputStroke, 1)
                    Utility.registerThemedElement(searchBar, "BackgroundColor3", "InputBackground")
                    Utility.registerThemedElement(searchBar, "PlaceholderColor3", "InputPlaceholder")
                    Utility.registerThemedElement(searchBar, "TextColor3", "TextColor")

                    optionsList:AddConnection(searchBar.Changed:Connect(function()
                        local searchText = string.lower(searchBar.Text)
                        local visibleCount = 0
                        for _, itemButton in ipairs(optionsList:GetChildren()) do
                            if itemButton:IsA("TextButton") and itemButton.Name == "OptionItem" then
                                local itemText = string.lower(itemButton.Text)
                                local isVisible = string.find(itemText, searchText, 1, true) ~= nil
                                itemButton.Visible = isVisible
                                if isVisible then visibleCount = visibleCount + 1 end
                            end
                        end
                        -- Recalculate height based on visible items + search bar
                        local itemHeight = 25 -- Approx height of each item + padding
                        local searchHeight = 25 + 4 -- Search bar height + padding
                        local newHeight = math.min(searchHeight + (visibleCount * itemHeight) + 8, 150) -- Max height 150
                        optionsList.Size = UDim2.new(0, dropdownButton.AbsoluteSize.X, 0, newHeight)
                    end))
                end

                -- Populate options
                local totalHeight = (allowSearch and 33 or 8) -- Start with padding + search bar height
                local itemCount = 0
                for i, option in ipairs(self.Options) do
                    itemCount = itemCount + 1
                    local itemButton = Utility.createInstance("TextButton", {
                        Name = "OptionItem",
                        Size = UDim2.new(1, -8, 0, 25), -- Full width (-padding), fixed height
                        BackgroundColor3 = (option == self.Value) and theme.DropdownSelected or theme.DropdownUnselected,
                        Font = Enum.Font.Gotham,
                        Text = tostring(option),
                        TextColor3 = theme.TextColor,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        LayoutOrder = i,
                        Parent = optionsList
                    })
                    Utility.createCorner(itemButton, 3)
                    Utility.registerThemedElement(itemButton, "BackgroundColor3", "DropdownUnselected", "ElementBackgroundHover") -- Use specific keys
                    Utility.registerThemedElement(itemButton, "TextColor3", "TextColor")

                    -- Padding for item text
                    Utility.createInstance("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = itemButton })

                    optionsList:AddConnection(itemButton.MouseButton1Click:Connect(function()
                        self:SetValue(option)
                        self:ToggleOpen(false) -- Close after selection
                    end))

                    -- Hover effect for options
                    optionsList:AddConnection(itemButton.MouseEnter:Connect(function()
                        if option ~= self.Value then itemButton.BackgroundColor3 = theme.ElementBackgroundHover end
                    end))
                    optionsList:AddConnection(itemButton.MouseLeave:Connect(function()
                        if option ~= self.Value then itemButton.BackgroundColor3 = theme.DropdownUnselected end
                    end))

                    totalHeight = totalHeight + 25 + 2 -- Item height + layout padding
                end
                -- Set initial size, capped at max height
                optionsList.Size = UDim2.new(0, dropdownButton.AbsoluteSize.X, 0, math.min(totalHeight, 150))
            end

            -- Position and Animate Open
            optionsList.Position = UDim2.new(0, dropdownButton.AbsolutePosition.X, 0, dropdownButton.AbsolutePosition.Y + dropdownButton.AbsoluteSize.Y + 2)
            optionsList.Visible = true
            local targetSize = optionsList.Size -- Use calculated size
            optionsList.Size = UDim2.new(targetSize.X.Scale, targetSize.X.Offset, 0, 0) -- Start height at 0
            TweenService:Create(optionsList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = targetSize }):Play()
            TweenService:Create(arrowIcon, TweenInfo.new(0.2), { Rotation = -90 }):Play() -- Rotate arrow up

        else
            ActiveDropdown = nil -- No longer the active dropdown

            -- Animate Close and Destroy
            if optionsList and optionsList.Parent then
                local listRef = optionsList -- Store reference for callback
                optionsList = nil -- Clear reference

                local tweenInfoClose = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                local sizeTween = TweenService:Create(listRef, tweenInfoClose, { Size = UDim2.new(listRef.Size.X.Scale, listRef.Size.X.Offset, 0, 0) })
                sizeTween:Play()
                TweenService:Create(arrowIcon, TweenInfo.new(0.2), { Rotation = 90 }):Play() -- Rotate arrow down

                sizeTween.Completed:Connect(function()
                    Utility.destroyInstance(listRef) -- Use pooled destroy
                end)
            else
                 -- Ensure arrow resets if list wasn't open/valid
                 TweenService:Create(arrowIcon, TweenInfo.new(0.2), { Rotation = 90 }):Play()
            end
        end
    end

    -- Update function
    function DropdownApi:SetValue(value, skipCallback)
        if not table.find(self.Options, value) then
            warn("[LuminaUI] Attempted to set invalid value for Dropdown '"..text.."':", value)
            return
        end
        if self.Value == value then return end -- No change

        self.Value = value
        currentValue = value -- Update local state

        dropdownButton.Text = tostring(value)

        -- Update selected item style if options list is open
        if optionsList and optionsList.Parent then
            for _, itemButton in ipairs(optionsList:GetChildren()) do
                if itemButton:IsA("TextButton") and itemButton.Name == "OptionItem" then
                    local isSelected = (itemButton.Text == tostring(value))
                    itemButton.BackgroundColor3 = isSelected and theme.DropdownSelected or theme.DropdownUnselected
                end
            end
        end

        -- Update flag registry
        if flag and LuminaUI.Flags[flag] then
            LuminaUI.Flags[flag].Value = value
        end

        -- Trigger callback if not skipped
        if not skipCallback then
            Utility.safeCall(callback, value)
        end
    end

    -- Interaction
    DropdownApi:AddConnection(dropdownButton.MouseButton1Click:Connect(function()
        self:ToggleOpen()
    end))

    -- Tooltip
    if dropdownSettings.Tooltip then
         DropdownApi:AddConnection(dropdownFrame.MouseEnter:Connect(function() if not isOpen then Utility.showTooltip(dropdownSettings.Tooltip, self._window.CurrentTheme) end end))
         DropdownApi:AddConnection(dropdownFrame.MouseLeave:Connect(function() Utility.hideTooltip() end))
    end

    -- Register flag for saving/loading
    if flag then
        LuminaUI.Flags[flag] = { Value = currentValue, Type = "Dropdown", ComponentRef = DropdownApi }
    end

    return self:AddComponent(dropdownFrame, DropdownApi)
end

-- Add Textbox
function Tab:AddTextbox(textboxSettings)
    textboxSettings = textboxSettings or {}
    local text = textboxSettings.Text or "Textbox"
    local flag = textboxSettings.Flag -- Mandatory
    local placeholder = textboxSettings.Placeholder or "Enter text..."
    local defaultValue = textboxSettings.Default or ""
    local clearOnFocus = textboxSettings.ClearOnFocus -- Default behavior is true from pool reset
    local order = textboxSettings.Order or (#self._components + 1)
    local callback = textboxSettings.Callback or function(value) print("[LuminaUI] Textbox '"..text.."' changed to:", value) end
    local theme = self._window.CurrentTheme

    if not flag then warn("[LuminaUI] Textbox '"..text.."' is missing a 'Flag' for configuration saving.") end

    local currentValue = defaultValue

    local textboxFrame = Utility.createInstance("Frame", {
        Name = "Textbox_" .. text,
        Size = UDim2.new(1, 0, 0, 55), -- Taller frame for label + textbox
        BackgroundTransparency = 1,
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    Utility.manageConnections(textboxFrame)

    local label = Utility.createInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -20, 0, 20), -- Full width (-padding)
        Position = UDim2.new(0, 10, 0, 5), -- Position top-left
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = textboxFrame
    })
    Utility.registerThemedElement(label, "TextColor3", "TextColor")

    local textbox = Utility.createInstance("TextBox", {
        Name = "Input",
        Size = UDim2.new(1, -20, 0, 25), -- Full width (-padding), fixed height
        Position = UDim2.new(0, 10, 0, 25), -- Position below label
        BackgroundColor3 = theme.InputBackground,
        PlaceholderText = placeholder,
        PlaceholderColor3 = theme.InputPlaceholder,
        Text = currentValue,
        TextColor3 = theme.TextColor,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = clearOnFocus, -- Use provided setting or default
        Parent = textboxFrame
    })
    Utility.createCorner(textbox, 4)
    local stroke = Utility.createStroke(textbox, theme.InputStroke, 1)
    Utility.registerThemedElement(textbox, "BackgroundColor3", "InputBackground")
    Utility.registerThemedElement(textbox, "PlaceholderColor3", "InputPlaceholder")
    Utility.registerThemedElement(textbox, "TextColor3", "TextColor")
    -- Stroke already registered

    -- Padding for textbox text
    Utility.createInstance("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = textbox })

    -- API Object
    local TextboxApi = { Instance = textboxFrame, Input = textbox, _connections = {}, Value = currentValue }
    Utility.manageConnections(TextboxApi)

    -- Update function
    function TextboxApi:SetValue(value, skipCallback)
        value = tostring(value) -- Ensure string
        if self.Value == value then return end -- No change

        self.Value = value
        currentValue = value -- Update local state

        self.Input.Text = value

        -- Update flag registry
        if flag and LuminaUI.Flags[flag] then
            LuminaUI.Flags[flag].Value = value
        end

        -- Trigger callback if not skipped
        if not skipCallback then
            Utility.safeCall(callback, value)
        end
    end

    -- Interaction (FocusLost triggers callback and updates value)
    TextboxApi:AddConnection(textbox.FocusLost:Connect(function(enterPressed)
        -- Update value only when focus is lost or Enter is pressed
        self:SetValue(textbox.Text)
    end))
    -- Optional: Update on Changed event (can be spammy)
    -- TextboxApi:AddConnection(textbox:GetPropertyChangedSignal("Text"):Connect(function()
    --     -- Potentially debounce this if needed
    --     self:SetValue(textbox.Text)
    -- end))

    -- Tooltip
    if textboxSettings.Tooltip then
         TextboxApi:AddConnection(textboxFrame.MouseEnter:Connect(function() Utility.showTooltip(textboxSettings.Tooltip, self._window.CurrentTheme) end))
         TextboxApi:AddConnection(textboxFrame.MouseLeave:Connect(function() Utility.hideTooltip() end))
    end

    -- Register flag for saving/loading
    if flag then
        LuminaUI.Flags[flag] = { Value = currentValue, Type = "Textbox", ComponentRef = TextboxApi }
    end

    return self:AddComponent(textboxFrame, TextboxApi)
end

-- Add ColorPicker (Complex Component)
function Tab:AddColorPicker(cpSettings)
    cpSettings = cpSettings or {}
    local text = cpSettings.Text or "Color Picker"
    local flag = cpSettings.Flag -- Mandatory
    local defaultValue = cpSettings.Default or Color3.new(1, 1, 1) -- Default white
    local order = cpSettings.Order or (#self._components + 1)
    local callback = cpSettings.Callback or function(value) print("[LuminaUI] ColorPicker '"..text.."' set to:", value) end
    local theme = self._window.CurrentTheme

    if not flag then warn("[LuminaUI] ColorPicker '"..text.."' is missing a 'Flag' for configuration saving.") end

    local currentValue = defaultValue
    local isOpen = false

    local cpFrame = Utility.createInstance("Frame", {
        Name = "ColorPicker_" .. text,
        Size = UDim2.new(1, 0, 0, 35), -- Standard height
        BackgroundTransparency = 1,
        LayoutOrder = order,
        ZIndex = 6, -- Above dropdowns
        -- Parent set by AddComponent
    })
    Utility.manageConnections(cpFrame)

    local label = Utility.createInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.6, -10, 1, 0), -- Adjust width
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham, Text = text, TextColor3 = theme.TextColor, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = cpFrame
    })
    Utility.registerThemedElement(label, "TextColor3", "TextColor")

    local colorButton = Utility.createInstance("TextButton", {
        Name = "ColorButton",
        Size = UDim2.new(0.4, -10, 1, -10), -- Adjust width
        Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = theme.InputBackground, Text = "", Parent = cpFrame
    })
    Utility.createCorner(colorButton, 4)
    local buttonStroke = Utility.createStroke(colorButton, theme.InputStroke, 1)
    Utility.registerThemedElement(colorButton, "BackgroundColor3", "InputBackground", "ElementBackgroundHover")
    -- Stroke registered

    local colorPreview = Utility.createInstance("Frame", {
        Name = "Preview",
        Size = UDim2.new(1, -8, 1, -8), -- Slightly smaller for border effect
        Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = currentValue, -- Show current color
        BorderSizePixel = 0, Parent = colorButton
    })
    Utility.createCorner(colorPreview, 3)
    -- No theme registration needed for preview, it shows the actual value

    -- Picker Popup (created on demand)
    local pickerPopup = nil

    -- API Object
    local CPApi = { Instance = cpFrame, _connections = {}, Value = currentValue }
    Utility.manageConnections(CPApi)

    -- Function to create/destroy the picker popup
    function CPApi:ToggleOpen(forceState)
        isOpen = (forceState ~= nil) and forceState or not isOpen

        -- Close any other active dropdown/picker first
        if isOpen and ActiveDropdown and ActiveDropdown ~= self then
             Utility.safeCall(ActiveDropdown.ToggleOpen, ActiveDropdown, false)
        end

        if isOpen then
            ActiveDropdown = self -- Set this as the active picker

            if not pickerPopup or not pickerPopup.Parent then
                local popupWidth, popupHeight = 200, 230
                pickerPopup = Utility.createInstance("Frame", {
                    Name = "PickerPopup",
                    Size = UDim2.new(0, popupWidth, 0, popupHeight),
                    Position = UDim2.new(0, colorButton.AbsolutePosition.X + colorButton.AbsoluteSize.X - popupWidth, 0, colorButton.AbsolutePosition.Y + colorButton.AbsoluteSize.Y + 2), -- Position below and aligned right
                    BackgroundColor3 = theme.ColorPickerBackground,
                    BorderSizePixel = 1, BorderColor3 = theme.InputStroke,
                    ClipsDescendants = true, Visible = false,
                    ZIndex = 110, -- Above options lists
                    Parent = self._window.ScreenGui
                })
                Utility.createCorner(pickerPopup, 6)
                Utility.registerThemedElement(pickerPopup, "BackgroundColor3", "ColorPickerBackground")
                Utility.registerThemedElement(pickerPopup, "BorderColor3", "InputStroke")
                Utility.manageConnections(pickerPopup)

                -- Saturation/Value Box (using UIGradient)
                local svBoxSize = popupWidth - 20
                local svBox = Utility.createInstance("ImageButton", { -- ImageButton for input
                    Name = "SVBox",
                    Size = UDim2.new(0, svBoxSize, 0, svBoxSize),
                    Position = UDim2.new(0.5, 0, 0, 10), AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundColor3 = Color3.fromHSV(currentValue:ToHSV()), -- Initial hue
                    Parent = pickerPopup
                })
                Utility.createCorner(svBox, 4)

                -- Saturation Gradient (White -> Transparent)
                Utility.createInstance("UIGradient", {
                    Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(1,1,1))}),
                    Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}),
                    Rotation = 90, Parent = svBox
                })
                -- Value Gradient (Black -> Transparent)
                Utility.createInstance("UIGradient", {
                    Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, Color3.new(0,0,0))}),
                    Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}),
                    Rotation = 0, Parent = svBox
                })

                -- SV Picker Circle
                local svPicker = Utility.createInstance("Frame", {
                    Name = "SVPicker",
                    Size = UDim2.new(0, 10, 0, 10), AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 1, BorderColor3 = Color3.new(0,0,0),
                    ZIndex = svBox.ZIndex + 1, Parent = svBox
                })
                Utility.createCorner(svPicker, 5)

                -- Hue Slider
                local hueSliderHeight = 15
                local hueSlider = Utility.createInstance("ImageButton", { -- ImageButton for input
                    Name = "HueSlider",
                    Size = UDim2.new(0, svBoxSize, 0, hueSliderHeight),
                    Position = UDim2.new(0.5, 0, 0, svBoxSize + 20), AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundColor3 = Color3.new(1,1,1), -- Background for gradient
                    Parent = pickerPopup
                })
                Utility.createCorner(hueSlider, hueSliderHeight / 2)
                -- Hue Gradient
                Utility.createInstance("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(1,0,0)), ColorSequenceKeypoint.new(1/6, Color3.new(1,1,0)),
                        ColorSequenceKeypoint.new(2/6, Color3.new(0,1,0)), ColorSequenceKeypoint.new(3/6, Color3.new(0,1,1)),
                        ColorSequenceKeypoint.new(4/6, Color3.new(0,0,1)), ColorSequenceKeypoint.new(5/6, Color3.new(1,0,1)),
                        ColorSequenceKeypoint.new(1, Color3.new(1,0,0))
                    }),
                    Parent = hueSlider
                })

                -- Hue Picker Thumb
                local huePicker = Utility.createInstance("Frame", {
                    Name = "HuePicker",
                    Size = UDim2.new(0, 6, 1, 4), AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0), -- Position updated later
                    BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 1, BorderColor3 = Color3.new(0,0,0),
                    ZIndex = hueSlider.ZIndex + 1, Parent = hueSlider
                })
                Utility.createCorner(huePicker, 3)

                -- Function to update color from HSV
                local function updateColorFromHSV(h, s, v, skipCallback)
                    local newColor = Color3.fromHSV(h, s, v)
                    if CPApi.Value:ToHSV() == newColor:ToHSV() then return end -- Avoid redundant updates

                    CPApi.Value = newColor
                    currentValue = newColor

                    colorPreview.BackgroundColor3 = newColor
                    svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1) -- Update SV box base hue

                    -- Update picker positions
                    svPicker.Position = UDim2.new(s, 0, 1 - v, 0)
                    huePicker.Position = UDim2.new(h, 0, 0.5, 0)

                    -- Update border color for visibility
                    local lum = (newColor.R*0.299 + newColor.G*0.587 + newColor.B*0.114)
                    svPicker.BorderColor3 = lum > 0.5 and Color3.new(0,0,0) or Color3.new(1,1,1)

                    if flag and LuminaUI.Flags[flag] then LuminaUI.Flags[flag].Value = newColor end
                    if not skipCallback then Utility.safeCall(callback, newColor) end
                end

                -- Initial state update
                local h, s, v = currentValue:ToHSV()
                updateColorFromHSV(h, s, v, true) -- Update UI without callback initially

                -- Input Handling
                local svDragging, hueDragging = false, false

                local function updateSV(input)
                    local x = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                    local y = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                    local currentH, _, _ = CPApi.Value:ToHSV()
                    updateColorFromHSV(currentH, x, 1 - y)
                end
                local function updateHue(input)
                    local x = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
                    local _, currentS, currentV = CPApi.Value:ToHSV()
                    updateColorFromHSV(x, currentS, currentV)
                end

                pickerPopup:AddConnection(svBox.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = true; updateSV(input) end end))
                pickerPopup:AddConnection(hueSlider.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = true; updateHue(input) end end))

                pickerPopup:AddConnection(UserInputService.InputChanged:Connect(function(input)
                    if svDragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateSV(input) end
                    if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateHue(input) end
                end))
                pickerPopup:AddConnection(UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging, hueDragging = false, false end
                end))
            end

            -- Position and Animate Open
            pickerPopup.Position = UDim2.new(0, colorButton.AbsolutePosition.X + colorButton.AbsoluteSize.X - pickerPopup.AbsoluteSize.X, 0, colorButton.AbsolutePosition.Y + colorButton.AbsoluteSize.Y + 2)
            pickerPopup.Visible = true
            pickerPopup.Size = UDim2.new(pickerPopup.Size.X.Scale, pickerPopup.Size.X.Offset, 0, 0) -- Start height 0
            TweenService:Create(pickerPopup, TweenInfo.new(0.2), { Size = UDim2.new(pickerPopup.Size.X.Scale, pickerPopup.Size.X.Offset, 0, 230) }):Play() -- Animate to full height

        else
            ActiveDropdown = nil -- No longer active

            if pickerPopup and pickerPopup.Parent then
                local popupRef = pickerPopup
                pickerPopup = nil
                local tweenInfoClose = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                local sizeTween = TweenService:Create(popupRef, tweenInfoClose, { Size = UDim2.new(popupRef.Size.X.Scale, popupRef.Size.X.Offset, 0, 0) })
                sizeTween:Play()
                sizeTween.Completed:Connect(function() Utility.destroyInstance(popupRef) end)
            end
        end
    end

    -- Update function
    function CPApi:SetValue(value, skipCallback)
        if typeof(value) ~= "Color3" then
            warn("[LuminaUI] Invalid value type for ColorPicker: expected Color3, got", typeof(value))
            return
        end
        -- Compare HSV for floating point precision issues
        local h1, s1, v1 = self.Value:ToHSV()
        local h2, s2, v2 = value:ToHSV()
        if math.abs(h1-h2)<0.001 and math.abs(s1-s2)<0.001 and math.abs(v1-v2)<0.001 then return end -- No change

        -- Update internal value and preview
        self.Value = value
        currentValue = value
        colorPreview.BackgroundColor3 = value

        -- Update picker UI if open
        if pickerPopup and pickerPopup.Parent then
            local h, s, v = value:ToHSV()
            local svBox = pickerPopup:FindFirstChild("SVBox")
            local svPicker = svBox and svBox:FindFirstChild("SVPicker")
            local hueSlider = pickerPopup:FindFirstChild("HueSlider")
            local huePicker = hueSlider and hueSlider:FindFirstChild("HuePicker")

            if svBox then svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1) end
            if svPicker then svPicker.Position = UDim2.new(s, 0, 1 - v, 0) end
            if huePicker then huePicker.Position = UDim2.new(h, 0, 0.5, 0) end

            -- Update SV picker border color
            if svPicker then
                 local lum = (value.R*0.299 + value.G*0.587 + value.B*0.114)
                 svPicker.BorderColor3 = lum > 0.5 and Color3.new(0,0,0) or Color3.new(1,1,1)
            end
        end

        -- Update flag registry
        if flag and LuminaUI.Flags[flag] then
            LuminaUI.Flags[flag].Value = value
        end

        -- Trigger callback if not skipped
        if not skipCallback then
            Utility.safeCall(callback, value)
        end
    end

    -- Interaction
    CPApi:AddConnection(colorButton.MouseButton1Click:Connect(function() self:ToggleOpen() end))

    -- Tooltip
    if cpSettings.Tooltip then
         CPApi:AddConnection(cpFrame.MouseEnter:Connect(function() if not isOpen then Utility.showTooltip(cpSettings.Tooltip, self._window.CurrentTheme) end end))
         CPApi:AddConnection(cpFrame.MouseLeave:Connect(function() Utility.hideTooltip() end))
    end

    -- Register flag for saving/loading
    if flag then
        LuminaUI.Flags[flag] = { Value = currentValue, Type = "ColorPicker", ComponentRef = CPApi }
    end

    return self:AddComponent(cpFrame, CPApi)
end

-- Add Keybind
function Tab:AddKeybind(keybindSettings)
    keybindSettings = keybindSettings or {}
    local text = keybindSettings.Text or "Keybind"
    local flag = keybindSettings.Flag -- Mandatory
    local defaultKey = keybindSettings.Default or Enum.KeyCode.None
    local mode = keybindSettings.Mode or "Toggle" -- "Toggle", "Hold", "Always"
    local order = keybindSettings.Order or (#self._components + 1)
    local callback = keybindSettings.Callback or function(state) print("[LuminaUI] Keybind '"..text.."' state:", state) end
    local theme = self._window.CurrentTheme

    if not flag then warn("[LuminaUI] Keybind '"..text.."' is missing a 'Flag' for configuration saving.") end
    if typeof(defaultKey) == "string" then defaultKey = Enum.KeyCode[defaultKey] or Enum.KeyCode.None end -- Allow string names

    local currentKey = defaultKey
    local currentMode = mode
    local isBinding = false -- Is user currently clicking to bind a new key?
    local isActive = false -- Is the keybind currently active (pressed/toggled on)?
    local inputConn = nil -- Connection for UserInputService

    local kbFrame = Utility.createInstance("Frame", {
        Name = "Keybind_" .. text,
        Size = UDim2.new(1, 0, 0, 35), -- Standard height
        BackgroundTransparency = 1,
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    Utility.manageConnections(kbFrame)

    local label = Utility.createInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.6, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = text,
        TextColor3 = theme.TextColor, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = kbFrame
    })
    Utility.registerThemedElement(label, "TextColor3", "TextColor")

    local keyButton = Utility.createInstance("TextButton", {
        Name = "KeyButton",
        Size = UDim2.new(0.4, -10, 1, -10), Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = theme.InputBackground,
        Font = Enum.Font.GothamBold, Text = currentKey.Name, TextColor3 = theme.TextColor, TextSize = 13,
        Parent = kbFrame
    })
    Utility.createCorner(keyButton, 4)
    local buttonStroke = Utility.createStroke(keyButton, theme.InputStroke, 1)
    Utility.registerThemedElement(keyButton, "BackgroundColor3", "InputBackground", "ElementBackgroundHover")
    Utility.registerThemedElement(keyButton, "TextColor3", "TextColor")
    -- Stroke registered

    -- API Object
    local KBApi = { Instance = kbFrame, _connections = {}, Value = currentKey, Mode = currentMode, IsActive = isActive }
    Utility.manageConnections(KBApi)

    -- Function to update the keybind listener
    local function updateListener()
        if inputConn then inputConn:Disconnect(); inputConn = nil end
        if currentKey == Enum.KeyCode.None then isActive = false; return end -- No key, no listener

        if currentMode == "Always" then
            isActive = true -- Always active if key is set
            Utility.safeCall(callback, true)
            return -- No input needed
        end

        inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == currentKey then
                if currentMode == "Toggle" then
                    isActive = not isActive
                    Utility.safeCall(callback, isActive)
                elseif currentMode == "Hold" then
                    isActive = true
                    Utility.safeCall(callback, true)
                end
            end
        end)
        KBApi:AddConnection(inputConn) -- Manage this connection

        if currentMode == "Hold" then
            local endedConn = UserInputService.InputEnded:Connect(function(input)
                if input.KeyCode == currentKey then
                    isActive = false
                    Utility.safeCall(callback, false)
                end
            end)
            KBApi:AddConnection(endedConn) -- Manage this connection too
        end
    end

    -- Function to set the key
    function KBApi:SetValue(value, skipCallback)
        if typeof(value) == "string" then value = Enum.KeyCode[value] or Enum.KeyCode.None end
        if typeof(value) ~= "EnumItem" or not value:IsA("KeyCode") then value = Enum.KeyCode.None end
        if self.Value == value then return end -- No change

        self.Value = value
        currentKey = value
        keyButton.Text = value.Name
        isBinding = false -- Ensure binding mode is exited

        updateListener() -- Recreate listener for the new key

        if flag and LuminaUI.Flags[flag] then LuminaUI.Flags[flag].Value = value.Name end -- Save key name
        -- Callback is triggered by input, not usually by SetValue itself
    end

    -- Function to set the mode
    function KBApi:SetMode(newMode)
        if newMode ~= "Toggle" and newMode ~= "Hold" and newMode ~= "Always" then return end
        if self.Mode == newMode then return end

        self.Mode = newMode
        currentMode = newMode
        isActive = false -- Reset active state when mode changes
        updateListener() -- Recreate listener for the new mode

        if flag and LuminaUI.Flags[flag] then LuminaUI.Flags[flag].Mode = newMode end -- Save mode if needed (requires config format change)
        -- Trigger callback with initial state for new mode? Optional.
        -- Utility.safeCall(callback, isActive)
    end

    -- Interaction (Click to bind)
    KBApi:AddConnection(keyButton.MouseButton1Click:Connect(function()
        if isBinding then -- Cancel binding
            isBinding = false
            keyButton.Text = currentKey.Name
            keyButton.TextColor3 = theme.TextColor
        else -- Start binding
            isBinding = true
            keyButton.Text = "..."
            keyButton.TextColor3 = theme.SubTextColor -- Indicate binding state

            -- Temporary listener for the next key press
            local bindConn
            bindConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then -- Allow mouse buttons too
                    local newKey = input.KeyCode
                    -- Allow Esc or clicking button again to cancel/unbind
                    if newKey == Enum.KeyCode.Escape or input.UserInputType == Enum.UserInputType.MouseButton1 and input.Target == keyButton then
                        newKey = Enum.KeyCode.None
                    end
                    self:SetValue(newKey) -- Set the new key (handles exiting binding state)
                    if bindConn then bindConn:Disconnect() end -- Disconnect this temporary listener
                end
            end)
            -- Auto-cancel if focus lost?
            local focusLostConn = keyButton.FocusLost:Connect(function()
                 if isBinding then
                     isBinding = false
                     keyButton.Text = currentKey.Name
                     keyButton.TextColor3 = theme.TextColor
                     if bindConn then bindConn:Disconnect() end
                 end
                 if focusLostConn then focusLostConn:Disconnect() end
            end)
        end
    end))

    -- Tooltip
    if keybindSettings.Tooltip then
         KBApi:AddConnection(kbFrame.MouseEnter:Connect(function() Utility.showTooltip(keybindSettings.Tooltip, self._window.CurrentTheme) end))
         KBApi:AddConnection(kbFrame.MouseLeave:Connect(function() Utility.hideTooltip() end))
    end

    -- Initial listener setup
    updateListener()

    -- Register flag for saving/loading (saving KeyCode.Name)
    if flag then
        LuminaUI.Flags[flag] = { Value = currentKey.Name, Type = "Keybind", ComponentRef = KBApi, Mode = currentMode }
        -- Need to handle loading Mode from config if saved
    end

    return self:AddComponent(kbFrame, KBApi)
end

-- Add Section
function Tab:AddSection(sectionSettings)
    sectionSettings = sectionSettings or {}
    local text = sectionSettings.Text or "Section"
    local order = sectionSettings.Order or (#self._components + 1)
    local theme = self._window.CurrentTheme

    local sectionFrame = Utility.createInstance("Frame", {
        Name = "Section_" .. text,
        Size = UDim2.new(1, 0, 0, 25), -- Slightly shorter than standard elements
        BackgroundTransparency = 1, -- No background itself
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    Utility.manageConnections(sectionFrame)

    local lineLeft = Utility.createInstance("Frame", {
        Name = "LineLeft",
        Size = UDim2.new(0.5, -40, 0, 1), -- Half width minus text space/padding
        Position = UDim2.new(0, 10, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = theme.ElementStroke, BackgroundTransparency = 0.5,
        Parent = sectionFrame
    })
    Utility.registerThemedElement(lineLeft, "BackgroundColor3", "ElementStroke")

    local label = Utility.createInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0, 60, 1, 0), -- Fixed width for text
        Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = text,
        TextColor3 = theme.SubTextColor, TextSize = 12,
        Parent = sectionFrame
    })
    Utility.registerThemedElement(label, "TextColor3", "SubTextColor")

    local lineRight = Utility.createInstance("Frame", {
        Name = "LineRight",
        Size = UDim2.new(0.5, -40, 0, 1), -- Half width minus text space/padding
        Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = theme.ElementStroke, BackgroundTransparency = 0.5,
        Parent = sectionFrame
    })
    Utility.registerThemedElement(lineRight, "BackgroundColor3", "ElementStroke")

    -- API Object (Simple, mostly for consistency)
    local SectionApi = { Instance = sectionFrame }

    return self:AddComponent(sectionFrame, SectionApi)
end

-- Add ProgressBar
function Tab:AddProgressBar(pbSettings)
    pbSettings = pbSettings or {}
    local text = pbSettings.Text or "Progress"
    local flag = pbSettings.Flag -- Mandatory
    local defaultValue = pbSettings.Default or 0 -- Value between 0 and 1
    local showPercentage = pbSettings.ShowPercentage ~= false -- Default true
    local order = pbSettings.Order or (#self._components + 1)
    local theme = self._window.CurrentTheme

    if not flag then warn("[LuminaUI] ProgressBar '"..text.."' is missing a 'Flag' for configuration saving/updating.") end

    defaultValue = math.clamp(defaultValue, 0, 1)
    local currentValue = defaultValue

    local pbFrame = Utility.createInstance("Frame", {
        Name = "ProgressBar_" .. text,
        Size = UDim2.new(1, 0, 0, 35), -- Standard height
        BackgroundTransparency = 1,
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    Utility.manageConnections(pbFrame)

    local label = Utility.createInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(showPercentage and 0.7 or 1, -10, 0, 18), -- Adjust width based on percentage display
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = text,
        TextColor3 = theme.TextColor, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = pbFrame
    })
    Utility.registerThemedElement(label, "TextColor3", "TextColor")

    local percentageLabel = nil
    if showPercentage then
        percentageLabel = Utility.createInstance("TextLabel", {
            Name = "PercentageLabel",
            Size = UDim2.new(0.3, -10, 0, 18), Position = UDim2.new(1, -10, 0, 0),
            AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
            Text = string.format("%.0f%%", currentValue * 100), TextColor3 = theme.SubTextColor, TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Right, Parent = pbFrame
        })
        Utility.registerThemedElement(percentageLabel, "TextColor3", "SubTextColor")
    end

    local track = Utility.createInstance("Frame", {
        Name = "Track",
        Size = UDim2.new(1, -20, 0, 8), Position = UDim2.new(0, 10, 0, 20),
        BackgroundColor3 = theme.ProgressBarBackground, Parent = pbFrame
    })
    Utility.createCorner(track, 4)
    Utility.registerThemedElement(track, "BackgroundColor3", "ProgressBarBackground")

    local fill = Utility.createInstance("Frame", {
        Name = "Fill",
        Size = UDim2.new(currentValue, 0, 1, 0), BackgroundColor3 = theme.ProgressBarFill,
        Parent = track
    })
    Utility.createCorner(fill, 4)
    Utility.registerThemedElement(fill, "BackgroundColor3", "ProgressBarFill")

    -- API Object
    local PBApi = { Instance = pbFrame, _connections = {}, Value = currentValue }
    Utility.manageConnections(PBApi)

    -- Update function
    function PBApi:SetValue(value, skipCallback) -- skipCallback is unused but kept for consistency
        value = math.clamp(value, 0, 1)
        if self.Value == value then return end -- No change

        self.Value = value
        currentValue = value

        -- Animate fill bar
        TweenService:Create(fill, TweenInfo.new(0.2), { Size = UDim2.new(value, 0, 1, 0) }):Play()
        if percentageLabel then
            percentageLabel.Text = string.format("%.0f%%", value * 100)
        end

        -- Update flag registry (if needed for external reading, not usually saved)
        if flag and LuminaUI.Flags[flag] then
            LuminaUI.Flags[flag].Value = value
        end
    end

    -- Tooltip
    if pbSettings.Tooltip then
         PBApi:AddConnection(pbFrame.MouseEnter:Connect(function() Utility.showTooltip(pbSettings.Tooltip, self._window.CurrentTheme) end))
         PBApi:AddConnection(pbFrame.MouseLeave:Connect(function() Utility.hideTooltip() end))
    end

    -- Register flag (primarily for external updates via SetValue)
    if flag then
        LuminaUI.Flags[flag] = { Value = currentValue, Type = "ProgressBar", ComponentRef = PBApi }
    end

    return self:AddComponent(pbFrame, PBApi)
end

-- Add Checkbox
function Tab:AddCheckbox(cbSettings)
    cbSettings = cbSettings or {}
    local text = cbSettings.Text or "Checkbox"
    local flag = cbSettings.Flag -- Mandatory
    local defaultValue = cbSettings.Default or false
    local order = cbSettings.Order or (#self._components + 1)
    local callback = cbSettings.Callback or function(value) print("[LuminaUI] Checkbox '"..text.."' set to:", value) end
    local theme = self._window.CurrentTheme

    if not flag then warn("[LuminaUI] Checkbox '"..text.."' is missing a 'Flag' for configuration saving.") end

    local currentValue = defaultValue

    local cbFrame = Utility.createInstance("Frame", {
        Name = "Checkbox_" .. text,
        Size = UDim2.new(1, 0, 0, 25), -- Shorter height
        BackgroundTransparency = 1,
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    Utility.manageConnections(cbFrame)

    local boxButton = Utility.createInstance("TextButton", { -- Use button for interaction
        Name = "BoxButton",
        Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = theme.CheckboxUnchecked,
        Text = "", Parent = cbFrame
    })
    Utility.createCorner(boxButton, 4)
    Utility.registerThemedElement(boxButton, "BackgroundColor3", "CheckboxUnchecked") -- Base is unchecked

    local checkIcon = Utility.createInstance("ImageLabel", {
        Name = "Check",
        Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
        Image = "rbxassetid://6031280882", -- Placeholder checkmark-like icon (settings icon)
        ImageColor3 = Color3.new(1,1,1), -- White checkmark
        ImageTransparency = defaultValue and 0 or 1, -- Visible if checked by default
        Rotation = -90, -- Rotate to look more like a check
        ZIndex = boxButton.ZIndex + 1, Parent = boxButton
    })

    local label = Utility.createInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -(10 + 18 + 10), 1, 0), -- Width = Frame width - left pad - box width - right pad
        Position = UDim2.new(0, 10 + 18 + 5, 0, 0), -- Position right of box
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = text,
        TextColor3 = theme.TextColor, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = cbFrame
    })
    Utility.registerThemedElement(label, "TextColor3", "TextColor")

    -- API Object
    local CBApi = { Instance = cbFrame, _connections = {}, Value = currentValue }
    Utility.manageConnections(CBApi)

    -- Update function
    function CBApi:SetValue(value, skipCallback)
        value = value == true
        if self.Value == value then return end

        self.Value = value
        currentValue = value

        local targetColor = value and self._window.CurrentTheme.CheckboxChecked or self._window.CurrentTheme.CheckboxUnchecked
        local targetTransparency = value and 0 or 1

        local tweenInfo = TweenInfo.new(0.2)
        TweenService:Create(boxButton, tweenInfo, { BackgroundColor3 = targetColor }):Play()
        TweenService:Create(checkIcon, tweenInfo, { ImageTransparency = targetTransparency }):Play()

        if flag and LuminaUI.Flags[flag] then LuminaUI.Flags[flag].Value = value end
        if not skipCallback then Utility.safeCall(callback, value) end
    end

    -- Interaction
    CBApi:AddConnection(boxButton.MouseButton1Click:Connect(function() self:SetValue(not self.Value) end))

    -- Tooltip
    if cbSettings.Tooltip then
         CBApi:AddConnection(cbFrame.MouseEnter:Connect(function() Utility.showTooltip(cbSettings.Tooltip, self._window.CurrentTheme) end))
         CBApi:AddConnection(cbFrame.MouseLeave:Connect(function() Utility.hideTooltip() end))
    end

    -- Register flag
    if flag then
        LuminaUI.Flags[flag] = { Value = currentValue, Type = "Checkbox", ComponentRef = CBApi }
    end

    -- Initial state visual update
    CBApi:SetValue(currentValue, true)

    return self:AddComponent(cbFrame, CBApi)
end

-- Add Divider
function Tab:AddDivider(dividerSettings)
    dividerSettings = dividerSettings or {}
    local thickness = dividerSettings.Thickness or 1
    local color = dividerSettings.Color -- Uses theme if nil
    local transparency = dividerSettings.Transparency or 0.5
    local padding = dividerSettings.Padding or UDim.new(0, 10) -- Vertical padding
    local order = dividerSettings.Order or (#self._components + 1)
    local theme = self._window.CurrentTheme

    local divider = Utility.createInstance("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, 0, 0, thickness),
        BackgroundColor3 = color or theme.ElementStroke,
        BackgroundTransparency = transparency,
        BorderSizePixel = 0,
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    -- Add vertical padding using a container frame
    local paddingFrame = Utility.createInstance("Frame", {
        Name = "DividerPadding",
        Size = UDim2.new(1, 0, 0, thickness + padding.Offset * 2), -- Total height including padding
        BackgroundTransparency = 1,
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    divider.Position = UDim2.new(0, 0, 0.5, 0) -- Center divider within padding frame
    divider.AnchorPoint = Vector2.new(0, 0.5)
    divider.Parent = paddingFrame

    if not color then -- Only register if using theme color
        Utility.registerThemedElement(divider, "BackgroundColor3", "ElementStroke")
    end

    -- API Object (Simple)
    local DividerApi = { Instance = paddingFrame }

    return self:AddComponent(paddingFrame, DividerApi)
end

-- Add Paragraph
function Tab:AddParagraph(pSettings)
    pSettings = pSettings or {}
    local title = pSettings.Title or ""
    local content = pSettings.Content or "Paragraph content goes here."
    local order = pSettings.Order or (#self._components + 1)
    local theme = self._window.CurrentTheme

    local pFrame = Utility.createInstance("Frame", {
        Name = "Paragraph_" .. (title or "NoTitle"),
        Size = UDim2.new(1, 0, 0, 0), -- Auto-sized height
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = order,
        -- Parent set by AddComponent
    })
    Utility.manageConnections(pFrame)

    Utility.createInstance("UIListLayout", { -- Layout for title + content
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = pFrame
    })

    if title ~= "" then
        local titleLabel = Utility.createInstance("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -20, 0, 18), Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = title,
            TextColor3 = theme.TextColor, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 1, Parent = pFrame
        })
        Utility.registerThemedElement(titleLabel, "TextColor3", "TextColor")
    end

    local contentLabel = Utility.createInstance("TextLabel", {
        Name = "Content",
        Size = UDim2.new(1, -20, 0, 0), -- Auto-sized height
        AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = content,
        TextColor3 = theme.SubTextColor, TextSize = 13, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        LayoutOrder = 2, Parent = pFrame
    })
    Utility.registerThemedElement(contentLabel, "TextColor3", "SubTextColor")

    -- API Object (Simple)
    local ParagraphApi = { Instance = pFrame }

    return self:AddComponent(pFrame, ParagraphApi)
end

-- Store Tab API object
self.Tabs[name] = Tab

-- Select the first tab created by default
if not self._activeTabButton then
    self:_selectTab(tabButton, page)
end

return Tab
end

-- Placeholder for CreateTabGroup
function Window:CreateTabGroup(...)
warn("[LuminaUI] CreateTabGroup is not yet implemented.")
end

-- Select first tab if any exist after creation loop finishes
if not Window._activeTabButton then
local firstButton, firstPage = nil, nil
for _, child in ipairs(Window._tabScrollFrame:GetChildren()) do
     if child:IsA("Frame") and child:FindFirstChild("Interact") and child.Name ~= "Header" then
         firstButton = child
         firstPage = Window._elementsPageFolder:FindFirstChild(child.Name)
         break
     end
end
if firstButton and firstPage then
     Window:_selectTab(firstButton, firstPage)
elseif Window._settingsPage then -- Fallback to settings if no tabs
     Window:_selectTab(settingsButton, Window._settingsPage) -- Pass settingsButton for context
end
end

return Window
end

-- ==================================
--      Internal Helper Functions (Continued)
-- ==================================

-- Creates the Settings Page (ScrollingFrame)
local function _createSettingsPage(parentFolder, windowSettings, theme, windowApi)
local page = Utility.createInstance("ScrollingFrame", {
Name = "LuminaSettingsPage",
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(0, 0, 0, 0),
ScrollBarThickness = 0, Visible = false, -- Initially hidden
Parent = parentFolder
})
Utility.manageConnections(page)

local pageLayout = Utility.createInstance("UIListLayout", {
Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = page
})
Utility.createInstance("UIPadding", {
PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10),
PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
Parent = page
})
Utility.applyCustomScrollbar(page, theme, 4)

-- Settings Tab API (Mimics a regular Tab for adding components)
local SettingsTab = {
Instance = page, Layout = pageLayout, _window = windowApi, _connections = {}, _components = {}
}
Utility.manageConnections(SettingsTab)
-- Assign component methods from the Tab prototype (or copy them)
-- This assumes Tab methods are defined before _createSettingsPage is called, which they are now.
local tempTab = {} -- Create a dummy tab to borrow methods
windowApi:CreateTab({ Name = "__TempSettingsTab" }) -- Create and immediately destroy is messy
-- Instead, let's just copy the functions directly if possible, or define them within SettingsTab
-- Copying required functions:
SettingsTab.AddComponent = windowApi.Tabs[next(windowApi.Tabs)].AddComponent -- Borrow from first tab created
-- ...existing code... (Inside _createSettingsPage function)
SettingsTab.AddLabel = windowApi.Tabs[next(windowApi.Tabs)].AddLabel -- Borrow from first tab created
SettingsTab.AddButton = windowApi.Tabs[next(windowApi.Tabs)].AddButton
SettingsTab.AddToggle = windowApi.Tabs[next(windowApi.Tabs)].AddToggle
SettingsTab.AddSlider = windowApi.Tabs[next(windowApi.Tabs)].AddSlider
SettingsTab.AddDropdown = windowApi.Tabs[next(windowApi.Tabs)].AddDropdown
SettingsTab.AddTextbox = windowApi.Tabs[next(windowApi.Tabs)].AddTextbox
SettingsTab.AddColorPicker = windowApi.Tabs[next(windowApi.Tabs)].AddColorPicker
SettingsTab.AddKeybind = windowApi.Tabs[next(windowApi.Tabs)].AddKeybind
SettingsTab.AddSection = windowApi.Tabs[next(windowApi.Tabs)].AddSection
SettingsTab.AddProgressBar = windowApi.Tabs[next(windowApi.Tabs)].AddProgressBar
SettingsTab.AddCheckbox = windowApi.Tabs[next(windowApi.Tabs)].AddCheckbox
SettingsTab.AddDivider = windowApi.Tabs[next(windowApi.Tabs)].AddDivider
SettingsTab.AddParagraph = windowApi.Tabs[next(windowApi.Tabs)].AddParagraph
-- Note: This borrowing assumes at least one tab exists. A more robust way would be to define these methods directly or inherit.

-- Add Settings Components

-- Theme Selector
local themeNames = {}
for name, _ in pairs(LuminaUI.Theme) do table.insert(themeNames, name) end
table.sort(themeNames) -- Sort alphabetically

SettingsTab:AddDropdown({
    Text = "UI Theme",
    Flag = "LuminaThemeSetting", -- Internal flag, not saved by default config logic
    Options = themeNames,
    Default = windowApi.CurrentThemeName,
    Order = 1,
    Callback = function(selectedTheme)
        windowApi:SetTheme(selectedTheme)
    end
})

-- Configuration Saving Toggle (if enabled in initial settings)
if windowSettings.ConfigurationSaving and windowSettings.ConfigurationSaving.Enabled then
    SettingsTab:AddToggle({
        Text = "Save Configuration",
        Flag = "LuminaConfigSaveEnabled", -- Internal flag
        Default = true, -- Assume enabled if section exists
        Order = 2,
        Callback = function(value)
            -- This toggle might just be visual unless you add logic to disable saving based on it
            print("[LuminaUI] Config Saving Toggled (Visual):", value)
            -- If you want to truly disable/enable saving based on this:
            -- windowApi.Settings.ConfigurationSaving.Enabled = value
        end
    })

    SettingsTab:AddButton({
        Text = "Save Config Now",
        Order = 3,
        Callback = function()
            local position = windowApi.Instance.Position
            Utility.saveConfig(windowApi.Settings, position)
            windowApi:CreateNotification({ Title = "Settings", Content = "Configuration saved!", Duration = 3 })
        end
    })

    -- Add a button to reset config? (Requires deleting file and reloading UI)
    -- SettingsTab:AddButton({ Text = "Reset Config", Order = 4, Callback = function() ... end })
end

-- Add more settings options here as needed (e.g., UI scale, font size, etc.)

return page
end

-- Creates the container for notifications
local function _createNotificationsContainer(parent)
    local container = Utility.createInstance("Frame", {
        Name = "NotificationsContainer",
        Size = UDim2.new(0, 280, 1, -20), -- Fixed width, almost full height (minus padding)
        Position = UDim2.new(1, -10, 0, 10), -- Positioned top-right
        AnchorPoint = Vector2.new(1, 0), -- Anchor top-right
        BackgroundTransparency = 1,
        ClipsDescendants = false, -- Allow notifications to animate outside bounds initially
        ZIndex = 500, -- High ZIndex to be above main UI but potentially below modals
        Parent = parent
    })

    -- Layout for notifications (bottom to top)
    Utility.createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right, -- Align notifications to the right
        VerticalAlignment = Enum.VerticalAlignment.Bottom, -- New notifications appear at the bottom and push old ones up
        Parent = container
    })

    return container
end


-- Return the main library table
return LuminaUI
````-- filepath: c:\Users\micah\Downloads\lumina.lua
-- ...existing code... (Inside _createSettingsPage function)
SettingsTab.AddLabel = windowApi.Tabs[next(windowApi.Tabs)].AddLabel -- Borrow from first tab created
SettingsTab.AddButton = windowApi.Tabs[next(windowApi.Tabs)].AddButton
SettingsTab.AddToggle = windowApi.Tabs[next(windowApi.Tabs)].AddToggle
SettingsTab.AddSlider = windowApi.Tabs[next(windowApi.Tabs)].AddSlider
SettingsTab.AddDropdown = windowApi.Tabs[next(windowApi.Tabs)].AddDropdown
SettingsTab.AddTextbox = windowApi.Tabs[next(windowApi.Tabs)].AddTextbox
SettingsTab.AddColorPicker = windowApi.Tabs[next(windowApi.Tabs)].AddColorPicker
SettingsTab.AddKeybind = windowApi.Tabs[next(windowApi.Tabs)].AddKeybind
SettingsTab.AddSection = windowApi.Tabs[next(windowApi.Tabs)].AddSection
SettingsTab.AddProgressBar = windowApi.Tabs[next(windowApi.Tabs)].AddProgressBar
SettingsTab.AddCheckbox = windowApi.Tabs[next(windowApi.Tabs)].AddCheckbox
SettingsTab.AddDivider = windowApi.Tabs[next(windowApi.Tabs)].AddDivider
SettingsTab.AddParagraph = windowApi.Tabs[next(windowApi.Tabs)].AddParagraph
-- Note: This borrowing assumes at least one tab exists. A more robust way would be to define these methods directly or inherit.

-- Add Settings Components

-- Theme Selector
local themeNames = {}
for name, _ in pairs(LuminaUI.Theme) do table.insert(themeNames, name) end
table.sort(themeNames) -- Sort alphabetically

SettingsTab:AddDropdown({
    Text = "UI Theme",
    Flag = "LuminaThemeSetting", -- Internal flag, not saved by default config logic
    Options = themeNames,
    Default = windowApi.CurrentThemeName,
    Order = 1,
    Callback = function(selectedTheme)
        windowApi:SetTheme(selectedTheme)
    end
})

-- Configuration Saving Toggle (if enabled in initial settings)
if windowSettings.ConfigurationSaving and windowSettings.ConfigurationSaving.Enabled then
    SettingsTab:AddToggle({
        Text = "Save Configuration",
        Flag = "LuminaConfigSaveEnabled", -- Internal flag
        Default = true, -- Assume enabled if section exists
        Order = 2,
        Callback = function(value)
            -- This toggle might just be visual unless you add logic to disable saving based on it
            print("[LuminaUI] Config Saving Toggled (Visual):", value)
            -- If you want to truly disable/enable saving based on this:
            -- windowApi.Settings.ConfigurationSaving.Enabled = value
        end
    })

    SettingsTab:AddButton({
        Text = "Save Config Now",
        Order = 3,
        Callback = function()
            local position = windowApi.Instance.Position
            Utility.saveConfig(windowApi.Settings, position)
            windowApi:CreateNotification({ Title = "Settings", Content = "Configuration saved!", Duration = 3 })
        end
    })

    -- Add a button to reset config? (Requires deleting file and reloading UI)
    -- SettingsTab:AddButton({ Text = "Reset Config", Order = 4, Callback = function() ... end })
end

-- Add more settings options here as needed (e.g., UI scale, font size, etc.)

return page
end

-- Creates the container for notifications
local function _createNotificationsContainer(parent)
    local container = Utility.createInstance("Frame", {
        Name = "NotificationsContainer",
        Size = UDim2.new(0, 280, 1, -20), -- Fixed width, almost full height (minus padding)
        Position = UDim2.new(1, -10, 0, 10), -- Positioned top-right
        AnchorPoint = Vector2.new(1, 0), -- Anchor top-right
        BackgroundTransparency = 1,
        ClipsDescendants = false, -- Allow notifications to animate outside bounds initially
        ZIndex = 500, -- High ZIndex to be above main UI but potentially below modals
        Parent = parent
    })

    -- Layout for notifications (bottom to top)
    Utility.createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right, -- Align notifications to the right
        VerticalAlignment = Enum.VerticalAlignment.Bottom, -- New notifications appear at the bottom and push old ones up
        Parent = container
    })

    return container
end


-- Return the main library table
return LuminaUI
