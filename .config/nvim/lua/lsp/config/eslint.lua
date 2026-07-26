local M = {}

function M.enable(capabilities)
	local lsp = "eslint"
	vim.lsp.config(lsp, { capabilities = capabilities })
	vim.lsp.enable(lsp)
end

return M
