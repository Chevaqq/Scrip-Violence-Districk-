-- [[ TARUH SCRIPT INI DI LOCALSCRIPT TOOL SENJATA LU ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Tool = script.Parent

-- [[ 1. SETTINGS CONFIG ]] --
local Settings = {
    KillerEnabled = false,
    SurvivorEnabled = false,
    GeneratorEnabled = false,
    TracerEnabled = false,
    
    -- Colors
    KillerColor = Color3.fromRGB(255, 0, 0),     -- Merah
    SurvivorColor = Color3.fromRGB(0, 0, 255),   -- Biru
    GeneratorColor = Color3.fromRGB(255, 255, 0),-- Kuning
    TracerColor = Color3.fromRGB(255, 100, 0)    -- Orange
}

-- [[ 2. UI CREATION (BUTTON & PANEL) ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyHubMekanikUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Tombol Open/Close
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Text = "Rey"
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
ToggleBtn.Parent = ScreenGui

-- Main Panel
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 240)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ReyHub - Test Visual"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextSize = 18
Title.Parent = MainFrame

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- [[ 3. TOGGLE BUTTON CREATOR ]] --
local function CreateToggle(name, order, startState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0.18, (order * 40))
    btn.BackgroundColor3 = startState and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name .. ": " .. (startState and "ON" or "OFF")
    Instance.new("UICorner", btn)
    btn.Parent = MainFrame
    
    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    end)
end

CreateToggle("Chams Killer (Merah)", 0, Settings.KillerEnabled, function()
    Settings.KillerEnabled = not Settings.KillerEnabled
    return Settings.KillerEnabled
end)

CreateToggle("Chams Survivor (Biru)", 1, Settings.SurvivorEnabled, function()
    Settings.SurvivorEnabled = not Settings.SurvivorEnabled
    return Settings.SurvivorEnabled
end)

CreateToggle("Chams Generator (Kuning)", 2, Settings.GeneratorEnabled, function()
    Settings.GeneratorEnabled = not Settings.GeneratorEnabled
    return Settings.GeneratorEnabled
end)

CreateToggle("Tracer Line (Orange)", 3, Settings.TracerEnabled, function()
    Settings.TracerEnabled = not Settings.TracerEnabled
    return Settings.TracerEnabled
end)

-- [[ 4. VISUAL EFFECTS ENGINE ]] --
local function ApplyChams(instance, color, isEnabled, namePenanda)
    if not instance then return end
    local highlight = instance:FindFirstChild(namePenanda)
    
    if not isEnabled then
        if highlight then highlight:Destroy() end
        return
    end
    
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = namePenanda
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = instance
    end
    
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.4
end

-- TRACER LINE FUNCTION (Garis muncul lurus mengarah ke target dan langsung musnah)
local function BuatTracerLine(dari, ke)
    if not Settings.TracerEnabled then return end
    
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = Settings.TracerColor
    part.Transparency = 0.1
    
    local jarak = (ke - dari).Magnitude
    part.Size = Vector3.new(0.1, 0.1, jarak)
    part.CFrame = CFrame.lookAt(dari, ke) * CFrame.new(0, 0, -jarak / 2)
    part.Parent = workspace
    
    -- Langsung hancur dalam sekejap (simulasi setelah peluru sampai mengenai target)
    task.delay(0.06, function()
        part:Destroy()
    end)
end

-- [[ 5. MAIN LOOP PROCESS ]] --
RunService.RenderStepped:Connect(function()
    -- Loop Player Chams (Killer & Survivor)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local isKiller = (player.Team and player.Team.Name:lower():find("killer")) or player:GetAttribute("Role") == "Killer"
            
            if isKiller then
                ApplyChams(player.Character, Settings.KillerColor, Settings.KillerEnabled, "ReyKillerChams")
            else
                ApplyChams(player.Character, Settings.SurvivorColor, Settings.SurvivorEnabled, "ReySurvChams")
            end
        end
    end
    
    -- Loop Generator Chams (Kuning)
    if Settings.GeneratorEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("gen") or obj.Name:lower():find("generator")) then
                ApplyChams(obj, Settings.GeneratorColor, Settings.GeneratorEnabled, "ReyGenChams")
            end
        end
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("ReyGenChams") then
                obj.ReyGenChams:Destroy()
            end
        end
    end
end)

-- [[ 6. WEAPON SHOOT EVENT ]] --
Tool.Activated:Connect(function()
    local karakter = LocalPlayer.Character
    if not karakter or not karakter:FindFirstChild("HumanoidRootPart") then return end
    
    local posisiAsal = Tool:FindFirstChild("Handle") and Tool.Handle.Position or karakter.HumanoidRootPart.Position
    local posisiTujuan = Mouse.Hit.Position -- Jalur lurus normal ke arah kursor/tap HP
    
    -- Buat garis orange kilat pas peluru dilepas
    BuatTracerLine(posisiAsal, posisiTujuan)
end)

Tool.Unequipped:Connect(function() ScreenGui.Enabled = false end)
Tool.Equipped:Connect(function() ScreenGui.Enabled = true end)
