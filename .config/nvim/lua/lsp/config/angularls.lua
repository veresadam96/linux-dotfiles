local utils = require("utils")

local M = {}

--npm i (-g) @angular/language-server@VERSION
--npm i (-g) @angular/language-service@VERSION
function M.enable(capabilities)
	local lsp = "angularls"

	local ls_path = utils.node.resolve_package("@angular/language-server")
	if not ls_path then
		return
	end

	local probe = {}
	local local_nm = vim.fn.getcwd() .. "/node_modules"
	if utils.io.does_directory_exist(local_nm) then
		table.insert(probe, local_nm)
	end
	local global_root = utils.node.global_root()
	if global_root then
		table.insert(probe, global_root)
	end
	local probe_locations = table.concat(probe, ",")

	vim.lsp.config(lsp, {
		capabilities = capabilities,
		cmd = {
			ls_path .. "/bin/ngserver",
			"--stdio",
			"--tsProbeLocations",
			probe_locations,
			"--ngProbeLocations",
			probe_locations,
		},
	})
	vim.lsp.enable(lsp)
end

return M
