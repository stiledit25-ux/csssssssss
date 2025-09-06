-- Embedded UI Library (RegularVynixu UI Library, simplified for embedding)
local Library = (function()
    local Library = {}
    -- Buraya UI Library'nin temel kodu gelecek (kısaltılmış ve embedlenmiş)
    -- UI oluşturma fonksiyonları, toggle, bind vs.
    -- (Gerekirse basitleştirilmiş versiyon yazılır)

    -- Basit örnek toggle ve bind işleyişi (console outputlu)
    function Library:CreateWindow(title)
        print("UI Window Created: "..title)
        local window = {}
        function window:AddToggle(params)
            print("Toggle added: "..params.text)
            window._toggleState = params.state or false
            function window:SetToggle(state)
                window._toggleState = state
                if params.callback then params.callback(state) end
            end
            return window
        end
        function window:AddBind(params)
            print("Bind added: "..params.text.." Key: "..tostring(params.key))
            if params.callback then params.callback(params.key) end
        end
        return window
    end
    return Library
end)()

-- Aimlock Script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

_G.AimlockEnabled = false
_G.AimlockKey = Enum.KeyCode.E

local Window = Library:CreateWindow("Solara Aimlock")

Window:AddToggle({
    text = "Enable Aimlock",
    state = false,
    callback = function(state)
        _G.AimlockEnabled = state
    end
})

Window:AddBind({
    text = "Aimlock Key",
    key = _G.AimlockKey,
    callback = function(newKey)
        _G.AimlockKey = newKey
    end
})

function GetClosestPlayer()
    local closest, shortest = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos = Camera:WorldToViewportPoint(v.Character.Head.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if dist < shortest then
                shortest = dist
                closest = v
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if _G.AimlockEnabled and UserInputService:IsKeyDown(_G.AimlockKey) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)
