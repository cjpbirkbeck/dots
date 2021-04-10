" Settings for nvim GUIs.

if exists('g:fvim_loaded')
    " Use fvim's custom Titlebar
    FVimCustomTitleBar v:true

    " Use smooth animations
    FVimCursorSmoothScroll v:true
    FVimCursorSmoothBlink v:true

    " Keybindings
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    " TODO: Set a default font size and have a keybinding that switches to
    " that size.
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
endif
