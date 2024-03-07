-- Requirement
-- brew install ripgrep
-- pip3 install neovim-remote
-- brew install lazygit
-- brew install ltex-ls
-- brew install node
-- brew install textidote
-- brew install languagetool
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
    {'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' }},
    {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
    'nvim-tree/nvim-web-devicons',
    -- LSP configuration
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
    'williamboman/mason-lspconfig.nvim',
    'mfussenegger/nvim-lint',
    {"folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }},
    -- complement
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    {'L3MON4D3/LuaSnip', run = "make install_jsregexp"},
    'saadparwaiz1/cmp_luasnip',
    'kdheepak/cmp-latex-symbols',
    'windwp/nvim-autopairs',
    -- vimtex
    'lervag/vimtex',
    'micangl/cmp-vimtex',
    -- 'frabjous/knap',
    -- 'jakewvincent/texmagic.nvim',

    -- theme
    {'maxmx03/solarized.nvim', lazy = false, priority = 1000,
        config = function()
            vim.o.background = 'light'
            vim.cmd.colorscheme 'solarized'
        end},
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

    -- lualine
    {'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},
    'arkav/lualine-lsp-progress',

    {'numToStr/Comment.nvim', lazy = false,}

})

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.builtin, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "latex", "markdown_inline", "julia" },
    auto_install = true,
    highlight = {
        enable = true,
        disable = { "latex" }
    }
}

-- mason
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
-- LSP
require("mason-lspconfig").setup {
    ensure_installed = { 'ltex', 'texlab', 'marksman', 'julials', 'taplo' },
}
-- lint
require('lint').linters_by_ft = {
    markdown = { 'vale', 'alex' },
    latex = { 'vale', 'alex', 'chktex' }
}
-- cmp
local cmp = require'cmp'
local luasnip = require("luasnip")

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
            -- that way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'treesitter' },
        { name = 'emoji' },
        { name = 'vimtex' },
        { name = "latex_symbols", option = { strategy = 0, }, },
    }, { { name = 'buffer' }, { name = "path" } })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- autopairs
local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
local cond = require('nvim-autopairs.conds')
npairs.setup({
    check_ts = true,
    ts_config = {
        lua = {'string'},-- it will not add a pair on that treesitter node
        javascript = {'template_string'},
        java = false,-- don't check treesitter on java
    }
})
npairs.add_rules({
    Rule("$","$","tex"),
    Rule("$","$","markdown"),
    Rule("$$","$$","tex")
        :with_pair(cond.not_after_regex("$$")),
    Rule("$$","$$","markdwon")
        :with_pair(cond.not_after_regex("$$"))
})
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['ltex'].setup {capabilities = capabilities}
require('lspconfig')['marksman'].setup {capabilities = capabilities}
require('lspconfig')['julials'].setup {capabilities = capabilities}
require('lspconfig')['taplo'].setup {capabilities = capabilities}
vim.g.tex_flavor = 'latex'
require('lspconfig')['texlab'].setup {
    capabilities = capabilities
}

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
})
local signs = { Error = "", Warn = "", Info = "", Hint = "󰌵" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.diagnostic.config({virtual_text = false})
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("float_diagnostic_cursor", { clear = true }),
    callback = function ()
        vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
    end
})

-- lualine
require('lualine').setup {
    options = {
        -- theme = 'nord',
        theme = 'solarized_light',
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' }
    },
    -- extensions = { "nvim-tree", "toggleterm" },
    sections = {
        lualine_b = {'branch','diff'},
        lualine_c = {'lsp_progress'},
        lualine_x = {},
        lualine_y = {'diagnostics'},
    },
}
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})

require('Comment').setup({
    toggler = {line = '<C-c>'},
    opleader = {line = '<C-c>'}
})

vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.cursorline = true
vim.wo.signcolumn = "yes"
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.go.shiftround = true
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.cmdheight = 1
vim.o.autoread = true
vim.bo.autoread = true
vim.o.mouse = "a"
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.listchars = "space:·,tab:··"
vim.o.list = true
vim.o.wildmenu = true
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.pumheight = 10
vim.o.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.spelllang = {'en_us'}
vim.g.vimtex_compiler_progname = 'nvr'
vim.g.vimtex_compiler_latexmk = { aux_dir=".aux" }
vim.g.vimtex_view_method = 'sioyek'
-- vim.g.vimtex_indent_enabled = 0
vim.g.vimtex_indent_on_ampersands = 0

local highlight = {
    "CursorColumn",
    "Whitespace",
}
require("ibl").setup { indent = { char = {" "," "," "," "," "," "," "} } }

-- keymap
vim.g.mapleader = " "
vim.g.maplocalleader = "/"
local opt = {
    noremap = true,
    silent = true,
}
local map = vim.api.nvim_set_keymap
map("n", "<C-h>", "<C-w>h", opt)
map("n", "<C-j>", "<C-w>j", opt)
map("n", "<C-k>", "<C-w>k", opt)
map("n", "<C-l>", "<C-w>l", opt)
map("n", "<C-w>", ":Bdelete!<CR>", opt)
map("n", "gh", "0", opt)
map("n", "gl", "$", opt)
map("n", "ge", "G", opt)
map("n", "c", "s", opt)
map("n", "d", "x", opt)
map("n", "e", "ve", opt)
map("n", "x", "<S-v>", opt)
map("v", "y", "y<esc>", opt)
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)
map("v", "s", "<esc>/\\%V", opt)
map("x", "x", "j", opt)
-- map("n", "<C-c>", "gcc", opt)
-- map("v", "<C-c>", "gc", opt)
-- map("x", "<C-c>", "gc", opt)

-- luasnip
require("luasnip").config.set_config({
    enable_autosnippets = true,
    store_selection_keys = "<Tab>",
})
local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local has_treesitter, ts = pcall(require, 'vim.treesitter')
local _, query = pcall(require, 'vim.treesitter.query')

local tex_utils = {}

local MATH_ENVIRONMENTS = {
    displaymath = true,
    eqnarray = true,
    equation = true,
    align = true,
    math = true,
    array = true,
}
local MATH_NODES = {
    displayed_equation = true,
    inline_formula = true,
}

local function get_node_at_cursor()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_range = { cursor[1] - 1, cursor[2] }
    local buf = vim.api.nvim_get_current_buf()
    local ok, parser = pcall(ts.get_parser, buf, 'latex')
    if not ok or not parser then return end
    local root_tree = parser:parse()[1]
    local root = root_tree and root_tree:root()

    if not root then return end

    return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

function tex_utils.in_comment()
    if has_treesitter then
        local node = get_node_at_cursor()
        while node do
            if node:type() == 'comment' then
                return true
            end
            node = node:parent()
        end
        return false
    end
end

function tex_utils.in_mathzone()
    if has_treesitter then
        local buf = vim.api.nvim_get_current_buf()
        local node = get_node_at_cursor()
        while node do
            if MATH_NODES[node:type()] then
                return true
            end
            if node:type() == 'math_environment' or node:type() == "generic_environment" then
                local begin = node:child(0)
                local names = begin and begin:field('name')
                if names and names[1] and MATH_ENVIRONMENTS[vim.treesitter.get_node_text(names[1], buf):match "[A-Za-z]+"] then
                    return true
                end
            end
            node = node:parent()
        end
        return false
    end
end
tex_utils.in_text = function()
    return not tex_utils.in_mathzone()
end
tex_utils.in_env = function(name)  -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
tex_utils.in_equation = function()  -- equation environment detection
    return tex_utils.in_env('equation')
end
tex_utils.in_itemize = function()  -- itemize environment detection
    return tex_utils.in_env('itemize')
end
tex_utils.in_tikz = function()  -- TikZ picture environment detection
    return tex_utils.in_env('tikzpicture')
end
tex_utils.in_beamer = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, line in ipairs(lines) do
        if line:match("\\documentclass{beamer}") then
            return true
		    end
    end
    return false
end

ls.add_snippets("lua",{
    s({ trig = "hi", snippetType="autosnippet" },{
        t("Hello World!"),
    }),
})

local math_snippets = {
    s({ trig = "(.)__", regTrig = true, wordTrig = false, snippetType="autosnippet", dscr="auto subscript" },
        fmta(
            "<>_{<>}",
            { f( function(_, snip) return snip.captures[1] end ), i(1) }
        )),
    s({ trig = "(.)^^", regTrig = true, wordTrig = false, snippetType="autosnippet", dscr="auto superscript" },
        fmta(
            "<>^{<>}",
            { f( function(_, snip) return snip.captures[1] end ), i(1) }
        )),
    s({ trig = '//', snippetType="autosnippet", dscr="fraction" },
        fmta(
            "\\frac{<>}{<>}",
            { i(1), i(2) }
        ), { condition = tex_utils.in_mathzone } ),

    s({ trig = "%s([^%s,^%)]+)/", regTrig = true, wordTrig = false, snippetType="autosnippet", dscr="fraction" },
        fmta(
            "\\frac{<>}{<>}",
            { f( function(_, snip) return snip.captures[1] end ), i(1) }
        ), { condition = tex_utils.in_mathzone } ),
    s({ trig = "%((.*)%)/", regTrig = true, wordTrig = false, snippetType="autosnippet", dscr="fraction" },
        fmta(
            "\\frac{<>}{<>}",
            { f( function(_, snip) return snip.captures[1] end ), i(1) }
        ), { condition = tex_utils.in_mathzone } ),
    s({ trig = "\\begin", snippetType="autosnippet", dscr="begin block" },
        fmta(
            [[
                \begin{<>}
                
                \end{<>}
            ]],
            { i(1), rep(1) }
        )),
}

ls.add_snippets("tex", math_snippets)
ls.add_snippets("markdown", math_snippets)
