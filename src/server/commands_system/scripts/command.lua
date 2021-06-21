local Command = {}
Command.__index = Command

Command.new = function(opts)
	local self = {
        name = opts.name,
		access_level = opts.access_level,
        executor = opts.executor,
	}
	return setmetatable(self, Command)
end

function Command:execute(args)
	print("args", args)
	self.executor(args)
end

return Command