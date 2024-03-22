local null_ls = require("null-ls")
local b = null_ls.builtins
local sources = {

  -- webdev stuff
  b.formatting.deno_fmt,
  b.formatting.prettier.with({ filetypes = { "html", "markdown", "css" } }),

  -- Lua
  b.formatting.stylua,

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

  -- cpp
  b.formatting.clang_format,
  b.formatting.rustfmt,

  -- Personal
  b.formatting.black.with({ extra_args = { "--fast" } }),
  b.formatting.stylua,
  b.diagnostics.flake8,
}

return {
  -- "jose-elias-alvarez/null-ls.nvim",
  "nvimtools/none-ls.nvim",
  null_ls.setup({
    debug = true,
    sources = sources,
  }),
}
