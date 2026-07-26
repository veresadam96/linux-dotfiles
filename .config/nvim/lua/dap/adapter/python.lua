local dap = require('dap')
dap.adapters.python = function(callback, config)
	if config.request == 'attach' then
		---@diagnostic disable-next-line: undefined-field
		local port = (config.connect or config).port
		---@diagnostic disable-next-line: undefined-field
		local host = (config.connect or config).host or '127.0.0.1'
		callback({
			type = 'server',
			port = assert(port, '`connect.port` is required for an `attach` configuration'),
			host = host,
			options = {
				source_filetype = 'python',
			},
		})
	else
		callback({
			type = 'executable',
			command = '/bin/python',
			args = {
				'-m', 'debugpy.adapter'
			},
			options = {
				source_filetype = 'python',
			},
		})
	end
end
