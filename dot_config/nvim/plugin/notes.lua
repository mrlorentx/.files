-- headlines.nvim (markdown heading highlights)
vim.pack.add({ "https://github.com/lukas-reineke/headlines.nvim" }, { confirm = false })

-- Headline colors follow the active Omarchy theme.
--
-- These used to be hardcoded to a Tokyo Night palette. Colorschemes that define
-- the headlines.nvim groups themselves (tokyonight, catppuccin) overrode them,
-- but the ones that don't (gruvbox, kanagawa, everforest, nordfox, rose-pine)
-- let the hardcoded values leak through -- a near-invisible band on gruvbox, and
-- a dark band with cyan text on light themes like rose-pine. So: defer to the
-- colorscheme when it styles these groups, and otherwise derive them from it.

local HEADLINE_GROUPS = { "Headline1", "Headline2", "Headline3", "CodeBlock", "Dash" }

local function hl(name)
	local group = vim.api.nvim_get_hl(0, { name = name, link = false })
	return next(group) and group or nil
end

---Mix `amount` of `mix` into `base`; both are 24-bit RGB ints.
local function blend(base, mix, amount)
	local function channel(color, shift)
		return math.floor(color / shift) % 256
	end
	local out = 0
	for _, shift in ipairs({ 65536, 256, 1 }) do
		local value = channel(base, shift) * (1 - amount) + channel(mix, shift) * amount
		out = out + math.floor(value + 0.5) * shift
	end
	return out
end

---Foregrounds for the three heading levels.
---
---Prefer the theme's own markdown heading colors, but only when it actually
---distinguishes the levels. Neovim links @markup.heading.N to Title by default,
---so a theme that styles neither still resolves to one flat default color for
---all three -- in that case fall back to semantic accents, which every theme
---sets and which stay visually distinct.
local function heading_colors()
	local from_theme, distinct = {}, {}
	for level = 1, 3 do
		local heading = hl("@markup.heading." .. level .. ".markdown") or hl("@markup.heading." .. level)
		from_theme[level] = heading and heading.fg or nil
		if from_theme[level] then
			distinct[from_theme[level]] = true
		end
	end

	if #vim.tbl_keys(distinct) > 1 then
		return from_theme
	end

	local accents = {}
	for level, fallback in ipairs({ "Function", "Constant", "Type" }) do
		local group = hl(fallback)
		accents[level] = group and group.fg or from_theme[level]
	end
	return accents
end

local function style_headlines()
	local normal = hl("Normal") or {}
	local bg, fg = normal.bg, normal.fg

	-- A subtle band behind the heading. CursorLine is already tuned per theme for
	-- exactly this "slightly off the background" job; blend as a fallback. Blending
	-- toward the foreground works on light and dark themes alike.
	local band = (hl("CursorLine") or {}).bg
	if not band and bg and fg then
		band = blend(bg, fg, 0.08)
	end
	local code = (bg and fg) and blend(bg, fg, 0.05) or band

	local colors = heading_colors()
	for level = 1, 3 do
		local name = "Headline" .. level
		if not hl(name) then
			vim.api.nvim_set_hl(0, name, { fg = colors[level], bg = band, bold = true })
		end
	end

	if not hl("CodeBlock") then
		vim.api.nvim_set_hl(0, "CodeBlock", { bg = code })
	end
	if not hl("Dash") then
		local dash = hl("Special") or hl("Comment") or {}
		vim.api.nvim_set_hl(0, "Dash", { fg = dash.fg, bold = true })
	end
end

-- Clear our own definitions before the new colorscheme loads, so the check above
-- sees what the incoming theme actually styles rather than last theme's leftovers.
vim.api.nvim_create_autocmd("ColorSchemePre", {
	group = vim.api.nvim_create_augroup("notes_headlines_reset", { clear = true }),
	callback = function()
		for _, name in ipairs(HEADLINE_GROUPS) do
			pcall(vim.api.nvim_set_hl, 0, name, {})
		end
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("notes_headlines", { clear = true }),
	callback = style_headlines,
})

-- plugin/theme.lua applies the Omarchy colorscheme after this file loads, which
-- fires the autocmd above. Cover the case where a colorscheme is already active.
style_headlines()

require("headlines").setup({
	markdown = {
		headline_highlights = { "Headline1", "Headline2", "Headline3" },
		bullet_highlights = { "Headline1", "Headline2", "Headline3" },
		bullets = { "❯", "❯", "❯", "❯" },
		dash_string = "⎯",
		fat_headlines = false,
		query = vim.treesitter.query.parse(
			"markdown",
			[[
				(atx_heading [
					(atx_h1_marker)
					(atx_h2_marker)
					(atx_h3_marker)
					(atx_h4_marker)
					(atx_h5_marker)
					(atx_h6_marker)
				] @headline)

				(thematic_break) @dash

				(fenced_code_block) @codeblock
			]]
		),
	},
})

-- obsidian.nvim
vim.pack.add({ "https://github.com/obsidian-nvim/obsidian.nvim" }, { confirm = false })

require("obsidian").setup({
	ui = { enable = false },
	workspaces = {
		{ name = "notes", path = "~/vaults" },
	},
	picker = {
		name = "telescope.nvim",
	},
	daily_notes = {
		default_tags = { "daily-notes" },
		workays_only = true,
		template = "dailies",
	},
	notes_subdir = "notes",
	templates = {
		folder = "/templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
	},
	legacy_commands = false,
})

-- obsidian keymaps (normal mode)
vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<cr>", { desc = "Obsidian: Open note" })
vim.keymap.set("n", "<leader>od", "<cmd>Obsidian dailies -10 0<cr>", { desc = "Obsidian: Daily notes" })
vim.keymap.set("n", "<leader>op", "<cmd>Obsidian paste_img<cr>", { desc = "Obsidian: Paste image" })
vim.keymap.set("n", "<leader>oq", "<cmd>Obsidian quick_switch<cr>", { desc = "Obsidian: Quick switch" })
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Obsidian: Search" })
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian tags<cr>", { desc = "Obsidian: Tags" })
vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian links<cr>", { desc = "Obsidian: Links" })
vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Obsidian: Backlinks" })
vim.keymap.set("n", "<leader>om", "<cmd>Obsidian template<cr>", { desc = "Obsidian: Template" })
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian quick_switch nav<cr>", { desc = "Obsidian: Nav" })
vim.keymap.set("n", "<leader>or", "<cmd>Obsidian rename<cr>", { desc = "Obsidian: Rename" })
vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian toc<cr>", { desc = "Obsidian: Contents (TOC)" })

-- obsidian keymaps (visual mode)
vim.keymap.set("v", "<leader>oe", function()
	local title = vim.fn.input({ prompt = "Enter title (optional): " })
	vim.cmd("ObsidianExtractNote " .. title)
end, { desc = "Obsidian: Extract text into new note" })
vim.keymap.set("v", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = "Obsidian: Link text to existing note" })
vim.keymap.set("v", "<leader>on", "<cmd>ObsidianLinkNew<cr>", { desc = "Obsidian: Link text to new note" })
vim.keymap.set("v", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = "Obsidian: Tags" })

-- task search keymaps (searches in ~/vaults/)
vim.keymap.set("n", "<leader>tt", function()
	require("telescope.builtin").grep_string({
		prompt_title = "Incomplete Tasks",
		search = "^\\s*- \\[ \\]",
		search_dirs = { "~/vaults/" },
		use_regex = true,
		initial_mode = "normal",
		layout_config = { preview_width = 0.5 },
		additional_args = function()
			return { "--no-ignore" }
		end,
	})
end, { desc = "Search for incomplete [t]asks" })

vim.keymap.set("n", "<leader>tf", function()
	require("telescope.builtin").grep_string({
		prompt_title = "Followup Tasks",
		search = "^\\s*- \\[>\\]",
		search_dirs = { "~/vaults/" },
		use_regex = true,
		initial_mode = "normal",
		layout_config = { preview_width = 0.5 },
		additional_args = function()
			return { "--no-ignore" }
		end,
	})
end, { desc = "Search for [f]ollowup tasks" })
