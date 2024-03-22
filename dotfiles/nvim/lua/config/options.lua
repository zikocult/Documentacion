-----------------------------------------------------------
-- Opciones personalizadas de nvim
-----------------------------------------------------------

local opt = vim.opt
-- Disable LazyVim auto format
vim.g.autoformat = false

-----------------------------------------------------------
-- General
-----------------------------------------------------------

opt.mouse = "a" -- enable mouse support
opt.swapfile = false -- don't use swapfileo

-- Indenting
opt.expandtab = false
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.smarttab = true
opt.clipboard = "unnamedplus"

-----------------------------------------------------------
-- NeoVim UI
-----------------------------------------------------------

opt.winbar = "%=%m %f"
opt.number = true -- show line number
opt.relativenumber = true -- show line number
opt.showmatch = true -- highlight matching parenthesis
opt.foldmethod = "marker" -- enable folding (default 'foldmarker')
opt.colorcolumn = "80" -- line lenght marker at 80 columns
opt.splitright = true -- vertical split to the right
opt.splitbelow = true -- orizontal split to the bottom
opt.smartcase = true -- ignore lowercase for the whole pattern
opt.linebreak = true -- wrap on word boundary
opt.conceallevel = 0
opt.termguicolors = true
vim.g.neovide_cursor_vfx_mode = "railgun"

vim.opt.listchars = {
  tab = "▸ ",
  trail = "•",
  nbsp = "␣",
  precedes = "«",
  extends = "»",
  eol = "⤶",
}
opt.list = true
