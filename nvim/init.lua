-- Requirement
-- Hack Nerd Font Mono, 16, 100, 125
-- brew install ripgrep
-- pip3 install neovim-remote
-- brew install lazygit
-- brew install ltex-ls
-- brew install node
-- npm install remark
local packer = require("packer")
packer.startup(
    function(use)
    use 'wbthomason/packer.nvim'
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig", "mfussenegger/nvim-dap", "jay-babu/mason-nvim-dap.nvim" }
    use({ "hrsh7th/nvim-cmp", requires = {
        "kdheepak/cmp-latex-symbols",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "rafamadriz/friendly-snippets",
    } })
    use 'shaunsingh/nord.nvim'
    use({ "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" })
    use {'akinsho/bufferline.nvim', tag = "*", requires = "kyazdani42/nvim-web-devicons", "moll/vim-bbye"  }
    use({ "nvim-lualine/lualine.nvim", requires = "kyazdani42/nvim-web-devicons" })
    use 'arkav/lualine-lsp-progress'
    use { 'nvim-telescope/telescope.nvim', requires = { "nvim-lua/plenary.nvim" } }
    use 'windwp/nvim-autopairs'
    use 'p00f/nvim-ts-rainbow'
    use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }
    use 'lervag/vimtex'
    use({
        "kdheepak/lazygit.nvim",
        requires = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").load_extension("lazygit")
        end,
    })
    use {
        'doctorfree/cheatsheet.nvim',
        requires = {
            {'nvim-telescope/telescope.nvim'},
            {'nvim-lua/popup.nvim'},
            {'nvim-lua/plenary.nvim'},
        }
    }
    use { "LinArcX/telescope-command-palette.nvim" }
    use({'lewis6991/gitsigns.nvim'})
    use({'folke/neodev.nvim'})
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use 'karb94/neoscroll.nvim'
    use { 'otavioschwanck/cool-substitute.nvim'}
    use {'Vigemus/iron.nvim'}
end)

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
vim.o.list = false
vim.o.listchars = "space:·,tab:··"
vim.o.wildmenu = true
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.pumheight = 10
vim.o.showtabline = 2
vim.o.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.cmd[[colorscheme nord]]
vim.opt.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'sioyek'
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_syntax_conceal_disable = 1
vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
vim.g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'} -- customize lazygit popup window border characters
vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed
vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
vim.g.lazygit_config_file_path = '' -- custom config file path
vim.opt.spelllang = {'en_us', 'cjk'}
vim.cmd([[
    autocmd FileType latex,tex,md,markdown setlocal spell
    autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
    let g:vimtex_compiler_latexmk = {
        \ 'build_dir' : 'build',
        \ 'options' : [
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \   '-shell-escape'
        \ ],
    \}
    let g:vimtex_grammar_vlty = {'lt_command': 'languagetool'}
]])

require('neoscroll').setup()
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

require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "julia", "matlab", "latex", "markdown", "toml", "yaml" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>", -- set to `false` to disable one of the mappings
            node_incremental = "<CR>",
            scope_incremental = "<BS>",
            node_decremental = "<TAB>",
        },
    },
    indent = {
        enable = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
}
require("nvim-tree").setup()
require("bufferline").setup({
    options = {
        numbers = "ordinal",
        separator_style = "slant",
        close_command = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left",
            },
        },
        --[[ diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " " or (e == "warning" and " " or "󰌵")
                s = s .. n .. sym
            end
            return s
        end, ]]
    },
})
require('lualine').setup {
    options = {
        theme = 'nord',
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' }
    },
    extensions = { "nvim-tree", "toggleterm" },
    sections = {
        lualine_b = {'branch','diff'},
        -- lualine_c = {'lsp_progress'},
        lualine_c = {
            {require('cool-substitute.status').status_with_icons,
            color = function() return { fg = require('cool-substitute.status').status_color() } end}
        },
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

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "julials",
    "ltex",
    "texlab",
    "marksman",
    "prosemd_lsp",
    "remark_ls",
    "zk",
    "taplo",
    "yamlls",
    "lua_ls",
  },
})
require("lspconfig").bashls.setup {}
require("lspconfig").lua_ls.setup {}
require("lspconfig").julials.setup {}
require("lspconfig").ltex.setup {}
require("lspconfig").texlab.setup {}
require("lspconfig").marksman.setup {}
require("lspconfig").prosemd_lsp.setup {}
require("lspconfig").remark_ls.setup {}
require("lspconfig").zk.setup {}
require("lspconfig").taplo.setup {}
require("lspconfig").yamlls.setup {}


require('gitsigns').setup {
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    yadm = {
        enable = false
    },
}

local cmp = require("cmp")
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
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'treesitter' },
        { name = 'emoji' },
        { name = "latex_symbols", option = { strategy = 0, }, },
    }, { { name = 'buffer' }, { name = "path" } })
})

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
            { name = 'buffer' },
        })
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
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

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
require("luasnip").config.set_config({
    enable_autosnippets = true,
    store_selection_keys = "<Tab>",
})
require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

local dap = require('dap')

-- dap.adapters.julia = {
--     type = "executable",
--     command = "/usr/bin/julia <path/to>/DebugAdapter.jl/src/DebugAdapter.jl",
-- }

dap.configurations.julia = {
	{
		-- The first three options are required by nvim-dap
		type = "julia", -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = "launch",
		name = "Launch file",

		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

		program = "${file}", -- This configuration will launch the current file if used.
		juliaPath = function()
			-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
			-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the julia within.
			-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      return "/usr/bin/julia"
		end,
	},
}

local iron = require("iron.core")

iron.setup {
    config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
        sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = {"zsh"}
        }
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = require('iron.view').split.botright(15),
    },
    -- Iron doesn't set keymaps by default anymore.
    -- You can set them here or manually add keymaps to the functions in iron.core
    keymaps = {
        send_motion = "<space>sc",
        visual_send = "<space>sc",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_until_cursor = "<space>su",
        send_mark = "<space>sm",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
    },
    -- If the highlight is on, you can change how it looks
    -- For the available options, check nvim_set_hl
    highlight = {
        italic = true
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

require('telescope').setup({
  extensions = {
    command_palette = {
      {"File",
        { "entire selection (C-a)", ':call feedkeys("GVgg")' },
        { "save current file (C-s)", ':w' },
        { "save all files (C-A-s)", ':wa' },
        { "quit (C-q)", ':qa' },
        { "file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
        { "search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1 },
        { "git files (A-f)", ":lua require('telescope.builtin').git_files()", 1 },
        { "files (C-f)",     ":lua require('telescope.builtin').find_files()", 1 },
      },
      {"Help",
        { "tips", ":help tips" },
        { "cheatsheet", ":help index" },
        { "tutorial", ":help tutor" },
        { "summary", ":help summary" },
        { "quick reference", ":help quickref" },
        { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
      },
      {"Vim",
        { "reload vimrc", ":source $MYVIMRC" },
        { 'check health', ":checkhealth" },
        { "jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()" },
        { "commands", ":lua require('telescope.builtin').commands()" },
        { "command history", ":lua require('telescope.builtin').command_history()" },
        { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
        { "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
        { "vim options", ":lua require('telescope.builtin').vim_options()" },
        { "keymaps", ":lua require('telescope.builtin').keymaps()" },
        { "buffers", ":Telescope buffers" },
        { "search history (C-h)", ":lua require('telescope.builtin').search_history()" },
        { "paste mode", ':set paste!' },
        { 'cursor line', ':set cursorline!' },
        { 'cursor column', ':set cursorcolumn!' },
        { "spell checker", ':set spell!' },
        { "relative number", ':set relativenumber!' },
        { "search highlighting (F12)", ':set hlsearch!' },
      }
    }
  }
})
require('telescope').load_extension('command_palette')

require'cool-substitute'.setup({
  setup_keybindings = true,
  -- mappings = {
  --   start = 'gm', -- Mark word / region
  --   start_and_edit = 'gM', -- Mark word / region and also edit
  --   start_and_edit_word = 'g!M', -- Mark word / region and also edit.  Edit only full word.
  --   start_word = 'g!m', -- Mark word / region. Edit only full word
  --   apply_substitute_and_next = 'M', -- Start substitution / Go to next substitution
  --   apply_substitute_and_prev = '<C-b>', -- same as M but backwards
  --   apply_substitute_all = 'ga', -- Substitute all
  --   force_terminate_substitute = 'g!!', -- Terminate macro (if some bug happens)
  --   terminate_substitute = '<esc>', -- Terminate macro
  --   skip_substitute = 'n', -- Skip this occurrence
  --   goto_next = '<C-j>', -- Go to next occurence
  --   goto_previous = '<C-k>', -- Go to previous occurrence
  -- },
  -- reg_char = 'o', -- letter to save macro (Dont use number or uppercase here)
  -- mark_char = 't', -- mark the position at start of macro
  -- writing_substitution_color = "#ECBE7B", -- for status line
  -- applying_substitution_color = "#98be65", -- for status line
  -- edit_word_when_starting_with_substitute_key = true -- (press M to mark and edit when not executing anything anything)
})

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')

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
map("n", "<", ":vertical resize +20<CR>", opt)
map("n", ">", ":vertical resize -20<CR>", opt)
map("v", "H", "<gv", opt)
map("v", "L", ">gv", opt)
map("v", "J", ":move '>+1<CR>gv-gv", opt)
map("v", "K", ":move '<-2<CR>gv-gv", opt)

-- nvim-tree
map("n", "<C-t>", ":NvimTreeToggle<CR>", opt)
map("n", "<leader>t", ":NvimTreeToggle<CR>", opt)

-- Telescrope
map("n", "<C-p>", ":Telescope command_palette<CR>", opt)
map("n", "<C-f>", ":Telescope find_files<CR>", opt)

-- DAP
map("n","<F5>",":lua require'dap'.continue()<CR>", opt)
map("n","<F9>",":lua require'dap'.toggle_breakpoint()<CR>", opt)

-- bufferline
map("n","<leader>1", ":BufferLineGoToBuffer 1<CR>", opt)
map("n","<leader>2", ":BufferLineGoToBuffer 2<CR>", opt)
map("n","<leader>3", ":BufferLineGoToBuffer 3<CR>", opt)
map("n","<leader>4", ":BufferLineGoToBuffer 4<CR>", opt)
map("n","<leader>5", ":BufferLineGoToBuffer 5<CR>", opt)
map("n","<leader>6", ":BufferLineGoToBuffer 6<CR>", opt)
map("n","<leader>7", ":BufferLineGoToBuffer 7<CR>", opt)
map("n","<leader>8", ":BufferLineGoToBuffer 8<CR>", opt)
map("n","<leader>9", ":BufferLineGoToBuffer 9<CR>", opt)
map("n","<leader>w", ":BufferLinePickClose <CR>", opt)
map("n","<leader>h", ":BufferLineCyclePrev <CR>", opt)
map("n","<leader>l", ":BufferLineCycleNext <CR>", opt)

vim.cmd([[
    " Use Tab to expand and jump through snippets
    imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
    smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

    " Use Shift-Tab to jump backwards through snippets
    imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
    smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'

    " For changing choices in choiceNodes (not strictly necessary for a basic setup).
    imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
    smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]])

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

ls.add_snippets("tex",{
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
    s({ trig = "([\\%w%{%}]+)/", regTrig = true, wordTrig = false, snippetType="autosnippet", dscr="fraction" },
        fmta(
            "\\frac{<>}{<>}",
            { f( function(_, snip) return snip.captures[1] end ), i(1) }
        ), { condition = tex_utils.in_mathzone } ),
    s({ trig = "(%()([\\%w%{%}%s]+)(%))/", regTrig = true, wordTrig = false, snippetType="autosnippet", dscr="fraction" },
        fmta(
            "\\frac{<>}{<>}",
            { f( function(_, snip) return snip.captures[2] end ), i(1) }
        ), { condition = tex_utils.in_mathzone } ),
    s({ trig = "\\begin", snippetType="autosnippet", dscr="begin block" },
        fmta(
            [[
                \begin{<>}
                <>
                \end{<>}
            ]],
            { i(1), i(2), rep(1) }
        )),
})
ls.add_snippets("markdown",{
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
    s({ trig = "(%w+)/", regTrig = true, wordTrig = false, snippetType="autosnippet", dscr="fraction" },
        fmta(
            "\\frac{<>}{<>}",
            { f( function(_, snip) return snip.captures[1] end ), i(1) }
        ), { condition = tex_utils.in_mathzone } ),
    s({ trig = "\\begin", snippetType="autosnippet", dscr="begin block" },
        fmta(
            [[
                \begin{<>}
                <>
                \end{<>}
            ]],
            { i(1), i(2), rep(1) }
        )),
})
