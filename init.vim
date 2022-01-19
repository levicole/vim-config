function! HTry(function, ...)
  if exists('*'.a:function)
    return call(a:function, a:000)
  else
    return ''
  endif
endfunction

function! MarkdownToHtml()
  let file = expand('%:t:r') execute(':!showdown makehtml -i % -o '. file . '.html')
endfunction

" Annotations Gem adds table info to the top of models and their associated
" specs. This gets called everytime I open a model.
function! JumpToClassDef()
  if RailsFileType() == 'model'
    call search('class [A-Z]')
  elseif RailsFileType() == 'rspec-model'
    call search('describe [A-Z]')
  endif
endfunction

filetype plugin indent on


" Settings
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

" Spacemacs ruined me...
let mapleader="\<Space>"

command! -bar -nargs=* -bang W :write<bang> <args>
command! -bar -range=% Trim :<line1>,<line2>s/\s\+$//e

nnoremap Y       y$
nnoremap <silent> <C-L> :nohls<CR><C-L>

" Emacs style mappings
inoremap          <C-A> <C-O>^
cnoremap          <C-A> <Home>

" Enable TAB indent and SHIFT-TAB unindent
vnoremap <silent> <TAB> >gv
vnoremap <silent> <S-TAB> <gv

augroup vimrc
  autocmd!
  autocmd GuiEnter * set guifont=Hack:h16 guioptions-=T columns=120 lines=70 number
augroup END

augroup file_type_settings
  autocmd!
  autocmd BufRead,BufNewFile *.hamlc setlocal filetype=haml
  autocmd FileType go setlocal shiftwidth=4 tabstop=4 expandtab
  autocmd FileType handlebars setlocal shiftwidth=2 tabstop=2 expandtab
  autocmd FileType asm setlocal shiftwidth=8 tabstop=8 expandtab
  autocmd BufNewFile,BufRead *.haml             set ft=haml
  autocmd FileType javascript             setlocal et sw=2 sts=2 isk+=$
  autocmd FileType html,xhtml,css         setlocal et sw=2 sts=2
  autocmd FileType eruby,yaml,ruby        setlocal et sw=2 sts=2 omnifunc=rubycomplete#Complete
  autocmd FileType cucumber               setlocal et sw=2 sts=2
  autocmd FileType gitcommit              setlocal spell
  autocmd FileType ruby                   setlocal comments=:#\  tw=79
  autocmd FileType vim                    setlocal et sw=2 sts=2 keywordprg=:help
  autocmd FileType sql                    setlocal et sw=2 sts=2
  autocmd Syntax   css  syn sync minlines=50
augroup END

" Rails/Rspec/Ruby
augroup rails_commands
  autocmd!

  autocmd User Rails nnoremap <buffer> <D-r> :<C-U>Rake<CR>
  autocmd User Rails nnoremap <buffer> <D-R> :<C-U>.Rake<CR>
  autocmd User Rails call JumpToClassDef()
augroup END

augroup sql_commands
  autocmd!
  " Starts an async psql job, prompting for the psql arguments.
  " Also opens a scratch buffer where output from psql is directed.
  autocmd FileType sql noremap <leader>po :VipsqlOpenSession<CR>

  " Terminates psql (happens automatically if the scratch buffer is closed).
  autocmd FileType sql noremap <silent> <leader>pk :VipsqlCloseSession<CR>

  " In normal-mode, prompts for input to psql directly.
  autocmd FileType sql nnoremap <leader>ps :VipsqlShell<CR>

  " In visual-mode, sends the selected text to psql.
  autocmd FileType sql vnoremap <leader>ps :VipsqlSendSelection<CR>

  " Sends the selected _range_ to psql.
  autocmd FileType sql noremap <leader>pr :VipsqlSendRange<CR>

  " Sends the current line to psql.
  autocmd FileType sql noremap <leader>pl :VipsqlSendCurrentLine<CR>

  " Sends the entire current buffer to psql.
  autocmd FileType sql noremap <leader>pb :VipsqlSendBuffer<CR>

  " Sends `SIGINT` (C-c) to the psql process.
  autocmd FileType sql noremap <leader>pc :VipsqlSendInterrupt<CR>

  autocmd BufRead __vipsql__ setlocal nowrap
augroup END

au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

let g:racer_experimental_completer = 1

map <Leader>s :call RunNearestSpec()<CR>
let g:rspec_command = "Dispatch spring rspec {spec}"


" Plugin settings / Custom Mappings

" Commenting out with NERDCommenter
nmap \\           <Plug>NERDCommenterInvert
xmap \\           <Plug>NERDCommenterInvert

" split join
let g:splitjoin_ruby_hanging_args=0
let g:splitjoin_ruby_curly_braces=0

map <leader>] :bnext<CR>
map <leader>[ :bprevious<CR>
map <leader>t :FZF<CR>
map <leader>pf :FZF<CR>
map <leader>/ :Ag<CR>

imap dt5 <!DOCTYPE html>

" Open my vimrc like I would open my .spacemacs config
" Like I said, spacemacs ruined me ;)
nnoremap <leader>fed :vsplit $MYVIMRC<cr>
nnoremap <leader>fer :source $MYVIMRC<cr>
nnoremap <leader>feR :source $MYVIMRC<cr>
nnoremap <leader>; :
inoremap ;; <esc>:

noremap ,s :source ~/.vimrc.local

" Colors / UI
if has("termguicolors")
  set termguicolors
endif

set number

colorscheme nova
set background=dark

if $TERM == '^\%(screen\|xterm-color\)$' && t_Co == 8
  set t_Co=16
endif

if &term =~ '256color'
   "disable Background Color Erase (BCE) so that color schemes
   "render properly when inside 256-color tmux and GNU screen.
   "see also http://snk.tuxfamily.org/log/vim-256color-bce.html
   set t_ut=
endif


" I mispell things a lot:
iabbrev fundemental fundamental
iabbrev Fundemental Fundamental
