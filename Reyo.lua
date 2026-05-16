-- [[ VIOLENCE DISTRICT COMMERCIAL SCRIPT - ADVANCED PREDICTION EDITION ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Bersihkan UI duplikat untuk mencegah kebocoran memori
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("ZentazzPremiumV4") then
    CoreGui.ZentazzPremiumV4:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZentazzPremiumV4"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- UI FRAME PREMIUM (Hitam Transparan 0.5)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- [[ SCRIPT DRAG KHUSUS MOBILE ]] --
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

local Title = Instance.new("TextLabel")
Title.Text = "ZENTAZZ V4 - PREDICTION PRESETS"
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 110, 0)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 75, 0, 35)
ToggleBtn.Position = UDim2.new(0, 20, 0, 200)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 110, 0)
ToggleBtn.Text = "CLOSE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
        ToggleBtn.Text = "OPEN"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 110, 0)
    else
        MainFrame.Visible = true
        ToggleBtn.Text = "CLOSE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end
end)

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -30, 1, -60)
ContentContainer.Position = UDim2.new(0, 15, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local PageList = Instance.new("UIListLayout")
PageList.Padding = UDim.new(0, 6)
PageList.Parent = ContentContainer

local function AddButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = ContentContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- ==================================================
-- CORE CRITICAL LOGIC: HOMING SILENT AIM WITH VELOCITY PREDICTION
-- ==================================================
local AimEnabled = false
local BulletSpeed = 850 -- Nilai default kecepatan proyektil (dapat disesuaikan dengan weapon game)

-- Fungsi penentu target Killer
local function GetKillerTarget()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character:FindFirstChildOfClass("BillboardGui") or player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChildOfClass("BillboardGui") then
                return player.Character.HumanoidRootPart
            end
            if player:FindFirstChild("Killer") or (player.Team and string.find(player.Team.Name:lower(), "kill")) then
                return player.Character.HumanoidRootPart
            end
        end
    end
    
    local closest = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; closest = p.Character.HumanoidRootPart end
        end
    end
    return closest
end

-- Kalkulasi Prediksi Berdasarkan Kecepatan Target (Velocity)
local function GetPredictedPosition(origin, targetPart)
    local currentPos = targetPart.Position
    local velocity = targetPart.Velocity
    local distance = (currentPos - origin).Magnitude
    
    -- Estimasi waktu tempuh proyektil menuju target
    local timeToTarget = distance / BulletSpeed
    
    -- Posisi masa depan target saat peluru diperkirakan sampai
    local predictedPos = currentPos + (velocity * timeToTarget)
    return predictedPos
end

-- Pembuatan Tracer Line Dinamis
local function SpawnDynamicTracer(startPos, endPos)
    local Line = Instance.new("Part")
    Line.Anchored = true
    Line.CanCollide = false
    Line.Color = Color3.fromRGB(255, 110, 0)
    Line.Material = Enum.Material.Neon
    Line.Parent = Workspace

    local distance = (endPos - startPos).Magnitude
    Line.Size = Vector3.new(0.2, 0.2, distance)
    Line.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance/2)

    local travelTime = math.clamp(distance / (BulletSpeed * 1.2), 0.02, 0.18)
    task.wait(travelTime)
    Line:Destroy()
end

-- INJEKSI INTERSEPSI VIA METATABLE NAMECALL HOOKING
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall

gmt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if AimEnabled and not checkcaller() then
        -- 1. Intersepsi Raycast Modern API
        if method == "Raycast" then
            local target = GetKillerTarget()
            if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local origin = args[1]
                local predictedTargetPos = GetPredictedPosition(origin, target)
                
                task.spawn(SpawnDynamicTracer, origin, predictedTargetPos)
                
                args[2] = (predictedTargetPos - origin).Unit * 1000
                return oldNamecall(self, unpack(args))
            end
            
        -- 2. Intersepsi Raycast Legacy API
        elseif method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" then
            local target = GetKillerTarget()
            if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local origin = LocalPlayer.Character.HumanoidRootPart.Position
                local predictedTargetPos = GetPredictedPosition(origin, target)
                
                task.spawn(SpawnDynamicTracer, origin, predictedTargetPos)
                
                args[1] = Ray.new(origin, (predictedTargetPos - origin).Unit * 1000)
                return oldNamecall(self, unpack(args))
            end
            
        -- 3. Intersepsi Pengiriman Remote Event Data Posisi Mentah (FireServer)
        elseif method == "FireServer" or method == "InvokeServer" then
            local target = GetKillerTarget()
            if target then
                local origin = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
                local predictedTargetPos = GetPredictedPosition(origin, target)
                
                for i, arg in pairs(args) do
                    if typeof(arg) == "Vector3" then
                        if origin == Vector3.new(0,0,0) then origin = arg end
                        task.spawn(SpawnDynamicTracer, origin, predictedTargetPos)
                        args[i] = predictedTargetPos
                        return oldNamecall(self, unpack(args))
                    elseif typeof(arg) == "CFrame" then
                        if origin == Vector3.new(0,0,0) then origin = arg.Position end
                        task.spawn(SpawnOrangeTracer, origin, predictedTargetPos)
                        args[i] = CFrame.new(arg.Position, predictedTargetPos)
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(gmt, true)

-- Tombol Aktivasi Utama
local MainButton = AddButton("Silent Aim + Prediction: OFF", function()
    AimEnabled = not AimEnabled
    local btn = ContentContainer:FindFirstChildOfClass("TextButton")
    if AimEnabled then
        btn.Text = "Silent Aim + Prediction: ACTIVE"
        btn.TextColor3 = Color3.fromRGB(255, 110, 0)
    else
        btn.Text = "Silent Aim + Prediction: OFF"
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    end
end)
