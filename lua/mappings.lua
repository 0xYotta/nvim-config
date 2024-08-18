require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>cx", function()
  require("nvchad.tabufline").closeAllBufs()
end, { desc = "Close All Buffers" })

map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find Todo" })
map("n", "\\", "<cmd>:vsplit <CR>", { desc = "Vertical Split" })
map("n", "<c-l>", "<cmd>:TmuxNavigateRight<cr>", { desc = "Tmux Right" })
map("n", "<c-h>", "<cmd>:TmuxNavigateLeft<cr>", { desc = "Tmux Left" })
map("n", "<c-k>", "<cmd>:TmuxNavigateUp<cr>", { desc = "Tmux Up" })
map("n", "<c-j>", "<cmd>:TmuxNavigateDown<cr>", { desc = "Tmux Down" })

-- Trouble

map("n", "<leader>qx", "<cmd>TroubleToggle<CR>", { desc = "Open Trouble" })
map("n", "<leader>qw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { desc = "Open Workspace Trouble" })
map("n", "<leader>qd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Open Document Trouble" })
map("n", "<leader>qq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Open Quickfix" })
map("n", "<leader>ql", "<cmd>TroubleToggle loclist<CR>", { desc = "Open Location List" })
map("n", "<leader>qt", "<cmd>TodoTrouble<CR>", { desc = "Open Todo Trouble" })

-- Tests
map("n", "<leader>tt", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })
map("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run file test" })
map("n", "<leader>to", ":Neotest output<CR>", { desc = "Show test output" })
map("n", "<leader>ts", ":Neotest summary<CR>", { desc = "Show test summary" })

-- Debug
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle Debug UI" })
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
map("n", "<leader>ds", function()
  require("dap").continue()
end, { desc = "Start" })
map("n", "<leader>dn", function()
  require("dap").step_over()
end, { desc = "Step Over" })

-- Git
map("n", "<leader>gl", ":Flog<CR>", { desc = "Git Log" })
map("n", "<leader>gf", ":DiffviewFileHistory<CR>", { desc = "Git File History" })
map("n", "<leader>gc", ":DiffviewOpen HEAD~1<CR>", { desc = "Git Last Commit" })
map("n", "<leader>gt", ":DiffviewToggleFile<CR>", { desc = "Git File History" })

-- Terminal
map("n", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp", size = 0.4 }
end, { desc = "Toogle Terminal Vertical" })
map("n", "<C-\\>", function()
  require("nvchad.term").toggle { pos = "sp", size = 0.4 }
end, { desc = "Toogle Terminal Horizontal" })
map("n", "<C-f>", function()
  require("nvchad.term").toggle { pos = "float" }
end, { desc = "Toogle Terminal Float" })
map("t", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp" }
end, { desc = "Toogle Terminal Vertical" })
map("t", "<C-\\>", function()
  require("nvchad.term").toggle { pos = "sp" }
end, { desc = "Toogle Terminal Horizontal" })
map("t", "<C-f>", function()
  require("nvchad.term").toggle { pos = "float" }
end, { desc = "Toogle Terminal Float" })

-- Basic

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--

-- Toggle comment
map("n", "<leader>/", ':lua require("Comment.api").toggle.linewise.current()<CR>', default_opts)
map("v", "<leader>/", ":lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", default_opts)

map("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })
map("n", "<leader>gorn", ":GoRename<CR>")

--=======================================================================================
--Session control--
-------------------
--leader s w to write a session file
--leader s s to restore a session from that file

-- Define the save_session function as a global function
_G.save_session = function()
  -- Get the current root directory
  local root_dir = vim.fn.getcwd()

  -- Extract the current folder name from the root directory path
  local folder_name = vim.fn.fnamemodify(root_dir, ":t")

  -- Construct the session filename using the folder name
  local session_filename = folder_name .. ".vim"

  -- Save the session with the constructed filename
  vim.cmd("mksession! " .. session_filename)
  print("Session saved as " .. session_filename)

  -- Define the path to the .gitignore file
  local gitignore_path = root_dir .. "/.gitignore"

  -- Check if the .gitignore file exists
  local gitignore_exists = vim.fn.filereadable(gitignore_path) == 1

  -- Open the .gitignore file in append mode or create it if it doesn't exist
  local gitignore_file = io.open(gitignore_path, "a+")

  if gitignore_file then
    -- Read the contents of the .gitignore file to check if the session file is already listed
    local already_ignored = false
    for line in gitignore_file:lines() do
      if line == session_filename then
        already_ignored = true
        break
      end
    end

    -- If the session file is not already listed, append it to the .gitignore file
    if not already_ignored then
      gitignore_file:write(session_filename .. "\n")
      print(session_filename .. " added to .gitignore")
    end

    -- Close the .gitignore file
    gitignore_file:close()
  else
    print "Could not open or create .gitignore file"
  end
end

-- Define the restore_session function as a global function
_G.restore_session = function()
  -- Get the current root directory
  local root_dir = vim.fn.getcwd()

  -- Extract the current folder name from the root directory path
  local folder_name = vim.fn.fnamemodify(root_dir, ":t")

  -- Construct the session filename using the folder name
  local session_filename = folder_name .. ".vim"

  -- Check if the session file exists
  if vim.fn.filereadable(session_filename) == 1 then
    -- Source the session file to restore the session
    vim.cmd("source " .. session_filename)
    print("Session restored from " .. session_filename)
  else
    print("No session file found for " .. folder_name)
  end
end

-- Map <leader>sw to save the session
map("n", "<leader>sw", ":lua save_session()<CR>", { noremap = true, silent = true })
-- Map <leader>ss to restore the session
map("n", "<leader>ss", ":lua restore_session()<CR>", { noremap = true, silent = true })
