local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local API_URL = "https://mtlxlyqmcpzzqnzzyyus.supabase.co/rest/v1/fish_it_inventory"
local ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im10bHhseXFtY3B6enFuenp5eXVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM0OTU5MDksImV4cCI6MjA5OTA3MTkwOX0.2M02hdfHtD-Bw2OQdUbcJLoqLEeqIFT5oOkkFFfvoKc"

-- Deteksi fungsi request bawaan executor mobile
local sendReq = request or (http and http.request) or http_request

local function getStat(folderName, statName)
    local folder = LocalPlayer:FindFirstChild(folderName)
    if folder then
        local stat = folder:FindFirstChild(statName)
        if stat then return tonumber(stat.Value) or 0 end
    end
    return 0
end

local function sendInventory()
    local data = {
        username = LocalPlayer.Name,
        evolved_enchant = getStat("Save_Data", "Evolved Enchant"),
        runic_enchant = getStat("Save_Data", "Runic Enchant"),
        secret_fish = getStat("leaderstats", "Secret"),
        ghostfinn_rod = getStat("Save_Data", "Ghostfinn Rod"),
        element_rod = getStat("Save_Data", "Element Rod"),
        diamond_rod = getStat("Save_Data", "Diamond Rod"),
        ruby_gem = getStat("Save_Data", "Ruby")
    }
    
    -- Mengirim langsung tanpa pcall pembungkus agar error asli terlihat di console jika gagal
    if sendReq then
        sendReq({
            Url = API_URL,
            Method = "POST",
            Headers = {
                ["apikey"] = ANON_KEY,
                ["Authorization"] = "Bearer " .. ANON_KEY,
                ["Content-Type"] = "application/json",
                ["Prefer"] = "return=minimal"
            },
            Body = HttpService:JSONEncode(data)
        })
    else
        warn("Executor tidak mendukung HTTP Request!")
    end
end

task.spawn(sendInventory)

while task.wait(60) do
    sendInventory()
end
