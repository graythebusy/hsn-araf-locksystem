ESX = nil

Keys = {}
PlayerData = {}
SearchedVeh = {}
local disableF = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('hsn-araf-locksystem:client:addKeys')
AddEventHandler('hsn-araf-locksystem:client:addKeys', function(data)
    Keys[data] = true
end)

RegisterNetEvent('hsn-araf-locksystem:client:removeKeys')
AddEventHandler('hsn-araf-locksystem:client:removeKeys',function(plate)
    Keys[plate] = nil
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	ClearDrawOrigin()
end

function playAnim(animDict, animName, duration, flag)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, -8.0, -8, duration, flag, 0, 0, 0, 0)
end

function disableMouse()
    DisableControlAction(0, 1, true) -- LookLeftRight
    DisableControlAction(0, 2, true) -- LookUpDown
    DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
end

function disableMovement()
    DisableControlAction(0, 30, true) -- disable left/right
    DisableControlAction(0, 31, true) -- disable forward/back
    DisableControlAction(0, 36, true) -- INPUT_DUCK
    DisableControlAction(0, 21, true) -- disable sprint
end

function disableCarMovements()
    DisableControlAction(0, 63, true) -- veh turn left
    DisableControlAction(0, 64, true) -- veh turn right
    DisableControlAction(0, 71, true) -- veh forward
    DisableControlAction(0, 72, true) -- veh backwards
    DisableControlAction(0, 75, true) -- disable exit vehicle
end

function disableCombat()
    DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
    DisableControlAction(0, 24, true) -- disable attack
    DisableControlAction(0, 25, true) -- disable aim
    DisableControlAction(1, 37, true) -- disable weapon select
    DisableControlAction(0, 47, true) -- disable weapon
    DisableControlAction(0, 58, true) -- disable weapon
    DisableControlAction(0, 140, true) -- disable melee
    DisableControlAction(0, 141, true) -- disable melee
    DisableControlAction(0, 142, true) -- disable melee
    DisableControlAction(0, 143, true) -- disable melee
    DisableControlAction(0, 263, true) -- disable melee
    DisableControlAction(0, 264, true) -- disable melee
    DisableControlAction(0, 257, true) -- disable melee
end

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        if IsPedInAnyVehicle(PlayerPedId(),false)  then
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            local class = GetVehicleClass(vehicle)
            local Plate = GetVehicleNumberPlateText(vehicle)
            local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 1.25, 0.35)
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
                if Keys[Plate] ~= true then
                    if class ~= 13 and class ~= 14 and class ~= 15 and class ~= 16 and class ~= 19 and class ~= 21 then
                        wait = 10
                        if SearchedVeh[Plate] ~= true then
                            text = _U('hotwire_text_not_searched')
                        else
                            text = _U('hotwire_text_searched')
                        end
                        if IsControlJustPressed(1, 74) then--H
                            ESX.TriggerServerCallback('hsn-araf-locksystem:tornavida', function(cb)
                                if cb ~= nil and cb ~= false then
                                    disableCombat()
                                    disableCarMovements()
                                    disableMovement()
                                    playAnim(Config.AnimDict, Config.AnimName, -1, 1)
                                    SetVehicleAlarm(vehicle, true)
                                    SetVehicleAlarmTimeLeft(vehicle, Config.AlarmTime * 1000)
                                    local finished = exports["reload-skillbar"]:taskBar(3500,math.random(5,10))
                                    if finished ~= 100 then
                                        ClearPedTasks(PlayerPedId())
                                        exports['mythic_notify']:SendAlert('inform', _U('hotwire_failed'))
                                        EnableAllControlActions(0)
                                        EnableAllControlActions(1)
                                        TriggerServerEvent('hsn-araf-locksystem:deleteItem', 'tornavida')
                                    else
                                        local finished2 = exports["reload-skillbar"]:taskBar(5000,math.random(5,6))
                                        if finished2 ~= 100 then
                                            ClearPedTasks(PlayerPedId())
                                            exports['mythic_notify']:SendAlert('inform', _U('hotwire_failed'))
                                            EnableAllControlActions(0)
                                            EnableAllControlActions(1)
                                            TriggerServerEvent('hsn-araf-locksystem:deleteItem', 'tornavida')
                                        else
                                            local finished3 = exports["reload-skillbar"]:taskBar(2000,math.random(15,25))
                                            if finished3 ~= 100 then
                                                ClearPedTasks(PlayerPedId())
                                                exports['mythic_notify']:SendAlert('inform', _U('hotwire_failed'))
                                                EnableAllControlActions(0)
                                                EnableAllControlActions(1)
                                                TriggerServerEvent('hsn-araf-locksystem:deleteItem', 'tornavida')
                                            else
                                                if math.random(0, 100) < 25 then
                                                    local finished4 = exports["reload-skillbar"]:taskBar(2000,math.random(15,25))
                                                    if finished4 ~= 100 then
                                                        ClearPedTasks(PlayerPedId())
                                                        exports['mythic_notify']:SendAlert('inform', _U('hotwire_failed'))
                                                        EnableAllControlActions(0)
                                                        EnableAllControlActions(1)
                                                        TriggerServerEvent('hsn-araf-locksystem:deleteItem', 'tornavida')
                                                    else
                                                        if math.random(0, 100) < 50 then
                                                            local finished4 = exports["reload-skillbar"]:taskBar(2000,math.random(15,25))
                                                            if finished4 ~= 100 then
                                                                ClearPedTasks(PlayerPedId())
                                                                exports['mythic_notify']:SendAlert('inform', _U('hotwire_failed'))
                                                                EnableAllControlActions(0)
                                                                EnableAllControlActions(1)
                                                                TriggerServerEvent('hsn-araf-locksystem:deleteItem', 'tornavida')
                                                            else
                                                                if math.random(0, 100) < 75 then
                                                                    local finished5 = exports["reload-skillbar"]:taskBar(2000,math.random(15,25))
                                                                    if finished5 ~= 100 then
                                                                        ClearPedTasks(PlayerPedId())
                                                                        exports['mythic_notify']:SendAlert('inform', _U('hotwire_failed'))
                                                                        EnableAllControlActions(0)
                                                                        EnableAllControlActions(1)
                                                                        TriggerServerEvent('hsn-araf-locksystem:deleteItem', 'tornavida')
                                                                    else
                                                                        ClearPedTasks(PlayerPedId())
                                                                        EnableAllControlActions(0)
                                                                        EnableAllControlActions(1)
                                                                        AddKeys(Plate)
                                                                        SetVehicleEngineOn(vehicle,true)
                                                                        exports['mythic_notify']:SendAlert('inform', _U('hotwire_successful'))
                                                                    end
                                                                else
                                                                    ClearPedTasks(PlayerPedId())
                                                                    EnableAllControlActions(0)
                                                                    EnableAllControlActions(1)
                                                                    AddKeys(Plate)
                                                                    SetVehicleEngineOn(vehicle,true)
                                                                    exports['mythic_notify']:SendAlert('inform', _U('hotwire_successful'))
                                                                end
                                                            end
                                                        else
                                                            ClearPedTasks(PlayerPedId())
                                                            EnableAllControlActions(0)
                                                            EnableAllControlActions(1)
                                                            AddKeys(Plate)
                                                            SetVehicleEngineOn(vehicle,true)
                                                            exports['mythic_notify']:SendAlert('inform', _U('hotwire_successful'))
                                                        end
                                                    end
                                                else
                                                    ClearPedTasks(PlayerPedId())
                                                    EnableAllControlActions(0)
                                                    EnableAllControlActions(1)
                                                    AddKeys(Plate)
                                                    SetVehicleEngineOn(vehicle,true)
                                                    exports['mythic_notify']:SendAlert('inform', _U('hotwire_successful'))
                                                end
                                            end
                                        end
                                    end
                                else
                                    exports['mythic_notify']:SendAlert('inform', _U('tornavida_yok'))
                                end
                            end)
                        end
                        if IsControlJustPressed(1, 20) then --Z
                            if SearchedVeh[Plate] ~= true then
                                SearchVehicle(Plate)
                            end
                        end
                        DrawText3Ds(vehicleCoords.x,vehicleCoords.y,vehicleCoords.z,text)
                    end
                end
            end
        end
        Citizen.Wait(wait)  
    end
end)

RegisterCommand('anahtarver', function()
    local vehicle = ESX.Game.GetVehicleInDirection()
    local Plate = GetVehicleNumberPlateText(vehicle)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if vehicle ~= nil then
        if Keys[Plate] == true then
            if closestPlayer ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('hsn-araf-locksystem:server:giveKeys',GetPlayerServerId(closestPlayer), Plate)
            else
                exports['mythic_notify']:SendAlert('inform', _U('nobody_near'))
            end
        else
            exports['mythic_notify']:SendAlert('inform', _U('no_keys'))
        end
    else
        exports['mythic_notify']:SendAlert('inform', _U('must_look_at_car'))
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 750
        local veh = GetVehiclePedIsIn(PlayerPedId() , false)
        local Plate = GetVehicleNumberPlateText(veh)
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and Keys[Plate] ~= true then
            wait = 6
            SetVehicleEngineOn(veh, false)
        end
        Citizen.Wait(wait)
    end
end)

SearchVehicle = function(plate)
    exports['mythic_progbar']:Progress({
        name = "search_veh_locksystem",
        duration = 10000,
        label = _U('searching_car'),
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = Config.AnimDict,
            anim = Config.AnimName,
            flags = 1,
        },
        prop = {
            model = "",
            bone = 18905,
            coords = { x = 0.10, y = 0.02, z = 0.08 },
            rotation = { x = -80.0, y = 0.0, z = 0.0 },
        },
        propTwo = {
            model = "",
            bone = 58866,
            coords = { x = 0.12, y = 0.0, z = 0.001 },
            rotation = { x = -150.0, y = 0.0, z = 0.0 },
        },
    }, function(cancelled)
        if not cancelled then
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('hsn-araf-locksystem:server:SearchVeh', plate)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if IsControlJustReleased(1,182) then
            local coords = GetEntityCoords(PlayerPedId())
            vehicle = ESX.Game.GetClosestVehicle()
            local Plate = GetVehicleNumberPlateText(vehicle)
            if Keys[Plate] == true then
                local lock = GetVehicleDoorLockStatus(vehicle)
                if lock == 1 or lock == 0 then
                    playAnim("anim@mp_player_intmenu@key_fob@", "fob_click_fp", -1, 0)
                    SetVehicleDoorShut(vehicle, 0, false)
                    SetVehicleDoorShut(vehicle, 1, false)
                    SetVehicleDoorShut(vehicle, 2, false)
                    SetVehicleDoorShut(vehicle, 3, false)
                    SetVehicleDoorsLocked(vehicle, 2)
                    PlayVehicleDoorCloseSound(vehicle, 1)
                    SetVehicleLights(vehicle, 2)
                    SetVehicleLights(vehicle, 0)
                    SetVehicleLights(vehicle, 2)
                    SetVehicleLights(vehicle, 0)
                    exports['mythic_notify']:SendAlert('inform', _U('vehicle_locked'))
                elseif lock == 2 then
                    playAnim("anim@mp_player_intmenu@key_fob@", "fob_click_fp", -1, 0)
                    SetVehicleDoorsLocked(vehicle, 1)
					PlayVehicleDoorOpenSound(vehicle, 0)
					SetVehicleLights(vehicle, 2)
					SetVehicleLights(vehicle, 0)
					SetVehicleLights(vehicle, 2)
                    SetVehicleLights(vehicle, 0)
                    exports['mythic_notify']:SendAlert('inform', _U('vehicle_unlocked'))
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 1000
	local sent = false

        if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
            local curveh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local pedDriver = GetPedInVehicleSeat(curveh, -1)
            local plate = GetVehicleNumberPlateText(curveh)

            if Keys[plate] ~= true and DoesEntityExist(pedDriver) and IsEntityDead(pedDriver) and not IsPedAPlayer(pedDriver)  then
                wait = 10
                TriggerServerEvent('hsn-araf-locksystem:addKeys',plate)

		if sent == false then
		   exports['mythic_notify']:SendAlert('inform', _U('took_keys', plate))
		   sent = true
		end

		Citizen.Wait(2500)
		sent = false
            end
        end
        Citizen.Wait(wait)
    end
end)

AddKeys = function(plate)
    if plate ~= nil then
        TriggerServerEvent('hsn-araf-locksystem:addKeys',plate)
    end
end

RegisterNetEvent('hsn-araf-locksystem:client:useLockpick')
AddEventHandler('hsn-araf-locksystem:client:useLockpick', function()
    local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)

	if IsPedSittingInAnyVehicle(playerPed) then
		--ESX.ShowNotification(_U('inside_vehicle'))
		exports['mythic_notify']:SendAlert('error', _U('cant_do_this_in_vehicle'))
		return
	end

	if DoesEntityExist(vehicle) then
		isBusy = true
        local spawnCoords = vector3(GetEntryPositionOfDoor(vehicle, 0).x, GetEntryPositionOfDoor(vehicle, 0).y, GetEntryPositionOfDoor(vehicle, 0).z - 1)
        SetEntityCoords(playerPed, 	spawnCoords, false, false, false, true)
        exports['mythic_progbar']:Progress({
            name = "lockpick_locksystem",
            duration = 10000,
            label = _U('lockpick'),
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "missheistdockssetup1clipboard@base",
                anim = "base",
                flags = 49,
            },
        }, function(cancelled)
            if not cancelled then
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                SetVehicleDoorsLocked(vehicle, 1)
                ClearPedTasksImmediately(playerPed)
                TriggerServerEvent('hsn-araf-locksystem:deleteItem', 'lockpick')
                --ESX.ShowNotification(_U('vehicle_unlocked'))
                exports['mythic_notify']:SendAlert('inform', _U('vehicle_unlocked'))
                isBusy = false
            else
                isBusy = false
                TriggerServerEvent('hsn-araf-locksystem:deleteItem', 'lockpick')
            end
        end)
	else
		--ESX.ShowNotification(_U('no_vehicle_nearby'))
		exports['mythic_notify']:SendAlert('error', _U('no_car_near'))
	end
end)

Citizen.CreateThread(function()
    while true do
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local lock = GetVehicleDoorLockStatus(veh)
            local luck = math.random(1, 100)

            if Config.UnlockedChance >= 100 then
                Config.UnlockedChance = 100
            elseif Config.UnlockedChance <= 0 then
                Config.UnlockedChance = 0
            end

            if (Config.UnlockedChance >= luck) then
                SetVehicleDoorsLocked(veh, 1)
            elseif (GetConvertibleRoofState(veh) == 1) or (GetConvertibleRoofState(veh) == 2) then
                SetVehicleDoorsLocked(veh, 1)
            elseif (IsVehicleDoorFullyOpen(veh, 0)) or (IsVehicleDoorFullyOpen(veh, 1)) or (IsVehicleDoorFullyOpen(veh, 2)) or (IsVehicleDoorFullyOpen(veh, 3)) or not DoesVehicleHaveDoor(veh, 0) then
                SetVehicleDoorsLocked(veh, 1)
            elseif lock == 0 or lock == 7 or lock == 3 then
                SetVehicleDoorsLocked(veh, 2)
            end
        end
        Citizen.Wait(10)
    end
end)
