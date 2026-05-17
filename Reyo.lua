-- DEBUG SCRIPT
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character

print("=== DEBUG INFO ===")
print("Player: " .. player.Name)
print("Character exist: " .. tostring(character ~= nil))

if character then
    print("\nCharacter Parts:")
    for _, part in pairs(character:GetChildren()) do
        print("  - " .. part.Name .. " (" .. part.ClassName .. ")")
    end
    
    print("\nBackpack Items:")
    for _, item in pairs(player.Backpack:GetChildren()) do
        print("  - " .. item.Name)
    end
end

print("\nPlayerGui exist: " .. tostring(player:FindFirstChild("PlayerGui") ~= nil))
