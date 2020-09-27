" Install and configure plug.vim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'plasticboy/vim-markdown'
call plug#end()

"=====================================================
"===================== SETTINGS ======================

set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically reread changed files without asking me anything
set autoindent
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
" set mouse=a                     "Enable mouse mode

set noerrorbells             " No beeps
set number                   " Show line numbers
set showcmd                  " Show me what I'm typing
set noswapfile               " Don't use swapfile
set nobackup                 " Don't create annoying backup files
set splitright               " Split vertical windows right to the current windows
set splitbelow               " Split horizontal windows below to the current windows
set autowrite                " Automatically save before :next, :make etc.
set hidden
set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 formats
set noshowmatch              " Do not show matching brackets by flickering
set noshowmode               " We show the mode with airline or lightline
set ignorecase               " Search case insensitive...
set smartcase                " ... but not it begins with upper case
set completeopt=longest,menuone
set nocursorcolumn           " speed up syntax highlighting
set nocursorline
" set updatetime=300
" set pumheight=10             " Completion window max size
" set conceallevel=2           " Concealed text is completely hidden

" set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

set title

"=====================================================
"===================== MAPPINGS ======================

let mapleader = ","

" highlight stays so get rid
nmap <Leader>h :noh<cr>

nnoremap <Leader>no :set number<cr>
nnoremap <Leader>non :set nonumber<cr>


" https://vim.fandom.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
" :set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


" Quickfix
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
" nnoremap <leader>a :cclose<CR>
" https://www.reddit.com/r/golang/comments/5k28lo/vimgo_anyone_knows_a_good_way_to_close_both/
nnoremap <silent> <leader>a :cclose<CR>:lclose<CR>

" Navigate easier between splits e.g. go impl and go test
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"=====================================================
"===================== PLUGINS ======================


"===================== NERDTRee  ======================
nmap <Leader>tree :NERDTreeToggle<CR>
nmap <Leader>treef :NERDTreeFind<cr>

let NERDTreeShowHidden=1

"===================== lightline ======================
" From https://github.com/maximbaz/lightline-ale
let g:lightline = {}
" https://github.com/itchyny/lightline.vim/issues/71
set laststatus=2
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }

let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" ==================== vim-go ====================
" https://github.com/fatih/vim-go/pull/2577 and https://github.com/fatih/vim-go/issues/2366
let g:go_gorename_command = 'gopls'

let g:go_fmt_command = "goimports"

augroup go
  autocmd!

  autocmd FileType go nmap <silent> <Leader>v <Plug>(go-def-vertical)
  autocmd FileType go nmap <silent> <Leader>s <Plug>(go-def-split)
  autocmd FileType go nmap <silent> <Leader>d <Plug>(go-def-tab)

  autocmd FileType go nmap <silent> <Leader>x <Plug>(go-doc-vertical)

  autocmd FileType go nmap <silent> <Leader>i <Plug>(go-info)
  autocmd FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)

  autocmd FileType go nmap <silent> <leader>b :<C-u>call <SID>build_go_files()<CR>
  autocmd FileType go nmap <silent> <leader>t  <Plug>(go-test)
  autocmd FileType go nmap <silent> <leader>r  <Plug>(go-run)
  autocmd FileType go nmap <silent> <leader>e  <Plug>(go-install)

  autocmd FileType go nmap <silent> <Leader>c <Plug>(go-coverage-toggle)

  " I like these more!
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
  autocmd filetype go inoremap <buffer> . .<C-x><C-o>
" Not filtering nicely so switching off for now
" au filetype go inoremap <buffer> . .<C-x><C-o>

  " OLD CONFIG
" autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
" autocmd FileType go nmap <leader>r  <Plug>(go-run)
" autocmd FileType go nmap <leader>t  <Plug>(go-test)
" autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
" au Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
" au Filetype go nmap <leader>gah <Plug>(go-alternate-split)
" au Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)
augroup END

" ==================== authors settings ====================
" authors settings https://github.com/fatih/dotfiles/blob/master/vimrc
"
" https://github.com/fatih/vim-go/issues/247#issuecomment-64779382
" use go build instead of autolinting for listing linting issues
let g:go_fmt_fail_silently = 1

let g:go_fmt_command = "goimports"
let g:go_debug_windows = {
      \ 'vars':  'leftabove 35vnew',
      \ 'stack': 'botright 10new',
\ }

let g:go_test_prepend_name = 1
let g:go_list_type = "quickfix"
let g:go_auto_type_info = 0
let g:go_auto_sameids = 0

let g:go_null_module_warning = 0
let g:go_echo_command_info = 1

let g:go_autodetect_gopath = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_metalinter_enabled = ['vet', 'golint']
" mine was...
" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
" let g:go_metalinter_autosave = 1

let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
" mine was...
" let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_types = 0
" mine was...
" let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_format_strings = 0
let g:go_highlight_function_calls = 0
" mine was...
" let g:go_highlight_function_calls = 1
" mine was but not present in authors so leaving out...
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_structs = 1

let g:go_gocode_propose_source = 1

let g:go_modifytags_transform = 'camelcase'
let g:go_fold_enable = []
" mine was...
" let g:go_fold_enable = ['block', 'import', 'varconst', 'package_comment']

nmap <C-g> :GoDecls<cr>
imap <C-g> <esc>:<C-u>GoDecls<cr>

" ==================== remains of my original settings ====================
" mine still is...
set foldmethod=syntax
set foldlevelstart=20

" Set whether the JSON tags should be snakecase or camelcase.
let g:go_addtags_transform = "snakecase"

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

" Fix for issue with folding on save as described in https://github.com/fatih/vim-go/issues/502
let g:go_fmt_experimental = 1

" https://github.com/fatih/vim-go/issues/2271#issuecomment-489470535 and :messages
" let g:go_test_show_name=1

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" create a go doc comment based on the word under the cursor
function! s:create_go_doc_comment()
  norm! "zyiw
  execute ":put! z"
  execute ":norm! I// \<Esc>A ...\<Esc>"
endfunction
nnoremap <leader>doc :<C-u>call <SID>create_go_doc_comment()<CR>

" wrap long lines in quickfix
" https://github.com/fatih/vim-go/issues/1271
augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap
    autocmd FileType qf setlocal statusline=\ %n\ \ %f%=%L\ lines\
augroup END


