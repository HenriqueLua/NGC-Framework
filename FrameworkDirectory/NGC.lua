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
			if (RunService:IsServer()) then resolve("Server") elseif (RunService:IsClient()) then resolve("Client") end
		end):andThen(function(Face)

			module_:Running() -- [Start Running]

			-- #AfterRunning:

			Packets.Promise.new(function(resolve, onCancel, reject)
				if (Face == "Client") then if (game:IsLoaded()) then resolve() elseif (not game:IsLoaded()) then game.Loaded:Wait() resolve() end
				elseif (Face == "Server") then
					resolve()
				end
			end):andThen(function()
				module_:AfterRunning()
			end)


		end)

	end
	return {
		ConnectServices = function(Folder: Folder | Instance) 
			assert(typeof(Folder) == "Instance", "Error! Folder (ConnectServices(Folder)) is not of type 'Folder'!")
			local ListOfServices = { }
			for _Index, Elements in pairs(Folder:GetChildren()) do table.insert(ListOfServices, Elements); initializationBridge(Elements) end
			Framework.Services = ListOfServices --[Add services in table 'Services']
		end;
		ConnectUsufruidores = function(Folder: Folder | Instance) 
			assert(typeof(Folder) == "Instance", "Error! Folder (ConnectServices(Folder)) is not of type 'Folder'!")
			local ListOfServices = { }
			for _Index, Elements in pairs(Folder:GetChildren()) do table.insert(ListOfServices, Elements); initializationBridge(Elements) end
			Framework.Usufruidores = ListOfServices --[Add services in table 'Usufruidores']
		end;
	}
end


function Framework:Create(Data: table)
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

					Framework.UsufruidoresStorage[Data.Name] = { Name = Data.Name, StorageData = Data.StorageData, Events = Data.Events }
					
					local DataUse = Framework.UsufruidoresStorage[Data.Name]

					for Index = 1, #DataUse.Events do
						local Signal = DataUse.Events[Index]
						CreateSignal(Signal[1], Signal[2], Signal[3], Signal[4], DataUse)
					end
					
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

					Framework.ServicesStorage[Data.Name] = {Name = Data.Name, StorageData = Data.StorageData, Events = Data.Events}
					
					local DataUse = Framework.ServicesStorage[Data.Name]
					
					for Index = 1, #DataUse.Events do
						local Signal = DataUse.Events[Index]
						CreateSignal(Signal[1], Signal[2], Signal[3], Signal[4], DataUse)
					end
					
				elseif (not Entry) then error("'Entry > true'expected, but, is 'false'! [Services List do not loaded!]") end
			end)
		end
	end)
	if (RunService:IsServer()) then return Framework.ServicesStorage[Data.Name] elseif (RunService:IsClient()) then return Framework.UsufruidoresStorage[Data.Name] end
end

--[[

CreateSignal:

  	Events = {
		Example = { "Nome do seu evento (Example)", "BindableEvent" (Tipo do evento), 
		"Service" (Nome do Usufruidor/Serviço), script (Coloque o seu index/ModuleScript aqui) }
	};


]]

function CreateSignal( NameSignal, NameEvent: string, NameIndex: string, Index: ModuleScript, DataUse )
	Packets.Promise.new(function(resolve, onCancel, reject)
		local Signals: Folder, Name = Instance.new("Folder"), "Signals"
		local SignalsTypes = { 

			-- [Events Types]

			BindableEvent = {Instance = Instance.new("BindableEvent"), Type = "BindableEvent"};
			RemoteEvent = {Instance = Instance.new("RemoteEvent"), Type = "RemoteEvent"};

			-- [Functions Types]

			BindableFunction = {Instance = Instance.new("BindableFunction"), Type = "BindableFunction"};
			RemoteFunction = {Instance = Instance.new("RemoteFunction"), Type = "RemoteFunction"};

		}

		if (not Index:FindFirstChild("Signals")) then Signals.Parent = (Index); Signals.Name = (Name) end

		local Item = SignalsTypes[NameEvent]
		local Signal, Type = Item.Instance:Clone(), Item.Type; 

		Signal.Parent = Index:WaitForChild(Name);
		Signal.Name = NameSignal;
		
		resolve(Signal, Type)
		
	end):andThen(function( Signal, Type )
		table.insert(DataUse.Events.EventsDeep, { [NameEvent] = {Instance = Signal, Type = Type} })
	end)
end

return Framework