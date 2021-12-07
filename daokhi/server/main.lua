ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)


RegisterServerEvent("daokhi:update")
AddEventHandler("daokhi:update", function(id, player, killer, DeathReason, Weapon)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local yPlayer = ESX.GetPlayerFromId(killer)
    if Weapon then _Weapon = ""..Weapon.."" else _Weapon = "" end
    if DeathReason then _DeathReason = "`"..DeathReason.."`" else _DeathReason = " chết " end
    if id == 1 then
        TriggerClientEvent('chat:addMessage', -1, { args = { "Đảo Khỉ","Người chơi "..xPlayer.name.. " đã chết bởi ".._DeathReason}, color = {249, 166, 0}})
    elseif id == 2 then
        TriggerClientEvent('chat:addMessage', -1, { args = { "Đảo Khỉ","Người chơi "..yPlayer.name.. " đã giết người chơi "..xPlayer.name.." bởi"}, color = {249, 166, 0}})
    end
end)

RegisterCommand('batdau', function(source)
    if (source > 0) then
        TriggerClientEvent('brv:setCurrentSafezone', -1)
        TriggerClientEvent("lr_occ:client:notify", -1, "warning", ("Sự Kiện Dảo Khỉ Chính Thức Bắt Dầu"))
    end
end, true)

RegisterCommand('tieptheo', function(source)

    if (source > 0) then
        timer = 600000
        TriggerClientEvent('brv:setTargetSafezone', -1, timer)
        TriggerClientEvent("lr_occ:client:notify", -1, "warning", ("Vòng Bo bắt dầu thu hẹp, người chơi di chuyển vào tâm bo"))
    end
end, true)