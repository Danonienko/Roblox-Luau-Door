# ClearanceController Class Documentation

A controller class that manages door access permissions through clearance levels and card-based authentication.

## Constructor

```lua
local controller = ClearanceController.new(door: Door)
```

The constructor takes a Door instance and manages its access control system.

## Properties

### Door
```lua
controller.Door: Door
```
Reference to the Door instance this controller is managing.

## Methods

### Access Control

#### PlayerHasClearance
```lua
controller:PlayerHasClearance(player: Player) -> boolean
```
Checks if a player has sufficient clearance to operate the door. This checks:
- Player's clearance level against door's required level
- Player's clearance cards against door's accepted cards
- Lockdown state and bypass permissions

#### PlayerHasLockdownBypass
```lua
controller:PlayerHasLockdownBypass(player: Player) -> boolean
```
Checks if the player has any card with lockdown bypass capability.

### Clearance Level Management

#### GetDoorClearanceLevel
```lua
controller:GetDoorClearanceLevel() -> number
```
Returns the current clearance level required to operate the door.

#### SetDoorClearanceLevel
```lua
controller:SetDoorClearanceLevel(level: number)
```
Sets the clearance level required to operate the door.

#### GetPlayerClearanceLevel
```lua
controller:GetPlayerClearanceLevel(player: Player) -> number
```
Returns the highest clearance level among all cards the player has.

### Card Management

#### GetDoorClearanceCards
```lua
controller:GetDoorClearanceCards() -> { string }
```
Returns an array of card names that are accepted by the door.

#### GetPlayerClearanceCards
```lua
controller:GetPlayerClearanceCards(player: Player) -> { Tool }
```
Returns an array of clearance card tools the player currently has.

#### AddDoorClearanceCard
```lua
controller:AddDoorClearanceCard(cardName: string)
```
Adds a single card to the door's accepted cards list.

#### AddDoorClearanceCards
```lua
controller:AddDoorClearanceCards(cardNames: { string })
```
Adds multiple cards to the door's accepted cards list.

#### RemoveDoorClearanceCard
```lua
controller:RemoveDoorClearanceCard(cardName: string)
```
Removes a single card from the door's accepted cards list.

#### RemoveDoorClearanceCards
```lua
controller:RemoveDoorClearanceCards(cardNames: { string })
```
Removes multiple cards from the door's accepted cards list.

#### ClearDoorClearanceCards
```lua
controller:ClearDoorClearanceCards()
```
Removes all cards from the door's accepted cards list.

### Cleanup

#### Destroy
```lua
controller:Destroy()
```
Cleans up the controller instance.

## Example Usage

```lua
-- Get controller from door
local controller = door.ClearanceController

-- Check access
if controller:PlayerHasClearance(player) then
    print("Player can access the door")
end

-- Manage clearance levels
controller:SetDoorClearanceLevel(5)
local level = controller:GetDoorClearanceLevel()

-- Manage accepted cards
controller:AddDoorClearanceCard("Level5Card")
controller:AddDoorClearanceCards({"VIPCard", "AdminCard"})
controller:RemoveDoorClearanceCard("Level5Card")
controller:ClearDoorClearanceCards()

-- Check player cards and levels
local playerLevel = controller:GetPlayerClearanceLevel(player)
local playerCards = controller:GetPlayerClearanceCards(player)

-- Check lockdown bypass
if controller:PlayerHasLockdownBypass(player) then
    print("Player can bypass lockdown")
end
```

## Card System

### Card Requirements

Clearance cards should:
1. Be Tools in the player's backpack
2. Have the "ClearanceCard" tag
3. Have a "Level" attribute with a number value
4. Optionally have a "LockdownBypass" attribute

### Door Card Configuration

Door card configurations are stored as StringValue instances under the door's Configuration with:
- Name: "OR"
- Value: The card name to accept
