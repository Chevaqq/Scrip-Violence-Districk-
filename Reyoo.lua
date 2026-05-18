-- [[ REYHUB / ACCOORNNHUB - VIOLENCE DISTRICT SCRIPT ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- State Pemain
local CurrentTarget = nil

-- Konfigurasi Fitur (On/Off)
local Config = {
    KeyVerified = false,
    CorrectKey = "Reyo",
    ChamsKiller = false,
    ChamsSurvivor = false,
    SilentAimSurvivor = false, -- Aimprediksi Survivor
    AimbotVeil = false,        -- Lock Killer
    SilentAimVeil = false,     -- Aimprediksi Veil
    ShowVeilLine = false
}

-- [[ UI SYSTEM (Instant & Transparan) ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyHub_ViolenceDistrict"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Button Open/Close (Responsif di HP)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 90, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.Text = "CLOSE"
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 240)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.5 -- Transparansi 0.5 sesuai preferensimu
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.Parent = ScreenGui

-- Fungsi Toggle Menu (Instant)
ToggleBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
        ToggleBtn.Text = "OPEN"
    else
        MainFrame.Visible = true
        ToggleBtn.Text = "CLOSE"
    end
end)

-- [[ 1. KEY SYSTEM TAB ]] --
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(1, 0, 1, 0)
KeyFrame.BackgroundTransparency = 1
KeyFrame.Parent = MainFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Text = "ENTER KEY TO ACCESS"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.TextSize = 18
KeyTitle.BackgroundTransparency = 1
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 200, 0, 35)
KeyInput.Position = UDim2.new(0.5, -100, 0.4, -17)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.TextColor3 = Color3.fromRGB(0, 255, 0)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Input Key Here..."
KeyInput.Parent = KeyFrame

local KeySubmit = Instance.new("TextButton")
KeySubmit.Size = UDim2.new(0, 120, 0, 35)
KeySubmit.Position = UDim2.new(0.5, -60, 0.7, -17)
KeySubmit.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
KeySubmit.Text = "SUBMIT"
KeySubmit.TextColor3 = Color3.fromRGB(255, 255, 255)
KeySubmit.Font = Enum.Font.SourceSansBold
KeySubmit.Parent = KeyFrame

-- [[ MAIN CHEAT INTERFACE (Hidden at start) ]] --
local CheatFrame = Instance.new("Frame")
CheatFrame.Size = UDim2.new(1, 0, 1, 0)
CheatFrame.BackgroundTransparency = 1
CheatFrame.Visible = false
CheatFrame.Parent = MainFrame

-- Tab Navigation
local TabSurvivorBtn = Instance.new("TextButton")
TabSurvivorBtn.Size = UDim2.new(0.5, 0, 0, 35)
TabSurvivorBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabSurvivorBtn.Text = "SURVIVOR"
TabSurvivorBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
TabSurvivorBtn.Parent = CheatFrame

local TabKillerBtn = Instance.new("TextButton")
TabKillerBtn.Size = UDim2.new(0.5, 0, 0, 35)
TabKillerBtn.Position = UDim2.new(0.5, 0, 0, 0)
TabKillerBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabKillerBtn.Text = "KILLER"
TabKillerBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
TabKillerBtn.Parent = CheatFrame

-- Content Containers
local SurvivorContent = Instance.new("Frame")
SurvivorContent.Size = UDim2.new(1, 0, 1, -35)
SurvivorContent.Position = UDim2.new(0, 0, 0, 35)
SurvivorContent.BackgroundTransparency = 1
SurvivorContent.Parent = CheatFrame

local KillerContent = Instance.new("Frame")
KillerContent.Size = UDim2.new(1, 0, 1, -35)
KillerContent.Position = UDim2.new(0, 0, 0, 35)
KillerContent.BackgroundTransparency = 1
KillerContent.Visible = false
KillerContent.Parent = CheatFrame

-- Switch Tab Logic (Instant)
TabSurvivorBtn.MouseButton1Click:Connect(function()
    SurvivorContent.Visible = true
    KillerContent.Visible = false
end)

TabKillerBtn.MouseButton1Click:Connect(function()
    SurvivorContent.Visible = false
    KillerContent.Visible = true
end)

-- UI Helper: Create Toggle Button
local function CreateToggle(name, pos, parent, configKey)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 260, 0, 30)
    Btn.Position = pos
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = name .. " : OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 50, 50)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 14
    Btn.Parent = parent

    Btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        if Config[configKey] then
            Btn.Text = name .. " : ON"
            Btn.TextColor3 = Color3.fromRGB(50, 255, 50)
        else
            Btn.Text = name .. " : OFF"
            Btn.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
    return Btn
end

-- Populate Survivor Tab
CreateToggle("Chams Killer (Red)", UDim2.new(0.5, -130, 0.1, 0), SurvivorContent, "ChamsKiller")
CreateToggle("Chams Survivor (Green)", UDim2.new(0.5, -130, 0.35, 0), SurvivorContent, "ChamsSurvivor")
CreateToggle("Aim Prediction / Anti-Miss", UDim2.new(0.5, -130, 0.6, 0), SurvivorContent, "SilentAimSurvivor")

-- Populate Killer Tab
CreateToggle("Aimbot Lock (Closest)", UDim2.new(0.5, -130, 0.1, 0), KillerContent, "AimbotVeil")
CreateToggle("Veil Prediction (Anti-Miss)", UDim2.new(0.5, -130, 0.35, 0), KillerContent, "SilentAimVeil")
CreateToggle("Show Veil Line to Target", UDim2.new(0.5, -130, 0.6, 0), KillerContent, "ShowVeilLine")

-- Key Verification Trigger
KeySubmit.MouseButton1Click:Connect(function()
    if KeyInput.Text == Config.CorrectKey then
        Config.KeyVerified = true
        KeyFrame.Visible = false
        CheatFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "WRONG KEY! Try Again."
    end
end)


-- [[ FUNCTIONALITIES & GAMEPLAY MECHANICS ]] --

-- Fungsi Cari Player Terdekat (Untuk Aimbot/Silent Aim)
local function GetClosestPlayer()
    local Target = nil
    local ShortestDistance = math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if OnScreen then
                local MousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) -- Center of screen for mobile
                local Mag = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                if Mag < ShortestDistance then
                    ShortestDistance = Mag
                    Target = v
                end
            end
        end
    end
    return Target
end

-- [[ CHAMS MECHANIC (Highlight) ]] --
local function ApplyChams(player, color)
    if player.Character then
        local Highlight = player.Character:FindFirstChildOfClass("Highlight")
        if not Highlight then
            Highlight = Instance.new("Highlight")
            Highlight.Parent = player.Character
        end
        Highlight.FillColor = color
        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        Highlight.FillTransparency = 0.4
        Highlight.OutlineTransparency = 0
        Highlight.Enabled = true
    end
end

local function RemoveChams(player)
    if player.Character then
        local Highlight = player.Character:FindFirstChildOfClass("Highlight")
        if Highlight then
            Highlight:Destroy()
        end
    end
end

-- [[ TRACER LINE MECHANIC ]] --
local LineDrawing = Drawing.new("Line")
LineDrawing.Visible = false
LineDrawing.Color = Color3.fromRGB(0, 255, 0)
LineDrawing.Thickness = 2
LineDrawing.Transparency = 1

-- [[ MAIN LOOP (RenderStepped untuk Responsivitas Tinggi) ]] --
RunService.RenderStepped:Connect(function()
    if not Config.KeyVerified then return end

    CurrentTarget = GetClosestPlayer()

    -- Manage Chams & Roles
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            -- Note: Penentuan role "Killer" atau "Survivor" idealnya membaca ObjectValue/Team bawaan game.
            -- Script ini menggunakan deteksi general, kamu bisa menyesuaikan string "Killer" dengan sistem spesifik gamenya.
            local isKiller = p:GetAttribute("Role") == "Killer" or p.Name:lower():find("killer") 
            
            if Config.ChamsKiller and isKiller then
                ApplyChams(p, Color3.fromRGB(255, 0, 0)) -- Merah Full
            elseif Config.ChamsSurvivor and not isKiller then
                ApplyChams(p, Color3.fromRGB(0, 255, 0)) -- Hijau Full
            else
                RemoveChams(p)
            end
        end
    end

    -- Aimbot Veil Lock Camera
    if Config.AimbotVeil and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, CurrentTarget.Character.HumanoidRootPart.Position)
    end

    -- Visualisasi Line Hijau ke Target (Veil Line)
    if Config.ShowVeilLine and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(CurrentTarget.Character.HumanoidRootPart.Position)
        if OnScreen then
            LineDrawing.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            LineDrawing.To = Vector2.new(ScreenPos.X, ScreenPos.Y)
            LineDrawing.Visible = true
        else
            LineDrawing.Visible = false
        end
    else
        LineDrawing.Visible = false
    end
end)

-- [[ SILENT AIM & ANTI-MISS ENGINE (HookMetamethod) ]] --
-- System ini memanipulasi arah peluru/tombak secara langsung (Metatable Hook) sehingga dipaksa kena target terdekat.
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()

    if not checkcaller() and (Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRay" or Method == "Raycast") then
        if (Config.SilentAimSurvivor or Config.SilentAimVeil) and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
            -- Memodifikasi arah vector raycast langsung menuju target root part (Anti Miss Bergaransi)
            local TargetPart = CurrentTarget.Character.HumanoidRootPart
            if Args[1] and typeof(Args[1]) == "Ray" then
                Args[1] = Ray.new(Args[1].Origin, (TargetPart.Position - Args[1].Origin).Unit * 9999)
            end
        end
    end
    return OldNamecall(Self, unpack(Args))
end)

-- Pembersihan Gambar saat Script Dihentikan
LocalPlayer.CharacterAdding:Connect(function()
    LineDrawing.Visible = false
end)
