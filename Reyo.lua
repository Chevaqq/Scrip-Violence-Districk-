-- [[ REYO.VEIL UI SCRIPT FROM SCRATCH ]] --
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Local States (Fitur)
local Features = {
    SurvChams = false,
    KillChams = false,
    SurvAimPred = false,
    KillAimbot = false,
    KillAimPred = false,
    KillSilent = false
}

-- Create UI Base
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyoVeil_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
-- Mengatasi proteksi exploit/executor mobile
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- [[ 1. SISTEM KEY WINDOW ]] --
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UIDimensions and UIDimensions.new(0, 300, 0, 180) or UDim2.new(0, 300, 0, 180)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyFrame.BackgroundTransparency = 0.3
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 8)
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Text = "Reyo.Veil"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 20
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.BackgroundTransparency = 1
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.PlaceholderText = "Masukkan Key Disini..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInput.BackgroundTransparency = 0.5
KeyInput.Parent = KeyFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 5)
KeyInputCorner.Parent = KeyInput

local KeyBtn = Instance.new("TextButton")
KeyBtn.Size = UDim2.new(0.8, 0, 0, 35)
KeyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
KeyBtn.Text = "Submit"
KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
KeyBtn.Font = Enum.Font.SourceSansBold
KeyBtn.TextSize = 16
KeyBtn.Parent = KeyFrame

local KeyBtnCorner = Instance.new("UICorner")
KeyBtnCorner.CornerRadius = UDim.new(0, 5)
KeyBtnCorner.Parent = KeyBtn


-- [[ 2. MAIN MENU WINDOW ]] --
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.4 -- Transparan hitam 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Title Main Menu
local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 35)
MainTitle.Text = "  Reyo.Veil - Violence District"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 18
MainTitle.Font = Enum.Font.SourceSansBold
MainTitle.TextXAlignment = Enum.TextXAlignment.Left
MainTitle.BackgroundTransparency = 1
MainTitle.Parent = MainFrame

-- Close Button UI
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = MainFrame

-- Container Tab (Survivor / Killer)
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 100, 1, -35)
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local SurvTabBtn = Instance.new("TextButton")
SurvTabBtn.Size = UDim2.new(1, 0, 0, 40)
SurvTabBtn.Position = UDim2.new(0, 0, 0, 0)
SurvTabBtn.Text = "Survivor"
SurvTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SurvTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SurvTabBtn.BackgroundTransparency = 0.5
SurvTabBtn.Parent = TabContainer

local KillTabBtn = Instance.new("TextButton")
KillTabBtn.Size = UDim2.new(1, 0, 0, 40)
KillTabBtn.Position = UDim2.new(0, 0, 0, 45)
KillTabBtn.Text = "Killer"
KillTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
KillTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KillTabBtn.BackgroundTransparency = 0.7
KillTabBtn.Parent = TabContainer

-- Content Panel
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -110, 1, -45)
ContentFrame.Position = UDim2.new(0, 105, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local SurvList = Instance.new("ScrollingFrame")
SurvList.Size = UDim2.new(1, 0, 1, 0)
SurvList.BackgroundTransparency = 1
SurvList.CanvasSize = UDim2.new(0, 0, 1.5, 0)
SurvList.ScrollBarThickness = 2
SurvList.Visible = true
SurvList.Parent = ContentFrame

local KillList = Instance.new("ScrollingFrame")
KillList.Size = UDim2.new(1, 0, 1, 0)
KillList.BackgroundTransparency = 1
KillList.CanvasSize = UDim2.new(0, 0, 1.5, 0)
KillList.ScrollBarThickness = 2
KillList.Visible = false
KillList.Parent = ContentFrame

local SurvLayout = Instance.new("UIListLayout")
SurvLayout.Parent = SurvList; SurvLayout.Padding = UDim.new(0, 5)

local KillLayout = Instance.new("UIListLayout")
KillLayout.Parent = KillList; KillLayout.Padding = UDim.new(0, 5)


-- [[ 3. TOMBOL OPEN MENU (MOBILE FRIENDLY) ]] --
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 60, 0, 35)
OpenBtn.Position = UDim2.new(0, 10, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 180, 30)
OpenBtn.Text = "Open"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Font.fromEnum(Enum.Font.SourceSansBold)
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6)


-- [[ 4. FUNCTION MAKER FOR UI ]] --
local function CreateToggle(name, parent, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.95, 0, 0, 35)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBtn.BackgroundTransparency = 0.5
    ToggleBtn.Text = "  " .. name .. " : OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtn.Font = Enum.Font.SourceSans
    ToggleBtn.TextSize = 15
    ToggleBtn.Parent = parent
    
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 4)
    
    local enabled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            ToggleBtn.Text = "  " .. name .. " : ON"
            ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
        else
            ToggleBtn.Text = "  " .. name .. " : OFF"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        callback(enabled)
    end)
end


-- [[ 5. LOGIC & FUNCTIONAL FITUR ]] --

-- Fungsi Cari Player Terdekat
local function GetClosestPlayer()
    local target = nil
    local distance = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if mag < distance then
                distance = mag
                target = v
            end
        end
    end
    return target
end

-- Fungsi Chams (ESP Box/Highlight)
local function ApplyChams(player, color)
    if player.Character then
        local highlight = player.Character:FindFirstChild("VeilChams") or Instance.new("Highlight")
        highlight.Name = "VeilChams"
        highlight.FillColor = color
        highlight.FillTransparency = 0.4
        highlight.OutlineTransparency = 1
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end
end

local function RemoveChams(player)
    if player.Character and player.Character:FindFirstChild("VeilChams") then
        player.Character.VeilChams:Destroy()
    end
end

-- Loop Handler untuk Game Logic
RunService.RenderStepped:Connect(function()
    -- Fitur Chams Loop
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            -- Note logika deteksi role disesuaikan dev/gameplay Violence District
            -- Di bawah ini permisalan sederhana team/role
            if Features.SurvChams then
                ApplyChams(p, Color3.fromRGB(0, 255, 0)) -- Hijau Full
            elseif Features.KillChams then
                ApplyChams(p, Color3.fromRGB(255, 0, 0)) -- Merah Full
            else
                RemoveChams(p)
            end
        end
    end

    -- Aimbot / Prediction Logic
    if Features.KillAimbot or Features.SurvAimPred or Features.KillAimPred then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local velocity = hrp.AssemblyLinearVelocity
            -- Rumus prediksi posisi target berdasar kecepatan gerak
            local predictedPos = hrp.Position + (velocity * 0.165) 
            
            if Features.KillAimbot then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
            end
        end
    end
end)

-- Silent Aim Hook Hook (Simulasi bypass tembakan agar langsung kena)
local MT = getrawmetatable(game)
local OldNamecall = MT.__namecall
setreadonly(MT, false)

MT.__namecall = newcclosure(function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if Features.KillSilent and Method == "FireServer" and Self.Name == "TombakRemote" or Method == "InvokeServer" then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            -- Mengubah argument posisi/target tembakan ke HumanoidRootPart Survivor terdekat
            Args[1] = target.Character.HumanoidRootPart.Position
            return Self[Method](Self, unpack(Args))
        end
    end
    return OldNamecall(Self, ...)
end)
setreadonly(MT, true)


-- [[ 6. MEMBUAT TOGGLE DI TAB MENU ]] --

-- Survivor Tabs
CreateToggle("Chams Survivor", SurvList, function(state) Features.SurvChams = state end)
CreateToggle("Chams Killer", SurvList, function(state) Features.KillChams = state end)
CreateToggle("Aim Prediksi", SurvList, function(state) Features.SurvAimPred = state end)

-- Killer Tabs
CreateToggle("Aimbot Veil", KillList, function(state) Features.KillAimbot = state end)
CreateToggle("Aim Prediksi Veil", KillList, function(state) Features.KillAimPred = state end)
CreateToggle("Silent Aim Veil", KillList, function(state) Features.KillSilent = state end)


-- [[ 7. INTERAKSI BUTTON & KEY VALIDATION ]] --

-- Submit Key Logic
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "Veil" then
        KeyFrame:Destroy() -- Hapus UI input key instant
        MainFrame.Visible = true -- Buka menu utama
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "KEY SALAH! Coba lagi..."
    end
end)

-- Navigation Tab Switcher (Instant tanpa transisi lemot)
SurvTabBtn.MouseButton1Click:Connect(function()
    SurvList.Visible = true
    KillList.Visible = false
    SurvTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    KillTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)

KillTabBtn.MouseButton1Click:Connect(function()
    KillList.Visible = true
    SurvList.Visible = false
    KillTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SurvTabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end)

-- Close / Open Interaction
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Fitur Dragging Menu (Biar bisa digeser di layar HP)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)
