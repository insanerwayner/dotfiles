-- init.lua

-- Basic settings
vim.opt.number = true                     -- Show line numbers
vim.opt.relativenumber = true             -- Show relative line numbers
vim.opt.tabstop = 8                       -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 0                   -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt.shiftwidth = 4                    -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true                  -- Use spaces instead of tabs
vim.opt.autoindent = true                 -- Copy indent from current line when starting a new line
vim.opt.modeline = false                  -- Disable modelines for security
vim.opt.wrap = false                      -- No Wrap long lines
vim.opt.linebreak = true                  -- Wrap lines at convenient points
vim.opt.list = false                      -- Disable 'list' to prevent 'linebreak' issues
-- vim.cmd('syntax off')                      -- Enable syntax highlighting
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- included configs
require('ledger')

-- Netrw settings
vim.g.netrw_fastbrowse = 0
vim.g.netrw_banner = 1
vim.g.netrw_liststyle = 1
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 15

-- Close Netrw buffer when leaving it
 vim.api.nvim_create_augroup('NetrwCloseOnSelect', {})
 vim.api.nvim_create_autocmd('BufLeave', {
   group = 'NetrwCloseOnSelect',
   pattern = '*',
   callback = function()
     if vim.bo.filetype == 'netrw' then
       vim.cmd('silent! bwipeout')
     end
   end,
 })

-- Man page settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'man',
  command = 'colorscheme adwaita',
})

-- init.lua (excerpt)

-- 1) Make sure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- If lazy.nvim not found, clone it
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2) Set up your plugin list as a Lua table
require("lazy").setup({
  -- Appearance plugins
  {
    "Mofiqul/adwaita.nvim",
    -- If you have config for these plugins, you can
    -- add it in a config function here.
    -- config = function()
    --   vim.cmd("colorscheme adwaita")
    -- end
  },
  { "junegunn/goyo.vim" },
  { "ap/vim-css-color" },

  -- Filetype-specific plugins
  { "preservim/vim-markdown" },
  { "godlygeek/tabular" },
  { "ledger/vim-ledger" },
  { "kirasok/cmp-hledger" },
  { "sirjofri/vim-biblereader" },

  -- Utility plugins
  { "jamessan/vim-gnupg" },
  { "glacambre/firenvim", run = function() vim.fn["firenvim#install"](0) end },
  { "alx741/vinfo" },
  { "tpope/vim-vinegar" },

  -- LSP and completion plugins
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/vim-vsnip" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
  },
}, {})


-- Mason and LSP configurations
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'bashls', 'pyright', 'yamlls', 'jsonls', 'dockerls' },
})

local lspconfig = require('lspconfig')

-- Automatically set up servers installed via Mason
require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({})
  end,
})

-- Autocompletion configuration
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'hledger'},
  },
})

-- Treesitter configuration
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash',
    'lua',
    'python',
    'yaml',
    'json',
    'toml',
    'markdown',
    'dockerfile',
    'nix',
    'powershell',
    -- Add other languages you use
  },
  highlight = {
    enable = true,
    disable = { 'ledger' },
    additional_vim_regex_highlighting = false,
  },
})
