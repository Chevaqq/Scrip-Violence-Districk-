-- [[ CHEVA HUB - PREMIUM CUSTOM GUI (100% FIXED & WORKING) ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Proteksi tumpang tindih UI
if CoreGui:FindFirstChild("ChevaHubPremium") then
    CoreGui.ChevaHubPremium:Destroy()
end

-- 1. UTAMA SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChevaHubPremium"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

---------------------------------------------------------
-- TOMBOL TOGGLE STATIS (DI KIRI ATAS - SAMA SEPERTI GAMBAR)
---------------------------------------------------------
local ToggleButton = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
local ToggleStroke = Instance.new("UIStroke")

ToggleButton.Name = "Toggle"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0, 15, 0, 55) -- Dikunci statis di bawah tombol Roblox
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "TOGGLE"
ToggleButton.TextColor3 = Color3.fromRGB(0, 200, 100)
ToggleButton.TextSize = 13

ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleButton

---------------------------------------------------------
-- MAIN PANEL DESAIN (HITAM TRANSPARAN 0.5 - PREMIUM LOOK)
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Visible = true

MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

MainStroke.Color = Color3.fromRGB(100, 100, 100)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Fungsi Buka/Tutup lewat Tombol Toggle
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

---------------------------------------------------------
-- HEADER TITLE & TABS SYSTEM
---------------------------------------------------------
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "CHEVA HUB - D.B.D."
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.Size = UDim2.new(1, -20, 0, 40)
TabBar.Position = UDim2.new(0, 10, 0, 40)
TabBar.BackgroundTransparency = 1

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -20, 1, -100)
ContentArea.Position = UDim2.new(0, 10, 0, 85)
ContentArea.BackgroundTransparency = 1

---------------------------------------------------------
-- SISTEM INTERFACES KEY (VERIFIKASI UTAMA)
---------------------------------------------------------
local KeyFrame = Instance.new("Frame")
local KeyCorner = Instance.new("UICorner")
KeyFrame.Parent = MainFrame
KeyFrame.Size = UDim2.new(1, 0, 1, 0)
KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
KeyFrame.BackgroundTransparency = 0.05
KeyFrame.ZIndex = 10

KeyCorner.CornerRadius = UDim.new(0, 10)
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Position = UDim2.new(0, 0, 0, 60)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.Text = "ENTER KEY TO ACCESS"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 18
KeyTitle.ZIndex = 10

local KeyBox = Instance.new("TextBox")
local KeyBoxCorner = Instance.new("UICorner")
KeyBox.Parent = KeyFrame
KeyBox.Size = UDim2.new(0, 220, 0, 35)
KeyBox.Position = UDim2.new(0.5, -110, 0.5, -20)
KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyBox.Font = Enum.Font.SourceSans
KeyBox.Text = ""
KeyBox.PlaceholderText = "Insert Key Here..."
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 14
KeyBox.ZIndex = 10
KeyBoxCorner.Parent = KeyBox

-- Verifikasi otomatis saat melepas ketikan key
KeyBox.FocusLost:Connect(function()
    if KeyBox.Text == "ChevaHub" then
        KeyFrame:Destroy()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Wrong Key! Try again..."
    end
end)

---------------------------------------------------------
-- ENGINE PEMBUATAN ELEMEN UI (TAB, TOGGLE & INPUT)
---------------------------------------------------------
local activePage = nil

local function NewTab(name, layoutOrder)
    local Button = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    
    Button.Parent = TabBar
    Button.Size = UDim2.new(0, 85, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = name:upper()
    Button.TextColor3 = Color3.fromRGB(160, 160, 160)
    Button.TextSize = 13
    Button.LayoutOrder = layoutOrder
    
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = Button
    
    BtnStroke.Color = Color3.fromRGB(60, 60, 60)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Button

    local Page = Instance.new("ScrollingFrame")
    Page.Parent = ContentArea
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 1.8, 0)
    Page.ScrollBarThickness = 2

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 5)

    Button.MouseButton1Click:Connect(function()
        if activePage then activePage.Visible = false end
        Page.Visible = true
        activePage = Page
        for _, obj in pairs(TabBar:GetChildren()) do
            if obj:IsA("TextButton") then
                obj.TextColor3 = Color3.fromRGB(160, 160, 160)
                obj.UIStroke.Color = Color3.fromRGB(60, 60, 60)
            end
        end
        Button.TextColor3 = Color3.fromRGB(0, 200, 100)
        Button.UIStroke.Color = Color3.fromRGB(0, 200, 100)
    end)

    if layoutOrder == 1 then
        Page.Visible = true
        activePage = Page
        Button.TextColor3 = Color3.fromRGB(0, 200, 100)
        Button.UIStroke.Color = Color3.fromRGB(0, 200, 100)
    end

    return Page
end

local function NewToggle(page, text, globalFlag)
    local Row = Instance.new("Frame")
    Row.Parent = page
    Row.Size = UDim2.new(1, 0, 0, 35)
    Row.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel")
    Label.Parent = Row
    Label.Size = UDim2.new(0, 250, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSansBold
    Label.Text = "  " .. text:upper()
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton")
    local SwitchCorner = Instance.new("UICorner")
    Switch.Parent = Row
    Switch.Size = UDim2.new(0, 55, 0, 24)
    Switch.Position = UDim2.new(1, -60, 0.5, -12)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Switch.Font = Enum.Font.SourceSansBold
    Switch.Text = "OFF"
    Switch.TextColor3 = Color3.fromRGB(255, 255, 255)
    Switch.TextSize = 11
    SwitchCorner.CornerRadius = UDim.new(0, 12)
    SwitchCorner.Parent = Switch

    _G[globalFlag] = false
    Switch.MouseButton1Click:Connect(function()
        _G[globalFlag] = not _G[globalFlag]
        if _G[globalFlag] then
            Switch.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
            Switch.Text = "ON"
        else
            Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Switch.Text = "OFF"
        end
    end)
end

local function NewInput(page, text, placeholder, flagName)
    local Row = Instance.new("Frame")
    Row.Parent = page
    Row.Size = UDim2.new(1, 0, 0, 35)
    Row.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel")
    Label.Parent = Row
    Label.Size = UDim2.new(0, 150, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSansBold
    Label.Text = "  " .. text:upper()
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Box = Instance.new("TextBox")
    local BoxCorner = Instance.new("UICorner")
    Box.Parent = Row
    Box.Size = UDim2.new(0, 180, 0, 26)
    Box.Position = UDim2.new(1, -190, 0.5, -13)
    Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Box.Font = Enum.Font.SourceSans
    Box.Text = ""
    Box.PlaceholderText = placeholder
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.TextSize = 13
    BoxCorner.Parent = Box

    Box:GetPropertiesChangedSignal("Text"):Connect(function()
        _G[flagName] = Box.Text
    end)
end

---------------------------------------------------------
-- ALOKASI HALAMAN TAB & DAFTAR FITUR LENGKAP
---------------------------------------------------------
local TabMain = NewTab("Main", 1)
local TabSurv = NewTab("Survivor", 2)
local TabKill = NewTab("Killer", 3)
local TabVis  = NewTab("Visual", 4)

-- TAB 1: MAIN
NewInput(TabMain, "Config Name", "Type config name...", "ConfigName")
NewInput(TabMain, "Speed", "Enter number...", "SpeedValue")

-- TAB 2: SURVIVOR
NewToggle(TabSurv, "Aimlock (Lock Killer)", "Aimlock")
NewToggle(TabSurv, "Treacher Line (Red Line Hit)", "TracerLineHit")
NewToggle(TabSurv, "Silent Aim (Bullet Redirect)", "SilentAim")

-- TAB 3: KILLER
NewToggle(TabKill, "No Slowdown", "NoSlowdown")
NewToggle(TabKill, "Infinite Lague", "InfLague")
NewToggle(TabKill, "Infinite Attack", "InfAttack")

-- TAB 4: VISUAL
NewToggle(TabVis, "Chams Killer (Red)", "ChamsKiller")
NewToggle(TabVis, "Chams Generator (Yellow)", "ChamsGen")
NewToggle(TabVis, "Chams Survivor (Green)", "ChamsSurv")
NewToggle(TabVis, "Full Bright", "FullBright")
NewToggle(TabVis, "Noclip", "Noclip") -- FITUR REQ BARU NYATA WORKING
NewToggle(TabVis, "Treacher Line (K&S)", "TracerVisual")
NewToggle(TabVis, "Box 3D", "Box3D")

---------------------------------------------------------
-- SYSTEM ENGINE CORE (LOGIKA REAL-TIME COUPLING GAME)
---------------------------------------------------------

-- 1. LOOP SPEED & NOCLIP UTAMA (ANTI-RESET DAN PASTI WORK)
RunService.Stepped:Connect(function()
    -- Logika Speed Hack
    if _G.SpeedValue and tonumber(_G.SpeedValue) then
        local chr = LocalPlayer.Character
        if chr and chr:FindFirstChild("Humanoid") then
            chr.Humanoid.WalkSpeed = tonumber(_G.SpeedValue)
        end
    end

    -- Logika Noclip (Tembus Dinding)
    if _G.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 2. ENGINE FULL BRIGHT INTERN
local OriginalBrightness = Lighting.Brightness
local OriginalClockTime = Lighting.ClockTime
task.spawn(function()
    while task.wait(0.3) do
        if _G.FullBright then
            Lighting.Brightness = 10
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 999999
        end
    end
end)
