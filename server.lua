local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterUsableItem('radio', function(source)
  TriggerClientEvent('radio:clientopen', source)
end)
