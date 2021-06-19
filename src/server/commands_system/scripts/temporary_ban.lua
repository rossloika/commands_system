function main()

end

-- Temporary Ban List
local bansList = {}

function ban_insert(data)
	return table.insert(bansList, data.userid, data)
end

function ban_find(userid)
	return bansList[userid]
end

function ban_remove(userid)
	bansList[userid] = nil
	return true
end

return main