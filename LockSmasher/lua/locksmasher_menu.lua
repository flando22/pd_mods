_G.LockSmasher = _G.LockSmasher or {}
_G.LockSmasher.Settings = _G.LockSmasher.Settings or {}
LockSmasher.Path = ModPath

LockSmasher.Settings.PowerToolsEntries = {
	"cs",		--lumber-lite l2
	"cutters",	--boltcutters
	"nin",		--pounder nailgun
	"dingdong"	--ding dong breaching tool
}

LockSmasher.Settings.Enabled = true
LockSmasher.Settings.Mode = 1
LockSmasher.Settings.Sparks = true

function LockSmasher:LoadSettings()
	local options = io.open(SavePath.."LockSmasher_Settings.json", "r")
	if options then
		local tabledata = json.decode(options:read("*all"))
		for key, val in pairs(tabledata) do
			self.Settings[key] = val
		end
		options:close()
	end
end

function LockSmasher:SaveSettings()
	local options = io.open(SavePath.."LockSmasher_Settings.json", "w+")
	if options then
		options:write(json.encode(self.Settings))
		options:close()
	end
end

if not io.open(SavePath.."LockSmasher_Settings.json", "r") then LockSmasher:SaveSettings() end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_LockSmasher", function(self)
	self:load_localization_file(LockSmasher.Path.."loc/en.json")
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_LockSmasher", function(menu)

	MenuCallbackHandler.LockSmasher_Enabled = function(self, item)
		LockSmasher.Settings.Enabled = item:value() == "on"
	end
	MenuCallbackHandler.LockSmasher_Mode = function(self, item)
		LockSmasher.Settings.Mode = tonumber(item:value())
	end
	MenuCallbackHandler.LockSmasher_Sparks = function(self, item)
		LockSmasher.Settings.Sparks = item:value() == "on"
	end
	
	MenuCallbackHandler.LockSmasher_SaveData = function(_)
		LockSmasher:SaveSettings()
	end

	LockSmasher:LoadSettings()
	MenuHelper:LoadFromJsonFile(LockSmasher.Path.."menu/options.json", LockSmasher, LockSmasher.Settings)
end)