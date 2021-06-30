-- Local Roblox Services

-- Local Paths
local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts

-- Local Requires
local settings_module = require(commands_system.settings)
local command = require(scripts_folder.command)
local temporary_ban = require(scripts_folder.temporary_ban)
local send_game_notification = require(scripts_folder.send_notification)
local send_webhook = require(scripts_folder.send_webhook)
local create_ui = require(scripts_folder.create_ui)
local admin_logs = require(scripts_folder.admin_logs)

-- General Functions
-- Find player via a string
local function find_player(player)
	for _, players in ipairs(game.Players:GetPlayers()) do
		if player:lower() == players.Name:lower():sub(1, #player:lower()) then 
			return game.Players:FindFirstChild(tostring(players))
		end
	end
end

-- Main Code

local function send_notification(admin, player, result)
	print(player.UserId)
    if result then
        local notification_data = {
            player = admin,
            title = "Temporary Ban!",
            text = player.Name .. " Has a Temporary Ban!",
            icon = "rbxassetid://6537654035",
            waitTime = 3
        }
        send_game_notification.send(notification_data)
    else
        local notification_data = {
            player = admin,
            title = "Temporary Ban!",
            text = player.Name .. " Does not have Temporary Ban!",
            icon = "rbxassetid://6537654035",
            waitTime = 3
        }
        send_game_notification.send(notification_data)
    end
end

local function check_temp_ban(admin, player, banReason)
    return temporary_ban.find(player.UserId)
end

return command.new({
	name = "checkban",
	access_level = settings_module.access_level.moderator,
	executor = function(args)
        admin_logs.create_admin_log(
            {
                admin = args.player,
                player = find_player(args.command_arguments[1]),
                command_name = args.command_name,
            }
        )
        if check_temp_ban(args.player, find_player(args.command_arguments[1]), args.combined_command_arguments) then
            send_notification(args.player, find_player(args.command_arguments[1]), true)
        else
            send_notification(args.player, find_player(args.command_arguments[1]), false)
        end
    end,
})
