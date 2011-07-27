set go=aegiLt
"get platform info
let platform = system('uname')
if platform =~ "Linux"
    " Linux specific options
    set gfn=DejaVu\ Sans\ Mono\ 9
elseif platform =~ "Darwin"
    " Mac specific options
    set gfn=Menlo\ Regular:h10
endif
