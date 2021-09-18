if has('win32') && has('nvim')
    packadd glow-nvim
endif

setlocal spell
setlocal conceallevel=2

let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_math = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_autowrite = 1
let g:vim_markdown_follow_anchor = 1

let g:vim_markdown_fenced_languages = [
    \'shell=sh',
    \'viml=vim',
    \'nix=nix',
    \ ]

" Preview window
highlight NormalFloat guifg=LightBlue guibg=grey30

" Preview with glow(1)
nnoremap <buffer> <silent> <localleader>p :Glow<CR>
