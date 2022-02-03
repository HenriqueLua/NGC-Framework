--[[,
Use of the Framework (NGC), rights reserved & authorized use.
Visit the Framework website for more information! [https://github.com/HenriqueLua/NGC-Framework]
]]

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local NGC = require(ReplicatedStorage:WaitForChild('NGC'));

local Service = NGC:Create{

    Name = "Service";
    StorageData = { };
    Events = {
    EventsDeep = {};
    };

}

function Service:Running()
    
end

function Service:AfterRunning()
    
end

function Service:RunningUpdate()
-- > Visit (https://github.com/HenriqueLua/NGC-Framework/releases/tag/FrameworkAvoid) to learn how to use this part of Singleton!
    return { }
end

NGC:DeferLive({"2022", "2", "3", "Thursday", "18", "21", "25", "en-us", "Cidade destruída", 
function(Runner: RBXScriptConnection)
    print('as')
    local Bomb = workspace:WaitForChild("Bomb")
    for _, k in pairs(Bomb:GetChildren()) do
        k.Enabled = true
        task.wait(0.03)
        k.Enabled = false
    end
    workspace.House:Destroy() 
    Runner:Disconnect()
end, 
function(Runner: RBXScriptConnection) 
    print('state')
    workspace.House:Destroy() 
    Runner:Disconnect()
end
})

return Service
