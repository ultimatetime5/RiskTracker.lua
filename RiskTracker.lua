local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local API_URL = "https://mtlxlyqmcpzzqnzzyyus.supabase.co/rest/v1/fish_it_inventory"
local ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im10bHhseXFtY3B6enFuenp5eXVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM0OTU5MDksImV4cCI6MjA5OTA3MTkwOX0.2M02hdfHtD-Bw2OQdUbcJLoqLEeqIFT5oOkkFFfvoKc"

local req = request or (http and http.request) or http_request

-- Fungsi super pintar untuk mencari nilai item di folder mana pun (Deep Scan)
local function scanItem(namesTable)
    for _, name in pairs(namesTable) do
        local found = LocalPlayer:FindFirstChild(name, true)
        if found and (found:IsA("ValueBase") or found:IsA("NumberValue") or found:IsA("IntValue")) then
            return tonumber(found.Value) or 0
        end
    end
    return 0
end

local function sendInventory()
    local data = {
        username = LocalPlayer.Name,
        -- Memasukkan variasi nama item (pakai spasi / tanpa spasi) agar otomatis ketemu
        evolved_enchant = scanItem({"Evolved Enchant", "EvolvedEnchant", "EvolvedEnchantStone"}),
        runic_enchant = scanItem({"Runic Enchant", "RunicEnchant", "RunicEnchantStone"}),
        secret_fish = scanItem({"Secret", "Secret Fish", "SecretFish"}),
        ghostfinn_rod = scanItem({"Ghostfinn Rod", "GhostfinnRod"}),
        element_rod = scanItem({"Element Rod", "ElementRod"}),
        diamond_rod = scanItem({"Diamond Rod", "DiamondRod"}),
        ruby_gem = scanItem({"Ruby", "RubyGem", "RubyGemstone"})
    }

    if req then
        req({
            Url = API_URL,
            Method = "POST",
            Headers = {
                ["apikey"] = ANON_KEY,
                ["Authorization"] = "Bearer " .. ANON_KEY,
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end
end

task.spawn(sendInventory)
while task.wait(60) do
    sendInventory()
end
