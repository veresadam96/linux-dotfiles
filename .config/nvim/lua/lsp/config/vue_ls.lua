local utils = require("utils")

local M = {}

-- requires `@vue/language-server` on $PATH
-- (npm i (-g) @vue/language-server)
function M.enable(capabilities)
	local lsp = "vue_ls"
	local ls_path = utils.node.resolve_package("@vue/language-server")

	local cmd = {
		"node",
		ls_path .. "/bin/vue-language-server.js",
		"--stdio",
	}

	local ts_path = utils.node.resolve_package("typescript")
	if ts_path then
		table.insert(cmd, "--tsdk=" .. ts_path .. "/lib")
	end

	vim.lsp.config(lsp, {
		capabilities = capabilities,
		cmd = cmd,
	})
	vim.lsp.enable(lsp)
end

return M
