function main()

end

local Players = game:GetService("Players");

local commands_system = script.Parent.Parent
local commands_folder = commands_system.commands
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc

local Command = require(scripts_folder.command)
local Commander = require(scripts_folder.commander)
local settings_module = require(commands_system.settings)
local send_game_notification = require(scripts_folder.send_notification)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local commands_system_shared = ReplicatedStorage.Common.commands_system_shared
local remote_event = commands_system_shared.RemoteEvent

-- local users_access_levels = {
-- 	groups = {
-- 		{
-- 			group_id = 0,
-- 			ranks = {
-- 				{
-- 					rank_id = 0,
-- 					access_level = settings_module.access_level.moderator,
-- 				},
-- 			},
-- 		},
-- 	},
-- 	users = {
-- 		{
-- 			player_id = 0,
-- 			access_level = settings_module.access_level.moderator,
-- 		},
-- 	},
-- }

-- Find player via a string
local function find_player(player)
	for _, players in ipairs(game.Players:GetPlayers()) do
		if player:lower() == players.Name:lower():sub(1, #player:lower()) then 
			return game.Players:FindFirstChild(tostring(players))
		end
	end
end

--- @returns { access_level | nil }
local function get_user_access_level_by_user_in_users(player_id)
	for _, user in ipairs(settings_module.users_access_levels.users) do
		if user.player_id == player_id then
			return user.access_level
		end
	end

	return nil
end

--- @returns { access_level | nil }
local function get_user_access_level_by_ranks_in_groups(player_id)
	local user_access_level_from_rank = nil

	local player = Players:GetPlayerByUserId(player_id)

	for _, group in ipairs(settings_module.users_access_levels.groups) do
		local player_rank_id = player:GetRankInGroup(group.group_id)

		for _, rank in ipairs(group.ranks) do
			if player_rank_id == rank.rank_id then
				if type(user_access_level_from_rank) ~= 'number' or rank.access_level > user_access_level_from_rank then
					user_access_level_from_rank = rank.access_level
				end
				break
			end
		end
	end

	return user_access_level_from_rank
end

--- @returns { access_level }
local function get_user_access_level(player_id)
	local user_access_level_from_users = get_user_access_level_by_user_in_users(player_id)

	-- the access_level specified in users should be considered as the optimal result
	if type(user_access_level_from_users) ~= 'nil' then
		return user_access_level_from_users
	end

	local user_access_level_from_ranks_in_groups = get_user_access_level_by_ranks_in_groups(player_id)

	-- the highest permission level granted by the users rank in the groups
	if type(user_access_level_from_ranks_in_groups) ~= 'nil' then
		return user_access_level_from_ranks_in_groups
	end

	-- as a fallback, assume that the user is a guest
	return settings_module.access_level.guest
end

local function table_slice(tbl, first, last)
	local sliced = {}

	for i = first or 1, last or #tbl, 1 do
		sliced[#sliced + 1] = tbl[i]
	end

	return sliced
end

function table_find(tbl, callback)
    local matched = nil

    for key, value in pairs(tbl) do
        if callback(value, key, tbl) then
            matched = value
            break
        end
    end

    return matched
end

for _, commandFile in ipairs(commands_folder:GetChildren()) do
    Commander.registerCommand(commandFile)
end

remote_event.OnServerEvent:Connect(function(player, message)
    local split_message = message:split(" ")
    local command_prefix = settings_module.prefix
    local command_name = string.sub(split_message[1], #command_prefix + 1, #split_message[1])
    local command_arguments = table_slice(split_message, 2, #split_message)
    local combined_command_arguments = table.concat(command_arguments, " ", 2, #command_arguments)

    local command = table_find(Commander.commands, function(command) 
        return command.name == command_name
    end)

	if not command then return end

	print(command_name, command)

	local user_access_level = get_user_access_level(player.UserId)

	if user_access_level < command.access_level then
		send_game_notification.send({
			player = player,
			title = "Error!",
			text = player.Name .. ", you do not have access to this command!",
			icon = "rbxassetid://6537654035",
			waitTime = 3,
		})
		return
	end
	
	command:execute({
		player = player,
		command_prefix = command_prefix,
		command_name = command_name,
		command_arguments = command_arguments,
		combined_command_arguments = combined_command_arguments,
	})
end)

return main