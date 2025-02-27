local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--[[ Список моделей для ESP ]]
local targetNames = {"sandman", "gus", "FurThing", "Bixanti", "ashy"}
local espColor = Color3.new(0, 1, 0) -- Зеленый цвет для ESP (можно изменить)
local espTransparency = 0.8 -- Прозрачность ESP (от 0 до 1, где 0 - полностью видно, 1 - полностью прозрачно)
local espEnabled = false -- ESP выключен по умолчанию

--[[ Создаем ScreenGui ]]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPControlGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false -- **Важно!**

--[[ Создаем кнопку для включения/выключения ESP ]]
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Включить ESP"
toggleButton.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
toggleButton.Parent = screenGui

--[[ Функция для создания ESP ]]
local function createESP(target)
    if target:FindFirstChild("Highlight") then return end -- Проверяем, что ESP уже не создан

    local highlight = Instance.new("Highlight")
    highlight.Parent = target
    highlight.Name = "ESPHighlight"
    highlight.FillColor = espColor
    highlight.OutlineColor = espColor
    highlight.FillTransparency = espTransparency
    highlight.OutlineTransparency = espTransparency
end

--[[ Функция для удаления ESP ]]
local function removeESP(target)
    local highlight = target:FindFirstChild("ESPHighlight")
    if highlight then
        highlight:Destroy()
    end
end

--[[ Функция для обновления ESP ]]
local function updateESP()
    for _, targetName in ipairs(targetNames) do
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name:lower() == targetName:lower() then
                if espEnabled then
                    createESP(model)
                else
                    removeESP(model)
                end
            end
        end
    end
end

--[[ Вызываем функцию updateESP при добавлении новых объектов в игру ]]
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") then
        for _, targetName in ipairs(targetNames) do
            if descendant.Name:lower() == targetName:lower() then
                if espEnabled then
                    createESP(descendant)
                end
                break
            end
        end
    end
end)

--[[ Функция для включения/выключения ESP ]]
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        toggleButton.Text = "Выключить ESP"
    else
        toggleButton.Text = "Включить ESP"
    end
    updateESP()
end

--[[ Подключаем функцию toggleESP к кнопке ]]
toggleButton.MouseButton1Click:Connect(toggleESP)

--[[ Вызываем функцию updateESP при старте игры ]]
updateESP()
