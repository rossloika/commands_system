function main()

end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local commands_system_shared = ReplicatedStorage.Common.commands_system_shared
local remote_event = commands_system_shared.RemoteEvent_notifications
-- TitleValue, TextValue, iconValue, DurationValue, Button1Value, Button2Value
remote_event.OnClientEvent:Connect(function(options)
	game.StarterGui:SetCore("SendNotification", {
		Title = options.titleValue;
		Text = options.textValue;
		Icon = options.iconValue; 
		Duration = options.durationValue;
		Button1 = options.button1Value; 
		Button2 = options.button2Value;
	})
end)

return main
