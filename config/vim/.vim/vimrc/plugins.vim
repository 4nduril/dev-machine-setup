" Plugin integration and plugin-specific mappings.

let g:NERDSpaceDelims = 1
let g:airline_powerline_fonts = get(g:, 'newvim_airline_powerline_fonts', 0)
let g:copilot_no_tab_map = v:true
let g:tex_flavor = 'latex'

nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>nf :NERDTreeFind<CR>
nnoremap <C-p> :GitFiles<CR>
nnoremap <Leader>a :Rg<Space>

" The coc mappings only make sense when the coc.nvim submodule is checked
" out (the remote setup profile skips it). Without the guard, the <TAB>
" insert-mode <expr> map would call the missing coc#pum#visible() on every
" keystroke.
let s:coc_plugin = expand('<sfile>:p:h:h') . '/pack/plugins/start/coc.nvim/plugin/coc.vim'
if filereadable(s:coc_plugin)
  nmap <silent><Leader>gd <Plug>(coc-definition)
  nmap <silent><Leader>gv :call CocAction('jumpDefinition', 'vsplit')<CR>
  nmap <silent><Leader>gt <Plug>(coc-type-definition)
  nmap <silent><Leader>r <Plug>(coc-references)
  nmap <silent><Leader>rn <Plug>(coc-rename)
  nmap <silent><Leader>t :call CocAction('doHover')<CR>
  nmap <silent><Leader>do <Plug>(coc-codeaction)

  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  inoremap <silent><expr> <C-Space> coc#refresh()
  inoremap <expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
  endfunction
endif
unlet s:coc_plugin

function! s:enable_copilot() abort
  if get(g:, 'newvim_copilot_loaded', 0)
    return
  endif

  let g:newvim_copilot_loaded = 1
  packadd copilot.vim

  " This intentionally uses <C-i> because it works in the current terminal.
  " Other terminals may treat it as <Tab>, in which case this should be remapped.
  imap <silent><script><expr> <M-i> copilot#Accept("\<CR>")
endfunction

command! CopilotEnable call <SID>enable_copilot()

function! s:enable_vim_latex() abort
  if get(g:, 'newvim_vim_latex_loaded', 0)
    return
  endif

  let g:newvim_vim_latex_loaded = 1
  packadd vim-latex

  set grepprg=grep\ -nH\ $*
  nnoremap <SID>Anything_maybe_change_it <Plug>IMAP_JumpForward
endfunction

augroup NewVimLatex
  autocmd!
  autocmd BufReadPre,BufNewFile *.tex,*.latex,*.ltx call <SID>enable_vim_latex()
augroup END
