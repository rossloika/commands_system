require(script.commands_system.scripts.startup)

local Players = game:GetService("Players")

local DataStoreService = game:GetService("DataStoreService")
local temporary_ban_ds = DataStoreService:GetDataStore("temporary_ban_datastore")

local commands_system = script.commands_system
local commands_folder = commands_system.commands
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc

local Command = require(scripts_folder.command)
local Commander = require(scripts_folder.commander)
local settings_module = require(commands_system.settings)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local commands_system_shared = ReplicatedStorage.Common.commands_system_shared
local remote_event = commands_system_shared.RemoteEvent

local temporary_ban = require(scripts_folder.temporary_ban)
local trello_api = require(scripts_folder.trello_api)

-- Trello Items
local boardID = trello_api:GetBoardID("Adonis Control Center")
local listID = trello_api:GetListID("Banlist",boardID)

local function check_trello_ban(player)
	local listInfo = trello_api:GetCardsInList(listID)
	for _, banned_player_card in pairs(listInfo) do
		local player_query = string.format("%s:%s", player.Name, player.UserId)
		if banned_player_card.name == player_query then
			return true
		end
	end
end

local function playerAdded(player)
	local success, result = pcall(function()
		return temporary_ban_ds:GetAsync(tostring(player.UserId), "temporary_ban_datastore")
	end)
	warn(success, result, os.time())
	if success then
		if result then
			if result.BanTime < os.time() then
				temporary_ban_ds:RemoveAsync(tostring(player.UserId))
				warn("Data removed")
			else
				warn(os.time())
				player:Kick("You are currently Time-Banned. Please try again later.")
			end
		else
			print("No data")
		end
	end
	if temporary_ban.find(player.UserId) then
		player:Kick(settings_module.ban_message)
	end
	if check_trello_ban(player) then
		player:Kick(settings_module.ban_message)
	end

	---

	local new_ui = Instance.new("ScreenGui")
	new_ui.Parent = player.PlayerGui
	new_ui.Name = "CustomAdminGui"
end

for _, player in ipairs(Players:GetPlayers()) do
    coroutine.wrap(playerAdded)(player)
end

Players.PlayerAdded:Connect(playerAdded)