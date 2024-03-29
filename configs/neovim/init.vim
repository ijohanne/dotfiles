"Basic settings
" nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

EOF

" Closes nerdtree upon open
let NERDTreeQuitOnOpen=1

" Setup vim-crates plugin
autocmd BufRead Cargo.toml call crates#toggle()

" setup barbar
" Magic buffer-picking mode
nnoremap <silent> <C-s> :BufferPick<CR>
" Sort automatically by...
nnoremap <silent> <Space>bd :BufferOrderByDirectory<CR>
nnoremap <silent> <Space>bl :BufferOrderByLanguage<CR>
" Move to previous/next
nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
nnoremap <silent>    <A->> :BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    <A-1> :BufferGoto 1<CR>
nnoremap <silent>    <A-2> :BufferGoto 2<CR>
nnoremap <silent>    <A-3> :BufferGoto 3<CR>
nnoremap <silent>    <A-4> :BufferGoto 4<CR>
nnoremap <silent>    <A-5> :BufferGoto 5<CR>
nnoremap <silent>    <A-6> :BufferGoto 6<CR>
nnoremap <silent>    <A-7> :BufferGoto 7<CR>
nnoremap <silent>    <A-8> :BufferGoto 8<CR>
nnoremap <silent>    <A-9> :BufferLast<CR>
" Close buffer
nnoremap <silent>    <A-c> :BufferClose<CR>

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

"Allow filetype plugins and syntax highlighting
set autoindent
filetype plugin indent on
syntax on

" Map nerdtree
nmap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeGitStatusWithFlags = 1

" Use gitignore to avoid fuzzies
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" set synmaxcol=120
set expandtab

"" Incremental live completion
set inccommand=nosplit

""Change backspace to behave more intuitively
set backspace=indent,eol,start

""Set tab options for vim
set tabstop=8
set softtabstop=4

""Set highlight on search
set nohlsearch
set incsearch

"Make line numbers default
set number

"Do not save when switching buffers
set hidden

"Enable mouse mode
set mouse=a

"Enable break indent
set breakindent

"Set show command
set showcmd

"Save undo history
set undofile

"Case insensitive searching UNLESS /C or capital in search
set ignorecase
set smartcase

"Decrease update time
set updatetime=100
set signcolumn=yes

if has('termguicolors')
  set termguicolors
endif

" The configuration options should be placed before `colorscheme edge`.
let g:edge_style = 'aura'
let g:edge_enable_italic = 1
let g:edge_disable_italic_comment = 1
colorscheme edge

"Remap space as leader key
noremap <Space> <Nop>
let mapleader="\<Space>"

" Remap for dealing with word wrap
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

"Add move line shortcuts
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
nnoremap <A-j> :m .+1<CR>==

"Remap escape to leave terminal mode
augroup Terminal
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au FileType fzf tunmap <buffer> <Esc>
augroup end

"Add map to enter paste mode
set pastetoggle=<F3>

"Allow copy and paste to clipboard
nnoremap <F10> :call ToggleMouse()<CR>

function! ToggleMouse()
  if &mouse == 'a'
    IndentLinesDisable
    set signcolumn=no
    set mouse=v
    set nonu
    echo "Mouse usage Visual"
  else
    IndentLinesEnable
    set signcolumn=yes
    set mouse=a
    set nu
    echo "Mouse usage All"
  endif
endfunction

"Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

"Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Add neovim remote for vimtex
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor = 'latex'

"Add leader shortcuts
nnoremap <silent> <leader><space> :Buffers<CR>
nnoremap <silent> <leader>A :Windows<CR>
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>t :Tags<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>s :Rg<CR>
nnoremap <silent> <leader>p :Projects<CR>

" Add FZF and Vim Fugitive Shorcuts
nnoremap <silent> <leader>gc :Commits<CR>
nnoremap <silent> <leader>gb :Gbranch<CR>
nnoremap <silent> <leader>ga :Git add %:p<CR><CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR><CR>
nnoremap <silent> <leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <silent> <leader>gp :Ggrep<Space>
nnoremap <silent> <leader>gm :Gmove<Space>
nnoremap <silent> <leader>go :Git checkout<Space>
nnoremap <silent> <leader>gps :Dispatch! git push<CR>
nnoremap <silent> <leader>gpl :Dispatch! git pull<CR>

"Alternative shortcut without using fzf
nnoremap <leader>, :buffer *
nnoremap <leader>. :e<space>**/
nnoremap <leader>T :tjump *

" Intelligent switching of branches
function! s:gitCheckoutRef(ref)
    execute('Git checkout ' . a:ref)
    " call feedkeys("i")
endfunction

function! s:gitListRefs()
   let l:refs = execute("Git for-each-ref --format='\\%(refname:short)'")
   return split(l:refs,'\r\n*')[1:] "jump past the first line which is the git command
endfunction

command! -bang Gbranch call fzf#run({ 'source': s:gitListRefs(), 'sink': function('s:gitCheckoutRef'), 'dir':expand('%:p:h') })

" Search project root
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let options = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(options), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

"Add command for searching files within current git directory structure
command! ProjectFiles execute 'Files' s:find_git_root()

function! s:change_working_directory(path)
    execute 'cd' a:path
    execute 'edit' a:path
endfunction

" Projects implementation
function! s:switch_projects(path)
  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:path[0], 'e')

  execute cmd escape(a:path[1], ' %#\')
  execute('lcd ' . a:path[1])
endfunction

" Projects
command! -nargs=* Projects call fzf#run({
\ 'source':  'fd -H -t d --maxdepth 4 .git ' . $HOME . "/git" . ' | sed -En "s/\/.git//p"',
\ 'sink*':    function('<sid>switch_projects'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : '.
\            '--color hl:68,hl+:110',
\ 'down':    '50%'})

" speed up indent line
" default ''.
" n for Normal mode
" v for Visual mode
" i for Insert mode
" c for Command line editing, for 'incsearch'
let g:indentLine_faster = 1
let g:indentLine_setConceal = 2
let g:indentLine_concealcursor = ""
let g:indentLine_bufNameExclude = ["term:.*"]

" remove conceal on markdown files
let g:markdown_syntax_conceal = 0

" Configure vim slime to use tmux
let g:slime_target = "tmux"
let g:slime_python_ipython = 1
let g:slime_dont_ask_default = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right-of}"}

"Change preview window location
set splitbelow

"Remap number increment to alt
nnoremap <A-a> <C-a>
vnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>
vnoremap <A-x> <C-x>

"n always goes forward
nnoremap <expr> n  'Nn'[v:searchforward]
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]

nnoremap <expr> N  'nN'[v:searchforward]
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]

"Neovim python support
let g:loaded_python_provider = 0

" Highlight on yank
au TextYankPost * silent! lua vim.highlight.on_yank()

" Y yank until the end of line
noremap Y y$

" Clear white space on empty lines and end of line
nnoremap <silent> <F6> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

""" Nerdtree like sidepanel
" absolute width of netrw window
let g:netrw_winsize = -28

" do not display info on the top of window
let g:netrw_banner = 0

" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'

" variable for use by ToggleNetrw function
let g:NetrwIsOpen=0

" Lexplore toggle function
function! ToggleNetrw()

    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
        let g:netrw_liststyle = 0
        let g:netrw_chgwin=-1
    else
        let g:NetrwIsOpen=1
        let g:netrw_liststyle = 3
        silent Lexplore
    endif
endfunction

" Open netrw sidebar and open preview of file under cursor with ;
noremap <silent> <leader>d :call ToggleNetrw()<CR><Paste>

" Function to open preview of file under netrw
augroup Netrw
  autocmd filetype netrw nmap <leader>; <cr>:wincmd W<cr>
augroup end

" Vim polyglot language specific settings
let g:python_highlight_space_errors = 0

" Use global clipboard
set clipboard=unnamed,unnamedplus

" bubbly.nvim
let g:bubbly_palette = #{
\   background: "#34343c",
\   foreground: "#c5cdd9",
\   black: "#3e4249",
\   red: "#ec7279",
\   green: "#a0c980",
\   yellow: "#deb974",
\   blue: "#6cb6eb",
\   purple: "#d38aea",
\   cyan: "#5dbbc1",
\   white: "#c5cdd9",
\   lightgrey: "#57595e",
\   darkgrey: "#404247",
\ }

set nofoldenable
set foldlevel=99
set fillchars=fold:\
set foldtext=CustomFoldText()
setlocal foldmethod=expr
setlocal foldexpr=GetPotionFold(v:lnum)

function! GetPotionFold(lnum)
  if getline(a:lnum) =~? '\v^\s*$'
    return '-1'
  endif

  let this_indent = IndentLevel(a:lnum)
  let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

  if next_indent == this_indent
    return this_indent
  elseif next_indent < this_indent
    return this_indent
  elseif next_indent > this_indent
    return '>' . next_indent
  endif
endfunction

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
  let numlines = line('$')
  let current = a:lnum + 1

  while current <= numlines
      if getline(current) =~? '\v\S'
          return current
      endif

      let current += 1
  endwhile

  return -2
endfunction

function! CustomFoldText()
  " get first non-blank line
  let fs = v:foldstart

  while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile

  if fs > v:foldend
      let line = getline(v:foldstart)
  else
      let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . foldSize . " lines "
  let foldLevelStr = repeat("+--", v:foldlevel)
  let expansionString = repeat(" ", w - strwidth(foldSizeStr.line.foldLevelStr))
  return line . expansionString . foldSizeStr . foldLevelStr
endfunction
