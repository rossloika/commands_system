-- FIX THIS ERROR FOR TEMP BAN!
local commands_system = script.Parent.Parent
local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc
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

local function send_notification(admin, player, message)
	print(player.UserId)
	local webhook_data = {
		username = player.Name .. " Flying!",
		avatarUrl = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		title = "**Notification System**",
		description = player.Name .. " is flying!",
		color = 0x0dcbff,
	}

    local checked_message = ""

    if message then 
        checked_message = message 
    else 
        checked_message = player.Name .. " Is already flying!" 
    end

	local notification_data = {
		player = admin,
		title = "Flying!",
		text = checked_message,
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	send_game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

local function create_fly_script(admin, player)
    if not player.Backpack:FindFirstChild("flyScript") then
        local fly_script = misc_folder.flyScript
        fly_script:Clone()
        fly_script.Parent = player.Backpack
        fly_script.Disabled = false
    else
        send_notification(admin, player, "Already Flying")
    end
end

return Command.new({
	name = "fly",
	access_level = settings_module.access_level.supervisor,
	executor = function(args)
		create_fly_script(args.player, find_player(args.command_arguments[1]))
		send_notification(args.player, find_player(args.command_arguments[1]), args.combined_command_arguments)
	end,
})