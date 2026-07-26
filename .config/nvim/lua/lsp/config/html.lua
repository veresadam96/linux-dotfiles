local M = {}

function M.enable(capabilities)
	local lsp = "html"
	vim.lsp.config(lsp, { capabilities = capabilities })
	vim.lsp.enable(lsp)
end

return M
