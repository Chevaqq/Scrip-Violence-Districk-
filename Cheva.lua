-- [[ CHEVA HUB - PREMIUM EDITION ]] --
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- MEMBUAT WINDOW UTAMA
local Window = Fluent:CreateWindow({
    Title = "Cheva Hub",
    SubTitle = "Premium Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Tombol untuk Buka/Tutup UI (Open/Close)
})

---------------------------------------------------------
-- TAB 1: SYSTEM KEY (VERIFIKASI)
---------------------------------------------------------
local KeyTab = Window:AddTab({ Title = "Key System", Icon = "key" })

KeyTab:AddParagraph({
    Title = "Verification Required",
    Content = "Masukkan Key 'ChevaHub' untuk membuka semua fitur."
})

local KeyInput = KeyTab:AddInput("InputKey", {
    Title = "Enter Key",
    Default = "",
    Placeholder = "Ketik key disini...",
    Numeric = false,
    Finished = true,
})

-- Sembunyikan tab fitur lain sebelum key dimasukkan benar
local Tabs = {}
local KeyVerified = false

local function UnlockTabs()
    if KeyVerified then return end
    KeyVerified = true
    
    Fluent:Notify({
        Title = "Cheva Hub",
        Content = "Key 'ChevaHub' Verified! All tabs loaded.",
        Duration = 4
    })

    ---------------------------------------------------------
    -- TAB 2: MAIN
    ---------------------------------------------------------
    Tabs.Main = Window:AddTab({ Title = "Main", Icon = "home" })
    
    local ConfigName = ""
    Tabs.Main:AddInput("ConfigInput", {
        Title = "Config Name",
        Default = "",
        Placeholder = "Masukkan nama config...",
        Numeric = false,
        Finished = true,
        Callback = function(Value)
            ConfigName = Value
        end
    })

    Tabs.Main:AddInput("SpeedInput", {
        Title = "WalkSpeed",
        Default = "16",
        Placeholder = "Ketik angka speed...",
        Numeric = true,
        Finished = true,
        Callback = function(Value)
            local num = tonumber(Value)
            if num and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num
            end
        end
    })

    ---------------------------------------------------------
    -- TAB 3: SURVIVOR
    ---------------------------------------------------------
    Tabs.Survivor = Window:AddTab({ Title = "Survivor", Icon = "user" })
    
    local AimlockToggle = Tabs.Survivor:AddToggle("Aimlock", {Title = "Aimlock (Lock Killer)", Default = false})
    local TracerLineToggle = Tabs.Survivor:AddToggle("TracerLine", {Title = "Treacher Line (Red Line on Hit)", Default = false})
    local SilentAimToggle = Tabs.Survivor:AddToggle("SilentAim", {Title = "Silent Aim (Bullet Redirect)", Default = false})

    AimlockToggle:OnChanged(function() _G.Aimlock = AimlockToggle.Value end)
    TracerLineToggle:OnChanged(function() _G.TracerLineHit = TracerLineToggle.Value end)
    SilentAimToggle:OnChanged(function() _G.SilentAim = SilentAimToggle.Value end)

    ---------------------------------------------------------
    -- TAB 4: KILLER
    ---------------------------------------------------------
    Tabs.Killer = Window:AddTab({ Title = "Killer", Icon = "skull" })
    
    local NoSlowToggle = Tabs.Killer:AddToggle("NoSlowdown", {Title = "No Slowdown", Default = false})
    local InfLagueToggle = Tabs.Killer:AddToggle("InfLague", {Title = "Infinite Lague", Default = false})
    local InfAttackToggle = Tabs.Killer:AddToggle("InfAttack", {Title = "Infinite Attack", Default = false})

    NoSlowToggle:OnChanged(function() _G.NoSlowdown = NoSlowToggle.Value end)
    InfLagueToggle:OnChanged(function() _G.InfLague = InfLagueToggle.Value end)
    InfAttackToggle:OnChanged(function() _G.InfAttack = InfAttackToggle.Value end)

    ---------------------------------------------------------
    -- TAB 5: VISUAL
    ---------------------------------------------------------
    Tabs.Visual = Window:AddTab({ Title = "Visual", Icon = "eye" })
    
    local ChamsKiller = Tabs.Visual:AddToggle("ChamsKiller", {Title = "Chams Killer (Red)", Default = false})
    local ChamsGen = Tabs.Visual:AddToggle("ChamsGen", {Title = "Chams Generator (Yellow)", Default = false})
    local ChamsSurv = Tabs.Visual:AddToggle("ChamsSurv", {Title = "Chams Survivor (Green)", Default = false})
    local FullBright = Tabs.Visual:AddToggle("FullBright", {Title = "Full Bright (Layar Terang)", Default = false})
    local TracerVisual = Tabs.Visual:AddToggle("TracerVisual", {Title = "Treacher Line (Killer & Survivor)", Default = false})
    local Box3D = Tabs.Visual:AddToggle("Box3D", {Title = "Box 3D (Transparent Center)", Default = false})

    -- Logika Full Bright
    local Lighting = game:GetService("Lighting")
    local OldBrightness = Lighting.Brightness
    local OldClockTime = Lighting.ClockTime
    
    FullBright:OnChanged(function()
        if FullBright.Value then
            Lighting.Brightness = 10
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = OldBrightness
            Lighting.ClockTime = OldClockTime
            Lighting.GlobalShadows = true
        end
    end)

    ChamsKiller:OnChanged(function() _G.ChamsKiller = ChamsKiller.Value end)
    ChamsGen:OnChanged(function() _G.ChamsGen = ChamsGen.Value end)
    ChamsSurv:OnChanged(function() _G.ChamsSurv = ChamsSurv.Value end)
    TracerVisual:OnChanged(function() _G.TracerVisual = TracerVisual.Value end)
    Box3D:OnChanged(function() _G.Box3D = Box3D.Value end)
end

-- Cek input Key secara real-time
KeyInput:OnChanged(function()
    if KeyInput.Value == "ChevaHub" then
        UnlockTabs()
    end
end)

Window:SelectTab(1)
