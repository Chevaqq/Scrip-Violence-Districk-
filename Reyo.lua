-- VIOLENCE DISTRICT - SIMPLE AIMLOCK & TRACER (WORKING VERSION)
-- Jalankan dengan: loadstring(game:HttpGet("https://raw.githubusercontent.com/Chevaqq/Scrip-Violence-Districk-/refs/heads/main/Simple_AimLock.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- CONFIG
local AimLockActive = false
local TracerActive = false
local TargetPlayer = nil

-- FUNGSI: Cari target terdekat
local function getClosestTarget()
    local closestDist = math.huge
    local closestTarget = nil
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = p.Character:FindFirstChild("Humanoid")
            
            if targetRoot and targetHum and targetHum.Health > 0 then
                local dist = (targetRoot.Position - humanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestTarget = p.Character
                end
            end
        end
    end
    return closestTarget
end

-- FUNGSI: Buat tracer line
local function makeTracerLine(from, to, color)
    local line = Instance.new("Part")
    line.Shape = Enum.PartType.Cylinder
    line.Material = Enum.Material.Neon
    line.Color = color
    line.CanCollide = false
    line.CFrame = CFrame.new((from + to) / 2, to)
    line.Size = Vector3.new(0.2, (from - to).Magnitude, 0.2)
    line.Parent = workspace
    game:GetService("Debris"):AddItem(line, 0.05)
end

-- FUNGSI: AimLock
local function doAimLock()
    if not AimLockActive then return end
    
    TargetPlayer = getClosestTarget()
    if TargetPlayer then
        local targetRoot = TargetPlayer:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, targetRoot.Position)
        end
    end
end

-- FUNGSI: Tracer
local function doTracer()
    if not TracerActive then return end
    
    TargetPlayer = getClosestTarget()
    if TargetPlayer then
        local targetRoot = TargetPlayer:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            makeTracerLine(humanoidRootPart.Position, targetRoot.Position, Color3.fromRGB(255, 140, 0))
        end
    end
end

-- KEYBIND
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        AimLockActive = not AimLockActive
        print(AimLockActive and "✅ AIMLOCK ON" or "❌ AIMLOCK OFF")
    end
    
    if input.KeyCode == Enum.KeyCode.R then
        TracerActive = not TracerActive
        print(TracerActive and "✅ TRACER ON" or "❌ TRACER OFF")
    end
end)

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    if character and humanoidRootPart.Parent then
        doAimLock()
        doTracer()
    end
end)

print("="..string.rep("=", 40))
print("🎯 VIOLENCE DISTRICT SCRIPT LOADED!")
print("="..string.rep("=", 40))
print("📌 Press E = Toggle AimLock")
print("📌 Press R = Toggle Tracer Line")
print("="..string.rep("=", 40))
