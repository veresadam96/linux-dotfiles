local M = {}

function M.create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.9)
	local height = opts.height or math.floor(vim.o.lines * 0.9)

	local col = opts.column or math.floor((vim.o.columns - width) / 2)
	local row = opts.row or math.floor((vim.o.lines - height) / 2)

	local buf = vim.api.nvim_create_buf(true, false)
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		border = "rounded"
	}
	local win = vim.api.nvim_open_win(buf, true, win_config)
	return { buf = buf, win = win }
end

return M
