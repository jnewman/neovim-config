-- nixpkgs ships nvim-treesitter's `main` branch, whose setup() only configures
-- `install_dir` — the classic `highlight`/`indent`/`ensure_installed` options are
-- silently ignored. Parsers and their queries come prebuilt on the runtimepath
-- from the Nix pack (modules/treesitter-parsers.nix); there is no `:TSInstall`
-- and no compiler at runtime. So highlighting and indentation are driven by
-- Neovim core here, activated per buffer as filetypes load.
--
-- The set of bundled languages lives in modules/treesitter-parsers.nix; keep the
-- two in sync. A filetype with no bundled parser silently keeps regex syntax.

-- Point nvim-treesitter's managed install_dir at the standard (writable) site
-- dir and prepend it to the runtimepath. The prebuilt pack already supplies the
-- parsers we highlight; this just keeps `:checkhealth nvim-treesitter` green and
-- lets `:TSInstall` add extra languages on demand (tree-sitter + cc are on PATH).
-- The dir must exist for Neovim to keep it on the runtimepath (nvim_list_runtime_paths
-- drops missing dirs), so create it on first run.
local ts_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
vim.fn.mkdir(ts_install_dir, "p")
require("nvim-treesitter").setup({ install_dir = ts_install_dir })

-- Filetypes whose tree-sitter language name differs from the filetype name.
-- Neovim maps most 1:1; register the exceptions so get_lang() resolves them.
vim.treesitter.language.register("tsx", "typescriptreact")
vim.treesitter.language.register("hcl", { "terraform", "terraform-vars" })

-- Enable treesitter highlighting + indentation for a buffer, if a parser for its
-- filetype is bundled. Both start()/language.add() are pcall'd: a missing parser
-- must degrade to plain regex syntax, never error on FileType.
local function attach(buf, ft)
  local lang = vim.treesitter.language.get_lang(ft) or ft
  if not pcall(vim.treesitter.language.add, lang) then
    return
  end
  pcall(vim.treesitter.start, buf, lang)
  -- indentexpr() is provided by the nvim-treesitter plugin (kept on rtp for its
  -- indent Lua + healthcheck); it reads the bundled indents.scm queries.
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    attach(ev.buf, ev.match)
  end,
})

-- Catch the buffer already open at startup: FileType for it may have fired before
-- this autocmd was registered.
if vim.bo.filetype ~= "" then
  attach(0, vim.bo.filetype)
end
