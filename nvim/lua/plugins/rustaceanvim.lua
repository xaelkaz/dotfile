-- lazy importa este archivo solo (tu init hace require("lazy").setup("plugins"))
return {
  "mrcjkb/rustaceanvim",
  lazy = false, -- el plugin ya se auto-activa solo en archivos Rust
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          -- Mostrar inlay hints (tipos inferidos, nombres de parámetros)
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

          -- Atajos de Rust (mejores que los genéricos)
          vim.keymap.set("n", "K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, { buffer = bufnr, desc = "Rust: hover + acciones" })

          vim.keymap.set("n", "<leader>ca", function()
            vim.cmd.RustLsp("codeAction")
          end, { buffer = bufnr, desc = "Rust: code action" })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" }, -- corre clippy, no solo check
            cargo = { allFeatures = true },
            procMacro = { enable = true },
            inlayHints = {
              parameterHints = { enable = true },
              typeHints = { enable = true },
              closureReturnTypeHints = { enable = "always" },
            },
          },
        },
      },
    }
  end,
}
