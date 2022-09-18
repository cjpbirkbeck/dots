-- """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
-- "                                                                          "
-- " DEV.LUA                                                                  "
-- " Holds settings for any lua plugins. To be sourced only for neovim.       "
-- " This should be retricted for plugins for "advanced" task used in         "
-- " development work.                                                        "
-- "                                                                          "
-- """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

-- Defintions

local def_keymap_opts = { noremap = true, silent = true }

-- Snippets
-- Using luasnip and vim-snippets

require("luasnip.loaders.from_snipmate").lazy_load()

vim.api.nvim_set_keymap('i', '<A-j>',
    "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'<Space>",
    { silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<A-k>', "<cmd>lua require('luasnip').jump(-1)", def_keymap_opts)
vim.api.nvim_set_keymap('s', '<A-j>', "<cmd>lua require('luasnip').jump(1)", def_keymap_opts)
vim.api.nvim_set_keymap('s', '<A-k>', "<cmd>lua require('luasnip').jump(-1)", def_keymap_opts)

-- Git integrations
-- Using gitsigns

-- require('gitsigns').setup()

-- require('gitsigns').setup {
--   signs = {
--     add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
--     change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
--     delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
--     topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
--     changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
--   },
--   signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
--   numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
--   linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
--   word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
--   watch_index = {
--     interval = 1000,
--     follow_files = true
--   },
--   attach_to_untracked = true,
--   current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
--   current_line_blame_formatter_opts = {
--     relative_time = false
--   },
--   sign_priority = 6,
--   update_debounce = 100,
--   status_formatter = nil, -- Use default
--   max_file_length = 40000,
--   preview_config = {
--     -- Options passed to nvim_open_win
--     border = 'single',
--     style = 'minimal',
--     relative = 'cursor',
--     row = 0,
--     col = 1
--   },
--   yadm = {
--     enable = false
--   },
-- }

-- Completion
-- Using nvim-cmp. Note this is used mostly as an advanced omnifunction.

local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_exand(args.body)
        end,
    },
    source = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'spell' },
        { name = 'cmp-tmux' },
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    completion = {
        autocomplete = false, -- disable auto-completion.
    },
}

-- Create a subssitute omni-function.
_G.vimrc = _G.vimrc or {}
_G.vimrc.cmp = _G.vimrc.cmp or {}
_G.vimrc.cmp.lsp = function()
  cmp.complete({
    config = {
      sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' },
        { name = 'spell' },
        { name = 'cmp-tmux' },
      }
    }
  })
end

vim.api.nvim_set_keymap('i', '<C-x><C-o>', '<Cmd>lua vimrc.cmp.lsp()<CR>', def_keymap_opts)

-- Incremental Parsing
-- Using the experimental treesitter features.

require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    -- Select text based on treesitter nodes.
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gzz",
            node_incremental = "gzj",
            node_decremental = "gzk",
            scope_incremental = "gzc",
        },
    },
    -- Experimental
    indent = {
        enable = false,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ad"] = "@conditional.outer",
                ["id"] = "@conditional.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
            },
        },
    },
}

-- Language Server Protcol
-- Using nvim's native LSP feature.

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- vim-go handles gopls
local servers = { "rnix", "pylsp" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
