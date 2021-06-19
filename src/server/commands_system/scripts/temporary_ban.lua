local ban = {}
-- Temporary Ban List
local bansList = {}

function ban.insert(data)
	return table.insert(bansList, data.userid, data)
end

function ban.find(userid)
	return bansList[userid]
end

function ban.remove(userid)
	bansList[userid] = nil
	return true
end

return ban