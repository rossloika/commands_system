local settings_module = {}

settings_module.prefix = "/"

settings_module.webhooks = {
	warningLogs = "https://discord.com/api/webhooks/831652637040443411/eMsygTQWtdOoZMHU1RpOGauDZzXDkZKH4vssildkZwSPlAGsew2GXGvTRq9Qpg728akm",
	joinLogs = "",
	adminLogs = "https://discord.com/api/webhooks/831652637040443411/eMsygTQWtdOoZMHU1RpOGauDZzXDkZKH4vssildkZwSPlAGsew2GXGvTRq9Qpg728akm",
}

settings_module.access_levels = {
	moderator = 1,
	administrator = 2,
	supervisor = 3,
	leader = 4,
}

settings_module.groups = {
	{
		group_id = 2877225,
		rank_id = 7,
		permissions_level = settings_module.access_levels.moderator,
	},
	{
		group_id = 2877225,
		rank_id = 9,
		permissions_level = settings_module.access_levels.administrator,
	},
	{
		group_id = 2877225,
		rank_id = 11,
		permissions_level = settings_module.access_levels.administrator,
	},
	{
		group_id = 2877225,
		rank_id = 13,
		permissions_level = settings_module.access_levels.administrator,
	},
	{
		group_id = 2877225,
		rank_id = 15,
		permissions_level = settings_module.access_levels.administrator,
	},
	{
		group_id = 2877225,
		rank_id = 17,
		permissions_level = settings_module.access_levels.supervisor,
	},
	{
		group_id = 2877225,
		rank_id = 19,
		permissions_level = settings_module.access_levels.supervisor,
	},
	{
		group_id = 2877225,
		rank_id = 21,
		permissions_level = settings_module.access_levels.supervisor,
	},
	{
		group_id = 2877225,
		rank_id = 23,
		permissions_level = settings_module.access_levels.supervisor,
	},
	{
		group_id = 2877225,
		rank_id = 25,
		permissions_level = settings_module.access_levels.supervisor,
	},
	{
		group_id = 2877225,
		rank_id = 27,
		permissions_level = settings_module.access_levels.supervisor,
	},
	{
		group_id = 2877225,
		rank_id = 255,
		permissions_level = settings_module.access_levels.supervisor,
	},
}
settings_module.admins = {
	{
		user_id = 39509691, -- Ross
		permissions_level = settings_module.access_levels.leader,
	},
	{
		user_id = 99120954, -- Cody
		permissions_level = settings_module.access_levels.leader,
	},
	{
		user_id = 93368919, -- Will
		permissions_level = settings_module.access_levels.leader,
	},
}

settings_module.kick_message = "Goodbye kicked :))"
settings_module.ban_message = "Goodbye ahem banned.."

return settings_module