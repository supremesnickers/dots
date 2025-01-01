-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Treesitter context
require("treesitter-context").setup()

require 'nvim-treesitter.configs'.setup {
  autotag = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "v",
      node_decremental = "V",
    },
  },
}
