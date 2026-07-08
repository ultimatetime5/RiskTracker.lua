local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local API_URL = "https://mtlxlyqmcpzzqnzzyyus.supabase.co/rest/v1/fish_it_inventory"
local ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im10bHhseXFtY3B6enFuenp5eXVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM0OTU5MDksImV4cCI6MjA5OTA3MTkwOX0.2M02hdfHtD-Bw2OQdUbcJLoqLEeqIFT5oOkkFFfvoKc"

local req = request or (http and http.request) or http_request

-- Mengambil modul data save internal dari game Fish It
local function getInventoryData()
    local success, save = pcall(function()
        return game:GetService("ReplicatedStorage").CloudSave.GetSave:InvokeServer()
    end)
    if success and type(save) == "table" then
        return save
    end
    return nil
end

local function sendInventory()
    local save = getInventoryData()
    
    local function val(key)
        if not save then return 0 end
        -- Mengecek apakah item ada di dalam sub-tabel Inventory atau tabel utama save
        if save.Inventory and save.Inventory[key] then
            return tonumber(save.Inventory[key]) or 0
        elseif save[key] then
            return tonumber(save[key]) or 0
        end
        return 0
    end

    local data = {
        username = LocalPlayer.Name,
        evolved_enchant = val("Evolved Enchant Stone"),
        runic_enchant = val("Runic Enchant Stone"),
        secret_fish = val("Secret") or 0,
        ghostfinn_rod = val("Ghostfinn Rod"),
        element_rod = val("Element Rod"),
        diamond_rod = val("Diamond Rod"),
        ruby_gem = val("Ruby Gemstone")
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
