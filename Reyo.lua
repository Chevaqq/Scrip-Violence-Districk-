-- [[ VIOLENCE DISTRICT SCRIPT HUB - DELTA EXECUTOR ]] --

-- Menghapus UI lama kalau ada biar gak tumpuk
if game.CoreGui:FindFirstChild("ViolenceDistrictUI") then
    game.CoreGui.ViolenceDistrictUI:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 1. MAIN SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViolenceDistrictUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. MAIN FRAME (Background Hitam Transparan 0.5)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.5 --
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Biar bisa digeser lancar di HP
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- 3. TITLE BAR
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VIOLENCE DISTRICT HUB"
Title.TextColor3 = Color3.fromRGB(255, 55, 55)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- 4. CLOSE BUTTON (X) - Menghapus Script Sepenuhnya
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 5. BUTTON OPEN/CLOSE MENU (Tombol Kecil untuk Sembunyi/Munculkan UI)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10) -- Posisi pojok kiri atas layar
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
ToggleBtn.Text = "OPEN"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
ToggleBtn.Active = true
ToggleBtn.Draggable = true -- Tombol ini bisa kamu geser sesuka hati di HP biar gak ngalangin
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

-- Logika Open/Close Instant (Tanpa Animasi)
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

-- 6. NAVIGATION TABS (Samping)
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 120, 1, -50)
TabContainer.Position = UDim2.new(0, 10, 0, 45)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = TabContainer

-- 7. CONTAINER UNTUK ISI FITUR
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -150, 1, -50)
ContentContainer.Position = UDim2.new(0, 140, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabs = {}
local function CreateTab(tabName)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tabName .. "Tab"
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = tabName
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.TextSize = 14
    TabBtn.Font = Enum.Font.HelveticaBold
    TabBtn.Parent = TabContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    Page.Name = tabName .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 4
    Page.Parent = ContentContainer
    
    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 6)
    PageList.Parent = Page

    -- Pindah tab secara INSTAN
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

-- BIKIN TAB
local MainTab = CreateTab("Main")
local VisualTab = CreateTab("Visual")

tabs["Main"].Page.Visible = true
tabs["Main"].Btn.BackgroundColor3 = Color3.fromRGB(255, 55, 55)

local function AddButton(parentPage, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.BorderSizePixel = 0
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.SourceSansPro
    Btn.Parent = parentPage
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
    parentPage.CanvasSize = UDim2.new(0, 0, 0, parentPage.UIListLayout.AbsoluteContentSize.Y + 10)
end

-- ==================================================
-- LOGIKA TRACER LINE LOGIC (ORANGE LINE LOCK KILLER)
-- ==================================================
local TracerEnabled = false
local ActiveTracer = nil

-- Fungsi nyari player yang rolenya/namanya "Killer" di game
local function GetKillerTarget()
    -- Ganti logika ini sesuai dengan sistem game Violence District (apakah pakai Team atau Value di dalam player)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Contoh deteksi jika nama team-nya "Killer" atau punya atribut Killer
            if player.Team leadership and player.Team.Name == "Killer" or player:FindFirstChild("IsKiller") or string.find(player.Name:lower(), "killer") then
                return player.Character.HumanoidRootPart
            end
        end
    end
    
    -- Fallback: Kalau sistem team di atas beda, script bakal cari player terdekat yang bukan kamu sebagai target sementara
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player.Character.HumanoidRootPart
            end
        end
    end
    return closestPlayer
end

-- Fungsi buat bikin part line lurus warna Orange
local function CreateOrangeLine(targetPart)
    if ActiveTracer then ActiveTracer:Destroy() end

    local LinePart = Instance.new("Part")
    LinePart.Name = "TracerLine"
    LinePart.Anchored = true
    LinePart.CanCollide = false
    LinePart.Color = Color3.fromRGB(255, 120, 0) -- Warna Orange lurus
    LinePart.Material = Enum.Material.Neon
    LinePart.Parent = workspace

    ActiveTracer = LinePart

    -- Update posisi Line secara real-time mengikuti pergerakan tangan player ke target Killer
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not TracerEnabled or not LinePart or not targetPart or not targetPart.Parent or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LinePart then LinePart:Destroy() end
            connection:Disconnect()
            return
        end

        local startPos = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 1, 0) -- Berawal dari sekitar senjata/tangan
        local endPos = targetPart.Position

        local distance = (endPos - startPos).Magnitude
        LinePart.Size = Vector3.new(0.1, 0.1, distance)
        LinePart.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance / 2)
    end)
end

-- Trigger pas player Klik Tembak (Mouse klik kiri di HP/Delta)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not TracerEnabled then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local target = GetKillerTarget()
        if target then
            CreateOrangeLine(target)

            -- Simulasi peluru mengenai target (menghilang setelah beberapa saat / peluru sampai)
            task.wait(0.15) -- Estimasi waktu peluru mengenai target, lalu otomatis hilang
            if ActiveTracer then
                ActiveTracer:Destroy()
                ActiveTracer = nil
            end
        end
    end
end)

-- ==================================================
-- MENAMBAHKAN TOMBOL AKTIVASI KE TAB
-- ==================================================

AddButton(MainTab, "Tracer Line: OFF (Click to Toggle)", function(self)
    TracerEnabled = not TracerEnabled
    local btn = MainTab:FindFirstChild("Tracer Line: OFF (Click to Toggle)") or MainTab:FindFirstChild("Tracer Line: ON")
    if TracerEnabled then
        btn.Text = "Tracer Line: ON"
        btn.TextColor3 = Color3.fromRGB(255, 120, 0) -- Text jadi orange kalau aktif
    else
        btn.Text = "Tracer Line: OFF (Click to Toggle)"
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        if ActiveTracer then ActiveTracer:Destroy() end
    end
end)

-- Notifikasi Berhasil di-inject ke Delta
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Violence District",
    Text = "UI & Tracer Line Ready!",
    Duration = 3
})
