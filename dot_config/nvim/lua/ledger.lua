-- vim-ledger settings
vim.api.nvim_create_augroup('vim_ledger', {})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = 'vim_ledger',
  pattern = {'*.ldg', '*.ledger'},
  command = 'set filetype=ledger | compiler ledger',
})

vim.api.nvim_create_autocmd('FileType', {
  group = 'vim_ledger',
  pattern = 'ledger',
  callback = function()
    -- Map { and } for navigating transactions
    vim.api.nvim_buf_set_keymap(0, 'n', '{', '?^\\d<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '}', '/^\\d<CR>', { noremap = true, silent = true })

    -- Set colorscheme for ledger files
    vim.cmd('colorscheme adwaita')

    -- Set nowrap for ledger files
    vim.opt_local.wrap = false

    -- Map <F5> to toggle transaction state
    vim.api.nvim_buf_set_keymap(
      0,
      'n',
      '<F5>',
      ':call ledger#transaction_state_toggle(line("."), "!* ")<CR>',
      { noremap = true, silent = true }
    )

    -- Map <F6> to sort ledger
    vim.api.nvim_buf_set_keymap(0, 'n', '<F6>', ':LedgerSort<CR>', { noremap = true, silent = true })
  end,
})

vim.g.ledger_is_hledger = 1
vim.g.ledger_maxwidth = 120
vim.g.ledger_fillstring = '    -'
vim.g.ledger_detailed_first = 1
vim.g.ledger_fold_blanks = 1
vim.g.ledger_date_format = '%Y-%m-%d'

-- Function to sort ledger entries
function LedgerSort()
  vim.cmd('%! hledger -f - print -c "1000.00 USD"')
  vim.cmd('%LedgerAlign')
  vim.cmd('normal Gdd')
end

-- Create command to call LedgerSort function
vim.api.nvim_create_user_command('LedgerSort', LedgerSort, {})
