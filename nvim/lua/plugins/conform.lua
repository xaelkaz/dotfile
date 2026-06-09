return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    require("conform").setup({
      -- Formateo al guardar, decidido por filetype:
      format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "rust" then
          -- Dejamos que rust-analyzer formatee: él lee la `edition` del
          -- Cargo.toml de CADA proyecto (2021, 2024, o la que venga).
          return { lsp_format = "fallback", timeout_ms = 1500 }
        end
        -- Otros lenguajes: sin auto-formato (igual que hoy).
        return nil
      end,
    })
  end,
}
