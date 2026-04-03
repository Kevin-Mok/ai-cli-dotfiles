let g:airline#themes#kmwal#palette = get(g:, 'airline#themes#kmwal#palette', {})

function! s:color(gui_fg, gui_bg, cterm_fg, cterm_bg, ...) abort
  let l:attr = a:0 ? a:1 : ''
  return [a:gui_fg, a:gui_bg, a:cterm_fg, a:cterm_bg, l:attr]
endfunction

function! airline#themes#kmwal#refresh() abort
  let g:airline#themes#kmwal#palette = {}

  let l:wal = exists('*LoadWalPalette') ? LoadWalPalette() : {}
  if empty(l:wal)
    let l:wal = {
          \ 'bg': '#000000',
          \ 'fg': '#ffffff',
          \ 'line': '#808080',
          \ 'const': '#ff5f5f',
          \ 'string': '#5fff87',
          \ 'type': '#ffd75f',
          \ 'func': '#5f87ff',
          \ 'keyword': '#d75fff',
          \ 'special': '#5fd7d7',
          \ }
  endif

  let l:n1 = s:color(l:wal.bg, l:wal.func, 0, 4, 'bold')
  let l:n2 = s:color(l:wal.fg, l:wal.line, 7, 8, '')
  let l:n3 = s:color(l:wal.fg, l:wal.bg, 7, 0, '')

  let l:i1 = s:color(l:wal.bg, l:wal.string, 0, 2, 'bold')
  let l:i2 = s:color(l:wal.fg, l:wal.line, 7, 8, '')
  let l:i3 = s:color(l:wal.fg, l:wal.bg, 7, 0, '')

  let l:v1 = s:color(l:wal.bg, l:wal.keyword, 0, 5, 'bold')
  let l:v2 = s:color(l:wal.fg, l:wal.line, 7, 8, '')
  let l:v3 = s:color(l:wal.fg, l:wal.bg, 7, 0, '')

  let l:r1 = s:color(l:wal.bg, l:wal.const, 0, 1, 'bold')
  let l:r2 = s:color(l:wal.fg, l:wal.line, 7, 8, '')
  let l:r3 = s:color(l:wal.fg, l:wal.bg, 7, 0, '')

  let l:ia1 = s:color(l:wal.line, l:wal.bg, 8, 0, '')
  let l:ia2 = s:color(l:wal.line, l:wal.bg, 8, 0, '')
  let l:ia3 = s:color(l:wal.line, l:wal.bg, 8, 0, '')

  let g:airline#themes#kmwal#palette.normal = airline#themes#generate_color_map(l:n1, l:n2, l:n3)
  let g:airline#themes#kmwal#palette.insert = airline#themes#generate_color_map(l:i1, l:i2, l:i3)
  let g:airline#themes#kmwal#palette.visual = airline#themes#generate_color_map(l:v1, l:v2, l:v3)
  let g:airline#themes#kmwal#palette.replace = airline#themes#generate_color_map(l:r1, l:r2, l:r3)
  let g:airline#themes#kmwal#palette.inactive = airline#themes#generate_color_map(l:ia1, l:ia2, l:ia3)
  let g:airline#themes#kmwal#palette.accents = {
        \ 'red': s:color(l:wal.bg, l:wal.const, 0, 1, 'bold'),
        \ }

  let g:airline#themes#kmwal#palette.normal.airline_warning = s:color(l:wal.bg, l:wal.type, 0, 3, 'bold')
  let g:airline#themes#kmwal#palette.normal.airline_error = s:color(l:wal.bg, l:wal.const, 0, 1, 'bold')
  let g:airline#themes#kmwal#palette.insert.airline_warning = g:airline#themes#kmwal#palette.normal.airline_warning
  let g:airline#themes#kmwal#palette.insert.airline_error = g:airline#themes#kmwal#palette.normal.airline_error
  let g:airline#themes#kmwal#palette.visual.airline_warning = g:airline#themes#kmwal#palette.normal.airline_warning
  let g:airline#themes#kmwal#palette.visual.airline_error = g:airline#themes#kmwal#palette.normal.airline_error
  let g:airline#themes#kmwal#palette.replace.airline_warning = g:airline#themes#kmwal#palette.normal.airline_warning
  let g:airline#themes#kmwal#palette.replace.airline_error = g:airline#themes#kmwal#palette.normal.airline_error

  let g:airline#themes#kmwal#palette.tabline = {
        \ 'airline_tab': s:color(l:wal.fg, l:wal.bg, 7, 0, ''),
        \ 'airline_tabsel': s:color(l:wal.bg, l:wal.func, 0, 4, 'bold'),
        \ 'airline_tabtype': s:color(l:wal.fg, l:wal.bg, 7, 0, ''),
        \ 'airline_tabfill': s:color(l:wal.line, l:wal.bg, 8, 0, ''),
        \ 'airline_tabmod': s:color(l:wal.bg, l:wal.string, 0, 2, 'bold'),
        \ }
endfunction

call airline#themes#kmwal#refresh()
