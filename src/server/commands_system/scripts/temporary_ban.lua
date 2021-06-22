local ban = {}
local DataStoreService = game:GetService("DataStoreService")
local temporary_ban_ds = DataStoreService:GetDataStore("temporary_ban_datastore")

-- Temporary Ban List (not time ban)
ban.bansList = {}

function ban.insert(data)
	return table.insert(ban.bansList, data.userid, data)
end

function ban.find(userid)
	return ban.bansList[userid]
end

function ban.remove(userid)
	ban.bansList[userid] = nil
	return true
end

function ban.time_ban_create(data)
	--ban.bansList, data.userid, data
	temporary_ban_ds:SetAsync(tostring(data.userid), {BanTime = os.time() + data.time})
end

function ban.get_ban_list()
	return ban.bansList
end

return ban