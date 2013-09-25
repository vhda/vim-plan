" Vim syntax file
" Language:     Plan (Text plan)
" Maintainer:   Vitor Antunes <vitor.hda@gmail.com>
" Last Update:  Thu 12 Sep 2013 23:56:16 PM WEST
" Version:      1.0

" Define highlight links
highlight link PlanToday    WarningMsg
highlight link PlanDoneOld  Type
highlight link PlanDone     Include
highlight link PlanCheck    Statement
highlight link PlanComment  Comment
highlight link PlanFuture   Constant

" Date format definition
if exists("g:plan_date_format")
    let s:plan_date_format  = g:plan_date_format
else
    let s:plan_date_format  = "%Y\\/%m\\/%d"
endif

" Auxilliary constants
let s:one_day = 86400

" Highlight entries to be done today
let s:dateregex=strftime(printf("syntax match PlanToday /.*%s.*/ contains=PlanDoneOld", s:plan_date_format))
exec s:dateregex

" Highlight all items done during this week
let s:date = localtime()
while 1
    let s:dateregex=strftime(printf("syntax match PlanDoneOld /(%s.*\[XV\]$/", s:plan_date_format), s:date)
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
syntax match PlanComment    /^---.*\n.*\n---.*/
