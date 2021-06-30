-- Local Roblox Services
local Players = game:GetService("Players")
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
return command.new({
	name = "test",
	access_level = settings_module.access_level.moderator,
	executor = function(args)
       -- Command Code
       -- Send Logs and Notifications
    end,
})

