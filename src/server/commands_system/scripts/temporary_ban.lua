local ban = {}
-- Temporary Ban List
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

return ban