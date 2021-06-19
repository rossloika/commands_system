-- FIX THIS ERROR FOR TEMP BAN!
local commands_system = script.Parent.Parent
local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local settings_module = require(commands_system.settings)
local Command = require(scripts_folder.command)
local temporary_ban = require(scripts_folder.temporary_ban)
local send_game_notification = require(scripts_folder.send_notification)
local send_webhook = require(scripts_folder.send_webhook)

-- Find player via a string
local function find_player(player)
	for _, players in ipairs(game.Players:GetPlayers()) do
		if player:lower() == players.Name:lower():sub(1, #player:lower()) then 
			return game.Players:FindFirstChild(tostring(players))
		end
	end
end

local function send_notification(admin, player)
	print(player.UserId)
	local webhook_data = {
		username = tostring(player).." Temporary Banned!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		title = "**Temporary Ban System**",
		description = "A user has been Temporary Banned!",
		color = 0x0dcbff,
		fields = {
			{
				name = "Reason",
				value = tostring(player) or "no reason provided",
			},
		}
	}
	local notification_data = {
		player = admin,
		title = "Temporary Banned!",
		text = tostring(player).." Has been Temporary Banned!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	send_game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

local function send_temp_ban(admin, player, banReason)
    local banData = {
        player = tostring(player),
        userid = tostring(player.UserId),
        reason = banReason,
    }
    temporary_ban.ban_insert(banData)
end

return Command.new("ban", function(args)
	send_temp_ban(args.player, find_player(args.command_arguments[1]), args.combined_command_arguments)
    send_notification(args.player, find_player(args.command_arguments[1]))
end)