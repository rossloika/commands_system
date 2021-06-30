local find_player = {}

function find_player.find(player_name)
	for _, players in ipairs(game.Players:GetPlayers()) do
		if player_name:lower() == players.Name:lower():sub(1, #player_name:lower()) then 
			return game.Players:FindFirstChild(tostring(players))
		end
	end
end


-- Find Player Full Name Only
--local Players = game:GetService("Players")

-- local player = nil
-- 	pcall(function()
-- 		local user_id = Players:GetUserIdFromNameAsync(player_name)
-- 		player = Players:GetPlayerByUserId(user_id)
-- 	end)
-- 	return player

return find_player