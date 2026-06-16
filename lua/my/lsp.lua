
vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/folke/lazydev.nvim' },
}

require'lazydev'.setup {}

--vim.lsp.config('clangd', { cmd = { "clangd", "--enable-config", "--log=error" } })
vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')
vim.lsp.enable('pylsp')

vim.diagnostic.config { severity_sort = true, virtual_lines = { current_line = true } }


-- insert mode completion options
vim.o.autocomplete = true
vim.o.complete = "o,.,w,b,u"
vim.o.completeopt = "fuzzy,menuone,noselect,popup"
vim.o.pumheight = 7
vim.o.pummaxwidth = 80
vim.o.wildmode = 'noselect,longest,full'

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      vim.wo[0].signcolumn = 'yes'
    end
  end
})

-- Insert-mode <Tab>: completion next
vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return '<c-n>'
  else
    return '<tab>'
  end
end, { expr = true })

-- Insert-mode <Tab>: completion prev
vim.keymap.set("i", "<s-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return '<c-p>'
  else
    return '<s-tab>'
  end
end, { expr = true })

