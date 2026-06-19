vim.pack.add {
  { src = 'https://github.com/mfussenegger/nvim-dap', },
  { src = 'https://github.com/nvim-neotest/nvim-nio', },
  { src = 'https://github.com/igorlfs/nvim-dap-view', },
  { src = 'https://github.com/mfussenegger/nvim-dap-python', },
  { src = 'https://github.com/jbyuki/one-small-step-for-vimkind', },
}

local last_config = nil

local function configure_dap()
  local dap = require('dap')
  local timer_id = -1

  ---@param session dap.Session
  dap.listeners.after.event_initialized["store_config"] = function(session)
    last_config = session.config
  end

  local function restore_keymaps()
    vim.keymap.del('n', '<f4>')
    vim.keymap.del('n', '<f5>')
    vim.keymap.del('n', '<f8>')
    vim.keymap.del('n', '<f9>')
    vim.keymap.del('n', '<f10>')
    vim.keymap.del('n', '<f11>')
    vim.keymap.del('n', '<f12>')
    vim.keymap.del('n', '<down>')
    vim.keymap.del('n', '<right>')
    vim.keymap.del('n', '<left>')
  end

  local function check_restore_keymaps()
    if not next(dap.sessions()) then
      restore_keymaps()
      vim.fn.timer_stop(timer_id)
      timer_id = -1
    end
  end

  dap.listeners.after['event_initialized']['me'] = function()
    if timer_id == -1 then
      -- Set keymaps like in nvim-gdb
      vim.keymap.set('n', '<f4>', require'dap'.run_to_cursor, { silent = true })
      vim.keymap.set('n', '<f5>', require'dap'.continue, { silent = true })
      vim.keymap.set('n', '<f8>', require'dap'.set_breakpoint, { silent = true })
      vim.keymap.set('n', '<f9>', '<Cmd>DapViewHover<cr>', { silent = true })
      vim.keymap.set('n', '<f10>', require'dap'.step_over, { silent = true })
      vim.keymap.set('n', '<down>', require'dap'.step_over, { silent = true })
      vim.keymap.set('n', '<f11>', require'dap'.step_into, { silent = true })
      vim.keymap.set('n', '<right>', require'dap'.step_into, { silent = true })
      vim.keymap.set('n', '<f12>', require'dap'.step_out, { silent = true })
      vim.keymap.set('n', '<left>', require'dap'.step_out, { silent = true })

      timer_id = vim.fn.timer_start(1000, check_restore_keymaps)
    end
  end

  dap.listeners.after['event_terminated']['me'] = check_restore_keymaps
end

local configured = false

local function get(module)
  if not configured then
    configured = true

    configure_dap()
    if vim.fn.executable('gdb') == 1 then
      require('dapcfg.cpp')
    end
  end
  return require(module)
end

local function debug_last_session()
  if last_config then
    get('dap').run(last_config)
  else
    get('dap').continue()
  end
end

vim.keymap.set('n', '<leader>bb', function() get('dap').toggle_breakpoint() end, {noremap = true, silent = true, desc = 'DAP toggle breakpoint'})
vim.keymap.set('n', '<leader>bc', debug_last_session, {noremap = true, silent = true, desc = 'DAP last session'})
vim.keymap.set('n', '<leader>bC', function() get('dap').continue() end, {noremap = true, silent = true, desc = 'DAP continue'})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    get('dap-python').setup('python3')
  end,
})

vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='❓', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='📝', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='❌', texthl='', linehl='', numhl=''})
