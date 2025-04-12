--!strict

return table.freeze({
	-- Door Attributes
	--- Defines whether or not the door is currently open
	OPEN_ATTRIBUTE = "Open",
	--- Defines whether or not the door is currently locked down, prohibiting it's interaction unless your clearance features lockdown bypass
	LOCKDOWN_ATTRIBUTE = "Lockdown",
	--- Defines whether or not the door is currenlt jammed, completely prohibiting it's interaction
	JAMMED_ATTRIBUTE = "Jammed",
	--- Defines whether or not the door is currently debouncing, preventing it being spammed
	DEBOUNCE_ATTRIBUTE = "Debounce",
	--- Defines how fast the door will tween. Less = faster
	TWEEN_SPEED_ATTRIBUTE = "Speed",

	-- Door Tags
	DOOR_TAG = "Door",
	DYNAMIC_PART_RIGHT_TAG = "DynamicR",
	DYNAMIC_PART_LEFT_TAG = "DynamicL",
	OPEN_PART_RIGHT_TAG = "OpenR",
	OPEN_PART_LEFT_TAG = "OpenL",

	-- ClearanceController Attributes
	--- Defines at what clearance level the door can be interacted with
	DOOR_CLEARANCE_LEVEL_ATTRIBUTE = "Clearance",
	--- The card's clearance level
	CARD_CLEARANCE_LEVEL_ATTRIBUTE = "Level",
	--- Defines whether or not the card can open the doors that are on lockdown
	LOCKDOWN_BYPASS_ATTRIBUTE = "LockdownBypass",

	-- ClearanceController Tags
	--- A tag that marks a tool as clearance card
	CLEARANCE_CARD_TAG = "ClearanceCard",
})
