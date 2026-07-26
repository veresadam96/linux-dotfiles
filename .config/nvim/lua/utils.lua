local M = {}

M.nvim = {
	get_buffer_list = function()
		local buffer_list_output = vim.api.nvim_exec2("ls", { output = true }).output

		local buffers = {}
		local home = os.getenv("HOME")

		for line in buffer_list_output:gmatch("[^\r\n]+") do
			local buf_num = tonumber(line:match("^%s*(%d+)"))
			local buf_name = line:match('"(.-)"'):gsub("^~", home)
			local line_number = line:match("line%s+(%d+)")
			local bufopt = vim.bo[buf_num]
			local buf_readonly = bufopt.readonly
			local buf_modified = bufopt.modified

			if buf_num then
				table.insert(buffers, {
					number = buf_num,
					name = buf_name,
					line = line_number and tonumber(line_number) or nil,
					readonly = buf_readonly,
					modified = buf_modified,
				})
			end
		end
		return buffers
	end,

	is_buffer_empty = function(buf_num)
		if vim.api.nvim_buf_get_offset(buf_num, 0) <= 0 then
			local handle = io.open(vim.api.nvim_buf_get_name(buf_num))
			if handle ~= nil then
				local eof = handle:read(0)
				handle:close()
				return eof == nil
			end
		end
		return false
	end
}

M.io = {
	does_file_exist = function(file)
	   local ok, err, code = os.rename(file, file)
	   if not ok then
		  if code == 13 then
			 return true
		  end
	   end
	   return ok, err
	end,

	does_directory_exist = function(path)
	   return M.io.does_file_exist(path.."/")
	end,

	read_file_lines = function(path)
		local lines = {}
		for line in io.lines(path) do
			lines[#lines + 1] = line
		end
		return lines
	end,
}

M.node = {
	_global_root = nil,

	global_root = function()
		if M.node._global_root == nil then
			local out = vim.fn.system({ "npm", "root", "-g" })
			M.node._global_root = (vim.v.shell_error == 0) and vim.trim(out) or ""
		end
		if M.node._global_root == "" then
			return nil
		end
		return M.node._global_root
	end,

	resolve_package = function(name, root)
		root = root or vim.fn.getcwd()
		local local_path = root .. "/node_modules/" .. name
		if M.io.does_directory_exist(local_path) then
			return local_path
		end
		local global_root = M.node.global_root()
		if global_root then
			local global_path = global_root .. "/" .. name
			if M.io.does_directory_exist(global_path) then
				return global_path
			end
		end
		return nil
	end,
}

M.table = {
	map = function(tbl, f)
		local t = {}
		for k,v in pairs(tbl) do
			t[k] = f(v)
		end
		return t
	end,

	count = function(tbl)
		local ret = 0
		for _ in pairs(tbl) do
			ret = ret + 1
		end
		return ret
	end
}

return M
