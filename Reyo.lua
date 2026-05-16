-- [[ TARUH SCRIPT INI DI LOCALSCRIPT (Bisa di StarterPlayerScripts / StarterGui) ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ 1. SETTINGS CONFIG ]] --
local ChamsSettings = {
    KillerEnabled = false,
    SurvivorEnabled = false,
    KillerColor = Color3.fromRGB(255, 0, 0),    -- Merah Full
    SurvivorColor = Color3.fromRGB(0, 0, 255),  -- Biru Full
    FillTransparency = 0.4,
    OutlineTransparency = 0
}

-- [[ 2. UI CREATION (BUTTON & PANEL) ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReyHubChamsUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Tombol Open/Close (Desain Minimalis Putih-Hitam)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Text = "Rey"
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
ToggleBtn.Parent = ScreenGui

-- Main Panel (Hitam Transparan 0.5, Tulisan Putih)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 160)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ReyHub - Chams Menu"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Fungsi instant open/close
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- [[ 3. CHAMS ENGINE FUNCTION ]] --
local function ApplyChams(character, color, isEnabled)
    if not character then return end
    
    local highlight = character:FindFirstChild("ReyChams")
    
    if not isEnabled then
        if highlight then highlight:Destroy() end
        return
    end
    
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "ReyChams"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
    end
    
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1) -- Outline Putih biar kontras
    highlight.FillTransparency = ChamsSettings.FillTransparency
    highlight.OutlineTransparency = ChamsSettings.OutlineTransparency
end

-- [[ 4. UI TOGGLE INTERACTION ]] --
local function CreateToggle(name, order, startState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0.25, (order * 45))
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

CreateToggle("Chams Killer (Merah)", 0, ChamsSettings.KillerEnabled, function()
    ChamsSettings.KillerEnabled = not ChamsSettings.KillerEnabled
    return ChamsSettings.KillerEnabled
end)

CreateToggle("Chams Survivor (Biru)", 1, ChamsSettings.SurvivorEnabled, function()
    ChamsSettings.SurvivorEnabled = not ChamsSettings.SurvivorEnabled
    return ChamsSettings.SurvivorEnabled
end)

-- [[ 5. MAIN RENDER LOOP ]] --
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Cek Role berdasarkan nama Tim atau Atribut di game lu
            local isKiller = (player.Team and player.Team.Name:lower():find("killer")) or player:GetAttribute("Role") == "Killer"
            
            if isKiller then
                -- Kirim warna merah jika killer enabled
                ApplyChams(player.Character, ChamsSettings.KillerColor, ChamsSettings.KillerEnabled)
            else
                -- Kirim warna biru jika survivor enabled
                ApplyChams(player.Character, ChamsSettings.SurvivorColor, ChamsSettings.SurvivorEnabled)
            end
        end
    end
end)
