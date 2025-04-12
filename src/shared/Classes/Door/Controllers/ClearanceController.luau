--!strict

local DoorTypes = require(script.Parent.Parent.DoorTypes)
local Constants = require(script.Parent.Parent.Constants)
local PlayerClearanceCards = require(script.Parent.Parent.Functions.PlayerClearanceCards)
local PlayerMatchCards = require(script.Parent.Parent.Functions.PlayerMatchCards)
local DoorClearanceCards = require(script.Parent.Parent.Functions.DoorClearanceCards)
local FindStringValue = require(script.Parent.Parent.Functions.FindStringValue)

local Controller = {}
local ControllerMeta: DoorTypes.IClearanceController = {} :: DoorTypes.IClearanceController
ControllerMeta.__index = ControllerMeta

function Controller.new(door: DoorTypes.Door): DoorTypes.ClearanceController
	local self: DoorTypes.ClearanceController = setmetatable({}, ControllerMeta) :: DoorTypes.ClearanceController

	self.Door = door

	return self
end

function ControllerMeta:PlayerHasClearance(player: Player): boolean
	if self.Door:IsOnLockdown() and not self:PlayerHasLockdownBypass(player) then
		return false
	end

	if self:GetPlayerClearanceLevel(player) >= self:GetDoorClearanceLevel() then
		return true
	end

	if PlayerMatchCards(player, self:GetDoorClearanceCards(), self:GetPlayerClearanceCards(player)) then
		return true
	end

	return false
end

function ControllerMeta:PlayerHasLockdownBypass(player: Player): boolean
	for card: Tool, level: number in PlayerClearanceCards(player) do
		if card:GetAttribute(Constants.LOCKDOWN_BYPASS_ATTRIBUTE) then
			return true
		end
	end

	return false
end

function ControllerMeta:GetDoorClearanceLevel(): number
	local level: unknown? = self.Door.Configuration:GetAttribute(Constants.DOOR_CLEARANCE_LEVEL_ATTRIBUTE)

	if level == nil or typeof(level) ~= "number" then
		warn(`'{self.Door.Model.Name}' has invalid or has no clearance level'`)
		return 0
	end

	return level
end

function ControllerMeta:GetDoorClearanceCards(): { string }
	local cardNames: { string } = {}

	for cardName: string in DoorClearanceCards(self.Door.Configuration) do
		table.insert(cardNames, cardName)
	end

	return cardNames
end

function ControllerMeta:GetPlayerClearanceLevel(player: Player): number
	local highestLevel: number = 0

	for card: Tool, level: number in PlayerClearanceCards(player) do
		highestLevel = level > highestLevel and level or highestLevel
	end

	return highestLevel
end

function ControllerMeta:GetPlayerClearanceCards(player: Player): { Tool }
	local playerCards: { Tool } = {}

	for card: Tool, level: number in PlayerClearanceCards(player) do
		table.insert(playerCards, card)
	end

	return playerCards
end

function ControllerMeta:SetDoorClearanceLevel(level: number): ()
	if typeof(level) ~= "number" or level < 0 then
		return warn("Invalid clearance level")
	end

	self.Door.Configuration:SetAttribute(Constants.DOOR_CLEARANCE_LEVEL_ATTRIBUTE, level)
end

function ControllerMeta:AddDoorClearanceCard(cardName: string): ()
	if typeof(cardName) ~= "string" then
		return warn("Invalid card name")
	end

	local stringValue: StringValue = Instance.new("StringValue")

	stringValue.Name = "OR"
	stringValue.Value = cardName

	stringValue.Parent = self.Door.Configuration
end

function ControllerMeta:AddDoorClearanceCards(cardNames: { string }): ()
	for index: number, cardName: string in cardNames do
		self:AddDoorClearanceCard(cardName)
	end
end

function ControllerMeta:RemoveDoorClearanceCard(cardName: string): ()
	if typeof(cardName) ~= "string" then
		return warn("Invalid card name")
	end

	local stringValue: StringValue? = FindStringValue(self.Door.Configuration, cardName)

	if not stringValue then
		return warn(`Could not find 'StringValue' with a value of '{cardName}'`)
	end

	stringValue:Destroy()
end

function ControllerMeta:RemoveDoorClearanceCards(cardNames: { string }): ()
	for index: number, cardName: string in cardNames do
		self:RemoveDoorClearanceCard(cardName)
	end
end

function ControllerMeta:ClearDoorClearanceCards(): ()
	self.Door.Configuration:ClearAllChildren()
end

function ControllerMeta:Destroy(): ()
	table.clear(self :: any)
end

return Controller
