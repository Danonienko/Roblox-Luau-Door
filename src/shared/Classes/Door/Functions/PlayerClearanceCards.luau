--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Classes.Door.Constants)


--- An iterator function that takes local player's backpack and iterates over it's contents, returning cards and their level if player has any
--- @return tuple: `Tool, number` – Where `Tool` is the clearance card and `number` is it's clearance level
return function(player: Player): () -> (Tool?, number)
	local backpack: Backpack? = player:FindFirstChildOfClass("Backpack")
	local backpackContents: { Instance } = backpack and backpack:GetChildren() or {}

	local clearanceCards: { Tool } = {}
	local cardAndLevel: { [Tool]: number } = {}

	for _: number, tool: Instance in backpackContents do
		if not tool:IsA("Tool") or not tool:HasTag(Constants.CLEARANCE_CARD_TAG) then
			continue
		end

		table.insert(clearanceCards, tool)
	end

	for _: number, clearanceCard: Tool in clearanceCards do
		local clearanceLevel: unknown? = clearanceCard:GetAttribute(Constants.CARD_CLEARANCE_LEVEL_ATTRIBUTE)

		if clearanceLevel == nil or typeof(clearanceLevel) ~= "number" then
			warn(`'{clearanceCard.Name}' has invalid clearance level attribute`)
			continue
		end

		cardAndLevel[clearanceCard] = clearanceLevel
	end

	local card: Tool?, level: number

	return function(): (Tool?, number)
		card, level = next(cardAndLevel, card)

		return card, level
	end
end
