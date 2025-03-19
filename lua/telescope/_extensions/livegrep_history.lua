local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

local history = {}
local history_file = vim.fn.stdpath("data") .. "/telescope_livegrep_history.json"
local history_index = 0

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

  -- 履歴が100件を超えたら一番古いものを削除
  if #history > 100 then
    table.remove(history)
  end

  save_history()
end

local function live_grep_with_history()
  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")

  load_history()
  history_index = 0

  builtin.live_grep({
    prompt_title = "Live Grep History",
    search = history,
    attach_mappings = function(_, map)
      map("i", "<Up>", function(_prompt_bufnr)
        local picker = actions_state.get_current_picker(_prompt_bufnr)
        if history_index < #history then
          history_index = history_index + 1
          picker:set_prompt(history[history_index])
        end
      end)
      map("i", "<Down>", function(_prompt_bufnr)
        local picker = actions_state.get_current_picker(_prompt_bufnr)
        if history_index > 1 then
          history_index = history_index - 1
          picker:set_prompt(history[history_index])
        elseif history_index == 1 then
          history_index = 0
          picker:set_prompt("")
        end
      end)
      map("i", "<CR>", function(_prompt_bufnr)
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

