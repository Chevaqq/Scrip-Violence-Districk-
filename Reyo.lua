-- [[ VIOLENCE DISTRICT COMMERCIAL SCRIPT HUB - BYPASS EDITION ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

-- Proteksi UI Anti-Tumpuk & Injeksi Aman ke CoreGui
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("ViolenceDistrictUI") then
    CoreGui.ViolenceDistrictUI:Destroy()
end

-- 1. MAIN SCREEN GUI (ResetOnSpawn = false agar menetap lobi sampai game)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViolenceDistrictUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. MAIN FRAME PREMIUM (Hitam Transparan 0.5)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- [[ SCRIPT DRAG MANUAL HP ANTI-LAG ]] --
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

-- 3. TITLE BAR (Zentazz Hub Style)
local Title = Instance.new("TextLabel")
Title.Text = "ZENTAZZ V2 - VIOLENCE DISTRICT"
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 110, 0) -- Orange Neon
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- 4. BUTTON TOGGLE OPEN/CLOSE (Anti-Bug / Anti-Hilang)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 75, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0, 140) -- Posisi default aman di layar HP
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

-- 5. CONTAINER FITUR
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
-- CORE SILENT AIM & TRACER PERSIS VIDEO (ANTI-STUCK)
-- ==================================================
local AimEnabled = false

-- Fungsi pencari target Killer di dalam pertandingan
local function GetKillerTarget()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Deteksi via BillboardGui (Icon merah di atas kepala killer)
            if player.Character:FindFirstChildOfClass("BillboardGui") or player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChildOfClass("BillboardGui") then
                return player.Character.HumanoidRootPart
            end
            -- Deteksi via Nama Tim / Atribut data game
            if player:FindFirstChild("Killer") or (player.Team and string.find(player.Team.Name:lower(), "kill")) then
                return player.Character.HumanoidRootPart
            end
        end
    end
    
    -- Jaga-jaga: Auto lock player terdekat jika role killer belum terbagi
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

-- Membuat garis neon oranye tebal sekelebat (Persis seperti video yang dikirim)
local function SpawnOrangeTracer(startPos, endPos)
    local Line = Instance.new("Part")
    Line.Anchored = true
    Line.CanCollide = false
    Line.Color = Color3.fromRGB(255, 110, 0)
    Line.Material = Enum.Material.Neon
    Line.Parent = Workspace

    local mag = (endPos - startPos).Magnitude
    Line.Size = Vector3.new(0.25, 0.25, mag)
    Line.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -mag/2)

    task.wait(0.08) -- Durasi kedipan laser peluru
    Line:Destroy()
end

-- HOOKING METATABLE SECARA RELEVAN & BERSIH (PERBAIKAN TOTAL ANTI-STUCK)
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall

gmt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if AimEnabled and not checkcaller() then
        -- Deteksi pengiriman Remote Event senjata bawaan game saat menembak
        if method == "FireServer" or method == "InvokeServer" then
            local target = GetKillerTarget()
            if target then
                for i, arg in pairs(args) do
                    -- Membelokkan posisi Vector3 peluru langsung ke target Killer
                    if typeof(arg) == "Vector3" then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            task.spawn(SpawnOrangeTracer, LocalPlayer.Character.HumanoidRootPart.Position, target.Position)
                        end
                        args[i] = target.Position
                        return oldNamecall(self, unpack(args))
                    -- Membelokkan sudut CFrame peluru langsung ke arah Killer
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

-- Tombol Aktivasi Utama
local MainButton = AddButton("Silent Aim + Tracer: OFF", function()
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
