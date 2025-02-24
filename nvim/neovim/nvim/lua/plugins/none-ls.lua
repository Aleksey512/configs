
-- Customize None-ls sources
-- if true then return {} end
---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"
    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.isort,
      null_ls.builtins.diagnostics.mypy.with({
        extra_args = function()
          if os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr" then
            vim.notify_once("Running `mypy` with `ENV`")
            local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
            return { "--python-executable", virtual .. "/bin/python3" }
          elseif require("utils").cwd_has_file("poetry.lock") then
            vim.notify_once("Running `mypy` with `poetry`")
            return { "--python-executable", vim.fn.system("poetry env info --path") .. "/bin/python3" }
          else
            vim.notify_once("`mypy` not running")
          end
        end,
      }),
      -- Set a formatter
      -- null_ls.builtins.formatting.prettier,
    }
    return config -- return final config table
  end,
}
