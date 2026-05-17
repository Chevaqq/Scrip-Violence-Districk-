local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Violence District - Fix", "BloodTheme")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- CONFIGURATION & STATE
getgenv().TracerEnabled = true
getgenv().AntiStuckEnabled = true

local TRACER_COLOR = Color3.fromRGB(255, 0, 0)
local TRACER_THICKNESS = 0.2
local canShootTracer = true -- Cooldown agar tidak spam line merah

-- TAMBAHAN: MEMBUAT TOMBOL OPEN/CLOSE MANUAL UNTUK MOBILE/DELTA
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("DeltaOpenCloseButton") then
    CoreGui.DeltaOpenCloseButton:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "DeltaOpenCloseButton"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0) -- Posisi di kiri layar agak ke atas
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)       -- Tombol bulat ukuran pas
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "MENU"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14.0

UICorner.CornerRadius = UDim.new(1, 0) -- Membuat tombol jadi bulat sempurna
UICorner.Parent = ToggleBtn

-- Fungsi Klik Tombol Menu Buka/Tutup
ToggleBtn.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)

-- Fungsi mencari Killer/Musuh terdekat
local function getKiller()
    local closestKiller = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestKiller = player.Character
            end
        end
    end
    return closestKiller
end

-- 1. TRACER LINE (FIX: COOLDOWN & SINGLE SHOT)
local function drawTracer(startPos, targetPos)
    local distance = (startPos - targetPos).Magnitude
    local tracer = Instance.new("Part")
    
    tracer.Name = "VD_Tracer"
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Material = Enum.Material.Neon
    tracer.Color = TRACER_COLOR
    tracer.Size = Vector3.new(TRACER_THICKNESS, TRACER_THICKNESS, distance)
    
    tracer.CFrame = CFrame.lookAt(startPos, targetPos) * CFrame.new(0, 0, -distance/2)
    tracer.Parent = Workspace
    
    Debris:AddItem(tracer, 0.15) -- Dihapus cepat agar tidak menumpuk di map
end

-- Deteksi Anti-Stuck dan Tembakan secara presisi saat klik kiri saja
mouse.Button1Down:Connect(function()
    local char = localPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    -- [ANTI-STUCK FIX]: Hanya aktif jika menembak DAN posisi macet/stuck di tempat
    if getgenv().AntiStuckEnabled then
        local oldPos = char.HumanoidRootPart.Position
        task.wait(0.05) -- Cek pergerakan dalam waktu singkat saat klik
        if char and char:FindFirstChild("HumanoidRootPart") then
            local newPos = char.HumanoidRootPart.Position
            if (newPos - oldPos).Magnitude < 0.1 then
                -- Lepaskan karakter jika tersangkut saat baku tembak
                char.HumanoidRootPart.AssemblyLinearVelocity = char.HumanoidRootPart.CFrame.LookVector * -6 + Vector3.new(0, 32, 0)
            end
        end
    end

    -- [TRACER FIX]: Kasih jeda tipis agar tidak bikin garis merah tanpa henti (Spam)
    if getgenv().TracerEnabled and canShootTracer then
        canShootTracer = false
        
        local weapon = char:FindFirstChild("Weapon") or char:FindFirstChildOfClass("Model")
        if weapon then
            local killer = getKiller()
            if killer and killer:FindFirstChild("HumanoidRootPart") then
                local startPos = char.Head.Position
                local killerPos = killer.HumanoidRootPart.Position
                
                drawTracer(startPos, killerPos)
            end
        end
        
        task.wait(0.1) -- Cooldown peluru (0.1 detik)
        canShootTracer = true
    end
end)

-- SECTIONS UI
local Tab = Window:NewTab("Main Features")
local Section = Tab:NewSection("Violence District Toggles")

Section:NewToggle("Enable Bullet Tracer", "Garis peluru mengunci ke killer", function(state)
    getgenv().TracerEnabled = state
end)

Section:NewToggle("Anti-Stuck Pistol/Glitches", "Auto lepas jika tersangkut saat nembak", function(state)
    getgenv().AntiStuckEnabled = state
end)
