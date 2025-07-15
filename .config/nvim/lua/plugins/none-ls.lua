local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
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
                -- null_ls.builtins.formatting.clang_format,
                null_ls.builtins.formatting.prettier,
                require("none-ls.formatting.ruff").with({
                    extra_args = { "--config", "/home/david/.config/ruff/ruff.toml" },
                }),
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = { "--config-file", "/home/david/.config/mypy/mypy.ini", "--install-types" },
                }),
                require("none-ls.diagnostics.ruff").with({
                    extra_args = { "--config", "/home/david/.config/ruff/ruff.toml" },
                }),
                -- null_ls.builtins.formatting.rust_analyzer,
                -- null_ls.builtins.diagnostics.snyk,
                -- null_ls.builtins.diagnostics.cpplint,
                null_ls.builtins.diagnostics.pylint,
                -- null_ls.builtins.diagnostics.rust_analyzer,
            },
            on_attach = function(client, bufnr)
                local file_path = vim.fn.expand("%:p")

                -- disable auto formatting for semester project directory
                if not string.match(file_path, "MP%-SPDZ") then
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
    end,
}
