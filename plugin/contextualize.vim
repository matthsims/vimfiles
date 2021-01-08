" My contextualize.vim settings

try
  packadd contextualize.vim
catch
  finish
endtry

augroup vimrc_contextualize
  autocmd!
  autocmd User UltiSnipsEnterFirstSnippet let g:in_snippet = 1
  autocmd User UltiSnipsExitLastSnippet unlet! g:in_snippet
augroup END

ContextAdd insnippet {-> exists('g:in_snippet')}
Contextualize insnippet imap <Tab> <Plug>(myUltiSnipsForward)
Contextualize insnippet imap <S-Tab> <Plug>(myUltiSnipsBackward)
Contextualize insnippet smap <Tab> <Plug>(myUltiSnipsForward)
Contextualize insnippet smap <S-Tab> <Plug>(myUltiSnipsBackward)

function! s:startcmd() abort dict
  return getcmdtype()==":" && getcmdline()==self.lhs
endfunction
ContextAdd startcmd s:startcmd

ContextAdd inSyntax {name -> match(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), name) >= 0}

Contextualize startcmd cnoreabbrev he help
Contextualize startcmd cnoreabbrev h vert help
Contextualize startcmd cnoreabbrev <expr> some 'mkview \| source % \| setfiletype ' . &filetype . ' \| loadview'
Contextualize startcmd cnoreabbrev <expr> vre 'mkview \| runtime! settings.vim \| setfiletype ' . &filetype . ' \| loadview'
Contextualize startcmd cnoreabbrev eft EditFtPlugin
Contextualize startcmd cnoreabbrev e! mkview \| edit!
Contextualize startcmd cnoreabbrev use UltiSnipsEdit
Contextualize startcmd cnoreabbrev ase AutoSourceEnable
Contextualize startcmd cnoreabbrev asd AutoSourceDisable
Contextualize startcmd cnoreabbrev sr SetRepl
Contextualize startcmd cnoreabbrev tr TermRepl
Contextualize startcmd cnoreabbrev <expr> vga 'vimgrep // **/*.' . expand('%:e') . "\<C-Left><Left><Left>"
Contextualize startcmd cnoreabbrev cqf Clearqflist
Contextualize startcmd cnoreabbrev w2 w
" Use this like 'eh/', the / expands and adds the dir / divider
Contextualize startcmd cnoreabbrev eh edit <C-r>=expand('%:h')<Cr>

command! -complete=filetype -nargs=? EditFtplugin execute 'edit $CFGDIR/after/ftplugin/' . (empty(expand('<args>')) ? &filetype : expand('<args>')) . '.vim'

function! SetupSubstitute(type) abort
  call feedkeys(":'[,']s/\<C-r>\"//g\<Left>\<Left>")
endfunction " }}}
xnoremap s :s//g<Left><Left>
Contextualize {-> mode(1) =~# 'v'} xnoremap s y:set opfunc=SetupSubstitute<Cr>g@
" Contextualize default xnoremap s :s//g<Left><Left>

" end of word or a space, followed by nothing or any pair characters
" ContextAdd pairallowed {-> getline('.')[col('.') - 2 : col('.') - 1] =~ '\v\w?[ [\](){}"'']?'}
ContextAdd pairallowed {-> getline('.')[col('.') - 1] =~ '\W' || col('.') - 1 == len(getline('.'))}

ContextAdd completepair {lhs -> getline('.')[col('.') - 1] == lhs}
ContextAdd fly {lhs -> getline('.')[col('.') - 1 :] =~ '^[ \])}]\+' . lhs}

" ContextAdd tabout {-> getline('.')[col('.') - 1 :] =~ '^[\])}]\+'}
ContextAdd delpair {-> getline('.')[col('.') - 2 : col('.')] =~ '^\%(\V()\|{}\|[]\|''''\|""\)'}

for pair in ['()', '[]', '{}']
  call contextualize#map('pairallowed' , 'i', 'map', pair[0], pair . '<C-g>U<Left>')
  call contextualize#map('pairallowed' , 's', 'map', pair[0], pair . '<C-g>U<Left>')
  call contextualize#map('completepair', 'i', 'map', pair[1], '<C-g>U<Right>'               , {'args': pair[1]})
  call contextualize#map('fly'         , 'i', 'map', pair[1], '<C-o>f' . pair[1] . '<Right>', {'args': pair[1]})
endfor

" End of word is not allowed, space or opening characters only
ContextAdd quoteallowed {-> getline('.')[col('.') - 2 : col('.') - 1] !~ '\w'}

" Complete should take prescedence for quotes
Contextualize completepair ' inoremap ' <C-g>U<Right>
Contextualize completepair " inoremap " <C-g>U<Right>
Contextualize quoteallowed inoremap ' ''<C-g>U<Left>
Contextualize quoteallowed inoremap " ""<C-g>U<Left>
Contextualize quoteallowed snoremap ' ''<C-g>U<Left>
Contextualize quoteallowed snoremap " ""<C-g>U<Left>

" Contextualize tabout inoremap <expr> <Tab> repeat('<Right>', match(getline('.')[col('.') - 1 :], '[\])}]\+\zs'))
function! s:ends() abort
  " Return the number of ending bracket pairs in a row, after the cursor
  return match(getline('.')[col('.') - 1 :], '^[\])}]*\zs')
endfunction
ContextAdd tabout s:ends
Contextualize tabout inoremap <expr> <Tab> repeat('<Right>', <SID>ends())
Contextualize delpair inoremap <Bs> <BS><Del>


" vim-fugitive
Contextualize startcmd cnoreabbrev gcim Gcommit \| startinsert