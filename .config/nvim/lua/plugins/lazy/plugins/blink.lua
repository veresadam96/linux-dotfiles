return {
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = { "L3MON4D3/LuaSnip" },
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = { preset = "none" },
			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets" },
			},
			fuzzy = { implementation = "lua" },
			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
		config = function(_, opts)
			require("blink.cmp").setup(opts)
			require("keymaps").blink_keymaps()
		end,
	},
}
