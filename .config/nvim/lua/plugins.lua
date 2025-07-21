-- Import all plugin configurations from the plugins directory
-- This file serves as the main entry point for lazy.nvim

return {
    -- LSP and Language Support
    require("plugins.lsp-config"),
    require("plugins.completions"),
    require("plugins.treesitter"),
    require("plugins.none-ls"),
    
    -- Telescope and UI
    require("plugins.telescope"),
    require("plugins.neo-tree"),
    require("plugins.lualine"),
    require("plugins.alpha"),
    require("plugins.noice"),
    
    -- Colorscheme
    require("plugins.catppuccin"),
    
    -- Git Integration
    require("plugins.fugitive"),
    
    -- Language-specific tools
    require("plugins.vimtex"),
    require("plugins.flutter-tools"),
    require("plugins.glow"),
}