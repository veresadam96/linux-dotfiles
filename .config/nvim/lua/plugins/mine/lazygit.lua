local floating_window = require("plugins.mine.floating_window")

require("keymaps").lazygit_keymaps()

local state = {
	job = nil,
	prev_win = nil,
	pending = nil,
}

local function open_pending()
	local pending = state.pending
	state.pending = nil
	if not pending then
		return
	end
	if state.prev_win and vim.api.nvim_win_is_valid(state.prev_win) then
		vim.api.nvim_set_current_win(state.prev_win)
	end
	local line = pending.line and ("+" .. pending.line .. " ") or ""
	vim.cmd("edit " .. line .. vim.fn.fnameescape(pending.file))
	-- Diffview toggles, so close an already open diff first
	if vim.wo.diff then
		vim.cmd("Diffview")
	end
	vim.cmd("Diffview")
end

function _G.LazygitOpen(file, line)
	vim.schedule(function()
		state.pending = { file = file, line = tonumber(line) }
		if state.job then
			vim.fn.jobstop(state.job)
		else
			open_pending()
		end
	end)
	return ""
end

vim.api.nvim_create_user_command("Lazygit", function()
	if state.job then
		return
	end
	state.prev_win = vim.api.nvim_get_current_win()
	local float = floating_window.create_floating_window()
	state.job = vim.fn.jobstart("lazygit", {
		term = true,
		on_exit = function(_)
			state.job = nil
			if vim.api.nvim_buf_is_valid(float.buf) then
				vim.api.nvim_buf_delete(float.buf, { force = true })
			end
			if vim.api.nvim_win_is_valid(float.win) then
				vim.api.nvim_win_close(float.win, true)
			end
			open_pending()
			vim.cmd("redraw!")
		end,
	})
	vim.cmd.startinsert()
end, {})
