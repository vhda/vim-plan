" Vim autoload script file
" Language:     Plan (Text plan)
" Maintainer:   Vitor Antunes <vitor.hda@gmail.com>
" Last Update:  Thu 12 Sep 2013 23:56:16 PM WEST
" Version:      1.0

function plan#PlanControlFunc(type, add) range
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline   = getline(lnum)
        if (a:type == "date")
            if (a:add)
                call setline(lnum, printf("%s .%s (%s)", currentline, repeat(".", 53-strlen(currentline)), strftime("%Y/%m/%d")))
            else
                call setline(lnum, substitute(currentline, ' \.\+ (.*)$', "", ""))
            endif
        else
            if (a:type == "done")
                if (a:add)
                    call setline(lnum, printf("%-71s X", currentline))
                else
                    call setline(lnum, substitute(currentline, '\s\+X$', "", ""))
                endif
            else
                if (a:type == "date_increment")
                    let l:time = system(printf("date -d %s +%%s", substitute(currentline, '.* (\(.*\)).*', '\1', '')))
                    call setline(lnum, substitute(currentline, '\(.* (\).*\().*\)', printf('\1%s\2', strftime("%Y/%m/%d", l:time + 24*60*60)), ''))
                else
                    if (a:add)
                        call setline(lnum, printf("%-71s V", currentline))
                    else
                        call setline(lnum, substitute(currentline, '\s\+V$', "", ""))
                    endif
                endif
            endif
        endif
        let lnum += 1
    endwhile
endfunction


