type Framework = {
	Services : Folder;
	Usufruidores: Folder;
}

local Framework: Framework = {
	
	-- @Folders accessible storages (Client & Server):

	Services = {};
	Usufruidores = {};

}

function Framework:ConnectBridge( ): RBXScriptSignal?
	local function initializationBridge()
	end
	return {
		ConnectServices = function(Folder: Folder | Instance) 
			assert(type(Folder) == "Folder", "Error! Folder (ConnectServices(Folder)) is not of type 'Folder'!")
	        local ListOfServices = { }
	        for _Index, Elements in ipairs(Folder:GetChildren()) do table.insert(ListOfServices, Elements) end
	        Framework.Services = ListOfServices --[Add services in table 'Services']
		end;
		ConnectUsufruidores = function(Folder: Folder | Instance) 
			assert(type(Folder) == "Folder", "Error! Folder (ConnectServices(Folder)) is not of type 'Folder'!")
	        local ListOfServices = { }
	        for _Index, Elements in ipairs(Folder:GetChildren()) do table.insert(ListOfServices, Elements) end
	        Framework.Usufruidores = ListOfServices --[Add services in table 'Usufruidores']
		end;
	}
end



return Framework