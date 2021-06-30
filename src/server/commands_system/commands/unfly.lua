local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc
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

local function send_notification(admin, player)
	print(player.UserId)
	local webhook_data = {
		username = player.Name .. " Unfly!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		title = "**Notification System**",
		description = player.Name .. " is not flying!",
		color = 0x0dcbff,
	}
	local notification_data = {
		player = admin,
		title = "Unfly!",
		text = player.Name .. " is not flying!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	send_game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

local function unfly(admin, player)
    local CFrame = player.Character.HumanoidRootPart.CFrame
    player:LoadCharacter()
    player.Character.HumanoidRootPart.CFrame = CFrame
    player.Backpack:WaitForChild("flyScript"):Destroy()
end

return Command.new({
	name = "unfly",
	access_level = settings_module.access_level.supervisor,
	executor = function(args)
		unfly(args.player, find_player(args.command_arguments[1]))
		admin_logs.create_admin_log(
			{
				admin = args.player,
				player = find_player(args.command_arguments[1]),
				command_name = args.command_name,
			}
		)
    	send_notification(args.player, find_player(args.command_arguments[1]))
	end,
})