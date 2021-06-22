local admin_logs = {}

admin_logs.logs = {}

function admin_logs.insert(data)
    return table.insert(admin_logs.logs, data.time, data)
end

return admin_logs