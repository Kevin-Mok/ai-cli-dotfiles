set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

let g:python_host_prog = '/usr/lib/python3.7'
" let g:python3_host_prog = '/usr/lib/python3.5.zip'

augroup km_python_completion
  autocmd!
  autocmd VimEnter * lua vim.schedule(function() require('km.python_completion').setup() end)
  autocmd FileType python lua require('km.python_completion').setup(); if vim.lsp.config and vim.lsp.config.basedpyright then vim.lsp.enable('basedpyright'); vim.schedule(function() vim.cmd('LspStart basedpyright') end) end
augroup END
