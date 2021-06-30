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

local function send_notification(admin)
	local date = os.date("!*t")
	local webhook_data = {
		["username"] = admin.Name .. " Admin Logs!",
		["avatarUrl"] = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", admin.UserId),
		["embeds"] = {
			{
				["color"] = 0x0dcbff,
				["title"] = "**Admin Logs System**",
				["description"] = admin.Name .. " Has created admin logs gui!",
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
					},
				},
			},
		},
	}
	local notification_data = {
		player = admin,
		title = "Admin Logs!",
		text = admin.Name .. " created admin logs!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

local function create_admin_log(admin)
    create_ui.create_admin_logs(admin)
end

local function display_admin_logs(admin)
	local admin_log_template = misc_folder.ui_frames.log_template

	for _, log in pairs(admin_logs.logs) do
		local cloned_admin_log_template = admin_log_template:Clone()
		cloned_admin_log_template.Parent = admin.PlayerGui:WaitForChild("CustomAdminGui", 5).admin_logs.logs
		cloned_admin_log_template.Text = string.format("%s: %s %s %s", log.time, log.admin.Name, log.command_name, log.reason)
	end
end

return command.new({
	name = "adminlogs",
	access_level = settings_module.access_level.supervisor,
	executor = function(args)
		create_admin_log(args.player)
		display_admin_logs(args.player)
		send_notification(args.player)
		admin_logs.create_admin_log(
		{
			admin = args.player,
			command_name = args.command_name,
		}
	)
		warn(admin_logs.logs)
	end,
})