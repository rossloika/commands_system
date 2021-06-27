local admin_logs = {}

admin_logs.logs = {}

function admin_logs.create_admin_log(data)
	local time = os.date("%X")
	
	local data = {
		admin = data.admin,
		player = data.player,
		command_name = data.command_name,
		reason = data.reason or "No Reason Provided",
		time = time,
	}

	admin_logs.append(data)
end

function admin_logs.append(data)
    admin_logs.logs[#admin_logs.logs + 1] = data
end

return admin_logs