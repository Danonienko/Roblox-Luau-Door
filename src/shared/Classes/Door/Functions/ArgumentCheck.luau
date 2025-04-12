--!strict

local GetPartsForTweening = require(script.Parent.GetPartsForTweening)

--- This is an argument validator for `Door` class constructor. It checks if the arguments passed to the constructor are valid and throws an error if not.
--- If arguments are valid, extracts needed objects for the class and returns them as package
return function(model: Model)
	local modelPrimaryPart: BasePart? = model.PrimaryPart
	local config: Configuration? = model:FindFirstChildOfClass("Configuration")

	assert(modelPrimaryPart, `'{model.Name}' does not have a primary part`)
	assert(config, `'{model.Name}' does not have 'Configuration' instance as it's child`)

	local requiredAttributes: { [string]: string } = table.freeze({
		Open = "boolean",
		Lockdown = "boolean",
		Jammed = "boolean",
		Clearance = "number",
	})

	local doorAttributes = config:GetAttributes()

	for attributeName: string, attributeType: string in requiredAttributes do
		if doorAttributes[attributeName] == nil then
			warn(`'{model.Name}' does not have '{attributeName}' attribute. This may lead to unexpected behaviour`)
			continue
		end

		if typeof(doorAttributes[attributeName]) ~= attributeType then
			warn(
				`'{model.Name}' has '{attributeName}' attribute of wrong type. '{attributeName}' is expected to be of type '{attributeType}'`
			)
		end
	end

	local partsForTweening = GetPartsForTweening(model)

	local requiredParts: { string } = table.freeze({
		"DynamicR",
		"DynamicL",
		"OpenR",
		"OpenL",
	})

	local missingParts: boolean = false

	for index: number, requiredPart: string in requiredParts do
		if partsForTweening[requiredPart] == nil then
			missingParts = true
			warn(`'{model.Name}' does not have required part for tweening '{requiredPart}'`)
		end
	end

	assert(not missingParts, `'{model.Name}' is missing required parts for tweening`)

	return table.freeze({
		Model = model,
		Config = config,
		Tweening = partsForTweening,
	})
end
