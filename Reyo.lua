-- [[ VIOLENCE DISTRICT COMMERCIAL HUBS - 100% PERFECT SILENT AIM ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

-- Proteksi UI Anti-Double & Menetap di CoreGui (Gak bakal hilang dari lobi ke in-game)
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("ViolenceDistrictUI") then
    CoreGui.ViolenceDistrictUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViolenceDistrictUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- UI FRAME PREMIUM (Zentazz Style Look)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- [[ SYSTEM DRAG MOBILE - LALU LINTAS SENTUHAN AMAN ]] --
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
Title.Text = "ZENTAZZ V2 - VIOLENCE DISTRICT"
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 110, 0)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- BUTTON TOGGLE OPEN/CLOSE
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 75, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0, 140)
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
    
    Btn.MouseButton1Click:Connect(({callback})[1])
    return Btn
end

-- ==================================================
-- CORE MECHANICAL: RE-ENGINEERED ULTRA SILENT AIM & TRACER
-- ==================================================
local AimEnabled = false

local function GetKillerTarget()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Deteksi billboard target (Icon tengkorak/merah di atas kepala killer)
            if player.Character:FindFirstChildOfClass("BillboardGui") or player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChildOfClass("BillboardGui") then
                return player.Character.HumanoidRootPart
            end
            -- Deteksi tim killer
            if player:FindFirstChild("Killer") or (player.Team and string.find(player.Team.Name:lower(), "kill")) then
                return player.Character.HumanoidRootPart
            end
        end
    end
    -- Fallback lock otomatis terdekat
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

-- Fungsi pembuat tracer line orange menyala sekelebat pas nembak (Persis 100% di video)
local function SpawnOrangeTracer(startPos, endPos)
    local Line = Instance.new("Part")
    Line.Anchored = true
    Line.CanCollide = false
    Line.Color = Color3.fromRGB(255, 110, 0)
    Line.Material = Enum.Material.Neon
    Line.Parent = Workspace

    local mag = (endPos - startPos).Magnitude
    Line.Size = Vector3.new(0.25, 0.25, mag) -- Ketebalan neon disesuaikan biar tajam kayak video
    Line.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -mag/2)

    task.wait(0.08) -- Durasi sekelebat kedipan laser peluru
    Line:Destroy()
end

-- ADVANCED RAYCAST & NAMECALL HOOKING (ANTI MACET SENJATA)
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall

gmt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if AimEnabled and not checkcaller() then
        -- Deteksi fungsi Raycast global atau pemanggilan Remote Event peluru bawaan game
        if method == "Raycast" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" then
            local target = GetKillerTarget()
            if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local origin = LocalPlayer.Character.HumanoidRootPart.Position
                local targetPos = target.Position
                
                -- Bikin tracer sekelebat sinkron saat fungsi ini dipicu oleh tombol tembak game
                task.spawn(SpawnOrangeTracer, origin, targetPos)
                
                -- Membelokkan arah matematika Raycast langsung menuju koordinat Killer
                if method == "Raycast" then
                    -- args[1] adalah origin, args[2] adalah direction (Vektor tujuan)
                    args[2] = (targetPos - args[1]).Unit * 1000
                    return oldNamecall(self, unpack(args))
                elseif method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" then
                    -- Membuat Ray baru mengarah instan ke target Killer
                    args[1] = Ray.new(origin, (targetPos - origin).Unit * 1000)
                    return oldNamecall(self, unpack(args))
                end
            end
        -- Deteksi RemoteEvent jika senjata mengirim data posisi mentah ("FireServer")
         RhineMethod = (method == "FireServer" or method == "InvokeServer")
        if RhineMethod then
            local target = GetKillerTarget()
            if target then
                for i, arg in pairs(args) do
                    if typeof(arg) == "Vector3" then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            task.spawn(SpawnOrangeTracer, LocalPlayer.Character.HumanoidRootPart.Position, target.Position)
                        end
                        args[i] = target.Position
                        return oldNamecall(self, unpack(args))
                    elseif typeof(arg) == "CFrame" then
                        args[i] = CFrame.new(arg.Position, target.Position)
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(gmt, true)

-- Tombol Toggle Utama
local MainButton = AddButton("Silent Aim + Tracer: OFF", function(self)
    AimEnabled = not AimEnabled
    local btn = ContentContainer:FindFirstChildOfClass("TextButton")
    if AimEnabled then
        btn.Text = "Silent Aim + Tracer: ACTIVE"
        btn.TextColor3 = Color3.fromRGB(255, 110, 0)
    else
        btn.Text = "Silent Aim + Tracer: OFF"
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    end
end)
