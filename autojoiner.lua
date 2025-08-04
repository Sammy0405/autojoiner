local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoJoinerGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Fondo principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 250)
frame.Position = UDim2.new(0.5, -180, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(35, 37, 44)
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 16)
uiCorner.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Text = "AutoJoiner"
title.Size = UDim2.new(1, 0, 0, 44)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.Parent = frame

-- Campo PlaceID
local placeIdLabel = Instance.new("TextLabel")
placeIdLabel.Text = "Place ID:"
placeIdLabel.Size = UDim2.new(0, 80, 0, 26)
placeIdLabel.Position = UDim2.new(0, 22, 0, 60)
placeIdLabel.BackgroundTransparency = 1
placeIdLabel.TextColor3 = Color3.fromRGB(210,210,210)
placeIdLabel.Font = Enum.Font.Gotham
placeIdLabel.TextSize = 19
placeIdLabel.TextXAlignment = Enum.TextXAlignment.Left
placeIdLabel.Parent = frame

local placeIdBox = Instance.new("TextBox")
placeIdBox.PlaceholderText = "Ej: 109983668079237"
placeIdBox.Size = UDim2.new(0, 210, 0, 28)
placeIdBox.Position = UDim2.new(0, 110, 0, 60)
placeIdBox.BackgroundColor3 = Color3.fromRGB(46,46,56)
placeIdBox.TextColor3 = Color3.fromRGB(240,240,240)
placeIdBox.Font = Enum.Font.Gotham
placeIdBox.TextSize = 18
placeIdBox.ClearTextOnFocus = false
placeIdBox.Text = ""
placeIdBox.Parent = frame

-- Campo JobID
local jobIdLabel = Instance.new("TextLabel")
jobIdLabel.Text = "Job ID:"
jobIdLabel.Size = UDim2.new(0, 80, 0, 26)
jobIdLabel.Position = UDim2.new(0, 22, 0, 100)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.TextColor3 = Color3.fromRGB(210,210,210)
jobIdLabel.Font = Enum.Font.Gotham
jobIdLabel.TextSize = 19
jobIdLabel.TextXAlignment = Enum.TextXAlignment.Left
jobIdLabel.Parent = frame

local jobIdBox = Instance.new("TextBox")
jobIdBox.PlaceholderText = "Pega el Job ID aquí"
jobIdBox.Size = UDim2.new(0, 210, 0, 28)
jobIdBox.Position = UDim2.new(0, 110, 0, 100)
jobIdBox.BackgroundColor3 = Color3.fromRGB(46,46,56)
jobIdBox.TextColor3 = Color3.fromRGB(240,240,240)
jobIdBox.Font = Enum.Font.Gotham
jobIdBox.TextSize = 18
jobIdBox.ClearTextOnFocus = false
jobIdBox.Text = ""
jobIdBox.Parent = frame

-- Botón para pegar clipboard en JobID
local pasteJobButton = Instance.new("TextButton")
pasteJobButton.Text = "Pegar clipboard"
pasteJobButton.Size = UDim2.new(0, 128, 0, 24)
pasteJobButton.Position = UDim2.new(0, 110, 0, 135)
pasteJobButton.BackgroundColor3 = Color3.fromRGB(90, 130, 180)
pasteJobButton.TextColor3 = Color3.fromRGB(230,230,230)
pasteJobButton.Font = Enum.Font.GothamSemibold
pasteJobButton.TextSize = 16
pasteJobButton.AutoButtonColor = true
pasteJobButton.Parent = frame

pasteJobButton.MouseButton1Click:Connect(function()
    local clipboardText = UserInputService:GetClipboard()
    if clipboardText and clipboardText ~= "" then
        jobIdBox.Text = clipboardText
    end
end)

-- Botón para teletransportar
local joinButton = Instance.new("TextButton")
joinButton.Text = "Unirse"
joinButton.Size = UDim2.new(0, 140, 0, 38)
joinButton.Position = UDim2.new(0.5, -70, 1, -58)
joinButton.BackgroundColor3 = Color3.fromRGB(70, 180, 100)
joinButton.TextColor3 = Color3.fromRGB(255,255,255)
joinButton.Font = Enum.Font.GothamBold
joinButton.TextSize = 20
joinButton.AutoButtonColor = true
joinButton.Parent = frame

joinButton.MouseButton1Click:Connect(function()
    local placeId = tonumber(placeIdBox.Text)
    local jobId = jobIdBox.Text
    if placeId and jobId and string.len(jobId) > 20 then
        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
        end)
        if not success then
            jobIdBox.Text = ""
            jobIdBox.PlaceholderText = "Error: Job ID/PlaceID inválido"
        end
    else
        jobIdBox.PlaceholderText = "Rellena ambos campos correctamente"
    end
end)

-- --- (Opcional) Arrastrable ---
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
