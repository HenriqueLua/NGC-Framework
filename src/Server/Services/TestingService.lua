local NGC = require(game:GetService("ReplicatedStorage").NGC)

local TestingService = NGC:Create{
    Name = "TestingService";
    StorageData = {};
    Events = {EventsDeep = {}};
}

function TestingService:Running()

end

function TestingService:AfterRunning()
end

return TestingService