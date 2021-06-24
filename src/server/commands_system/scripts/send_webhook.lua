local webhook = {}

local HttpService = game:GetService("HttpService")
local commands_system = script.Parent.Parent
local scripts_folder = commands_system.scripts
local settings_module = require(commands_system.settings)

local webHookLinks = settings_module.webhooks

-- data = robloxPlayer, username, avatarURL, title, description, color, fieldName, fieldValue  
function webhook.send(webhookName, data)
	local date = os.date("!*t")
	
	HttpService:PostAsync(webHookLinks[webhookName], HttpService:JSONEncode(
		{
			["username"] = data.username,
			["avatar_url"] = data.avatarUrl,
			["embeds"] = {
				{
					["title"] = data.title,
					["description"] = data.description,
					["color"] = data.color,
					["fields"] = data.fields,
					["footer"] = {
						["text"] = string.format("Date: %s / %s / %s", date.month, date.day, date.year)
					}
				}
			},
			["components"] = data.components
		}
	))
end

--["content"] = "",

return webhook
