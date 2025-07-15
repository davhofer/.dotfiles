-- Custom function to filter diagnostics
local function custom_clangd_on_publish_diagnostics(_, result, ctx, config)
    -- Filter out diagnostics with code 'pp_file_not_found'
    if result and result.diagnostics then
        local filtered_diagnostics = {}
        for _, diagnostic in ipairs(result.diagnostics) do
            if diagnostic.code ~= "pp_file_not_found" then
                table.insert(filtered_diagnostics, diagnostic)
            end
        end
        result.diagnostics = filtered_diagnostics
    end
    -- Call the original on_publish_diagnostics function with the filtered diagnostics
    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
end

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup({
                ensure_installed = {
                    "mypy",
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                    "ltex",
                    "ruff",
                    "rust_analyzer",
                    "gopls",
                    "ts_ls"
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.clangd.setup({
                keys = {
                    { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
                },
                root_dir = function(fname)
                    return require("lspconfig.util").root_pattern(
                        "Makefile",
                        "configure.ac",
                        "configure.in",
                        "config.h.in",
                        "meson.build",
                        "meson_options.txt",
                        "build.ninja"
                    )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
                        fname
                    ) or require("lspconfig.util").find_git_ancestor(fname)
                end,
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
                handlers = {
                    ["textDocument/publishDiagnostics"] = custom_clangd_on_publish_diagnostics,
                }
            })
            lspconfig.ltex.setup({
                capabilities = capabilities,
                filetypes = {
                    "bib",
                    "gitcommit",
                    "markdown",
                    "org",
                    "plaintex",
                    "rst",
                    "rnoweb",
                    "tex",
                    "pandoc",
                    "quarto",
                    "rmd",
                    "context",
                    "html",
                    "xhtml",
                    "mail",
                    -- "text",
                },
            })
            lspconfig.ruff.setup({
                capabilities = capabilities,
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
            })
            lspconfig.gopls.setup({
                capabilities = capabilities,
            })
            lspconfig.pyright.setup({
                settings = {
                    pyright = {
                        disableOrganizeImports = true, -- Using Ruff
                    },
                    python = {
                        analysis = {
                            ignore = { "*" },         -- Using Ruff
                            typeCheckingMode = "off", -- Using mypy
                        },
                    },
                },
            })
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })
        end,
    },
}
