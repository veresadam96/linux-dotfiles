local dap = require('dap')
dap.configurations.java = {
	{
		type = 'java',
		request = 'attach',
		name = "Debug localhost:8000",
		hostName = "127.0.0.1",
		port = "8000"
	}
}
