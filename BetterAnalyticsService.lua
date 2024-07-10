local BetterAnalyticsService = {}

local Config = require(script.Config)

local DebugMode = Config.DebugMode

local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local function matchType(value, expectedType)
	local valueTypeOf = typeof(value)
	
	if valueTypeOf == expectedType then
		return true
	end
	
	return false, valueTypeOf
end

function BetterAnalyticsService:LogEconomyEvent(player: Player, flowType: string, 
	currencyType: string, amount: number, endingBalance: number, 
	transactionType: string, itemSku: string, customFields)
	
	if (not matchType(player, "Instance")) or (player.Parent ~= Players) then
		warn("Player Instance is not valid")
		return
	end
	
	local success, flowTypeEnum = pcall(function()
		return Enum.AnalyticsEconomyFlowType[flowType]
	end)
	
	if not success then
		local str = "%s is not a valid Transaction Type.\nRefer to https://create.roblox.com/docs/reference/engine/enums/AnalyticsEconomyFlowType for more information."
		warn(string.format(str, flowType))
		return
	end
	
	local check, typeOf = matchType(currencyType, "string")
	if not check then
		local str = "Invalid argument #3 to 'LogEconomyEvent' (string expected, got %s)"
		warn(string.format(str, typeOf))
		return
	end
	
	local check, typeOf = matchType(amount, "number")
	if not check then
		local str = "Invalid argument #4 to 'LogEconomyEvent' (number expected, got %s)"
		warn(string.format(str, typeOf))
		return
	end
	
	local check, typeOf = matchType(endingBalance, "number")
	if not check then
		local str = "Invalid argument #5 to 'LogEconomyEvent' (number expected, got %s)"
		warn(string.format(str, typeOf))
		return
	end
	
	local success, transactionTypeEnum = pcall(function()
		return Enum.AnalyticsEconomyTransactionType[transactionType]
	end)

	if not success then
		local str = "%s is not a valid Transaction Type.\nRefer to https://create.roblox.com/docs/reference/engine/enums/AnalyticsEconomyTransactionType for more information."
		warn(string.format(str, transactionType))
		return
	end
	
	if itemSku ~= nil then
		local check, typeOf = matchType(itemSku, "string")
		if not check then
			local str = "Invalid argument #7 to 'LogEconomyEvent' (string expected, got %s)"
			warn(string.format(str, typeOf))
			return
		end
	end
	
	local success, errorMessage = pcall(function()
		AnalyticsService:LogEconomyEvent(player, flowTypeEnum, 
			currencyType, amount, endingBalance, transactionTypeEnum, 
			itemSku, customFields)
	end)
	
	if not success then
		error(errorMessage)
		return
	end
	
	if DebugMode then
		local args = {
			player = player.UserId,
			flowType = flowType,
			currencyType = currencyType,
			amount = amount,
			endingBalance = endingBalance,
			transactionType = transactionType,
			itemSku = itemSku,
			customFields = customFields,
		}

		print("Published the following data to Roblox using 'LogEconomyEvent':")
		print(args)
	end
	
	return errorMessage
end

function BetterAnalyticsService:LogFunnelStepEvent(player: Player, funnelName: string, 
	funnelSessionId: string, step: number, stepName: string, customFields)
	
	if (not matchType(player, "Instance")) or (player.Parent ~= Players) then
		warn("Player Instance is not valid")
		return
	end
	
	local check, typeOf = matchType(funnelName, "string")
	if not check then
		local str = "Invalid argument #2 to 'LogFunnelStepEvent' (string expected, got %s)"
		warn(string.format(str, typeOf))
		return
	end
	
	if funnelSessionId ~= nil then
		local check, typeOf = matchType(funnelSessionId, "string")
		if not check then
			local str = "Invalid argument #3 to 'LogFunnelStepEvent' (string expected, got %s):\nUsing HttpService:GenerateGUID() as fallback"
			warn(string.format(str, typeOf))
			funnelSessionId = HttpService:GenerateGUID()
		end
	else
		funnelSessionId = HttpService:GenerateGUID()
	end
	
	local check, typeOf = matchType(step, "number")
	if not check then
		local str = "Invalid argument #4 to 'LogFunnelStepEvent' (number expected, got %s)"
		warn(string.format(str, typeOf))
		return
	end
	
	local check, typeOf = matchType(stepName, "string")
	if not check then
		local str = "Invalid argument #5 to 'LogFunnelStepEvent' (string expected, got %s)"
		warn(string.format(str, typeOf))
		return
	end
	
	local success, errorMessage = pcall(function()
		AnalyticsService:LogFunnelStepEvent(player, funnelName, funnelSessionId, step, stepName, customFields)
	end)

	if not success then
		error(errorMessage)
		return
	end
	
	if DebugMode then
		local args = {
			player = player.UserId,
			funnelName = funnelName,
			funnelSessionId = funnelSessionId,
			step = step,
			stepName = stepName,
			customFields = customFields,
		}
		
		print("Published the following data to Roblox using 'LogFunnelStepEvent':")
		print(args)
	end

	return errorMessage
end

function BetterAnalyticsService:LogOnboardingFunnelStepEvent(player: Player, 
	step: number, stepName: string, customFields)
	
	if typeof(player) ~= "Instance" or player.Parent ~= Players then
		warn("Player Instance is not valid")
		return
	end
	
	local check, typeOf = matchType(step, "number")
	if not check then
		local str = "Invalid argument #2 to 'LogFunnelStepEvent' (number expected, got %s)"
		warn(string.format(str, typeOf))
		return
	end

	local check, typeOf = matchType(stepName, "string")
	if not check then
		local str = "Invalid argument #3 to 'LogFunnelStepEvent' (string expected, got %s)"
		warn(string.format(str, typeOf))
		return
	end
	
	local success, errorMessage = pcall(function()
		AnalyticsService:LogOnboardingFunnelStepEvent(player, step, stepName, customFields)
	end)

	if not success then
		error(errorMessage)
		return
	end
	
	if DebugMode then
		local args = {
			player = player.UserId,
			step = step,
			stepName = stepName,
			customFields = customFields,
		}

		print("Published the following data to Roblox using 'LogOnboardingFunnelStepEvent':")
		print(args)
	end

	return errorMessage
end

return BetterAnalyticsService