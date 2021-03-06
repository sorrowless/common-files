set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'rodjek/vim-puppet'
Plugin 'davidhalter/jedi-vim'

call vundle#end()            " required
filetype plugin indent on    " required

" NerdTree plugin settings
map <C-n> :NERDTreeToggle<CR>

" syntastic plugin settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_puppet_checkers = [ 'puppet', 'puppetlint' ]

" ctrlp plugin settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ -g ""'

" jedi-vim plugin settings
let g:jedi#use_tabs_not_buffers = 1  " allow use tabs for goto jumps

" No compatible with vi
"set nocompatible

" help with backspace
set backspace=indent,eol,start

" Use spaces instead of tabs
set expandtab

" 1 tab == 4 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Be smart when using tabs ;)
set smarttab

" Wrap lines explicitly
"set wrap
" and set a newline after 80 characters
"set tw=80
" and linebreak only at characters in breakat
"set linebreak

set autoindent " ai - Auto indent - copy indentation from previous line
set smartindent " si - Smart indent - insert one more indent in some cases

set encoding=utf-8

" Always show status line
set laststatus=2
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " filename
set statusline+=%h%m%r%w                     " status flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type
set statusline+=%=                           " right align remainder
set statusline+=0x%-8B                       " character value
set statusline+=%-14(%l,%c%V%)               " line, character
set statusline+=%<%P

set ruler

" Search like in browsers
set incsearch

" Highlight search results
set hlsearch

" Ignore case when searching
set ignorecase

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

set wildmenu
set showmode

" Set to auto read when a file is changed from the outside
set autoread

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

syntax on " highlight syntax
"colorscheme darkblue
colorscheme desert

"filetype on
filetype plugin on
filetype indent on

imap ii <Esc>

" Delete trailing white space on save, useful for Python and Puppet
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.pp :call DeleteTrailingWS()

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Toggle relative and absolute numbers by C-n
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

"nnoremap <C-n> :call NumberToggle()<cr>

" Set relative number lines
set relativenumber

" Remember cursor position
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

" Keep some lines when scrolling
set scrolloff=5

set foldenable " включить фолдинг
"set foldmethod=syntax " определять блоки на основе синтаксиса файла
set foldmethod=indent " определять блоки на основе отступов
set foldcolumn=3 " показать полосу для управления сворачиванием
set foldlevel=1 " Первый уровень вложенности открыт, остальные закрыты
"set foldopen=all " автоматическое открытие сверток при заходе в них

" Auto remove trailing spaces
autocmd BufWritePre * :%s/\s\+$//e

" highlight symbols after 80
set t_Co=256
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" add line that show you 80 chars border
set colorcolumn=80
" it will work only if your terminal supports 256 colors properly
highlight ColorColumn ctermbg=233

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving and quit
nmap <leader>w :w!<cr>

" Fast quit
nmap <leader>q :q!<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" set W to be 'sudo w'
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Wq is ok
command! Wq wq

" Map Alt+<number> to switch between tabs
nmap 1 1gt
nmap 2 2gt
nmap 3 3gt
nmap 4 4gt
nmap 5 5gt
nmap 6 6gt
nmap 7 7gt
nmap 8 8gt
nmap 9 9gt
