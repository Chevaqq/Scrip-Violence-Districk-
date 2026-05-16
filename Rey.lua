-- [[ CHEVA HUB - COMBAT VISUAL (FIXED & GUARANTEED TO LOAD) ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Pembersihan UI lama agar tidak tumpang tindih
if CoreGui:FindFirstChild("ChevaSeparatedHub") then
    CoreGui.ChevaSeparatedHub:Destroy()
end

-- 1. SCREEN GUI UTAMA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChevaSeparatedHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

---------------------------------------------------------
-- TOMBOL TOGGLE (STATIS DI KIRI ATAS - PAS DI BAWAH LOGO)
---------------------------------------------------------
local ToggleButton = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
local ToggleStroke = Instance.new("UIStroke")

ToggleButton.Name = "Toggle"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0, 15, 0, 55)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "TOGGLE"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13

ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleButton

---------------------------------------------------------
-- PANEL UTAMA (HITAM TRANSPARAN 0.5 - PREMIUM LOOK)
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 420, 0, 250)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Visible = true

MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

MainStroke.Color = Color3.fromRGB(100, 100, 100)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Fungsi Buka Tutup Panel
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

---------------------------------------------------------
-- HEADER & NAVIGATION TABS
---------------------------------------------------------
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "CHEVA HUB - COMBAT VISUAL"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15

local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.Size = UDim2.new(1, -20, 0, 35)
TabBar.Position = UDim2.new(0, 10, 0, 40)
TabBar.BackgroundTransparency = 1

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 8)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -20, 1, -95)
ContentArea.Position = UDim2.new(0, 10, 0, 85)
ContentArea.BackgroundTransparency = 1

---------------------------------------------------------
-- ENGINE MUTLAK UNTUK MENCARI TARGET (DENGAN PROTEKSI AMAN)
---------------------------------------------------------
local function GetClosestTarget()
    local closestPart = nil
    local shortestDistance = math.huge
    local myChar = LocalPlayer.Character
    
    -- Dipasang pcall agar kalau character nil / reset, script TIDAK crash
    pcall(function()
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                    if p.Character.Humanoid.Health > 0 then
                        local distance = (myChar.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            closestPart = p.Character.HumanoidRootPart
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end)
    return closestPart
end

---------------------------------------------------------
-- RAKITAN UI BUILDER COUPLING
---------------------------------------------------------
local activePage = nil

local function CreateNewTab(name, order)
    local Button = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    
    Button.Parent = TabBar
    Button.Size = UDim2.new(0, 120, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = name:upper()
    Button.TextColor3 = Color3.fromRGB(150, 150, 150)
    Button.TextSize = 13
    Button.LayoutOrder = order
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = Button

    local Page = Instance.new("Frame")
    Page.Parent = ContentArea
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)

    Button.MouseButton1Click:Connect(function()
        if activePage then activePage.Visible = false end
        Page.Visible = true
        activePage = Page
        for _, obj in pairs(TabBar:GetChildren()) do
            if obj:IsA("TextButton") then obj.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        Button.TextColor3 = Color3.fromRGB(0, 220, 110)
    end)

    if order == 1 then
        Page.Visible = true
        activePage = Page
        Button.TextColor3 = Color3.fromRGB(0, 220, 110)
    end

    return Page
end

local function AddFeatureToggle(page, text, flag)
    local Row = Instance.new("Frame")
    Row.Parent = page
    Row.Size = UDim2.new(1, 0, 0, 40)
    Row.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel")
    Label.Parent = Row
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSansBold
    Label.Text = "  " .. text:upper()
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton")
    local SwitchCorner = Instance.new("UICorner")
    Switch.Parent = Row
    Switch.Size = UDim2.new(0, 60, 0, 26)
    Switch.Position = UDim2.new(1, -70, 0.5, -13)
    Switch.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    Switch.Font = Enum.Font.SourceSansBold
    Switch.Text = "OFF"
    Switch.TextColor3 = Color3.fromRGB(255, 255, 255)
    Switch.TextSize = 12
    SwitchCorner.CornerRadius = UDim.new(0, 13)
    SwitchCorner.Parent = Switch

    _G[flag] = false
    Switch.MouseButton1Click:Connect(function()
        _G[flag] = not _G[flag]
        if _G[flag] then
            Switch.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
            Switch.Text = "ON"
        else
            Switch.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            Switch.Text = "OFF"
        end
    end)
end

---------------------------------------------------------
-- ALOKASI PEMBUATAN MENU SEPARATED
---------------------------------------------------------
local AimlockPage = CreateNewTab("Aimlock System", 1)
local TracerPage  = CreateNewTab("Tracer Line", 2)

AddFeatureToggle(AimlockPage, "Enable Aimlock (Camera)", "CameraAimlock")
AddFeatureToggle(TracerPage, "Enable Tracer Line (Red)", "RedVisualTracer")

---------------------------------------------------------
-- CORE LOGIKA EKSEKUSI PERMAINAN (FIXED)
---------------------------------------------------------

-- LOGIKA 1: AIMLOCK KAMERA MULUS
RunService.RenderStepped:Connect(function()
    if _G.CameraAimlock then
        local target = GetClosestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

-- LOGIKA 2: TRACER LINE MERAH INSTANT (PENYIMPANAN DI WORKSPACE AMAN)
local function SpawnLaserEffect(startPos, endPos)
    local laser = Instance.new("BoxHandleAdornment")
    laser.Size = Vector3.new(0.12, 0.12, (startPos - endPos).Magnitude)
    laser.CFrame = CFrame.new(startPos:Lerp(endPos, 0.5), endPos)
    laser.Color3 = Color3.fromRGB(255, 30, 30) -- Merah Menyala Terbuka
    laser.Transparency = 0.2
    laser.AlwaysOnTop = true
    laser.ZIndex = 10
    laser.Adornee = Workspace -- DIPINDAH KE WORKSPACE BIAR PASTI LOAD 100%
    laser.Parent = Workspace
    
    task.wait(0.1) -- Durasi tampil tipis lalu langsung musnah/hilang
    laser:Destroy()
end

local Mouse = LocalPlayer:GetMouse()
Mouse.Button1Down:Connect(function()
    if _G.RedVisualTracer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = GetClosestTarget()
        if target then
            task.spawn(SpawnLaserEffect, LocalPlayer.Character.HumanoidRootPart.Position, target.Position)
        end
    end
end)
