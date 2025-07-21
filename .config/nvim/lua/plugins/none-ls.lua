local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local format_on_save_enabled = true
return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.clang_format,
                null_ls.builtins.formatting.prettier,
                require("none-ls.formatting.ruff").with({
                    extra_args = function()
                        local config_path = vim.fn.expand("~/.config/ruff/ruff.toml")
                        if vim.fn.filereadable(config_path) == 1 then
                            return { "--config", config_path }
                        end
                        return {}
                    end,
                }),
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = function()
                        local config_path = vim.fn.expand("~/.config/mypy/mypy.ini")
                        local args = { "--install-types" }
                        if vim.fn.filereadable(config_path) == 1 then
                            table.insert(args, 1, "--config-file")
                            table.insert(args, 2, config_path)
                        end
                        return args
                    end,
                }),
                require("none-ls.diagnostics.ruff").with({
                    extra_args = function()
                        local config_path = vim.fn.expand("~/.config/ruff/ruff.toml")
                        if vim.fn.filereadable(config_path) == 1 then
                            return { "--config", config_path }
                        end
                        return {}
                    end,
                }),
                -- null_ls.builtins.formatting.rust_analyzer,
                -- null_ls.builtins.diagnostics.snyk,
                -- null_ls.builtins.diagnostics.cpplint,
                -- null_ls.builtins.diagnostics.pylint, -- Removed: Ruff includes pylint rules (PL)
                -- null_ls.builtins.diagnostics.rust_analyzer,
            },
            on_attach = function(client, bufnr)
                local file_path = vim.fn.expand("%:p")

                -- disable auto formatting for semester project directory or if globally disabled
                if not string.match(file_path, "MP%-SPDZ") and format_on_save_enabled then
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({
                            group = augroup,
                            buffer = bufnr,
                        })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end
            end,
        })
        
        -- Auto-cleanup null-ls temp files after saving (current file's directory only)
        vim.api.nvim_create_autocmd("BufWritePost", {
            callback = function()
                local current_dir = vim.fn.expand("%:p:h")
                local temp_files = vim.fn.glob(current_dir .. "/.null-ls_*", false, true)
                for _, file in ipairs(temp_files) do
                    vim.fn.delete(file)
                end
            end,
        })
        
        -- Toggle auto-format on save
        vim.keymap.set("n", "<leader>tf", function()
            format_on_save_enabled = not format_on_save_enabled
            local status = format_on_save_enabled and "enabled" or "disabled"
            vim.notify("Auto-format on save " .. status, vim.log.levels.INFO)
        end, { desc = "Toggle auto-format on save" })
    end,
}
