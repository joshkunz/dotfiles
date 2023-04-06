set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

lua << EOF
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- use 'altercation/vim-colors-solarized'
    use 'lifepillar/vim-solarized8'
    use 'SirVer/ultisnips'
    use { 'nvim-lualine/lualine.nvim',
          requires = {
              { 'nvim-tree/nvim-web-devicons', opt = true },
        }
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
        }
    }

    use 'neovim/nvim-lspconfig'

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    --use 'windwp/nvim-ts-autotag'

    use {
        'hrsh7th/nvim-cmp',
        requires = {
            { 'quangnguyen30192/cmp-nvim-ultisnips' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
        },
    }
    use 'kassio/neoterm'
    use 'mhartington/formatter.nvim'
    use 'j-hui/fidget.nvim'
end)


if vim.fn.has 'termguicolors' then
    vim.o.termguicolors = true
end

function leaders(m)
    for key, fun in pairs(m) do
        vim.keymap.set('n', '<Leader>'..key, fun)
    end
end

telescope_builtin = require('telescope.builtin')

leaders {
    f = telescope_builtin.git_files,
    b = telescope_builtin.buffers,
    z = telescope_builtin.treesitter,
    g = telescope_builtin.live_grep,
    s = telescope_builtin.grep_string,
    j = telescope_builtin.jumplist,
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
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, opts)
        vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, opts)
        vim.keymap.set('n', 'gi', telescope_builtin.lsp_incoming_calls, opts)
        vim.keymap.set('n', 'go', telescope_builtin.lsp_outgoing_calls, opts)
    end,
})

vim.filetype.add {
    extension = {
        hcl = 'hcl',
        tf = 'hcl',
        tfvars = 'hcl',
        tfstate = 'json',
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
nnoremap <Leader>t <Plug>(neoterm-repl-send-line)
vnoremap <Leader>t <Plug>(neoterm-repl-send)
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
        expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'buffer' },
    })

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

gopls_command = { 'gopls' }
if os.getenv("YGG_ROOT") ~= nil then
    driver_path = os.getenv("YGG_ROOT") .. '/dev/scripts/gopackagesdriver'
    gopls_command = { 'env', 'GOPACKAGESDRIVER=' .. driver_path, 'gopls' }
end

lspconfig.gopls.setup({
    cmd = gopls_command,
    capabilities = lsp_capabilities,
})

lspconfig.tsserver.setup({
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    cmd = { "typescript-language-server", "--stdio" },
    capabilities = lsp_capabilities,
})

lspconfig.r_language_server.setup({})

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
        fish = { require('formatter.filetypes.fish').fishindent },
        yaml = { require('formatter.filetypes.yaml').pyyaml },
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

vim.api.nvim_create_autocmd({'BufWritePost'}, {
    pattern = { '*' },
    callback = function()
        vim.cmd("FormatWrite")
    end,
})

require('fidget').setup({})
EOF

source ~/.vimrc
