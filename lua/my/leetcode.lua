vim.pack.add {
  { src = 'https://github.com/kawre/leetcode.nvim', },
  { src = 'https://github.com/nvim-mini/mini.pick', },
  { src = 'https://github.com/nvim-mini/mini.icons', },
  { src = 'https://github.com/nvim-lua/plenary.nvim', },
  { src = 'https://github.com/MunifTanjim/nui.nvim', },
}

require'mini.pick'.setup {}

require'leetcode'.setup {
  lang = vim.env.LEET_LANG and vim.env.LEET_LANG or 'cpp',
  picker = { provider = 'mini-picker', },
  storage = { home = vim.env.HOME .. '/.leetcode', },
}

