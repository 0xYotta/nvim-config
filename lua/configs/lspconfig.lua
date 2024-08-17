local configs = require "nvchad.configs.lspconfig"

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "gopls", "gradle_ls" }

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

-- Global variable to track hover popup toggle state
local hover_enabled = false -- Автопоказ изначально отключен

-- Function to manually show hover popup
local function show_hover_popup()
  vim.lsp.buf.hover()
end

-- Function to toggle hover popup functionality
local function toggle_hover_enabled()
  hover_enabled = not hover_enabled
  if hover_enabled then
    print "Hover popup enabled"
  else
    print "Hover popup disabled"
  end
end

-- Customize the on_attach function to include hover popup on CursorHold
local function custom_on_attach(client, bufnr)
  -- Call the original on_attach function
  if on_attach then
    on_attach(client, bufnr)
  end

  -- Set up CursorHold autocommand for showing hover popup after 1 second, only if hover_enabled is true
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      if hover_enabled then
        vim.lsp.buf.hover()
      end
    end,
  })

  -- Key mapping to manually trigger hover with 'K'
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "", {
    noremap = true,
    silent = true,
    callback = show_hover_popup,
  })

  -- Key mapping to toggle hover functionality with <leader>z
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>z", "", {
    noremap = true,
    silent = true,
    callback = toggle_hover_enabled,
  })
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = custom_on_attach, -- Use the custom on_attach function
    capabilities = capabilities,
    commands = {
      OrganizeImports = {
        organize_imports,
        description = "Organize Imports",
      },
    },
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
      },
    },
  }
end

lspconfig.prismals.setup {}

lspconfig.volar.setup {
  on_attach = custom_on_attach, -- Use the custom on_attach function for volar as well
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
}
