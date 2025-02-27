local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local highlightEnabled = true --[[Переменная для отслеживания состояния подсветки и кликов]]
local currentHighlight = nil --[[Текущий подсвеченный объект]]
local proximityPrompt = nil
local targetPart = nil

--[[Функция для создания подсветки]]
local function createHighlight(part)
    local highlight = Instance.new("Highlight")
    highlight.Parent = part
    highlight.Name = "HoverHighlight"
    highlight.FillColor = Color3.new(1, 1, 0) --[[Жёлтый цвет]]
    highlight.OutlineColor = Color3.new(1, 1, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    return highlight
end

--[[Функция для удаления подсветки]]
local function destroyHighlight()
    if currentHighlight then
        currentHighlight:Destroy()
        currentHighlight = nil
        targetPart = nil
    end
end

--[[Функция для отображения информации об объекте (замените на свою логику)]]
local function showObjectInfo(part)
    if not part then return end
    --[[Пример: Создание UI элемента для отображения информации]]
    local objectName = part.Name
    print("Clicked on: " .. objectName)
    --[[Здесь можно добавить код для создания GUI и отображения информации об объекте]]
end

--[[Функция для обработки наведения мыши]]
local function handleMouseHover(mouse)
    local target = mouse.Target
    if not highlightEnabled then return end
    if target and target:IsA("BasePart") then
        if target ~= targetPart then
            destroyHighlight()
            targetPart = target
            currentHighlight = createHighlight(target)
        end
    else
        destroyHighlight()
    end
end

--[[Функция для обработки клика мыши]]
local function handleMouseClick(mouse)
    if not highlightEnabled then return end
    local target = mouse.Target
    if target and target:IsA("BasePart") then
        showObjectInfo(target)
    end
end

--[[Подключение к сервисам]]
local mouse = game.Players.LocalPlayer:GetMouse()
mouse.Move:Connect(function()
    RunService.Heartbeat:Wait()
    handleMouseHover(mouse)
end)
mouse.Button1Down:Connect(function()
    handleMouseClick(mouse)
end)

--[[Функция для включения/выключения подсветки и кликов]]
local function toggleHighlightAndClick(enabled)
    highlightEnabled = enabled
    if not highlightEnabled then
        destroyHighlight()
    end
end

--[[Пример: Создание кнопки в ScreenGui для включения/выключения]]
local function createToggleButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToggleGUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local textButton = Instance.new("TextButton")
    textButton.Size = UDim2.new(0, 150, 0, 30)
    textButton.Position = UDim2.new(0, 10, 0, 10)
    textButton.Text = "Disable Highlight"
    textButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    textButton.Parent = screenGui

    local enabled = true

    textButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleHighlightAndClick(enabled)
        if enabled then
            textButton.Text = "Disable Highlight"
        else
            textButton.Text = "Enable Highlight"
        end
    end)
end

createToggleButton()
