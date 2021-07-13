ESX             				= nil


local PlayerData                = {}
local nevidljiv = false


Citizen.CreateThread(function()
  while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

function BurekNotifikacije(title, subject, msg)

	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))
  
	ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
  
	UnregisterPedheadshot(mugshot)

end

RegisterNetEvent('burek:popravi')
AddEventHandler('burek:popravi', function()
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
    exports.pNotify:SendNotification({text = "Tvoje vozilo je popravljeno!", type = "success", timeout = 2000, layout = "center", queue = "right"})
	else
    exports.pNotify:SendNotification({text = "Nisi u vozilu", type = "error", timeout = 2000, layout = "center", queue = "right"})
	end
end)

RegisterNetEvent('burek:operi')
AddEventHandler('burek:operi', function()
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleDirtLevel(vehicle, 0)
		exports.pNotify:SendNotification({text = "Tvoje vozilo je oprano", type = "success", timeout = 2000, layout = "center", queue = "right"})
	else
		exports.pNotify:SendNotification({text = "Nisi u vozilu", type = "error", timeout = 2000, layout = "center", queue = "right"})
	end
end)

  function AdminMeni()

    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'admin',
    {
      css      = 'meni',
      title    = 'Hype RolePlay',
      align    = 'top-left',
      elements = {
        {label = 'Nevidljivost', value = 'nevidljiv'},
        {label = 'Teleport na marker', value = 'teleport_marker'},
        {label = 'Admin Auto', value = 'admin_auto'},
        {label = 'Admin Meni', value = 'admin_meni'},
        {label = 'Popravi Auto', value = 'popravi_auto'},
        {label = 'Operi Auto', value = 'operi_auto'},
        {label = 'Spectate', value = 'spectate'},
        {label = 'Obrisi auto', value = 'dv'}
      }
    },
      
      function(data, menu)
  
        if data.current.value == 'nevidljiv' then
          if nevidljiv == false then
            SetEntityVisible(GetPlayerPed(-1), false)
            exports.pNotify:SendNotification({text = "Nevidjlivost je ukljucena", type = "success", timeout = 2000, layout = "center", queue = "right"})
            nevidljiv = true
          else
            SetEntityVisible(GetPlayerPed(-1), true)
            exports.pNotify:SendNotification({text = "Nevidjlivost je iskljucena", type = "error", timeout = 2000, layout = "center", queue = "right"})
            nevidljiv = false
          end
        end
  
        if data.current.value == 'teleport_marker' then
          local WaypointHandle = GetFirstBlipInfoId(8)
  
          if DoesBlipExist(WaypointHandle) then
            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
  
            for height = 1, 1000 do
              SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
  
              local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
  
              if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                break
              end
              Citizen.Wait(0)
            end
            exports.pNotify:SendNotification({text = "Uspesno ste se teleportovali", type = "success", timeout = 2000, layout = "center", queue = "right"})
          else
            exports.pNotify:SendNotification({text = "Morate da postavite marker", type = "error", timeout = 2000, layout = "center", queue = "right"})
          end
        end
  
        if data.current.value == 'admin_auto' then
          TriggerEvent('esx:spawnVehicle', "lp610")
          ESX.UI.Menu.CloseAll()
        end
  
        if data.current.value == 'admin_meni' then
          TriggerEvent('es_admin2:open')
        end

        if data.current.value == 'popravi_auto' then
          TriggerEvent('burek:popravi')
        end

        if data.current.value == 'operi_auto' then
          TriggerEvent('burek:operi')
        end
  
        if data.current.value == 'spectate' then
          TriggerEvent('esx_spectate:spectate')
        end

        if data.current.value == 'dv' then
          TriggerEvent('esx:deleteVehicle')
        end
      end,
      function(data, menu)
        menu.close()
      end
    )
  end
  
  RegisterNetEvent("esx_adminmeni:admin")
  AddEventHandler("esx_adminmeni:admin", function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
      if playerRank == "admin" or playerRank == "superadmin" then
        AdminMeni()
      else
        BurekNotifikacije('~r~Ac4BroYT Admin Menu', '~w~Pristup odbijen', 'Nemate dozvolu!.')
      end
    end)
  end)
  
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if IsControlPressed(0, 56) then
          TriggerEvent('esx_adminmeni:admin')
      end
    end
  end)