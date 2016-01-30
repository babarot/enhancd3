let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#enhancd#define()
    return s:source
endfunction

let s:source = {
            \ 'name': 'enhancd',
            \ 'action_table' : {},
            \ 'default_action' : 'cd',
            \ }

function! s:source.gather_candidates(args, context)
    return map(readfile($ENHANCD_LOG), "{ 'word' : v:val }")
endfunction

let s:action_table = {}
let s:action_table.cd = {
            \ 'description' : 'change directory',
            \ 'is_selectable' : 1,
            \ }

function! s:action_table.cd.func(candidates)
    let name = join(map(deepcopy(a:candidates), "v:val.word"))
    execute "cd " . name
endfunction

let s:source.action_table = s:action_table

let &cpo = s:save_cpo
unlet s:save_cpo
