local M = {}

local function keymap_set(mode, map, callback, opts)
	vim.keymap.set(mode, map, callback, opts)
end

function M.main_keymaps()
	-- Quit
	keymap_set("n", "<esc><esc>", ":qa!<cr>", { noremap = true })

	-- Remap macro recording
	keymap_set("n", "<bs>", "q", { noremap = true })

	-- Jump between tags
	keymap_set("n", "<c-ő>", "<c-[>", { noremap = true })
	keymap_set("n", "<c-ú>", "<c-]>", { noremap = true })

	-- Show relative line numbers
	keymap_set("n", "<c-l><c-l>", ":set invrelativenumber<cr>", { noremap = true })

	-- List and jump to active buffers
	keymap_set("n", "gb", ":ls<cr>:b", { noremap = true })

	-- Disable highlight
	keymap_set({ "n", "i", "v" }, "<c-c>", "<esc>", { silent = true })
	keymap_set({ "n", "i", "v" }, "<esc>", "<esc>:noh<cr>", { silent = true })

	-- Indentation
	keymap_set("v", "<tab>", ">gv", { noremap = true })
	keymap_set("v", "<s-tab>", "<gv", { noremap = true })
	keymap_set("i", "<s-tab>", "<esc>:<<cr>gi", { noremap = true, silent = true })

	-- Moving lines
	keymap_set("n", "<s-up>", ":m.-2<cr>==", { noremap = true })
	keymap_set("n", "<s-down>", ":m.+1<cr>==", { noremap = true })
	keymap_set("i", "<s-up>", "<esc>:m.-2<cr>==gi", { noremap = true })
	keymap_set("i", "<s-down>", "<esc>:m.+1<cr>==gi", { noremap = true })
	keymap_set("v", "<s-up>", ":m'<-2<cr>gv=gv", { noremap = true })
	keymap_set("v", "<s-down>", ":m'>+1<cr>gv=gv", { noremap = true })

	-- Selecting lines
	--    All lines
	keymap_set({ "n", "i", "v" }, "<c-a>", "<esc>gg0vG$", { noremap = true })

	-- Diagnostic
	--    Current buffer diagnostics
	keymap_set("n", "<leader>dc", function() vim.diagnostic.setloclist() end, { noremap = true })
	--    All diagnostics
	keymap_set("n", "<leader>daa", function() vim.diagnostic.setqflist() end, { noremap = true })
	keymap_set("n", "<leader>dae", function() vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR }) end, { noremap = true })
	keymap_set("n", "<leader>daw", function() vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN }) end, { noremap = true })
	--    Jump to previous diagnostic marker
	keymap_set("n", "<leader>d<up>", function() vim.diagnostic.jump({ count = -1, float = true}) end, { noremap = true })
	--    Jump to next diagnostic marker
	keymap_set("n", "<leader>d<down>", function() vim.diagnostic.jump({ count = 1, float = true }) end, { noremap = true })
	--    Open floating diagnostic window for current line
	keymap_set("n", "<leader>df", function() vim.diagnostic.open_float() end, { noremap = true })

	-- Terminal
	keymap_set("t", "<c-t>", "<c-\\><c-n>:bw!<cr>", { noremap = true, silent = true })
	keymap_set("t", "<esc><esc>", "<c-\\><c-n>")
	keymap_set("t", "<c-left>", "<c-\\><c-n><c-w>h", { silent = true })
	keymap_set("t", "<c-down>", "<c-\\><c-n><c-w>j", { silent = true })
	keymap_set("t", "<c-up>", "<c-\\><c-n><c-w>k", { silent = true })
	keymap_set("t", "<c-right>", "<c-\\><c-n><c-w>l", { silent = true })

	-- Windows
	keymap_set("n", "<c-left>", "<c-w><c-h>", { desc = "Move focus to the left window" })
	keymap_set("n", "<c-right>", "<c-w><c-l>", { desc = "Move focus to the right window" })
	keymap_set("n", "<c-down>", "<c-w><c-j>", { desc = "Move focus to the lower window" })
	keymap_set("n", "<c-up>", "<c-w><c-k>", { desc = "Move focus to the upper window" })

	-- Buffers
	keymap_set("n", "<s-q>", ":close<cr>", { noremap = true })
	keymap_set("n", "<c-q>", function()
		if not vim.bo.buflisted or vim.bo.buftype == "quickfix" then
			vim.cmd("close")
		else
			local bufs = vim.fn.getbufinfo({ buflisted = 1 })
			if #bufs > 1 then
				vim.cmd("bp | bw #")
			else
				vim.cmd("enew | bw #")
			end
		end
	end, { noremap = true })
	keymap_set("n", "<c-s>", ":w<cr>", { noremap = true })

	-- Auto pairing characters
	keymap_set("i", "{", "{}<left>", { noremap = true })
	keymap_set("i", "(", "()<left>", { noremap = true })
	keymap_set("i", "[", "[]<left>", { noremap = true })
	keymap_set("i", "<", "<><left>", { noremap = true })
	keymap_set("i", '"', '""<left>', { noremap = true })
	keymap_set("i", "'", "''<left>", { noremap = true })
	keymap_set("i", "`", "``<left>", { noremap = true })

	-- Surround visual selection with special characters
	keymap_set("v", '<leader>"', '<esc>`>a"<esc>`<i"<esc>`<lv`>f"h', { noremap = true })
	keymap_set("v", "<leader>[", "<esc>`>a]<esc>`<i[<esc>`<lv`>f]h", { noremap = true })
	keymap_set("v", "<leader>]", "<esc>`>a]<esc>`<i[<esc>`<lv`>f]h", { noremap = true })
	keymap_set("v", "<leader>'", "<esc>`>a'<esc>`<i'<esc>`<lv`>f'h", { noremap = true })
	keymap_set("v", "<leader>(", "<esc>`>a)<esc>`<i(<esc>`<lv`>f)h", { noremap = true })
	keymap_set("v", "<leader>)", "<esc>`>a)<esc>`<i(<esc>`<lv`>f)h", { noremap = true })
	keymap_set("v", "<leader>{", "<esc>`>a}<esc>`<i{<esc>`<lv`>f}h", { noremap = true })
	keymap_set("v", "<leader>}", "<esc>`>a}<esc>`<i{<esc>`<lv`>f}h", { noremap = true })
	keymap_set("v", "<leader>-", "<esc>`>a-<esc>`<i-<esc>`<lv`>f-h", { noremap = true })
	keymap_set("v", "<leader>_", "<esc>`>a_<esc>`<i_<esc>`<lv`>f_h", { noremap = true })
	keymap_set("v", "<leader>.", "<esc>`>a.<esc>`<i.<esc>`<lv`>f.h", { noremap = true })
	keymap_set("v", "<leader>*", "<esc>`>a*<esc>`<i*<esc>`<lv`>f*h", { noremap = true })
	keymap_set("v", "<leader><leader>", "<esc>`>a <esc>`<i <esc>`<lv`>f h", { noremap = true })
end

function M.floating_terminal_keymaps()
	keymap_set("n", "<c-t>", ":FloatingTerminal<cr>", { noremap = true, silent = true })
end

function M.nnn_keymaps()
	local cmd = function()
		if vim.bo.filetype == "netrw" then
			return
		end
		vim.cmd('Nnn')
	end
	keymap_set("n", "<leader>se", cmd, { noremap = true })
	keymap_set("n", "q", cmd, { noremap = true })
end

function M.netrw_keymaps()
	keymap_set("n", "<c-e>", "<esc>:Lexplore<cr>", { noremap = true })

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "netrw",
		callback = function()
			if vim.bo.filetype ~= "netrw" then
				return
			end
			local opts = { silent = true }

			vim.api.nvim_buf_set_keymap(0, "n", "t", "<nop>", opts)

			vim.keymap.set("n", "%", function ()
				local filename = vim.fn.input("New file name: ")
				vim.cmd(":silent !touch " .. filename)
			end, { buffer = 0, silent = true, noremap = true })
			vim.api.nvim_buf_set_keymap(0, "n", "n", "%", opts)

			vim.api.nvim_buf_set_keymap(0, "n", "<TAB>", "mf", opts)
			vim.api.nvim_buf_set_keymap(0, "n", "<S-TAB>", "mF", opts)
			vim.api.nvim_buf_set_keymap(0, "n", "<Leader><TAB>", "mu", opts)

			vim.api.nvim_buf_set_keymap(0, "n", "mt", "<esc>:call <SNR>37_NetrwMarkFileTgt(1)<cr>:enew<cr>:bp | bw #<cr><c-left>", opts)
		end,
	})
end

function M.fzf_keymaps()
	keymap_set("n", "<leader>sf", "<esc>:Fzf<cr>", { noremap = true })
	keymap_set("n", "<c-f>", "<esc>:Fzf<cr>", { noremap = true })
end

function M.bufview_keymaps()
	keymap_set("n", "<leader>sb", "<esc>:Bufview<cr>", { noremap = true })
	keymap_set("n", "<c-b>", "<esc>:Bufview<cr>", { noremap = true })
end

function M.bufdel_keymaps()
	keymap_set("n", "<leader>db", "<esc>:Bufdel<cr>", { noremap = true })
	keymap_set("n", "<c-d>", "<esc>:Bufdel<cr>", { noremap = true })
end

function M.livegrep_keymaps()
	keymap_set("n", "<leader>sg", "<esc>:Livegrep<cr>", { noremap = true })
	keymap_set("n", "<c-g>", "<esc>:Livegrep<cr>", { noremap = true })
end

function M.wsdiag_keymaps()
	keymap_set("n", "<leader>dw", "<esc>:WSDiag<cr>", { noremap = true })
end

function M.blink_keymaps()
	local mode_keys_to_fallbacks = {
		["i"] = {
			["<c-e>"] = function() end,
			["<up>"] = function()
				vim.cmd("norm!k")
			end,
			["<down>"] = function()
				vim.cmd("norm!j")
			end,
			["<s-tab>"] = function() end,
			["<c-tab>"] = function()
				--vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-v><tab>", true, false, true), "i", false)
			end,
		},
	}
	local mode_keys_to_commands = {
		["i"] = {
			["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<c-e>"] = { "hide" },
			["<up>"] = { "select_prev" },
			["<down>"] = { "select_next" },
			["<c-k>"] = { "scroll_documentation_up" },
			["<c-j>"] = { "scroll_documentation_down" },
			["<c-tab>"] = { "select_and_accept", "snippet_forward" },
			["<s-tab>"] = { "snippet_backward" },
			["<c-s>"] = { "show_signature", "hide_signature" },
		},
		["s"] = {
			["<c-tab>"] = { "snippet_forward" },
			["<s-tab>"] = { "snippet_backward" },
		},
	}

	for mode, mode_table in pairs(mode_keys_to_commands) do
		for key, commands in pairs(mode_table) do
			keymap_set(mode, key, function()
				for _, command in ipairs(commands) do
					local did_run = require("blink.cmp")[command]()
					if did_run then
						return
					end
				end
				mode_keys_to_fallbacks[mode][key]()
			end)
		end
	end
end

function M.lsp_keymaps(event)
	local dap = require("dap")
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	local opts = { buffer = event.buf, noremap = true }

	keymap_set("n", "<leader>cn", vim.lsp.buf.rename, opts)
	keymap_set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	keymap_set("n", "<leader>cr", vim.lsp.buf.references, opts)
	keymap_set("n", "<leader>ci", vim.lsp.buf.implementation, opts)
	keymap_set("n", "<leader>cd", vim.lsp.buf.definition, opts)
	keymap_set("n", "<leader>cD", vim.lsp.buf.declaration, opts)

	if client then
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			keymap_set("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, opts)
		end

		-- Hot code replace (for java)
		if client.name == "jdtls" then
			keymap_set("n", "<leader>hc", function()
				local session = assert(dap.session(), "No active debug session!")
				vim.notify('Applying code changes...')
				session:request('redefineClasses', nil, function(err, result)
					if err then
						vim.print(err)
					else
						local changedClasses = result.changedClasses or {}
						local errorMessage = result.errorMessage or nil
						if errorMessage then
							vim.notify("HOT CODE REPLACE FAILED: " .. errorMessage)
						else
							local classCount = 0
							for _, _ in ipairs(changedClasses) do
								classCount = classCount + 1
							end
							vim.notify(classCount .. " class(es) replaced.")
						end
					end
				end)
			end, opts)
		end
	end
end

function M.dap_keymaps()
	local dap = require("dap")
	local dapui = require("dapui")
	keymap_set("n", "<f5>", function() dap.continue() end, { noremap = true })
	keymap_set("n", "<f1>", function() dap.step_into() end, { noremap = true })
	keymap_set("n", "<f2>", function() dap.step_over() end, { noremap = true })
	keymap_set("n", "<f3>", function() dap.step_out() end, { noremap = true })
	keymap_set("n", "<leader>b", function() dap.toggle_breakpoint() end, { noremap = true })
	keymap_set("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { noremap = true })
	keymap_set("n", "<f7>", function() dapui.toggle() end, { noremap = true })
end

return M
