local M = {}

function M.enable(capabilities)
	local lsp = "cssls"
	vim.lsp.config(lsp, {
		capabilities = capabilities,
		settings = {
			css = {
				validate = true,
				lint = {
					unknownAtRules = "ignore"
				}
			},
			scss = {
				validate = true,
				lint = {
					unknownAtRules = "ignore"
				}
			},
			less = {
				validate = true,
				lint = {
					unknownAtRules = "ignore"
				}
			},
		}
	})
	vim.lsp.enable(lsp)
end

return M
