-- [[ TARUH SCRIPT INI DI DALAM TOOL SENJATA LU -> LOCALSCRIPT ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Tool = script.Parent

-- [[ 1. SETTINGS & CONFIG ]] --
local Config = {
    AimlockEnabled = true, -- Fitur On/Off Aimlock
    TracerEnabled = true,  -- Fitur On/Off Garis Orange
    FOVRadius = 200,       -- Jarak maksimal lock ke Killer
    TracerColor = Color3.fromRGB(255, 100, 0), -- Orange
    DamageAmount = 25      -- Damage simulasi pas nembak
}

-- [[ 2. UI CREATION (OPEN/CLOSE BUTTON & PANEL) ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViolenceDistrictTestUI"
-- Biar aman pas testing di Studio/Mobile, taruh di PlayerGui
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Tombol Kecil buat Open/Close
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Text = "Menu"
ToggleBtn.TextSize = 14
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
ToggleBtn.Parent = ScreenGui

-- Frame Utama Menu (Hitam Transparan 0.5)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 150)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Mekanik Test Panel"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextSize = 16
Title.Parent = MainFrame

-- Fungsi Pembantu bikin Tombol Toggle Fitur
local function CreateMenuToggle(name, startState, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0.25, (order * 40))
    btn.BackgroundColor3 = startState and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name .. ": " .. (startState and "ON" or "OFF")
    Instance.new("UICorner", btn)
    btn.Parent = MainFrame
    
    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    end)
end

-- Hubungkan fungsi Open/Close Button (Instant tanpa tween biar cepat)
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CreateMenuToggle("Aimlock Peluru", Config.AimlockEnabled, 0, function()
    Config.AimlockEnabled = not Config.AimlockEnabled
    return Config.AimlockEnabled
end)

CreateMenuToggle("Tracer Orange", Config.TracerEnabled, 1, function()
    Config.TracerEnabled = not Config.TracerEnabled
    return Config.TracerEnabled
end)


-- [[ 3. MECHANICAL TARGETING LOGIC ]] --
local function AmbilKillerTerdekat()
    local target = nil
    local jarakTerdekat = Config.FOVRadius
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- Cek Tim bernama "Killer" atau atribut penanda role di game lu
            local isKiller = (p.Team and p.Team.Name:lower():find("killer")) or p:GetAttribute("Role") == "Killer"
            
            if isKiller then
                local jarak = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if jarak < jarakTerdekat then
                    target = p.Character
                    jarakTerdekat = jarak
                end
            end
        end
    end
    return target
end

-- [[ 4. TRACER LINE GENERATOR (ORANGE EFFECT) ]] --
local function BuatGarisOrange(dari, ke)
    if not Config.TracerEnabled then return end
    
    -- Menggunakan metode pembuatan part silinder kilat agar lancar di Mobile (HP)
    local tracerPart = Instance.new("Part")
    tracerPart.Name = "TestTracer"
    tracerPart.Anchored = true
    tracerPart.CanCollide = false
    tracerPart.Material = Enum.Material.Neon
    tracerPart.Color = Config.TracerColor
    tracerPart.Transparency = 0.2
    
    local jarak = (ke - dari).Magnitude
    tracerPart.Size = Vector3.new(0.15, 0.15, jarak)
    tracerPart.CFrame = CFrame.lookAt(dari, ke) * CFrame.new(0, 0, -jarak/2)
    tracerPart.Parent = workspace
    
    -- Menghilang secara instan setelah mengenai target (0.08 detik biar ada kilatan mata)
    task.delay(0.08, function()
        tracerPart:Destroy()
    end)
end


-- [[ 5. WEAPON ACTIVATION ENGINE ]] --
Tool.Activated:Connect(function()
    local karakter = LocalPlayer.Character
    if not karakter or not karakter:FindFirstChild("HumanoidRootPart") then return end
    
    -- Cek letak moncong senjata (Handle)
    local moncongPos = Tool:FindFirstChild("Handle") and Tool.Handle.Position or karakter.HumanoidRootPart.Position
    local targetKiller = AmbilKillerTerdekat()
    local targetPos = Mouse.Hit.Position -- Default tembakan ke arah kursor/tap hp
    
    if Config.AimlockEnabled and targetKiller and targetKiller:FindFirstChild("HumanoidRootPart") then
        -- MEKANIK AIMLOCK: Mengalihkan paksa posisi tujuan peluru ke arah Killer
        targetPos = targetKiller.HumanoidRootPart.Position
        
        -- Simulasi hit damage langsung ke target mekanik game lu
        if targetKiller:FindFirstChild("Humanoid") then
            targetKiller.Humanoid:TakeDamage(Config.DamageAmount)
        end
    end
    
    -- Tembakkan efek garis oranye dari moncong senjata ke target
    BuatGarisOrange(moncongPos, targetPos)
end)

-- Bersihkan UI dari layar kalau senjata dicopot/diturunkan
Tool.Unequipped:Connect(function()
    ScreenGui.Enabled = false
end)

Tool.Equipped:Connect(function()
    ScreenGui.Enabled = true
end)
