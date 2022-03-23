RegisterServerEvent('Roda_BlipsCreator:GetBlips')
AddEventHandler('Roda_BlipsCreator:GetBlips', function (remove)
    local src = source
    RefreshBlips(src, remove)
end)

RegisterServerEvent('Roda_BlipsCreator:SaveBlips')
AddEventHandler('Roda_BlipsCreator:SaveBlips', function (x,y,z,sprite,color,name, isuniversal)
    local src = source
    local iden = GetIdentifier(src, Config.Identifier)
 
    if isuniversal == 'yes' then 
        Query(Config.Db, 'execute',
        "INSERT INTO roda_blips (`identifier`, `x`, `y`, `z`, `sprite`, `color`, `name`, `universal`) VALUES (@id, @x, @y, @z, @sprite, @color, @name, 1)",
        {['@id'] = 'Admin Blip', ['@x'] = x, ['@y'] = y, ['@z'] = z, ['@sprite'] = sprite, ['@color'] = color, ['@name'] = name})
    else
        Query(Config.Db, 'execute',
        "INSERT INTO roda_blips (`identifier`, `x`, `y`, `z`, `sprite`, `color`, `name`, `universal`) VALUES (@id, @x, @y, @z, @sprite, @color, @name, 0)",
        {['@id'] = iden, ['@x'] = x, ['@y'] = y, ['@z'] = z, ['@sprite'] = sprite, ['@color'] = color, ['@name'] = name})
    end
    
end)



RegisterServerEvent('Roda_BlipsCreator:GetBlipsToDelete')
AddEventHandler('Roda_BlipsCreator:GetBlipsToDelete', function (admin)
    local src = source
    local iden = GetIdentifier(src, Config.Identifier)
    GetBlipsToDelete(src, admin)
end)

RegisterServerEvent('Roda_BlipsCreator:DeleteBlipPersonal')
AddEventHandler('Roda_BlipsCreator:DeleteBlipPersonal', function (blipid)
    Query(Config.Db, 'execute',
        "DELETE FROM roda_blips WHERE blipid = @id",
        {['@id'] = blipid})
end)

RegisterCommand('blipcreator', function (source)
    local src = source
    if CheckIsAdmin(src) then 
        TriggerClientEvent('Roda_BlipsCreator:OpenUI', src, true)
    else
        TriggerClientEvent('Roda_BlipsCreator:OpenUI', src, false)
    end
end)


RegisterServerEvent('Roda_BlipsCreator:UniversalBlipsRefresh')
AddEventHandler('Roda_BlipsCreator:UniversalBlipsRefresh', function (info, remove)
    TriggerClientEvent('Roda_BlipsCreator:MakeBlip', -1, info)
end)