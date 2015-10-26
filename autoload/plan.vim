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

        if !plan#is_done(currentline)
            call setline(lnum, printf("%s .%s (%s)", currentline, repeat(".", 53-strlen(currentline)), strftime("%Y/%m/%d")))
        endif

        let lnum += 1
    endwhile
endfunction
"}}}

function plan#date_del () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline
        let currentline = getline(lnum)

        if !plan#is_done(currentline)
            call setline(lnum, substitute(currentline, ' \.\+ ([^)]\+)$', "", ""))
        endif

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

        if !plan#is_done(currentline)
            call setline(lnum, substitute(currentline, '\(.* (\).*\().*\)', printf('\1%s\2', strftime("%Y/%m/%d", l:time + v:count1*24*60*60 + 2*60*60)), ''))
        endif

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

        if !plan#is_done(currentline)
            call setline(lnum, substitute(currentline, '\(.* (\).*\().*\)', printf('\1%s\2', strftime("%Y/%m/%d", l:time - v:count1*24*60*60 + 2*60*60)), ''))
        endif

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

    while lnum <= a:lastline + v:count1 - 1
        let currentline = getline(lnum)
        let bullet_dict = plan#get_bullet(currentline)

        if bullet_dict['index'] >= 0 && bullet_dict['index'] + 1 < len(g:plan_bullets_list)
            let new_bullet = g:plan_bullets_list[bullet_dict['index'] + 1]
            let currentline= substitute(currentline, bullet_dict['bullet'], new_bullet, "")
            " Remove extra .. characters
            if match(currentline, '\. (.*)\(\s\+[XV]\)\?$') >= 0
                let currentline= substitute(currentline, '\.\.', '', '')
            endif
            call setline(lnum, currentline)
        endif

        let lnum += 1
    endwhile

    execute a:firstline . "," . (a:lastline + v:count1 - 1) . ">"
endfunction
"}}}

function plan#shift_left () range
"{{{
    let lnum   = a:firstline

    while lnum <= a:lastline + v:count1 - 1
        let currentline = getline(lnum)
        let bullet_dict = plan#get_bullet(currentline)

        if bullet_dict['index'] >= 0 && bullet_dict['index'] - 1 >= 0
            let new_bullet = g:plan_bullets_list[bullet_dict['index'] - 1]
            let bullet = bullet_dict['bullet']
            if index(["."], bullet) >= 0
                let bullet = "\\" . bullet
            endif
            let currentline= substitute(currentline, bullet, new_bullet, "")
            " Repeat .. characters
            if match(currentline, '\. (.*)\(\s\+[XV]\)\?$') >= 0
                let currentline= substitute(currentline, '\.\.', '&&', '')
            endif
            call setline(lnum, currentline)
        endif

        let lnum += 1
    endwhile

    execute a:firstline . "," . (a:lastline + v:count1 - 1) . "<"
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
    if substitute(line, '\s', '', '') == markers[0]
      let line = getline(v:foldstart + 1)
      if line[0] == g:plan_bullets_list[0]
        return line
      endif
    endif
    let sub = substitute(line, markers[0], repeat(v:folddashes, len(markers[0])), 'g')
    if (substitute(sub, '\s*', '', '') == "...")
        let line = getline(v:foldstart + 1)
        let sub = substitute(line, markers[0], '', '')
    endif

    return sub
endfunction
"}}}

function plan#is_done (line)
"{{{
    let last_char = strlen(a:line) - 1
    if index(["X", "V"], a:line[last_char]) >= 0
        return 1
    else
        return 0
    endif
endfunction
"}}}

function plan#syntax_update ()
"{{{
    runtime syntax/plan.vim

    " Check if Calendar is enabled and update it
    if bufexists("__Calendar")
        call Calendar(0)
        wincmd p
    endif
endfunction
"}}}

" vim: set fdm=marker:
