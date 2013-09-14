" Vim filetype plugin file
" Language:     Plan (Text plan)
" Maintainer:   Vitor Antunes <vitor.hda@gmail.com>
" Last Update:  Thu 12 Sep 2013 23:56:16 PM WEST
" Version:      1.0

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" General configurations
if exists("g:plan_default_config")

    " General configurations
    set shiftwidth      =2
    set softtabstop     =2
    set tabstop         =2

    set foldmethod      =marker
    set foldcolumn      =2
    set commentstring   =""
    set comments        =:*,:-,:>,:.
    set formatoptions   =cqo2

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
    noremap  <leader>ps :execute strftime("vimgrep /%Y\\/%m\\/%d/ %%")<CR>:cclose<CR>
endif
