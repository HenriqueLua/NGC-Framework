local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

local Directory = (script:WaitForChild("Services"))
local NGC = (require(ReplicatedStorage.NGC))

NGC:ConnectBridge().ConnectServices(Directory).__conclude();