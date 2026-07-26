local utils = require("utils")
local floating_window = require("plugins.mine.floating_window")
local tmp_file = "/tmp/.nvim_fzf"

require("keymaps").fzf_keymaps()

local fzf_filter_map = {
	["jdtls"] = "!target/ !build/ !bin/ !dist/ !gradle/ !.class !.settings/ !.gradle/",
	["angularls"] = "!.angular/ !dist/ !node_modules/",
}

local function fzf_query()
	local ret = "!.svn !.git "
	local lsp_clients = vim.lsp.get_clients()
	local lsp_client_count = utils.table.count(lsp_clients)
	if lsp_client_count == 0 then
		for _, filter in pairs(fzf_filter_map) do
			ret = ret .. filter .. " "
		end
	else
		for _, client in ipairs(lsp_clients) do
			local filter = fzf_filter_map[client.name] or ""
			ret = ret .. filter .. " "
		end
	end
	return ret
end

vim.api.nvim_create_user_command("Fzf", function()
	floating_window.create_floating_window()
	local cmd = [[
		/bin/fzf \
			-i \
			-m \
			--keep-right \
			--query=']] .. fzf_query() .. [[' \
			--layout=reverse \
			--preview 'cat {}' > ]] .. tmp_file
	vim.fn.jobstart(cmd, {
		term = true,
		on_exit = function(_)
			vim.cmd("bd!")
			if utils.io.does_file_exist(tmp_file) then
				local names = utils.io.read_file_lines(tmp_file)
				for i, name in ipairs(names) do
					local vim_cmd = i == 1 and "edit " or "argadd "
					vim.cmd(vim_cmd .. vim.fn.fnameescape(name))
				end
			end
			vim.cmd("redraw!")
		end,
	})
	vim.cmd.startinsert()
end, {})
