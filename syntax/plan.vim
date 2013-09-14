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

" Auxilliary constants
let s:one_day = 86400

" Highlight entries to be done today
let s:dateregex=strftime("syntax match PlanToday /.*%Y\\/%m\\/%d.*/ contains=PlanDoneOld")
exec s:dateregex

" Highlight all items done during this week
let s:date = localtime()
while 1
    let s:dateregex=strftime("syntax match PlanDoneOld  /(%Y\\/%m\\/%d.*\[XV\]$/", s:date)
    exec s:dateregex
    let s:date -= s:one_day
    if strftime("%u", s:date) == "5"
        break
    endif
endwhile

" Highlight items to be done until end of this week
let s:date = localtime() + s:one_day
while strftime("%u", s:date) != "6"
    let s:dateregex=strftime("syntax match PlanFuture   /.*(%Y\\/%m\\/%d)$/", s:date)
    exec s:dateregex
    let s:date += s:one_day
endwhile

" Highlight done items
syntax match PlanDone       /.*X$/ contains=PlanToday,PlanDoneOld

" Highlight checked items
syntax match PlanCheck      /.*V$/ contains=PlanToday

" Highlight headers
syntax match PlanComment    /^---.*\n.*\n---.*/
