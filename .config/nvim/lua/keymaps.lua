-- general keymaps
-- vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy (yank) to system clipboard" })
-- vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy (yank) to system clipboard" })

-- vim window navigation
vim.keymap.set("n", "<C-w>j", "<C-w><C-j>", { desc = "Move focus to buffer/window below." })
vim.keymap.set("n", "<C-w>k", "<C-w><C-k>", { desc = "Move focus to buffer/window above." })
vim.keymap.set("n", "<C-w>h", "<C-w><C-h>", { desc = "Move focus to left buffer/window." })
vim.keymap.set("n", "<C-w>l", "<C-w><C-l>", { desc = "Move focus to right buffer/window." })

-- buffer navigation
vim.keymap.set("n", "<leader>bb", "<C-6>", { desc = "Go back to previously opened buffer." })

-- TODO: use a plugin for this
-- vim.keymap.set("i", "(", "()<esc>i", { desc = "Always create opening and closing parentheses" })
-- vim.keymap.set("i", "{", "{}<esc>i", { desc = "Always create opening and closing parentheses" })
-- vim.keymap.set("i", "[", "[]<esc>i", { desc = "Always create opening and closing parentheses" })

vim.keymap.set("n", "<leader>v", "lbve", { desc = "Select the word under the cursor" })

-- neo-tree keymaps
vim.keymap.set("n", "<leader>nn", function()
    -- Clean up null-ls temp files in current file's directory
    local current_dir = vim.fn.expand("%:p:h")
    local temp_files = vim.fn.glob(current_dir .. "/.null-ls_*", false, true)
    for _, file in ipairs(temp_files) do
        vim.fn.delete(file)
    end
    -- Open file explorer
    vim.cmd("Neotree filesystem left reveal")
end, { desc = "Open file explorer (and cleanup temp files)" })
vim.keymap.set("n", "<leader>nc", ":Neotree filesystem left close<CR>", { desc = "Close file explorer" })

-- telescope keymaps
local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Search/find files in current directory" })
vim.keymap.set(
    "n",
    "<leader>fg",
    telescope_builtin.live_grep,
    { desc = "Search for/find text in files in current directory" }
)
vim.keymap.set("n", "<leader>buf", telescope_builtin.buffers, { desc = "Look through open buffers" })
vim.keymap.set("n", "<leader>cmd", telescope_builtin.commands, { desc = "Search/find commands" })
vim.keymap.set("n", "<leader>km", telescope_builtin.keymaps, { desc = "Search/find keymaps" })
vim.keymap.set("n", "<C-f>", telescope_builtin.current_buffer_fuzzy_find, { desc = "Search/find in current file" })
vim.keymap.set("n", "<leader>sym", telescope_builtin.lsp_document_symbols,
    { desc = "List symbols in current file (from LSP)" })

-- display diagnostics, with keymaps for different severities and options
vim.keymap.set("n", "<leader>dgl", function()
    vim.diagnostic.open_float(nil, { border = "rounded", focusable = true })
end, { desc = "Display diagnostics for the current line" })

vim.keymap.set(
    "n",
    "<leader>dga",
    "<cmd>Telescope diagnostics bufnr=0<CR>",
    { desc = "Display all diagnostics in current buffer" }
)

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local severity = vim.diagnostic.severity

-- Mapping severity levels to prefixes and highlight groups
local severity_config = {
    [severity.ERROR] = { prefix = "E", hl = "DiagnosticError" },
    [severity.WARN]  = { prefix = "W", hl = "DiagnosticWarn" },
    [severity.INFO]  = { prefix = "I", hl = "DiagnosticInfo" },
    [severity.HINT]  = { prefix = "H", hl = "DiagnosticHint" },
}

local function filtered_diagnostics(severity_level)
    local diagnostics = vim.diagnostic.get(0, { severity = severity_level })
    if vim.tbl_isempty(diagnostics) then
        vim.notify("No diagnostics found for the selected severity.", vim.log.levels.INFO)
        return
    end

    pickers.new({}, {
        prompt_title = "Filtered Diagnostics",
        finder = finders.new_table({
            results = diagnostics,
            entry_maker = function(entry)
                local sev_cfg = severity_config[entry.severity] or {}
                local prefix = sev_cfg.prefix or "?"
                local hl_group = sev_cfg.hl or "Normal"
                local line_info = string.format("%4d", entry.lnum + 1) -- 4-character padding for line number
                local message = entry.message

                return {
                    value = entry,
                    display = function()
                        -- Combine and format the display
                        local text = string.format("%s %s | %s", prefix, line_info, message)
                        return text, { { { 0, #prefix + #line_info + 2 }, hl_group } }
                    end,
                    ordinal = message, -- For fuzzy matching
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map)
            map("i", "<CR>", function(prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                vim.api.nvim_win_set_cursor(0, { selection.value.lnum + 1, selection.value.col })
            end)
            return true
        end,
    }):find()
end

-- Keymaps for different severities
vim.keymap.set("n", "<leader>dge", function() filtered_diagnostics(severity.ERROR) end,
    { desc = "Diagnostics: Show only errors" })
vim.keymap.set("n", "<leader>dgw", function() filtered_diagnostics(severity.WARN) end,
    { desc = "Diagnostics: Show only warnings" })
vim.keymap.set("n", "<leader>dgi", function() filtered_diagnostics(severity.INFO) end,
    { desc = "Diagnostics: Show only info" })
vim.keymap.set("n", "<leader>dgh", function() filtered_diagnostics(severity.HINT) end,
    { desc = "Diagnostics: Show only hints" })


--
--
--
--


vim.keymap.set("n", "gr", telescope_builtin.lsp_references, { desc = "Go to references for word under cursor" })
vim.keymap.set(
    "n",
    "gi",
    telescope_builtin.lsp_implementations,
    { desc = "Go to implementations for word under cursor" }
)
vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, { desc = "Go to definitions for word under cursor" })
vim.keymap.set(
    "n",
    "gt",
    telescope_builtin.lsp_type_definitions,
    { desc = "Go to type definitions for word under cursor" }
)

-- lsp keymaps
vim.keymap.set("n", "<C-i>", vim.lsp.buf.hover, { desc = "Display hover information" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Display code actions" })

-- null/none ls keymaps
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format code" })

-- vimtex keymaps
vim.keymap.set(
    "n",
    "<leader>ll",
    ":VimtexCompile<CR>",
    { noremap = true, desc = "Turn on continuous compilation for latex documents." }
)
vim.keymap.set(
    "n",
    "<leader>lv",
    ":VimtexView<CR>",
    { noremap = true, desc = "Display compileed latex document in PDF viewer." }
)

-- fugitive keymaps
vim.keymap.set("n", "<leader>ga", ":Git add .<CR>", { desc = "git add . " })
vim.keymap.set("n", "<leader>gs", ":Git status<CR>", { desc = "git status" })
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "git commit" })
vim.keymap.set("n", "<leader>gpl", ":Git pull<CR>", { desc = "git pull" })
vim.keymap.set("n", "<leader>gps", ":Git push<CR>", { desc = "git push" })

-- glow.nvim keymaps
vim.keymap.set("n", "<leader>md", ":Glow<CR>", { desc = "Render markdown in terminal using glow" })

-- autocomment selection
local slash_comment = "\\/\\/"
local comment_symbols = {
    c = slash_comment,          -- C
    cpp = slash_comment,        -- C++
    python = "\\#",             -- Python
    go = slash_comment,         -- Go
    rust = slash_comment,       -- Rust
    javascript = slash_comment, -- JavaScript
    typescript = slash_comment, -- TypeScript
    bash = "\\#",               -- Bash
    lua = "--",                 -- Lua
    html = "<!--",              -- HTML
    php = slash_comment,        -- PHP
    ruby = "\\#",               -- Ruby
    swift = slash_comment,      -- Swift
    kotlin = slash_comment,     -- Kotlin
    scala = slash_comment,      -- Scala
    markdown = "<!--",          -- Markdown (HTML comment style)
}
vim.keymap.set('v', '<leader>cc', function()
        local comment_symbol = comment_symbols[vim.bo.filetype] or slash_comment
        return ":!sed 's/^/" .. comment_symbol .. " /'<CR>"
    end,
    { expr = true, desc = "Comment a block of code" })


vim.keymap.set('v', '<leader>uc', function()
        local comment_symbol = comment_symbols[vim.bo.filetype] or slash_comment
        return ":!sed 's/^" .. comment_symbol .. " //'<CR>"
    end,
    { expr = true, desc = "Uncomment a block of code" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>return err<CR>}<Esc>",
            { desc = "Add go error handling block." })
    end,
})
