--!strict

--- An iterator function that takes the door's config and returns the names of clearance cards the door accepts
--- @param doorConfig Configuration — The door's configuration instance
--- @return `string` – The clearance card name
return function(doorConfig: Configuration): () -> string
	local configContents: { Instance } = doorConfig:GetChildren()

	local stringValueInstances: { StringValue } = {}

	for index: number, instance in configContents do
		if not instance:IsA("StringValue") or instance.Value == nil then
			continue
		end

		table.insert(stringValueInstances, instance)
	end

	local index: number = 0

	return function(): string
		index += 1

		return stringValueInstances[index] and stringValueInstances[index].Value
	end
end
