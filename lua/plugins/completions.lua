-- lua/plugins/completions.lua

return {
  { 'hrsh7th/cmp-nvim-lsp' },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'onsails/lspkind.nvim' },
    config = function()
      local cmp = require 'cmp'

      require('luasnip.loaders.from_vscode').lazy_load()

      require('luasnip.loaders.from_lua').lazy_load {
        paths = vim.fn.stdpath 'config' .. '/snippets/lua/',
      }

      -- border opts
      local border_opts = {
        border = 'rounded',
        scrollbar = false,
        col_offset = -3,
        side_padding = 0,
        scrolloff = 0,
        winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
      }
      local cmp_config_window = (vim.g.lsp_round_borders_enabled and cmp.config.window.bordered(border_opts)) or cmp.config.window

      cmp.setup {
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = require('lspkind').cmp_format {
              mode = 'symbol_text',
              maxwidth = 50,
              abbr = 50,
              ellipsis_char = '...',
              show_labelDetails = true,
            }(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. (strings[1] or '') .. ' '
            kind.menu = '    (' .. (strings[2] or '') .. ')'
            return kind
          end,
        },

        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp_config_window,
          documentation = cmp_config_window,
        },

        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
        },

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'calc' },
          { name = 'treesitter' },
          { name = 'tags' },
          { name = 'rg' },
        }, {
          { name = 'buffer' },
        }),
      }
    end,
  },
}
