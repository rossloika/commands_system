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

local function send_notification(admin, player, banReason)
	print(player.UserId)
	local webhook_data = {
		username = tostring(player).." Unbanned!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		title = "**Temporary Ban System**",
		description = tostring(player).." Has been Unbanned!",
		color = 0x0dcbff,
	}
	local notification_data = {
		player = admin,
		title = "Unbanned!",
		text = tostring(player).." Has been Unbanned!",
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

local function send_unban(admin, player, banReason)
    return temporary_ban.find(player.UserId)
end

return Command.new("unban", function(args)
	send_unban(args.player, find_player(args.command_arguments[1]), ban_reason_formatted(args.combined_command_arguments))
    send_notification(args.player, find_player(args.command_arguments[1]), ban_reason_formatted(args.combined_command_arguments))
end)
