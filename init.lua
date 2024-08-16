vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"
-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Function to format JSON using jq
local function format_json()
  local current_buffer = vim.api.nvim_get_current_buf()
  local buffer_content = vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false)
  local json_content = table.concat(buffer_content, "\n")

  -- Use jq to format the JSON
  local handle = io.popen("echo '" .. json_content:gsub("'", [["]]) .. "' | jq .")
  local formatted_content = handle:read "*a"
  handle:close()

  -- Replace the buffer content with formatted JSON
  vim.api.nvim_buf_set_lines(current_buffer, 0, -1, false, vim.split(formatted_content, "\n"))
end

-- Create a custom command for formatting JSON
vim.api.nvim_create_user_command("FormatJSON", function()
  format_json()
end, {})

-- Mapping the function to <leader>json
vim.api.nvim_set_keymap("n", "<leader>json", ":FormatJSON<CR>", { noremap = true, silent = true })
