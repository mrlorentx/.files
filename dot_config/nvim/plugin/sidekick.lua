-- copilot-lsp is installed in plugin/copilot.lua so it's on the rtp by the time
-- plugin/lsp.lua calls vim.lsp.enable("copilotlsp").
vim.pack.add({ "https://github.com/folke/sidekick.nvim" }, { confirm = false })

require("sidekick").setup({})

-- <Tab> in normal mode jumps to / applies the next edit suggestion,
-- and falls through to a regular <Tab> when there's no suggestion.
vim.keymap.set("n", "<Tab>", function()
	if require("sidekick").nes_jump_or_apply() then
		return
	end
	return "<Tab>"
end, { expr = true, desc = "Sidekick: jump/apply NES" })
