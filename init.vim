function! HTry(function, ...)
  if exists('*'.a:function)
    return call(a:function, a:000)
  else
    return ''
  endif
endfunction

filetype plugin indent on

set nocompatible
set autoindent
set autoread
set backspace=indent,eol,start
set complete-=i      " Searching includes can be slow
set display=lastline " When lines are cropped at the screen bottom, show as much as possible
set incsearch
set laststatus=2    " Always show status line
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set list            " show trailing whiteshace and tabs
set modelines=5
set scrolloff=1
set sidescrolloff=5
set showcmd
set showmatch
set smarttab
if &statusline == ''
  set statusline=[%n]\ %<%.99f\ %h%w%m%r%{HTry('CapsLockStatusline')}%y%{HTry('rails#statusline')}%{HTry('fugitive#statusline')}%#ErrorMsg#%{HTry('SyntasticStatuslineFlag')}%*%=%-16(\ %l,%c-%v\ %)%P
endif
set ttimeoutlen=50  " Make Esc work faster
set wildmenu
set rtp+=/usr/local/opt/fzf

let g:netrw_dirhistmax = 0
let mapleader="\<Space>"

command! -bar -nargs=* -bang W :write<bang> <args>
command! -bar -range=% Trim :<line1>,<line2>s/\s\+$//e

map Y       y$
nnoremap <silent> <C-L> :nohls<CR><C-L>

" Emacs style mappings
inoremap          <C-A> <C-O>^
cnoremap          <C-A> <Home>

nmap \\           <Plug>NERDCommenterInvert
xmap \\           <Plug>NERDCommenterInvert

" Enable TAB indent and SHIFT-TAB unindent
vnoremap <silent> <TAB> >gv
vnoremap <silent> <S-TAB> <gv

augroup vimrc
  autocmd!
  autocmd GuiEnter * set guifont=Monaco:h16 guioptions-=T columns=120 lines=70 number
augroup END

autocmd BufRead,BufNewFile *.hamlc setlocal filetype=haml
autocmd FileType go setlocal shiftwidth=4 tabstop=4 expandtab
autocmd FileType handlebars setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType asm setlocal shiftwidth=8 tabstop=8 expandtab
autocmd BufNewFile,BufRead *.haml             set ft=haml
autocmd FileType javascript             setlocal et sw=2 sts=2 isk+=$
autocmd FileType html,xhtml,css         setlocal et sw=2 sts=2
autocmd FileType eruby,yaml,ruby        setlocal et sw=2 sts=2
autocmd FileType cucumber               setlocal et sw=2 sts=2
autocmd FileType gitcommit              setlocal spell
autocmd FileType ruby                   setlocal comments=:#\  tw=79
autocmd FileType vim                    setlocal et sw=2 sts=2 keywordprg=:help
autocmd Syntax   css  syn sync minlines=50
autocmd User Rails nnoremap <buffer> <D-r> :<C-U>Rake<CR>
autocmd User Rails nnoremap <buffer> <D-R> :<C-U>.Rake<CR>

colorscheme afterglow

set number

map <leader>] :bnext<CR>
map <leader>[ :bprevious<CR>
map <leader>t :FZF<CR>

imap dt5 <!DOCTYPE html>

noremap ,s :source ~/.vimrc.local

if has("termguicolors")
  set termguicolors
endif

if $TERM == '^\%(screen\|xterm-color\)$' && t_Co == 8
  set t_Co=16
endif

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
