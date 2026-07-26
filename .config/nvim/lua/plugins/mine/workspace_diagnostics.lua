local utils = require("utils")
require("keymaps").wsdiag_keymaps()

local function trigger_workspace_diagnostics(client, workspace_files)
	if vim.tbl_get(client.server_capabilities, 'textDocumentSync', 'openClose') then
		for _, path in ipairs(workspace_files) do
			local filetype = vim.filetype.match({ filename = path }) or ""
			if vim.tbl_contains(client.config.filetypes, filetype) then
				local params = {
					textDocument = {
						uri = vim.uri_from_fname(path),
						version = 0,
						text = vim.fn.join(vim.fn.readfile(path), "\n"),
						languageId = filetype
					}
				}
				client.notify('textDocument/didOpen', params)
			end
		end
	end
end

local function get_workspace_files()
	local workspace_files = {}
	if utils.io.does_directory_exist(".git") then
		workspace_files = vim.split(vim.fn.system("git ls-files"), "\n")
	elseif utils.io.does_directory_exist(".svn") then
		--unix
		workspace_files = vim.split(vim.fn.system("svn status -v | awk '{print $4}' | grep -E '\\..+$'"), "\n")
	else
		--unix
		workspace_files = vim.split(vim.fn.system("find . -print"), "\n")
	end
	workspace_files = utils.table.map(workspace_files, function(path) return vim.fn.fnamemodify(path, ":p") end)
	return workspace_files
end

vim.api.nvim_create_user_command("WSDiag", function()
	local workspace_files = get_workspace_files()
	local lsp_clients = vim.lsp.get_clients()
	for _, client in ipairs(lsp_clients) do
		trigger_workspace_diagnostics(client, workspace_files)
	end
end, {})
