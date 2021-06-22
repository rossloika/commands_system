local create_gui = {}

local Players = game:GetService("Players");

local commands_system = script.Parent.Parent
local commands_folder = commands_system.commands
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc

local Command = require(scripts_folder.command)
local Commander = require(scripts_folder.commander)
local settings_module = require(commands_system.settings)
local send_game_notification = require(scripts_folder.send_notification)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local commands_system_shared = ReplicatedStorage.Common.commands_system_shared
local remote_event = commands_system_shared.RemoteEvent

function create_gui.create_admin_logs(player)
    local admin_logs_ui = misc_folder.admin_logs:Clone()
    admin_logs_ui.Parent = player.PlayerGui:WaitForChild("CustomAdminGui", 5)
end

return create_gui