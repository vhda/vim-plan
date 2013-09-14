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

    " Mappings
    noremap  <leader>d  :call plan#PlanControlFunc("done", 1)<CR>
    noremap  <leader>rd :call plan#PlanControlFunc("done", 0)<CR>
    noremap  <leader>v  :call plan#PlanControlFunc("check", 1)<CR>
    noremap  <leader>rv :call plan#PlanControlFunc("check", 0)<CR>
    noremap  <leader>D  :call plan#PlanControlFunc("date", 1)<CR>
    noremap  <leader>rD :call plan#PlanControlFunc("date", 0)<CR>
    noremap  <leader>u  :call plan#PlanControlFunc("date", 0)<CR>:call PlanControlFunc("date", 1)<CR>
    noremap  <leader>i  :call plan#PlanControlFunc("date_increment", 0)<CR>
    noremap  <leader>ps :execute strftime("vimgrep /%Y\\/%m\\/%d/ %%")<CR>:cclose<CR>
endif
