return {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        --'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
        require("flutter-tools").setup({
            flutter_path = "/home/david/snap/flutter/common/flutter/bin/flutter"
        })
    end,
}
