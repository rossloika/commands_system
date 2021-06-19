local Command = {}
Command.__index = Command

Command.new = function(name, executor)
	local self = {
        name = name,
        executor = executor,
	}
	return setmetatable(self, Command)
end

function Command:execute(args)
	print("args", args)
	self.executor(args)
end

return Command