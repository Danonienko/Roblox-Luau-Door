--!strict

--- The Door class
export type Door = typeof(setmetatable(
	{} :: {
		ClearanceController: ClearanceController,

		Model: Model,
		Configuration: Configuration,
	},
	{} :: IDoor
))

export type IDoor = {
	__index: IDoor,

	--- Utility method to quickly toggle the door's open/close state
	Toggle: (self: Door, player: Player) -> (),
	--- Opens the door, unless it is already open
	Open: (self: Door, player: Player) -> (),
	--- Closes the door, unless it is already closed
	Close: (self: Door, player: Player) -> (),
	--- Puts the door on lockdown, preventing its interaction unless the player has lockdown bypass
	Lockdown: (self: Door) -> (),
	--- Clears the lockdown status of the door
	Unlockdown: (self: Door) -> (),
	--- Jams the door, completely preventing its interaction
	Jam: (self: Door) -> (),
	--- Clears the jammed status
	Unjam: (self: Door) -> (),
	--- Puts debounce status
	Debounce: (self: Door) -> (),
	--- Removes debounce status
	UnDebounce: (self: Door) -> (),

	--- Utility method for getting the speed number from door's configuration
	GetTweenSpeed: (self: Door) -> number,

	--- State flag describing whether or not the door is currently open
	IsOpen: (self: Door) -> boolean,
	--- State flag describing whether or not the door is currently on lockdown
	IsOnLockdown: (self: Door) -> boolean,
	--- State flag describing whether or not the door is currently jammed
	IsJammed: (self: Door) -> boolean,
	--- State flag describing whether or not the door is currently debouncing, preventing it being spammed
	IsDebouncing: (self: Door) -> boolean,

	--- Checker method for determining whether or not the door's open/close state can be changed
	CanOpenClose: (self: Door, player: Player) -> boolean,

	--- A destructor for destroying the class
	Destroy: (self: Door) -> (),
}

--- A controller class for Door class that manages door access via clearances
export type ClearanceController = typeof(setmetatable(
	{} :: {
		--- The door class this controller is linked to
		Door: Door,
	},
	{} :: IClearanceController
))

export type IClearanceController = {
	__index: IClearanceController,

	--- A checker method for determining whether or not the player has sufficient clearance
	PlayerHasClearance: (self: ClearanceController, player: Player) -> boolean,
	--- A checker method that checks if the player has any card with lockdown bypass
	PlayerHasLockdownBypass: (self: ClearanceController, player: Player) -> boolean,

	--- Gets and returns the clearance level of the door
	GetDoorClearanceLevel: (self: ClearanceController) -> number,
	--- Gets and returns an array of card clearance names that the door accepts
	GetDoorClearanceCards: (self: ClearanceController) -> { string },
	--- Gets and returns the highest clearance level of the player
	GetPlayerClearanceLevel: (self: ClearanceController, player: Player) -> number,
	--- Gets and returns an array of card clearance tools that the player currently has in their backpack
	GetPlayerClearanceCards: (self: ClearanceController, player: Player) -> { Tool },
	--- Sets the door clearance level to a specified one
	SetDoorClearanceLevel: (self: ClearanceController, level: number) -> (),
	--- Adds a specified clearance card to the door, giving the card's ability to interact with it
	AddDoorClearanceCard: (self: ClearanceController, cardName: string) -> (),
	--- Adds a list of specified clearance cards to the door, giving them ability to interact with it
	AddDoorClearanceCards: (self: ClearanceController, cardNames: { string }) -> (),
	--- Removes a specified clearance card from the door, removing the card's ability to interact with it
	RemoveDoorClearanceCard: (self: ClearanceController, cardName: string) -> (),
	--- Removes a list of specified clearance cards from the door, removing their abilities to interact with it
	RemoveDoorClearanceCards: (self: ClearanceController, cardNames: { string }) -> (),
	--- Removes all clearance cards that was assigned to the door
	ClearDoorClearanceCards: (self: ClearanceController) -> (),

	Destroy: (self: ClearanceController) -> (),
}

export type PartsForTweening = {
	DynamicR: BasePart,
	DynamicL: BasePart,
	OpenR: BasePart,
	OpenL: BasePart,
}

export type Tweening = {
	Parts: PartsForTweening,
	Origins: {
		DynamicR: CFrame,
		DynamicL: CFrame,
	},
}

return nil
