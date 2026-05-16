-- [[ VIOLENCE DISTRICT COMMERCIAL HUBS - ZENTAZZ V5 FINAL PRESET ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Memastikan UI bersih di CoreGui biar anti-hilang dari lobi ke in-game
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("ZentazzPremiumV5") then
    CoreGui.ZentazzPremiumV5:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZentazzPremiumV5"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- UI FRAME UTAMA (Premium Hitam Transparan 0.5)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- [[ DRAG SYSTEM LAYAR HP ANTI-LAG ]] --
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

-- TITLE BAR
local Title = Instance.new("TextLabel")
Title.Text = "ZENTAZZ HUB V5 - EDITION"
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 110, 0) -- Orange Neon Premium
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- TOGGLE OPEN/CLOSE BUTTON
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 75, 0, 35)
ToggleBtn.Position = UDim2.new(0, 20, 0, 220)
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

-- SCROLLING CONTAINER FITUR (Biar rapi muat banyak tombol pisahan)
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -30, 1, -60)
ContentContainer.Position = UDim2.new(0, 15, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ScrollBarThickness = 2
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 220)
ContentContainer.Parent = MainFrame

local PageList = Instance.new("UIListLayout")
PageList.Padding = UDim.new(0, 6)
PageList.Parent = ContentContainer

local function AddToggle(text, defaultState, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 45)
    Btn.BackgroundColor3 = defaultState and Color3.fromRGB(45, 30, 20) or Color3.fromRGB(30, 30, 30)
    Btn.Text = text .. (defaultState and ": ON" or ": OFF")
    Btn.TextColor3 = defaultState and Color3.fromRGB(255, 110, 0) or Color3.fromRGB(200, 200, 200)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = ContentContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Btn
    
    local state = defaultState
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. (state and ": ON" or ": OFF")
        Btn.BackgroundColor3 = state and Color3.fromRGB(45, 30, 20) or Color3.fromRGB(30, 30, 30)
        Btn.TextColor3 = state and Color3.fromRGB(255, 110, 0) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
    return Btn
end

-- ==================================================
-- MODULAR LOGIC CORE: SEPARATED STATUS VALUES
-- ==================================================
local AimlockEnabled = false
local PredictionEnabled = false
local TracerEnabled = false

local BulletSpeed = 900 -- Estimasi kecepatan peluru proyektil game

-- Fungsi pendeteksi target Killer via BillboardGui data game
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

-- Rumus Prediksi Kecepatan Linear Target (Velocity)
local function CalculatePrediction(origin, targetPart)
    local currentPos = targetPart.Position
    if not PredictionEnabled then return currentPos end
    
    local velocity = targetPart.Velocity
    local distance = (currentPos - origin).Magnitude
    local timeToTarget = distance / BulletSpeed
    
    return currentPos + (velocity * timeToTarget)
end

-- Fungsi Pembuat Tracer Line Dinamis (Hanya aktif pas nembak & hilang pas sampai target)
local function SpawnDynamicTracer(startPos, endPos)
    if not TracerEnabled then return end
    
    local Line = Instance.new("Part")
    Line.Anchored = true
    Line.CanCollide = false
    Line.Color = Color3.fromRGB(255, 110, 0)
    Line.Material = Enum.Material.Neon
    Line.Parent = Workspace

    local distance = (endPos - startPos).Magnitude
    Line.Size = Vector3.new(0.2, 0.2, distance)
    Line.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance/2)

    -- Kecepatan line menghilang seiring jarak peluru (Dinamis)
    local travelTime = math.clamp(distance / (BulletSpeed * 1.1), 0.03, 0.16)
    task.wait(travelTime)
    Line:Destroy()
end

-- METATABLE INTERCEPTION - MODULAR HANDLING (KAMERA ANTI-STUCK)
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall

gmt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if not checkcaller() then
        -- 1. Intersepsi Raycast Baru API
        if method == "Raycast" and AimlockEnabled then
            local target = GetKillerTarget()
            if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local origin = args[1]
                local finalDestination = CalculatePrediction(origin, target)
                
                task.spawn(SpawnDynamicTracer, origin, finalDestination)
                args[2] = (finalDestination - origin).Unit * 1000
                return oldNamecall(self, unpack(args))
            end
            
        -- 2. Intersepsi Raycast Lama API
        elseif (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay") and AimlockEnabled then
            local target = GetKillerTarget()
            if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local origin = LocalPlayer.Character.HumanoidRootPart.Position
                local finalDestination = CalculatePrediction(origin, target)
                
                task.spawn(SpawnDynamicTracer, origin, finalDestination)
                args[1] = Ray.new(origin, (finalDestination - origin).Unit * 1000)
                return oldNamecall(self, unpack(args))
            end
            
        -- 3. Intersepsi Pengiriman Remote Event Tembakan Senjata (FireServer)
        elseif (method == "FireServer" or method == "InvokeServer") and AimlockEnabled then
            local target = GetKillerTarget()
            if target then
                local origin = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
                local finalDestination = CalculatePrediction(origin, target)
                
                for i, arg in pairs(args) do
                    if typeof(arg) == "Vector3" then
                        if origin == Vector3.new(0,0,0) then origin = arg end
                        task.spawn(SpawnDynamicTracer, origin, finalDestination)
                        args[i] = finalDestination
                        return oldNamecall(self, unpack(args))
                    elseif typeof(arg) == "CFrame" then
                        if origin == Vector3.new(0,0,0) then origin = arg.Position end
                        task.spawn(SpawnDynamicTracer, origin, finalDestination)
                        args[i] = CFrame.new(arg.Position, finalDestination)
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(gmt, true)

-- [[ MEMASANG TOMBOL TOGGLE SEPARATED SECARA PISAH ]] --
AddToggle("Silent Aimlock", false, function(state)
    AimlockEnabled = state
end)

AddToggle("Aim Prediction", false, function(state)
    PredictionEnabled = state
end)

AddToggle("Orange Tracer Line", false, function(state)
    TracerEnabled = state
end)
