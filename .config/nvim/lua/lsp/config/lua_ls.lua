local M = {}

function M.enable(capabilities)
	local lsp = "lua_ls"
	vim.lsp.config(lsp, {
		capabilities = capabilities,
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					disable = { "missing-fields" },
					globals = { "vim", "require" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})
	vim.lsp.enable(lsp)
end

return M
