return {
  "saecki/crates.nvim",
  tag = "stable",
  event = { "BufRead Cargo.toml" },
  config = function()
    local crates = require("crates")
    crates.setup({
      completion = {
        cmp = { enabled = true },
      },
    })

    local map = vim.keymap.set
    map("n", "<leader>cv", crates.show_versions_popup, { desc = "Crates: versiones disponibles" })
    map("n", "<leader>cf", crates.show_features_popup, { desc = "Crates: features del crate" })
    map("n", "<leader>cu", crates.update_crate,        { desc = "Crates: actualizar el del cursor" })
    map("n", "<leader>cU", crates.upgrade_all_crates,  { desc = "Crates: actualizar todas" })
    map("n", "<leader>cp", crates.show_popup,          { desc = "Crates: popup de info" })
    map("n", "<leader>cd", crates.open_documentation,  { desc = "Crates: abrir docs.rs" })
  end,
}
