-- [[ CHEVA HUB - PREMIUM & AESTHETIC ]] --
-- UI Library: Fluent (Paling mirip sama yang kamu mau)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 1. KONFIGURASI WINDOW
local Window = Fluent:CreateWindow({
    Title = "Cheva Hub",
    SubTitle = "Premium Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- INI TOMBOL BUKA TUTUPNYA (L-CTRL)
})

-- Notifikasi Cara Buka Tutup
Fluent:Notify({
    Title = "Cheva Hub Loaded!",
    Content = "Tekan 'Left Control' untuk Buka/Tutup Menu!",
    Duration = 5
})

---------------------------------------------------------
-- TAB 1: LOGIN (KEY SYSTEM)
---------------------------------------------------------
local LoginTab = Window:AddTab({ Title = "Login", Icon = "key" })

LoginTab:AddParagraph({
    Title = "System Verification",
    Content = "Masukkan Key untuk akses fitur Premium."
})

local KeyValue = ""
local KeyInput = LoginTab:AddInput("InputKey", {
    Title = "Enter Key Here",
    Default = "",
    Placeholder = "Key: ChevaHub",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        KeyValue = Value
    end
})

LoginTab:AddButton({
    Title = "Check Key",
    Description = "Klik untuk verifikasi key kamu",
    Callback = function()
        if KeyValue == "ChevaHub" then
            Fluent:Notify({Title = "Success", Content = "Key Benar! Fitur Terbuka.", Duration = 3})
            LoadFeatures() -- Jalankan fungsi buka fitur
        else
            Fluent:Notify({Title = "Error", Content = "Key Salah! Coba lagi.", Duration = 3})
        end
    end
})

---------------------------------------------------------
-- FUNGSI UNTUK MEMUAT SEMUA FITUR (SETELAH KEY BENAR)
---------------------------------------------------------
function LoadFeatures()
    
    -- TAB: MAIN
    local MainTab = Window:AddTab({ Title = "Main", Icon = "home" })
    
    MainTab:AddInput("ConfigName", {
        Title = "Config Name",
        Default = "",
        Placeholder = "Ketik nama config...",
        Callback = function(Value) _G.ConfigName = Value end
    })

    MainTab:AddInput("SpeedInput", {
        Title = "Speed Value",
        Default = "16",
        Placeholder = "Contoh: 50",
        Numeric = true,
        Callback = function(Value)
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(Value)
            end
        end
    })

    -- TAB: SURVIVOR
    local SurvTab = Window:AddTab({ Title = "Survivor", Icon = "user" })
    
    SurvTab:AddToggle("Aimlock", {Title = "Aimlock (Lock Killer)", Default = false, Callback = function(v) _G.Aimlock = v end})
    SurvTab:AddToggle("TracerLine", {Title = "Treacher Line (Red Line Hit)", Default = false, Callback = function(v) _G.TracerLine = v end})
    SurvTab:AddToggle("SilentAim", {Title = "Silent Aim (Bisa Belok)", Default = false, Callback = function(v) _G.SilentAim = v end})

    -- TAB: KILLER
    local KillTab = Window:AddTab({ Title = "Killer", Icon = "skull" })
    
    KillTab:AddToggle("NoSlow", {Title = "No Slowdown", Default = false, Callback = function(v) _G.NoSlow = v end})
    KillTab:AddToggle("InfLague", {Title = "Infinite Lague", Default = false, Callback = function(v) _G.InfLague = v end})
    KillTab:AddToggle("InfAttack", {Title = "Infinite Attack", Default = false, Callback = function(v) _G.InfAttack = v end})

    -- TAB: VISUAL
    local VisualTab = Window:AddTab({ Title = "Visual", Icon = "eye" })
    
    VisualTab:AddToggle("ChamsK", {Title = "Chams Killer (Merah)", Default = false, Callback = function(v) _G.ChamsK = v end})
    VisualTab:AddToggle("ChamsG", {Title = "Chams Generator (Kuning)", Default = false, Callback = function(v) _G.ChamsG = v end})
    VisualTab:AddToggle("ChamsS", {Title = "Chams Survivor (Hijau)", Default = false, Callback = function(v) _G.ChamsS = v end})
    
    local Lighting = game:GetService("Lighting")
    VisualTab:AddToggle("FullBright", {Title = "Full Bright (Terang)", Default = false, 
        Callback = function(Value)
            if Value then
                Lighting.Brightness = 5
                Lighting.ClockTime = 14
                Lighting.GlobalShadows = false
            else
                Lighting.Brightness = 1
                Lighting.ClockTime = 12
                Lighting.GlobalShadows = true
            end
        end
    })

    VisualTab:AddToggle("TracerVis", {Title = "Treacher Line (Visual)", Default = false, Callback = function(v) _G.TracerVis = v end})
    VisualTab:AddToggle("Box3D", {Title = "Box 3D (Transparent)", Default = false, Callback = function(v) _G.Box3D = v end})

    -- Pindah ke Tab Main otomatis setelah login
    Window:SelectTab(2)
end

-- OTOMATIS PILIH TAB LOGIN SAAT PERTAMA LOAD
Window:SelectTab(1)
