require("keymaps").diffview_keymaps()

local function diff_off()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.wo[win].diff and vim.bo[buf].buftype == 'nofile' then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
  vim.cmd('diffoff!')
end

local function diff_view()
  if vim.wo.diff then
    return diff_off()
  end
  local f = vim.fn.expand('%:p')
  local ft = vim.bo.filetype
  local lines = vim.fn.systemlist({ 'git', '-C', vim.fn.fnamemodify(f, ':h'),
    'show', 'HEAD:./' .. vim.fn.fnamemodify(f, ':t') })
  if vim.v.shell_error ~= 0 then
    return vim.notify('DiffHead: file not in HEAD', vim.log.levels.WARN)
  end
  vim.cmd('diffthis | vert new')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.buftype, vim.bo.bufhidden, vim.bo.filetype = 'nofile', 'wipe', ft
  vim.cmd('diffthis | wincmd p')
end

vim.api.nvim_create_user_command('Diffview', diff_view, {})
