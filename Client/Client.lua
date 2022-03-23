local PlayeBlips = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            TriggerServerEvent('Roda_BlipsCreator:GetBlips', false)
            break
        end
    end
end)


RegisterNetEvent('Roda_BlipsCreator:OpenUI')
AddEventHandler('Roda_BlipsCreator:OpenUI', function (admin)
    SetNuiFocus(true,true)
    SendNUIMessage({
        action = 'showBlip',
        admin = admin
    })
end)

RegisterNUICallback("exit" , function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'hideBlip'
    })
end)

RegisterNUICallback("delete" , function(data, cb)
    SendNUIMessage({
        action = 'deleteBlip'
    })
    TriggerServerEvent('Roda_BlipsCreator:GetBlipsToDelete', data.isadmin)
end)


RegisterNUICallback("DeleteBlip" , function(data, cb)

    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'hideBlip'
    })
    TriggerServerEvent('Roda_BlipsCreator:DeleteBlipPersonal', data.blipid)
    Wait(100)
    TriggerServerEvent('Roda_BlipsCreator:GetBlips', true)
end)

RegisterNetEvent('Roda_BlipsCreator:BlipsABorrar')
AddEventHandler('Roda_BlipsCreator:BlipsABorrar', function (datablip2)
    for i = 1, #datablip2 do 
        SendNUIMessage({
            action = 'loadBlipsToDelete',
            totalblips = datablip2[i]
        })
    end
end)




RegisterNUICallback("data" , function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('Roda_BlipsCreator:SaveBlips', data.x, data.y, data.z, data.sprite, data.color, data.name, data.admin)
    local info = {}
    info = {x = data.x, y = data.y, sprite = data.sprite, color = data.color, name = data.name}

    if data.admin == 'yes' then 
        TriggerServerEvent('Roda_BlipsCreator:UniversalBlipsRefresh', info)
    else
        makeBlip(info)
    end
end)

RegisterNUICallback("coords" , function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())
    SendNUIMessage({
        action = 'Coords',
        coords = coords
    })
end)


RegisterNetEvent('Roda_BlipsCreator:MakeBlip')
AddEventHandler('Roda_BlipsCreator:MakeBlip', function (info)
    makeBlip(info)
end)

function makeBlip(info)
    Citizen.CreateThread(function()
        info.blip = AddBlipForCoord(tonumber(info.x), tonumber(info.y), tonumber(info.z))
        SetBlipSprite(info.blip, tonumber(info.sprite))
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.9)
        SetBlipColour(info.blip, tonumber(info.color))
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.name)
        EndTextCommandSetBlipName(info.blip)
    end)
end

local oldBlips = {}
RegisterNetEvent('Roda_BlipsCreator:LoadBlips')
AddEventHandler('Roda_BlipsCreator:LoadBlips', function (blips, remove)

    Citizen.CreateThread(function()
        if remove == false then 
            for _, info in pairs(blips) do
            info.blip = AddBlipForCoord(info.x, info.y, info.z)
            SetBlipSprite(info.blip, info.sprite)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, 0.9)
            SetBlipColour(info.blip, info.color)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(info.name)
            EndTextCommandSetBlipName(info.blip)
            oldBlips = blips
            end
        else
           
            for _, info in pairs(oldBlips) do
               RemoveBlip(info.blip)
            end
            
        end
    end)
end)


local oldUniverseBlips = {}
RegisterNetEvent('Roda_BlipsCreator:LoadUniversalBlips')
AddEventHandler('Roda_BlipsCreator:LoadUniversalBlips', function (blips, remove)
    Citizen.CreateThread(function()
        if remove == false then 
            for _, info in pairs(blips) do
            info.blip = AddBlipForCoord(info.x, info.y, info.z)
            SetBlipSprite(info.blip, info.sprite)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, 0.9)
            SetBlipColour(info.blip, info.color)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(info.name)
            EndTextCommandSetBlipName(info.blip)
            oldUniverseBlips = blips
            end
        end
    end)
end)

RegisterNetEvent('Roda_BlipsCreator:ByeBye')
AddEventHandler('Roda_BlipsCreator:ByeBye', function ()
    for _, info in pairs(oldUniverseBlips) do
       RemoveBlip(info.blip)
    end
    UpdateClientBlips()
end)

function UpdateClientBlips()
    TriggerServerEvent('Roda_BlipsCreator:GetBlips', false)
end