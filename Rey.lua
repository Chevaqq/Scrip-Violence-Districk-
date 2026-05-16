-- [[ CHEVA HUB - EXCLUSIVE TRACER LINE ONLY ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Proteksi tumpang tindih UI
if CoreGui:FindFirstChild("ChevaTracerHub") then
    CoreGui.ChevaTracerHub:Destroy()
end

-- 1. UTAMA SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChevaTracerHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

---------------------------------------------------------
-- TOMBOL TOGGLE (STATIS DI KIRI ATAS - DI BAWAH MENU ROBLOX)
---------------------------------------------------------
local ToggleButton = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
local ToggleStroke = Instance.new("UIStroke")

ToggleButton.Name = "Toggle"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0, 15, 0, 55) -- Posisi statis tidak bisa digeser
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "TOGGLE"
ToggleButton.TextColor3 = Color3.fromRGB(255, 100, 0) -- Warna Oranye sesuai tema fitur
ToggleButton.TextSize = 13

ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleButton

---------------------------------------------------------
-- MAIN PANEL FRAME (HITAM TRANSPARAN 0.5)
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 350, 0, 150) -- Ukuran lebih minimalis karena cuma 1 fitur
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Visible = true

MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

MainStroke.Color = Color3.fromRGB(255, 100, 0) -- Stroke Oranye biar sangar
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Fungsi Buka/Tutup lewat Tombol Toggle
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

---------------------------------------------------------
-- TITLE HEADER
---------------------------------------------------------
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "CHEVA HUB - TRACER EDITION"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

---------------------------------------------------------
-- TOMBOL SWITCH FITUR ON / OFF
---------------------------------------------------------
local RowFrame = Instance.new("Frame")
RowFrame.Parent = MainFrame
RowFrame.Size = UDim2.new(1, -20, 0, 50)
RowFrame.Position = UDim2.new(0, 10, 0, 65)
RowFrame.BackgroundTransparency = 1

local FeatureLabel = Instance.new("TextLabel")
FeatureLabel.Parent = RowFrame
FeatureLabel.Size = UDim2.new(0, 200, 1, 0)
FeatureLabel.BackgroundTransparency = 1
FeatureLabel.Font = Enum.Font.SourceSansBold
FeatureLabel.Text = "  TREACHER LINE (ORANGE)"
FeatureLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
FeatureLabel.TextSize = 14
FeatureLabel.TextXAlignment = Enum.TextXAlignment.Left

local SwitchButton = Instance.new("TextButton")
local SwitchCorner = Instance.new("UICorner")
SwitchButton.Parent = RowFrame
SwitchButton.Size = UDim2.new(0, 65, 0, 30)
SwitchButton.Position = UDim2.new(1, -75, 0.5, -15)
SwitchButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SwitchButton.Font = Enum.Font.SourceSansBold
SwitchButton.Text = "OFF"
SwitchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SwitchButton.TextSize = 12
SwitchCorner.CornerRadius = UDim.new(0, 15)
SwitchCorner.Parent = SwitchButton

---------------------------------------------------------
-- LOGIKA ENGINE UTAMA: GERAKAN LINE ORANYE KE TARGET
---------------------------------------------------------
_G.TracerLineOrange = false

-- Fungsi mencari musuh terdekat dari karakter kita
local function GetClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myChar = LocalPlayer.Character
    
    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local distance = (myChar.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    closestPlayer = p.Character.HumanoidRootPart
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- Fungsi membuat efek garis laser Oranye murni menggunakan BoxHandleAdornment (Anti-Lag & Instant)
local function CreateOrangeLaser(startPos, endPos)
    local laser = Instance.new("BoxHandleAdornment")
    laser.Size = Vector3.new(0.15, 0.15, (startPos - endPos).Magnitude)
    laser.CFrame = CFrame.new(startPos:Lerp(endPos, 0.5), endPos)
    laser.Color3 = Color3.fromRGB(255, 100, 0) -- Warna Oranye menyala tulen
    laser.Transparency = 0.1
    laser.AlwaysOnTop = true
    laser.ZIndex = 5
    laser.Adornee = workspace.Terrain
    laser.Parent = workspace.Terrain
    
    -- Efek instant hilang setelah peluru sampai/kena target
    task.wait(0.12)
    laser:Destroy()
end

-- Deteksi klik/tembakan untuk memunculkan garis laser ke target
SwitchButton.MouseButton1Click:Connect(function()
    _G.TracerLineOrange = not _G.TracerLineOrange
    if _G.TracerLineOrange then
        SwitchButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0) -- Berubah jadi oranye saat aktif
        SwitchButton.Text = "ON"
    else
        SwitchButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SwitchButton.Text = "OFF"
    end
end)

-- Listener Tembakan / Serangan Peluru keluar
local Mouse = LocalPlayer:GetMouse()
Mouse.Button1Down:Connect(function()
    if _G.TracerLineOrange and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = GetClosestTarget()
        if target then
            -- Garis ditarik dari tubuh karakter kamu langsung meluncur lurus ke koordinat target terdekat
            CreateOrangeLaser(LocalPlayer.Character.HumanoidRootPart.Position, target.Position)
        end
    end
end)
