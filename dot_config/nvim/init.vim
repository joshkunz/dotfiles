set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

lua << EOF
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'altercation/vim-colors-solarized'
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
end)

function bind_leader(key, f)
    vim.keymap.set('n', '<Leader>'..key, f)
end

telescope_builtin = require('telescope.builtin')

bind_leader('f', telescope_builtin.git_files)
bind_leader('b', telescope_builtin.buffers)
bind_leader('z', telescope_builtin.treesitter)
bind_leader('g', telescope_builtin.live_grep)
bind_leader('s', telescope_builtin.grep_string)
bind_leader('r', telescope_builtin.lsp_references)
bind_leader('i', telescope_builtin.lsp_incoming_calls)
bind_leader('o', telescope_builtin.lsp_outgoing_calls)
bind_leader('d', telescope_builtin.lsp_definitions)

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
    }
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
        cpp = { require('formatter.filetypes.cpp').clangformat },
        terraform = { require('formatter.filetypes.terraform').terraformfmt },
        fish = { require('formatter.filetypes.fish').fishindent },
        yaml = { require('formatter.filetypes.yaml').pyyaml },
        ["*"] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
        },
    },
}
EOF

source ~/.vimrc
