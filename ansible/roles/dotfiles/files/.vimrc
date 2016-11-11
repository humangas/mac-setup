""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ~/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Base
set nobackup                                        "No create backup file.
set noswapfile                                      "No create swap file.
set autoread                                        "Rereading Automatic When the file being edited is changed.
set hidden                                          "Buffer is to be opened in the editing.
set showcmd                                         "To view the command in the input to the status.
set paste                                           "At the time of paste, not indented.
set mouse=a                                         "To enable the mouse operation.
set confirm                                         "To make sure when there are unsaved files.
set visualbell t_vb=                                "Disable all the beep.
set noerrorbells                                    "Not sound the beep at the time of display of error messages.
set clipboard=unnamed,autoselect                    "To insert the selected text in visual mode to the clipboard. & Share the clipboard.
set backspace=indent,eol,start                      "Backspace key so as to operate normally.
set history=100                                     "The number of command history

" Tab
set expandtab                                       "Convert tabs to spaces.
set shiftwidth=2                                    "Display width of the Tab character at the beginning of a line.
set tabstop=2                                       "Display width of the Tab character other than the beginning of the line.

" Search
set ignorecase                                      "Search not case sensitive.
set smartcase                                       "If the search string contains upper-case letters, to search by distinguishing.
set incsearch                                       "To enable incremental search.
set wrapscan                                        "Search to the end, go back to the beginning.
set hlsearch                                        "Search result hilight.
"To turn off the highlight in the Esc key * 2.
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>

" Completion
set wildmenu wildmode=list:longest,full             "At the time of the command mode, to supplement the command with the Tab key.
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll           "Ignore Pattern when the complement.

" View
set title                                           "To display the name of the file being edited.
set number                                          "View number count.
set ruler                                           "Display ruler.
set cursorline                                      "Currently highlight the line.
set cursorcolumn                                    "Currently highlight the line (column).
set showmatch                                       "Input parentheses, to highlight the corresponding brackets.
set laststatus=2                                    "Display the status line in the second row from the end.

" Plugin Shougo/dein.vim
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('/Users/humangas/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
call dein#add('Shougo/neosnippet.vim')                                      "Adds snippet support to Vim.
call dein#add('Shougo/neosnippet-snippets')                                 "The standard snippets repository for 'neosnippet.vim'.
call dein#add('Shougo/unite.vim')                                           "Search and display information from arbitrary sources like files, buffers, etc.
call dein#add('Shougo/vimfiler')                                            "Powerful file explorer implemented by Vim script
call dein#add('Shougo/denite.nvim')                                         "Dark powered asynchronous unite all interfaces for Neovim/Vim8
call dein#add('Shougo/neocomplete.vim')                                     "Next generation completion framework after neocomplcache
call dein#add('altercation/vim-colors-solarized')                           "Colorscheme: solarized
call dein#add('itchyny/lightline.vim')                                      "A light and configurable statusline/tabline for Vim
call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })  "fzf is a general-purpose command-line fuzzy finder.
call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })                     "vim plugin fzf
call dein#add('kannokanno/previm')                                          "Realtime preview by Vim. (Markdown, reStructuredText, textile)
call dein#add('davidhalter/jedi-vim')                                       "VIM binding to the autocompletion library Jedi(for Python).
call dein#add('fatih/vim-go')                                               "Go development plugin for Vim

" You can specify revision/branch/tag.
call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" Color scheme
syntax enable
set background=dark
colorscheme solarized

" Plugin itchyny/lightline.vim 
let g:lightline = {}
let g:lightline.colorscheme = 'solarized'

" Plugin altercation/vim-colors-solarized
let g:solarized_termtrans=1                            "Terminal at the time of the transparent background, to enable transparent background of Solarized.

" Plugin kannokanno/previm 
let g:previm_open_cmd = 'open -a Safari'

" Plugin Shougo/vimfiler
let g:vimfiler_as_default_explorer = 1

