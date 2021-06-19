local notification = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local commands_system_shared = ReplicatedStorage.Common.commands_system_shared
local remote_event = commands_system_shared.RemoteEvent_notifications

function notification.send(data)
	remote_event:FireClient(
		data.player, -- Player
		data.title, -- Title Value
		data.text, -- Text Value
		data.icon, -- Icon Value
		data.waitTime -- Duration Time
	)
end

return notification