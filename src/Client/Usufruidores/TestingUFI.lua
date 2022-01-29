local NGC = require(game:GetService("ReplicatedStorage").NGC)

local TestingUFI = NGC:Create{
    Name = "TestingUFI";
    StorageData = {};
    Events = {EventsDeep = {}};
}

function TestingUFI:Running()

end

function TestingUFI:AfterRunning()
    local TestingUFI, Warn = NGC:GetSingleton("TestingUFI", {Entry = "Usufruidores"})
	Warn.__conclude(print)
end

return TestingUFI