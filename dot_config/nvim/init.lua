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

-- Plugin management with packer.nvim
-- Ensure packer.nvim is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    })
    vim.cmd('packadd packer.nvim')
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Plugins
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Appearance plugins
  use 'Mofiqul/adwaita.nvim'            -- Adwaita theme for Neovim
  use 'junegunn/goyo.vim'               -- Distraction-free writing
  use 'ap/vim-css-color'                -- Highlight CSS colors in code

  -- Filetype-specific plugins
  use 'preservim/vim-markdown'          -- Markdown support
  use 'godlygeek/tabular'               -- Text alignment
  use 'ledger/vim-ledger'               -- Ledger file support
  use 'kirasok/cmp-hledger'             -- hledger completion  
  use 'sirjofri/vim-biblereader'        -- Bible reading plugin

  -- Utility plugins
  use 'jamessan/vim-gnupg'              -- Transparent editing of GPG files
  use 'glacambre/firenvim'              -- Embed Neovim in web pages
  use 'alx741/vinfo'                    -- Info file viewer
  use 'tpope/vim-vinegar'               -- netrw enhancement

  -- LSP and completion plugins
  use 'neovim/nvim-lspconfig'           -- Configurations for Neovim LSP
  use 'williamboman/mason.nvim'         -- Portable package manager
  use 'williamboman/mason-lspconfig.nvim' -- Mason extension for lspconfig
  use 'hrsh7th/nvim-cmp'                -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'            -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'              -- Buffer source for nvim-cmp
  use 'hrsh7th/cmp-path'                -- Path source for nvim-cmp
  use 'hrsh7th/vim-vsnip'               -- Snippet engine

  -- Treesitter for enhanced syntax highlighting
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

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
