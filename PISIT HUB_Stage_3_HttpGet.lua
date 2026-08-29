--[[
	PISIT HUB | Complete Single-File Bundle v2.2.0 (Rayfield Style with Toggle Pill)
	--------------------------------------------------------------------
	Includes: Window, Tabs, Sections, Buttons, Toggles, Sliders, Dropdowns,
	Textbox, Paragraph, Label, Keybind, ColorPicker, Divider, Image, Minimize
	(with floating toggle button), Mobile-optimized 400x320 default window sizing,
	Config Save/Load + AutoSave, Notification, and LIVE Theme Switching
	(Red / Blue / Green / Purple / Light) via Library:SetTheme("Red") or
	Section:CreateThemeDropdown().
--]]


if _G.PISIT_HUB_RUNNING then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "PISIT HUB",
        Text = "⚠️ สคริป PISIT HUB ถูกรันขึ้นมาแล้ว ไม่สามารถรันซ้ำอีกรอบได้",
        Duration = 5
    })
    return
end
_G.PISIT_HUB_RUNNING = true

-- 🔊 ระบบเสียงเปิดตัว PISIT HUB (เล่นอัตโนมัติครั้งเดียว)
-- ====================================================================
task.spawn(function()
    pcall(function()
        local soundFileName = "PISIT1.mp3"
        local soundRawLink = "https://raw.githubusercontent.com/qqe22462-ops/PISIT-X-TATA/refs/heads/main/PISIT1.mp3"
        
        -- ถ้ายังไม่มีไฟล์ ให้โหลดจากลิงค์
        if writefile and readfile and isfile and not isfile(soundFileName) then
            writefile(soundFileName, game:HttpGet(soundRawLink))
        end
        
        local sound = Instance.new("Sound")
        -- ใช้ไฟล์ในเครื่องถ้ามี หรือใช้ลิงค์สด
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

-- ============================================
-- 🔥 Modules.Button 
-- ============================================
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

-- ============================================
-- 🔥 Modules.SplitButton (ซ้ายข้อความ / ขวา RUN)
-- ============================================
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

	-- ปุ่ม Toggle (box) แสดง ON / OFF
	local box = Utility.New("TextButton", {
		Text = self.Value and "OFF" or "ON",
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

	-- ฟังก์ชัน render
	local function render(anim)
		local col = self.Value and Theme.Get("Accent") or Theme.Get("Background")
		local textCol = self.Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
		local text = self.Value and "OFF" or "ON"
		
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

Modules.ColorPicker = (function()
local UserInputService = game:GetService("UserInputService")
local Theme = Modules.Theme
local Utility = Modules.Utility
local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(parent, config)
	config = config or {}
	local self = setmetatable({}, ColorPicker)
	self.Value = config.Default or Color3.fromRGB(220, 30, 30)

	self.Instance = Utility.New("Frame", {
		Name = "ColorPicker", BackgroundColor3 = Theme.Get("ElementBackground"),
		Size = UDim2.new(1, 0, 0, 100), Parent = parent
	})
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.Instance })
	local stroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.75, Thickness = 1, Parent = self.Instance })
	Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 6), Parent = self.Instance })

	local header = Utility.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Parent = self.Instance })
	local titleLbl = Utility.New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -30, 1, 0), Text = config.Title or "Color Picker", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.Get("Text"), TextXAlignment = Enum.TextXAlignment.Left, Parent = header })
	local preview = Utility.New("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(20, 20), BackgroundColor3 = self.Value, Parent = header })
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = preview })
	local previewStroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Thickness = 1, Parent = preview })

	local r, g, b = math.floor(self.Value.R * 255), math.floor(self.Value.G * 255), math.floor(self.Value.B * 255)
	local fills = {}

	local function makeSlider(name, val, col)
		local row = Utility.New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Parent = self.Instance })
		Utility.New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromOffset(15, 20), Text = name, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = col, Parent = row })
		local bar = Utility.New("Frame", { Position = UDim2.new(0, 18, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(1, -18, 0, 4), BackgroundColor3 = Theme.Get("AccentDim"), Parent = row })
		Utility.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
		local fill = Utility.New("Frame", { Size = UDim2.new(val/255, 0, 1, 0), BackgroundColor3 = col, Parent = bar })
		Utility.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
		fills[name] = { bar = bar, fill = fill }

		local dragging = false
		bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local rel = Utility.Clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
				fill.Size = UDim2.new(rel, 0, 1, 0)
				if name == "R" then r = math.floor(rel * 255 + 0.5)
				elseif name == "G" then g = math.floor(rel * 255 + 0.5)
				elseif name == "B" then b = math.floor(rel * 255 + 0.5) end
				self.Value = Color3.fromRGB(r, g, b)
				preview.BackgroundColor3 = self.Value
				Utility.SafeCall(config.Callback, self.Value)
			end
		end)
	end

	makeSlider("R", r, Color3.fromRGB(255, 80, 80))
	makeSlider("G", g, Color3.fromRGB(80, 255, 100))
	makeSlider("B", b, Color3.fromRGB(80, 150, 255))

	Theme.OnChanged:Connect(function()
		self.Instance.BackgroundColor3 = Theme.Get("ElementBackground")
		stroke.Color = Theme.Get("Border")
		titleLbl.TextColor3 = Theme.Get("Text")
		previewStroke.Color = Theme.Get("Border")
		for _, s in pairs(fills) do s.bar.BackgroundColor3 = Theme.Get("AccentDim") end
	end)

	if config.Flag then
		Modules.Config.Register(config.Flag, {
			Get = function() return { r = r, g = g, b = b } end,
			Set = function(v)
				if typeof(v) ~= "table" then return end
				r, g, b = v.r or r, v.g or g, v.b or b
				self.Value = Color3.fromRGB(r, g, b)
				preview.BackgroundColor3 = self.Value
				if fills.R then fills.R.fill.Size = UDim2.new(r/255, 0, 1, 0) end
				if fills.G then fills.G.fill.Size = UDim2.new(g/255, 0, 1, 0) end
				if fills.B then fills.B.fill.Size = UDim2.new(b/255, 0, 1, 0) end
			end,
		})
	end

return self
end
return ColorPicker
end)()

Modules.Textbox = (function()
local Theme = Modules.Theme
local Utility = Modules.Utility
local Textbox = {}
Textbox.__index = Textbox
function Textbox.new(parent, config)
	config = config or {}
	local self = setmetatable({}, Textbox)
	self.Value = config.Default or ""
	self.Instance = Utility.New("Frame", { Name = "Textbox", BackgroundColor3 = Theme.Get("ElementBackground"), Size = UDim2.new(1, 0, 0, 50), Parent = parent })
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.Instance })
	local stroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.75, Thickness = 1, Parent = self.Instance })
	Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 6), Parent = self.Instance })

	local titleLbl = Utility.New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Text = config.Title or "Textbox", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Get("Text"), TextXAlignment = Enum.TextXAlignment.Left, Parent = self.Instance })
	local boxBg = Utility.New("Frame", { Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = Theme.Get("Background"), Parent = self.Instance })
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = boxBg })
	local box = Utility.New("TextBox", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = self.Value, PlaceholderText = config.Placeholder or "Type...", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.Get("Text"), Parent = boxBg })
	box.FocusLost:Connect(function()
		self.Value = box.Text
		Utility.SafeCall(config.Callback, self.Value)
	end)

	Theme.OnChanged:Connect(function()
		self.Instance.BackgroundColor3 = Theme.Get("ElementBackground")
		stroke.Color = Theme.Get("Border")
		titleLbl.TextColor3 = Theme.Get("Text")
		boxBg.BackgroundColor3 = Theme.Get("Background")
		box.TextColor3 = Theme.Get("Text")
	end)

	if config.Flag then
		Modules.Config.Register(config.Flag, {
			Get = function() return self.Value end,
			Set = function(v) self.Value = tostring(v); box.Text = self.Value end,
		})
	end
	
	return self
end
return Textbox
end)()

Modules.Paragraph = (function()
local Theme = Modules.Theme
local Utility = Modules.Utility
local Paragraph = {}
Paragraph.__index = Paragraph
function Paragraph.new(parent, config)
	config = config or {}
	local self = setmetatable({}, Paragraph)
	self.Instance = Utility.New("Frame", { Name = "Paragraph", BackgroundColor3 = Theme.Get("ElementBackground"), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = parent })
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.Instance })
	local stroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.8, Thickness = 1, Parent = self.Instance })
	Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = self.Instance })
	Utility.New("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 4), Parent = self.Instance })

	local titleLbl
	if config.Title and config.Title ~= "" then
		titleLbl = Utility.New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Text = config.Title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Get("Text"), TextXAlignment = Enum.TextXAlignment.Left, Parent = self.Instance })
	end
	local contentLbl = Utility.New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = config.Content or "", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.Get("SubText"), TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = self.Instance })

	Theme.OnChanged:Connect(function()
		self.Instance.BackgroundColor3 = Theme.Get("ElementBackground")
		stroke.Color = Theme.Get("Border")
		if titleLbl then titleLbl.TextColor3 = Theme.Get("Text") end
		contentLbl.TextColor3 = Theme.Get("SubText")
	end)

	return self
end
return Paragraph
end)()

Modules.Label = (function()
local Theme = Modules.Theme
local Utility = Modules.Utility
local Label = {}
Label.__index = Label
function Label.new(parent, config)
	config = config or {}
	local self = setmetatable({}, Label)
	self.Instance = Utility.New("TextLabel", { Name = "Label", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Text = config.Text or "Label", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.Get("SubText"), TextXAlignment = Enum.TextXAlignment.Left, Parent = parent })
	Theme.OnChanged:Connect(function() self.Instance.TextColor3 = Theme.Get("SubText") end)
	return self
end
return Label
end)()

Modules.Section = (function()
local Theme = Modules.Theme
local Utility = Modules.Utility
local Section = {}
Section.__index = Section

function Section.new(parent, config)
	config = config or {}
	local self = setmetatable({}, Section)
	self.Instance = Utility.New("Frame", { Name = "Section", BackgroundColor3 = Theme.Get("SecondaryBackground"), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = parent })
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Instance })
	local stroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.8, Thickness = 1, Parent = self.Instance })
	Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = self.Instance })
	local titleLbl = Utility.New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Text = config.Title or "Section", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Get("Accent"), TextXAlignment = Enum.TextXAlignment.Left, Parent = self.Instance })

	self.Content = Utility.New("Frame", { BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = self.Instance })
	Utility.New("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 6), Parent = self.Content })

	Theme.OnChanged:Connect(function()
		self.Instance.BackgroundColor3 = Theme.Get("SecondaryBackground")
		stroke.Color = Theme.Get("Border")
		titleLbl.TextColor3 = Theme.Get("Accent")
	end)

	return self
end

function Section:CreateButton(cfg) return Modules.Button.new(self.Content, cfg) end
function Section:CreateToggle(cfg) return Modules.Toggle.new(self.Content, cfg) end
function Section:CreateSplitButton(cfg) return Modules.SplitButton.new(self.Content, cfg) end
function Section:CreateSlider(cfg) return Modules.Slider.new(self.Content, cfg) end
function Section:CreateDropdown(cfg) return Modules.Dropdown.new(self.Content, cfg) end
function Section:CreateTextbox(cfg) return Modules.Textbox.new(self.Content, cfg) end
function Section:CreateParagraph(cfg) return Modules.Paragraph.new(self.Content, cfg) end
function Section:CreateLabel(cfg) return Modules.Label.new(self.Content, cfg) end
function Section:CreateColorPicker(cfg) return Modules.ColorPicker.new(self.Content, cfg) end

function Section:CreateDivider()
	local line = Utility.New("Frame", { Name = "Divider", BackgroundColor3 = Theme.Get("Border"), BackgroundTransparency = 0.75, Size = UDim2.new(1, 0, 0, 1), Parent = self.Content })
	Theme.OnChanged:Connect(function() line.BackgroundColor3 = Theme.Get("Border") end)
	return line
end

function Section:CreateImage(cfg)
	cfg = cfg or {}
	local frame = Utility.New("Frame", { Name = "Image", BackgroundColor3 = Theme.Get("ElementBackground"), Size = UDim2.new(1, 0, 0, cfg.Height or 120), ClipsDescendants = true, Parent = self.Content })
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = frame })
	local stroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.75, Thickness = 1, Parent = frame })
	local img = Utility.New("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Image = cfg.Image or "", ScaleType = Enum.ScaleType.Crop, Parent = frame })
	Theme.OnChanged:Connect(function()
		frame.BackgroundColor3 = Theme.Get("ElementBackground")
		stroke.Color = Theme.Get("Border")
	end)
	return { Instance = frame, Image = img }
end

function Section:CreateThemeDropdown(cfg)
	cfg = cfg or {}
	return self:CreateDropdown({
		Title = cfg.Title or "ธีม",
		Options = Theme.Order,
		Default = Theme.Current,
		Callback = function(name) Theme.Set(name) end,
	})
end

function Section:CreateKeybind(cfg)
	cfg = cfg or {}
	local UserInputService = game:GetService("UserInputService")
	local keybind = { Value = cfg.Default or Enum.KeyCode.Unknown, Listening = false }

	local inst = Utility.New("Frame", {
		Name = "Keybind", BackgroundColor3 = Theme.Get("ElementBackground"),
		Size = UDim2.new(1, 0, 0, 36), Parent = self.Content
	})
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = inst })
	Utility.New("UIStroke", { Color = Theme.Get("Border"), Transparency = 0.75, Thickness = 1, Parent = inst })
	Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = inst })

	Utility.New("TextLabel", {
		BackgroundTransparency = 1, Size = UDim2.new(1, -70, 1, 0),
		Text = cfg.Title or "Keybind", Font = Enum.Font.GothamMedium, TextSize = 13,
		TextColor3 = Theme.Get("Text"), TextXAlignment = Enum.TextXAlignment.Left, Parent = inst
	})

	local keyBtn = Utility.New("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(60, 22), BackgroundColor3 = Theme.Get("Background"),
		Text = keybind.Value.Name, Font = Enum.Font.GothamBold, TextSize = 11,
		TextColor3 = Theme.Get("Accent"), AutoButtonColor = false, Parent = inst
	})
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = keyBtn })

	keyBtn.MouseButton1Click:Connect(function()
		keybind.Listening = true
		keyBtn.Text = "..."
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if keybind.Listening and input.UserInputType == Enum.UserInputType.Keyboard then
			keybind.Value = input.KeyCode
			keyBtn.Text = input.KeyCode.Name
			keybind.Listening = false
			return
		end
		if not processed and not keybind.Listening and input.UserInputType == Enum.UserInputType.Keyboard
			and input.KeyCode == keybind.Value then
			Utility.SafeCall(cfg.Callback)
		end
	end)

	if cfg.Flag then
		Modules.Config.Register(cfg.Flag, {
			Get = function() return keybind.Value.Name end,
			Set = function(name)
				local ok, item = pcall(function() return Enum.KeyCode[name] end)
				if ok and item then keybind.Value = item; keyBtn.Text = item.Name end
			end,
		})
	end

	return keybind
end

return Section
end)()

Modules.Tab = (function()
local Theme = Modules.Theme
local Utility = Modules.Utility
local Animation = Modules.Animation
local Tab = {}
Tab.__index = Tab

function Tab.new(window, tabListParent, pageParent, config)
	config = config or {}
	local self = setmetatable({}, Tab)
	self.Window = window

	self.Button = Utility.New("TextButton", { Name = "TabBtn", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), Parent = tabListParent })
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.Button })
	Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = self.Button })

	self.Indicator = Utility.New("Frame", { Size = UDim2.new(0, 2, 0, 14), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Theme.Get("Accent"), BackgroundTransparency = 1, Parent = self.Button })
	Utility.New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.Indicator })

	self.Label = Utility.New("TextLabel", { Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -8, 1, 0), BackgroundTransparency = 1, Text = config.Title or "Tab", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Get("SubText"), TextXAlignment = Enum.TextXAlignment.Left, Parent = self.Button })

	self.Page = Utility.New("ScrollingFrame", { Name = "Page", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, Visible = false, Parent = pageParent })
	Utility.New("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 8), Parent = self.Page })
	Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 2), Parent = self.Page })

	self.Button.MouseButton1Click:Connect(function() self.Window:SelectTab(self) end)

	Theme.OnChanged:Connect(function()
		self.Indicator.BackgroundColor3 = Theme.Get("Accent")
		self.Label.TextColor3 = self.Active and Theme.Get("Text") or Theme.Get("SubText")
	end)

	return self
end

function Tab:CreateSection(cfg) return Modules.Section.new(self.Page, cfg) end

function Tab:SetActive(active)
	self.Active = active
	self.Page.Visible = active
	Animation.Tween(self.Indicator, Animation.Easing.Normal, { BackgroundTransparency = active and 0 or 1 })
	Animation.Tween(self.Label, Animation.Easing.Normal, { TextColor3 = active and Theme.Get("Text") or Theme.Get("SubText") })
end

return Tab
end)()

Modules.Window = (function()
local Players = game:GetService("Players")
local Theme = Modules.Theme
local Utility = Modules.Utility
local Animation = Modules.Animation
local Window = {}
Window.__index = Window

function Window.new(config)
    config = config or {}
    local self = setmetatable({}, Window)
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false

    local coreGui = game:GetService("CoreGui")
    
    self.ScreenGui = Utility.New("ScreenGui", { 
        Name = "PISIT_HUB", 
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        Parent = coreGui
    })

-- ====================================================================
-- 🔥 RESPONSIVE AUTO-SIZE (ปรับขนาดตามอุปกรณ์อัตโนมัติ)
-- ====================================================================
local viewportSize = workspace.CurrentCamera.ViewportSize
local screenWidth = viewportSize.X
local screenHeight = viewportSize.Y

-- ตรวจจับประเภทอุปกรณ์
local isMobile = screenWidth < 600
local isTablet = screenWidth >= 600 and screenWidth < 1024
local isPC = screenWidth >= 1024

-- คำนวณขนาด UI แบบอัตโนมัติ
local uiWidth, uiHeight
if isMobile then
    uiWidth = math.min(screenWidth * 0.85, 380)
    uiHeight = math.min(screenHeight * 0.75, 300)
elseif isTablet then
    uiWidth = math.min(screenWidth * 0.7, 500)
    uiHeight = math.min(screenHeight * 0.7, 400)
else
    uiWidth = config.Width or 420
    uiHeight = config.Height or 340
end

uiWidth = math.round(uiWidth / 10) * 10
uiHeight = math.round(uiHeight / 10) * 10
uiWidth = math.max(uiWidth, 280)
uiHeight = math.max(uiHeight, 200)

self.Main = Utility.New("Frame", { 
    Name = "Main", 
    AnchorPoint = Vector2.new(0.5, 0.5), 
    Position = UDim2.fromScale(0.5, 0.5), 
    Size = UDim2.fromOffset(uiWidth, uiHeight),
    BackgroundColor3 = Theme.Get("Background"), 
    ClipsDescendants = true, 
    Parent = self.ScreenGui 
})
Utility.New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self.Main })
self.MainStroke = Utility.New("UIStroke", { Color = Theme.Get("Border"), Thickness = 1.2, Transparency = 0.2, Parent = self.Main })
	self:_buildTopBar(config.Title or "PISIT HUB")
	self:_buildBody()
	self:_buildTogglePill()
	Modules.Notification.Init(self.ScreenGui)
	Utility.MakeDraggable(self.Main, self.TopBar)
	Animation.OpenWindow(self.Main)

	Theme.OnChanged:Connect(function()
		self.Main.BackgroundColor3 = Theme.Get("Background")
		self.MainStroke.Color = Theme.Get("Border")
		self.TopBar.BackgroundColor3 = Theme.Get("SecondaryBackground")
		self.TitleLabel.TextColor3 = Theme.Get("Accent")
		self.CloseBtn.BackgroundColor3 = Theme.Get("ElementBackground")
		self.CloseBtn.TextColor3 = Theme.Get("Text")
		self.MinBtn.BackgroundColor3 = Theme.Get("ElementBackground")
		self.MinBtn.TextColor3 = Theme.Get("Text")
		self.Sidebar.BackgroundColor3 = Theme.Get("SecondaryBackground")
		-- ปุ่มวงกลม TogglePill (ปรับสีตาม Theme)
		if self.TogglePill and self.PillStroke then
			self.PillStroke.Color = Theme.Get("Accent")
		end
	end)

	return self
end

function Window:_buildTopBar(titleText)
	self.TopBar = Utility.New("Frame", { Name = "TopBar", BackgroundColor3 = Theme.Get("SecondaryBackground"), Size = UDim2.new(1, 0, 0, 40), Parent = self.Main })
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self.TopBar })
	Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 8), Parent = self.TopBar })

	self.TitleLabel = Utility.New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -65, 1, 0), Text = titleText, Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = Theme.Get("Accent"), TextXAlignment = Enum.TextXAlignment.Left, Parent = self.TopBar })

	self.CloseBtn = Utility.New("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(24, 24), BackgroundColor3 = Theme.Get("ElementBackground"), Text = "x", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Get("Text"), AutoButtonColor = false, Parent = self.TopBar })
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 5), Parent = self.CloseBtn })
self.CloseBtn.MouseButton1Click:Connect(function()
    -- ปิด Popup เก่าถ้ามี
    if self.ScreenGui:FindFirstChild("CloseConfirmPopup") then
        self.ScreenGui.CloseConfirmPopup:Destroy()
    end
    
    -- สร้าง Popup สีดำแดง
    local popup = Instance.new("Frame")
    popup.Name = "CloseConfirmPopup"
    popup.Size = UDim2.new(0, 340, 0, 150)
    popup.Position = UDim2.new(0.5, -170, 0.5, -75)
    popup.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    popup.BorderSizePixel = 0
    popup.ZIndex = 9999  -- <<< สำคัญ! ให้อยู่หน้าสุด
    popup.Parent = self.ScreenGui  -- <<< ต้องเป็น ScreenGui ไม่ใช่ Main
    
    local popupCorner = Instance.new("UICorner")
    popupCorner.CornerRadius = UDim.new(0, 12)
    popupCorner.Parent = popup
    
    local popupStroke = Instance.new("UIStroke")
    popupStroke.Color = Color3.fromRGB(220, 30, 50)
    popupStroke.Thickness = 2.5
    popupStroke.Parent = popup
    
    -- ข้อความถาม
    local question = Instance.new("TextLabel")
    question.Size = UDim2.new(1, -20, 0, 44)
    question.Position = UDim2.new(0, 10, 0, 18)
    question.BackgroundTransparency = 1
    question.Text = "⚠️ คุณจะปิดสคริป PISIT HUB หรือไม่?"
    question.TextColor3 = Color3.fromRGB(255, 255, 255)
    question.Font = Enum.Font.GothamBold
    question.TextSize = 16
    question.TextWrapped = true
    question.ZIndex = 9999
    question.Parent = popup
    
    -- ปุ่ม "ใช่" (สีแดง)
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0, 120, 0, 40)
    yesBtn.Position = UDim2.new(0.5, -135, 0, 82)
    yesBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
    yesBtn.BorderSizePixel = 0
    yesBtn.Text = "ใช่ ปิดเลย"
    yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.TextSize = 14
    yesBtn.ZIndex = 9999
    yesBtn.Parent = popup
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 8)
    yesCorner.Parent = yesBtn
    
    -- ปุ่ม "ไม่ใช่" (สีเทา)
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0, 120, 0, 40)
    noBtn.Position = UDim2.new(0.5, 15, 0, 82)
    noBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    noBtn.BorderSizePixel = 0
    noBtn.Text = "ไม่ใช่"
    noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noBtn.Font = Enum.Font.GothamBold
    noBtn.TextSize = 14
    noBtn.ZIndex = 9999
    noBtn.Parent = popup
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 8)
    noCorner.Parent = noBtn
    
    -- เอฟเฟกต์ Hover
    yesBtn.MouseEnter:Connect(function()
        yesBtn.BackgroundColor3 = Color3.fromRGB(230, 40, 40)
    end)
    yesBtn.MouseLeave:Connect(function()
        yesBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
    end)
    
    noBtn.MouseEnter:Connect(function()
        noBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    noBtn.MouseLeave:Connect(function()
        noBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
yesBtn.MouseButton1Click:Connect(function()
    _G.PISIT_HUB_RUNNING = nil
    self.ScreenGui:Destroy()
end)
    
    -- กด "ไม่ใช่" = ปิด Popup
    noBtn.MouseButton1Click:Connect(function()
        popup:Destroy()
    end)
end)

	self.MinBtn = Utility.New("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -28, 0.5, 0), Size = UDim2.fromOffset(24, 24), BackgroundColor3 = Theme.Get("ElementBackground"), Text = "-", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Get("Text"), AutoButtonColor = false, Parent = self.TopBar })
	Utility.New("UICorner", { CornerRadius = UDim.new(0, 5), Parent = self.MinBtn })
	self.MinBtn.MouseButton1Click:Connect(function()
		self.Minimized = true
		Animation.CloseWindow(self.Main, function()
			self.TogglePill.Visible = true
		end)
	end)
end

function Window:_buildBody()
	self.Body = Utility.New("Frame", { Name = "Body", Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 1, -40), BackgroundTransparency = 1, Parent = self.Main })
	self.Sidebar = Utility.New("ScrollingFrame", { Name = "Sidebar", BackgroundColor3 = Theme.Get("SecondaryBackground"), Size = UDim2.new(0, 110, 1, 0), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, Parent = self.Body })
	Utility.New("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 6), Parent = self.Sidebar })
	Utility.New("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 3), Parent = self.Sidebar })

	self.PageContainer = Utility.New("Frame", { Name = "PageContainer", Position = UDim2.new(0, 110, 0, 0), Size = UDim2.new(1, -110, 1, 0), BackgroundTransparency = 1, Parent = self.Body })
end


			function Window:_buildTogglePill()
    -- ====================================================================
    -- 🔥 PISIT HUB - PERFECT TOUCH TOGGLE PILL (PRESS ANIMATION + DRAG)
    -- ====================================================================
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    
    -- ลบปุ่มเก่าถ้ามี
    if self.ScreenGui:FindFirstChild("TogglePill") then
        self.ScreenGui.TogglePill:Destroy()
    end

    self.TogglePill = Instance.new("ImageButton")
    self.TogglePill.Name = "TogglePill"
    self.TogglePill.BackgroundTransparency = 1
    self.TogglePill.BorderSizePixel = 0
    self.TogglePill.ClipsDescendants = false
    self.TogglePill.ZIndex = 10
    self.TogglePill.AutoButtonColor = false
    self.TogglePill.AnchorPoint = Vector2.new(0.5, 0.5)
    self.TogglePill.Position = UDim2.new(0.1, 20, 0.25, 25)
    self.TogglePill.Size = UDim2.fromOffset(54, 54)
    self.TogglePill.Visible = true
    self.TogglePill.Parent = self.ScreenGui
    self.TogglePill.ImageTransparency = 0.05
    self.TogglePill.ScaleType = Enum.ScaleType.Crop

    -- มุมโค้งมน
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.TogglePill

    -- ขอบสีแดง
    self.PillStroke = Instance.new("UIStroke")
    self.PillStroke.Color = Color3.fromRGB(200, 10, 40)
    self.PillStroke.Thickness = 2.5
    self.PillStroke.Parent = self.TogglePill

    -- โหลดรูปภาพ
    task.spawn(function()
        pcall(function()
            local imageUrl = "https://i.postimg.cc/hP39YjVY/logo.png"
            local fileName = "pisit_square_free.png"
            
            if isfile and writefile and readfile and getcustomasset then
                if not isfile(fileName) then
                    local imgData = game:HttpGet(imageUrl)
                    if imgData and #imgData > 0 then
                        writefile(fileName, imgData)
                    end
                end
                if isfile(fileName) then
                    self.TogglePill.Image = getcustomasset(fileName)
                else
                    self.TogglePill.Image = imageUrl
                end
            else
                self.TogglePill.Image = imageUrl
            end
        end)
    end)

    -- ====================================================================
    -- ระบบลากปุ่ม + เอฟเฟคกดยุบตัว
    -- ====================================================================
    local dragging = false
    local activeInput = nil
    local dragStart = nil
    local startPos = nil
    local dragStartPos = Vector2.new(0, 0)
    local isDraggingHappened = false

    local function isInBounds(guiObject, pos)
        local absPos = guiObject.AbsolutePosition
        local absSize = guiObject.AbsoluteSize
        return pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and
               pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
    end

    -- กดคลิกธรรมดา (เปิด/ปิดหน้าต่าง UI)
    self.TogglePill.MouseButton1Click:Connect(function()
        if not isDraggingHappened then
            if self.Main.Visible then
                self.Minimized = true
                Animation.CloseWindow(self.Main)
            else
                self.Minimized = false
                Animation.OpenWindow(self.Main)
            end
        end
    end)

    -- เริ่มจิ้ม
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not dragging and isInBounds(self.TogglePill, input.Position) then
                dragging = true
                activeInput = input
                dragStart = input.Position
                startPos = self.TogglePill.Position
                dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
                isDraggingHappened = false

                TweenService:Create(self.TogglePill, TweenInfo.new(0.1), {Size = UDim2.fromOffset(46, 46)}):Play()
            end
        end
    end)

    -- กำลังลาก
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == activeInput then
            local currentPos = Vector2.new(input.Position.X, input.Position.Y)
            local deltaMove = (currentPos - dragStartPos).Magnitude

            if deltaMove > 5 then
                isDraggingHappened = true
            end

            local delta = input.Position - dragStart
            self.TogglePill.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ปล่อยนิ้ว
    UserInputService.InputEnded:Connect(function(input)
        if input == activeInput then
            dragging = false
            activeInput = nil

            TweenService:Create(self.TogglePill, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(54, 54)}):Play()
        end
    end)

    -- ป้องกันการหาย
    task.spawn(function()
        while self.ScreenGui and self.ScreenGui.Parent do
            task.wait(1)
            if self.TogglePill and self.TogglePill.Parent ~= self.ScreenGui then
                self.TogglePill.Parent = self.ScreenGui
            end
        end
    end)

    print("[PISIT] Perfect Touch TogglePill Loaded! 🔥")
end   -- <<< end เดียวนี้จบ function

-- ❌ ลบ 2 บรรทัดนี้ทิ้ง!!!
-- print("[PISIT] Circle Button Loaded Successfully! 🔥")
-- end

function Window:CreateTab(config)
	local tab = Modules.Tab.new(self, self.Sidebar, self.PageContainer, config)
	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then self:SelectTab(tab) end
	return tab
end

function Window:SelectTab(tab)
	if self.ActiveTab then self.ActiveTab:SetActive(false) end
	self.ActiveTab = tab
	tab:SetActive(true)
end

return Window
end)()

local Library = {}
Library._version = "2.2.0"
function Library:CreateWindow(config) return Modules.Window.new(config) end

function Library:Notify(data) Modules.Notification.Notify(data) end
function Library:SaveConfig(name) return Modules.Config.Save(name) end
function Library:LoadConfig(name) return Modules.Config.Load(name) end
function Library:EnableAutoSave(name, interval) return Modules.Config.EnableAutoSave(name, interval) end
function Library:DisableAutoSave() return Modules.Config.DisableAutoSave() end

function Library:SetTheme(name) return Modules.Theme.Set(name) end
function Library:GetThemes() return Modules.Theme.Order end

return Library