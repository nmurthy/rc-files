set go-=rm
"get platform info
let platform = system('uname')
if system('uname') == 'Linux'
    " Linux specific options
    set gfn=DejaVu\ Sans\ Mono\ 9
elseif system('uname') == 'Darwin'
    " Mac specific options
    set gfn=Menlo\ Regular:h10
endif
