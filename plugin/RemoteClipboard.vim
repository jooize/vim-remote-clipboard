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
		return 1
		echohl ErrorMsg
		echomsg "Failed to retrieve remote clipboard."
		echohl WarningMsg
		echomsg "$ ".g:RemoteClipboardGetCommand
		echomsg l:RemoteClipboard
		echohl None
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

