local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

local Directory = (script:WaitForChild("Usufruidores"))
local NGC = (require(ReplicatedStorage.NGC))

NGC:ConnectBridge().ConnectUsufruidores(Directory).__conclude();