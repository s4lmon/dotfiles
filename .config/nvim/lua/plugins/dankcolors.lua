return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#131313',
				base01 = '#131313',
				base02 = '#666c6c',
				base03 = '#666c6c',
				base04 = '#202323',
				base05 = '#b7bfbf',
				base06 = '#b7bfbf',
				base07 = '#b7bfbf',
				base08 = '#c63c58',
				base09 = '#c63c58',
				base0A = '#0b7c80',
				base0B = '#008c0b',
				base0C = '#468a8c',
				base0D = '#0b7c80',
				base0E = '#81bdbf',
				base0F = '#81bdbf',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#666c6c',
				fg = '#b7bfbf',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#0b7c80',
				fg = '#131313',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#666c6c' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#468a8c', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#81bdbf',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#0b7c80',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#0b7c80',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#468a8c',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#008c0b',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#202323' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#202323' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#666c6c',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
