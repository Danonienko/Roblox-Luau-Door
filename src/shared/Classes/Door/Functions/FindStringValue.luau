--!strict

--- An utility function to help finding the `StringValue` instance with needed string value
--- @param instance Instance — the `Instance` to search for the `StringValue`
--- @param value string — the string value of the `StringValue` instance we are trying to find
--- @return A `StringValue` instance with string value you specified if found, `nil` otherwise
return function(instance: Instance, value: string): StringValue?
	for index: number, child: Instance in instance:GetChildren() do
		if not child:IsA("StringValue") then
			continue
		end

		if child.Value ~= value then
			continue
		end

		return child
	end

	return
end
