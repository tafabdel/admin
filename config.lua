Config = {}



-- General settings
Config.OpenKey = 'F5' -- Key to open the admin menu
Config.CloseKey = 'ESC' -- Key to close the admin menu

-- Permission levels
Config.PermissionLevels = {
    ['admin'] = 0,
    ['god'] = 1,
    ['developer'] = 2
}

-- Admin menu options
Config.Options = {
    ['kill'] = {label = 'Kill Player', permission = 'admin'},
    ['revive'] = {label = 'Revive Player', permission = 'admin'},
    ['freeze'] = {label = 'Freeze Player', permission = 'admin'},
    ['spectate'] = {label = 'Spectate Player', permission = 'admin'},
    ['teleport'] = {label = 'Teleport to Player', permission = 'admin'},
    ['giveitem'] = {label = 'Give Item', permission = 'god'},
    ['ban'] = {label = 'Ban Player', permission = 'admin'},
    ['kick'] = {label = 'Kick Player', permission = 'admin'},
    ['setjob'] = {label = 'Set Job', permission = 'god'},
    ['noclip'] = {label = 'Toggle Noclip', permission = 'admin'},
    ['godmode'] = {label = 'Toggle God Mode', permission = 'god'},
    ['spawnvehicle'] = {label = 'Spawn Vehicle', permission = 'admin'},
    ['fixvehicle'] = {label = 'Fix Vehicle', permission = 'admin'},
    ['deletevehicle'] = {label = 'Delete Vehicle', permission = 'admin'},
    ['setweather'] = {label = 'Set Weather', permission = 'god'},
    ['settime'] = {label = 'Set Time', permission = 'god'},
    ['announce'] = {label = 'Make Announcement', permission = 'admin'},
}

-- Weather options
Config.WeatherOptions = {'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'RAIN', 'THUNDER', 'SNOW', 'BLIZZARD', 'FOGGY', 'SMOG', 'XMAS'}

-- Time options
Config.TimeOptions = {
    {hour = 0, minute = 0, label = 'Midnight'},
    {hour = 6, minute = 0, label = 'Dawn'},
    {hour = 12, minute = 0, label = 'Noon'},
    {hour = 18, minute = 0, label = 'Dusk'},
    {hour = 22, minute = 0, label = 'Night'}
}

-- Max values
Config.MaxSpeedBoost = 10.0
Config.MaxHealth = 200
Config.MaxArmor = 100

return Config

