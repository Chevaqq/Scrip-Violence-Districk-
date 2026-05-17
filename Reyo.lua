-- SCRIPT AIMLOCK & TRACER LINE UNTUK DELTA EXECUTOR
-- Paste ke Delta Executor Console

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- CONFIG
local AIMLOCK_ENABLED = false
local CURRENT_KILLER = nil
local BARREL_OFFSET = Vector3.new(0, 2, 5)
local BULLET_SPEED = 150
local BULLET_DAMAGE = 50

-- FUNGSI: Cari Killer Terdekat
local function findClosestKiller()
    local closestDistance = math.huge
    local closestKiller = nil
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherChar = otherPlayer.Character
            local otherHumanoid = otherChar:FindFirstChild("Humanoid")
            
            if otherHumanoid and otherHumanoid.Health > 0 then
                local distance = (otherChar.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                
                if distance < closestDistance then
                    closestDistance = distance
                    closestKiller = otherChar
                end
            end
        end
    end
    
    return closestKiller
end

-- FUNGSI: Buat Tracer Line
local function createTracerLine(startPos, endPos, isHit)
    local line = Instance.new("Part")
    line.Shape = Enum.PartType.Cylinder
    line.Material = Enum.Material.Neon
    line.Color = isHit and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 165, 0) -- Merah atau Orange
    line.CanCollide = false
    line.CFrame = CFrame.new((startPos + endPos) / 2, endPos)
    line.Size = Vector3.new(0.15, (startPos - endPos).Magnitude, 0.15)
    line.TopSurface = Enum.SurfaceType.Smooth
    line.BottomSurface = Enum.SurfaceType.Smooth
    line.Parent = workspace
    
    game:GetService("Debris"):AddItem(line, 0.15)
end

-- FUNGSI: Spawn Peluru
local function spawnBullet(barrelPos, targetPos)
    local bullet = Instance.new("Part")
    bullet.Name = "Bullet_" .. math.random(1, 99999)
    bullet.Shape = Enum.PartType.Ball
    bullet.Size = Vector3.new(0.5, 0.5, 0.5)
    bullet.Color = Color3.fromRGB(255, 200, 0) -- Orange
    bullet.Material = Enum.Material.Neon
    bullet.CanCollide = false
    bullet.CFrame = CFrame.new(barrelPos)
    bullet.Parent = workspace
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = (targetPos - barrelPos).Unit * BULLET_SPEED
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = bullet
    
    local hitTarget = false
    local elapsedTime = 0
    local maxDuration = 10 -- 10 detik sebelum bullet hilang
    
    local connection
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        elapsedTime = elapsedTime + deltaTime
        
        if not bullet.Parent or elapsedTime > maxDuration then
            connection:Disconnect()
            bullet:Destroy()
            return
        end
        
        if CURRENT_KILLER then
            local targetHumanoidRootPart = CURRENT_KILLER:FindFirstChild("HumanoidRootPart")
            
            if targetHumanoidRootPart then
                local distance = (bullet.Position - targetHumanoidRootPart.Position).Magnitude
                
                -- Update arah ke target (anti-stuck)
                bodyVelocity.Velocity = (targetHumanoidRootPart.Position - bullet.Position).Unit * BULLET_SPEED
                
                -- Buat tracer line
                createTracerLine(barrelPos, bullet.Position, hitTarget)
                
                -- Cek collision dengan target
                if distance < 3 and not hitTarget then
                    hitTarget = true
                    bullet.Color = Color3.fromRGB(255, 0, 0) -- Merah
                    
                    -- Damage target
                    local targetHumanoid = CURRENT_KILLER:FindFirstChild("Humanoid")
                    if targetHumanoid then
                        targetHumanoid:TakeDamage(BULLET_DAMAGE)
                    end
                    
                    -- Hapus bullet
                    game:GetService("Debris"):AddItem(bullet, 0.3)
                    connection:Disconnect()
                end
            end
        end
    end)
end

-- FUNGSI: AimLock
local function aimLockToKiller()
    if not AIMLOCK_ENABLED or not CURRENT_KILLER then return end
    
    local targetPos = CURRENT_KILLER:FindFirstChild("HumanoidRootPart").Position
    local myPos = character:FindFirstChild("HumanoidRootPart").Position
    
    character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(myPos, targetPos)
end

-- FUNGSI: Tembak
local function shoot()
    if not AIMLOCK_ENABLED then
        print("⚠️ AimLock belum diaktifkan!")
        return
    end
    
    CURRENT_KILLER = findClosestKiller()
    
    if CURRENT_KILLER then
        local myRootPart = character:FindFirstChild("HumanoidRootPart")
        local barrelPos = myRootPart.Position + BARREL_OFFSET
        local targetPos = CURRENT_KILLER:FindFirstChild("HumanoidRootPart").Position
        
        spawnBullet(barrelPos, targetPos)
        print("🎯 Peluru Ditembak!")
    else
        print("❌ Tidak ada target ditemukan!")
    end
end

-- INPUT: Tekan E untuk AimLock, F untuk Tembak
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        AIMLOCK_ENABLED = not AIMLOCK_ENABLED
        print(AIMLOCK_ENABLED and "✅ AimLock: ON" or "❌ AimLock: OFF")
    elseif input.KeyCode == Enum.KeyCode.F then
        shoot()
    end
end)

-- Loop AimLock
RunService.RenderStepped:Connect(function()
    aimLockToKiller()
end)

print("="..string.rep("=", 30))
print("🎮 DELTA EXECUTOR - AIMLOCK & TRACER")
print("="..string.rep("=", 30))
print("📌 Tekan E = Toggle AimLock")
print("📌 Tekan F = Tembak")
print("="..string.rep("=", 30))
