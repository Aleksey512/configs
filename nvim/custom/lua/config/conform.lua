local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    python = { "black", "isort" },
    go = { "gofmt" },
  },

  format_on_save = false,
}

require("conform").setup(options)
