if has('nvim')
    packadd nvim-gdb
endif

iabbrev <buffer> true True
iabbrev <buffer> false False

" lua << EOF
"     require'lspconfig'.pylsp.setup {
"         cmd = { "pyls" }
"     }
" EOF
