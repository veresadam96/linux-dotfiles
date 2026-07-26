local M = {}

local function find_venv(bufnr)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	local start_path = fname ~= "" and vim.fs.dirname(fname) or vim.uv.cwd()
	return vim.fs.find(".venv", { path = start_path, upward = true, type = "directory" })[1]
end

local function start_pylsp(bufnr, capabilities)
	local cmd = { "pylsp" }
	local root_dir
	local venv = find_venv(bufnr)
	if venv then
		local exe = venv .. "/bin/pylsp"
		if vim.uv.fs_stat(exe) then
			cmd = { exe }
		end
		root_dir = vim.fs.dirname(venv)
	end
	if not root_dir then
		root_dir = vim.fs.root(bufnr, {
			"pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git",
		})
	end
	vim.lsp.start({
		name = "pylsp",
		cmd = cmd,
		root_dir = root_dir,
		capabilities = capabilities,
	}, { bufnr = bufnr })
end

function M.enable(capabilities)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "python",
		callback = function(args)
			start_pylsp(args.buf, capabilities)
		end,
	})

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype == "python" then
			start_pylsp(bufnr, capabilities)
		end
	end
end

return M
