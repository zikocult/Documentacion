local function noremap(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- ===GENERAL OPTIONS
-- resize splits with arrow keys
noremap("n", "<A-up>", ":res +5<CR>", {})
noremap("n", "<A-down>", ":res -5<CR>", {})
noremap("n", "<A-left>", ":vertical resize-5<CR>", {})
noremap("n", "<A-right>", ":vertical resize+5<CR>", {})
-- vertical to horizontal ( | -> -- )
noremap("n", "<leader>z", "<C-w>t<C-w>K", { desc = "Switch to horizontal" })
noremap("n", "<leader>v", "<C-w>t<C-w>H", { desc = "Switch to vertical" })

-- ===STHEADER42
noremap("n", "<F5>", "<cmd>Stdheader<cr>", { desc = "42's Header" })

-- ===COLORIZER
noremap("n", "<leader>co", "<cmd>ColorizerAttachToBuffer<cr>", { desc = "Colorizer Attach to Buffer" })
noremap("n", "<leader>ct", "<cmd>ColorizerToggle<cr>", { desc = "Colorizer toggle" })

-- Comment

local bufopts = { noremap = true, silent = true }

-- ===NEOTREE
map("n", "<C-n>", "<Cmd>Neotree toggle<CR>", bufopts)

-- ===BARBAR
map("n", "<tab>", "<Cmd>BufferNext<CR>", bufopts)
map("n", "<S-tab>", "<Cmd>BufferPrevious<CR>", bufopts)
-- Re-order to previous/next
map("n", "<A-.>", "<Cmd>BufferMoveNext<CR>", bufopts)
map("n", "<A-,>", "<Cmd>BufferMovePrevious<CR>", bufopts)
-- Goto buffer in position...
map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", bufopts)
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", bufopts)
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", bufopts)
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", bufopts)
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", bufopts)
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", bufopts)
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", bufopts)
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", bufopts)
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", bufopts)
map("n", "<A-0>", "<Cmd>BufferLast<CR>", bufopts)
-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferPin<CR>", bufopts)
-- Close buffer
map("n", "<A-c>", "<Cmd>BufferClose<CR>", bufopts)

-- ===ALPHA NVIM
map("n", "<leader>a", "<Cmd>Dashboard<CR>", { noremap = true, silent = true, desc = "Dashboard-NVIM" })

-- ===SEARCHBOX
-- Normal mode
map(
  "n",
  "<leader>sr",
  "<Cmd>SearchBoxReplace confirm=menu<CR>",
  { noremap = true, silent = true, desc = "Sustitución con confirmación" }
)
map(
  "n",
  "<leader>se",
  "<Cmd>SearchBoxReplace<CR>",
  { noremap = true, silent = true, desc = "Sustitución sin confirmación" }
)
map("n", "<C-f>", "<Cmd>SearchBoxSimple<CR>", { noremap = true, silent = true, desc = "Busqueda Simple" })
-- Visual mode
map("v", "<C-f>", "<Cmd>SearchBoxSimple<CR>", { noremap = true, silent = true, desc = "Busqueda Simple" })
map("v", "<C-r>", "<Cmd><CR>", { noremap = true, silent = true, desc = "Busqueda Simple" })
