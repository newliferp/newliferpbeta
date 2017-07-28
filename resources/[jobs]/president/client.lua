local isPres = false
local isInServicePres = false
local rankpres = "President"
local checkpointsPres = {}
local existingVehPres = nil
local handCuffedPres = false
local isAlreadyDeadPres = false
local allServicePres = {}
local blipsPres = {}

local takingServicePres = {
  --{x=850.156677246094, y=-1283.92004394531, z=28.0047378540039},
  {x=108.862, y=-744.78, z=242.152}
  --{x=1856.91320800781, y=3689.50073242188, z=34.2670783996582},
  --{x=-450.063201904297, y=6016.5751953125, z=31.7163734436035}
}

local stationGarage = {
	{x=-407.254, y=1062.7, z=323.841}
}

AddEventHandler("playerSpawned", function()
	TriggerServerEvent("president:checkIsPres")
end)

RegisterNetEvent('president:receiveIsPres')
AddEventHandler('president:receiveIsPres', function(result)
	if(result == "President") then
		isPres = false
	else
		isPres = true
		rankpres = result
	end
end)

RegisterNetEvent('president:nowPres')
AddEventHandler('president:nowPres', function()
	isPres = true
end)

RegisterNetEvent("gcl:showItentity")
AddEventHandler("gcl:showItentity", function()
	local p , dist  = GetClosestPlayer(distMaxCheck)
    if p ~= -1 then
		TriggerServerEvent('gc:openIdentity', GetPlayerServerId(p))
    end
end)

RegisterNetEvent("gcl:openMeIdentity")
AddEventHandler("gcl:openMeIdentity", function()
	TriggerServerEvent('gc:openMeIdentity')
end)

RegisterNetEvent('president:noLongerPres')
AddEventHandler('president:noLongerPres', function()
	isPres = false
	isInServicePres = false
	
	local playerPed = GetPlayerPed(-1)
						
	TriggerServerEvent("skin_customization:SpawnPlayer")
	RemoveAllPedWeapons(playerPed)
	
	if(existingVehPres ~= nil) then
		SetEntityAsMissionEntity(existingVehPres, true, true)
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVehPres))
		existingVehPres = nil
	end
	
	ServicePresOff()
end)

RegisterNetEvent('president:getArrested')
AddEventHandler('president:getArrested', function()
	if(isPres == false) then
		handCuffedPres = not handCuffedPres
		if(handCuffedPres) then
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Tu es menotté.")
		else
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Tu es libre !")
		end
	end
end)

RegisterNetEvent('president:payFines')
AddEventHandler('president:payFines', function(amount)
	TriggerServerEvent('bank:withdrawAmende', amount)
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "~h~ Vous avez payé "..amount.."€ d'amende.")
end)

RegisterNetEvent('president:dropIllegalItem')
AddEventHandler('president:dropIllegalItem', function(id)
	TriggerEvent("player:looseItem", tonumber(id), exports.vdk_inventory:getQuantity(id))
end)

RegisterNetEvent('president:unseatme')
AddEventHandler('president:unseatme', function(t)
	local ped = GetPlayerPed(t)        
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
	local xnew = plyPos.x+2
	local ynew = plyPos.y+2
   
	SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

RegisterNetEvent('president:forcedEnteringVeh')
AddEventHandler('president:forcedEnteringVeh', function(veh)
	if(handCuffedPres) then
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
		local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)

		if vehicleHandle ~= nil then
			SetPedIntoVehicle(GetPlayerPed(-1), vehicleHandle, 1)
		end
	end
end)

RegisterNetEvent('president:resultAllPresInService')
AddEventHandler('president:resultAllPresInService', function(array)
	allServicePres = array
	enablePresBlips()
end)

function enablePresBlips()

	for k, existingBlip in pairs(blipsPres) do
        RemoveBlip(existingBlip)
    end
	blipsPres = {}
	
	local localIdPres = {}
	for id = 0, 64 do
		if(NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1)) then
			for i,c in pairs(allServicePres) do
				if(i == GetPlayerServerId(id)) then
					localIdPres[id] = c
					break
				end
			end
		end
	end
	
	for id, c in pairs(localIdPres) do
		local ped = GetPlayerPed(id)
		local blip = GetBlipFromEntity(ped)
		
		if not DoesBlipExist( blip ) then

			blip = AddBlipForEntity( ped )
			SetBlipSprite( blip, 1 )
			Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
			HideNumberOnBlip( blip )
			SetBlipNameToPlayerName( blip, id )
			
			SetBlipScale( blip,  0.85 )
			SetBlipAlpha( blip, 255 )
			
			table.insert(blipsPres, blip)
		else
			
			blipSprite = GetBlipSprite( blip )
			
			HideNumberOnBlip( blip )
			if blipSprite ~= 1 then
				SetBlipSprite( blip, 1 )
				Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
			end
			
			Citizen.Trace("Name : "..GetPlayerName(id))
			SetBlipNameToPlayerName( blip, id )
			SetBlipScale( blip,  0.85 )
			SetBlipAlpha( blip, 255 )
			
			table.insert(blipsPres, blip)
		end
	end
end

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function getisInServicePres()
	return isInServicePres
end

function isNearTakeServicePres()
	for i = 1, #takingServicePres do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = GetDistanceBetweenCoords(takingServicePres[i].x, takingServicePres[i].y, takingServicePres[i].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance < 30) then
			DrawMarker(1, takingServicePres[i].x, takingServicePres[i].y, takingServicePres[i].z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
		if(distance < 2) then
			return true
		end
	end
end

function isNearStationGarage()
	for i = 1, #stationGarage do
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = GetDistanceBetweenCoords(stationGarage[i].x, stationGarage[i].y, stationGarage[i].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance < 30) then
			DrawMarker(1, stationGarage[i].x, stationGarage[i].y, stationGarage[i].z-1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
		if(distance < 2) then
			return true
		end
	end
end

function ServicePresOn()
	isInServicePres = true
	TriggerServerEvent("jobssystem:jobs", 16)
	TriggerServerEvent("president:takeServicePres")
end

function ServicePresOff()
	isInServicePres = false
	TriggerServerEvent("jobssystem:jobs", 1)
	TriggerServerEvent("president:breakServicePres")
	
	allServicePres = {}
	
	for k, existingBlip in pairs(blipsPres) do
        RemoveBlip(existingBlip)
    end
	blipsPres = {}
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if(isPres) then
			if(isNearTakeServicePres()) then
			
				DisplayHelpText('Appuis sur ~INPUT_CONTEXT~ pour ouvrir le ~b~casier',0,1,0.5,0.8,0.6,255,255,255,255) -- ~g~E~s~
				if IsControlJustPressed(1,51) then
					OpenMenuVestPres()
				end
			end
			if(isInServicePres) then
				if IsControlJustPressed(1,166) then 
					OpenPresidentMenu()
				end
			end
			
			if(isInServicePres) then
				if(isNearStationGarage()) then
					if(presidentvehicle ~= nil) then --existingVehPres
						DisplayHelpText('Appuis sur ~INPUT_CONTEXT~ pour ranger ton véhicule',0,1,0.5,0.8,0.6,255,255,255,255)
					else
						DisplayHelpText('Appuis sur ~INPUT_CONTEXT~ pour ouvrir le ~b~garage du président',0,1,0.5,0.8,0.6,255,255,255,255)
					end
					
					if IsControlJustPressed(1,51) then
						if(presidentvehicle ~= nil) then
							SetEntityAsMissionEntity(presidentvehicle, true, true)
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(presidentvehicle))
							presidentvehicle = nil
						else
							OpenVeh()
						end
					end
				end
				
				
			end
		else
			if (handCuffedPres == true) then
			  RequestAnimDict('mp_arresting')

			  while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(0)
			  end

			  local myPed = PlayerPedId()
			  local animation = 'idle'
			  local flags = 16

			  TaskPlayAnim(myPed, 'mp_arresting', animation, 8.0, -8, -1, flags, 0, 0, 0, 0)
			end
		end
    end
end)
---------------------------------------------------------------------------------------
-------------------------------SPAWN HELI AND CHECK DEATH------------------------------
---------------------------------------------------------------------------------------
local alreadyDead = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if(isPres) then
			if(isInServicePres) then
			
				if(IsPlayerDead(PlayerId())) then
					if(alreadyDead == false) then
						ServicePresOff()
						alreadyDead = true
					end
				else
					alreadyDead = false
				end
			
				DrawMarker(1,449.113,-981.084,42.691,0,0,0,0,0,0,2.0,2.0,2.0,0,155,255,200,0,0,0,0)
			
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 449.113,-981.084,43.691, true ) < 5 then
					if(existingVehPres ~= nil) then
						DisplayHelpText('Press ~INPUT_CONTEXT~ to store ~b~your ~b~helicopter',0,1,0.5,0.8,0.6,255,255,255,255)
					else
						DisplayHelpText('Press ~INPUT_CONTEXT~ to drive an helicopter out',0,1,0.5,0.8,0.6,255,255,255,255)
					end
					
					if IsControlJustPressed(1,51)  then
						if(existingVehPres ~= nil) then
							SetEntityAsMissionEntity(existingVehPres, true, true)
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVehPres))
							existingVehPres = nil
						else
							local car = GetHashKey("polmav")
							local ply = GetPlayerPed(-1)
							local plyCoords = GetEntityCoords(ply, 0)
							
							RequestModel(car)
							while not HasModelLoaded(car) do
									Citizen.Wait(0)
							end
							
							existingVehPres = CreateVehicle(car, plyCoords["x"], plyCoords["y"], plyCoords["z"], 90.0, true, false)
							local id = NetworkGetNetworkIdFromEntity(existingVehPres)
							SetNetworkIdCanMigrate(id, true)
							TaskWarpPedIntoVehicle(ply, existingVehPres, -1)
						end
					end
				end
			end
		end
    end
end)