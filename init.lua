vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.g.mapleader = ' '

vim.pack.add {
  { src = 'https://github.com/folke/tokyonight.nvim', },
  { src = 'https://github.com/ellisonleao/gruvbox.nvim', },
}

vim.o.bg = 'light'
vim.cmd('colorscheme gruvbox')

vim.pack.add{
  { src = 'https://github.com/windwp/nvim-autopairs' },
}

require'nvim-autopairs'.setup {}

vim.pack.add({ "https://github.com/sakhnik/quickterm.nvim", })

require'my.lsp'
require'my.leetcode'
require'my.dap'
