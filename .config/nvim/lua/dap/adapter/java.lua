local dap = require('dap')
dap.adapters.java = function(callback)
	local jdtls_client = vim.lsp.get_clients({name = "jdtls"})[1]
	local method = "workspace/executeCommand"
	local params = {
		command = "vscode.java.startDebugSession"
	}
	jdtls_client:request(method, params, function(err, port)
		if err then
			print("Error starting debug session: ", err)
		else
			callback({
				type = "server",
				host = "127.0.0.1",
				port = port,
			})
		end
	end)
end
