-- Every language server runs natively off PATH — the flake wraps nvim with the
-- `lsp-tools` bundle (modules/lsp-tools.nix) on its PATH, so the binary names
-- below are the nixpkgs ones.

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      schemas = require("schemastore").yaml.schemas(),
      validate = { enable = true },
      completion = true,
      hover = true,
    },
  },
})

vim.lsp.config("jsonls", {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git" },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

-- The argv for a server: the binary name followed by any extra arguments.
local function cmd(bin, ...)
  return { bin, ... }
end

vim.filetype.add({
  filename = {
    ["Tiltfile"] = "python",
  },
})

vim.lsp.config("pyright", {
  cmd = cmd("pyright-langserver", "--stdio"),
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
  settings = {
    python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true } },
  },
})

vim.lsp.config("rust_analyzer", {
  cmd = cmd("rust-analyzer"),
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "Cargo.lock", ".git" },
})

vim.lsp.config("ts_ls", {
  cmd = cmd("typescript-language-server", "--stdio"),
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
})

vim.lsp.config("gopls", {
  cmd = cmd("gopls"),
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.work", ".git" },
})

vim.lsp.config("metals", {
  cmd = cmd("metals"),
  filetypes = { "scala", "sbt" },
  root_markers = { "build.sbt", "build.sc", ".bsp", ".git" },
})

vim.lsp.config("hls", {
  cmd = cmd("haskell-language-server-wrapper", "--lsp"),
  filetypes = { "haskell", "lhaskell" },
  root_markers = { "*.cabal", "stack.yaml", "cabal.project", "package.yaml", ".git" },
})

vim.filetype.add({ extension = { podspec = "ruby" } })

vim.lsp.config("ruby_lsp", {
  cmd = cmd("ruby-lsp"),
  filetypes = { "ruby" },
  root_markers = { "Gemfile", ".git" },
})

vim.lsp.config("clangd", {
  cmd = cmd("clangd"),
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
})

vim.lsp.config("bashls", {
  cmd = cmd("bash-language-server", "start"),
  filetypes = { "sh", "bash" },
  root_markers = { ".git" },
})

vim.lsp.config("html", {
  cmd = cmd("vscode-html-language-server", "--stdio"),
  filetypes = { "html" },
  root_markers = { ".git" },
})

vim.lsp.config("lemminx", {
  cmd = cmd("lemminx"),
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
  root_markers = { ".git" },
})

vim.lsp.config("terraformls", {
  cmd = cmd("terraform-ls", "serve"),
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", "*.tf", ".git" },
})

vim.lsp.config("marksman", {
  cmd = cmd("marksman", "server"),
  filetypes = { "markdown" },
  root_markers = { ".marksman.toml", ".git" },
})

vim.lsp.enable({
  "lua_ls",
  "yamlls",
  "jsonls",
  "pyright",
  "rust_analyzer",
  "ts_ls",
  "gopls",
  "metals",
  "hls",
  "ruby_lsp",
  "clangd",
  "bashls",
  "html",
  "lemminx",
  "terraformls",
  "marksman",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gr", vim.lsp.buf.references, "Go to references")
    map("K", vim.lsp.buf.hover, "Hover docs")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("[d", function()
      vim.diagnostic.jump({ count = -1 })
    end, "Previous diagnostic")
    map("]d", function()
      vim.diagnostic.jump({ count = 1 })
    end, "Next diagnostic")
  end,
})
