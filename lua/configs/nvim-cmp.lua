
local cmp = require'cmp'
local luasnip = require'luasnip'

-- Ensure util.default_tbl_get exists (fix for LuaSnip bug)
local util = require('luasnip.util.util')
if util.default_tbl_get == nil then
  util.default_tbl_get = function(default, t, ...)
    if t ~= nil then
      local tbl_val = vim.tbl_get(t, ...)
      if tbl_val ~= nil then
        return tbl_val
      end
    end
    return default
  end
end

-- Setup LuaSnip
require("luasnip").setup({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})

-- Load friendly-snippets (VSCode format from lazy.nvim)
require("luasnip.loaders.from_vscode").lazy_load()

-- Load custom Lua snippets
require("luasnip.loaders.from_lua").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets/lua" }
})

-- Debug: Print loaded snippets (optional, can be commented out)
-- vim.defer_fn(function()
--   local ls = require('luasnip')
--   local available = ls.available()
--   print("Loaded snippets:")
--   for ft, snippets in pairs(available) do
--     print(string.format("  %s: %d snippets", ft, #snippets))
--   end
-- end, 100)

-- Snippet selection using fzf-lua if available
vim.keymap.set('n', '<leader>ss', function()
  if pcall(require, 'fzf-lua') then
    require('fzf-lua').files({
      prompt = 'Snippets> ',
      cwd = vim.fn.stdpath("config") .. "/snippets/lua",
      previewer = false,
      actions = {
        ['default'] = function(selected)
          local file = selected[1]
          if file then
            vim.cmd('edit ' .. vim.fn.stdpath("config") .. "/snippets/lua/" .. file)
          end
        end
      }
    })
  else
    vim.cmd('edit ' .. vim.fn.stdpath("config") .. "/snippets/lua/")
  end
end, { desc = 'Open snippets directory' })

-- Add LSP capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  performance = {
    debounce = 60,
    throttle = 30,
    fetching_timeout = 500,
    confirm_resolve_timeout = 80,
    async_budget = 1,
    max_view_entries = 200,
  },
  matching = {
    disallow_fuzzy_matching = false,
    disallow_fullfuzzy_matching = false,
    disallow_partial_fuzzy_matching = true,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = true,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.close()
      end
      fallback()
    end, { 'i', 's' }),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', true)
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp', 
      entry_filter = function(entry, ctx)
        local client = entry.source.source.client
        if client then
          -- Filter out pylsp to avoid duplicates with pyright
          if client.name == 'pylsp' then
            return false
          end
        end
        return true
      end
    },
    { name = 'luasnip', duplicates = false },
  }, {
    { name = 'buffer', duplicates = false },
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = require('lspkind').presets.default[vim_item.kind] .. ' ' .. vim_item.kind
      local src = entry.source
      local src_name = src.name or 'unknown'
      if src.source and src.source.client then
        src_name = src_name .. '(' .. src.source.client.name .. ')'
      end
      vim_item.menu = '[' .. src_name .. ']'
      return vim_item
    end,
  },
})
