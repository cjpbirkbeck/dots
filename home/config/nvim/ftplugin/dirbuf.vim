" Color until the maximum filename size
" Note we has for the characters for the hash and the padding
" In Windows this is a default of 260, see https://docs.microsoft.com/en-ca/windows/win32/fileio/naming-a-file
" In Linux, there is a limit of 256 characters.
" See: https://arvimal.github.io/posts/2016/07/2016-07-21-max-file-name-length-in-an-ext4-file-system/
" I'm guessing here, but I don't think filename *should* be longer than 32
" characters, so I am going to put a colorcolumn there.
if has('win32')
    setlocal colorcolumn=43,271
else
    setlocal colorcolumn=43,266
endif

setlocal nowrap
