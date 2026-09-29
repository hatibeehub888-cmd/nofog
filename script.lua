local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local ui = tbl16:CreateWindow(PlayerGui)

local v28 = ui.Content

tbl16:CreateToggle(v28, "Remove Fog", "NoFog", false, { global = true, save = true })

local Lighting = game:GetService("Lighting")

local function handleFog()
    if _G.NoFog then
        Lighting.FogEnd = math.huge
        if Lighting:FindFirstChild("FantasySky") then
            Lighting.FantasySky:Destroy()
        elseif Lighting:FindFirstChild("LightingLayers") then
            Lighting.LightingLayers:Destroy()
        elseif Lighting:FindFirstChild("Sky") then
            Lighting.Sky:Destroy()
        elseif Lighting:FindFirstChild("SeaTerrorCC") then
            Lighting.SeaTerrorCC:Destroy()
        end
    end
end

while true do
    task.wait(0.5)
    handleFog()
end
