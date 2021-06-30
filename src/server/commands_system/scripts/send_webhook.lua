local webhook = {}

local HttpService = game:GetService("HttpService")
local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local misc_folder = commands_system.misc
local settings_module = require(commands_system.settings)

local webHookLinks = settings_module.webhooks

-- data = robloxPlayer, username, avatarURL, title, description, color, fieldName, fieldValue
function webhook.send(webhookName, data)
	--local date = os.date("!*t") --string.format("Date: %s/%s/%s", date.month, date.day, date.year)
	local success, response = pcall(function()
		return HttpService:RequestAsync(
			{
				Url = webHookLinks[webhookName],  -- This website helps debug HTTP requests
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"  -- When sending JSON, set this!
				},
				Body = HttpService:JSONEncode(data)
			}
    	)
	end)
	warn(success, response)
end

--["content"] = "",

return webhook
