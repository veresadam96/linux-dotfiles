local utils = require("utils")

local M = {}

local function add_plugin(plugins, name, candidates, languages, extra)
	for _, candidate in ipairs(candidates) do
		local location = utils.node.resolve_package(candidate)
		if location then
			local entry = {
				name = name,
				location = location,
				languages = languages,
			}
			for k, v in pairs(extra or {}) do
				entry[k] = v
			end
			table.insert(plugins, entry)
			return
		end
	end
end

function M.enable(capabilities)
	local lsp = "ts_ls"

	local plugins = {}
	add_plugin(plugins, "@angular/language-service",
		{ "@angular/language-service" },
		{ "typescript", "html" })
	add_plugin(plugins, "@vue/typescript-plugin", {
		"@vue/typescript-plugin",
		"@vue/language-server/node_modules/@vue/typescript-plugin",
	}, { "vue" }, { configNamespace = "typescript" })

	vim.lsp.config(lsp, {
		capabilities = capabilities,
		init_options = {
			plugins = plugins,
		},
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
			"vue",
		},
	})
	vim.lsp.enable(lsp)
end

return M
