--[[
   
   Framework-Documentation https://github.com/HenriqueLua/NGC-Framework;
   Creator: Henrique/NGC7380;
   Date: 27/01/2021.
   
   Framework Copyright License Atribuite © 2022 !
   
]]

type Framework = {
	Services : Folder;
	Usufruidores: Folder;
}

type Packets = {
	Promise : ModuleScript | any;
	TableUtil : ModuleScript | any;
}

type Messages = {
	ErrorGrammatical : string;
}

local ModuleScript: ModuleScript = script

local RunService: RunService = game:GetService("RunService")
local Stats_: Stats = game:GetService("Stats")

local Messages = {
	ErrorGrammatical = "Error! Framework:%s(%s) Data.%s don't exist, or not is the first argument or not has renamed with name '%s' at variable it!";
}

local Packets: Packets = {
	Promise = require(ModuleScript.Parent:WaitForChild("Packets").Promise);
	TableUtil = require(ModuleScript.Parent:WaitForChild("Packets").TableUtil)
} 

local Framework: Framework = {

	-- @Folders accessible storages (Client & Server):

	Services = {}; ServicesStorage = {};
	Usufruidores = {}; UsufruidoresStorage = {};

}

function Framework:ConnectBridge( ): RBXScriptSignal?
	local function initializationBridge(module: ModuleScript)

		local module_ = require(module)
		local Keys = Packets.TableUtil.Keys(module_)

		-- #Running:

		Packets.Promise.new(function(resolve, onCancel, reject)
			if (not Keys[table.find(Keys, "Running")]) then warn("Error! Running not started... [Running Function: Don't exist!]") return end 
			if (Stats_:GetTotalMemoryUsageMb( ) >= 0) then
				if (RunService:IsServer()) then resolve("Server") elseif (RunService:IsClient()) then resolve("Client") end
			end
		end):andThen(function(Face)

			module_:Running() -- [Start Running]

			-- #AfterRunning:

			Packets.Promise.new(function(resolve, onCancel, reject)
				if (Keys[table.find(Keys, "AfterRunning")]) and (Stats_:GetTotalMemoryUsageMb() > 0) then
					if (Face == "Client") then if (game:IsLoaded()) then resolve() elseif (not game:IsLoaded()) then game.Loaded:Wait() resolve() end
				    elseif (Face == "Server") then
						resolve()
				    end
				end
			end):andThen(function()
				module_:AfterRunning()
			end)


		end)

		-- #RunningUpdate

		Packets.Promise.new(function(resolve, onCancel, reject)
			if (Keys[table.find(Keys, "RunningUpdate")]) then
				if (RunService:IsClient()) or (RunService:IsServer()) then resolve() end
			end
		end):andThen(function()
			local RunningUpdate = module_:RunningUpdate()
			for Index = 1, #RunningUpdate do
				RunService[RunningUpdate[Index].Style]:Connect(function(deltaTime: number)
					RunningUpdate[Index].Occurrence(deltaTime);
				end)
			end
		end)

	end
	return {
		ConnectServices = function(Folder: Folder | Instance) 
			assert(typeof(Folder) == "Instance", "Error! Folder (ConnectServices(Folder)) is not of type 'Folder'!")
			local ListOfServices = { }
			for _Index, Elements in pairs(Folder:GetChildren()) do table.insert(ListOfServices, Elements); initializationBridge(Elements) end
			Framework.Services = ListOfServices --[Add services in table 'Services']
			return {
				__conclude = function()
					warn("[Server] => Initiated successfully!")
				end
			}
		end;
		ConnectUsufruidores = function(Folder: Folder | Instance) 
			assert(typeof(Folder) == "Instance", "Error! Folder (ConnectServices(Folder)) is not of type 'Folder'!")
			local ListOfServices = { }
			for _Index, Elements in pairs(Folder:GetChildren()) do table.insert(ListOfServices, Elements); initializationBridge(Elements) end
			Framework.Usufruidores = ListOfServices --[Add services in table 'Usufruidores']
			return {
				__conclude = function()
					warn("[Client] => Initiated successfully!")
				end
			}
		end;
	}
end


function Framework:Create(Data: table)
	
	local Keys = Packets.TableUtil.Keys(Data)
	
	if (Keys[table.find(Keys, "Name")] ~= 'Name') then error("Error! Framework:Create(Data: table) Data.Name don't exist, or not is the first argument or not has renamed with name 'Name' at variable it!", 2) end
	if (Keys[table.find(Keys, "StorageData")] ~= 'StorageData') then error("Error! Framework:Create(Data: table) Data.StorageData don't exist, or not is the first argument or not has renamed with name 'StorageData' at variable it!", 2) end
	if (Keys[table.find(Keys, "Events")] ~= 'Events') then error("Error! Framework:Create(Data: table) Data.Events don't exist, or not is the first argument or not has renamed with name 'Events' at variable it!", 2) end
	
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

function Framework:GetSingleton( Name: string, Additional: any )

	local Keys = Packets.TableUtil.Keys(Additional)
	if (Keys[table.find(Keys, "Entry")] ~= 'Entry') then error(string.format(Messages.ErrorGrammatical, "GetSingleton", "Additional", "Entry", "Entry"), 2) end

	--[[ @Como usar o Additional 

	    Use o "Additional" igual abaixo:

		```lua

		Additional = {
			Entry: string = "Usufruidores" | "Services"
		}

		```

	--]]

	if (RunService:IsClient() and Additional.Entry == "Usufruidores") then
		repeat RunService.Heartbeat:Wait() until (Packets.TableUtil.IsEmpty(self.UsufruidoresStorage) == false)
		return self.UsufruidoresStorage[Name], {
			__conclude = function( type_ )
				type_("[GetSingleton]: successfully complete! [In Client]") 
			end
		};
	elseif (RunService:IsClient() and Additional.Entry == ("Services")) then
		-- #Devlopment
	end

	if (RunService:IsServer() and Additional.Entry == "Services") then
		repeat RunService.Heartbeat:Wait() until (Packets.TableUtil.IsEmpty(self.ServicesStorage) == false)
		return self.ServicesStorage[Name], {
			__conclude = function( type_ )
				type_("[GetSingleton]: successfully complete! [In Server]") 
			end
		};
	elseif (RunService:IsServer() and Additional.Entry == ("Usufruidores")) then
		-- #Devlopment
	end

end


return Framework