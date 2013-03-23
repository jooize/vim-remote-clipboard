if !exists(g:RemoteClipboardGetCommand)
	let g:RemoteClipboardGetCommand = "ssh localhost pbpaste"
endif
if !exists(g:RemoteClipboardGetToRegister)
	let g:RemoteClipboardGetToRegister = 'r'
endif
if !exists(g:RemoteClipboardSetCommand)
	let g:RemoteClipboardSetCommand = "ssh localhost pbcopy"
endif

function! g:RemoteClipboardGet()
	let l:RemoteClipboard = system(g:RemoteClipboardGetCommand)
	if !v:shell_error
		call setreg(g:RemoteClipboardGetToRegister, l:RemoteClipboard)
	else
		echohl ErrorMsg
		echomsg "Failed to retrieve remote clipboard."
		echohl WarningMsg
		echomsg "$ ".g:RemoteClipboardGetCommand
		echomsg l:RemoteClipboard
		echohl None
		return '' " Return nothing to not paste 0 or 1 when calling with <C-r>=
	endif
endfunction

function! g:RemoteClipboardGetAndPasteAfter()
	if g:RemoteClipboardGet() == 0
		normal! "rP
	else
		return 1
	endif
endfunction

function! g:RemoteClipboardGetAndPasteBefore()
	if g:RemoteClipboardGet() == 0
		normal! "rp
	else
		return 1
	endif
endfunction

function! s:RemoteClipboardSet()
	call system(g:RemoteClipboardSetCommand, getreg("\""))
endfunction

command! -nargs=0 -bar RemoteClipboardGet call g:RemoteClipboardGet()
command! -nargs=0 -bar RemoteClipboardGetAndPasteAfter call g:RemoteClipboardGetAndPasteAfter()
command! -nargs=0 -bar RemoteClipboardGetAndPasteBefore call g:RemoteClipboardGetAndPasteBefore()
command! -nargs=0 -bar RemoteClipboardSet call s:RemoteClipboardSet()

