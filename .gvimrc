set go=aegit
"get platform info
let platform = system('uname')
if platform =~ "Linux"
    " Linux specific options
    set gfn=DejaVu\ Sans\ Mono\ 9
elseif platform =~ "Darwin"
    " Mac specific options
    set gfn=Droid\ Sans\ Mono:h10
endif

au VimLeave * mksession! ~/.vim/session/%:t.session
au VimLeave * wviminfo! ~/.vim/session/%:t.viminfo
