local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Global state
_G.NoFog = false
_G.NoLightingLayers = false
_G.NoFantasySky = false
_G.NoSky = false
_G.NoSeaTerrorCC = false
_G.FogDistance = 5000

local Lighting = game:GetService("Lighting")

local originalObjects = {}

local function storeOriginal(name)
    if not originalObjects[name] and Lighting:FindFirstChild(name) then
        originalObjects[name] = Lighting[name]
    end
end

local function removeObject(name)
    if Lighting:FindFirstChild(name) then
        storeOriginal(name)
        Lighting[name]:Destroy()
    end
end

local function restoreObject(name)
    local original = originalObjects[name]
    if original and not Lighting:FindFirstChild(name) then
        original.Parent = Lighting
    end
end

local function updateLighting()
    if _G.NoFog then
        Lighting.FogEnd = math.huge
    else
        Lighting.FogEnd = _G.FogDistance or 5000
    end

    if _G.NoLightingLayers then
        removeObject("LightingLayers")
    else
        restoreObject("LightingLayers")
    end

    if _G.NoFantasySky then
        removeObject("FantasySky")
    else
        restoreObject("FantasySky")
    end

    if _G.NoSky then
        removeObject("Sky")
    else
        restoreObject("Sky")
    end

    if _G.NoSeaTerrorCC then
        removeObject("SeaTerrorCC")
    else
        restoreObject("SeaTerrorCC")
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NoFogGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 300)
Main.Position = UDim2.new(0.5, -140, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 28)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NoFog"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -28, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, 0, 1, -28)
Content.Position = UDim2.new(0, 0, 0, 28)
Content.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 6
Content.CanvasSize = UDim2.new(0, 0, 0, 500)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Main

local function makeToggle(labelText, stateKey, y)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 34)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Parent = Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 70, 0, 22)
    toggle.Position = UDim2.new(1, -75, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
    toggle.Text = "ON"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 12
    toggle.BorderSizePixel = 0
    toggle.Parent = frame

    local function refresh()
        local enabled = _G[stateKey]
        toggle.Text = enabled and "ON" or "OFF"
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(160, 0, 0)
    end

    toggle.MouseButton1Click:Connect(function()
        _G[stateKey] = not _G[stateKey]
        refresh()
        updateLighting()
    end)

    refresh()
    return frame
end

local function makeNumberBox(labelText, y)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 38)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Parent = Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 90, 0, 24)
    box.Position = UDim2.new(1, -95, 0.5, -12)
    box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Text = tostring(_G.FogDistance)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    box.BorderSizePixel = 0
    box.Parent = frame

    box.FocusLost:Connect(function()
        local parsed = tonumber(box.Text)
        if parsed then
            _G.FogDistance = math.clamp(parsed, 0, 100000)
            box.Text = tostring(_G.FogDistance)
            updateLighting()
        else
            box.Text = tostring(_G.FogDistance)
        end
    end)

    return frame
end

local function makeButton(text, y, color3, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = color3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = Content
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Toggle entries
makeToggle("Fog", "NoFog", 10)
makeToggle("LightingLayers", "NoLightingLayers", 50)
makeToggle("FantasySky", "NoFantasySky", 90)
makeToggle("Sky", "NoSky", 130)
makeToggle("SeaTerrorCC", "NoSeaTerrorCC", 170)
makeNumberBox("Fog Distance", 210)

makeButton("Remove All Sky Objects", 255, Color3.fromRGB(255, 120, 0), function()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child.Name == "FantasySky" or child.Name == "LightingLayers" or child.Name == "Sky" or child.Name == "SeaTerrorCC" then
            removeObject(child.Name)
        end
    end
end)

makeButton("Reset", 295, Color3.fromRGB(90, 90, 0), function()
    _G.NoFog = false
    _G.NoLightingLayers = false
    _G.NoFantasySky = false
    _G.NoSky = false
    _G.NoSeaTerrorCC = false
    _G.FogDistance = 5000
    updateLighting()
end)

makeButton("Close GUI", 335, Color3.fromRGB(200, 0, 0), function()
    ScreenGui.Enabled = false
end)

-- Initial apply and monitor loop
updateLighting()

while true do
    task.wait(0.25)
    updateLighting()
end
