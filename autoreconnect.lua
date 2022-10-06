script_name('Auto-Reconnect')
script_author('Rmly')
script_version('1.0')

local sampev = require 'samp.events'
local glob = require "lib.game.globals"
local prefix = "{0ed2e8}[AUTO-RECONNECT]:{b9bcbd}"
local reconnectName
local ip, port

function main()
    repeat
        wait(100)
    until isSampAvailable()
    local ts = thisScript()

    -- storing some information which we can use later on
    reconnectName = sampGetPlayerNickname(getPlayerId())
    ip, port = sampGetCurrentServerAddress()

    sampAddChatMessage(string.format('%s %s v%s {b9bcbd}by {0ed2e8}%s {b9bcbd}', prefix, ts.name, ts.version,
        table.concat(ts.authors)))
    sampAddChatMessage(string.format('%s Nickname: {0ed2e8}%s', prefix, reconnectName))
end

function getPlayerId()
    local result, ped = getPlayerChar(getGameGlobal(glob.PLAYER_CHAR))
    local result, playerid = sampGetPlayerIdByCharHandle(ped)

    return playerid
end

function reconnect()
    lua_thread.create(function()
        sampAddChatMessage(string.format("%s Reconnecting in 5s...", prefix))
        wait(5000)
        sampAddChatMessage(string.format("%s Reconnecting now with the name {0ed2e8}%s", prefix, reconnectName))
        sampSetLocalPlayerName(reconnectName)
        sampConnectToServer(ip, port)
    end)
end

-- listening for some events

function sampev.onConnectionClosed()
    reconnect()
end

function sampev.onConnectionPasswordInvalid()
    reconnect()
end

function sampev.onConnectionAttemptFailed()
    reconnect()
end

function sampev.onConnectionLost()
    reconnect()
end

function sampev.onConnectionBanned()
    reconnect()
end
