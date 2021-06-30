local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local settings_module = require(commands_system.settings)
local Command = require(scripts_folder.command)
local temporary_ban = require(scripts_folder.temporary_ban)
local send_game_notification = require(scripts_folder.send_notification)
local send_webhook = require(scripts_folder.send_webhook)
local admin_logs = require(scripts_folder.admin_logs)

-- Find player via a string
local function find_player(player)
	for _, players in ipairs(game.Players:GetPlayers()) do
		if player:lower() == players.Name:lower():sub(1, #player:lower()) then 
			return game.Players:FindFirstChild(tostring(players))
		end
	end
end

local function send_notification(admin, player, ban_reason)
	print(player.UserId)
	local webhook_data = {
		username = player.Name .. " Temporary Banned!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		title = "**Temporary Ban System**",
		description = player.Name .. " Has been Temporary Banned!",
		color = 0x0dcbff,
		fields = {
			{
				name = "Reason",
				value = tostring(ban_reason),
			},
		}
	}
	local notification_data = {
		player = admin,
		title = "Temporary Banned!",
		text = player.Name .. " Has been Temporary Banned!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	send_game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

local function ban_reason_formatted(ban_reason)
	if string.len(ban_reason) < 1 then
		return "No reason provided."
	end
end

local function send_temp_ban(admin, player, ban_reason)
	local date = os.date("!*t")
    local ban_data = {
        player = tostring(player),
        userid = tostring(player.UserId),
        reason = ban_reason,
		time = string.format("Date: %s / %s / %s", date.month, date.day, date.year),

    }
    temporary_ban.insert(ban_data)
	player:Kick(ban_reason)
end

return Command.new({
	name = "ban",
	access_level = settings_module.access_level.moderator,
	executor = function(args)
		send_temp_ban(args.player, find_player(args.command_arguments[1]), ban_reason_formatted(args.combined_command_arguments))
		admin_logs.create_admin_log(
			{
				admin = args.player,
				player = find_player(args.command_arguments[1]),
				command_combined_arguments = args.combined_command_arguments,
				command_name = args.command_name,
			}
		)
    	send_notification(args.player, find_player(args.command_arguments[1]), ban_reason_formatted(args.combined_command_arguments))
	end,
})