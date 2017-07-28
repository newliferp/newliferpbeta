require "resources/essentialmode/lib/MySQL"
MySQL:open("localhost", "BDD", "root", "PASS")

local inServicePres = {}

function addPres(identifier)
	MySQL:executeQuery("INSERT INTO president (`identifier`) VALUES ('@identifier')", { ['@identifier'] = identifier})
end

function remPres(identifier)
	MySQL:executeQuery("DELETE FROM president WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
end

function checkIsPres(identifier)
	local query = MySQL:executeQuery("SELECT * FROM president WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
	local result = MySQL:getResults(query, {'rankpres'}, "identifier")
	
	if(not result[1]) then
		TriggerClientEvent('president:receiveIspres', source, "President")
	else
		TriggerClientEvent('president:receiveIsPres', source, result[1].rankpres)
	end
end

function s_checkIsPres(identifier)
	local query = MySQL:executeQuery("SELECT * FROM president WHERE identifier = '@identifier'", { ['@identifier'] = identifier})
	local result = MySQL:getResults(query, {'rankpres'}, "identifier")
	
	if(not result[1]) then
		return "nil"
	else
		return result[1].rankpres
	end
end

RegisterServerEvent('gc:openIdentity')
AddEventHandler('gc:openIdentity',function(other)
    local data = getIdentity(other)
    if data ~= nil then 
        TriggerClientEvent('gc:showItentity', source, {
            nom = data.nom,
            prenom = data.prenom,
            sexe = data.sexe,
            dateNaissance = tostring(data.dateNaissance),
            jobs = data.jobs,
            taille = data.taille
        })
    end
    ---- ... Date conversion error
    -- TriggerClientEvent('gc:showItentity', source, data)
end)

RegisterServerEvent('gc:openMeIdentity')
AddEventHandler('gc:openMeIdentity',function()
    local data = getIdentity(source)
    if data ~= nil then 
        TriggerClientEvent('gc:showItentity', source, {
            nom = data.nom,
            prenom = data.prenom,
            sexe = data.sexe,
            dateNaissance = tostring(data.dateNaissance),
            jobs = data.jobs,
            taille = data.taille
        })
    end
end)

function checkInventory(target)
	local strResult = GetPlayerName(target).." own : "
	local identifier = ""
    TriggerEvent("es:getPlayerFromId", target, function(player)
		identifier = player.identifier
		local executed_query = MySQL:executeQuery("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = '@username'", { ['@username'] = identifier })
		local result = MySQL:getResults(executed_query, { 'quantity', 'libelle', 'item_id', 'isIllegal' }, "item_id")
		if (result) then
			for _, v in ipairs(result) do
				if(v.quantity ~= 0) then
					strResult = strResult .. v.quantity .. " de " .. v.libelle .. ", "
				end
				if(v.isIllegal == "True") then
					TriggerClientEvent('president:dropIllegalItem', target, v.item_id)
				end
			end
		end
		
		strResult = strResult .. " / "
		
		local executed_query = MySQL:executeQuery("SELECT * FROM user_weapons WHERE identifier = '@username'", { ['@username'] = identifier })
		local result = MySQL:getResults(executed_query, { 'weapon_model' }, 'identifier' )
		if (result) then
			for _, v in ipairs(result) do
					strResult = strResult .. "possession de " .. v.weapon_model .. ", "
			end
		end
	end)
	
    return strResult
end

AddEventHandler('playerDropped', function()
	if(inServicePres[source]) then
		inServicePres[source] = nil
		
		for i, c in pairs(inServicePres) do
			TriggerClientEvent("president:resultAllPresInService", i, inServicePres)
		end
	end
end)

AddEventHandler('es:playerDropped', function(player)
		local isPres = s_checkIsPres(player.identifier)
		if(isPres ~= "nil") then
			TriggerEvent("jobssystem:disconnectReset", player, 7)
		end
end)

RegisterServerEvent('president:checkIsPres')
AddEventHandler('president:checkIsPres', function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local identifier = user.identifier
		checkIsPres(identifier)
	end)
end)

RegisterServerEvent('president:takeServicePres')
AddEventHandler('president:takeServicePres', function()

	if(not inServicePres[source]) then
		inServicePres[source] = GetPlayerName(source)
		
		for i, c in pairs(inServicePres) do
			TriggerClientEvent("president:resultAllPresInService", i, inServicePres)
		end
	end
end)

RegisterServerEvent('president:breakServicePres')
AddEventHandler('president:breakServicePres', function()

	if(inServicePres[source]) then
		inServicePres[source] = nil
		
		for i, c in pairs(inServicePres) do
			TriggerClientEvent("president:resultAllPresInService", i, inServicePres)
		end
	end
end)

RegisterServerEvent('president:getAllPresInService')
AddEventHandler('president:getAllPresInService', function()
	TriggerClientEvent("president:resultAllPresInService", source, inServicePres)
end)

RegisterServerEvent('president:checkingPlate')
AddEventHandler('president:checkingPlate', function(plate)
	local executed_query = MySQL:executeQuery("SELECT Nomvoiture FROM user_vehicle JOIN users ON user_vehicle.identifier = users.identifier WHERE vehicle_plate = '@plate'", { ['@plate'] = plate })
	local result = MySQL:getResults(executed_query, { 'Nomvoiture' }, "identifier")
	if (result[1]) then
		for _, v in ipairs(result) do
			TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "La plaque #"..plate.." est au nom de " .. v.Nomvoiture)
		end
	else
		TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "Le véhicule #"..plate.." apparait volé !")
	end
end)

RegisterServerEvent('president:confirmUnseat')
AddEventHandler('president:confirmUnseat', function(t)
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, GetPlayerName(t).. " est dehors !")
	TriggerClientEvent('president:unseatme', t)
end)

RegisterServerEvent('president:targetCheckInventory')
AddEventHandler('president:targetCheckInventory', function(t)
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, checkInventory(t))
end)

RegisterServerEvent('president:finesGranted')
AddEventHandler('president:finesGranted', function(t, amount)
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, GetPlayerName(t).. " a payé $"..amount.." d'amende.")
	TriggerClientEvent('president:payFines', t, amount)
end)

RegisterServerEvent('president:cuffGranted')
AddEventHandler('president:cuffGranted', function(t)
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, GetPlayerName(t).. " est menotté !")
	TriggerClientEvent('president:getArrested', t)
end)

RegisterServerEvent('president:forceEnterAsk')
AddEventHandler('president:forceEnterAsk', function(t, v)
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, GetPlayerName(t).. " get to the car ! (if he's cuffed :) )")
	TriggerClientEvent('president:forcedEnteringVeh', t, v)
end)

-----------------------------------------------------------------------
----------------------EVENT SPAWN PRESIDENT VEH---------------------------
-----------------------------------------------------------------------
RegisterServerEvent('CheckpresidentVeh')
AddEventHandler('CheckpresidentVeh', function(vehicle)
	TriggerEvent('es:getPlayerFromId', source, function(user)

			TriggerClientEvent('FinishPresidentCheckForVeh',source)
			-- Spawn president vehicle
			TriggerClientEvent('presidentveh:spawnVehicle', source, vehicle)
	end)
end)

-----------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP PRES-------------------
-----------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'presadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "Usage : /presadd [ID]")	
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				addPres(target.identifier)
				TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "President script By Edwyn !")
				TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "Tu es maintenant President !~w~.")
				TriggerClientEvent('president:nowPres', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "No player with this ID !")
		end
	end
end, function(source, args, user) 
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "Tu n'as pas la permission pour ça !")
end)

TriggerEvent('es:addGroupCommand', 'presrem', "admin", function(source, args, user) 
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "Usage : /presrem [ID]")	
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				remPres(target.identifier)
				TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Government", false, "Tu n'es plus president !~w~.")
				TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "Roger that !")
				--TriggerClientEvent('chatMessage', player, 'GOVERNMENT', {255, 0, 0}, "You're no longer a pres !")
				TriggerClientEvent('president:noLongerPres', player)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "No player with this ID !")
		end
	end
end, function(source, args, user) 
	TriggerClientEvent('chatMessage', source, 'GOVERNMENT', {255, 0, 0}, "Tu n'as pas la permission pour ça !")
end)
