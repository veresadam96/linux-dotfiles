require("lazy").setup({
	require("plugins.lazy.plugins.nvim-lspconfig"),
	require("plugins.lazy.plugins.blink"),
	require("plugins.lazy.plugins.luasnip"),
	require("plugins.lazy.plugins.nvim-treesitter"),
	require("plugins.lazy.plugins.nvim-dap"),
	require("plugins.lazy.plugins.nvim-jdtls"),
	require("plugins.lazy.plugins.lint"),
	require("plugins.lazy.plugins.catpuccin"),
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤",
		},
	},
})
