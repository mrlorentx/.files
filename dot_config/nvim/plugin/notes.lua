-- headlines.nvim (markdown heading highlights)
vim.pack.add({ "https://github.com/lukas-reineke/headlines.nvim" }, { confirm = false })

local bg = "#2B2B2B"
vim.api.nvim_set_hl(0, "Headline1", { fg = "#33ccff", bg = bg })
vim.api.nvim_set_hl(0, "Headline2", { fg = "#00bfff", bg = bg })
vim.api.nvim_set_hl(0, "Headline3", { fg = "#0099cc", bg = bg })
vim.api.nvim_set_hl(0, "CodeBlock", { bg = bg })
vim.api.nvim_set_hl(0, "Dash", { fg = "#D19A66", bold = true })

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
