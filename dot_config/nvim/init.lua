-- Prepend lazy package manager
vim.opt.runtimepath:prepend(vim.fn.stdpath('data') .. '/lazy/lazy.nvim')

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit colour
vim.opt.termguicolors = true

-- Make leader explicit
vim.g.mapleader = '\\'

require('lazy').setup({
    {
        'folke/lazydev.nvim',
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },

    'neovim/nvim-lspconfig',

    {
        'L3MON4D3/LuaSnip',
        tag = 'v2.3.0',
    },

    'nvim-tree/nvim-web-devicons',
    'nvim-lualine/lualine.nvim',
    'maxmx03/solarized.nvim',

    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = table.concat({
                    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release',
                    'cmake --build build --config Release',
                    'cmake --install build --prefix build',
                }, ' && '),
            },
        },
    },

    'nvim-treesitter/nvim-treesitter',

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-emoji' },
        },
    },

    'kassio/neoterm',
    'mhartington/formatter.nvim',
    'j-hui/fidget.nvim',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'kdheepak/tabline.nvim',
    'folke/trouble.nvim',
    'nvim-tree/nvim-tree.lua',
    'ibhagwan/fzf-lua',

    'mfussenegger/nvim-dap',
    'leoluz/nvim-dap-go',
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
    },
})

-- Pre-pend ~/.vim to search path
vim.opt.runtimepath:prepend(vim.env.HOME .. '/.vim')
-- Append ~/.vim/after to serarch path
vim.opt.runtimepath:append(vim.env.HOME .. '/.vim/after')

vim.opt.background = 'dark'
require('solarized').setup({
    highlights = function(colors)
        return {
            -- Unset some lsp specs that are better handled by treesitter or
            -- overrides.
            ['@lsp.type.variable'] = { fg = 'NONE' },
            ['@lsp.type.keyword.go'] = { fg = 'NONE' },

            -- Variables should be "normal" content quality.
            ['@variable'] = { fg = colors.base0 },
            -- pretty much everything in starlark is a param, treat them like
            -- normal variables
            ['@variable.parameter.starlark'] = { link = '@variable' },
            -- Parameters are purple.
            ['@variable.parameter'] = { link = 'Underlined' },
            ['@lsp.type.parameter'] = { link = '@variable.parameter' },
            ['@lsp.typemod.parameter.definition.go'] = { link = '@variable.parameter' },
            -- Definitions of new variables are blue.
            ['@lsp.mod.definition'] = { link = 'Identifier' },
            -- Namespaces, IDK... Still working on it.
            ['@namespace'] = { fg = colors.orange },
        }
    end,
})
vim.cmd.colorscheme('solarized')

local luasnip = require('luasnip')
require('luasnip.loaders.from_snipmate').lazy_load()
vim.keymap.set({'i', 'n'}, '<Ctrl-J>', function() luasnip.jump(1) end)
vim.keymap.set({'i', 'n'}, '<Ctrl-K>', function() luasnip.jump(-1) end)

require('fzf-lua').setup({
    files = {
        -- Disable git icons they rely on `git status` which is relatively
        -- slow.
        git_icons = false,
    },
})

require('trouble').setup {}
local trouble_telescope = require('trouble.sources.telescope')

require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
    defaults = {
        mappings = {
            i = { ['<C-t>'] = trouble_telescope.open },
            n = { ['<C-t>'] = trouble_telescope.open },
        }
    }
}

require('telescope').load_extension('fzf')

function leaders(m)
    for key, fun in pairs(m) do
        vim.keymap.set('n', '<Leader>'..key, fun)
    end
end

telescope_builtin = require('telescope.builtin')

leaders {
    jf = require('fzf-lua').git_files,
    jb = telescope_builtin.buffers,
    jz = telescope_builtin.treesitter,
    jg = telescope_builtin.live_grep,
    js = telescope_builtin.grep_string,
    jj = telescope_builtin.jumplist,
}

vim.api.nvim_create_user_command('LGLink', function(opts)
    local file = vim.fn.getreg('%')
    local line_no = vim.fn.line('.')
    local sha = vim.fn.system('git rev-parse HEAD')
    local root = vim.fn.system('git rev-parse --show-toplevel')
end, {})

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', '<cmd>TroubleToggle document_diagnostics<CR>')

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, opts)
        vim.keymap.set('n', 'gI', telescope_builtin.lsp_implementations, opts)
        vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, opts)
        vim.keymap.set('n', 'gi', telescope_builtin.lsp_incoming_calls, opts)
        vim.keymap.set('n', 'go', telescope_builtin.lsp_outgoing_calls, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    end,
})

vim.filetype.add {
    extension = {
        hcl = 'hcl',
        tf = 'hcl',
        tfvars = 'hcl',
        tfstate = 'json',
        sky = 'sky',
    },
    filename = {
        ['.terraformrc'] = 'hcl',
        ['terraform.rc'] = 'hcl',
    },
}

function begin_append_when_in_term()
    if vim.api.nvim_buf_get_option(0, 'buftype') == 'terminal' then
        vim.cmd{
            cmd = 'normal',
            bang = true,
            args = {'GA'},
        }
    end
    -- otherwise we do nothing
end

vim.cmd([[
nnoremap <Leader>T <Plug>(neoterm-repl-send-line)
vnoremap <Leader>T <Plug>(neoterm-repl-send)
nnoremap <Leader>R :Texec R<Enter>

" terminal binds
tnoremap <Esc> <C-\><C-n>
tnoremap <C-w> <C-\><C-n><C-w>
augroup TermCommands
    au!
    au WinEnter * :lua begin_append_when_in_term()
augroup END
]])

vim.g.neoterm_repl_python = ''
vim.g.neoterm_repl_r = ''

local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources(
        {
            { name = 'luasnip' },
        },
        {
            { name = 'nvim_lsp' },
        },
        {
            { name = 'buffer' },
        },
        {
            { name = 'emoji' },
        }
    ),
    mapping = cmp.mapping.preset.insert({
        ['<C-space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
})

local lsp_capabilities = {}
function ensure_lsp_capabilities(new)
    lsp_capabilities = vim.tbl_extend('keep', lsp_capabilities, new)
end
ensure_lsp_capabilities(require('cmp_nvim_lsp').default_capabilities())

lspconfig = require('lspconfig')

lspconfig.clangd.setup({
    cmd = {"clangd", "--background-index"},
    init_options = { clangdFileStatus = true },
    capabilities = lsp_capabilities,
})

lspconfig.gopls.setup({
    cmd = { 'gopls' },
    capabilities = lsp_capabilities,
    settings = {
        gopls = {
            -- Enable semantic token support in gopls
            semanticTokens = true,
        },
    },
})

lspconfig.tsserver.setup({
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    cmd = { "typescript-language-server", "--stdio" },
    capabilities = lsp_capabilities,
})

lspconfig.r_language_server.setup({})

local work_cfg_loaded, work_cfg = pcall(require, 'workcfg')
if work_cfg_loaded then
    work_cfg.setup_extra_lsp_configs(lsp_capabilities)
else
    work_cfg = nil
end

lspconfig.hls.setup({})

lspconfig.rust_analyzer.setup({})

--require('lspsaga').setup({
--    lightbulb = { enable = false },
--})

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'bash',
        'c',
        'cmake',
        'cpp',
        'css',
        'diff',
        'dockerfile',
        'dot',
        'fish',
        'gitcommit',
        'gitignore',
        'go',
        'gomod',
        'haskell',
        'hcl',
        'html',
        'http',
        'java',
        'javascript',
        'jq',
        'json',
        'json5',
        'latex',
        'lua',
        'make',
        'markdown',
        'meson',
        'ninja',
        'python',
        'r',
        'regex',
        'rust',
        'sql',
        'tsx',
        'typescript',
        'vim',
        'yaml',
    },
    autotag = {
        enable = true,
    },
    highlight = {
        enable = true,
        disable = { 'cpp' },
        additional_vim_regex_highlighting = false,
    },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true,
            goto_previous_start = {
                ['gt'] = '@function.outer',
            },
        },
    },
})

require('lualine').setup({
    options = {
        theme = 'solarized_dark',
        refresh = {
            statusline = 500
        },
    },
    sections = {
        lualine_a = {{
            'mode',
            fmt = function(str) return str:sub(1,1) end,
        }},
        lualine_b = {
            'branch',
            'diff',
            'diagnostics',
        },
    },
})

require('tabline').setup {}

local fmtutil = require('formatter.util')

require('formatter').setup {
    filetype = {
        go = { require('formatter.filetypes.go').gofmt },
        cpp = {
            function()
                return {
                    exe = "clang-format",
                    -- Pick up the location of the buffer we're modifying
                    -- so clang format can find .clang-format in parent directories
                    cwd = fmtutil.get_current_buffer_file_dir(),
                    args = {
                        "-assume-filename",
                        fmtutil.escape_path(fmtutil.get_current_buffer_file_name()),
                    },
                    stdin = true,
                }
            end,
        },
        terraform = { require('formatter.filetypes.terraform').terraformfmt },
        hcl = { require('formatter.filetypes.terraform').terraformfmt },
        fish = { require('formatter.filetypes.fish').fishindent },
        yaml = { require('formatter.filetypes.yaml').pyyaml },
        ruby = (function()
            if work_cfg then
                return { work_cfg.ruby_formatter }
            else
                return nil
            end
        end
        )(),
        bzl = {
            function()
                return {
                    exe = "buildifier",
                    cwd = fmtutil.get_current_buffer_file_dir(),
                    args = { '-path', fmtutil.get_current_buffer_file_path(), '-' },
                    stdin = true
                }
            end,
        },
        ["*"] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
        },
    },
}

leaders {
    q = function()
        vim.cmd('FormatLock')
    end,
}

vim.api.nvim_create_augroup('__formatter__', { clear = true })
vim.api.nvim_create_autocmd({'BufWritePost'}, {
    group = '__formatter__',
    callback = function()
        vim.cmd("FormatWrite")
    end,
})

require('fidget').setup({})

function nvim_tree_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    local function single_click_open()
        local node = api.tree.get_node_under_cursor()
        api.node.open.edit()
    end

    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.del('n', '<2-LeftMouse>', opts('Open'))
    vim.keymap.set('n', '<LeftRelease>', single_click_open, opts('Open'))
end

require('nvim-tree').setup({
    on_attach = nvim_tree_on_attach,
    filesystem_watchers = {
        -- This is causing issues with syncgenerated.
        enable = false,
    },
    diagnostics = {
        enable = true,
    },
})

require('dap-go').setup({})

require('dapui').setup()

leaders {
    d = require('dapui').toggle,
    dgt = require('dap-go').debug_test,
    db = require('dap').toggle_breakpoint,
    dc = require('dap').continue,
    di = require('dap').step_into,
    dn = require('dap').step_over,
}

-- Load backwards-compatible configuration
vim.cmd.source('~/.vimrc')

leaders {
    c = function()
        vim.cmd('bp | sp | bn | bd')
    end,
}
