-- [[ CHEVA HUB - EXCLUSIVE RAYFIELD EDITION (READY TO SELL) ]] --

-- Menggunakan link cadangan GitHub agar pasti muncul di semua executor HP
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- MEMBUAT WINDOW UTAMA
local Window = Rayfield:CreateWindow({
   Name = "Cheva Hub | Premium",
   LoadingTitle = "Loading Cheva Hub...",
   LoadingSubtitle = "Ready for Customers",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = true, -- Sistem Key Aktif
   KeySettings = {
      Title = "Cheva Hub | Key System",
      Subtitle = "Premium Verification",
      Note = "Key: ChevaHub",
      FileName = "ChevaHubKeyConfig",
      SaveKey = true,
      GrabKeyFromUrl = false,
      Key = {"ChevaHub"} -- Key Utama
   }
})

---------------------------------------------------------
-- TOMBOL BUKA TUTUP (FLOATING TOGGLE BUTTON FOR MOBILE)
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "ChevaToggleGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 150) -- Posisi tombol di kiri layar HP
ToggleButton.Size = UDim2.new(0, 60, 0, 60) -- Ukuran tombol bulat
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "CHEVA"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14.00

UICorner.CornerRadius = UDim.new(1, 0) -- Membuat tombol menjadi bulat sempurna
UICorner.Parent = ToggleButton

-- Logika klik tombol untuk Buka / Tutup UI
local UI_Toggled = true
ToggleButton.MouseButton1Click:Connect(function()
    if UI_Toggled then
        Window:Close() -- Menutup UI Rayfield
        UI_Toggled = false
        ToggleButton.Text = "OPEN"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 150, 20) -- Berubah jadi hijau saat tutup
    else
        Window:Open() -- Membuka UI Rayfield
        UI_Toggled = true
        ToggleButton.Text = "CLOSE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 20, 20) -- Berubah jadi merah saat buka
    end
end)

---------------------------------------------------------
-- TAB 1: MAIN
---------------------------------------------------------
local MainTab = Window:CreateTab("Main", 4483362458)

local ConfigName = ""
MainTab:CreateInput({
   Name = "Config Name",
   PlaceholderText = "Ketik nama config...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      ConfigName = Text
   end,
})

MainTab:CreateInput({
   Name = "WalkSpeed",
   PlaceholderText = "Ketik angka speed (Contoh: 30)",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num then
          game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = num
      end
   end,
})

---------------------------------------------------------
-- TAB 2: SURVIVOR
---------------------------------------------------------
local SurvTab = Window:CreateTab("Survivor", 4483362458)

SurvTab:CreateToggle({
   Name = "Aimlock (Lock Killer)",
   CurrentValue = false,
   Flag = "Aimlock",
   Callback = function(Value) _G.Aimlock = Value end,
})

SurvTab:CreateToggle({
   Name = "Treacher Line (Red Line on Hit)",
   CurrentValue = false,
   Flag = "TracerLine",
   Callback = function(Value) _G.TracerLineHit = Value end,
})

SurvTab:CreateToggle({
   Name = "Silent Aim (Bullet Redirect)",
   CurrentValue = false,
   Flag = "SilentAim",
   Callback = function(Value) _G.SilentAim = Value end,
})

---------------------------------------------------------
-- TAB 3: KILLER
---------------------------------------------------------
local KillTab = Window:CreateTab("Killer", 4483362458)

KillTab:CreateToggle({
   Name = "No Slowdown",
   CurrentValue = false,
   Flag = "NoSlow",
   Callback = function(Value) _G.NoSlowdown = Value end,
})

KillTab:CreateToggle({
   Name = "Infinite Lague",
   CurrentValue = false,
   Flag = "InfLague",
   Callback = function(Value) _G.InfLague = Value end,
})

KillTab:CreateToggle({
   Name = "Infinite Attack",
   CurrentValue = false,
   Flag = "InfAttack",
   Callback = function(Value) _G.InfAttack = Value end,
})

---------------------------------------------------------
-- TAB 4: VISUAL
---------------------------------------------------------
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateToggle({
   Name = "Chams Killer (Merah)",
   CurrentValue = false,
   Flag = "ChamsK",
   Callback = function(Value) _G.ChamsKiller = Value end,
})

VisualTab:CreateToggle({
   Name = "Chams Generator (Kuning)",
   CurrentValue = false,
   Flag = "ChamsG",
   Callback = function(Value) _G.ChamsGen = Value end,
})

VisualTab:CreateToggle({
   Name = "Chams Survivor (Hijau)",
   CurrentValue = false,
   Flag = "ChamsS",
   Callback = function(Value) _G.ChamsSurv = Value end,
})

-- LOGIKA FULL BRIGHT (LAYAR SANGAT TERANG)
local Lighting = game:GetService("Lighting")
local OldBrightness = Lighting.Brightness
local OldClockTime = Lighting.ClockTime

VisualTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
      if Value then
          Lighting.Brightness = 10
          Lighting.ClockTime = 14
          Lighting.GlobalShadows = false
          Lighting.FogEnd = 999999
      else
          Lighting.Brightness = OldBrightness
          Lighting.ClockTime = OldClockTime
          Lighting.GlobalShadows = true
      end
   end,
})

VisualTab:CreateToggle({
   Name = "Treacher Line (Killer & Survivor)",
   CurrentValue = false,
   Flag = "TracerVisual",
   Callback = function(Value) _G.TracerVisual = Value end,
})

VisualTab:CreateToggle({
   Name = "Box 3D (Transparent)",
   CurrentValue = false,
   Flag = "Box3D",
   Callback = function(Value) _G.Box3D = Value end,
})

-- Notifikasi Akhir
Rayfield:Notify({
   Name = "Cheva Hub",
   Content = "Script loaded! Use the 'CHEVA' button on your screen to toggle UI.",
   Duration = 5,
   Image = 4483362458,
})
