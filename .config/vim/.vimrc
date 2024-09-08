set clipboard=unnamedplus,unnamed
set guifont=Hack\ Nerd\ Font\ Mono:h14
set viminfo=

set noerrorbells
set noundofile

noremap <silent> x "_x
noremap <silent> + <c-a>
noremap <silent> - <c-x>
noremap <silent> <c-a> gg<s-v>G

noremap <silent> te :tabedit<return>
noremap <silent> tc :tabclose<return>
noremap <silent> <tab> :tabnext<return>
noremap <silent> <s-tab> :tabprevious<return>

noremap <silent> ss :split<return>
noremap <silent> sv :vsplit<return>
noremap <silent> sh <c-w>h
noremap <silent> sj <c-w>j
noremap <silent> sk <c-w>k
noremap <silent> sl <c-w>l

noremap <silent> <left> <c-w><
noremap <silent> <down> <c-w>-
noremap <silent> <up> <c-w>+
noremap <silent> <right> <c-w>>

vnoremap <silent> J :m'>+1<return>gv
vnoremap <silent> K :m'<-2<return>gv

vnoremap <silent> ;nl :s/\\n/\\r\\r/g<return>:noh<return>
vnoremap <silent> ;dl :g/^$/d<return>:noh<return>

vnoremap <silent> ;uc gU
vnoremap <silent> ;lc gu

vnoremap <silent> ;st :sort i<return>
