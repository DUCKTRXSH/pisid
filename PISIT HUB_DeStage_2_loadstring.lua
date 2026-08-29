local _body2 =game:HttpGet("https://onf-pisit.kirsrsaema66.workers.dev/api/script/toglrdn9g0")
local HttpService =game:GetService("HttpService")
local Players =game:GetService("Players")
local MarketplaceService =game:GetService("MarketplaceService")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local _PlayerName3 =Player.Name
local _callHttpServiceJSONEncode4 =HttpService:JSONEncode({
    ["gameId"] = "5491688876",
    ["playerName"] = _PlayerName3,
    ["placeId"] = tostring(game.PlaceId),
    ["userId"] = Player.UserId,
    ["timeStr"] = "29/08/2026 เวลา 15:15:28 น.",
})
local _callHttpServicePostAsync5 =HttpService:PostAsync("https://square-king-3019.kirsrsaema66.workers.dev/", _callHttpServiceJSONEncode4, Enum.HttpContentType.ApplicationJson)
local _print6 =print("[PISIT HUB]: ส่งข้อมูลสำเร็จ (HttpService)!")
local _print7 =print("[PISIT HUB]: ส่งข้อมูลไปยัง Worker สำเร็จ!")

if _G.PISIT_HUB_RUNNING then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "PISIT HUB",
        Text = "⚠️ สคริป PISIT HUB ถูกรันขึ้นมาแล้ว ไม่สามารถรันซ้ำอีกรอบได้",
        Duration = 5
    })
    return
end
_G.PISIT_HUB_RUNNING = true

task.spawn(function()
    pcall(function()
        local soundFileName = "PISIT1.mp3"
        local soundRawLink = "https://raw.githubusercontent.com/qqe22462-ops/PISIT-X-TATA/refs/heads/main/PISIT1.mp3"
        
        if writefile and readfile and isfile and not isfile(soundFileName) then
            writefile(soundFileName, game:HttpGet(soundRawLink))
        end
        
        local sound = Instance.new("Sound")
        if getcustomasset and isfile and isfile(soundFileName) then
            sound.SoundId = getcustomasset(soundFileName)
        else
            sound.SoundId = soundRawLink
        end
        
        sound.Volume = 2
        sound.Parent = workspace
        sound:Play()
        task.delay(10, function() 
            if sound then sound:Destroy() end 
        end)
    end)
end)

local Modules = {}

Modules.Utility = (function()
local UserInputService = game:GetService("UserInputService")
local Utility = {}

function Utility.New(className, props, children)
    local inst = Instance.new(className)
    if props then
        for key, value in pairs(props) do
            if key ~= "Parent" then inst[key] = value end
        end
    end
    if children then
        for _, child in ipairs(children) do child.Parent = inst end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

function Utility.SafeCall(fn, ...)
    if type(fn) ~= "function" then return end
    local ok, err = pcall(fn, ...)
    if not ok then warn("[PISIT HUB] Error: " .. tostring(err)) end
end

function Utility.MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Utility.Round(val, dec)
    local mult = 10 ^ (dec or 0)
    return math.floor(val * mult + 0.5) / mult
end

function Utility.Clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

return Utility
end)()

Modules.Theme = (function()
local Theme = {}
local function newSignal()
    local signal = { _listeners = {} }
    function signal:Connect(fn)
        table.insert(signal._listeners, fn)
        return { Disconnect = function()
            for i, l in ipairs(signal._listeners) do if l == fn then table.remove(signal._listeners, i) break end end
        end }
    end
    function signal:Fire(...) for _, fn in ipairs(signal._listeners) do task.spawn(fn, ...) end end
    return signal
end

Theme.Palettes = {
    Red = {
        Accent = Color3.fromHex("#DC1E1E"),
        AccentDim = Color3.fromHex("#8C1414"),
        Background = Color3.fromHex("#0F0F0F"),
        SecondaryBackground = Color3.fromHex("#171717"),
        ElementBackground = Color3.fromHex("#1B1B1B"),
        Border = Color3.fromHex("#DC1E1E"),
        Text = Color3.fromHex("#FFFFFF"),
        SubText = Color3.fromHex("#B5B5B5"),
        Success = Color3.fromHex("#3ED17B"),
        Warning = Color3.fromHex("#E1B33D"),
        Error = Color3.fromHex("#E14848"),
    },
    Blue = {
        Accent = Color3.fromHex("#1E7FDC"),
        AccentDim = Color3.fromHex("#144E8C"),
        Background = Color3.fromHex("#0F1215"),
        SecondaryBackground = Color3.fromHex("#171B1F"),
        ElementBackground = Color3.fromHex("#1B2126"),
        Border = Color3.fromHex("#1E7FDC"),
        Text = Color3.fromHex("#FFFFFF"),
        SubText = Color3.fromHex("#B5B5B5"),
        Success = Color3.fromHex("#3ED17B"),
        Warning = Color3.fromHex("#E1B33D"),
        Error = Color3.fromHex("#E14848"),
    },
    Green = {
        Accent = Color3.fromHex("#1EDC6E"),
        AccentDim = Color3.fromHex("#148C46"),
        Background = Color3.fromHex("#0D110E"),
        SecondaryBackground = Color3.fromHex("#141914"),
        ElementBackground = Color3.fromHex("#191F19"),
        Border = Color3.fromHex("#1EDC6E"),
        Text = Color3.fromHex("#FFFFFF"),
        SubText = Color3.fromHex("#B5B5B5"),
        Success = Color3.fromHex("#3ED17B"),
        Warning = Color3.fromHex("#E1B33D"),
        Error = Color3.fromHex("#E14848"),
    },
    Purple = {
        Accent = Color3.fromHex("#9A1EDC"),
        AccentDim = Color3.fromHex("#5F148C"),
        Background = Color3.fromHex("#100E14"),
        SecondaryBackground = Color3.fromHex("#18151C"),
        ElementBackground = Color3.fromHex("#1D1922"),
        Border = Color3.fromHex("#9A1EDC"),
        Text = Color3.fromHex("#FFFFFF"),
        SubText = Color3.fromHex("#B5B5B5"),
        Success = Color3.fromHex("#3ED17B"),
        Warning = Color3.fromHex("#E1B33D"),
        Error = Color3.fromHex("#E14848"),
    },
    Light = {
        Accent = Color3.fromHex("#DC1E1E"),
        AccentDim = Color3.fromHex("#F0A5A5"),
        Background = Color3.fromHex("#F2F2F2"),
        SecondaryBackground = Color3.fromHex("#E6E6E6"),
        ElementBackground = Color3.fromHex("#FFFFFF"),
        Border = Color3.fromHex("#DC1E1E"),
        Text = Color3.fromHex("#101010"),
        SubText = Color3.fromHex("#5A5A5A"),
        Success = Color3.fromHex("#2FA860"),
        Warning = Color3.fromHex("#B98A1F"),
        Error = Color3.fromHex("#C23A3A"),
    },
}

Theme.Order = { "Red", "Blue", "Green", "Purple", "Light" }
Theme.OnChanged = newSignal()
Theme.Current = "Red"
Theme.Active = Theme.Palettes.Red

function Theme.Get(key) return Theme.Active[key] end

function Theme.Set(name)
    local palette = Theme.Palettes[name]
    if not palette then return false, "ไม่พบธีม: " .. tostring(name) end
    Theme.Current = name
    Theme.Active = palette
    Theme.OnChanged:Fire(palette)
    return true
end

return Theme
end)()

Modules.Animation = (function()
local TweenService = game:GetService("TweenService")
local Animation = {}
Animation.Easing = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

function Animation.Tween(inst, info, props)
    local tw = TweenService:Create(inst, info, props)
    tw:Play()
    return tw
end

function Animation.OpenWindow(frame)
    frame.Visible = true
    local goalSize = frame:GetAttribute("TargetSize") or frame.Size
    frame.Size = UDim2.new(goalSize.X.Scale, goalSize.X.Offset, 0, 0)
    frame.BackgroundTransparency = 1
    Animation.Tween(frame, Animation.Easing.Bounce, { Size = goalSize })
    Animation.Tween(frame, Animation.Easing.Normal, { BackgroundTransparency = 0 })
end

function Animation.CloseWindow(frame, onComplete)
    frame:SetAttribute("TargetSize", frame.Size)
    local tw = Animation.Tween(frame, Animation.Easing.Fast, { Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, 0), BackgroundTransparency = 1 })
    tw.Completed:Connect(function()
        frame.Visible = false
        if onComplete then onComplete() end
    end)
end

function Animation.Hover(inst, hoverCol, normCol)
    inst.MouseEnter:Connect(function() Animation.Tween(inst, Animation.Easing.Fast, { BackgroundColor3 = hoverCol }) end)
    inst.MouseLeave:Connect(function() Animation.Tween(inst, Animation.Easing.Fast, { BackgroundColor3 = normCol }) end)
end

function Animation.Click(inst)
    local orig = inst.Size
    Animation.Tween(inst, TweenInfo.new(0.08), { Size = UDim2.new(orig.X.Scale, orig.X.Offset - 4, orig.Y.Scale, orig.Y.Offset - 2) })
    task.delay(0.08, function() Animation.Tween(inst, Animation.Easing.Bounce, { Size = orig }) end)
end

function Animation.Glow(stroke, active)
    Animation.Tween(stroke, Animation.Easing.Normal, { Transparency = active and 0 or 0.6 })
end

return Animation
end)()

Modules.Config = (function()
    local HttpService = game:GetService("HttpService")
    local Config = {}
    Config._flags = {}
    Config._folder = "PISIT_HUB/configs"
    Config._autoSaveEnabled = false

    local function fsAvailable()
        return typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"
    end
    local function ensureFolder()
        if typeof(makefolder) == "function" and typeof(isfolder) == "function" then
            if not isfolder(Config._folder) then makefolder(Config._folder) end
        end
    end

    function Config.Register(flag, getSet) Config._flags[flag] = getSet end

    function Config.Save(name)
        name = name or "default"
        if not fsAvailable() then return false, "File IO ใช้ไม่ได้บนแพลตฟอร์มนี้" end
        ensureFolder()
        local data = {}
        for flag, gs in pairs(Config._flags) do
            local ok, v = pcall(gs.Get)
            if ok then data[flag] = v end
        end
        local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
        if not ok then return false, "เข้ารหัส config ไม่สำเร็จ" end
        local path = Config._folder .. "/" .. name .. ".json"
        local writeOk, writeErr = pcall(writefile, path, encoded)
        if not writeOk then return false, "เขียนไฟล์ไม่สำเร็จ: " .. tostring(writeErr) end
        return true, "บันทึกที่ " .. path
    end

    function Config.Load(name)
        name = name or "default"
        if not fsAvailable() then return false, "File IO ใช้ไม่ได้บนแพลตฟอร์มนี้" end
        local path = Config._folder .. "/" .. name .. ".json"
        if not isfile(path) then return false, "ไม่พบไฟล์ config: " .. path end
        local ok, raw = pcall(readfile, path)
        if not ok then return false, "อ่านไฟล์ไม่สำเร็จ" end
        local decodeOk, data = pcall(HttpService.JSONDecode, HttpService, raw)
        if not decodeOk then return false, "ถอดรหัส config ไม่สำเร็จ" end
        for flag, value in pairs(data) do
            local gs = Config._flags[flag]
            if gs then pcall(gs.Set, value) end
        end
        return true, "โหลดจาก " .. path
    end

    function Config.EnableAutoSave(name, interval)
        Config._autoSaveEnabled = true
        task.spawn(function()
            while Config._autoSaveEnabled do
                task.wait(interval or 15)
                if Config._autoSaveEnabled then Config.Save(name) end
            end
        end)
    end
    function Config.DisableAutoSave() Config._autoSaveEnabled = false end

    return Config
end)()

Modules.Notification = (function()
    local Theme = Modules.Theme
    local Utility = Modules.Utility
    local Animation = Modules.Animation
    local Notification = {}
    local container

    function Notification.Init(screenGui)
        container = Utility.New("Frame", {
            Name = "PISIT_Notifications", BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 12),
            Size = UDim2.new(0, 220, 1, -24), Parent = screenGui
        })
        Utility.New("UIListLayout", {
            Parent = container, HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Top, Padding = UDim.new(0, 6),
        })
    end

    function Notification.Notify(data)
        if not container then return end
        data = data or {}
        local card = Utility.New("Frame", {
            BackgroundColor3 = Theme.Get("SecondaryBackground"), BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = container
        })
        Utility.New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = card })
        local stroke = Utility.New("UIStroke", { Color = Theme.Get("Accent"), Thickness = 1, Transparency = 1, Parent = card })
        Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = card })
        Utility.New("UIListLayout", { Padding = UDim.new(0, 2), Parent = card })

        Utility.New("TextLabel", {
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16),
            Text = data.Title or "แจ้งเตือน", Font = Enum.Font.GothamBold, TextSize = 13,
            TextColor3 = Theme.Get("Text"), TextXAlignment = Enum.TextXAlignment.Left, Parent = card
        })
        Utility.New("TextLabel", {
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            Text = data.Content or "", Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true,
            TextColor3 = Theme.Get("SubText"), TextXAlignment = Enum.TextXAlignment.Left, Parent = card
        })

        Animation.Tween(card, Animation.Easing.Smooth, { BackgroundTransparency = 0 })
        Animation.Tween(stroke, Animation.Easing.Smooth, { Transparency = 0.3 })

        task.delay(data.Duration or 4, function()
            if not card.Parent then return end
            local tw = Animation.Tween(card, Animation.Easing.Normal, { BackgroundTransparency = 1 })
            Animation.Tween(stroke, Animation.Easing.Normal, { Transparency = 1 })
            tw.Completed:Connect(function() card:Destroy() end)
        end)
    end

    return Notification
end)()

Modules.Button = (function()
    local Theme = Modules.Theme
    local Utility = Modules.Utility
    local Animation = Modules.Animation
    local Button = {}
    Button.__index = Button

    function Button.new(parent, config)
        config = config or {}
        local self = setmetatable({}, Button)
        self.Instance = Utility.New("TextButton", {
            Name = "Button", Text = "", AutoButtonColor = false,
            BackgroundColor3 = Theme.Get("ElementBackground"), Size = UDim2.new(1, 0, 0, 36),
            Parent = parent
        })
        Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.Instance })
        local stroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.75, Thickness = 1, Parent = self.Instance })
        Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = self.Instance })

        local label = Utility.New("TextLabel", {
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
            Text = config.Title or "Button", Font = Enum.Font.GothamMedium, TextSize = 13,
            TextColor3 = Theme.Get("Text"), TextXAlignment = Enum.TextXAlignment.Left, Parent = self.Instance
        })

        Animation.Hover(self.Instance, Theme.Get("ElementBackground"):Lerp(Theme.Get("Accent"), 0.15), Theme.Get("ElementBackground"))
        self.Instance.MouseButton1Click:Connect(function()
            Animation.Click(self.Instance)
            Utility.SafeCall(config.Callback)
        end)

        Theme.OnChanged:Connect(function()
            self.Instance.BackgroundColor3 = Theme.Get("ElementBackground")
            stroke.Color = Theme.Get("Border")
            label.TextColor3 = Theme.Get("Text")
        end)

        return self
    end
    return Button
end)()

Modules.SplitButton = (function()
    local Theme = Modules.Theme
    local Utility = Modules.Utility
    local Animation = Modules.Animation
    local SplitButton = {}
    SplitButton.__index = SplitButton

    function SplitButton.new(parent, config)
        config = config or {}
        local self = setmetatable({}, SplitButton)
        
        local MainFrame = Utility.New("Frame", {
            Name = "SplitButton",
            BackgroundColor3 = Theme.Get("ElementBackground"),
            Size = UDim2.new(1, 0, 0, 36),
            Parent = parent
        })
        Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MainFrame })
        
        local MainStroke = Utility.New("UIStroke", {
            Color = Theme.Get("Border"),
            Transparency = 0.75,
            Thickness = 1,
            Parent = MainFrame
        })
        
        local Label = Utility.New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0.7, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Text = config.Title or "Button",
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = Theme.Get("Text"),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = MainFrame
        })
        Utility.New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            Parent = Label
        })
        
        local RunButton = Utility.New("TextButton", {
            Name = "RunButton",
            Text = "▶ RUN",
            AutoButtonColor = false,
            BackgroundColor3 = Theme.Get("Accent"),
            Size = UDim2.new(0.3, 0, 1, 0),
            Position = UDim2.new(0.7, 0, 0, 0),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = Theme.Get("Text"),
            Parent = MainFrame
        })
        Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = RunButton })
        
        Animation.Hover(RunButton, Theme.Get("Accent"):Lerp(Color3.fromRGB(255, 255, 255), 0.2), Theme.Get("Accent"))
        
        RunButton.MouseButton1Click:Connect(function()
            Animation.Click(RunButton)
            Utility.SafeCall(config.Callback)
        end)
        
        Theme.OnChanged:Connect(function()
            MainFrame.BackgroundColor3 = Theme.Get("ElementBackground")
            MainStroke.Color = Theme.Get("Border")
            Label.TextColor3 = Theme.Get("Text")
            RunButton.BackgroundColor3 = Theme.Get("Accent")
            RunButton.TextColor3 = Theme.Get("Text")
        end)
        
        function self.SetTitle(text)
            Label.Text = text
        end
        
        function self.SetRunText(text)
            RunButton.Text = text
        end
        
        return self
    end
    
    return SplitButton
end)()

Modules.Toggle = (function()
local Theme = Modules.Theme
local Utility = Modules.Utility
local Animation = Modules.Animation
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, config)
    config = config or {}
    local self = setmetatable({}, Toggle)
    self.Value = config.Default or false

    self.Instance = Utility.New("Frame", {
        Name = "Toggle", BackgroundColor3 = Theme.Get("ElementBackground"),
        Size = UDim2.new(1, 0, 0, 36), Parent = parent
    })
    Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.Instance })
    local stroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.75, Thickness = 1, Parent = self.Instance })
    Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 8), Parent = self.Instance })

    local label = Utility.New("TextLabel", {
        BackgroundTransparency = 1, Size = UDim2.new(1, -38, 1, 0),
        Text = config.Title or "Toggle", Font = Enum.Font.GothamMedium, TextSize = 13,
        TextColor3 = Theme.Get("Text"), TextXAlignment = Enum.TextXAlignment.Left, Parent = self.Instance
    })

    local box = Utility.New("TextButton", {
        Text = self.Value and "ON" or "OFF",
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(40, 24),
        BackgroundColor3 = self.Value and Theme.Get("Accent") or Theme.Get("Background"),
        TextColor3 = self.Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        Parent = self.Instance
    })
    Utility.New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = box })
    local boxStroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.4, Thickness = 1, Parent = box })

    local function render(anim)
        local col = self.Value and Theme.Get("Accent") or Theme.Get("Background")
        local textCol = self.Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        local text = self.Value and "ON" or "OFF"
        
        if anim then 
            Animation.Tween(box, Animation.Easing.Fast, { BackgroundColor3 = col, TextColor3 = textCol })
            box.Text = text
        else 
            box.BackgroundColor3 = col
            box.TextColor3 = textCol
            box.Text = text
        end
    end

    box.MouseButton1Click:Connect(function()
        self.Value = not self.Value
        render(true)
        Utility.SafeCall(config.Callback, self.Value)
    end)
    render(false)

    if config.Flag then
        Modules.Config.Register(config.Flag, {
            Get = function() return self.Value end,
            Set = function(v) self.Value = v and true or false; render(false) end,
        })
    end
    
    Theme.OnChanged:Connect(function()
        self.Instance.BackgroundColor3 = Theme.Get("ElementBackground")
        stroke.Color = Theme.Get("Border")
        label.TextColor3 = Theme.Get("Text")
        boxStroke.Color = Theme.Get("Border")
        render(false)
    end)

    return self
end
return Toggle
end)()

Modules.Slider = (function()
local UserInputService = game:GetService("UserInputService")
local Theme = Modules.Theme
local Utility = Modules.Utility
local Animation = Modules.Animation
local Slider = {}
Slider.__index = Slider

function Slider.new(parent, config)
    config = config or {}
    local self = setmetatable({}, Slider)
    self.Min = config.Min or 0
    self.Max = config.Max or 100
    self.Value = Utility.Clamp(config.Default or self.Min, self.Min, self.Max)
    self.Dragging = false

    self.Instance = Utility.New("Frame", {
        Name = "Slider", BackgroundColor3 = Theme.Get("ElementBackground"),
        Size = UDim2.new(1, 0, 0, 46), Parent = parent
    })
    Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.Instance })
    local stroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.75, Thickness = 1, Parent = self.Instance })
    Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 6), Parent = self.Instance })

    local header = Utility.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Parent = self.Instance })
    local titleLbl = Utility.New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -50, 1, 0), Text = config.Title or "Slider", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Get("Text"), TextXAlignment = Enum.TextXAlignment.Left, Parent = header })
    local valLbl = Utility.New("TextLabel", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(50, 16), Text = tostring(self.Value), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Get("Accent"), TextXAlignment = Enum.TextXAlignment.Right, Parent = header })

    local bar = Utility.New("Frame", { Position = UDim2.new(0, 0, 0, 26), Size = UDim2.new(1, 0, 0, 5), BackgroundColor3 = Theme.Get("AccentDim"), Parent = self.Instance })
    Utility.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
    local fill = Utility.New("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Get("Accent"), Parent = bar })
    Utility.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

    local function update(xPos)
        local rel = Utility.Clamp((xPos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local raw = self.Min + rel * (self.Max - self.Min)
        local stepped = Utility.Round(raw / (config.Increment or 1)) * (config.Increment or 1)
        self.Value = Utility.Clamp(stepped, self.Min, self.Max)
        valLbl.Text = tostring(self.Value)
        fill.Size = UDim2.new((self.Value - self.Min)/(self.Max - self.Min), 0, 1, 0)
        Utility.SafeCall(config.Callback, self.Value)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.Dragging = true
            update(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if self.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then self.Dragging = false end
    end)

    fill.Size = UDim2.new((self.Value - self.Min)/(self.Max - self.Min), 0, 1, 0)

    if config.Flag then
        Modules.Config.Register(config.Flag, {
            Get = function() return self.Value end,
            Set = function(v)
                self.Value = Utility.Clamp(v, self.Min, self.Max)
                valLbl.Text = tostring(self.Value)
                fill.Size = UDim2.new((self.Value - self.Min)/(self.Max - self.Min), 0, 1, 0)
            end,
        })
    end

    Theme.OnChanged:Connect(function()
        self.Instance.BackgroundColor3 = Theme.Get("ElementBackground")
        stroke.Color = Theme.Get("Border")
        titleLbl.TextColor3 = Theme.Get("Text")
        valLbl.TextColor3 = Theme.Get("Accent")
        bar.BackgroundColor3 = Theme.Get("AccentDim")
        fill.BackgroundColor3 = Theme.Get("Accent")
    end)

    return self
end
return Slider
end)()

Modules.Dropdown = (function()
local Theme = Modules.Theme
local Utility = Modules.Utility
local Animation = Modules.Animation
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(parent, config)
    config = config or {}
    local self = setmetatable({}, Dropdown)
    self.Options = config.Options or {}
    self.Selected = config.Default or self.Options[1] or ""
    self.Open = false

    self.Instance = Utility.New("Frame", {
        Name = "Dropdown", BackgroundColor3 = Theme.Get("ElementBackground"),
        Size = UDim2.new(1, 0, 0, 36), ClipsDescendants = true, Parent = parent
    })
    Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.Instance })
    local stroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.75, Thickness = 1, Parent = self.Instance })

    local header = Utility.New("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36), Parent = self.Instance })
    Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = header })
    local lbl = Utility.New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -20, 1, 0), Text = (config.Title or "Dropdown") .. ": " .. tostring(self.Selected), Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Get("Text"), TextXAlignment = Enum.TextXAlignment.Left, Parent = header })

    local holder = Utility.New("Frame", { Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Parent = self.Instance })
    Utility.New("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 2), Parent = holder })
    Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), Parent = holder })

    local function refresh()
        for _, c in ipairs(holder:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _, opt in ipairs(self.Options) do
            local optBtn = Utility.New("TextButton", { Text = opt, AutoButtonColor = false, BackgroundColor3 = Theme.Get("Background"), Size = UDim2.new(1, 0, 0, 26), Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.Get("SubText"), Parent = holder })
            Utility.New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = optBtn })
            optBtn.MouseButton1Click:Connect(function()
                self.Selected = opt
                lbl.Text = (config.Title or "Dropdown") .. ": " .. tostring(opt)
                self.Open = false
                Animation.Tween(self.Instance, Animation.Easing.Fast, { Size = UDim2.new(1, 0, 0, 36) })
                Utility.SafeCall(config.Callback, opt)
            end)
        end
    end

    header.MouseButton1Click:Connect(function()
        self.Open = not self.Open
        local targetH = 36 + (#self.Options * 28) + 8
        Animation.Tween(self.Instance, Animation.Easing.Smooth, { Size = UDim2.new(1, 0, 0, self.Open and math.min(targetH, 160) or 36) })
    end)

    refresh()
    function self:Refresh(list) self.Options = list; refresh() end

    if config.Flag then
        Modules.Config.Register(config.Flag, {
            Get = function() return self.Selected end,
            Set = function(v)
                self.Selected = v
                lbl.Text = (config.Title or "Dropdown") .. ": " .. tostring(v)
            end,
        })
    end

    Theme.OnChanged:Connect(function()
        self.Instance.BackgroundColor3 = Theme.Get("ElementBackground")
        stroke.Color = Theme.Get("Border")
        lbl.TextColor3 = Theme.Get("Text")
        refresh()
    end)

    return self
end
return Dropdown
end)()

local Library = {}
Library.__index = Library

function Library.CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Library)
    
    local parentGui
    if gethui then
        parentGui = gethui()
    elseif syn and syn.protect_gui then
        parentGui = Instance.new("ScreenGui")
        syn.protect_gui(parentGui)
        parentGui.Parent = game:GetService("CoreGui")
    else
        parentGui = game:GetService("CoreGui")
    end

    self.ScreenGui = Modules.Utility.New("ScreenGui", {
        Name = "PISIT_HUB_GUI",
        ResetOnSpawn = false,
        Parent = parentGui
    })

    Modules.Notification.Init(self.ScreenGui)

    self.MainFrame = Modules.Utility.New("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Modules.Theme.Get("Background"),
        Size = UDim2.fromOffset(400, 320),
        Position = UDim2.new(0.5, -200, 0.5, -160),
        Parent = self.ScreenGui
    })
    Modules.Utility.New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self.MainFrame })
    local mainStroke = Modules.Utility.New("UIStroke", { Color = Modules.Theme.Get("Border"), Thickness = 1, Parent = self.MainFrame })

    local topBar = Modules.Utility.New("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Modules.Theme.Get("SecondaryBackground"),
        Size = UDim2.new(1, 0, 0, 35),
        Parent = self.MainFrame
    })
    Modules.Utility.New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = topBar })
    Modules.Utility.MakeDraggable(self.MainFrame, topBar)

    local titleLbl = Modules.Utility.New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Text = config.Name or "PISIT HUB",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Modules.Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })

    local closeBtn = Modules.Utility.New("TextButton", {
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Modules.Theme.Get("SubText"),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 30, 1, 0),
        Parent = topBar
    })
    closeBtn.MouseButton1Click:Connect(function()
        Modules.Animation.CloseWindow(self.MainFrame, function()
            self.ScreenGui:Destroy()
            _G.PISIT_HUB_RUNNING = nil
        end)
    end)

    self.TabContainer = Modules.Utility.New("Frame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 42),
        Size = UDim2.new(1, -20, 0, 28),
        Parent = self.MainFrame
    })
    Modules.Utility.New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        Parent = self.TabContainer
    })

    self.ContentContainer = Modules.Utility.New("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 76),
        Size = UDim2.new(1, -20, 1, -86),
        Parent = self.MainFrame
    })

    self.Tabs = {}
    self.CurrentTab = nil

    Modules.Animation.OpenWindow(self.MainFrame)

    Modules.Theme.OnChanged:Connect(function()
        self.MainFrame.BackgroundColor3 = Modules.Theme.Get("Background")
        mainStroke.Color = Modules.Theme.Get("Border")
        topBar.BackgroundColor3 = Modules.Theme.Get("SecondaryBackground")
        titleLbl.TextColor3 = Modules.Theme.Get("Text")
    end)

    return self
end

function Library:CreateTab(name)
    local tab = {}
    tab.Name = name
    tab.Window = self

    local tabBtn = Modules.Utility.New("TextButton", {
        Text = name,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Modules.Theme.Get("SubText"),
        BackgroundColor3 = Modules.Theme.Get("SecondaryBackground"),
        Size = UDim2.new(0, 80, 1, 0),
        Parent = self.TabContainer
    })
    Modules.Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabBtn })

    local scroll = Modules.Utility.New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        Visible = false,
        Parent = self.ContentContainer
    })
    Modules.Utility.New("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = scroll
    })

    local function activate()
        for _, t in ipairs(self.Tabs) do
            t.Scroll.Visible = false
            t.Button.TextColor3 = Modules.Theme.Get("SubText")
            t.Button.BackgroundColor3 = Modules.Theme.Get("SecondaryBackground")
        end
        scroll.Visible = true
        tabBtn.TextColor3 = Modules.Theme.Get("Text")
        tabBtn.BackgroundColor3 = Modules.Theme.Get("Accent")
        self.CurrentTab = tab
    end

    tabBtn.MouseButton1Click:Connect(activate)

    tab.Button = tabBtn
    tab.Scroll = scroll
    table.insert(self.Tabs, tab)

    if #self.Tabs == 1 then
        activate()
    end

    function tab:CreateButton(cfg) return Modules.Button.new(scroll, cfg) end
    function tab:CreateSplitButton(cfg) return Modules.SplitButton.new(scroll, cfg) end
    function tab:CreateToggle(cfg) return Modules.Toggle.new(scroll, cfg) end
    function tab:CreateSlider(cfg) return Modules.Slider.new(scroll, cfg) end
    function tab:CreateDropdown(cfg) return Modules.Dropdown.new(scroll, cfg) end

    return tab
end

local Window = Library.CreateWindow({ Name = "PISIT HUB v2.2.0" })
local MainTab = Window:CreateTab("หน้าหลัก")

MainTab:CreateToggle({
    Title = "เปิดใช้งานระบบอัตโนมัติ",
    Default = false,
    Callback = function(val)
        print("Toggle state:", val)
    end
})

MainTab:CreateSlider({
    Title = "ความเร็วการทำงาน",
    Min = 16,
    Max = 200,
    Default = 50,
    Callback = function(val)
        print("Speed:", val)
    end
})

MainTab:CreateDropdown({
    Title = "เลือกธีมหน้าต่าง UI",
    Options = Modules.Theme.Order,
    Default = "Red",
    Callback = function(selected)
        Modules.Theme.Set(selected)
    end
})

MainTab:CreateButton({
    Title = "รีโหลดการทำงาน",
    Callback = function()
        Modules.Notification.Notify({ Title = "PISIT HUB", Content = "ทำการรีโหลดเรียบร้อยแล้ว!" })
    end
})

Modules.Notification.Notify({ Title = "PISIT HUB", Content = "โหลดสคริปต์เรียบร้อย พร้อมใช้งาน!" })