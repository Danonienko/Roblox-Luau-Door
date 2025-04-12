--!nonstrict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BetterTween = {}

local event = ReplicatedStorage.Remotes.Tween
local tweenThreads = {}

local function tweenCompleted(instance, tweenInfo, goal)
	tweenThreads[instance] = nil
	if not tweenInfo.Reverses then
		for property, value in goal do
			instance[property] = value
		end
	end
end

function BetterTween:Tween(instance: Instance, tweenInfo: TweenInfo, goal): number
	if tweenInfo.RepeatCount == -1 then
		warn("Cannot repeat tweens with BetterTween")
		return 0
	end
	if tweenThreads[instance] then
		task.cancel(tweenThreads[instance])
		tweenThreads[instance] = nil
	end

	local tweenData = {
		tweenInfo.Time,
		tweenInfo.EasingStyle,
		tweenInfo.EasingDirection,
		tweenInfo.RepeatCount,
		tweenInfo.Reverses,
		tweenInfo.DelayTime,
	}

	event:FireAllClients(instance, tweenData, goal)

	local timeMultiplier = if tweenInfo.Reverses then 2 else 1
	local totalDuration = (tweenInfo.Time * timeMultiplier + tweenInfo.DelayTime) * (tweenInfo.RepeatCount + 1)
	tweenThreads[instance] = task.delay(totalDuration, tweenCompleted, instance, tweenInfo, goal)

	return totalDuration
end

return BetterTween
