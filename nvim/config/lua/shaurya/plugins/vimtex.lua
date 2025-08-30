return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		-- General
		-- Viewer: Zathura (with inverse/forward search via nvr)
		vim.g.vimtex_view_method = "skim"
		vim.g.vimtex_view_skim_sync = 1 -- enable forward/inverse search
		vim.g.vimtex_view_skim_activate = 1 -- focus Skim when you invoke \lv

		vim.maplocalleader = " "
	end,
}
