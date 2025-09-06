--// Aimlock Script with Menu (by stiledit25-ux)
--// You need a Lua executor to run this (like Synapse X, Fluxus, etc.)

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

--// Settings
_G.AimlockEnabled = false
_G.AimlockKey = Enum.KeyCode.E

--// UI Library (Vynixu's Simple Library)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/UI-Library/main/Library.lua"))()
local Window = Library:CreateWindow("Aimlock Menu")

Window:AddToggle({
    text = "Enable Aimlock",
    state = false,
    callback = function(value)
        _G.AimlockEnabled = value
    end
})

Window:AddBind({
    text = "Set Aimlock Key",
    key = _G.AimlockKey,
    callback = function(newKey)
        _G.AimlockKey = newKey
    end
})

--// Function to get closest player to mouse
function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

--// Main Aimlock Logic
RunService.RenderStepped:Connect(function()
    if _G.AimlockEnabled and UserInputService:IsKeyDown(_G.AimlockKey) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local headPos = target.Character.Head.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
        end
    end
end)
