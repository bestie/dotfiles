local comment_preview = {
  keymap_overrides = {
    ["&trans"] = "  ",
    ["&none"] = "❌",
    ["&sys_reset"] = "🔄",
    ["&bootloader"] = "💾",
    ["&"] = "",
    ["&OUT_USB"] = "🔌",
    ["&OUT_BLE"] = "",
    mmv = "🖱️",
    MOVE_UP = "↑",
    MOVE_DOWN = "↓",
    MOVE_LEFT = "←",
    MOVE_RIGHT = "→",
    KC_UP = "↑",
    KC_DOWN = "↓",
    KC_LEFT = "←",
    KC_RIGHT = "→",
    KC_LGUI = "⌘",
    KC_RGUI = "⌘",
    KC_LCTRL = "⌃",
    KC_RCTRL = "⌃",
    KC_LALT = "⌥",
    KC_RALT = "⌥",
    KC_LSFT = "⇧",
    KC_RSFT = "⇧",
  },
  symbols = {
    tl = "╭",
    tr = "╮",
    bl = "╰",
    br = "╯",
  },
}

return {
	{
		"codethread/qmk.nvim",
		config = function()
      local qmk = require("qmk")

			vim.api.nvim_create_autocmd({ "BufWrite" }, {
				pattern = "*.keymap",
				callback = function()
					qmk.format()
				end,
			})

			vim.api.nvim_create_autocmd({ "BufEnter" }, {
				pattern = "*/eyelash_sofle.keymap",
				callback = function()
					require("qmk").setup({
						name = "eyelash_sofle",
						auto_format_pattern = "*/eyelash_sofle.keymap",
						comment_preview = comment_preview,
						layout = {
              "x x x x x x x x x x x x x",
              "x x x x x x x x x x x x x",
              "x x x x x x x x x x x x x",
              "x x x x x x x x x x x x x",
              "x x x x x x x x x x x x _",
						},
						variant = "zmk",
					})
					require("qmk").format()
				end,
			})
		end,
	},
}
