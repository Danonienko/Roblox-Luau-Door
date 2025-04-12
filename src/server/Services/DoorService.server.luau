local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Door = require(ReplicatedStorage.Classes.Door)
local Constants = require(ReplicatedStorage.Classes.Door.Constants)
local t = require(ReplicatedStorage.Utility.t)

local ToggleDoorEvent = ReplicatedStorage.Classes.Door.Remotes.ToggleDoor

local function HandleOnServerEvent(player: Player, doorModel: Model): ()
	if not t.instanceIsA("Model")(doorModel) then
		return warn(`Passed 'doorModel' by '{player.Name}' is not a model`)
	end

	local door = Door.GetDoor(doorModel)

	if not door then
		return warn(`Could not find '{doorModel.Name}' door in door collection`)
	end

	door:Toggle(player)

	return
end

ToggleDoorEvent.OnServerEvent:Connect(HandleOnServerEvent)

local function HandleAdded(door: Instance): ()
	if not door:IsA("Model") then
		return warn(
			`Instances tagged with a '{Constants.DOOR_TAG}' tag are expected to be of type 'Model'. '{door.Name}' is not a model`
		)
	end

	Door.new(door)

	return
end

local function HandleRemoved(door: Instance)
	if not door:IsA("Model") then
		return warn(
			`Instances tagged with a '{Constants.DOOR_TAG}' tag are expected to be of type 'Model'. '{door.Name}' is not a model`
		)
	end

	local theDoor = Door.GetDoor(door)

	if not theDoor then
		return warn(`Could not find '{door.Name}' door in the door collection`)
	end

	theDoor:Destroy()

	return
end

for index: number, door: Instance in CollectionService:GetTagged(Constants.DOOR_TAG) do
	HandleAdded(door)
end

CollectionService:GetInstanceAddedSignal(Constants.DOOR_TAG):Connect(HandleAdded)
CollectionService:GetInstanceRemovedSignal(Constants.DOOR_TAG):Connect(HandleRemoved)
