-- Encrypted Tracker for Fish It
local _0xA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function _0xB(data)
    data = string.gsub(data, '[^'.._0xA..'=]', '')
    return (string.gsub(data, '.', function(x)
        if (x == '=') then return '' end
        local r, f = '', (_0xA:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d%d%d%d%d%d', function(x)
        local r = 0
        for i = 1, 8 do r = r + (x:sub(i,i) == '1' and 2^(8-i) or 0) end
        return string.char(r)
    end))
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Decrypting credentials safely on runtime
local SUPABASE_URL = _0xB("aHR0cHM6Ly9tdGx4bHlxbWNwenpxbnp6eXl1cy5zdXBhYmFzZS5jbw==")
local SUPABASE_ANON_KEY = _0xB("ZXlKaGJHY2lPaUpTVXpVTklYTWlMQ0p0ZFhBaU9pSldaVlpmZEdsemN6bHlaVzV6Y0dGMWMyVWlMQ0pwWVhRaU9qRTNNRE16TnpRNE9EazVfZXhwT0p6RTNNRE16TnpRNE9EazVNMTkwT0gwc0luSnZiR1Z6Y0dGMWMyVWlPaUptYVdOb2FYUWlMQ0pwWVhRaU9qRTNNRFl6TXpRM016STVfZXhwT0p6RTNNRFl6TXpRM016STVNMTkwT0gwc0luVjVjR1Z5Ym1GdFpTSTZJbVZ1WTNKeWRYUnBiMjRpTENKdVlXMWxJanBiZXlKMWNtbG5hVzVvSWpvaVlYQnBMM1Z6YlhWeWFXNW5JanVzZXlKMWNtbG5hVzUvY0hWeVlXSmhjMlVpT2lKbWRYSm9hWEpsWTNSeWIyNHVJanVzZXlKMWNtbG5hVzUvY0hWeVlXSmhjMlUvWVdsMGFXOXVJanVzZXlKMWNtbG5hVzUvY0hWeVlXSmhjMlUvWVdsMGFXOXVJanVzZXlKMWNtbG5hVzUvY0hWeVlXSmhjMlUvWTI5dWREMXphR1ZzYkhNaU9pSm1kV05vYVhKbFlM")
local API_URL = SUPABASE_URL .. "/rest/v1/fish_it_inventory"

local function sendInventory()
    local inv = LocalPlayer:FindFirstChild("Inventory") or LocalPlayer:FindFirstChild("leaderstats")
    if inv then
        local data = {
            username = LocalPlayer.Name,
            evolved_enchant = inv:FindFirstChild("EvolvedEnchantStone") and inv.EvolvedEnchantStone.Value or 0,
            runic_enchant = inv:FindFirstChild("RunicEnchantStone") and inv.RunicEnchantStone.Value or 0,
            secret_fish = inv:FindFirstChild("SecretFish") and inv.SecretFish.Value or 0,
            ghostfinn_rod = inv:FindFirstChild("GhostfinnRod") and inv.GhostfinnRod.Value or 0,
            element_rod = inv:FindFirstChild("ElementRod") and inv.ElementRod.Value or 0,
            diamond_rod = inv:FindFirstChild("DiamondRod") and inv.DiamondRod.Value or 0,
            ruby_gem = inv:FindFirstChild("RubyGemstone") and inv.RubyGemstone.Value or 0
        }
        pcall(function()
            request({
                Url = API_URL, Method = "POST",
                Headers = {["apikey"] = SUPABASE_ANON_KEY, ["Authorization"] = "Bearer " .. SUPABASE_ANON_KEY, ["Content-Type"] = "application/json", ["Prefer"] = "resolution=merge-duplicates"},
                Body = HttpService:JSONEncode(data)
            })
        end)
    end
end

task.spawn(sendInventory)
while task.wait(60) do sendInventory() end
