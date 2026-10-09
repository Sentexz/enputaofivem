-- SENTEX Loader: sin Susano ni fxmanifest, preparado para TU entorno autorizado.
-- IMPORTANTE: FetchLibrary NO es una funcion estandar de Lua ni FiveM.
-- El ejecutor debe proporcionar FetchLibrary(url, callback), donde callback(status, body).
-- Puede usarse un codigo de estado HTTP 200, o true como indicador de exito.
local URL = 'https://raw.githubusercontent.com/Sentexz/enputaofivem/refs/heads/main/library.lua'

local function darFelicidad()
    -- ==============================================================
    -- INICIO: PEGA TU CODIGO PARA "DAR FELICIDAD" AQUI
    -- ==============================================================

    print('[SENTEX] Dar felicidad: accion pendiente de configurar.')

    -- ==============================================================
    -- FIN: PEGA TU CODIGO PARA "DAR FELICIDAD" AQUI
    -- ==============================================================
end

local function init(source)
    if type(source) ~= 'string' or source == '' then
        print('[SENTEX] El contenido descargado esta vacio.')
        return
    end
    local compile = ExecuteLua or load
    if type(compile) ~= 'function' then
        print('[SENTEX] Este entorno no ofrece ExecuteLua ni load().')
        return
    end
    -- ExecuteLua puede tener otra firma en tu ejecutor; ajusta este adaptador.
    local chunk, syntaxErr = compile(source, '@sentex/library.lua', 't')
    if type(chunk) ~= 'function' then
        print('[SENTEX] No se pudo compilar library.lua: ' .. tostring(syntaxErr))
        return
    end
    local ok, Library = pcall(chunk)
    if not ok or type(Library) ~= 'table' or type(Library.new) ~= 'function' then
        print('[SENTEX] library.lua incompatible: ' .. tostring(Library))
        return
    end

    local menu = Library.new({ title = 'SENTEX', toggleControl = 166 })
    local opciones = menu:addCategory('Opciones')
    menu:addAction(opciones, 'Dar felicidad', darFelicidad, 'Accion configurable por el usuario')
    local ajustes = menu:addCategory('Ajustes')
    menu:addAction(ajustes, 'Color cian', function() menu:setAccent(0, 185, 255) end)
    menu:addAction(ajustes, 'Color rojo', function() menu:setAccent(255, 65, 78) end)
    menu:addAction(ajustes, 'Color morado', function() menu:setAccent(167, 105, 255) end)
    local started, reason = menu:start()
    if not started then
        print('[SENTEX] ' .. tostring(reason))
        -- Sin CreateThread: tu ejecutor debe llamar menu:tick() cada frame.
        _G.SENTEX_MENU = menu
        return
    end
    _G.SENTEX_MENU = menu
    print('[SENTEX] Menu inicializado. F5 para abrir/cerrar.')
end

local fetch = rawget(_G, 'FetchLibrary')
if type(fetch) ~= 'function' then
    print('[SENTEX] Falta FetchLibrary(url, callback).')
    print('[SENTEX] Proporciona un adaptador HTTP en tu propio ejecutor.')
    print('[SENTEX] FiveM no garantiza HTTP desde un ejecutor cliente externo.')
else
    fetch(URL, function(status, body)
        if status ~= 200 and status ~= true then
            print('[SENTEX] Fallo al obtener GitHub Raw: ' .. tostring(status))
            return
        end
        init(body)
    end)
end
