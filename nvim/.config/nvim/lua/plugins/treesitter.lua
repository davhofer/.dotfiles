return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            auto_install = true,
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
                "rust",
                "python",
                "javascript",
                "go",
                "bash",
                "cpp",
                "json",
                "dockerfile",
                "latex",
                "dart",
                "regex",
                "html",
                "yaml",
            },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
