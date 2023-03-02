""""""""""""""""""""
""" BASIC INFO
""""""""""""""""""""
" 
" Maintainer: jdbargas
"
" Sections:
"     -> BASIC INFO
"     -> LEADER
"     -> GENERAL
"     -> PLUGINS
"     -> MAP
"     -> COLOR
"     -> STATUSLINE
"     -> MISC

""""""""""""""""""""
""" LEADER
""""""""""""""""""""

" Set leader key
let mapleader = ","

" Leader maps defined here, all other maps defined in section below

" clear search highlights
noremap <leader><leader> :nohlsearch<cr>

""""""""""""""""""""
""" GENERAL
""""""""""""""""""""

" Use Vim settings not Vi
set nocompatible

" Turn on for correct colors in terminal
set termguicolors

" Turn on syntax highlighting, highlight strings in C comments
syntax enable
let c_comment_strings=1

" Disable mouse
set mouse=

" Open splits to the right, or below
set splitright
set splitbelow

" Turn off beeping and flashing
set visualbell
set t_vb=

" Allow backspacing in insert mode
set backspace=indent,eol,start

" Keep 2000 entries in history
set history=2000

" Show cursor position, display commands, display matches in statusline
set ruler
set showcmd
set wildmenu

" Timeout for key codes and wait up to 100ms 
set ttimeout
set ttimeoutlen=100

" Show a few lines of context around the cursor
set scrolloff=5

" Don't word wrap on open; don't wrap at window.
set nowrap
set textwidth=0

" Show hybrid line numbers (relative except for cursor line)
set number
set relativenumber

" Highlight cursor line
set cursorline

" Highlight 81st column to maintain < 80 char lines
set colorcolumn=81

" Tab and indent settings
set autoindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Use /g flag on :s substitutions by default
set gdefault

" Search
" <leader><leader> to clear search highlights
set hlsearch
set ignorecase
set smartcase
set incsearch
set showmatch 

" Allow vim to hide modified buffers without abandoning them
set hidden

" Don't redraw while executing macros (performance config)
set lazyredraw

" Display extra whitespace
set list
set listchars=nbsp:%,tab:▸\ ,trail:_,eol:¬,precedes:←,extends:→

" Don't increment in octal notation
set nrformats-=octal

" Enable file type detection
filetype plugin indent on

""""""""""""""""""""
""" PLUGINS
""""""""""""""""""""

" Download and install vim-plug if it doesn't already exist
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim-plug load plugins here
call plug#begin()

" Plugins to install with :PlugInstall
" Color Schemes
Plug 'NLKNguyen/papercolor-theme'
Plug 'tomasr/molokai'

call plug#end()

""""""""""""""""""""
""" MAP
""""""""""""""""""""

" noremap  -> map normal and visual
" nnoremap -> map normal
" inoremap -> map insert

" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" exit insert mode after opening new line below cursor
nnoremap o o<Esc>

" center search on screen when using n/N to cycle search results
noremap n nzz
noremap N Nzz

" use jk/kj as an alternate to <Esc> to avoid having to reach
inoremap jk <Esc>
inoremap kj <Esc>

" temp to get used to jk/kj instead of <Esc> 
inoremap <Esc> <Nop>

""""""""""""""""""""
""" COLOR
""""""""""""""""""""

" set colorscheme
set background=dark
colorscheme molokai

" override some highlight definitions
hi TabLineSel guibg=#808080 guifg=#FFFFFF gui=bold

" highlights for statusline
hi NormalModeSL         guibg=#808080     guifg=#292929   cterm=bold
hi InsertReplaceModeSL  guibg=red         guifg=#EEEEEE   cterm=bold
hi CommandModeSL        guibg=yellow      guifg=#444444   cterm=bold
hi VisualModeSL         guibg=lightgreen  guifg=#444444   cterm=bold
hi ModifiedFileSL       guibg=red         guifg=yellow    cterm=bold
hi FiletypeSL           guibg=#455354     guifg=#66D9EF   cterm=bold

""""""""""""""""""""
""" STATUSLINE
""""""""""""""""""""

" NOTE: highlights defined in COLOR section above
" 
" Show statusline
set laststatus=2

" component for active window
function! StatuslineActive()
  let l:filename = '» %t «'
  let l:mod = '%#ModifiedFileSL#%m%*'
  " `w:` is variable to current window
  " `l:` is variable to function. For more info :help E121
  let w:mode = StatuslineMode()
  let l:path = '%f'
  let l:lcp = '%l:%2c %3p%%'
  let l:type = '%#FiletypeSL#%12y%*'
  let l:sep = '%='
  return w:mode.' '.l:filename.' '.l:mod.l:sep.l:type.' '.l:path.' @ '.l:lcp
endfunction

" component for inactive window
function! StatuslineInactive()
  return '» %t «'
endfunction

" load statusline using `autocmd` event with this function
function! StatuslineLoad(mode)
  if a:mode ==# 'active'
    " to make it simple, %! is to evaluate the current changes in the window
    " it can be useful to evaluate current mode in statusline. For more info:
    " :help statusline.
    setlocal statusline=%!StatuslineActive()
  else
    setlocal statusline=%!StatuslineInactive()
  endif
endfunction

function! StatuslineMode() abort
  let l:currentmode={
        \ 'n':  ' NORMAL ',
        \ 'v':  ' VISUAL ',
        \ 'V':  ' V-LINE ',
        \ '^V': ' V-RECT ',
        \ 's':  ' SELECT ',
        \ 'S':  ' S-LINE ',
        \ '^S': ' S-RECT ',
        \ 'i':  ' INSERT ',
        \ 'R':  ' REPLACE ',
        \ 'c':  ' COMMAND ',
        \ 't':  ' TERM '}

  let l:modecurrent = mode()
  " use get() -> fails safely, since ^V doesn't seem to register
  " 3rd arg is used when return of mode() == 0, which is case with ^V
  " thus, ^V fails -> returns 0 -> replaced with 'VB'
  let l:modelist = toupper(get(l:currentmode, l:modecurrent, ' V-RECT '))
  let l:current_status = l:modelist

  " check mode type, assign color, reset color
  if l:modecurrent ==# 'n'
    let l:mode_color = '%#NormalModeSL#' 
  elseif l:modecurrent ==# 'i' || l:modecurrent == 'R'
    let l:mode_color = '%#InsertReplaceModeSL#'
  elseif l:modecurrent ==# 'c'
    let l:mode_color = '%#CommandModeSL#'
  elseif l:modecurrent == 'v' || l:current_status == ' V-RECT '
    let l:mode_color = '%#VisualModeSL#'
  else
    let l:mode_color = '%*'
  endif
  return l:mode_color.l:current_status.'%*'
endfunction

" so that autocmd didn't stack up and slow down vim
augroup statusline_startup
  autocmd!
  " for more info :help WinEnter and :help BufWinEnter
  autocmd WinEnter,BufWinEnter * call StatuslineLoad('active')
  autocmd WinLeave * call StatuslineLoad('inactive')
augroup END

""""""""""""""""""""
""" MISC
""""""""""""""""""""

" Command kept from original .vimrc
" See the diff between the current buffer and the file it was loaded from
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
