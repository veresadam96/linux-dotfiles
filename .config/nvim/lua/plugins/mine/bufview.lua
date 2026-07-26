local utils = require("utils")
local floating_window = require("plugins.mine.floating_window")
local pid = vim.fn.getpid()
local tmp_file = "/tmp/.nvim_" .. pid .. "_bufview"

require("keymaps").bufview_keymaps()

vim.api.nvim_create_user_command("Bufview", function()
	local buffers = utils.nvim.get_buffer_list()
	local current_buffer = vim.api.nvim_get_current_buf()
	local entries = {}
	local fzf_pos = 0
	vim.fn.system("rm -rf " .. tmp_file .. "*")
	for i, buffer in ipairs(buffers) do
		vim.fn.system("cp " .. buffer.name .. " " .. tmp_file .. buffer.number)
		local buffer_split = vim.fn.split(buffer.name, "/")
		local split_len = 0
		for _ in pairs(buffer_split) do
			split_len = split_len + 1
		end
		local filename = buffer_split[split_len]
		local readonly = buffer.readonly and ":[-]" or ""
		local modified = buffer.modified and ":[+]" or ""
		table.insert(entries, buffer.number .. ":" .. filename .. ":" .. buffer.line .. readonly .. modified)
		if current_buffer == buffer.number then
			fzf_pos = i
		end
	end
	floating_window.create_floating_window()
	local cmd =
		'echo "' .. table.concat(entries, "\n") .. '" '
		.. '| fzf '
			.. '--tac '
			.. '--bind "result:pos(-' .. fzf_pos .. ')" '
			.. '--ansi '
			.. '--delimiter : '
			.. '--preview "bat --color=always ' .. tmp_file .. '{1} --highlight-line {3}" '
			.. '--preview-window "right,50%,border-bottom,+{3}+1/3" '
			.. '--accept-nth=1 > ' .. tmp_file .. ' '
	vim.fn.jobstart(cmd, {
		term = true,
		on_exit = function(_)
			vim.cmd("bd!")
			if utils.io.does_file_exist(tmp_file) then
				local numbers = utils.io.read_file_lines(tmp_file)
				for _, number in ipairs(numbers) do
					vim.cmd("b" .. number)
					break
				end
			end
			vim.cmd("redraw!")
		end,
	})
	vim.cmd.startinsert()
end, {})
