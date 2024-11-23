-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      autoformat = true, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          "go",
        },
      },
      filter = function(client)
        if vim.bo.filetype == "python" then
          return client.name == "null-ls"
        end

        return true
      end,
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        "pyright",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      "pyright",
      "gopls",
      "ruff_lsp"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
      pyright  = function(_, opts) 
       require("lspconfig").pyright.setup({
        setting = {
            pyright = {
              -- Using Ruff import organizer
              disableOrginizeImports = true,
            },
            python = {
              analysis = {
                ignore = {'*'},
              },
            },
          },
        on_new_config = function(new_config, dir)
          if os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr" then
            vim.notify_once("Running `pyright` with active virtualenv: " .. venv)
            new_config.cmd = { venv .. "/bin/python pyright-langserver", "--stdio" }
          elseif require("utils").dir_has_file(dir, "poetry.lock") then
            vim.notify_once("Running `pyright` with `poetry`")
            new_config.cmd = { "poetry", "run", "pyright-langserver", "--stdio" }
          elseif require("utils").dir_has_file(dir, "Pipfile") then
            vim.notify_once("Running `pyright` with `pipenv`")
            new_config.cmd = { "pipenv", "run", "pyright-langserver", "--stdio" }
          else
            vim.notify_once("Running `pyright` without a virtualenv")
          end
        end,
     }) end, 
      
      gopls = function(_, opts) require("lspconfig").gopls.setup({
        cmd = { "gopls" },
        filetypes = {"go", "gomd", "gowork", "gotmpl"},
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
            }
          }
        }
      }) end,

     ruff_lsp = function(_, opts) require("lspconfig").ruff_lsp.setup({
        init_options = {
          settings = {
            args = {
              "--select=E,F,UP,N,I,ASYNC,S,PTH",
              "--line-length=88",
              "--respect-gitignore"
            },
          }
        }
      }) end,
    },
    autocmds = {
    -- Configure buffer local auto commands to add when attaching a language server
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
         
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
        },
        gy = {
          function() vim.lsp.buf.type_definition() end,
          desc = "Type definition",
        },
        gp = {
          function() vim.lsp.buf.definition() end,
          desc = "Definition",
        },
        gI = {
          function() vim.lsp.buf.implementation() end,
          desc = "Implementation",
        },
        gi = {
          function() require('lspimport').import() end,
          desc = "Import",
        },
        K = {
          function() vim.lsp.buf.hover() end,
          desc = "Hover symbol details",
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}