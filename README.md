# telescope-livegrep-history.nvim

A Neovim plugin that adds search history functionality to Telescope's live_grep command.

## Demo

[![Image from Gyazo](https://i.gyazo.com/b3ba9bd974a050c4e57ec0863befd769.gif)](https://gyazo.com/b3ba9bd974a050c4e57ec0863befd769)

## Features

- Saves live_grep search history
- Recall previous searches using up/down keys
- Automatically removes duplicate search history entries
- Search history is saved in JSON format and persists across Neovim restarts
- Customizable key mappings
- Configurable maximum history size

## Requirements

- Neovim >= 0.9.0
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation

### Using lazy.nvim

```lua
{
  "happy663/telescope-livegrep-history.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
}
```

## Setup

```lua
-- Load the extension
require('telescope').load_extension('live_grep_history')

-- Optional: Configure the extension
require('telescope').setup {
  extensions = {
    live_grep_history = {
      -- Customize key mappings
      mappings = {
        up_key = "<Up>",      -- Navigate to older search history
        down_key = "<Down>",  -- Navigate to newer search history
        confirm_key = "<CR>", -- Execute search and save to history
      },
      max_history = 100,      -- Maximum number of history entries to save
    }
  }
}
```

## Usage

```lua
-- Example keymapping
vim.keymap.set('n', '<leader>gg', require('telescope').extensions.live_grep_history.live_grep_with_history)
```

### Default Mappings

- `<Up>` (or your custom key): Navigate to older search history
- `<Down>` (or your custom key): Navigate to newer search history
- `<CR>` (or your custom key): Execute search and save to history

## History Storage

Search history is stored at:

```
~/.local/share/nvim/telescope_livegrep_history.json
```

## License

MIT
