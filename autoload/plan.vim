" Vim autoload script file
" Language:     Plan (Text plan)
" Maintainer:   Vitor Antunes <vitor.hda@gmail.com>
" Last Update:  Thu 12 Sep 2013 23:56:16 PM WEST
" Version:      1.0

function plan#date_add () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)

        call setline(lnum, printf("%s .%s (%s)", currentline, repeat(".", 53-strlen(currentline)), strftime("%Y/%m/%d")))

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#date_del () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)

        call setline(lnum, substitute(currentline, ' \.\+ (.*)$', "", ""))

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#date_inc () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)
        let l:time      = system(printf("date -d %s +%%s", substitute(currentline, '.* (\(.*\)).*', '\1', '')))

        call setline(lnum, substitute(currentline, '\(.* (\).*\().*\)', printf('\1%s\2', strftime("%Y/%m/%d", l:time + 24*60*60)), ''))

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#date_dec () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)
        let l:time      = system(printf("date -d %s +%%s", substitute(currentline, '.* (\(.*\)).*', '\1', '')))

        call setline(lnum, substitute(currentline, '\(.* (\).*\().*\)', printf('\1%s\2', strftime("%Y/%m/%d", l:time - 24*60*60)), ''))

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#done_add () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)

        call setline(lnum, printf("%-71s X", currentline))

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#done_del () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)

        call setline(lnum, substitute(currentline, '\s\+X$', "", ""))

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#check_add () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)

        call setline(lnum, printf("%-71s V", currentline))

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#check_del () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)

        call setline(lnum, substitute(currentline, '\s\+V$', "", ""))

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#shift_right () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)
        let bullet_dict = plan#get_bullet(currentline)

        if bullet_dict['index'] >= 0 && bullet_dict['index'] + 1 < len(g:plan_bullets_list)
            let new_bullet = g:plan_bullets_list[bullet_dict['index'] + 1]
            let currentline= substitute(currentline, bullet_dict['bullet'], new_bullet, "")
            call setline(lnum, currentline)

            normal! >>
        endif

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#shift_left () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)
        let bullet_dict = plan#get_bullet(currentline)

        if bullet_dict['index'] >= 0 && bullet_dict['index'] - 1 >= 0
            let new_bullet = g:plan_bullets_list[bullet_dict['index'] - 1]
            let bullet = bullet_dict['bullet']
            if index(["."], bullet) >= 0
                let bullet = "\\" . bullet
            endif
            let currentline= substitute(currentline, bullet, new_bullet, "")
            call setline(lnum, currentline)

            normal! <<
        endif

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#get_bullet (line)
"{{{
    let line_start = match(a:line, "[^ \t]")
    let bullet = a:line[line_start]
    let bullet_idx = index(g:plan_bullets_list, bullet)

    return {'bullet': bullet, 'index': bullet_idx}
endfunction
"}}}

function plan#get_fold_text ()
"{{{
    let markers = split(&foldmarker, ',')
    let line = getline(v:foldstart)
    let sub = substitute(line, markers[0], '', '')
    if (substitute(sub, '\s*', '', '') == "")
        let line = getline(v:foldstart + 1)
        let sub = substitute(line, markers[0], '', '')
    endif

    return sub
endfunction
"}}}

" vim: set fdm=marker:
