function main()

end

local commands_system = script.Parent.Parent
local commands_folder = commands_system.commands
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc

local Command = require(scripts_folder.command)
local Commander = require(scripts_folder.commander)
local settings_module = require(commands_system.settings)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local commands_system_shared = ReplicatedStorage.Common.commands_system_shared
local remote_event = commands_system_shared.RemoteEvent

-- Checks to see if player is in the admin list
local function is_admin(userId)
	for _, admin_info in ipairs(settings_module.admins) do
		if userId == admin_info.user_id then
			local data = {
				admin = true,
				permissions_level = admin_info.permissions_level
			}
			return data
		end
	end
	return {
		admin = false,
		permissions_level = 0
	}
end

-- Checks to see if player is certain rank in group
local function is_ranked_in_group(player)
	for _, group_info in ipairs(settings_module.groups) do
		if player:GetRankInGroup(group_info.group_id) == group_info.rank_id then
			return {
				admin = true,
				permissions_level = group_info.permissions_level
			}
		end
	end
	return {
		admin = false,
		permissions_level = 0
	}
end

-- Check permissions level of player
local function check_permissions_level(player, permissions_level)
	return (is_admin(player.userId).permissions_level >= permissions_level or is_ranked_in_group(player).permissions_level >= permissions_level)
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
	
	command:execute({
		player = player,
		command_prefix = command_prefix,
		command_name = command_name,
		command_arguments = command_arguments,
		combined_command_arguments = combined_command_arguments,
	})
end)

return main