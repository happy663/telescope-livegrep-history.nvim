local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	error("This plugin requires nvim-telescope/telescope.nvim")
end

local M = {}
local history = {}
local history_file = vim.fn.stdpath("data") .. "/telescope_livegrep_history.json"
local history_index = 0

local config = {
	mappings = {
		up_key = "<Up>",
		down_key = "<Down>",
		confirm_key = "<CR>",
	},
	max_history = 100,
}

function M.setup(opts)
	opts = opts or {}
	config = vim.tbl_deep_extend("force", config, opts or {})
end

local function load_history()
	local file = io.open(history_file, "r")

	if not file then
		return {}
	end

	if file then
		local content = file:read("*a")
		file:close()
		if content and content ~= "" then
			history = vim.fn.json_decode(content)
		end
	end
end

local function save_history()
	local file = io.open(history_file, "w")
	if file then
		file:write(vim.fn.json_encode(history))
		file:close()
	end
end

local function add_history(search_word)
	table.insert(history, 1, search_word)

	-- 重複を削除
	local hash = {}
	history = vim.tbl_filter(function(value)
		if not hash[value] then
			hash[value] = true
			return true
		end
		return false
	end, history)

	-- 履歴の最大数を超えたら古いものを削除
	if #history > config.max_history then
		table.remove(history)
	end

	save_history()
end

function M.live_grep_with_history()
	local builtin = require("telescope.builtin")
	local actions = require("telescope.actions")
	local actions_state = require("telescope.actions.state")

	load_history()
	history_index = 0

	builtin.live_grep({
		prompt_title = "Live Grep History",
		search = history,
		attach_mappings = function(_, map)
			map("i", config.mappings.up_key, function(_prompt_bufnr)
				local picker = actions_state.get_current_picker(_prompt_bufnr)
				if history_index < #history then
					history_index = history_index + 1
					picker:set_prompt(history[history_index])
				end
			end)
			map("i", config.mappings.down_key, function(_prompt_bufnr)
				local picker = actions_state.get_current_picker(_prompt_bufnr)
				if history_index > 1 then
					history_index = history_index - 1
					picker:set_prompt(history[history_index])
				elseif history_index == 1 then
					history_index = 0
					picker:set_prompt("")
				end
			end)
			map("i", config.mappings.confirm_key, function(_prompt_bufnr)
				local picker = actions_state.get_current_picker(_prompt_bufnr)
				local search_word = picker:_get_prompt()
				add_history(search_word)
				history_index = 0
				actions.select_default(_prompt_bufnr)
			end)
			return true
		end,
	})
end

return telescope.register_extension({
	setup = M.setup,
	exports = {
		live_grep_with_history = M.live_grep_with_history,
	},
})
