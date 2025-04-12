--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Classes.Door.Constants)
local DoorTypes = require(ReplicatedStorage.Classes.Door.DoorTypes)

return function(model: Model): DoorTypes.PartsForTweening
	local partsForTweening = {} :: DoorTypes.PartsForTweening

	for index: number, child: Instance in model:GetChildren() do
		if not child:IsA("BasePart") then
			continue
		end

		if child:HasTag(Constants.DYNAMIC_PART_RIGHT_TAG) then
			partsForTweening.DynamicR = child
			continue
		end
		if child:HasTag(Constants.DYNAMIC_PART_LEFT_TAG) then
			partsForTweening.DynamicL = child
			continue
		end
		if child:HasTag(Constants.OPEN_PART_RIGHT_TAG) then
			partsForTweening.OpenR = child
			continue
		end
		if child:HasTag(Constants.OPEN_PART_LEFT_TAG) then
			partsForTweening.OpenL = child
			continue
		end
	end

	return partsForTweening
end
