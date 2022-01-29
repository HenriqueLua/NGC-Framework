local NGC = require(game:GetService("ReplicatedStorage").NGC)

local TestingUFI = NGC:Create{
    Name = "TestingUFI";
    StorageData = {};
    Events = {EventsDeep = {}};
}

function TestingUFI:Running()

end

function TestingUFI:AfterRunning()
    local TesUFI, Warn = NGC:GetSingleton("TesUFI", {Entry = "Usufruidores"})
	Warn.__conclude(print)
    TesUFI.Events.EventsDeep[1]["BindableEvent"].Instance:Fire()
end

return TestingUFI