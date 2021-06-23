local admin_logs = {}

admin_logs.logs = {}

function admin_logs.create_admin_log(admin, player, command_name, reason)
    local date = os.date("!*t")
	
	local data = {
		admin = admin,
		player = player,
		command_name = command_name,
		reason = reason,
		time = string.format("%s/%s/%s", date.month, date.day, date.year),
	}

	admin_logs.append(data)
end

function admin_logs.append(data)
    admin_logs.logs[#admin_logs.logs + 1] = data
end

return admin_logs