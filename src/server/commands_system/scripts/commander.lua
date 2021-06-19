local Commander = {}

Commander.commands = {}

function Commander.registerCommand(commandFile)
    local command = require(commandFile)

    Commander.commands[#Commander.commands+1] = command
end

return Commander