local settings_module = {}

settings_module.prefix = "/"

settings_module.webhooks = {
	warningLogs = "",
	joinLogs = "",
	adminLogs = "",
}

settings_module.access_levels = {
	moderator = 1,
	administrator = 2,
	supervisor = 3,
	leader = 4,
}

settings_module.groups = {
	{
		group_id = 0,
		rank_id = 0,
		permissions_level = settings_module.access_levels.moderator,
	},
}
settings_module.admins = {
	{
		user_id = 39509691, -- Ross
		permissions_level = settings_module.access_levels.leader,
	},
}

settings_module.kick_message = "Goodbye kicked :))"
settings_module.ban_message = "Goodbye ahem banned.."

return settings_module
