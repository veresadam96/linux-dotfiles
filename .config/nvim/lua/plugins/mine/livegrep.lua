local utils = require("utils")
local floating_window = require("plugins.mine.floating_window")
local tmp_file = "/tmp/.nvim_livegrep"

require("keymaps").livegrep_keymaps()

local rg_filter_map = {
	["jdtls"] = { "!target/", "!build/", "!.class", "!.settings/" },
	["angularls"] = { "!.angular/", "!dist/", "!node_modules/", "!package-lock.json", },
}

local function add_filters(filters)
	local ret = ""
	for _, filter in ipairs(filters) do
		ret = ret .. "--glob='" .. filter .. "' "
	end
	return ret
end

local function rg_filter()
	local ret =
		"--glob='!.svn' "
		.. "--glob='!.git' "
	local lsp_clients = vim.lsp.get_clients()
	local lsp_client_count = utils.table.count(lsp_clients)
	if lsp_client_count == 0 then
		for _, filters in pairs(rg_filter_map) do
			ret = ret .. add_filters(filters)
		end
	else
		for _, client in ipairs(lsp_clients) do
			local filters = rg_filter_map[client.name] or {}
			ret = ret .. add_filters(filters)
		end
	end
	return ret
end

vim.api.nvim_create_user_command("Livegrep", function()
	floating_window.create_floating_window()
	local cmd = [[
		RG_PREFIX="rg \
			--column \
			--line-number \
			--no-heading \
			--color=always \
			--smart-case \
			]] .. rg_filter() .. [[";
		AWK_PIPE="| awk -F: '{print \$1\":\"\$2\":\"\$3}'";
		IFS=: read -ra selected < <(
			FZF_DEFAULT_COMMAND="$RG_PREFIX '' $AWK_PIPE" \
			/bin/fzf \
				--ansi \
				--keep-right \
				--layout=reverse \
				--disabled \
				--bind "change:reload:sleep 0.1; $RG_PREFIX {q} $AWK_PIPE || true" \
				--delimiter : \
				--preview 'bat --wrap=never --color=always {1} --highlight-line {2}' \
				--preview-window 'right,50%,border-bottom,+{2}+1/3,~3'
		)
		if [ -n "${selected[0]}" ]; then
			echo "${selected[0]} +${selected[1]}" > ]] .. tmp_file ..  [[;
		else
			echo "" > ]] .. tmp_file .. [[;
		fi
	]]
	vim.fn.jobstart(cmd, {
		term = true,
		on_exit = function(_)
			vim.cmd("bd!")
			if utils.io.does_file_exist(tmp_file) then
				local lines = utils.io.read_file_lines(tmp_file)
				for _, line in ipairs(lines) do
					if (line:len() > 0) then
						local line_split = vim.split(line, " ")
						vim.cmd("edit " .. line_split[2] .. " " .. vim.fn.fnameescape(line_split[1]))
						break
					end
				end
			end
			vim.cmd("redraw!")
		end,
	})
	vim.cmd.startinsert()
end, {})
