local keymap = vim.keymap

local function options(desc)
	return {
		noremap = true,
		silent = true,
		desc = desc,
	}
end

keymap.set("n", "x", '"_x', options("Delete character"))
keymap.set("n", "+", "<c-a>", options("Increment number"))
keymap.set("n", "-", "<c-x>", options("Decrement number"))
keymap.set("n", "<c-a>", "gg<s-v>G", options("Select all"))

keymap.set("n", "te", ":tabedit<return>", options("New tab"))
keymap.set("n", "tc", ":tabclose<return>", options("Close tab"))
keymap.set("n", "<tab>", ":tabnext<return>", options("Next tab"))
keymap.set("n", "<s-tab>", ":tabprevious<return>", options("Previous tab"))

keymap.set("n", "ss", ":split<return>", options("Split window horizontally"))
keymap.set("n", "sv", ":vsplit<return>", options("Split window vertically"))
keymap.set("n", "sh", "<c-w>h", options("Move to left window"))
keymap.set("n", "sj", "<c-w>j", options("Move to below window"))
keymap.set("n", "sk", "<c-w>k", options("Move to above window"))
keymap.set("n", "sl", "<c-w>l", options("Move to right window"))

keymap.set("n", "<left>", "<c-w><", options("Resize window left"))
keymap.set("n", "<down>", "<c-w>-", options("Resize window down"))
keymap.set("n", "<up>", "<c-w>+", options("Resize window up"))
keymap.set("n", "<right>", "<c-w>>", options("Resize window right"))

keymap.set("v", "J", ":m'>+1<return>gv", options("Move line down"))
keymap.set("v", "K", ":m'<-2<return>gv", options("Move line up"))

keymap.set("v", ";nl", ":s/\\n/\\r\\r/g<return>:noh<return>", options("Normalize newlines"))
keymap.set("v", ";dl", ":g/^$/d<return>:noh<return>", options("Delete empty lines"))

keymap.set("v", ";uc", "gU", options("Uppercase"))
keymap.set("v", ";lc", "gu", options("Lowercase"))

keymap.set("v", ";st", ":sort i<return>", options("Sort"))
