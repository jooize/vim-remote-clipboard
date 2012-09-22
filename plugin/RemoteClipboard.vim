let g:RemoteClipboardGetCommand = "ssh localhost pbpaste"
let g:RemoteClipboardGetToRegister = 'r'
let g:RemoteClipboardSetCommand = "ssh localhost pbcopy"

function! g:RemoteClipboardGet()
	let l:RemoteClipboard = system(g:RemoteClipboardGetCommand)
	if !v:shell_error
		call setreg(g:RemoteClipboardGetToRegister, l:RemoteClipboard)
	else
		echo "Failed to retrieve remote clipboard."
			\ ."\n$ ".g:RemoteClipboardGetCommand
			\ ."\n".l:RemoteClipboard
		return 1
	endif
endfunction

function! g:RemoteClipboardGetAndPasteAfter()
	if s:RemoteClipboardGet() == 0
		normal! "rP
	else
		return 1
	endif
endfunction

function! g:RemoteClipboardGetAndPasteBefore()
	if s:RemoteClipboardGet() == 0
		normal! "rp
	else
		return 1
	endif
endfunction

function! s:RemoteClipboardSet()
	call system(g:RemoteClipboardSetCommand, getreg("\""))
endfunction

command! -nargs=0 -bar RemoteClipboardGet call s:RemoteClipboardGet()
command! -nargs=0 -bar RemoteClipboardGetAndPasteAfter call s:RemoteClipboardGetAndPasteAfter()
command! -nargs=0 -bar RemoteClipboardGetAndPasteBefore call s:RemoteClipboardGetAndPasteBefore()
command! -nargs=0 -bar RemoteClipboardSet call s:RemoteClipboardSet()

