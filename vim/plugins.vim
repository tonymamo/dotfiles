" Vundle
" Use vundle for plugin management
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" Plugins
" Tmux
" Disabled this plugin because it broke the C-l mapping to refresh Vim
" Plugin 'christoomey/vim-tmux-navigator'
" For writing
Plugin 'junegunn/goyo.vim'
Plugin 'reedes/vim-pencil'
Plugin 'christoomey/vim-titlecase'

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
" CoffeeScript
Plugin 'kchmck/vim-coffee-script'
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
" Mustache
Plugin 'mustache/vim-mustache-handlebars'

" For frameworks
"Plugin 'tpope/vim-rails'
"Plugin 'burnettk/vim-angular'

" For productivity
Plugin 'tpope/vim-ragtag'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'majutsushi/tagbar'
Plugin 'godlygeek/tabular'
Plugin 'ervandew/supertab'
Plugin 'airblade/vim-gitgutter'
Plugin 'nathanaelkane/vim-indent-guides'

call vundle#end()

filetype plugin indent on
