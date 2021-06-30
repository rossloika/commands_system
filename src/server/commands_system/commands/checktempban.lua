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

local function send_notification(admin, player, result)
    if result then
        local date = os.date("!*t")
        local webhook_data = {
            ["username"] = player.Name .. " Is Banned!",
            ["avatarUrl"] = string.format("https://www.roblox.com/bust-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId),
            ["embeds"] = {
                {
                    ["color"] = 0x0dcbff,
                    ["title"] = "**Notifications System**",
                    ["description"] = player.Name .. " Is Banned!",
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
                            ["label"] = "Banned Player Profile",
                            ["url"] = string.format("https://roblox.com/profile/%s", player.UserId),
                        },
                    },
                },
            },
        }
        local notification_data = {
            player = admin,
            title = "Temporary Ban!",
            text = player.Name .. " Has a Temporary Ban!",
            icon = "rbxassetid://6537654035",
            waitTime = 3
        }
        game_notification.send(notification_data)
    else
        local notification_data = {
            player = admin,
            title = "Temporary Ban!",
            text = player.Name .. " Does not have Temporary Ban!",
            icon = "rbxassetid://6537654035",
            waitTime = 3
        }
        game_notification.send(notification_data)
    end
end

local function check_temp_ban(admin, player, banReason)
    return temporary_ban.find(player.UserId)
end

return command.new({
	name = "checkban",
	access_level = settings_module.access_level.moderator,
	executor = function(args)
        admin_logs.create_admin_log(
            {
                admin = args.player,
                player = find_player.find(args.command_arguments[1]),
                command_name = args.command_name,
            }
        )
        if check_temp_ban(args.player, find_player.find(args.command_arguments[1]), args.combined_command_arguments) then
            send_notification(args.player, find_player.find(args.command_arguments[1]), true)
        else
            send_notification(args.player, find_player.find(args.command_arguments[1]), false)
        end
    end,
})
