# telescope-livegrep-history.nvim

A Neovim plugin that adds search history functionality to Telescope's live_grep command.

## Features

- Saves live_grep search history
- Recall previous searches using up/down keys
- Automatically removes duplicate search history entries
- Search history is saved in JSON format and persists across Neovim restarts

## Requirements

- Neovim >= 0.5.0
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
require('telescope').load_extension('livegrep_history')
```

## Usage

```lua
-- Example keymapping
vim.keymap.set('n', '<leader>gg', require('telescope').extensions.livegrep_history.live_grep_with_history)
```

### Basic Operations

- `<Up>`: Navigate to older search history
- `<Down>`: Navigate to newer search history
- `<CR>`: Execute search and save to history

## History Storage

Search history is stored at:
```
~/.local/share/nvim/telescope_livegrep_history.json
```

## License

MIT