local Rbxcookbook = {}

------------------------------------------------------------------------------

function Rbxcookbook:AngleBetween(vectorA: Vector3, vectorB: Vector3): number -- @Find angle between two vectors:
	return math.atan2(vectorA:Cross(vectorB).Magnitude, vectorA:Dot(vectorB))
end

------------------------------------------------------------------------------

-- Allows for linear interpolation between two colors using a specified Gamma value.

-- Utility function to apply a power to Color3
function Rbxcookbook:PowColor3(color: Color3, pow: number): Color3
    return Color3.new(math.pow(color.R, pow), math.pow(color.G, pow), math.pow(color.B, pow))
end

-- Interpolate between 'ColorA' and 'ColorB' by 'Frac' percentage with an optional 'Gamma' value. 
-- Typical gamma values range from 1.8 to 2.2. The default value is 2.0.

function Rbxcookbook:LerpColor(colorA: Color3, colorB: Color3, frac: number, gamma: number): Color3
    gamma = gamma or 2.0
    local ca = Rbxcookbook:PowColor3(colorA, gamma)
    local cb = Rbxcookbook:PowColor3(colorB, gamma)
    return Rbxcookbook:PowColor3(ca:Lerp(cb, frac), 1 / gamma)
end

------------------------------------------------------------------------------

-- Linear Interpolation (AKA Lerp)
-- Interpolate between 'a' and 'b' by 'x' percentage

function Rbxcookbook:Lerp(a: number, b: number, x: number)
	return a + ((b - a) * x)
end

------------------------------------------------------------------------------

-- Remap 'n' from the old range (oldMin, oldMax) to the new range (min, max)

function Rbxcookbook:Map(n: number, oldMin: number, oldMax: number, min: number, max: number): number
	return (min + ((max - min) * ((n - oldMin) / (oldMax - oldMin))))
end

------------------------------------------------------------------------------

-- SetPrimaryPartCFrame but avoids float errors via caching

-- ExampleSetterFunction = ModelCFramer(workspace.Model)
-- ExampleSetterFunction(CFrame.new(0, 5, 0))


function Rbxcookbook:ModelCFramer(model: Model): (cframe: CFrame) -> nil
	local primary = model.PrimaryPart
	local primaryCf = primary.CFrame
	local cache = {}
	for _,child in ipairs(model:GetDescendants()) do
		if (child:IsA("BasePart") and child ~= primary) then
			cache[child] = primaryCf:ToObjectSpace(child.CFrame)
		end
	end
	return function(desiredCf: CFrame)
		primary.CFrame = desiredCf
		for part,offset in pairs(cache) do
			part.CFrame = desiredCf * offset
		end
	end
end

------------------------------------------------------------------------------

-- Round 'x' to the nearest 'mult'

function Rbxcookbook:Round(x: number, mult: number): number
	return math.round(x / mult) * mult
end

------------------------------------------------------------------------------]

return Rbxcookbook