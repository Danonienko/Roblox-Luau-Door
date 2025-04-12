-- TWEEN HANDLER (CLIENT) --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local event = ReplicatedStorage.Remotes.Tween

event.OnClientEvent:Connect(function(instance, tweenInfo, goal)
	if not instance then
		-- The instance is not replicated to this client
		return
	end

	local newTweenInfo = TweenInfo.new(table.unpack(tweenInfo))

	local tween = TweenService:Create(instance, newTweenInfo, goal)
	tween:Play()
end)
