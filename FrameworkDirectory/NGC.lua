type Framework = {
	Services : Folder;
	Usufruidores: Folder;
}

type Packets = {
	Promise : ModuleScript? | any;
}

local ModuleScript: ModuleScript = script

local RunService: RunService = game:GetService("RunService")

local Packets: Packets = {
	Promise = require(ModuleScript.Parent:WaitForChild("Packets").Promise);
} 

local Framework: Framework = {

	-- @Folders accessible storages (Client & Server):

	Services = {}; ServicesStorage = {};
	Usufruidores = {}; UsufruidoresStorage = {};

}

function Framework:ConnectBridge( ): RBXScriptSignal?
	local function initializationBridge(module: ModuleScript)
		
		local module_ = require(module)

		-- #Running:

		Packets.Promise.new(function(resolve, onCancel, reject)
			if (RunService:IsServer()) then resolve() end
		end):andThen(function()
			module_.Running()
		end)

		-- #AfterRunning:

		Packets.Promise.new(function(resolve, onCancel, reject)
			if (RunService:IsServer()) then 
				if (game:IsLoaded()) then resolve() elseif (not game:IsLoaded()) then game.Loaded:Wait() resolve() end
			end
		end):andThen(function()
			module_.AfterRunning()
		end)


	end
	return {
		ConnectServices = function(Folder: Folder | Instance) 
			assert(typeof(Folder) == "Instance", "Error! Folder (ConnectServices(Folder)) is not of type 'Folder'!")
			local ListOfServices = { }
			for _Index, Elements in ipairs(Folder:GetChildren()) do print(Elements) table.insert(ListOfServices, Elements); initializationBridge(Elements) end
			Framework.Services = ListOfServices --[Add services in table 'Services']
		end;
		ConnectUsufruidores = function(Folder: Folder | Instance) 
			assert(typeof(Folder) == "Instance", "Error! Folder (ConnectServices(Folder)) is not of type 'Folder'!")
			local ListOfServices = { }
			for _Index, Elements in ipairs(Folder:GetChildren()) do table.insert(ListOfServices, Elements) end
			Framework.Usufruidores = ListOfServices --[Add services in table 'Usufruidores']
		end;
	}
end


function Framework:Create(Data: table)
	assert(typeof(Data) == "table", "Data (Framework:Create(Data: table)) is not a table!")
	Packets.Promise.new(function(resolve, onCancel, reject)
		if (RunService:IsClient()) then
			Packets.Promise.new(function(resolve, onCancel, reject)
				if (Framework.Usufruidores) then
					resolve(true)
				elseif (not Framework.Usufruidores) then
					resolve(false)
				end
			end):andThen(function(Entry: boolean)
				if (Entry) then  

					table.insert(Framework.UsufruidoresStorage, {["Name"] = Data.Name --[[Table]], StorageData = Data.StorageData --[[Table]]})

				elseif (not Entry) then error("'Entry > true'expected, but, is 'false'! [Usufruidores List do not loaded!]") end
			end)
		elseif (RunService:IsServer()) then
			Packets.Promise.new(function(resolve, onCancel, reject)
				if (Framework.Services) then
					resolve(true)
				elseif (not Framework.Services) then
					resolve(false)
				end
			end):andThen(function(Entry: boolean)
				if (Entry) then  

					table.insert(Framework.ServicesStorage, {["Name"] = Data.Name, StorageData = Data.StorageData})

				elseif (not Entry) then error("'Entry > true'expected, but, is 'false'! [Services List do not loaded!]") end
			end)
		end
	end)
	return { ["Name"] = Data.Name, StorageData = Data.StorageData } --[For use your index after called!]
end

return Framework