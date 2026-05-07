vim.pack.add({ "https://github.com/saghen/blink.cmp" }, { confirm = false })

require("blink.cmp").setup({
	completion = {
		documentation = {
			auto_show = true,
		},
		list = {
			max_items = 5,
		},
		menu = {
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind" },
					{ "source_name" },
				},
			},
		},
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer", "copilot" },
		providers = {
			copilot = {
				name = "copilot",
				module = "blink-cmp-copilot",
				score_offset = 100,
				async = true,
			},
		},
	},

	-- default blink keymaps
	keymap = {
		["<C-p>"] = { "select_prev", "fallback_to_mappings" },
		["<C-n>"] = { "select_next", "fallback_to_mappings" },

		["<C-y>"] = { "select_and_accept", "fallback" },
		["<C-e>"] = { "cancel", "fallback" },
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

		["<CR>"] = { "select_and_accept", "fallback" },
		["<Tab>"] = {
			function() -- sidekick next edit suggestion
				return require("sidekick").nes_jump_or_apply()
			end,
			function() -- native LSP inline completion (copilot-lsp ghost text)
				return vim.lsp.inline_completion.get()
			end,
			"snippet_forward", -- if in snippet, jump forward
			"fallback", -- menu nav lives on <C-n>/<C-p>
		},
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },

		["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
	},

	fuzzy = {
		implementation = "lua",
	},
})
