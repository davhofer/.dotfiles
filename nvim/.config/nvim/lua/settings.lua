-------------------------------------------------------------
-------------------------------------------------------------
--                                                         --
--                        SETTINGS                         --
--                                                         --
-------------------------------------------------------------
-------------------------------------------------------------
vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"

-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4


-- ?????????????
vim.opt.smartindent = true

-- vim.opt.wrap = false

-- ???????????????????
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- ??????????????????
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- vim.opt.termguicolors = true

-- vim.o.mouse = 'a'

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- ???????????????????
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50



-- TODO: desired settings
-- some behavior like in other ide's
-- opening a bracket also creates closing brakcet
-- putting a selection into quotes or brackets

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
