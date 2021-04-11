" Settings for nvim GUIs.

if exists('g:fvim_loaded')
    " Use fvim's custom Titlebar
    FVimCustomTitleBar v:true

    " Use smooth animations
    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true

    " Keybindings
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    " TODO: Set a default font size and have a keybinding that switches to
    " that size.
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
else
    " Here, I am assuming that any non-fvim GUI should is actually neovim-qt.
    " This is a poor assumption, and should be replace with a more robust
    " solution.

    " Context menu for copy-pasting.
    nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
    inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
    vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
endif
