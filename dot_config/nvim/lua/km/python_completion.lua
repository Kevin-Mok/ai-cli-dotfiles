local M = {}

local uv = vim.uv or vim.loop

local function is_executable(path)
  return path ~= nil and path ~= '' and vim.fn.executable(path) == 1
end

local function join_path(...)
  return table.concat({ ... }, '/')
end

local function find_python(root_dir)
  local candidates = {}

  if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= '' then
    table.insert(candidates, join_path(vim.env.VIRTUAL_ENV, 'bin', 'python'))
  end

  if root_dir and root_dir ~= '' then
    for _, dirname in ipairs({ '.venv', 'venv' }) do
      table.insert(candidates, join_path(root_dir, dirname, 'bin', 'python'))
    end
  end

  table.insert(candidates, vim.fn.exepath('python3'))
  table.insert(candidates, vim.fn.exepath('python'))

  for _, candidate in ipairs(candidates) do
    if is_executable(candidate) then
      return candidate
    end
  end

  return 'python3'
end

local function buf_command(method, opts)
  if not next(vim.lsp.get_clients({ bufnr = 0 })) then
    vim.notify('No active LSP client for this buffer.', vim.log.levels.WARN)
    return
  end

  opts = opts or {}
  if opts.split then
    vim.cmd.vsplit()
  end

  method()
end

local function register_commands()
  vim.api.nvim_create_user_command('KMHover', function()
    buf_command(vim.lsp.buf.hover)
  end, {})

  vim.api.nvim_create_user_command('KMDefinitionSplit', function()
    buf_command(vim.lsp.buf.definition, { split = true })
  end, {})

  vim.api.nvim_create_user_command('KMRename', function()
    buf_command(vim.lsp.buf.rename)
  end, {})

  vim.api.nvim_create_user_command('KMCodeAction', function()
    buf_command(vim.lsp.buf.code_action)
  end, {})
end

local function setup_blink()
  local ok, blink = pcall(require, 'blink.cmp')
  if not ok then
    return nil
  end

  blink.setup({
    keymap = {
      preset = 'none',
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<Tab>'] = { 'accept', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      ['<C-y>'] = { 'accept', 'fallback' },
      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    completion = {
      menu = { auto_show = true },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 150,
      },
    },
    signature = { enabled = true },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  })

  return blink.get_lsp_capabilities()
end

local function setup_python_lsp(capabilities)
  if type(vim.lsp.config) ~= 'function' or type(vim.lsp.enable) ~= 'function' then
    return
  end

  vim.lsp.config('basedpyright', {
    capabilities = capabilities,
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    single_file_support = true,
    before_init = function(_, config)
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = find_python(config.root_dir)
    end,
    settings = {
      basedpyright = {
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticMode = 'openFilesOnly',
          typeCheckingMode = 'basic',
          useLibraryCodeForTypes = true,
        },
      },
      python = {
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
    root_dir = function(fname)
      local root_files = {
        'pyproject.toml',
        'basedpyrightconfig.json',
        'pyrightconfig.json',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        '.git',
      }
      local match = vim.fs.find(root_files, {
        upward = true,
        path = vim.fs.dirname(fname),
        stop = uv.os_homedir(),
      })[1]

      if match then
        return vim.fs.dirname(match)
      end

      return vim.fn.getcwd()
    end,
  })

  vim.lsp.enable('basedpyright')
end

function M.setup()
  if vim.g.km_python_completion_loaded == 1 then
    return
  end
  vim.g.km_python_completion_loaded = 1

  register_commands()

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end,
  })

  local capabilities = setup_blink()
  setup_python_lsp(capabilities)
end

return M
