ESX = nil
PlayerData = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    if ESX.IsPlayerLoaded() then 
        PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
end)

-- Citizen.CreateThread(function()
--     Citizen.Wait(1000)
-- 	for k,v in pairs(Config.Blips) do
-- 		local blip = AddBlipForRadius(v.x, v.y, v.z, v.Size)
	
-- 		SetBlipColour(blip, v.Color)
-- 		SetBlipAlpha(blip, v.Alpha)
-- 	end
-- end)

playerinzone = false

Citizen.CreateThread(function ()
    Citizen.Wait(0)
    for k,v in pairs(Config.Blips) do
        while true do
            Citizen.Wait(7)
            local player = PlayerPedId()
            local dist = GetDistanceBetweenCoords(GetEntityCoords(player), vector3(v.x,v.y,v.z), true)
            if dist <= v.Size then
                playerinzone = true
                if not v.notifIn then
                    SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
                    TriggerEvent("pNotify:SendNotification",{
                        text = Config.ShowNotifyInSafeZone,
                        type = "success",
                        timeout = 3000,
                        layout = "bottomcenter",
                        queue = "global"
                    })
                    v.notifIn = true
                    v.notifOut = false
                    Citizen.CreateThread(function ()
                        while v.notifIn do
                            Citizen.Wait(7)
                            if PlayerData.job.name ~= "police" then
                                -- DrawText3D(Config.PositionX, Config.PositionY, 1.0,1.0,0.55,"Khu vực ~r~:~g~ "..(v.allowWeapon or "Chiến Đấu"), 255,255,255,255)
                                if v.allowWeapon and not Config.WeaponGroup[v.allowWeapon].all then 
                                    local hasWeapon, weaponHash = GetCurrentPedWeapon(player, 1)
                                    if hasWeapon then
                                        if not Config.WeaponGroup[v.allowWeapon][weaponHash] then 
                                            SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
                                        end
                                    end
                                end
                            end
                            if v.revive then 
                                if IsPlayerDead(PlayerId()) then 
                                    TriggerServerEvent("daokhi:update")
                                    ESX.ShowNotification("Bạn sẽ được dịch chuyển về vùng an toàn nếu không được cứu sau 30 giây.")
                                    Wait(30000)
                                    if IsPlayerDead(PlayerId()) then
                                        ESX.Game.Teleport(PlayerPedId(), {x = -258.66293334961, y = -978.29418945313, z = 31.21997833252}, function()
                                            ESX.ShowNotification("Bạn đã được dịch chuyển về vùng an toàn.")
                                            Wait(10000)
                                            ClearPedTasksImmediately(PlayerId())
                                        end)
                                    end
                                    Wait(5000)
                                end
                            end
                        end
                    end)
                end
                -- Thông Báo Chết--
                local DeathReason, Killer, DeathCauseHash, Weapon
                while true do
                    Citizen.Wait(5)
                    if IsEntityDead(PlayerPedId()) then
                        Citizen.Wait(500)
                        local PedKiller = GetPedSourceOfDeath(PlayerPedId())
                        local killername = GetPlayerName(PedKiller)
                        DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
                        Weapon = Config.WeaponNames[tostring(DeathCauseHash)]
            
                        if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
                            Killer = NetworkGetPlayerIndexFromPed(PedKiller)
                        elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
                            Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
                        end
            
                        if (Killer == PlayerId()) then
                            DeathReason = 'giết '
                        elseif (Killer == nil) then
                            DeathReason = 'died'
                        else
                            if IsMelee(DeathCauseHash) then
                                DeathReason = 'giết bằng vũ khí cận chiến'
                            elseif IsTorch(DeathCauseHash) then
                                DeathReason = 'chết cháy'
                            elseif IsKnife(DeathCauseHash) then
                                DeathReason = 'giết bằng dao'
                            elseif IsPistol(DeathCauseHash) then
                                DeathReason = 'giết bằng lục'
                            elseif IsSub(DeathCauseHash) then
                                DeathReason = 'giết bằng SMG'
                            elseif IsRifle(DeathCauseHash) then
                                DeathReason = 'giết bằng rifle'
                            elseif IsLight(DeathCauseHash) then
                                DeathReason = 'giết bằng súng máy'
                            elseif IsShotgun(DeathCauseHash) then
                                DeathReason = 'giết bằng shotgun'
                            elseif IsSniper(DeathCauseHash) then
                                DeathReason = 'giết bằng sniper'
                            elseif IsHeavy(DeathCauseHash) then
                                DeathReason = 'giết bằng súng hạng nặng'
                            elseif IsMinigun(DeathCauseHash) then
                                DeathReason = 'giết bằng 6 nòng'
                            elseif IsBomb(DeathCauseHash) then
                                DeathReason = 'giết bằng bom'
                            elseif IsVeh(DeathCauseHash) then
                                DeathReason = 'cán chết'
                            elseif IsVK(DeathCauseHash) then
                                DeathReason = 'cán chết bẹp'
                            else
                                DeathReason = 'giết'
                            end
                        end
            
                        if DeathReason == 'committed suicide' or DeathReason == 'died' then
                            TriggerServerEvent('daokhi:update',1,PlayerId(),_Killer,DeathReason,Weapon)
                        else
                            TriggerServerEvent('daokhi:update',2,PlayerId(),GetPlayerServerId(Killer),DeathReason,Weapon)
                        end
                        Killer = nil
                        DeathReason = nil
                        DeathCauseHash = nil
                        Weapon = nil
                    end
                    while IsEntityDead(PlayerPedId()) do
                        Citizen.Wait(1000)
                    end
                end
                -- tính damage nếu ngoài vòng bo --
                while playerinzone and isPlayerOutOfZone() do
                    Citizen.Wait(1000)
                    ApplyDamageToPed(player, 1.0, false)
                end
            else
                Wait(1000)
                playerinzone = false
                if not v.notifOut then
                    TriggerEvent("pNotify:SendNotification",{
                        text = Config.ShowNotifyOutSafeZone,
                        type = "error",
                        timeout = 3000,
                        layout = "bottomcenter",
                        queue = "global"
                    })
                    v.notifOut = true
                    v.notifIn = false
                end
            end    
        end
    end
end)

function hashToWeapon(hash)
	return weapons[hash]
end

function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end


---------------Safe ZONE---------------------

local currentSafezoneBlip

local currentSafezoneCoord
local currentSafezoneRadius
local targetSafezoneCoord
local targetSafezoneRadius



RegisterNetEvent('brv:setCurrentSafezone')
RegisterNetEvent('brv:setTargetSafezone') 

function ResetSafezone()
    -- body
    print('ResetSafezone')
    currentSafezoneCoord = nil
    currentSafezoneRadius = nil
    targetSafezoneCoord = nil
    targetSafezoneRadius = nil
    
end

function IsSetCurrentSafezone()
    if currentSafezoneCoord ~= nil and currentSafezoneRadius ~= nil  then
        return true
    else
        return false
    end
end


function isPlayerOutOfZone()

    local playerPos = GetEntityCoords(GetPlayerPed(PlayerId()))
    local distance = math.abs(GetDistanceBetweenCoords(playerPos.x, playerPos.y, 0, currentSafezoneCoord.x, currentSafezoneCoord.y, 0, false))
    return distance > currentSafezoneRadius
end

AddEventHandler('brv:setTargetSafezone', function(timer)

    for k,v in pairs(Config.TargetZone) do
        targetSafezoneCoord = {x=v.x, y=v.y, z=v.z}  
        targetSafezoneRadius = v.Size
        print('setTargetSafezone : ' .. tostring(targetSafezoneCoord.x) .. ' ' .. tostring(targetSafezoneCoord.y) .. ' ' .. tostring(targetSafezoneCoord.z) .. ' ' .. tostring(targetSafezoneRadius) ) 
        CreateTargetSafezoneBlip(targetSafezoneCoord, targetSafezoneRadius)
    end
end)
  
  
AddEventHandler('brv:setCurrentSafezone', function(cSafezone)
  
    for k,v in pairs(Config.Blips) do
        Citizen.Wait(1000)
        currentSafezoneCoord = {x= v.x, y= v.y, z= v.z}
        currentSafezoneRadius = v.Size
        print('setCurrentSafezone : ' .. tostring(currentSafezoneCoord.x) .. ' ' .. tostring(currentSafezoneCoord.y) .. ' ' .. tostring(currentSafezoneCoord.z) .. ' ' .. tostring(currentSafezoneRadius) )
    end
 end)
  


local IsSafezoneArriveAtTarget = true
local TargetSafezoneBlip = nil

function CreateTargetSafezoneBlip(tSafezoneCoord, tSafezoneRadius)
    TargetSafezoneBlip = SetSafeZoneBlip(TargetSafezoneBlip, tSafezoneCoord, tSafezoneRadius, 16)
    SetBlipPriority(TargetSafezoneBlip, 5)
end

--currentSafezone move to targetSafezone update
Citizen.CreateThread(function()
    local playerOOZAt = nil
    while true do
        if currentSafezoneCoord ~= nil and currentSafezoneRadius ~= nil then
            if targetSafezoneCoord ~= nil and targetSafezoneRadius ~= nil then 
                if playerOOZAt == nil then 
                    playerOOZAt = GetGameTimer() 
                end
                local deltaTime = GetTimeDifference(GetGameTimer(), playerOOZAt) -- deltaTime is ms
                playerOOZAt = GetGameTimer() 
                local isArrive = true
                if(GetDistanceBetweenCoords(currentSafezoneCoord.x, currentSafezoneCoord.y, 0, targetSafezoneCoord.x, targetSafezoneCoord.y, 0, false) > 0.1) then
                    
                    currentSafezoneCoord = coord_lerp(currentSafezoneCoord, targetSafezoneCoord, conf.safeZoneCoordMoveSpeed * ( deltaTime / 1000  ) ) -- deltaTime/1000 <- change milliSecond to second
                
                    isArrive = isArrive and false
                end
                if(math.abs( currentSafezoneRadius - targetSafezoneRadius) > 0.1) then
                    currentSafezoneRadius = math.lerp(currentSafezoneRadius, targetSafezoneRadius, conf.safeZoneRadiusMoveSpeed * ( deltaTime / 1000  ) )
                    
                    isArrive = isArrive and false
                end
                if isArrive == true then
                    RemoveBlip(TargetSafezoneBlip)
                end
            end
            currentSafezoneBlip = SetSafeZoneBlip(currentSafezoneBlip, currentSafezoneCoord, currentSafezoneRadius, 1)
            SetBlipPriority(currentSafezoneBlip, 1)
        end
        Wait(30) -- Wait 30 ms .if you want safezone move more smoothly, Chnage this 20 or 10 
    end  
end)
    

Citizen.CreateThread(function()
    while true do
        if currentSafezoneCoord ~= nil and currentSafezoneRadius ~= nil then
            DrawMarker(1, currentSafezoneCoord.x, currentSafezoneCoord.y, currentSafezoneCoord.z - 30, 0, 0, 0, 0, 0, 0, currentSafezoneRadius * 2.0, currentSafezoneRadius * 2.0, 80.0, 255, 0, 0, 200, 0, 0, 0, 0, 0, 0, 0)
        end
        Wait(0)
    end
end)

