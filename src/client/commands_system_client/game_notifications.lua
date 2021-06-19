function main()

end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local commands_system_shared = ReplicatedStorage.Common.commands_system_shared
local remote_event = commands_system_shared.RemoteEvent_notifications

local function OnSendNotification(TitleValue, TextValue, iconValue, DurationValue, Button1Value, Button2Value)
	game.StarterGui:SetCore("SendNotification", {
		Title = TitleValue;
		Text = TextValue;
		Icon = iconValue; 
		Duration = DurationValue;
		Button1 = Button1Value; 
		Button2 = Button2Value;
	})
end

remoteEvent.OnClientEvent:Connect(OnSendNotification)

return main