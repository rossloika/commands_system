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
	local date = os.date("!*t")
	local webhook_data = {
		["username"] = player.Name .. " Player Warning Removed!",
		["avatarUrl"] = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		["embeds"] = {
			{
				["color"] = 0x0dcbff,
				["title"] = "**Warning System**",
				["description"] = player.Name .. " warning has been removed!",
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
						["label"] = "Unwarned Player Profile",
						["url"] = string.format("https://roblox.com/profile/%s", player.UserId),
					},
				},
			},
		},
	}
	local notification_data = {
		player = admin,
		title = "Player Warning Removed!",
		text = player.Name .. " warning has been removed!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

return command.new({
	name = "removewarn",
	access_level = settings_module.access_level.administrator,
	executor = function(args)
		remove_warn_player(args.player, find_player.find(args.command_arguments[1]), args.combined_command_arguments)
		admin_logs.create_admin_log(
			{
				admin = args.player,
				player = find_player.find(args.command_arguments[1]),
				command_combined_arguments = args.combined_command_arguments,
				command_name = args.command_name,
			}
		)
		send_notification(args.player, find_player.find(args.command_arguments[1]), args.combined_command_arguments)
	end,
})