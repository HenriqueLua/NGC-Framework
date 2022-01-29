local NGC = require(game:GetService("ReplicatedStorage").NGC)

local TesUFI = NGC:Create{
    Name = "TesUFI";
    StorageData = {
        Number = 10;
    };
    Events = {[1] = {"DestroyBaseplate", "BindableEvent", "TesUFI", script}, EventsDeep = {}};
}


function TesUFI:Running()

end

function TesUFI:AfterRunning()
    self.Events.EventsDeep[1]["BindableEvent"].Instance.Event:Connect(function()
        workspace.Baseplate:Destroy()
    end)
end


return TesUFI