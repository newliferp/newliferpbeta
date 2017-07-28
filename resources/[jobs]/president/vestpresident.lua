-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------President script by Edwyn---------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local vestpresident = {
	opened = false,
	title = "Vestiaire",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }, -- ???
	menu = {
		x = 0.11,
		y = 0.25,
		width = 0.2,
		height = 0.04,
		buttons = 10,  --Nombre de bouton
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Prendre son service", description = ""},
				{name = "Arrêter son service", description = ""},
			}
		},
	}
}

local hashSkin = GetHashKey("mp_m_freemode_01")
-------------------------------------------------
----------------CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelectedVest(button)
	local ped = GetPlayerPed(-1)
	local this = vestpresident.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Prendre son service" then
			ServicePresOn()                                                 -- En Service + Uniforme
			giveUniforme()
			drawNotification("Tu as pris ton ~g~service")
			drawNotification("Appuis sur ~g~F5~w~ pour ouvrir le ~b~menu president")
		elseif btn == "Arrêter son service" then
			ServicePresOff()
			removeUniforme()                                            --Finir Service + Enleve Uniforme
			drawNotification("Tu as ~r~arrêter ton service")
		end
	end
end
-------------------------------------------------
------------------FONCTION UNIFORME--------------
-------------------------------------------------
function giveUniforme()
	Citizen.CreateThread(function()
	
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then

			SetPedComponentVariation(GetPlayerPed(-1), 7, 115, 0, 0) -- Cravate
			    SetPedComponentVariation(GetPlayerPed(-1), 8, 10, 0, 0) -- Chemise
			    SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 0) -- Main
			    SetPedComponentVariation(GetPlayerPed(-1), 11, 28, 0, 0) -- Veste
			    SetPedComponentVariation(GetPlayerPed(-1), 4, 10, 0, 0) -- Jeans
			    SetPedComponentVariation(GetPlayerPed(-1), 6, 10, 0, 0) -- Chaussure	
		end
		
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
	end)
end

function removeUniforme()
	Citizen.CreateThread(function()
		TriggerServerEvent("skin_customization:SpawnPlayer")
		RemoveAllPedWeapons(GetPlayerPed(-1))
	end)
end
-------------------------------------------------
----------------CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenVestMenuPres(menu)
	vestpresident.menu.from = 1
	vestpresident.menu.to = 10
	vestpresident.selectedbutton = 0
	vestpresident.currentmenu = menu
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
local menu = vestpresident.menu
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
	local menu = vestpresident.menu
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
	local menu = vestpresident.menu
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
	local menu = vestpresident.menu
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
function BackVest()
	if backlock then
		return
	end
	backlock = true
	if vestpresident.currentmenu == "main" then
		CloseMenuVestPres()
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
function OpenMenuVestPres()
	vestpresident.currentmenu = "main"
	vestpresident.opened = true
	vestpresident.selectedbutton = 0
end
-------------------------------------------------
----------------FONCTION CLOSE-------------------
-------------------------------------------------
function CloseMenuVestPres()
		vestpresident.opened = false
		vestpresident.menu.from = 1
		vestpresident.menu.to = 10
end
-------------------------------------------------
----------------FONCTION OPEN MENU---------------
-------------------------------------------------
local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if GetDistanceBetweenCoords(108.862, -744.78, 242.152,GetEntityCoords(GetPlayerPed(-1))) > 2 then
			if vestpresident.opened then
				CloseMenuVestPres()
			end
		end
		if vestpresident.opened then
			local ped = LocalPed()
			local menu = vestpresident.menu[vestpresident.currentmenu]
			drawTxt(vestpresident.title,1,1,vestpresident.menu.x,vestpresident.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, vestpresident.menu.x,vestpresident.menu.y + 0.08)
			drawTxt(vestpresident.selectedbutton.."/"..tablelength(menu.buttons),0,0,vestpresident.menu.x + vestpresident.menu.width/2 - 0.0385,vestpresident.menu.y + 0.067,0.4, 255,255,255,255)
			local y = vestpresident.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= vestpresident.menu.from and i <= vestpresident.menu.to then

					if i == vestpresident.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,vestpresident.menu.x,y,selected)
					if button.distance ~= nil then
						drawMenuRight(button.distance.."m",vestpresident.menu.x,y,selected)
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelectedVest(button)
					end
				end
			end
		end
		if vestpresident.opened then
			if IsControlJustPressed(1,202) then
				BackVest()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if vestpresident.selectedbutton > 1 then
					vestpresident.selectedbutton = vestpresident.selectedbutton -1
					if buttoncount > 10 and vestpresident.selectedbutton < vestpresident.menu.from then
						vestpresident.menu.from = vestpresident.menu.from -1
						vestpresident.menu.to = vestpresident.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if vestpresident.selectedbutton < buttoncount then
					vestpresident.selectedbutton = vestpresident.selectedbutton +1
					if buttoncount > 10 and vestpresident.selectedbutton > vestpresident.menu.to then
						vestpresident.menu.to = vestpresident.menu.to + 1
						vestpresident.menu.from = vestpresident.menu.from + 1
					end
				end
			end
		end

	end
end)
