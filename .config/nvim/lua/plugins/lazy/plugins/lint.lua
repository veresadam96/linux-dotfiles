return {

	{ -- Linting
		'mfussenegger/nvim-lint',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			local lint = require 'lint'
			-- requires `eslint_d` and `stylelint` on $PATH (npm i -g eslint_d stylelint)
			lint.linters_by_ft = {
				markdown   = { 'markdownlint' },
				typescript = { 'eslint_d' },
				javascript = { 'eslint_d' },
				html       = { 'eslint_d' },
				css        = { 'stylelint' },
				scss       = { 'stylelint' },
			}

			local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
			vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
				group = lint_augroup,
				callback = function()
					if vim.bo.modifiable then
						lint.try_lint(nil, { ignore_errors = true })
					end
				end,
			})
		end,
	},
}
