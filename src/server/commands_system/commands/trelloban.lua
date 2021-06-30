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

local function send_notification(admin, player, ban_reason)
	local date = os.date("!*t")
	local webhook_data = {
		["username"] = player.Name .. " Trello Banned!",
		["avatarUrl"] = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
		["embeds"] = {
			{
				["color"] = 0x0dcbff,
				["title"] = "**Trello Ban System**",
				["description"] = player.Name .. " Has been Trello Banned!",
				["fields"] = {
					{
						["name"] = "Reason",
						["value"] = tostring(ban_reason),
					},
				},
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
						["label"] = "Trellobanned Player Profile",
						["url"] = string.format("https://roblox.com/profile/%s", player.UserId),
					},
				},
			},
		},
	}
	local notification_data = {
		player = admin,
		title = "Trello Banned!",
		text = player.Name .. " Has been Trello Banned!",
		icon = "rbxassetid://6537654035",
		waitTime = 3
	}

	game_notification.send(notification_data)
	send_webhook.send("adminLogs", webhook_data)
end

local function send_trello_ban(admin, player, ban_reason)
    local banData = {
        admin = tostring(admin),
        player = tostring(player),
        userid = tostring(player.UserId),
        reason = ban_reason,
    }
    trello_api:AddCard(banData.player..":"..banData.userid, "Administrator: "..banData.admin.."\nReason: "..banData.reason, listID)
end

return command.new({
	name = "trelloban",
	access_level = settings_module.access_level.moderator,
	executor = function(args)
		send_trello_ban(args.player, find_player.find(args.command_arguments[1]), args.combined_command_arguments)
		find_player.find(args.command_arguments[1]):Kick(args.combined_command_arguments)
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