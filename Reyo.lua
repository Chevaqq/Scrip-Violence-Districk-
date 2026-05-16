-- [[ VIOLENCE DISTRICT SCRIPT HUB - REAL SHOT DETECTION ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Bersihkan UI lama jika ada
if PlayerGui:FindFirstChild("ViolenceDistrictUI") then
    PlayerGui.ViolenceDistrictUI:Destroy()
end

-- 1. MAIN SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViolenceDistrictUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- 2. MAIN FRAME
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

-- [[ SCRIPT DRAG MANUAL ]] --
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
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- 3. TITLE BAR
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VIOLENCE DISTRICT"
Title.TextColor3 = Color3.fromRGB(255, 55, 55)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- 4. BUTTON TOGGLE OPEN/CLOSE
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 70, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0, 100)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
ToggleBtn.Text = "CLOSE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
ToggleBtn.Active = true
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
        ToggleBtn.Text = "OPEN"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
    else
        MainFrame.Visible = true
        ToggleBtn.Text = "CLOSE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end
end)

-- 5. NAVIGATION TABS
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 100, 1, -50)
TabContainer.Position = UDim2.new(0, 10, 0, 45)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = TabContainer

-- 6. CONTENT CONTAINER
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -130, 1, -50)
ContentContainer.Position = UDim2.new(0, 120, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabs = {}
local function CreateTab(tabName)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.Text = tabName
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.TextSize = 12
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Parent = TabContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 2
    Page.Parent = ContentContainer
    
    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 6)
    PageList.Parent = Page

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Page.Visible = false
            t.Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
    end)

    tabs[tabName] = {Btn = TabBtn, Page = Page}
    return Page
end

local MainTab = CreateTab("Main")
tabs["Main"].Page.Visible = true
tabs["Main"].Btn.BackgroundColor3 = Color3.fromRGB(255, 55, 55)

local function AddButton(parentPage, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.Gotham
    Btn.Parent = parentPage
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
    parentPage.CanvasSize = UDim2.new(0, 0, 0, parentPage.UIListLayout.AbsoluteContentSize.Y + 10)
    return Btn
end

-- ==================================================
-- MECHANIC: TRACER LINE DETEKSI PELURU (ANTI MATAKAN)
-- ==================================================
local TracerEnabled = false
local ActiveTracer = nil

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

local function CreateOrangeLine(targetPart)
    if ActiveTracer then ActiveTracer:Destroy() end

    local Line = Instance.new("Part")
    Line.Anchored = true
    Line.CanCollide = false
    Line.Color = Color3.fromRGB(255, 110, 0) -- Orange Neon
    Line.Material = Enum.Material.Neon
    Line.Parent = Workspace
    ActiveTracer = Line

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not TracerEnabled or not Line or not targetPart or not targetPart.Parent or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if Line then Line:Destroy() end
            conn:Disconnect()
            return
        end
        local startPos = LocalPlayer.Character.HumanoidRootPart.Position
        local endPos = targetPart.Position
        local mag = (endPos - startPos).Magnitude
        Line.Size = Vector3.new(0.15, 0.15, mag)
        Line.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -mag/2)
    end)
end

-- DETEKSI TEMBAKAN ASLI (Mendeteksi saat senjata mengeluarkan peluru/efek)
local function MonitorShooting()
    -- Mendeteksi objek baru yang muncul di Workspace (biasanya peluru ber-name Bullet, Projectile, dll)
    Workspace.ChildAdded:Connect(function(child)
        if not TracerEnabled then return end
        
        -- Deteksi jika peluru dicreate game saat menembak
        if child:IsA("Part") or child:IsA("MeshPart") then
            local name = child.Name:lower()
            if string.find(name, "bullet") or string.find(name, "peluru") or string.find(name, "part") then
                local target = GetKillerTarget()
                if target then
                    CreateOrangeLine(target)
                    task.wait(0.12) -- Langsung hilang begitu peluru sampai target
                    if ActiveTracer then ActiveTracer:Destroy(); ActiveTracer = nil end
                end
            end
        end
    end)

    -- Alternatif deteksi: Jika game memasukkan efek peluru di dalam tool/senjata karakter
    LocalPlayer.CharacterAdded:Connect(function(char)
        char.DescendantAdded:Connect(function(descendant)
            if not TracerEnabled then return end
            -- Mendeteksi efek suara "Shot", "Fire", atau efek visual "Muzzle" pas nembak
            if descendant:IsA("Sound") and (string.find(descendant.Name:lower(), "shot") or string.find(descendant.Name:lower(), "fire")) then
                local target = GetKillerTarget()
                if target then
                    CreateOrangeLine(target)
                    task.wait(0.12)
                    if ActiveTracer then ActiveTracer:Destroy(); ActiveTracer = nil end
                end
            end
        end)
    end)
end

-- Jalankan fungsi monitor tembakan
MonitorShooting()

-- Tombol Aktivasi
local ToggleTracerBtn = AddButton(MainTab, "Tracer Line: OFF", function()
    TracerEnabled = not TracerEnabled
    if TracerEnabled then
        tabs["Main"].Page:FindFirstChildOfClass("TextButton").Text = "Tracer Line: ON"
        tabs["Main"].Page:FindFirstChildOfClass("TextButton").TextColor3 = Color3.fromRGB(255, 110, 0)
    else
        tabs["Main"].Page:FindFirstChildOfClass("TextButton").Text = "Tracer Line: OFF"
        tabs["Main"].Page:FindFirstChildOfClass("TextButton").TextColor3 = Color3.fromRGB(230, 230, 230)
        if ActiveTracer then ActiveTracer:Destroy() end
    end
end)
