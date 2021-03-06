" Vim syntax file
" Language:     Plan (Text plan)
" Maintainer:   Vitor Antunes <vitor.hda@gmail.com>
" Last Update:  Thu 12 Sep 2013 23:56:16 PM WEST
" Version:      1.0

" Define highlight colors
highlight PlanToday    term=standout cterm=bold ctermfg=1 guifg=Red
highlight PlanDoneOld  term=underline cterm=bold ctermfg=2 gui=bold guifg=#60ff60
highlight PlanDone     term=bold cterm=bold ctermfg=4 gui=bold guifg=Blue
highlight PlanCheck    term=bold cterm=bold ctermfg=3 gui=bold guifg=#ffff60
highlight PlanComment  term=bold cterm=bold ctermfg=6 guifg=#80a0ff
highlight PlanFuture   term=bold cterm=bold ctermfg=5 gui=bold guifg=Magenta
highlight PlanOld      term=reverse cterm=bold ctermfg=7 ctermbg=1 guifg=White guibg=Red

" Date format definition
if exists("g:plan_date_format")
    let s:plan_date_format  = g:plan_date_format
else
    let s:plan_date_format  = "%Y\\/%m\\/%d"
endif

" Clear existing syntax definitions
syntax clear PlanToday
syntax clear PlanDoneOld
syntax clear PlanDone
syntax clear PlanCheck
syntax clear PlanComment
syntax clear PlanFuture
syntax clear PlanOld

" Auxilliary constants
let s:one_day = 86400

" Highlight entries to be done today
let s:dateregex=strftime(printf("syntax match PlanToday /.*(%s).*/ contains=PlanDoneOld", s:plan_date_format))
exec s:dateregex

" Highlight old items still not done since previous week
let s:date = localtime()
let s:date -= s:one_day
while s:date >= localtime() - 7*s:one_day
    let s:dateregex=strftime(printf("syntax match PlanOld /.*(%s).*/", s:plan_date_format), s:date)
    exec s:dateregex
    let s:date -= s:one_day
endwhile

" Highlight all items done during this week
let s:date = localtime()
while 1
    let s:dateregex=strftime(printf("syntax match PlanDoneOld /(%s).*\[XV\]$/", s:plan_date_format), s:date)
    exec s:dateregex
    let s:date -= s:one_day
    if strftime("%u", s:date) == "5"
        break
    endif
endwhile

" Highlight items to be done until end of this week
let s:date = localtime() + s:one_day
while strftime("%u", s:date) != "6"
    let s:dateregex=strftime(printf("syntax match PlanFuture /.*(%s)$/", s:plan_date_format), s:date)
    exec s:dateregex
    let s:date += s:one_day
endwhile

" Highlight done items
syntax match PlanDone       /.*X$/ contains=PlanToday,PlanDoneOld

" Highlight checked items
syntax match PlanCheck      /.*V$/

" Highlight headers
syntax match PlanComment    /^---.*\n\(.*\n\)\{-1,\}---.*/
