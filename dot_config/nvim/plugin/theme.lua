-- Sync the Neovim colorscheme with the active Omarchy theme.
--
-- Omarchy 4 (Quattro) renders a lazy.nvim-style spec for the current theme into
-- ~/.local/state/omarchy/current/theme/neovim.lua. A theme that ships its own
-- neovim.lua wins; everything else gets one generated from the theme's
-- colors.toml via the bjarneo/aether.nvim template. Either way that one file is
-- always present and always describes the active theme, so we read it directly
-- instead of scanning theme directories or mapping theme names to colorschemes.

local state_dir = vim.fs.joinpath(vim.env.HOME, ".local", "state", "omarchy", "current")
local theme_name_file = vim.fs.joinpath(state_dir, "theme.name")
local spec_file = vim.fs.joinpath(state_dir, "theme", "neovim.lua")
local colors_file = vim.fs.joinpath(state_dir, "theme", "colors.toml")

if not vim.uv.fs_stat(state_dir) then
	return
end

---Derive the Lua module name to call setup() on for a plugin spec entry.
---@param entry table
---@return string
local function module_name(entry)
	if entry.name then
		return entry.name
	end
	local basename = entry[1]:match("([^/]+)$")
	return (basename:gsub("%.nvim$", ""))
end

---Translate a lazy.nvim spec entry into a vim.pack spec.
---@param entry table
---@return table
local function pack_spec(entry)
	return {
		src = "https://github.com/" .. entry[1],
		-- Only override the name when the theme asks for it. Repos like
		-- catppuccin/nvim and rose-pine/neovim would otherwise install into a
		-- directory named after the wrong half of the slug.
		name = entry.name,
		version = entry.branch or entry.tag or entry.commit,
	}
end

---Install a spec entry and its dependencies, depth first.
---@param entry table
local function install(entry)
	for _, dep in ipairs(entry.dependencies or {}) do
		install(type(dep) == "string" and { dep } or dep)
	end
	vim.pack.add({ pack_spec(entry) }, { confirm = false })
end

---Pick the colorscheme plugin and colorscheme name out of a rendered spec.
---@param spec table
---@return table|nil plugin, string|function|nil colorscheme
local function parse(spec)
	local plugin, colorscheme
	for _, entry in ipairs(spec) do
		if type(entry) == "table" and type(entry[1]) == "string" then
			if entry[1] == "LazyVim/LazyVim" then
				-- We don't run LazyVim; this entry is only here to carry the
				-- colorscheme name. Some themes make it a function that applies
				-- highlights inline rather than naming a colorscheme.
				colorscheme = entry.opts and entry.opts.colorscheme
			elseif not plugin then
				plugin = entry
			end
		end
	end
	return plugin, colorscheme
end

---Read `mode` out of the theme's colors.toml, defaulting to dark.
---@return string
local function theme_background()
	local file = io.open(colors_file, "r")
	if not file then
		return "dark"
	end
	local mode = file:read("*a"):match('mode%s*=%s*"(%a+)"')
	file:close()
	return mode == "light" and "light" or "dark"
end

local function sync()
	local chunk, load_err = loadfile(spec_file)
	if not chunk then
		vim.notify(string.format("Could not read Omarchy theme spec: %s", load_err), vim.log.levels.ERROR)
		return
	end

	local ok, spec = pcall(chunk)
	if not ok or type(spec) ~= "table" then
		vim.notify(string.format("Could not evaluate %s", spec_file), vim.log.levels.ERROR)
		return
	end

	local plugin, colorscheme = parse(spec)
	if not plugin and not colorscheme then
		vim.notify(string.format("No colorscheme declared in %s", spec_file), vim.log.levels.ERROR)
		return
	end

	vim.o.background = theme_background()

	-- A theme may define its colors inline instead of pulling in a plugin, in
	-- which case there is nothing to install and `colorscheme` is a function
	-- that sets the highlights itself.
	if plugin then
		install(plugin)

		-- Themes that ship a config function do their own setup and :colorscheme.
		if type(plugin.config) == "function" then
			local configured, config_err = pcall(plugin.config, nil, plugin.opts or {})
			if configured then
				return
			end
			vim.notify(string.format("%s config failed: %s", plugin[1], config_err), vim.log.levels.WARN)
		end

		if plugin.opts then
			local module = module_name(plugin)
			local required, mod = pcall(require, module)
			if required and type(mod) == "table" and type(mod.setup) == "function" then
				local applied, setup_err = pcall(mod.setup, plugin.opts)
				if not applied then
					vim.notify(string.format("%s.setup() failed: %s", module, setup_err), vim.log.levels.WARN)
				end
			end
		end
	end

	if type(colorscheme) == "function" then
		-- A theme defining its highlights inline never runs :colorscheme, so the
		-- ColorScheme events don't fire on their own. Emit them, or anything that
		-- restyles itself per theme (headlines.nvim groups in plugin/notes.lua)
		-- silently keeps the previous theme's colors.
		vim.api.nvim_exec_autocmds("ColorSchemePre", { pattern = "omarchy" })
		local applied, cs_err = pcall(colorscheme)
		if not applied then
			vim.notify(string.format("Inline colorscheme failed: %s", cs_err), vim.log.levels.ERROR)
			return
		end
		vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name or "omarchy" })
	elseif colorscheme then
		local applied = pcall(vim.cmd.colorscheme, colorscheme)
		if not applied then
			vim.notify(
				string.format("Colorscheme '%s' not found (from %s)", colorscheme, plugin and plugin[1] or spec_file),
				vim.log.levels.ERROR
			)
		end
	end
end

sync()

-- omarchy-theme-set swaps the theme directory into place before writing
-- theme.name, so that write is the signal that a switch has completed. Watch
-- the containing directory rather than the file itself so the watch survives
-- the file being replaced instead of truncated.
local handle, watch_err = vim.uv.new_fs_event()
if not handle then
	vim.notify(string.format("Could not watch for Omarchy theme changes: %s", watch_err), vim.log.levels.ERROR)
	return
end

vim.uv.fs_event_start(handle, state_dir, {}, function(_, filename, _)
	if filename ~= vim.fs.basename(theme_name_file) then
		return
	end
	-- vim.cmd.* is not allowed in a fast event context.
	vim.schedule(sync)
end)
