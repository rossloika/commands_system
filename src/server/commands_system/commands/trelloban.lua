local commands_system = script.Parent.Parent
local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local settings_module = require(commands_system.settings)
local Command = require(scripts_folder.command)
local trello_api = require(scripts_folder.trello_api)
local send_game_notification = require(scripts_folder.send_notification)
local send_webhook = require(scripts_folder.send_webhook)
local admin_logs = require(scripts_folder.admin_logs)


-- Trello Items
local boardID = trello_api:GetBoardID("Adonis Control Center")
local listID = trello_api:GetListID("Banlist",boardID)
local listInfo = trello_api:GetCardsInList(listID)

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
		username = player.Name .. " Trello Banned!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		title = "**Trello Ban System**",
		description = player.Name .. " Has been Trello Banned!",
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
		title = "Trello Banned!",
		text = player.Name .. " Has been Trello Banned!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	send_game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

local function send_trello_ban(admin, player, ban_reason)
    local banData = {
        admin = tostring(admin),
        player = tostring(player),
        userid = tostring(player.UserId),
        reason = ban_reason,
    }
    trello_api:AddCard(banData.player..":"..banData.userid, "Administrator: "..banData.admin.."\nReason: "..banData.reason, listID)
end

return Command.new({
	name = "trelloban",
	access_level = settings_module.access_level.moderator,
	executor = function(args)
		send_trello_ban(args.player, find_player(args.command_arguments[1]), args.combined_command_arguments)
		find_player(args.command_arguments[1]):Kick(args.combined_command_arguments)
		admin_logs.create_admin_log(
			{
				admin = args.player,
				player = find_player(args.command_arguments[1]),
				reason = args.combined_command_arguments,
				command_name = args.command_name,
			}
		)
    	send_notification(args.player, find_player(args.command_arguments[1]), args.combined_command_arguments)
	end,
})