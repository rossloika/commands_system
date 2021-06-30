-- Local Roblox Services

-- Local Paths
local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc

-- Local Requires
local settings_module = require(commands_system.settings)
local command = require(scripts_folder.command)
local temporary_ban = require(scripts_folder.temporary_ban)
local game_notification = require(scripts_folder.send_notification)
local send_webhook = require(scripts_folder.send_webhook)
local create_ui = require(scripts_folder.create_ui)
local admin_logs = require(scripts_folder.admin_logs)
local find_player = require(scripts_folder.find_player)

-- General Functions

-- Main Code
local function send_notification(admin, player)
	local date = os.date("!*t")
	local webhook_data = {
		["username"] = player.Name .. " Teleported!",
		["avatarUrl"] = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		["embeds"] = {
			{
				["color"] = 0x0dcbff,
				["title"] = "**Notifications System**",
				["description"] = player.Name .. " Has been Teleported!",
				["footer"] = {
					["text"] = string.format("Date: %s/%s/%s", date.month, date.day, date.year),
				},
			}
		},
		["components"] = {
			{
				["type"] = 1,
				["components"] = {
					{
						["type"] = 2,
						["style"] = 5,
						["disabled"] = false,
						["label"] = "Admin Player Profile",
						["url"] = string.format("https://roblox.com/profile/%s", admin.UserId),
					}, {
						["type"] = 2,
						["style"] = 5,
						["disabled"] = false,
						["label"] = "Player Profile",
						["url"] = string.format("https://roblox.com/profile/%s", player.UserId),
					},
				},
			},
		},
	}
	local notification_data = {
		player = admin,
		title = "Player Teleported!",
		text = player.Name .. " Has been Teleported!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

return command.new({
	name = "to",
	access_level = settings_module.access_level.administrator,
	executor = function(args)
		local findPlayer = find_player.find(args.command_arguments[1])
		local findPlayerCharacter = findPlayer.Character
		findPlayerCharacter:SetPrimaryPartCFrame(CFrame.new(Vector3.new(findPlayerCharacter.HumanoidRootPart.Position.X + 3, findPlayerCharacter.HumanoidRootPart.Position.Y, findPlayerCharacter.HumanoidRootPart.Position.Z)))
		admin_logs.create_admin_log(
			{
				admin = args.player,
				player = find_player.find(args.command_arguments[1]),
				command_name = args.command_name,
			}
		)
		send_notification(args.player, find_player.find(args.command_arguments[1]))
	end,
})