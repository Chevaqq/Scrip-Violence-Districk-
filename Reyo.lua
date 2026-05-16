-- [[ VIOLENCE DISTRICT SCRIPT HUB - FIXED FOR DELTA MOBILE ]] --

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Bersihkan UI lama jika ada
if PlayerGui:FindFirstChild("ViolenceDistrictUI") then
    PlayerGui.ViolenceDistrictUI:Destroy()
end

-- 1. MAIN SCREEN GUI (Pindah ke PlayerGui biar pasti muncul)
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

-- [[ SCRIPT DRAG MANUAL ANTI-LAG UNTUK HP ]] --
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

-- 4. BUTTON TOGGLE OPEN/CLOSE (Dipojokkan agar pas di HP)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 70, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0, 100) -- Di bawah tombol chat bawaan Roblox
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

-- Drag manual khusus Tombol Open/Close
local tDragging, tDragStart, tStartPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        tDragging = true
        tDragStart = input.Position
        tStartPos = ToggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then tDragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if tDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - tDragStart
        ToggleBtn.Position = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
    end
end)

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
-- MECHANIC: TRACER LINE LOCK KILLER
-- ==================================================
local TracerEnabled = false
local ActiveTracer = nil

-- Deteksi icon/target "Killer" di game secara dinamis
local function GetKillerTarget()
    -- Cek icon merah di atas kepala player (seperti gambar yang kamu kirim)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Deteksi BillboardGui atau icon di atas karakter
            if player.Character:FindFirstChildOfClass("BillboardGui") or player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChildOfClass("BillboardGui") then
                return player.Character.HumanoidRootPart
            end
            -- Deteksi folder status game (IsKiller / KillerTeam)
            if player:FindFirstChild("Killer") or (player.Team and string.find(player.Team.Name:lower(), "kill")) then
                return player.Character.HumanoidRootPart
            end
        end
    end
    
    -- Jaga-jaga kalau target murni belum ketemu, lock player lain terdekat
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
    Line.Color = Color3.fromRGB(255, 110, 0) -- Orange Neon Lurus
    Line.Material = Enum.Material.Neon
    Line.Parent = workspace
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

UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not TracerEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local target = GetKillerTarget()
        if target then
            CreateOrangeLine(target)
            task.wait(0.12) -- Menghilang instan setelah peluru sampai target
            if ActiveTracer then ActiveTracer:Destroy(); ActiveTracer = nil end
        end
    end
end)

-- Tombol Aktivasi Fitur
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
