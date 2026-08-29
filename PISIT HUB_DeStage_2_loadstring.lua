local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- 1. เตรียมข้อมูลที่จะส่ง
local logData = HttpService:JSONEncode({
    ["gameId"] = "5491688876",
    ["playerName"] = Player.Name,
    ["placeId"] = tostring(game.PlaceId),
    ["userId"] = Player.UserId,
    ["timeStr"] = "29/08/2026 เวลา 16:08:56 น."
})

-- 2. ส่งข้อมูลเข้า Cloudflare Worker (ใช้ request ของ Executor แทน PostAsync)
local requestFunc = syn and syn.request or http_request or request or fluxus and fluxus.request
if requestFunc then
    pcall(function()
        requestFunc({
            Url = "https://square-king-3019.kirsrsaema66.workers.dev/",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = logData
        })
    end)
    print("[PISIT HUB]: ส่งข้อมูลไปยัง Worker สำเร็จ!")
end

-- 3. โหลดและรันสคริปต์ Stage 4 จาก GitHub
local stage4Url = "https://raw.githubusercontent.com/DUCKTRXSH/pisid/refs/heads/main/PISIT%20HUB_Stage_4_loadstring.lua"
loadstring(game:HttpGet(stage4Url))()
