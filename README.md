# Door Class Documentation

A class for managing door objects in a game with support for clearance levels, cards, lockdown states, and smooth animations.
I wrote this door system at the request of my friend. It leverages instance attributes for state tracking.

## Features

- Door state management (open/close)
- Clearance level system
- Card-based access control
- Lockdown and jamming states
- Smooth animations using BetterTween
- Debounce protection

## Constructor

```lua
local door = Door.new(model: Model)
```

The constructor takes a Model instance that must contain:
- A PrimaryPart
- A Configuration instance with required attributes
- Parts tagged for animation:
  - DynamicR - Right moving part
  - DynamicL - Left moving part
  - OpenR - Right position target
  - OpenL - Left position target

### Required Configuration Attributes

- `Open` (boolean) - Current door state
- `Lockdown` (boolean) - Lockdown state
- `Jammed` (boolean) - Jammed state
- `Clearance` (number) - Required clearance level
- `Speed` (number, optional) - Door animation speed

## Static Methods

### GetDoor
```lua
Door.GetDoor(model: Model) -> Door?
```
Returns the Door instance associated with the given model, if it exists.

## Instance Methods

### State Management

#### Toggle
```lua
door:Toggle(player: Player)
```
Toggles the door between open and closed states if the player has sufficient clearance.

#### Open
```lua
door:Open(player: Player)
```
Opens the door if it's closed and the player has sufficient clearance.

#### Close
```lua
door:Close(player: Player)
```
Closes the door if it's open and the player has sufficient clearance.

### Security Methods

#### Lockdown
```lua
door:Lockdown()
```
Puts the door in lockdown state, requiring lockdown bypass clearance.

#### Unlockdown
```lua
door:Unlockdown()
```
Removes the door from lockdown state.

#### Jam
```lua
door:Jam()
```
Jams the door, preventing any interaction.

#### Unjam
```lua
door:Unjam()
```
Removes the jammed state.

### State Checks

#### IsOpen
```lua
door:IsOpen() -> boolean
```
Returns whether the door is currently open.

#### IsOnLockdown
```lua
door:IsOnLockdown() -> boolean
```
Returns whether the door is on lockdown.

#### IsJammed
```lua
door:IsJammed() -> boolean
```
Returns whether the door is jammed.

#### IsDebouncing
```lua
door:IsDebouncing() -> boolean
```
Returns whether the door is currently debouncing.

#### CanOpenClose
```lua
door:CanOpenClose(player: Player) -> boolean
```
Returns whether the door can be operated by the given player.

### Utility Methods

#### GetTweenSpeed
```lua
door:GetTweenSpeed() -> number
```
Returns the door's animation speed (defaults to 1).

#### Destroy
```lua
door:Destroy()
```
Cleans up the door instance and removes it from internal tracking.

## ClearanceController

Each Door instance has a ClearanceController accessible via `door.ClearanceController` that manages access permissions. See the ClearanceController documentation for more details.

## Example Usage

```lua
-- Creating a new door
local doorModel = workspace.SomeDoor
local door = Door.new(doorModel)

-- Basic door operations
door:Open(player)
door:Close(player)
door:Toggle(player)

-- Security operations
door:Lockdown()
door:Unlockdown()
door:Jam()
door:Unjam()

-- State checks
if door:IsOpen() then
    print("Door is open")
end

if door:CanOpenClose(player) then
    print("Player can operate the door")
end

-- Cleanup
door:Destroy()
```
