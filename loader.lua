-- ============================================================
-- LAZY JIRO · AUTO SPIN HUB
-- Glassmorphic UI Shell
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ============================================================
-- CONFIG
-- ============================================================
local CFG = {
    SpinTargetRate = 500, -- Spins per second (Raise to 1000+ at your own risk)
}

-- ============================================================
-- THEME (Glassmorphic Dark)
-- ============================================================
local Theme = {
    BgColor      = Color3.fromRGB(15, 15, 20),
    BgTrans      = 0.4,
    CardColor    = Color3.fromRGB(30, 30, 40),
    CardTrans    = 0.5,
    StrokeColor  = Color3.fromRGB(255, 255, 255),
    StrokeTrans  = 0.85,
    TextPrimary  = Color3.fromRGB(255, 255, 255),
    TextSecond   = Color3.fromRGB(170, 170, 185),
    Accent       = Color3.fromRGB(90, 140, 255), -- Blue
    Success      = Color3.fromRGB(60, 220, 130), -- Green
}

-- ============================================================
-- HELPERS
-- ============================================================
local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local function Round(obj, radius)
    Create("UICorner", { CornerRadius = UDim.new(0, radius) }, obj)
end

local function Stroke(obj, transparency)
    Create("UIStroke", {
        Color = Theme.StrokeColor,
        Transparency = transparency or Theme.StrokeTrans,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, obj)
end

local function MakeDraggable(frame, dragArea)
    local dragging, dragStart, startPos
    
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ============================================================
-- UI CONSTRUCTION
-- ============================================================
local parent = (gethui and gethui()) or player:WaitForChild("PlayerGui")
local old = parent:FindFirstChild("LazyJiroUI")
if old then old:Destroy() end

local ScreenGui = Create("ScreenGui", {
    Name = "LazyJiroUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = parent,
})

local Main = Create("Frame", {
    Size = UDim2.new(0, 280, 0, 270), -- Smaller height since we removed tabs
    Position = UDim2.new(0.5, -140, 0.5, -135),
    BackgroundColor3 = Theme.BgColor,
    BackgroundTransparency = Theme.BgTrans,
    BorderSizePixel = 0,
    Active = true,
    Parent = ScreenGui,
})
Round(Main, 16)
Stroke(Main, 0.7)

local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundTransparency = 1,
    Parent = Main,
})
MakeDraggable(Main, Header)

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 20, 0, 0),
    BackgroundTransparency = 1,
    Text = "LAZY JIRO",
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    TextColor3 = Theme.TextPrimary,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header,
})

local CloseBtn = Create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(255, 80, 80),
    BackgroundTransparency = 0.8,
    Text = "X",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = Theme.TextPrimary,
    AutoButtonColor = false,
    Parent = Header,
})
Round(CloseBtn, 8)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Main Page (No tabs)
local SpinPage = Create("Frame", {
    Size = UDim2.new(1, -40, 1, -70),
    Position = UDim2.new(0, 20, 0, 56),
    BackgroundTransparency = 1,
    Parent = Main,
})

local SpinLabel = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "Spins per fire:",
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = Theme.TextSecond,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SpinPage,
})

local SpinBox = Create("TextBox", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 24),
    BackgroundColor3 = Theme.CardColor,
    BackgroundTransparency = Theme.CardTrans,
    Text = "1000",
    PlaceholderText = "1000",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Theme.TextPrimary,
    PlaceholderColor3 = Theme.TextSecond,
    ClearTextOnFocus = false,
    Parent = SpinPage,
})
Round(SpinBox, 10)
Stroke(SpinBox, 0.9)

local SpinOnceBtn = Create("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 74),
    BackgroundColor3 = Theme.CardColor,
    BackgroundTransparency = Theme.CardTrans,
    Text = "Spin once",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Theme.TextPrimary,
    AutoButtonColor = false,
    Parent = SpinPage,
})
Round(SpinOnceBtn, 10)
Stroke(SpinOnceBtn, 0.8)

local AutoSpinBtn = Create("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 124),
    BackgroundColor3 = Theme.Accent,
    Text = "Auto Spin: OFF",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Theme.TextPrimary,
    AutoButtonColor = false,
    Parent = SpinPage,
})
Round(AutoSpinBtn, 10)

-- ============================================================
-- LOGIC
-- ============================================================
local LuckRE
pcall(function()
    LuckRE = game:GetService("ReplicatedStorage").Remote.Season_Server.LuckRE
end)

local function getSpinAmount()
    local n = tonumber(SpinBox.Text)
    if not n or n < 1 then n = 1 end
    return math.floor(n)
end

SpinOnceBtn.MouseButton1Click:Connect(function()
    if not LuckRE then return end
    SpinOnceBtn.Text = "Spinning..."
    pcall(function() LuckRE:FireServer(getSpinAmount()) end)
    task.wait(0.2)
    SpinOnceBtn.Text = "Spin once"
end)

local autoSpin = false

AutoSpinBtn.MouseButton1Click:Connect(function()
    if not LuckRE then return end

    autoSpin = not autoSpin
    if autoSpin then
        AutoSpinBtn.Text = "Auto Spin: ON"
        AutoSpinBtn.BackgroundColor3 = Theme.Success
        
        task.spawn(function()
            while autoSpin do
                local amount = getSpinAmount()
                local dt = RunService.Heartbeat:Wait()
                
                local owed = math.floor(CFG.SpinTargetRate * dt)
                if owed < 1 then owed = 1 end
                if owed > 200 then owed = 200 end

                for i = 1, owed do
                    if not autoSpin then break end
                    pcall(function() LuckRE:FireServer(amount) end)
                end
            end
        end)
    else
        AutoSpinBtn.Text = "Auto Spin: OFF"
        AutoSpinBtn.BackgroundColor3 = Theme.Accent
    end
end)-- ============================================================
-- LAZY JIRO · AUTO SPIN HUB
-- Glassmorphic UI Shell
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ============================================================
-- CONFIG
-- ============================================================
local CFG = {
    SpinTargetRate = 500, -- Spins per second (Raise to 1000+ at your own risk)
}

-- ============================================================
-- THEME (Glassmorphic Dark)
-- ============================================================
local Theme = {
    BgColor      = Color3.fromRGB(15, 15, 20),
    BgTrans      = 0.4,
    CardColor    = Color3.fromRGB(30, 30, 40),
    CardTrans    = 0.5,
    StrokeColor  = Color3.fromRGB(255, 255, 255),
    StrokeTrans  = 0.85,
    TextPrimary  = Color3.fromRGB(255, 255, 255),
    TextSecond   = Color3.fromRGB(170, 170, 185),
    Accent       = Color3.fromRGB(90, 140, 255), -- Blue
    Success      = Color3.fromRGB(60, 220, 130), -- Green
}

-- ============================================================
-- HELPERS
-- ============================================================
local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local function Round(obj, radius)
    Create("UICorner", { CornerRadius = UDim.new(0, radius) }, obj)
end

local function Stroke(obj, transparency)
    Create("UIStroke", {
        Color = Theme.StrokeColor,
        Transparency = transparency or Theme.StrokeTrans,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, obj)
end

local function MakeDraggable(frame, dragArea)
    local dragging, dragStart, startPos
    
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ============================================================
-- UI CONSTRUCTION
-- ============================================================
local parent = (gethui and gethui()) or player:WaitForChild("PlayerGui")
local old = parent:FindFirstChild("LazyJiroUI")
if old then old:Destroy() end

local ScreenGui = Create("ScreenGui", {
    Name = "LazyJiroUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = parent,
})

local Main = Create("Frame", {
    Size = UDim2.new(0, 280, 0, 270), -- Smaller height since we removed tabs
    Position = UDim2.new(0.5, -140, 0.5, -135),
    BackgroundColor3 = Theme.BgColor,
    BackgroundTransparency = Theme.BgTrans,
    BorderSizePixel = 0,
    Active = true,
    Parent = ScreenGui,
})
Round(Main, 16)
Stroke(Main, 0.7)

local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundTransparency = 1,
    Parent = Main,
})
MakeDraggable(Main, Header)

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 20, 0, 0),
    BackgroundTransparency = 1,
    Text = "LAZY JIRO",
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    TextColor3 = Theme.TextPrimary,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header,
})

local CloseBtn = Create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(255, 80, 80),
    BackgroundTransparency = 0.8,
    Text = "X",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = Theme.TextPrimary,
    AutoButtonColor = false,
    Parent = Header,
})
Round(CloseBtn, 8)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Main Page (No tabs)
local SpinPage = Create("Frame", {
    Size = UDim2.new(1, -40, 1, -70),
    Position = UDim2.new(0, 20, 0, 56),
    BackgroundTransparency = 1,
    Parent = Main,
})

local SpinLabel = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "Spins per fire:",
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextColor3 = Theme.TextSecond,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SpinPage,
})

local SpinBox = Create("TextBox", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 24),
    BackgroundColor3 = Theme.CardColor,
    BackgroundTransparency = Theme.CardTrans,
    Text = "1000",
    PlaceholderText = "1000",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Theme.TextPrimary,
    PlaceholderColor3 = Theme.TextSecond,
    ClearTextOnFocus = false,
    Parent = SpinPage,
})
Round(SpinBox, 10)
Stroke(SpinBox, 0.9)

local SpinOnceBtn = Create("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 74),
    BackgroundColor3 = Theme.CardColor,
    BackgroundTransparency = Theme.CardTrans,
    Text = "Spin once",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Theme.TextPrimary,
    AutoButtonColor = false,
    Parent = SpinPage,
})
Round(SpinOnceBtn, 10)
Stroke(SpinOnceBtn, 0.8)

local AutoSpinBtn = Create("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 124),
    BackgroundColor3 = Theme.Accent,
    Text = "Auto Spin: OFF",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Theme.TextPrimary,
    AutoButtonColor = false,
    Parent = SpinPage,
})
Round(AutoSpinBtn, 10)

-- ============================================================
-- LOGIC
-- ============================================================
local LuckRE
pcall(function()
    LuckRE = game:GetService("ReplicatedStorage").Remote.Season_Server.LuckRE
end)

local function getSpinAmount()
    local n = tonumber(SpinBox.Text)
    if not n or n < 1 then n = 1 end
    return math.floor(n)
end

SpinOnceBtn.MouseButton1Click:Connect(function()
    if not LuckRE then return end
    SpinOnceBtn.Text = "Spinning..."
    pcall(function() LuckRE:FireServer(getSpinAmount()) end)
    task.wait(0.2)
    SpinOnceBtn.Text = "Spin once"
end)

local autoSpin = false

AutoSpinBtn.MouseButton1Click:Connect(function()
    if not LuckRE then return end

    autoSpin = not autoSpin
    if autoSpin then
        AutoSpinBtn.Text = "Auto Spin: ON"
        AutoSpinBtn.BackgroundColor3 = Theme.Success
        
        task.spawn(function()
            while autoSpin do
                local amount = getSpinAmount()
                local dt = RunService.Heartbeat:Wait()
                
                local owed = math.floor(CFG.SpinTargetRate * dt)
                if owed < 1 then owed = 1 end
                if owed > 200 then owed = 200 end

                for i = 1, owed do
                    if not autoSpin then break end
                    pcall(function() LuckRE:FireServer(amount) end)
                end
            end
        end)
    else
        AutoSpinBtn.Text = "Auto Spin: OFF"
        AutoSpinBtn.BackgroundColor3 = Theme.Accent
    end
end)
