local M = {}

local req = "v:lua.require('general.statusline')"

local modes = {
	["n"] = "NORMAL",
	["no"] = "NORMAL",
	["v"] = "VISUAL",
	["V"] = "V-LINE",
	[""] = "V-BLOCK",
	["s"] = "SELECT",
	["S"] = "S-LINE",
	[""] = "S-BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "REPLACE",
	["Rv"] = "V-REPLACE",
	["c"] = "COMMAND",
	["cv"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

local function format_uri(uri)
	if vim.startswith(uri, 'jdt://') then
		local package = uri:match('contents/[%a%d._-]+/([%a%d._-]+)') or ''
		local class = uri:match('contents/[%a%d._-]+/[%a%d._-]+/([%a%d$]+).class') or ''
		return string.format('%s::%s', package, class)
	else
		return vim.fn.fnamemodify(vim.uri_to_fname(uri), ':.')
	end
end

function M.mode()
	return modes[vim.api.nvim_get_mode().mode]
end

function M.file()
	return format_uri(vim.uri_from_bufnr(vim.api.nvim_get_current_buf()))
end

function M.diagnostics()
	local ret = ""
	local severities = {
		[vim.diagnostic.severity.ERROR] = "E",
		[vim.diagnostic.severity.WARN] = "W",
		[vim.diagnostic.severity.HINT] = "H",
		[vim.diagnostic.severity.INFO] = "I",
	}
	for severity, icon in pairs(severities) do
		local count = #vim.diagnostic.get(0, { severity = severity })
		if count > 0 then
			ret = ret .. icon .. ":" .. count .. " "
		end
	end
	return ret
end

vim.o.statusline="%-10.{"..req..".mode()}"
	--.."%-35.{"..req..".version_control()}"
	.."%<%{"..req..".file()} %h%w%m%r"
	--.."%<%f %h%w%m%r"
	.."%="
	.."%-20.{"..req..".diagnostics()}"
	.."%{expand(&filetype)}"
	.."%10.{&fileencoding?&fileencoding:&encoding}"
	.."%8.14(%l:%c%)"
	.."%5.5P"

return M
