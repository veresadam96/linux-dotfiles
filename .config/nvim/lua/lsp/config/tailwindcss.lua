local utils = require("utils")

local M = {}

-- requires `@tailwindcss/language-server` installed locally or globally
-- (npm i (-g) @tailwindcss/language-server)
function M.enable(capabilities)
	local lsp = "tailwindcss"

	local ls_path = utils.node.resolve_package("@tailwindcss/language-server")
	if not ls_path then
		return
	end

	vim.lsp.config(lsp, {
		capabilities = capabilities,
		cmd = {
			"node",
			ls_path .. "/bin/tailwindcss-language-server",
			"--stdio",
		},
	})
	vim.lsp.enable(lsp)
end

return M
