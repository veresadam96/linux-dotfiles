local floating_window = require("plugins.mine.floating_window")

require("keymaps").floating_terminal_keymaps()

vim.api.nvim_create_user_command("FloatingTerminal", function()
	floating_window.create_floating_window({})
	vim.cmd.terminal()
	vim.cmd.startinsert()
end, {})
