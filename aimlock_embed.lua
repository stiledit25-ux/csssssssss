print("Script başladı!")

local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/UI-Library/main/Library.lua"))()
end)

if success then
    print("UI Library yüklendi!")
    local Window = Library:CreateWindow("Aimlock Menu Test")

    Window:AddToggle({
        text = "Enable Aimlock",
        state = false,
        callback = function(value)
            print("Aimlock durumu:", value)
        end
    })

    Window:AddBind({
        text = "Set Aimlock Key",
        key = Enum.KeyCode.E,
        callback = function(newKey)
            print("Yeni Aimlock tuşu:", newKey.Name)
        end
    })
else
    warn("UI Library yüklenirken hata:", Library)
end
