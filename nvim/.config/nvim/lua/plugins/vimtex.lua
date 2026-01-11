return {
	"lervag/vimtex",
    lazy = false,
	config = function()
		vim.g.vimtex_view_method = "general" -- Or another PDF viewer of your choice
		vim.g.vimtex_general_viewer = "xdg-open"
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_compiler_latexmk = {
			callback = 1,
			continuous = 1,
			executable = "latexmk",
			options = {
				"-shell-escape",
				"-verbose",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
			},
		}
	end,
}
