-- [[ CHEVA HUB - DEAD BY DAYLIGHT / ROBLOX SCRIPT ]] --

-- 1. SISTEM KEY (LOGIN)
local KeySystem = true
local CorrectKey = "ChevaHub"

-- Memanggil Fluent UI Library (UI Premium & Modern)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

if KeySystem then
    local KeyWindow = Fluent:CreateWindow({
        Title = "Cheva Hub | Key System",
        SubTitle = "by Owner",
        TabWidth = 160,
        Size = UDim2.fromOffset(450, 300),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local KeyTab = KeyWindow:AddTab({ Title = "Verification", Icon = "key" })
    local KeyInput = KeyTab:AddInput("InputKey", {
        Title = "Enter Key",
        Default = "",
        Placeholder = "Type key here...",
        Numeric = false,
        Finished = true,
    })

    local Verified = false
    KeyInput:OnChanged(function()
        if KeyInput.Value == CorrectKey then
            Verified = true
            Fluent:Notify({
                Title = "Success",
                Content = "Correct Key! Loading Cheva Hub...",
                Duration = 3
            })
            task.wait(1)
            KeyWindow:Destroy()
            -- Memanggil fungsi utama setelah key benar
            StartChevaHub()
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Wrong Key! Please try again.",
                Duration = 3
            })
        end
    end)
else
    StartChevaHub()
end

-- 2. TAMPILAN UTAMA SCRIPT (DIJALANKAN JIKA KEY BENAR)
function StartChevaHub()
    local Window = Fluent:CreateWindow({
        Title = "Cheva Hub",
        SubTitle = "Premium Edition",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl -- Tombol kiri CTRL untuk Buka/Tutup (Open/Close) UI
    })

    -- Membuat Kategori / Tab Fitur
    local Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "home" }),
        Survivor = Window:AddTab({ Title = "Survivor", Icon = "user" }),
        Killer = Window:AddTab({ Title = "Killer", Icon = "skull" }),
        Visual = Window:AddTab({ Title = "Visual", Icon = "eye" })
    }

    ---------------------------------------------------------
    -- TAB: MAIN
    ---------------------------------------------------------
    Tabs.Main:AddParagraph({
        Title = "Welcome to Cheva Hub",
        Content = "Press 'Left Control' to Open/Close Menu."
    })

    local ConfigName = ""
    Tabs.Main:AddInput("ConfigInput", {
        Title = "Config Name",
        Default = "",
        Placeholder = "Enter config name...",
        Numeric = false,
        Finished = true,
        Callback = function(Value)
            ConfigName = Value
        end
    })

    Tabs.Main:AddInput("SpeedInput", {
        Title = "Speed Hack Value",
        Default = "16",
        Placeholder = "Enter speed number...",
        Numeric = true, -- Hanya bisa mengetik angka
        Finished = true,
        Callback = function(Value)
            local num = tonumber(Value)
            if num then
                game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = num
            end
        end
    })


    ---------------------------------------------------------
    -- TAB: SURVIVOR
    ---------------------------------------------------------
    local AimlockToggle = Tabs.Survivor:AddToggle("Aimlock", {Title = "Aimlock (Lock Killer)", Default = false})
    local TracerLineToggle = Tabs.Survivor:AddToggle("TracerLine", {Title = "Tracer Line (Red Line on Hit)", Default = false})
    local SilentAimToggle = Tabs.Survivor:AddToggle("SilentAim", {Title = "Silent Aim (Bullet Redirect)", Default = false})

    -- Logika Fungsional Survivor (Placeholder penempatan logika game)
    AimlockToggle:OnChanged(function()
        _G.Aimlock = AimlockToggle.Value
        -- Logika penguncian kamera ke Killer taruh di sini
    end)

    TracerLineToggle:OnChanged(function()
        _G.TracerLineHit = TracerLineToggle.Value
        -- Logika saat peluru keluar memunculkan garis merah & hilang saat kena Killer
    end)

    SilentAimToggle:OnChanged(function()
        _G.SilentAim = SilentAimToggle.Value
        -- Logika manipulasi Vector3 / Raycast tembakan membelok ke arah target
    end)


    ---------------------------------------------------------
    -- TAB: KILLER
    ---------------------------------------------------------
    local NoSlowdownToggle = Tabs.Killer:AddToggle("NoSlowdown", {Title = "No Slowdown", Default = false})
    local InfLagueToggle = Tabs.Killer:AddToggle("InfLague", {Title = "Infinite Lague", Default = false})
    local InfAttackToggle = Tabs.Killer:AddToggle("InfAttack", {Title = "Infinite Attack", Default = false})

    NoSlowdownToggle:OnChanged(function()
        _G.NoSlowdown = NoSlowdownToggle.Value
    end)

    InfLagueToggle:OnChanged(function()
        _G.InfLague = InfLagueToggle.Value
    end)

    InfAttackToggle:OnChanged(function()
        _G.InfAttack = InfAttackToggle.Value
    end)


    ---------------------------------------------------------
    -- TAB: VISUAL
    ---------------------------------------------------------
    local ChamsKillerToggle = Tabs.Visual:AddToggle("ChamsKiller", {Title = "Chams Killer (Red)", Default = false})
    local ChamsGenToggle = Tabs.Visual:AddToggle("ChamsGen", {Title = "Chams Generator (Yellow)", Default = false})
    local ChamsSurvToggle = Tabs.Visual:AddToggle("ChamsSurv", {Title = "Chams Survivor (Green)", Default = false})
    local FullBrightToggle = Tabs.Visual:AddToggle("FullBright", {Title = "Full Bright", Default = false})
    local TracerVisualToggle = Tabs.Visual:AddToggle("TracerVisual", {Title = "Tracer Line (Killer & Survivor)", Default = false})
    local Box3DToggle = Tabs.Visual:AddToggle("Box3D", {Title = "Box 3D (Transparent Center)", Default = false})

    -- Efek Full Bright (Layar Sangat Terang)
    local Lighting = game:GetService("Lighting")
    local OldBrightness = Lighting.Brightness
    local OldClockTime = Lighting.ClockTime

    FullBrightToggle:OnChanged(function()
        if FullBrightToggle.Value then
            Lighting.Brightness = 10
            Lighting.ClockTime = 14
            Lighting.FogEnd = 999999
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = OldBrightness
            Lighting.ClockTime = OldClockTime
            Lighting.GlobalShadows = true
        end
    end)

    -- Pengaturan dasar Chams & Box ESP menggunakan fungsi bawaan Roblox (Highlight / Wireframe)
    ChamsKillerToggle:OnChanged(function() _G.ChamsKiller = ChamsKillerToggle.Value end)
    ChamsGenToggle:OnChanged(function() _G.ChamsGen = ChamsGenToggle.Value end)
    ChamsSurvToggle:OnChanged(function() _G.ChamsSurv = ChamsSurvToggle.Value end)
    TracerVisualToggle:OnChanged(function() _G.TracerVisual = TracerVisualToggle.Value end)
    Box3DToggle:OnChanged(function() _G.Box3D = Box3DToggle.Value end)

    -- Membuka tab pertama secara otomatis saat berhasil masuk
    Window:SelectTab(1)
    
    Fluent:Notify({
        Title = "Cheva Hub",
        Content = "Welcome! Script loaded successfully.",
        Duration = 5
    })
end
