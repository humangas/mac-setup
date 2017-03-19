" See also: https://github.com/glidenote/memolist.vim

" Install plugin: glidenote/memolist.vim (See .vimrc)

" Plugin glidenote/memolist.vim
let g:memolist_path = "~/.config/memo/_posts"
let g:memolist_memo_suffix = "md"
let g:memolist_unite = 1
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>
