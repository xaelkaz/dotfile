return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      -- estilos: modern (default), classic, minimal, powerline, ghost, simple, nonerdfont, amongus
      preset = "modern",
    })

    vim.diagnostic.config({ virtual_text = false })
  end,
}
