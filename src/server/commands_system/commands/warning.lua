local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc
local temporary_ban = require(scripts_folder.temporary_ban)
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
	if numberOfWarnings >= 3 then
		local warningsList = {}	

		for index, warnings in ipairs(warningsLocation:GetChildren()) do
			if warnings:IsA("TextBox") then
				table.insert(warningsList, index, warnings.Text)
			end
		end

		local webhook_data = {
			username = tostring(player).." Kicked!",
			avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
			title = "**Warning System**",
			description = "A user has been kicked for **three** warnings!",
			color = 0x0dcbff,
			fields = {
				{
					name = "Warning One",
					value = tostring(warningsList[2]) or "nil",
				},
				{
					name = "Warning Two",
					value = tostring(warningsList[3]) or "nil",
				},
				{
					name = "Warning Three",
					value = tostring(warningsList[4]) or "nil",
				},
			}
		}
		local ban_data = {
			player = tostring(player),
			userid = tostring(player.UserId),
			reason = reason,
			time = 60 -- In seconds 600 seconds in 10 minutes
		}

		send_webhook.send("adminLogs", webhook_data)
		temporary_ban.time_ban_create(ban_data)
		player:Kick("\nYou have exceeded the maximum limit for having warnings.\nYou have been timed banned for 10 minutes.")
		
	end
	if reason ~= "" then
		local cloneWarning = misc_folder.WarningExample:Clone()

        cloneWarning.Text = string.format("WARNING %s | %s ", numberOfWarnings, reason)
        cloneWarning.Name = "Warning "..numberOfWarnings
        cloneWarning.Parent = warningsLocation
    end
end
local function send_notification(admin, player, reason)
	local webhook_data = {
		username = tostring(player).." Warned!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		title = "**Warning System**",
		description = tostring(player).." Has been Warned!",
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
