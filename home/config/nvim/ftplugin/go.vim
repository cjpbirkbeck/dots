" Use literal tabs, as per gofmt guidelines.
setlocal noexpandtab
setlocal shiftwidth=0

" User Interface
let g:go_doc_popup_window = 1

" Enhanced syntax highlighting
let g:go_highlight_fields         = 1
let g:go_highlight_functions      = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types    = 1
let g:go_highlight_operators      = 1

" Insert placeholders
let g:go_gopls_use_placeholders = 1

" Keymaps
nnoremap <buffer> <silent> <localleader>i :GoInfo<CR>
nnoremap <buffer> <silent> <localleader>d :GoDecls<CR>
nnoremap <buffer> <silent> <localleader>D :GoDeclsDir<CR>
