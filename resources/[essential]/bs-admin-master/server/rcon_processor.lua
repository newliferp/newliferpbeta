AddEventHandler('rconCommand',
  function(commandName, args)
    if commandName:lower() == 'annonce' then
      announce(args)
      CancelEvent()
    end
    if commandName:lower() == 'kick' then
      kick(args)
      CancelEvent()
    end
    if commandName:lower() == 'ban' then
      ban(args)
      CancelEvent()
    end
    if commandName:lower() == 'freeze' then
      freeze(args)
      CancelEvent()
    end
    if commandName:lower() == 'unfreeze' then
      unfreeze(args)
      CancelEvent()
    end
    if commandName:lower() == 'slap' then
      slap(args)
      CancelEvent()
    end
    if commandName:lower() == 'slay' then
      slay(args)
      CancelEvent()
    end
  end
)

function announce(args)
  TriggerClientEvent('chatMessage', -1, 'ANNONCE', {255, 0, 0}, table.concat(args, ' '))
end

function kick(args)
  local reason = args
  table.remove(reason, 1)

  if (#reason == 0) then
    reason = 'Kick: Vous avez été kick du serveur'
  else
    reason = 'Kick: ' .. table.concat(reason, ' ')
  end

  local targetId = tonumber(args[1])

  adminMessage(-1, 'Le joueur ' .. GetPlayerName(targetId) .. ' a été kick pour (' .. reason .. ')')
  RconPrint('Le joueur ' .. GetPlayerName(targetId) .. ' a été kick pour (' .. reason .. ')')
  DropPlayer(targetId, reason)
end

function ban(args)
  local reason = args
  local targetId = tonumber(args[1])
  local playerName = GetPlayerName(targetId)
  local timeArg = args[2]

  local banEpoch = tonumber(tostring(os.time()))
  local timeUnit = timeArg:sub(-1):lower()
  local timeMultiplier = tonumber(timeArg:sub(1, -2))

  if timeUnit == 'h' then
    local additionalSeconds = timeMultiplier * 60 * 60
    banEpoch = banEpoch + additionalSeconds
  elseif timeUnit == 'd' then
    local additionalSeconds = timeMultiplier * 24 * 60 * 60
    banEpoch = banEpoch + additionalSeconds
  else
    RconPrint('Temps invalide.  /ban 24h raison')
  end

  table.remove(reason, 1)
  table.remove(reason, 1)

  if (#reason == 0) then
    reason = 'Banni: Vous avez été banni du serveur'
  else
    reason = 'Banni: ' .. table.concat(reason, ' ')
  end

  addBan(targetId, banEpoch, reason)

  adminMessage(-1, 'Le joueur ' .. playerName .. ' a été banni (' .. reason .. ')')
  RconPrint('Le joueur ' .. playerName .. ' a été banni (' .. reason .. ')')

  DropPlayer(targetId, reason)
end

function freeze(args)
  local targetId = tonumber(args[1])

  TriggerClientEvent('bs-admin:freezePlayer', targetId)

  adminMessage(targetId, 'Vous avez été freeze par RCON.')
  RconPrint('Vous avez freeze '..GetPlayerName(targetId))
end

function unfreeze(args)
  local targetId = tonumber(args[1])

  TriggerClientEvent('bs-admin:unfreezePlayer', targetId)

  adminMessage(targetId, 'Vous avez été unfreeze RCON.')
  RconPrint('Vous avez unfreeze '..GetPlayerName(targetId))
end

function slap(args)
  local targetId = tonumber(args[1])

  TriggerClientEvent('bs-admin:slap', targetId)

  adminMessage(targetId, 'Vous avez été slap par RCON.')
  RconPrint('Le joueur ' .. GetPlayerName(targetId) .. ' a été slap')
end

function slay(args)
  local targetId = tonumber(args[1])

  TriggerClientEvent('bs-admin:kill', targetId)

  adminMessage(targetId, 'Vous avez été tué par RCON.')
  RconPrint('Le joueur ' .. GetPlayerName(targetId) .. ' a été tué.')
end
