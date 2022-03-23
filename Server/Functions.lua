function Query(plugin,type,query,var)
	local wait = promise.new()
    if type == 'fetchAll' and plugin == 'mysql' then
		MySQL.Async.fetchAll(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'mysql' then
        MySQL.Async.execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'ghmattisql' then
        exports['ghmattimysql']:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'fetchAll' and plugin == 'ghmattisql' then
        exports.ghmattimysql:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'oxmysql' then
        exports.oxmysql:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'fetchAll' and plugin == 'oxmysql' then
		exports['oxmysql']:fetch(query, var, function(result)
			wait:resolve(result)
		end)
    end
	return Citizen.Await(wait)
end


function GetIdentifier(src, tipo)
	local src = src 
	local license
	if tipo == 'steam' then 
		for k,v in ipairs(GetPlayerIdentifiers(src)) do
			if string.match(v, 'steam') then
				license = v
				return license
			end
		end
	elseif tipo == 'license' then 
		for k,v in ipairs(GetPlayerIdentifiers(src)) do
			if string.match(v, 'license') then
				license = v
				return license
			end
		end
	elseif tipo == 'discord' then 
		for k,v in ipairs(GetPlayerIdentifiers(src)) do
			if string.match(v, 'discord') then
				license = v
				return license
			end
		end
	end
end

function RefreshBlips(src, remover)
    local src = src
    local iden = GetIdentifier(src, Config.Identifier)
    local result = Query(Config.Db, 'fetchAll',
    "SELECT * FROM roda_blips WHERE identifier = @steam OR universal = 1",
    {['@steam'] = iden})

    if remover then 
        TriggerClientEvent('Roda_BlipsCreator:ByeBye', -1, result, remover)
    else 
        TriggerClientEvent('Roda_BlipsCreator:LoadUniversalBlips', src, result, remover)
    end

    
end

function GetBlipsToDelete(src, admin)
    local src = src
    local iden = GetIdentifier(src, Config.Identifier)
    local result = Query(Config.Db, 'fetchAll',
    "SELECT * FROM roda_blips WHERE identifier = @steam",
    {['@steam'] = iden})

    local result2 = Query(Config.Db, 'fetchAll',
    "SELECT * FROM roda_blips WHERE universal = 1")

    if admin == 'yes' then 
        TriggerClientEvent('Roda_BlipsCreator:BlipsABorrar', src, result2)
    else
        TriggerClientEvent('Roda_BlipsCreator:BlipsABorrar', src, result)
    end

 
end

function CheckIsAdmin(src)
    local iden = GetIdentifier(src, Config.Identifier)
    for k,v in pairs(Config.Admins) do 
        if v == iden then 
            return true
        end
    end
    return false
end
