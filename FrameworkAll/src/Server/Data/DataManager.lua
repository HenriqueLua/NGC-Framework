-- Data Manager
-- Henrique Gomes

-- @ProfileTemplate table is what empty profiles will default to.
-- @Updating the template will not include missing template values
--   in existing player profiles!
local ProfileTemplate = {
}

----- @Loaded Modules -----

local ProfileService = require(game.ReplicatedStorage:WaitForChild("NGC").Supplements.ProfileService)

----- @Private Variables -----

local Players = game:GetService("Players")

local ProfileStore = ProfileService.GetProfileStore(
    "Version",
    ProfileTemplate
)

local Profiles = {} -- [player] = profile

----- @Private Functions -----

local function PlayerAdded(player)
    local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")
    if profile ~= nil then
        profile:ListenToRelease(function()
            Profiles[player] = nil
            -- @The profile could've been loaded on another Roblox server:
            player:Kick()
        end)
        if player:IsDescendantOf(Players) == true then
            Profiles[player] = profile
        else
            -- @Player left before the profile loaded:
            profile:Release()
        end
    else
        -- @The profile couldn't be loaded possibly due to other
        --   @Roblox servers trying to load this profile at the same time:
        player:Kick() 
    end
end

----- @Initialize -----

-- @In case Players have joined the server earlier than this script ran:
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(PlayerAdded, player)
end

----- @Connections -----

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
    local profile = Profiles[player]
    if profile ~= nil then
        profile:Release()
    end
end)

local DataManager = {}

-- @Return DataProfile of @Player:

function DataManager:GetData(player)
    local profile = Profiles[player]
    if profile then
        return profile.Data
    end
end

return DataManager