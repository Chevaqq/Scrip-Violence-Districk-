-- Memuat UI Library (Orion) agar pas dengan Delta Executor
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Tracer & Anti-Stuck (Delta)", HidePremium = false, SaveConfig = true, ConfigFolder = "DeltaTracer"})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- CONFIGURATION
local KILLER_NAME = "Killer" -- Ubah sesuai nama killer/role di game kamu
local TRACER_COLOR = Color3.fromRGB(255, 0, 0)
local TRACER_THICKNESS = 0.15

-- State Fitur
local _G = getgenv() -- Menggunakan global environment executor
_G.FeatureEnabled = true

-- 1. FUNGSI TRACER LINE (LOCK TO KILLER)
local function createTracer(startPosition, targetPosition)
    local distance = (startPosition - targetPosition).Magnitude
    local tracer = Instance.new("Part")
    
    tracer.Name = "BulletTracer"
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Material = Enum.Material.Neon
    tracer.Color = TRACER_COLOR
    tracer.Size = Vector3.new(TRACER_THICKNESS, TRACER_THICKNESS, distance)
    
    tracer.CFrame = CFrame.lookAt(startPosition, targetPosition) * CFrame.new(0, 0, -distance/2)
    tracer.Parent = workspace
    
    Debris:AddItem(tracer, 0.5) -- Hilang setelah 0.5 detik (peluru sampai)
end

-- Deteksi klik nembak
mouse.Button1Down:Connect(function()
    if not _G.FeatureEnabled then return end
    
    local character = localPlayer.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        local killerModel = workspace:FindFirstChild(KILLER_NAME)
        if killerModel and killerModel:FindFirstChild("HumanoidRootPart") then
            local startPos = tool:FindFirstChild("Handle") and tool.Handle.Position or character.HumanoidRootPart.Position
            local killerPos = killerModel.HumanoidRootPart.Position
            
            createTracer(startPos, killerPos)
        end
    end
end)

-- 2. FUNGSI ANTI-STUCK PISTOL
local lastPosition = Vector3.new()
local stuckTimer = 0

RunService.Heartbeat:Connect(function(dt)
    if not _G.FeatureEnabled then return end
    
    local character = localPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local tool = character and character:FindFirstChildOfClass("Tool")
    
    if hrp and tool then
        local currentPosition = hrp.Position
        local distanceMoved = (currentPosition - lastPosition).Magnitude
        
        if distanceMoved < 0.1 then
            stuckTimer = stuckTimer + dt
            if stuckTimer >= 1.5 then -- Jika stuck 1.5 detik saat pegang pistol
                hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * -5 + Vector3.new(0, 30, 0) -- Unstuck
                stuckTimer = 0
            end
        else
            stuckTimer = 0
        end
        lastPosition = currentPosition
    else
        stuckTimer = 0
    end
end)

-- TAB UI UNTUK DELTA EXECUTOR
local MainTab = Window:MakeTab({
    Name = "Main Features",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Tombol Open/Close (Toggle) di dalam Menu Delta
MainTab:AddToggle({
    Name = "Enable Tracer & Anti-Stuck",
    Default = true,
    Callback = function(Value)
        _G.FeatureEnabled = Value
    end    
})

OrionLib:Init()
