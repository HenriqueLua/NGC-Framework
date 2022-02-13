
--[[
Use of the Framework (NGC), rights reserved & authorized use.
Visit the Framework website for more information! [https://github.com/HenriqueLua/NGC-Framework]
]]

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local NGC = require(ReplicatedStorage:WaitForChild('NGC'));

local TestingServer = NGC:Create{

    Name = "TestingServer";
    StorageData = { };
    Events = {
        EventsDeep = {};
    };

}

function TestingServer:Running()

end

function TestingServer:AfterRunning()
  local ServerPlayers = require(ReplicatedStorage:WaitForChild("NGC").Supplements.ServerPlayers);
  local TotalPlayersNow = ServerPlayers:GetPlayersTotal(nil, false);
  print(TotalPlayersNow)
end

function TestingServer:RunningUpdate()
     -- > Visit (https://github.com/HenriqueLua/NGC-Framework/releases/tag/FrameworkAvoid) to learn how to use this part of Singleton!
     return { }
end

return TestingServer
