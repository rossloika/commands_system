local create_gui = {}

local Players = game:GetService("Players");

local commands_system = script.Parent.Parent
local commands_folder = commands_system.commands
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc

local command = require(scripts_folder.command)
local Commander = require(scripts_folder.commander)
local settings_module = require(commands_system.settings)
local send_game_notification = require(scripts_folder.send_notification)
local admin_logs = require(scripts_folder.admin_logs)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local commands_system_shared = ReplicatedStorage.Common.commands_system_shared
local remote_event = commands_system_shared.RemoteEvent

function create_gui.create_admin_logs(player)
    local admin_logs_ui_frame = misc_folder.ui_frames.admin_logs:Clone()
    admin_logs_ui_frame.Parent = player.PlayerGui:WaitForChild("CustomAdminGui", 5)

    if not admin_logs.logs == nil then
        local admin_log_template = misc_folder.ui_frames.log_template

        for _, log in pairs(admin_logs.logs) do
            local cloned_admin_log_template = admin_log_template:Clone()
            cloned_admin_log_template.Parent = admin.PlayerGui:WaitForChild("CustomAdminGui", 5).admin_logs.logs
            cloned_admin_log_template.Text = string.format("%s: %s %s %s", log.time, log.admin.Name, log.command_name, log.reason)
        end
    end
end

return create_gui
