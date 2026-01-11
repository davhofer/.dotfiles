return {
    "ellisonleao/glow.nvim",
    config = function()
        require('glow').setup({
            width_ratio = 0.85,
            height_ratio = 0.85,
            style = "~/.config/glow/catppuccin-mocha.json"
        })
    end

    ,
    cmd = "Glow"
}
