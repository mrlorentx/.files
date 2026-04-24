local lazy_path = vim.fn.stdpath("data") .. "/lazy"
local omarchy_themes = vim.fn.expand("~/.local/share/omarchy/themes")

-- For each Omarchy theme, read its neovim.lua to find the required plugin.
-- Add it to rtp if already in lazy, otherwise install it via vim.pack.add.
local handle = vim.uv.fs_scandir(omarchy_themes)
if handle then
	while true do
		local theme_name = vim.uv.fs_scandir_next(handle)
		if not theme_name then
			break
		end
		local neovim_lua = omarchy_themes .. "/" .. theme_name .. "/neovim.lua"
		local f = io.open(neovim_lua, "r")
		if f then
			local content = f:read("*a")
			f:close()
			local slug = content:match('"([^"]+/[^"]+)"')
			if slug then
				local dir_name = slug:match("([^/]+)$")
				local lazy_dir = lazy_path .. "/" .. dir_name
				if vim.uv.fs_stat(lazy_dir) then
					vim.opt.rtp:prepend(lazy_dir)
				else
					vim.pack.add({ "https://github.com/" .. slug }, { confirm = false })
				end
			end
		end
	end
end

vim.pack.add({ "https://github.com/EskelinenAntti/omarchy-theme-loader.nvim" }, { confirm = false })

-- Opt out of omarchy-theme-loader's forced transparent background.
package.loaded["omarchy-theme-loader.transparency"] = { set_transparent_background = function() end }

require("omarchy-theme-loader").start()
