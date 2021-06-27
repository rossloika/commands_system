local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc
local settings_module = require(commands_system.settings)
local Command = require(scripts_folder.command)
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
local function remove_warn_player(admin, player, selected)
    local PlayerHead = player.Character:WaitForChild("Head")
    local warningsLocation = PlayerHead.OverHeadGui.Warnings
    local headInstances = PlayerHead.OverHeadGui.Warnings:GetChildren()
    local numberOfWarnings = #headInstances
    if selected == "all" then
		for _, warning in pairs(headInstances) do
			warning:Destroy()
		end
	else
		local warningSelected = tostring("Warning "..selected)
    	warningsLocation[warningSelected]:Destroy()
	end
end
local function send_notification(admin, player, reason)
	print(player.UserId)
	local webhook_data = {
		username = player.Name .. " Player Warning Removed!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		title = "**Warning System**",
		description = player.Name .. " warning has been removed!",
		color = 0x0dcbff,
	}
	local notification_data = {
		player = admin,
		title = "Player Warning Removed!",
		text = player.Name .. " warning has been removed!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	send_game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

return Command.new({
	name = "removewarn",
	access_level = settings_module.access_level.administrator,
	executor = function(args)
		remove_warn_player(args.player, find_player(args.command_arguments[1]), args.combined_command_arguments)
		admin_logs.create_admin_log(
			{
				admin = args.player,
				player = find_player(args.command_arguments[1]),
				command_combined_arguments = args.combined_command_arguments,
				command_name = args.command_name,
			}
		)
		send_notification(args.player, find_player(args.command_arguments[1]), args.combined_command_arguments)
	end,
})