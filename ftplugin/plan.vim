" Vim filetype plugin file
" Language:     Plan (Text plan)
" Maintainer:   Vitor Antunes <vitor.hda@gmail.com>
" Last Update:  Thu 12 Sep 2013 23:56:16 PM WEST
" Version:      1.0

" General configurations
if exists("g:plan_default_config")

    " General configurations
    set shiftwidth      =2
    set softtabstop     =2
    set tabstop         =2

    set foldmethod      =marker
    set foldcolumn      =2
    set commentstring   =""
    set formatoptions   =cqo2
    set foldtext        =plan#get_fold_text()

    " Mappings
    noremap  <leader>d  :call plan#done_add()<CR>
    noremap  <leader>rd :call plan#done_del()<CR>
    noremap  <leader>v  :call plan#check_add()<CR>
    noremap  <leader>rv :call plan#check_del()<CR>
    noremap  <leader>D  :call plan#date_add()<CR>
    noremap  <leader>rD :call plan#date_del()<CR>
    noremap  <leader>u  :call plan#date_del()<CR>:call plan#date_add()<CR>
    noremap  <leader>i  :call plan#date_inc()<CR>
    noremap  <leader>x  :call plan#date_dec()<CR>
    nnoremap <<         :call plan#shift_left()<CR>
    nnoremap >>         :call plan#shift_right()<CR>
    vnoremap <          :call plan#shift_left()<CR>
    vnoremap >          :call plan#shift_right()<CR>
    inoremap <C-d>      <ESC>:call plan#shift_left()<CR>i
    inoremap <C-t>      <ESC>:call plan#shift_right()<CR>i
    noremap  <leader>ps :execute strftime("vimgrep /%Y\\/%m\\/%d)$/ %%")<CR>:cclose<CR>
endif

" Bullets configuration
if !exists("g:plan_bullets_list")
    let g:plan_bullets_list=["*", "-", ">", "."]
endif
let s:bullets_list=[]
for s:bullet in g:plan_bullets_list
    call add(s:bullets_list, ":" . s:bullet)
endfor
let &comments=join(s:bullets_list, ",")

" Command declarations
command     PlanSyntaxUpdate    call plan#syntax_update()
