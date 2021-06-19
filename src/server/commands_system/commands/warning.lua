local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc
local settings_module = require(commands_system.settings)
local Command = require(scripts_folder.command)
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
local function warn_player(admin, player, reason)
    local PlayerHead = player.Character:WaitForChild("Head")
    local warningsLocation = PlayerHead.OverHeadGui.Warnings
    local headInstances = PlayerHead.OverHeadGui.Warnings:GetChildren()
    local numberOfWarnings = #headInstances

    if reason ~= "" then
		local cloneWarning = misc_folder.WarningExample:Clone()

        cloneWarning.Text = string.format("WARNING %s | %s ", numberOfWarnings, reason)
        cloneWarning.Name = "Warning "..numberOfWarnings
        cloneWarning.Parent = warningsLocation
    end
end
local function send_notification(admin, player, reason)
	print(player.UserId)
	local webhook_data = {
		username = tostring(player).." Warned!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		title = "**Warning System**",
		description = "A user has been Warned!",
		color = 0x0dcbff,
        fields = {
            {
                name = "Reason",
                value = reason,
            },
        },
	}
	local notification_data = {
		player = admin,
		title = "Player Warned!",
		text = tostring(player).." Has been Warned!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	send_game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

return Command.new("warn", function(args)
    warn_player(args.player, find_player(args.command_arguments[1]), args.combined_command_arguments)
	send_notification(args.player, find_player(args.command_arguments[1]), args.combined_command_arguments)
end)
