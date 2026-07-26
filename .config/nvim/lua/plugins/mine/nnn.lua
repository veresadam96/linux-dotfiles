local utils = require("utils")
local floating_window = require("plugins.mine.floating_window")
local tmp_file = "/tmp/.nvim_nnn"

require("keymaps").nnn_keymaps()

vim.api.nvim_create_user_command("Nnn", function()
	local buffer_name = vim.api.nvim_buf_get_name(0)
	local start_file_name = ""
	if utils.io.does_file_exist(buffer_name) then
		start_file_name = buffer_name
	end
	floating_window.create_floating_window({})
	local cmd = '/bin/tmux new-session "/bin/nnn -doHAJu -p ' .. tmp_file .. ' ' .. start_file_name .. '"'
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
