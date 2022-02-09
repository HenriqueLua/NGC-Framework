--[[
	
	
	Camera Plus
	http://sleitnick.github.io/CameraPlus/
	
		Version 1.0.8
		March 25, 2014
		Created by Crazyman32
		
		Release:	April 3, 2014		[v.1.0.5]
		Update:		April 17, 2014		[v.1.0.7]
		Update:		February 24, 2015	[v.1.0.8]
		
	
	Camera Plus is an API wrapper for the default Camera
	object in ROBLOX to give additional support for
	doing tween animations with the camera.
	
	I made this API because I got tired of always writing
	custom camera cutscene systems for every new game I
	made. It was time to set a standard for my code that
	was unified! I had a lot of fun putting this together
	and am happy to share it with you all. I hope to see
	awesome camera cutscene animations spawn from how you
	guys use this!
	
	----
	This API uses Robert Penner's easing equations for
	interpolation calculations. The licensing information
	and other necessary credit is provided within the
	"Easing" ModuleScript parented within this ModuleScript.
	----
	
	Contact me on Twitter: @RBX_Crazyman32
	
	
	------------------------------------------------------------------
	
	HOW TO USE
	
	
	Please refer to my API Reference for CameraPlus:
	
	
			http://sleitnick.github.io/CameraPlus/
			
	
--]]




-----------------------------------------------------
-- Constants:

local CFRAME = CFrame.new
local CAMTYPE_SCRIPTABLE = Enum.CameraType.Scriptable
local CAMTYPE_CUSTOM = Enum.CameraType.Custom
local CLASS_NAME = "CameraPlus"

-----------------------------------------------------



local CameraPlus = {}
local API = {}
local MT = {}



local function ReadOnly(tbl)
	local t = {}
	local mt = {}
	mt.__metatable = true
	mt.__index = tbl
	mt.__newindex = function()
		error("Cannot add to read-only table", 0)
	end
	setmetatable(t, mt)
	return t
end


local function CFrameToPosAndFocus(cf, lookDistance)
	local pos = cf.p
	local foc = (pos + (cf.lookVector * (type(lookDistance) == "number" and lookDistance or 10)))
	return pos, foc
end


local RenderWait do
	local rs = game:GetService("RunService").RenderStepped
	function RenderWait()
		rs:wait()
	end
end


local function Tween(easingFunc, duration, callbackFunc)
	local tick = tick
	local start = tick()
	local dur = 0
	local ratio = 0
	local RW = RenderWait
	while (dur < duration) do
		ratio = easingFunc(dur, 0, 1, duration)
		dur = (tick() - start)
		callbackFunc(ratio)
		RW()
	end
	callbackFunc(1)
end



------------------------------------------------------------------------------------------------------------------------------
-- API:


local camera = game.Workspace.CurrentCamera
local lookAt = nil



API.Ease = (function()
	local Easing = require(script.Easing)
	local In, Out, InOut = {}, {}, {}
	for name,func in pairs(Easing) do	-- "Parse" out the easing functions:
		if (name == "linear") then
			In["Linear"] = func
			Out["Linear"] = func
			InOut["Linear"] = func
		else
			local t,n = name:match("^(inOut)(.+)")
			if (not t or not n) then t,n = name:match("^(in)(.+)") end
			if (not t or not n) then t,n = name:match("^(out)(.+)") end
			if (n) then
				n = (n:sub(1, 1):upper() .. n:sub(2):lower())
			end
			if (t == "inOut") then
				InOut[n] = func
			elseif (t == "in") then
				In[n] = func
			elseif (t == "out") then
				Out[n] = func
			end
		end
	end
	return ReadOnly {
		In = ReadOnly(In);
		Out = ReadOnly(Out);
		InOut = ReadOnly(InOut);
	}
end)();


-- Set the camera's position
function API:SetPosition(position)
	
	if (camera.CameraType == CAMTYPE_SCRIPTABLE) then
		if (not lookAt) then
			lookAt = (camera.CoordinateFrame.p + (camera.CoordinateFrame.lookVector * 5))
		end
		camera.CoordinateFrame = CFRAME(position, lookAt)
	else
		if (not lookAt) then
			lookAt = camera.Focus.p
		end
		camera.CoordinateFrame = CFRAME(position)
		camera.Focus = CFRAME(lookAt)
	end
	
end



-- Get the camera's position
function API:GetPosition()
	return camera.CoordinateFrame.p
end



-- Set what the camera is looking at
function API:SetFocus(focus)
	lookAt = focus
	self:SetPosition(self:GetPosition())
end




-- Set the camera's position and what it is looking at
function API:SetView(position, focus)
	lookAt = focus
	self:SetPosition(position)
end



-- Set the camera's FieldOfView
function API:SetFOV(fov)
	camera.FieldOfView = fov
end



-- Get the camera's FieldOfView
function API:GetFOV()
	return camera.FieldOfView
end



-- Increment the camera's current FieldOfView
function API:IncrementFOV(deltaFov)
	camera.FieldOfView = (camera.FieldOfView + deltaFov)
end



-- Set the camera's roll
-- OVERRIDE Camera:SetRoll
function API:SetRoll(roll)
	camera:SetRoll(roll)
end



-- Get the camera's roll
-- OVERRIDE Camera:GetRoll
function API:GetRoll()
	return camera:GetRoll()
end



-- Increment the camera's current roll
function API:IncrementRoll(deltaRoll)
	camera:SetRoll(camera:GetRoll() + deltaRoll)
end



-- Tween the camera from one position to the next
function API:Tween(cframeStart, cframeEnd, duration, easingFunc)
	camera.CameraType = CAMTYPE_SCRIPTABLE
	local startPos, startLook = CFrameToPosAndFocus(cframeStart)
	local endPos, endLook = CFrameToPosAndFocus(cframeEnd)
	local curPos, curLook = startPos, startLook
	local function Callback(ratio)
		curPos = startPos:lerp(endPos, ratio)
		curLook = startLook:lerp(endLook, ratio)
		camera.CoordinateFrame = CFRAME(curPos, curLook)
	end
	Tween(easingFunc, duration, Callback)
end



-- Tween the camera to the position from the current position
function API:TweenTo(cframeEnd, duration, easingFunc)
	camera.CameraType = CAMTYPE_SCRIPTABLE
	self:Tween(camera.CoordinateFrame, cframeEnd, duration, easingFunc)
end



-- Tween the camera from the current position back to the player
function API:TweenToPlayer(duration, easingFunc)
	local player = game.Players.LocalPlayer
	local humanoid, walkSpeed = player.Character:FindFirstChild("Humanoid")
	if (humanoid) then
		walkSpeed = humanoid.WalkSpeed
		humanoid.WalkSpeed = 0
	end
	local head = player.Character.Head
	local cframeEnd = CFrame.new((head.Position - (head.CFrame.lookVector * 10)), head.Position)
	self:TweenTo(cframeEnd, duration, easingFunc)
	camera.CameraType = CAMTYPE_CUSTOM
	camera.CameraSubject = player.Character
	if (humanoid) then
		humanoid.WalkSpeed = walkSpeed
	end
end



-- Tween FieldOfView
function API:TweenFOV(startFov, endFov, duration, easingFunc)
	local fov = startFov
	local diffFov = (endFov - startFov)
	local function Callback(ratio)
		fov = (startFov + (diffFov * ratio))
		camera.FieldOfView = fov
	end
	Tween(easingFunc, duration, Callback)
end



-- Tween to FieldOfView from current FieldOfView
function API:TweenToFOV(endFov, duration, easingFunc)
	self:TweenFOV(camera.FieldOfView, endFov, duration, easingFunc)
end



-- Tween the camera's roll
function API:TweenRoll(startRoll, endRoll, duration, easingFunc)
	camera.CameraType = CAMTYPE_SCRIPTABLE
	local roll = startRoll
	local diffRoll = (endRoll - startRoll)
	local function Callback(ratio)
		roll = (startRoll + (diffRoll * ratio))
		camera:SetRoll(roll)
	end
	Tween(easingFunc, duration, Callback)
end



-- Tween the camera's roll from the current roll
function API:TweenToRoll(endRoll, duration, easingFunc)
	self:TweenRoll(camera:GetRoll(), endRoll, duration, easingFunc)
end



-- Tween all parts of the camera
function API:TweenAll(cframeStart, cframeEnd, fovStart, fovEnd, rollStart, rollEnd, duration, easingFunc)
	camera.CameraType = CAMTYPE_SCRIPTABLE
	local startPos, startLook = CFrameToPosAndFocus(cframeStart)
	local endPos, endLook = CFrameToPosAndFocus(cframeEnd)
	local pos, look = startPos, startLook
	local fov, fovDiff = fovStart, (fovEnd - fovStart)
	local roll, rollDiff = rollStart, (rollEnd - rollStart)
	local function Callback(ratio)
		pos = startPos:lerp(endPos, ratio)
		look = startLook:lerp(endLook, ratio)
		fov = (fovStart + (fovDiff * ratio))
		roll = (rollStart + (rollDiff * ratio))
		camera.CoordinateFrame = CFRAME(pos, look)
		camera.FieldOfView = fov
		camera:SetRoll(roll)
	end
	Tween(easingFunc, duration, Callback)
end



-- Tween all parts of the camera from the current camera properties
function API:TweenToAll(cframeEnd, fovEnd, rollEnd, duration, easingFunc)
	camera.CameraType = CAMTYPE_SCRIPTABLE
	self:TweenAll(
		camera.CoordinateFrame, 	cframeEnd,
		camera.FieldOfView,			fovEnd,
		camera:GetRoll(),			rollEnd,
		duration,
		easingFunc
	)
end




-- OVERRIDE Camera:Interpolate
function API:Interpolate(endPos, endFocus, duration)
	self:TweenTo(CFRAME(endPos, endFocus), duration, self.Ease.InOut.Sine)
end



-- OVERRIDE Camera:IsA
function API:IsA(className)
	return (className == CLASS_NAME or camera:IsA(className))
end



------------------------------------------------------------------------------------------------------------------------------
-- MT:

-- Protects the API and hooks it onto the camera object, therefore
-- the API essentially appears to be an extention to the camera
-- object itself when used.

MT.__metatable = true
MT.__index = function(t, k)
	local value = (API[k] or camera[k])
	return value
end
MT.__newindex = function(t, k, v)
	if (API[k]) then
		error("Cannot change CameraPlus API", 0)
	else
		camera[k] = v
	end
end
MT.__eq = function(t, other)
	return (t == other or camera == other)
end
setmetatable(CameraPlus, MT)

------------------------------------------------------------------------------------------------------------------------------

return CameraPlus