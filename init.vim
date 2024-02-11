set number
set rnu
syntax on
set nocompatible
filetype on
filetype plugin on
filetype indent on
set clipboard+=unnamedplus
set cursorline
set cursorcolumn
set shiftwidth=2
set tabstop=2
set expandtab
set nobackup
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set showcmd
set showmode
set showmatch
set hlsearch
set splitbelow
set history=1000
set wildmenu
set undofile
set undodir=~/.vim/undodir
let mapleader = " "
set pumheight=10

"Lexplorer---------------------------------------------------------------- {{{
let g:netrw_keepdir = 0
let g:netrw_banner = 0
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = 27
nnoremap <Leader>e :Ex <CR>
"}}}

"------------------------------------------------------------------------ }}}

vmap <C-c> "+y
vmap <C-x> "+c
nnoremap <Leader>c :bd<CR>
nnoremap <Leader>h :nohls<CR>
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprevious<CR>
nnoremap <Leader>u :MundoToggle<CR>
colorscheme slate

"}}}

"Resize-Splits ---------------------------------------------------------- {{{
nnoremap <A-l> :vertical resize +5<CR>
nnoremap <A-h> :vertical resize -5<CR>
nnoremap <A-j> :resize -5<CR>
nnoremap <A-k> :resize +5<CR>
"}}}


"STATUS LINE ------------------------------------------------------------ {{{
set statusline=
set statusline+=\ %F\ %M\ %Y\ %R\ %{coc#status()}%{get(b:,'coc_current_function','')}\ %{LinterStatus()}
set statusline+=%=
set statusline+=\ git:\ %{GitStatus()}\ \|\ row:\ %l\ col:\ %c\ percent:\ %p%%
set laststatus=2
" }}}

"FZF--------------------------------------------------------------------  {{{
nnoremap <silent> <Leader>sb :Buffers<CR>
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <Leader>sg :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>
"----------------------------------------------------------------------   }}}

"Plugins----------------------------------------------------------------- {{{
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tribela/vim-transparent'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'xianzhon/vim-code-runner'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo'
call plug#end()
"------------------------------------------------------------------------ }}}

"Code-Runner ------------------------------------------------------------ {{{
nmap <silent><leader>bb <plug>CodeRunner
let g:code_runner_save_before_execute = 1

let g:CodeRunnerCommandMap = {
        \ 'python' : 'python3 $fileName',
        \ 'cpp' : 'clang++ -std=c++17 $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt',
        \ 'c' : 'clang $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt',
        \ 'java' : 'javac $fileName && java $fileNameWithoutExt',
        \ 'go' : 'go run $fileName',
        \ 'javascript' : 'node $fileName',
        \ 'typescript' : 'ts-node $fileName',
      \}
"------------------------------------------------------------------------ }}}

"Coc--------------------------------------------------------------------- {{{
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Vim-gutter ------------------------------------------------------ {{{
function! GitStatus()
    let [a,m,r] = GitGutterGetHunkSummary()
      return printf('+%d ~%d -%d', a, m, r)
endfunction
" }}}

" Vim-Fugitive ---------------------------------------------------- {{{
nnoremap <Leader>gg :Git<CR>
"}}}

" Ale ------------------------------------------------------------- {{{
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? 'OK' : printf(
        \   '%dW %dE',
        \   all_non_errors,
        \   all_errors
        \)
endfunction
"}}}
