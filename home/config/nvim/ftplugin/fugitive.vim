" Move the help windows to the top of the screen
execute "normal \<c-w>K"

" No columns
setlocal colorcolumn=

" Close help window with double leader.
nnoremap <buffer> <silent> <leader><leader> :q<CR>
