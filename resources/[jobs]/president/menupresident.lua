-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------PRESIDENT MENU---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local menupresident = {
	opened = false,
	title = "Menu President V1",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.11,
		y = 0.25,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Animations", description = ""},
				{name = "Intéraction Civil", description = ""},
				{name = "Vehicle", description = ""},
				{name = "Call for backup(SOON)", description = ""},
				{name = "Radar Speed Detector(SOON)", description = ""},
				{name = "Fermer le menu", description = ""},
			}
		},
		["Animations"] = {
			title = "ANIMATIONS",
			name = "Animations",
			buttons = {
				{name = "Traffic Cop", description = ''},
				{name = "Take notes", description = ''},
				{name = "Stand By", description = ''},
				{name = "Stand By 2", description = ''},
				{name = "Faire des pompes", description = ''},
			}
		},
		["Intéraction Civil"] = {
			title = "INTERACTION CIVIL",
			name = "Intéraction Civil",
			buttons = {
				{name = "Carte identité(SOON)", description = ''},
				{name = "Fouiller", description = ''},
				{name = "(dé)Menotter", description = ''},
				{name = "Rentrer dans le véhicule", description = ''},
				{name = "Sortir du véhicule", description = ''},
				{name = "Amendes", description = ''},
			}
		},
		["Amendes"] = {
			title = "Amendes",
			name = "Amendes",
			buttons = {
				{name = "$250", description = 'Griller un feu rouge'},
				{name = "$500", description = ''},
				{name = "$1000", description = ''},
				{name = "$1500", description = ''},
				{name = "$2000", description = ''},
				{name = "$4000", description = ''},
				{name = "$6000", description = ''},
				{name = "$8000", description = ''},
				{name = "$10000", description = ''},
				{name = "$11000", description = ''},
				{name = "$15000", description = ''},
				{name = "$25000", description = ''},
				{name = "$30000", description = ''},
				{name = "$35000", description = ''},
				{name = "$40000", description = ''},
				{name = "$45000", description = ''},
				{name = "$50000", description = ''},
				{name = "$60000", description = ''},
				{name = "$80000", description = ''},
			}
		},
		["Vehicle"] = {
			title = "VEHICLE INTERACTIONS",
			name = "Vehicle",
			buttons = {
				{name = "Check Plate", description = ''},
				{name = "Crochet", description = ''},
			}
		},
	}
}
-------------------------------------------------
----------------CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelectedPresident(button)
	local ped = GetPlayerPed(-1)
	local this = menupresident.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Animations" then
			OpenMenuPresident('Animations')
		elseif btn == "Intéraction Civil" then
			OpenMenuPresident('Intéraction Civil')
		elseif btn == "Vehicle" then
			OpenMenuPresident('Vehicle')
		elseif btn == "Fermer le menu" then
			CloseMenuPresident()
		end
	elseif this == "Animations" then
		if btn == "Traffic Cop" then
			Circulation()
		elseif btn == "Take notes" then
			Note()
		elseif btn == "Stand By" then
			StandBy()
		elseif btn == "Stand By 2" then
			StandBy2()
		elseif btn == "Faire des pompes" then
			Pompes()
		end
	elseif this == "Intéraction Civil" then
		if btn == "Amendes" then
			OpenMenuPresident('Amendes')
		elseif btn == "Fouiller" then
			Check()
		elseif btn == "(dé)Menotter" then
			Cuffed()
		elseif btn == "Rentrer dans le véhicule" then
			PutInVehicle()
		elseif btn == "Sortir du véhicule" then
			UnseatVehicle()
		end
	elseif this == "Vehicle" then
		if btn == "Crochet"then
			Crocheter()
		elseif btn == "Check Plate" then
			CheckPlate()
		end
	elseif this == "Amendes" then
		if btn == "$250"then
			Fines(250)
		elseif btn == "$500" then
			Fines(500)
		elseif btn == "$1000" then
			Fines(1000)
		elseif btn == "$1500" then
			Fines(1500)
		elseif btn == "$2000" then
			Fines(2000)
		elseif btn == "$4000" then
			Fines(4000)
		elseif btn == "$6000" then
			Fines(6000)
		elseif btn == "$8000" then
			Fines(8000)
		elseif btn == "$10000" then
			Fines(10000)
		elseif btn == "$11000" then
			Fines(11000)
		elseif btn == "$15000" then
			Fines(15000)
		elseif btn == "$25000" then
			Fines(25000)
		elseif btn == "$30000" then
			Fines(30000)
		elseif btn == "$35000" then
			Fines(35000)
		elseif btn == "$40000" then
			Fines(40000)
		elseif btn == "$45000" then
			Fines(45000)
		elseif btn == "$50000" then
			Fines(50000)
		elseif btn == "$60000" then
			Fines(60000)
		elseif btn == "$80000" then
			Fines(80000)
		end
	end
end
-------------------------------------------------
----------------FONCTION ANIMATIONS---------------
-------------------------------------------------
function Circulation()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false)
        Citizen.Wait(60000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification("~g~Tu fais la circulation.")
end

function Note()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end) 
	drawNotification("~g~Tu prends des notes.")
end

function StandBy()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, true)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification("~g~Tu attends.")
end

function StandBy2()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GUARD_STAND", 0, 1)
        Citizen.Wait(20000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification("~g~Tu attends.")
end

function Pompes()
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_PUSH_UPS", 0, false)
        Citizen.Wait(60000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end)
	drawNotification("~g~Tu fais des pompes.")
end

-------------------------------------------------
------------FONCTION INTERACTION Citizen---------
-------------------------------------------------
function Check()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("president:targetCheckInventory", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'GOUVERNEMENT', {255, 0, 0}, "Pas de joueur prêt de toi !")
	end
end

function Cuffed()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("president:cuffGranted", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'GOUVERNEMENT', {255, 0, 0}, "Pas de joueur prêt de toi !")
	end
end

function PutInVehicle()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		local v = GetVehiclePedIsIn(GetPlayerPed(-1), true)
		TriggerServerEvent("president:forceEnterAsk", GetPlayerServerId(t), v)
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de joueur prêt de toi !")
	end
end

function UnseatVehicle()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("president:confirmUnseat", GetPlayerServerId(t))
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de joueur prêt de toi !")
	end
end

function Fines(amount)
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("president:finesGranted", GetPlayerServerId(t), amount)
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de joueur prêt de toi !")
	end
end

-------------------------------------------------
------------FONCTION INTERACTION VEHICLE---------
-------------------------------------------------
function Crocheter()
	Citizen.CreateThread(function()
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	--GetClosestVehicle(x,y,z,distance dectection, 0 = tous les vehicules, Flag 70 = tous les veicules sauf president a tester https://pastebin.com/kghNFkRi)
	veh = GetClosestVehicle(plyCoords["x"], plyCoords["y"], plyCoords["z"], 5.001, 0, 70)
	TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
	Citizen.Wait(20000)
    SetVehicleDoorsLocked(veh, 1)
	ClearPedTasksImmediately(GetPlayerPed(-1))
	drawNotification("Le véhicule est maintenant ~g~OUVERT~w~.")
	end)
end

function CheckPlate()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
	if(DoesEntityExist(vehicleHandle)) then
		TriggerServerEvent("president:checkingPlate", GetVehicleNumberPlateText(vehicleHandle))
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de voiture prêt de toi !")
	end
end
-------------------------------------------------
----------------CONFIG OPEN MENU-----------------
-------------------------------------------------
function Openmenupresident(menu)
	menupresident.lastmenu = menupresident.currentmenu
	if menu == "Animations" then
		menupresident.lastmenu = "main"
	elseif menu == "Intéraction Civil" then
		menupresident.lastmenu = "main"
	elseif menu == "Vehicle" then
		menupresident.lastmenu = "main"
	elseif menu == "Amendes" then
		menupresident.lastmenu = "main"
	end
	menupresident.menu.from = 1
	menupresident.menu.to = 10
	menupresident.selectedbutton = 0
	menupresident.currentmenu = menu
end
-------------------------------------------------
------------------DRAW NOTIFY--------------------
-------------------------------------------------
function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end
--------------------------------------
-------------DISPLAY HELP TEXT--------
--------------------------------------
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
-------------------------------------------------
------------------DRAW TITLE MENU----------------
-------------------------------------------------
function drawMenuTitle(txt,x,y)
local menu = menupresident.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end
-------------------------------------------------
------------------DRAW MENU BOUTON---------------
-------------------------------------------------
function drawMenuButton(button,x,y,selected)
	local menu = menupresident.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end
-------------------------------------------------
------------------DRAW MENU INFO-----------------
-------------------------------------------------
function drawMenuInfo(text)
	local menu = menupresident.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)
end
-------------------------------------------------
----------------DRAW MENU DROIT------------------
-------------------------------------------------
function drawMenuRight(txt,x,y,selected)
	local menu = menupresident.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end
-------------------------------------------------
-------------------DRAW TEXT---------------------
-------------------------------------------------
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
-------------------------------------------------
----------------CONFIG BACK MENU-----------------
-------------------------------------------------
function Backmenupresident()
	if backlock then
		return
	end
	backlock = true
	if menupresident.currentmenu == "main" then
		Closemenupresident()
	elseif menupresident.currentmenu == "Animations" or menupresident.currentmenu == "Intéraction Civil" or menupresident.currentmenu == "Vehicle" or menupresident.currentmenu == "Amendes" then
		Openmenupresident(menupresident.lastmenu)
	else
		Openmenupresident(menupresident.lastmenu)
	end
end
-------------------------------------------------
---------------------FONCTION--------------------
-------------------------------------------------
function f(n)
return n + 0.0001
end

function LocalPed()
return GetPlayerPed(-1)
end

function try(f, catch_f)
local status, exception = pcall(f)
if not status then
catch_f(exception)
end
end
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end
-------------------------------------------------
----------------FONCTION OPEN--------------------
-------------------------------------------------
function OpenpresidentMenu()
	menupresident.currentmenu = "main"
	menupresident.opened = true
	menupresident.selectedbutton = 0
end
-------------------------------------------------
----------------FONCTION CLOSE-------------------
-------------------------------------------------
function Closemenupresident()
		menupresident.opened = false
		menupresident.menu.from = 1
		menupresident.menu.to = 10
end
-------------------------------------------------
----------------FONCTION OPEN MENU---------------
-------------------------------------------------
local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,166) and menupresident.opened == true then
				Closemenupresident()
		end
		if menupresident.opened then
			local ped = LocalPed()
			local menu = menupresident.menu[menupresident.currentmenu]
			drawTxt(menupresident.title,1,1,menupresident.menu.x,menupresident.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, menupresident.menu.x,menupresident.menu.y + 0.08)
			drawTxt(menupresident.selectedbutton.."/"..tablelength(menu.buttons),0,0,menupresident.menu.x + menupresident.menu.width/2 - 0.0385,menupresident.menu.y + 0.067,0.4, 255,255,255,255)
			local y = menupresident.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= menupresident.menu.from and i <= menupresident.menu.to then

					if i == menupresident.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,menupresident.menu.x,y,selected)
					if button.distance ~= nil then
						drawMenuRight(button.distance.."m",menupresident.menu.x,y,selected)
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelectedPresident(button)
					end
				end
			end
		end
		if menupresident.opened then
			if IsControlJustPressed(1,202) then
				BackMenuPresident()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if menupresident.selectedbutton > 1 then
					menupresident.selectedbutton = menupresident.selectedbutton -1
					if buttoncount > 10 and menupresident.selectedbutton < menupresident.menu.from then
						menupresident.menu.from = menupresident.menu.from -1
						menupresident.menu.to = menupresident.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if menupresident.selectedbutton < buttoncount then
					menupresident.selectedbutton = menupresident.selectedbutton +1
					if buttoncount > 10 and menupresident.selectedbutton > menupresident.menu.to then
						menupresident.menu.to = menupresident.menu.to + 1
						menupresident.menu.from = menupresident.menu.from + 1
					end
				end
			end
		end

	end
end)