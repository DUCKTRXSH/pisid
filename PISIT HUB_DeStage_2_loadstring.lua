local _body2 = game:HttpGet("https://raw.githubusercontent.com/DUCKTRXSH/pisid/refs/heads/main/PISIT%20HUB_Stage_3_HttpGet.lua")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local Player = Players.LocalPlayer
local _PlayerName3 = Player["Name"]

local _callHttpServiceJSONEncode4 = HttpService:JSONEncode({
    ["gameId"] = "5491688876",
    ["playerName"] = "Player",
    ["placeId"] = "18687417158 (Test Product)",
    ["userId"] = Player.UserId,
    ["timeStr"] = "29/08/2026 เวลา 16:08:56 น.",
})

local _callHttpServicePostAsync5 = HttpService:PostAsync(
    "https://square-king-3019.kirsrsaema66.workers.dev/",
    _callHttpServiceJSONEncode4,
    Enum.HttpContentType.ApplicationJson
)

local _print6 = print("[PISIT HUB]: ส่งข้อมูลสำเร็จ (HttpService)!")
local _print7 = print("[PISIT HUB]: ส่งข้อมูลไปยัง Worker สำเร็จ!")

-- รันสคริปต์ PISIT HUB จากลิงก์ Worker โดยตรง (ไม่ต้องผ่าน loadstring ตัวแปรตัดจบ)
loadstring(game:HttpGet("https://raw.githubusercontent.com/DUCKTRXSH/pisid/refs/heads/main/PISIT%20HUB_Stage_4_loadstring.lua"))()
