--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Classes.Door.Constants)
local DoorTypes = require(ReplicatedStorage.Classes.Door.DoorTypes)

local tagNames: { string } = table.freeze({
	Constants.DYNAMIC_PART_RIGHT_TAG,
	Constants.DYNAMIC_PART_LEFT_TAG,
	Constants.OPEN_PART_RIGHT_TAG,
	Constants.OPEN_PART_LEFT_TAG,
})

return function(model: Model): DoorTypes.PartsForTweening
	local partsForTweening = {} :: DoorTypes.PartsForTweening

	for index: number, child: Instance in model:GetChildren() do
		if not child:IsA("BasePart") then
			continue
		end

		for index: number, tagName: string in tagNames do
			if child:HasTag(tagName) then
				partsForTweening[tagName] = child
				break
			end
		end
	end

	return partsForTweening
end
