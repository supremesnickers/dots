-- nvim-cmp setup
local cmp = require "cmp"

cmp.setup {
    experimental = {
        native_menu = false,
        -- ghost_text = true
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "path" },
    },
}
