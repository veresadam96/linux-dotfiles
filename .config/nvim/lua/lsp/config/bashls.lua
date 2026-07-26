local M = {}

function M.enable(capabilities)
	local lsp = "bashls"
	vim.lsp.config(lsp, { capabilities = capabilities })
	vim.lsp.enable(lsp)
end

return M
