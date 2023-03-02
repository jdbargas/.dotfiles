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

"""""""""""""""""""
""" LEADER
""""""""""""""""""""

" Set leader key
let mapleader = ","

""""""""""""""""""""
""" GENERAL
""""""""""""""""""""

" Use Vim settings not Vi
set nocompatible

" Turn on for correct colors in terminal
set termguicolors

" Turn on syntax highlighting
syntax enable
let c_comment_strings=1 " highlight strings inside C comments

" Disable mouse
set mouse=

" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Turn off beeping and flashing
set visualbell
set t_vb=

" Allow backspacing in insert mode
set backspace=indent,eol,start

set history=2000 " keep 2000 lines of of cli history
set ruler "show the cursor position at all times
set showcmd " display incomplete commands
set wildmenu " display completion matches in status line

set ttimeout " time out for key codes
set ttimeoutlen=100 " wait up to 100ms after Esc for any special keys

" Show a few lines of context around the cursor
set scrolloff=5

" Don't word wrap on open, or on long lines when typing
set nowrap
set formatoptions-=t

" Show hybrid line numbers (relative except for cursor line)
set number
set relativenumber

" Highlight cursor line
set cursorline

" Highlight 81st column to maintain < 80 char lines
set colorcolumn=81

" Tab and indent settings
set autoindent
set tabstop=2 " number of spaces a tab in the file counts for
set softtabstop=2 " number of spaces a tab uses while editing
set shiftwidth=2 " number of spaces << or >> will use
set expandtab " insert spaces instead of tabs

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

"""""""""""
""" MAP
"""""""""""
"
" noremap  -> map normal and visual
" nnoremap -> map normal
" inoremap -> map insert

" exit insert mode after opening new line below cursor
nnoremap o o<Esc>

" clear search highlights
noremap <leader><leader> :nohlsearch<cr>

""""""""""""""""""""
""" COLOR
""""""""""""""""""""

" set colorscheme
set background=dark
colorscheme molokai

" override some highlight definitions
hi TabLineSel guibg=#808080 guifg=#FFFFFF gui=bold

" highlights for statusline
hi NormalModeSL         guibg=lightgreen  guifg=#444444   cterm=bold
hi InsertReplaceModeSL  guibg=red         guifg=#eeeeee   cterm=bold
hi CommandModeSL        guibg=yellow      guifg=#444444   cterm=bold
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
  let l:modelist = toupper(get(l:currentmode, l:modecurrent, 'VB'))
  let l:current_status = l:modelist

  " check mode type, assign color, reset color
  if l:current_status ==# ' NORMAL '
    let l:mode_color = '%#NormalModeSL#' 
  elseif l:current_status ==# ' INSERT ' || l:current_status == ' REPLACE '
    let l:mode_color = '%#InsertReplaceModeSL#'
  elseif l:current_status ==# ' COMMAND '
    let l:mode_color = '%#CommandModeSL#'
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

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
