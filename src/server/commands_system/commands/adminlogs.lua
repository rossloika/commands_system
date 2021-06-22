local commands_system = script.Parent.Parent

local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc

local settings_module = require(commands_system.settings)
local Command = require(scripts_folder.command)
local temporary_ban = require(scripts_folder.temporary_ban)
local send_game_notification = require(scripts_folder.send_notification)
local send_webhook = require(scripts_folder.send_webhook)
local create_ui = require(scripts_folder.create_ui)

-- Find player via a string
local function find_player(player)
	for _, players in ipairs(game.Players:GetPlayers()) do
		if player:lower() == players.Name:lower():sub(1, #player:lower()) then 
			return game.Players:FindFirstChild(tostring(players))
		end
	end
end

local function send_notification(admin)
	local webhook_data = {
		username = admin.Name .. " Admin Logs!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", admin.UserId),
		title = "**Admin Logs System**",
		description = admin.Name .. " Has created admin logs gui!",
		color = 0x0dcbff,
	}
	local notification_data = {
		admin = admin,
		title = "Admin Logs!",
		text = admin.Name .. " created admin logs!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	send_game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

local function create_admin_log(admin)
    create_ui.create_admin_logs(admin)
end

return Command.new({
	name = "adminlogs",
	access_level = settings_module.access_level.supervisor,
	executor = function(args)
		create_admin_log(args.player)
		send_notification(args.player)
	end,
})