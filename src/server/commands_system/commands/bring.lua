local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
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

local function send_notification(admin, player)
	print(player.UserId)
	local webhook_data = {
		username = player.Name .. " Teleported!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		title = "**Notifications System**",
		description = player.Name .. " Has been Teleported!",
		color = 0x0dcbff,
	}
	local notification_data = {
		player = admin,
		title = "Player Teleported!",
		text = player.Name .. " Has been Teleported!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	send_game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

return Command.new({
	name = "bring",
	access_level = settings_module.access_level.administrator,
	executor = function(args)
        local findPlayer = find_player(args.command_arguments[1])
    	local findPlayerCharacter = findPlayer.Character
    	findPlayerCharacter:SetPrimaryPartCFrame(CFrame.new(Vector3.new(findPlayerCharacter.HumanoidRootPart.Position.X + 3, findPlayerCharacter.HumanoidRootPart.Position.Y, findPlayerCharacter.HumanoidRootPart.Position.Z)))
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