--!strict

--- A checker function to determine if the player has cards that match with door cards
--- @param doorCards { string } — the cards that door accepts, found in the configuration of the door
--- @param playerCards { Tool } — the cards the player currently has in their backpack
--- @return boolean – true if found any match, false otherwise
return function(player: Player, doorCards: { string }, playerCards: { Tool }): boolean
	for index: number, playerCard: Tool in playerCards do
		if table.find(doorCards, playerCard.Name) then
			return true
		end
	end

	return false
end
