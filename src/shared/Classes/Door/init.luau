--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BetterTween = require(ReplicatedStorage.Utility.BetterTween)
local ClearanceController = require(script.Controllers.ClearanceController)
local Constants = require(script.Constants)
local DoorTypes = require(script.DoorTypes)
local ArgumentCheck = require(script.Functions.ArgumentCheck)

local Door = {}
local DoorMeta: DoorTypes.IDoor = {} :: DoorTypes.IDoor
DoorMeta.__index = DoorMeta

local private = {}

local doorCollection: { [Model]: DoorTypes.Door } = {}

function Door.new(model: Model): DoorTypes.Door
	local self: DoorTypes.Door = setmetatable({}, DoorMeta) :: DoorTypes.Door

	local package = ArgumentCheck(model)

	private[self] = {
		Tweening = {
			Parts = package.Tweening,
			Origins = {
				DynamicR = package.Tweening.DynamicR.CFrame,
				DynamicL = package.Tweening.DynamicL.CFrame,
			},
		},
	}

	self.Model = package.Model
	self.Configuration = package.Config

	self.ClearanceController = ClearanceController.new(self)

	doorCollection[model] = self

	return self
end

function Door.GetDoor(model: Model): DoorTypes.Door?
	return doorCollection[model]
end

function DoorMeta:Toggle(player: Player): ()
	if not self:CanOpenClose(player) then
		return
	end

	if self:IsOpen() then
		self:Close(player)
	else
		self:Open(player)
	end
end

function DoorMeta:Open(player: Player): ()
	if self:IsOpen() or not self:CanOpenClose(player) then
		return
	end

	self.Configuration:SetAttribute(Constants.OPEN_ATTRIBUTE, true)
	self:Debounce()

	local ref = private[self].Tweening
	local tweenSpeed: number = self:GetTweenSpeed()
	local tweenInfo = TweenInfo.new(tweenSpeed)

	BetterTween:Tween(ref.Parts.DynamicR, tweenInfo, {
		CFrame = ref.Parts.OpenR.CFrame,
	})
	local tweenTime: number = BetterTween:Tween(ref.Parts.DynamicL, tweenInfo, {
		CFrame = ref.Parts.OpenL.CFrame,
	})

	task.delay(tweenTime, function()
		self:UnDebounce()
	end)
end

function DoorMeta:Close(player: Player): ()
	if not self:IsOpen() or not self:CanOpenClose(player) then
		return
	end

	self.Configuration:SetAttribute(Constants.OPEN_ATTRIBUTE, false)
	self:Debounce()

	local ref = private[self].Tweening
	local tweenSpeed: number = self:GetTweenSpeed()
	local tweenInfo = TweenInfo.new(tweenSpeed)

	BetterTween:Tween(ref.Parts.DynamicR, tweenInfo, {
		CFrame = ref.Origins.DynamicR,
	})
	local tweenTime: number = BetterTween:Tween(ref.Parts.DynamicL, tweenInfo, {
		CFrame = ref.Origins.DynamicL,
	})

	task.delay(tweenTime, function()
		self:UnDebounce()
	end)
end

function DoorMeta:Lockdown(): ()
	if self:IsOnLockdown() then
		return
	end

	self.Configuration:SetAttribute(Constants.LOCKDOWN_ATTRIBUTE, true)
end

function DoorMeta:Unlockdown(): ()
	if not self:IsOnLockdown() then
		return
	end

	self.Configuration:SetAttribute(Constants.LOCKDOWN_ATTRIBUTE, false)
end

function DoorMeta:Jam(): ()
	if self:IsJammed() then
		return
	end

	self.Configuration:SetAttribute(Constants.JAMMED_ATTRIBUTE, true)
end

function DoorMeta:Unjam(): ()
	if not self:IsJammed() then
		return
	end

	self.Configuration:SetAttribute(Constants.JAMMED_ATTRIBUTE, false)
end

function DoorMeta:Debounce(): ()
	if self:IsDebouncing() then
		return
	end

	self.Configuration:SetAttribute(Constants.DEBOUNCE_ATTRIBUTE, true)
end

function DoorMeta:UnDebounce(): ()
	if not self:IsDebouncing() then
		return
	end

	self.Configuration:SetAttribute(Constants.DEBOUNCE_ATTRIBUTE, false)
end

function DoorMeta:GetTweenSpeed(): number
	local tweenSpeed: unknown? = self.Configuration:GetAttribute(Constants.TWEEN_SPEED_ATTRIBUTE)

	return if tweenSpeed ~= nil and typeof(tweenSpeed) == "number" then tweenSpeed else 1
end

function DoorMeta:IsOpen(): boolean
	local isOpen: unknown? = self.Configuration:GetAttribute(Constants.OPEN_ATTRIBUTE)

	return if isOpen ~= nil and typeof(isOpen) == "boolean" then isOpen else false
end

function DoorMeta:IsOnLockdown(): boolean
	local isOnLockdown: unknown? = self.Configuration:GetAttribute(Constants.LOCKDOWN_ATTRIBUTE)

	return if isOnLockdown ~= nil and typeof(isOnLockdown) == "boolean" then isOnLockdown else false
end

function DoorMeta:IsJammed(): boolean
	local isJammed: unknown? = self.Configuration:GetAttribute(Constants.JAMMED_ATTRIBUTE)

	return if isJammed ~= nil and typeof(isJammed) == "boolean" then isJammed else false
end

function DoorMeta:IsDebouncing(): boolean
	local isDebouncing: unknown? = self.Configuration:GetAttribute(Constants.DEBOUNCE_ATTRIBUTE)

	return if isDebouncing ~= nil and typeof(isDebouncing) == "boolean" then isDebouncing else false
end

function DoorMeta:CanOpenClose(player: Player): boolean
	return not self:IsJammed() and not self:IsDebouncing() and self.ClearanceController:PlayerHasClearance(player)
end

function DoorMeta:Destroy(): ()
	self.ClearanceController:Destroy()

	doorCollection[self.Model] = nil

	table.clear(self :: any)
end

return Door
