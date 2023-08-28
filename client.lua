local ESX = exports['es_extended']:getSharedObject()
local voice = exports['pma-voice']

function getRadioDict(ped)
	return IsPedInAnyVehicle(ped, false) and 'cellphone@in_car@ds' or 'cellphone@'
end

local function removeRadioProp()
	if not radioProp then return end
	DetachEntity(radioProp, false, false)
	DeleteEntity(radioProp)
	radioProp = nil
end

local function openRadio()

    local proppi = joaat('prop_cs_hand_radio')
	radioProp = CreateObject(proppi, 0.0, 0.0, 0.0, true, true, true)
	local ped = PlayerPedId()
	AttachEntityToEntity(radioProp, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
	SetModelAsNoLongerNeeded(proppi)

	local dict = getRadioDict(ped)
	lib.requestAnimDict(dict, 100)
	TaskPlayAnim(ped, dict, 'cellphone_text_in', 4.0, -1, -1, 50, 0, false, false, false)
	RemoveAnimDict(dict)
end

local function ProppiPois()
    local ped = PlayerPedId()
    local dict = getRadioDict(ped)
    StopAnimTask(ped, dict, 'cellphone_text_in', 1.0)
    Wait(100)
    lib.requestAnimDict(dict, 100)
    TaskPlayAnim(ped, dict, 'cellphone_text_out', 7.0, -1, -1, 50, 0, false, false, false)
    Wait(200)
    StopAnimTask(ped, dict, 'cellphone_text_out', 1.0)
    RemoveAnimDict(dict)

    removeRadioProp()
end


lib.registerMenu({
    id = 'radio:menu',
    title = 'Radio',
    position = 'bottom-right',
    onClose = function()
        ProppiPois()
    end,
    options = {
        {label = 'Liity radiotaajuudelle', icon = 'fas fa-walkie-talkie', args = {'1'}},
        {label = 'Poistu radiotaajuudelta', icon = 'fas fa-walkie-talkie', args = {'2'}},
        {label = 'Säädä äänenvoimakkuutta', icon = 'fas fa-volume-high', args = {'3'}},
    }
}, function(selected, scrollIndex, args)
    if selected == 1 then
        local radiotaajuus = lib.inputDialog('Radio', {
            {type = 'number', label = 'Radiotaajuus', min = 1, max = Config.MaxFreq},
        })

        exports['pma-voice']:setVoiceProperty('radioEnabled', true)
        exports['pma-voice']:setRadioChannel(radiotaajuus[1])
        lib.notify({
            title = 'Radio',
            description = 'Liityit taajuudelle: ' .. radiotaajuus[1],
            position = 'bottom',
            type = 'success'
        })
        ProppiPois()
    elseif selected == 2 then
        exports['pma-voice']:setRadioChannel(0)
        lib.notify({
            title = 'Radio',
            description = 'Poistuit radiotaajuudelta',
            position = 'bottom',
            type = 'error'
        })
        ProppiPois()
    elseif selected == 3 then
        local volume = lib.inputDialog('Radio', {
            {type = 'number', label = 'Äänenvoimakkuus', description = 'Säädä radion äänenvoimakkuutta', icon = 'fas fa-volume-high', min = 1, max = Config.MaxVolume},
        })
        exports['pma-voice']:setRadioVolume(volume[1])
        lib.notify({
            title = 'Radio',
            description = 'Äänenvoimakkuus: ' .. volume[1],
            position = 'bottom',
            type = 'success'
        })
        ProppiPois()
    end
end)

RegisterNetEvent('radio:clientopen')
AddEventHandler('radio:clientopen', function()
    openRadio()
    lib.showMenu('radio:menu')
end)