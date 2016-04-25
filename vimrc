set nocompatible
filetype off

" Vundle
" Use vundle for plugin management
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" Plugins
" For writing
Plugin 'junegunn/goyo.vim'
Plugin 'reedes/vim-pencil'

" Language
" Erlang
Plugin 'vim-erlang/vim-erlang-runtime'
Plugin 'vim-erlang/vim-erlang-compiler'
Plugin 'vim-erlang/vim-erlang-omnicomplete'
Plugin 'vim-erlang/vim-erlang-tags'
Plugin 'vim-erlang/vim-erlang-skeletons'
" Elixir
Plugin 'elixir-lang/vim-elixir'
" JavaScript
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'elzr/vim-json'
" Lua
Plugin 'xolox/vim-misc' " required by vim-lua-ftplugin
Plugin 'xolox/vim-lua-ftplugin'
" Markdown
Plugin 'plasticboy/vim-markdown'
" SASS/SCSS/Less/CSS
Plugin 'groenewege/vim-less'
Plugin 'cakebaker/scss-syntax.vim'
" Plugin 'ap/vim-css-color'
" Haml
Plugin 'tpope/vim-haml'
" Go
Plugin 'fatih/vim-go'

" For frameworks
Plugin 'tpope/vim-rails'
Plugin 'burnettk/vim-angular'

" For productivity
Plugin 'tpope/vim-ragtag'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'xolox/vim-easytags'
Plugin 'godlygeek/tabular'
Plugin 'ervandew/supertab'
Plugin 'airblade/vim-gitgutter'
Plugin 'nathanaelkane/vim-indent-guides'

call vundle#end()

" File type settings (file type-specific settings in vim/ftplugin/)
" Enable filetype plugin
filetype plugin indent on
autocmd BufRead,BufNewFile *.txt setfiletype text
autocmd BufRead,BufNewFile *.app setfiletype erlang
autocmd BufRead,BufNewFile *.app.src setfiletype erlang
autocmd BufRead,BufNewFile sys.config setfiletype erlang
autocmd BufRead,BufNewFile Gemfile setfiletype ruby
autocmd BufRead,BufNewFile Vagrantfile setfiletype ruby
autocmd BufRead,BufNewFile Dockerfile setfiletype bash

let g:pencil#wrapModeDefault = 'soft'

" TODO: Turn on goyo for markdown and text files as well
augroup pencil
    autocmd!
    autocmd FileType mkd.markdown,markdown,mkd call pencil#init()
    autocmd FileType text         call pencil#init()
augroup END

" General settings
syntax on
set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set guifont=Monaco:h12
set background=dark
set showmatch
set hlsearch
set colorcolumn=80

" Show pastetoggle status
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Turn on cursor column highlighting
set cursorcolumn

" set the color scheme
colorscheme solarized

" Make background transparent since we are using solarized in the terminal
let g:solarized_termtrans = 1
set t_Co=16

" Ignored files
set wildignore+=/tmp/,*.so,*.swp,*.swo,*.zip,*.meta,*.prefab,*.png,*.jpg,*.beam

" Allow hidden buffers
set hidden

set runtimepath^=~/.vim/bundle/ctrlp.vim

" Shortcuts ============================
let mapleader = ","
map ; :
map  <Esc> :w
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
map <Leader>s <esc>:w<CR>
map <Leader>m :Rmodel
imap <esc>:tabn <F7>
map gT <F8>
map gt <F7>
map :tabn <F8>
map :tabp <F7>
map <Leader>cr <F5>

if has("gui_running")
  set guioption=-t
endif

" Disable arrow keys
nnoremap <Left> :echoe "Use h"<cr>
nnoremap <Right> :echoe "Use l"<cr>
nnoremap <Up> :echoe "Use k"<cr>
nnoremap <Down> :echoe "Use j"<cr>
inoremap <Left> <esc> :echoe "Use h"<cr>
inoremap <Right> <esc> :echoe "Use l"<cr>
inoremap <Up> <esc> :echoe "Use k"<cr>
inoremap <Down> <esc> :echoe "Use j"<cr>

" Allow replacing of searched text by using `cs` on the first result and `n.`
" on all consecutive results
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
            \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

" NERDTree settings
nmap <silent> <F3> :NERDTreeToggle<CR>
set guioptions-=T
let NERDTreeShowHidden=1

" CtrlP directory mode
let g:ctrlp_working_path_mode = 0

"open CtrlP in buffer mode
nnoremap <leader>b :CtrlPBuffer<CR>

" custom CtrlP ignores toggle
function! ToggleCtrlPIgnores()
    if exists("g:ctrlp_user_command")
        " unset the ignores
        let g:ctrlp_custom_ignore = {}
        unlet g:ctrlp_user_command
    else
        " always ignore these patterns
        let g:ctrlp_custom_ignore = {
                    \'dir': 'ebin\|DS_Store\|git$\|bower_components\|node_modules\|logs',
                    \'file': '\v\.(beam|pyc|swo)$',
                    \}
        " also ignore files listed in the .gitignore
        let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
    end
endfunction

call ToggleCtrlPIgnores()
:nnoremap <F6> call ToggleCtrlPIgnores()<CR>

" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Hide everything that occupies space on the left side of the file, so we can
" copy the file contents with ease
function! ToggleLeftGuides()
    " Toggle line numbers
    :set number!

    " Toggle GitGutter
    :GitGutterToggle

    " Reset Syntastic, then set it to passive mode
    " TODO: Hide syntastic hints as well
    :SyntasticToggle
    :SyntasticReset
endfunction

:nnoremap <F4>  :call ToggleLeftGuides()<CR>

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

" Custom status bar
set statusline=\ Filename:%-8t                               " Filename
set statusline+=\ Encoding:\%-8{strlen(&fenc)?&fenc:'none'}   " File encoding
set statusline+=\ Line\ Endings:%-6{&ff}                      " Line Endings
set statusline+=\ File\ Type:%-12y                            " File Type
set statusline+=%=%h%m%r%c,%l/%L\ %P        " Cursor location and file status
set laststatus=2
" Color status bar
highlight statusline ctermfg=cyan ctermbg=black guifg=cyan guibg=black

" allow yanking to OSX clipboard
" http://stackoverflow.com/questions/11404800/fix-vim-tmux-yank-paste-on-unnamed-register
if $TMUX == ''
    set clipboard+=unnamed
endif

" Start CtrlP on startup
autocmd VimEnter * CtrlP

" Automatically reload .vimrc
autocmd! BufWritePost .vimrc,*vimrc source %

" Keep vim ctags in the tags file like normal
let easytags_file = '~/tags'

" Write to project specific tag file if it exists
set tags=./tags;
let easytags_dynamic_files = 1
let easytags_async = 1

" Vim-Erlang Skeleton settings
let g:erl_replace_buffer=0
" TODO: Figure out how to copy default erlang templates into our custom dir
" let g:erl_tpl_dir="~/.erlang_templates"

" Load in custom config if it exists
let custom_vimrc='~/dotfiles/mixins/vimrc.custom'
if filereadable(custom_vimrc)
    source custom_vimrc
end
