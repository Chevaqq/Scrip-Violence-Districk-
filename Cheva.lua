-- [[ CHEVA HUB - CUSTOM HANDMADE GUI (MOBILE OPTIMIZED) ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Hapus GUI lama jika ada biar gak tumpang tindih
if CoreGui:FindFirstChild("ChevaHubCustom") then
    CoreGui.ChevaHubCustom:Destroy()
end

-- 1. PEMBUATAN SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChevaHubCustom"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

---------------------------------------------------------
-- TOMBOL TOGGLE (BUKA TUTUP) DI KIRI ATAS
---------------------------------------------------------
local ToggleButton = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")

ToggleButton.Name = "Toggle"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 70, 0, 35)
ToggleButton.Position = UDim2.new(0, 15, 0, 55) -- Di bawah tombol logo Roblox asli
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Toggle"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16

ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

---------------------------------------------------------
-- MAIN WINDOW FRAME (HITAM TRANSPARAN 0.5)
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 550, 0, 380)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.5 -- Transparan 0.5 sesuai request
MainFrame.Visible = true

MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Membuat MainFrame bisa digeser (Draggable) di HP
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- Fungsi Buka Tutup via Tombol Toggle
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

---------------------------------------------------------
-- KONTEN INTERAL: HEADLINE & TABS SYSTEM
---------------------------------------------------------
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.Text = "CHEVA HUB - DEAD BY DAYLIGHT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

-- Container Untuk Tab Buttons
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.Size = UDim2.new(1, -20, 0, 35)
TabContainer.Position = UDim2.new(0, 10, 0, 45)
TabContainer.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabContainer
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Container Tempat Isi Fitur
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.Size = UDim2.new(1, -20, 1, -100)
ContentContainer.Position = UDim2.new(0, 10, 0, 90)
ContentContainer.BackgroundTransparency = 1

---------------------------------------------------------
-- SISTEM KEY (LOGIN SCREEN SEMENTARA)
---------------------------------------------------------
local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = MainFrame
KeyFrame.Size = UDim2.new(1, 0, 1, -40)
KeyFrame.Position = UDim2.new(0, 0, 0, 40)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
KeyFrame.BackgroundTransparency = 0.1
KeyFrame.ZIndex = 5

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Parent = KeyFrame
KeyLabel.Size = UDim2.new(1, 0, 0, 40)
KeyLabel.Position = UDim2.new(0, 0, 0, 50)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Font = Enum.Font.SourceSans
KeyLabel.Text = "Masukkan Key 'ChevaHub' Untuk Membuka Script"
KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyLabel.TextSize = 18
KeyLabel.ZIndex = 5

local KeyInput = Instance.new("TextBox")
local KeyInputCorner = Instance.new("UICorner")
KeyInput.Parent = KeyFrame
KeyInput.Size = UDim2.new(0, 250, 0, 40)
KeyInput.Position = UDim2.new(0.5, -125, 0.5, -30)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInput.Font = Enum.Font.SourceSans
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ketik Key Disini..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.ZIndex = 5
KeyInputCorner.Parent = KeyInput

-- Cek Key Otomatis Saat Selesai Ketik
KeyInput.FocusLost:Connect(function(EnterPressed)
    if KeyInput.Text == "ChevaHub" then
        KeyFrame:Destroy() -- Hilangkan penutup login jika key benar
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Key Salah! Coba lagi..."
    end
end)

---------------------------------------------------------
-- FUNGSI MEMBUAT HALAMAN TAB & TOGGLE FITUR
---------------------------------------------------------
local pages = {}
local activePage = nil

local function CreateTab(name, order)
    local TabButton = Instance.new("TextButton")
    local ButtonCorner = Instance.new("UICorner")
    TabButton.Parent = TabContainer
    TabButton.Size = UDim2.new(0, 95, 1, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.Text = name:upper()
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    TabButton.LayoutOrder = order
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = TabButton

    local Page = Instance.new("ScrollingFrame")
    Page.Parent = ContentContainer
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)
    Page.ScrollBarThickness = 4

    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 6)

    TabButton.MouseButton1Click:Connect(function()
        if activePage then activePage.Visible = false end
        Page.Visible = true
        activePage = Page
        for _, btn in pairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 150, 70) -- Hijau penanda tab aktif
    end)

    if order == 1 then
        Page.Visible = true
        activePage = Page
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
    end

    return Page
end

local function AddToggle(page, text, globalVar)
    local Frame = Instance.new("Frame")
    Frame.Parent = page
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Size = UDim2.new(0, 300, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSans
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Button = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    Button.Parent = Frame
    Button.Size = UDim2.new(0, 50, 0, 25)
    Button.Position = UDim2.new(1, -60, 0.5, -12)
    Button.BackgroundColor3 = Color3.fromRGB(150, 30, 30) -- Merah default (OFF)
    Button.Text = "OFF"
    Button.Font = Enum.Font.SourceSansBold
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    BtnCorner.Parent = Button

    _G[globalVar] = false
    Button.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        if _G[globalVar] then
            Button.BackgroundColor3 = Color3.fromRGB(30, 150, 30) -- Hijau (ON)
            Button.Text = "ON"
        else
            Button.BackgroundColor3 = Color3.fromRGB(150, 30, 30) -- Merah (OFF)
            Button.Text = "OFF"
        end
    end)
end

local function AddInput(page, text, placeholder, callback)
    local Frame = Instance.new("Frame")
    Frame.Parent = page
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.Size = UDim2.new(0, 150, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSans
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Input = Instance.new("TextBox")
    local InputCorner = Instance.new("UICorner")
    Input.Parent = Frame
    Input.Size = UDim2.new(0, 200, 0, 30)
    Input.Position = UDim2.new(1, -210, 0.5, -15)
    Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Input.Font = Enum.Font.SourceSans
    Input.Text = ""
    Input.PlaceholderText = placeholder
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.TextSize = 14
    InputCorner.Parent = Input

    Input.FocusLost:Connect(function()
        callback(Input.Text)
    end)
end

---------------------------------------------------------
-- ALOKASI PEMBUATAN TAB & KONTEN FITUR
---------------------------------------------------------
local MainTab = CreateTab("Main", 1)
local SurvTab = CreateTab("Survivor", 2)
local KillTab = CreateTab("Killer", 3)
local VisTab  = CreateTab("Visual", 4)

-- TAB 1: MAIN CONTENT
AddInput(MainTab, "Config Name:", "Masukkan nama config...", function(text)
    _G.ConfigName = text
end)

AddInput(MainTab, "Speed Hack:", "Ketik angka (Contoh: 30)", function(text)
    local num = tonumber(text)
    if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = num
    end
end)

-- TAB 2: SURVIVOR CONTENT
AddToggle(SurvTab, "Aimlock (Lock Killer)", "Aimlock")
AddToggle(SurvTab, "Treacher Line (Red Line on Hit)", "TracerLineHit")
AddToggle(SurvTab, "Silent Aim (Bullet Redirect)", "SilentAim")

-- TAB 3: KILLER CONTENT
AddToggle(KillTab, "No Slowdown", "NoSlowdown")
AddToggle(KillTab, "Infinite Lague", "InfLague")
AddToggle(KillTab, "Infinite Attack", "InfAttack")

-- TAB 4: VISUAL CONTENT
AddToggle(VisTab, "Chams Killer (Merah)", "ChamsKiller")
AddToggle(VisTab, "Chams Generator (Kuning)", "ChamsGen")
AddToggle(VisTab, "Chams Survivor (Hijau)", "ChamsSurv")

-- Logika Real-time Full Bright
local OldBrightness = Lighting.Brightness
local OldClockTime = Lighting.ClockTime
AddToggle(VisTab, "Full Bright (Layar Terang)", "FullBright")

local BrightLoop = task.spawn(function()
    while task.wait(0.5) do
        if _G.FullBright then
            Lighting.Brightness = 10
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 999999
        end
    end
end)

AddToggle(VisTab, "Treacher Line (Killer & Survivor)", "TracerVisual")
AddToggle(VisTab, "Box 3D (Transparent Center)", "Box3D")
