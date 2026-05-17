-- Memuat UI Library yang sangat ringan & anti-gagal untuk Delta Executor
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Violence District - Helper", "BloodTheme")

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

-- Fungsi mencari Killer (Mendeteksi musuh terdekat atau player lain yang memegang senjata)
local function getKiller()
    local closestKiller = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Violence District sering menyembunyikan status, kita deteksi berdasarkan jarak terdekat/musuh aktif
            local distance = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestKiller = player.Character
            end
        end
    end
    return closestKiller
end

-- 1. TRACER LINE (Muncul saat menembak & Lock ke Killer)
local function drawTracer(startPos, targetPos)
    local distance = (startPos - targetPos).Magnitude
    local tracer = Instance.new("Part")
    
    tracer.Name = "VD_Tracer"
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Material = Enum.Material.Neon
    tracer.Color = TRACER_COLOR
    tracer.Size = Vector3.new(TRACER_THICKNESS, TRACER_THICKNESS, distance)
    
    -- Mengunci arah garis dari senjata ke killer
    tracer.CFrame = CFrame.lookAt(startPos, targetPos) * CFrame.new(0, 0, -distance/2)
    tracer.Parent = Workspace
    
    -- Langsung hapus begitu peluru sampai (0.2 detik sangat ideal untuk game fast-paced)
    Debris:AddItem(tracer, 0.2)
end

-- Deteksi tembakan khusus Violence District (Mendeteksi klik mouse saat combat mode)
mouse.Button1Down:Connect(function()
    if not getgenv().TracerEnabled then return end
    
    local char = localPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    -- Deteksi senjata di Violence District (biasanya berada di dalam model karakter, bukan tool biasa)
    local weapon = char:FindFirstChild("Weapon") or char:FindFirstChildOfClass("Model")
    if weapon then
        local killer = getKiller()
        if killer and killer:FindFirstChild("HumanoidRootPart") then
            -- Ambil posisi dari kepala/tangan karaktermu ke badan Killer
            local startPos = char.Head.Position
            local killerPos = killer.HumanoidRootPart.Position
            
            drawTracer(startPos, killerPos)
        end
    end
end)

-- 2. ANTI-STUCK PISTOL (Khusus map & celah di Violence District)
local lastPos = Vector3.new()
local stuckDuration = 0

RunService.Heartbeat:Connect(function(dt)
    if not getgenv().AntiStuckEnabled then return end
    
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        local currentPos = hrp.Position
        local dist = (currentPos - lastPos).Magnitude
        
        -- Jika terjebak di tembok/stuck saat baku tembak
        if dist < 0.1 then
            stuckDuration = stuckDuration + dt
            if stuckDuration >= 1.2 then -- Jika stuck lebih dari 1.2 detik
                -- Dorong karakter sedikit ke atas dan belakang untuk lepas dari glitch tembok
                hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * -8 + Vector3.new(0, 35, 0)
                stuckDuration = 0
            end
        else
            stuckDuration = 0
        end
        lastPos = currentPos
    else
        stuckDuration = 0
    end
end)

-- SECTIONS UI (Kavo Library - Sangat Lancar di Delta Mobile)
local Tab = Window:NewTab("Main Features")
local Section = Tab:NewSection("Violence District Toggles")

-- Tombol Open/Close Fitur di Menu Delta
Section:NewToggle("Enable Bullet Tracer", "Garis peluru mengunci ke killer", function(state)
    getgenv().TracerEnabled = state
end)

Section:NewToggle("Anti-Stuck Pistol/Glitches", "Auto lepas jika tersangkut di map", function(state)
    getgenv().AntiStuckEnabled = state
end)

-- Tombol Rahasia Untuk Membuka/Menutup UI Semuanya (Gunakan Kunci Kanan Layar/Bawaan Kavo)
Section:NewKeybind("Minimize UI Key", "Tekan tombol ini jika ingin menyembunyikan GUI", Enum.KeyCode.RightControl, function()
	Library:ToggleUI()
end)
