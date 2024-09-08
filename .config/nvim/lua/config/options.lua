vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.cmdheight = 0
vim.opt.hlsearch = true
vim.opt.inccommand = "split"
vim.opt.showcmd = true
vim.opt.splitkeep = "cursor"
vim.opt.title = true

vim.opt.autoindent = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.breakindent = true
vim.opt.formatoptions:append({ "r" })
vim.opt.smarttab = true

vim.opt.shada = ""
vim.opt.backup = false

vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
