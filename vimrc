set history=10000
filetype plugin indent on
syntax on
set ttyfast
set encoding=utf-8

let $CFGDIR='~/.vim'
let $DATADIR=empty($XDG_DATA_HOME) ? $HOME.'/.local/share/vim' : $XDG_DATA_HOME.'/vim'
let &viewdir=$DATADIR.'/view'

runtime settings.vim
