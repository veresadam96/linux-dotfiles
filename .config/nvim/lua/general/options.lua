-- Disable errors on :wqa when terminal buffer is open
vim.cmd("command Z w | qa")
vim.cmd("cabbrev wqa Z")

-- Make help window a vertical split automatically
vim.cmd("cabbrev h vert h")

-- Nerd Font is installed
vim.g.have_nerd_font = false

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true
-- Sign column is the additional bar next to line numbers
vim.o.signcolumn = "yes"

-- Enable mouse mode
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Enable break indent -> breaks long lines with indenting to preserve blocks
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("state") .. "/undo"

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Set update time
vim.o.updatetime = 250

-- Set mapped sequence wait time in ms
vim.o.timeoutlen = 10000

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 0

-- Confirm quit on unsaved modified buffers
vim.o.confirm = true

-- Set automatic indentation of lines
vim.o.autoindent = true
-- Set tab length in characters
vim.o.tabstop = 4
-- Set indentation length in characters (e.g. when using >)
vim.o.shiftwidth = 4

vim.o.laststatus = 2

-- Options for diff mode
vim.o.diffopt = "vertical"

-- Load transparent colors after UI is fully loaded
vim.schedule(function()
	vim.cmd('colorscheme lunaperche')
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
	vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
end)
--[[ for colors
	"Normal",
	"NormalNC",
	"Comment",
	"Constant",
	"Special",
	"Identifier",
	"Statement",
	"PreProc",
	"Type",
	"Underlined",
	"Todo",
	"String",
	"Function",
	"Conditional",
	"Repeat",
	"Operator",
	"Structure",
	"LineNr",
	"NonText",
	"SignColumn",
	"CursorLine",
	"CursorLineNr",
	"StatusLine",
	"StatusLineNC",
	"EndOfBuffer",
]]
--
