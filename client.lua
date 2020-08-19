local UseBaseevents = false

-- Vehicles Classes :
-- 0: Compacts  
-- 1: Sedans  
-- 2: SUVs  
-- 3: Coupes  
-- 4: Muscle  
-- 5: Sports Classics  
-- 6: Sports  
-- 7: Super  
-- 8: Motorcycles  
-- 9: Off-road  
-- 10: Industrial  
-- 11: Utility  
-- 12: Vans  
-- 13: Cycles  
-- 14: Boats  
-- 15: Helicopters  
-- 16: Planes  
-- 17: Service  
-- 18: Emergency  
-- 19: Military  
-- 20: Commercial  
-- 21: Trains
local VehiclesClassDamagesModifiers = {
	[0]  = {engine = 3.0, collision = 1.0, weapons = 8.0}, -- 0: Compacts  
	[1]  = {engine = 3.0, collision = 3.0, weapons = 8.0},-- 1: Sedans  
	[2]  = {engine = 3.0, collision = 3.0, weapons = 8.0},-- 2: SUVs  
	[3]  = {engine = 3.0, collision = 3.0, weapons = 7.0},-- 3: Coupes  
	[4]  = {engine = 3.0, collision = 3.0, weapons = 8.0},-- 4: Muscle  
	[5]  = {engine = 3.0, collision = 3.0, weapons = 9.0},-- 5: Sports Classic
	[6]  = {engine = 3.0, collision = 3.0, weapons = 9.0},-- 6: Sports  
	[7]  = {engine = 3.0, collision = 3.0, weapons = 6.0},-- 7: Super  
	[8]  = {engine = 1.0, collision = 1.0, weapons = 1.0},-- 8: Motorcycles  
	[9]  = {engine = 3.0, collision = 3.0, weapons = 3.0},-- 9: Off-road  
	[10] = {engine = 3.0, collision = 3.0, weapons = 4.0},-- 10: Industrial  
	[11] = {engine = 3.0, collision = 3.0, weapons = 6.0},-- 11: Utility  
	[12] = {engine = 3.0, collision = 3.0, weapons = 6.0},-- 12: Vans  
	[13] = {engine = 1.0, collision = 1.0, weapons = 1.0},-- 13: Cycles  
	[14] = {engine = 3.0, collision = 3.0, weapons = 10.0},-- 14: Boats  
	[15] = {engine = 3.0, collision = 3.0, weapons = 3.0},-- 15: Helicopters  
	[16] = {engine = 3.0, collision = 3.0, weapons = 3.0},-- 16: Planes  
	[17] = {engine = 3.0, collision = 3.0, weapons = 6.0},-- 17: Service  
	[18] = {engine = 3.0, collision = 3.0, weapons = 3.0},-- 18: Emergency  
	[19] = {engine = 3.0, collision = 3.0, weapons = 3.0},-- 19: Military  
	[20] = {engine = 3.0, collision = 3.0, weapons = 2.0},-- 20: Commercial  
	[21] = {engine = 3.0, collision = 3.0, weapons = 10.0},-- 21: Trains
}

local VehicleNameDamagesModifiers = {
	[GetHashKey("blista")] = {engine = 2.5, collision = 2.5, weapons = 2.5},
	[GetHashKey("brioso")] = {engine = 2.0, collision = 2.0, weapons = 2.0},
	[GetHashKey("kuruma2")] = {engine = 1.7, collision = 1.7, weapons = 6.0},
	[GetHashKey("police3")] = {engine = 1.7, collision = 1.7, weapons = 6.0},
	[GetHashKey("riot")] = {engine = 1.7, collision = 1.7, weapons = 2.0},
}


DecorRegister("_Custom_Damages", 2)

if not UseBaseevents then
	local isInVehicle = false
	local isEnteringVehicle = false
	local currentVehicle = 0
	local currentSeat = 0

	Citizen.CreateThread(function()
		while true do
			local ped = PlayerPedId()

			if not isInVehicle and not IsPlayerDead(PlayerId()) then
				if IsPedInAnyVehicle(ped, false) then
					isEnteringVehicle = false
					isInVehicle = true
					currentVehicle = GetVehiclePedIsUsing(ped)
					local model = GetEntityModel(currentVehicle)
					StartVehiclesDamages(currentVehicle)
				end
			elseif isInVehicle then
				if not IsPedInAnyVehicle(ped, false) or IsPlayerDead(PlayerId()) then
					isInVehicle = false
					currentVehicle = 0
				end
			end
			Citizen.Wait(50)
		end
	end)
else
	AddEventHandler('baseevents:enteredVehicle', function(vehicle)
		StartVehiclesDamages(vehicle)
	end)
end

function StartVehiclesDamages(vehicle)
	if not DecorExistOn(vehicle, "_Custom_Damages") or DecorGetBool(vehicle, "_Custom_Damages") == false then
		local values = nil
		local vehModel = GetEntityModel(vehicle)
		if VehicleNameDamagesModifiers[vehModel] ~= nil then
			values = VehicleNameDamagesModifiers[vehModel]
		else
			local vehicleClass = GetVehicleClass(vehicle)
			if VehiclesClassDamagesModifiers[vehicleClass] ~= nil then
				values = VehiclesClassDamagesModifiers[vehicleClass]
			end
		end
		if values ~= nil then
			SetVehicleHandlingFloat(vehicle, "CHandlingData", "fEngineDamageMult", values.engine)
			SetVehicleHandlingFloat(vehicle, "CHandlingData", "fCollisionDamageMult", values.collision)
			SetVehicleHandlingFloat(vehicle, "CHandlingData", "fWeaponDamageMult", values.weapons)
		end
		DecorSetBool(vehicle, "_Custom_Damages", true)
	end
end