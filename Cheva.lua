-- [[ CHEVA HUB - RAYFIELD EDITION ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- MEMBUAT WINDOW UTAMA
local Window = Rayfield:CreateWindow({
   Name = "Cheva Hub | Premium",
   LoadingTitle = "Loading Cheva Hub...",
   LoadingSubtitle = "by Cheva",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = true, -- Mengaktifkan Sistem Key bawaan Rayfield
   KeySettings = {
      Title = "Cheva Hub | Key System",
      Subtitle = "Masukkan Key Terlebih Dahulu",
      WARNING!!! = "JANGAN GUNAKAN SCRIP INI BERLEBIHAN!",
      FileName = "ChevaHubKey",
      SaveKey = true,
      GrabKeyFromUrl = false,
      Key = {"ChevaHub"} -- Key yang benar
   }
})

---------------------------------------------------------
-- TAB 1: MAIN
---------------------------------------------------------
local MainTab = Window:CreateTab("Main", 4483362458) -- ID Icon Home

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
   PlaceholderText = "Default: 16 (Hanya angka)",
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
   Callback = function(Value)
      _G.Aimlock = Value
      -- Jalankan fungsi aimlock di sini
   end,
})

SurvTab:CreateToggle({
   Name = "Treacher Line (Red Line on Hit)",
   CurrentValue = false,
   Flag = "TracerLine",
   Callback = function(Value)
      _G.TracerLineHit = Value
   end,
})

SurvTab:CreateToggle({
   Name = "Silent Aim (Bullet Redirect)",
   CurrentValue = false,
   Flag = "SilentAim",
   Callback = function(Value)
      _G.SilentAim = Value
   end,
})

---------------------------------------------------------
-- TAB 3: KILLER
---------------------------------------------------------
local KillTab = Window:CreateTab("Killer", 4483362458)

KillTab:CreateToggle({
   Name = "No Slowdown",
   CurrentValue = false,
   Flag = "NoSlow",
   Callback = function(Value)
      _G.NoSlowdown = Value
   end,
})

KillTab:CreateToggle({
   Name = "Infinite Lague",
   CurrentValue = false,
   Flag = "InfLague",
   Callback = function(Value)
      _G.InfLague = Value
   end,
})

KillTab:CreateToggle({
   Name = "Infinite Attack",
   CurrentValue = false,
   Flag = "InfAttack",
   Callback = function(Value)
      _G.InfAttack = Value
   end,
})

---------------------------------------------------------
-- TAB 4: VISUAL
---------------------------------------------------------
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateToggle({
   Name = "Chams Killer (Merah)",
   CurrentValue = false,
   Flag = "ChamsK",
   Callback = function(Value)
      _G.ChamsKiller = Value
   end,
})

VisualTab:CreateToggle({
   Name = "Chams Generator (Kuning)",
   CurrentValue = false,
   Flag = "ChamsG",
   Callback = function(Value)
      _G.ChamsGen = Value
   end,
})

VisualTab:CreateToggle({
   Name = "Chams Survivor (Hijau)",
   CurrentValue = false,
   Flag = "ChamsS",
   Callback = function(Value)
      _G.ChamsSurv = Value
   end,
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
   Callback = function(Value)
      _G.TracerVisual = Value
   end,
})

VisualTab:CreateToggle({
   Name = "Box 3D (Transparent)",
   CurrentValue = false,
   Flag = "Box3D",
   Callback = function(Value)
      _G.Box3D = Value
   end,
})

-- Notifikasi Sukses
Rayfield:Notify({
   Title = "Cheva Hub Loaded",
   Content = "Selamat menikmati fitur premium!",
   Duration = 5,
   Image = 4483362458,
})
