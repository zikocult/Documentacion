" Theme
set background=dark
colorscheme gruvbox

" Stheader 42
let g:user42 = 'gbarulls'
let g:mail42 = 'gbarulls@student.42barcelona.com'

" Nerdtree
let NERDTreeQuitOnOpen=1

"Highlight tabs and spaces

function HighlightsTabsAndSpace ()
call feedkeys(":set listchars=eol:¬,tab:\\|_,trail:~,extends:>,precedes:<,space:\\|\<CR>")
call feedkeys(":set list\<CR>")
endfunction

nmap <leader>t :call HighlightsTabsAndSpace()<CR>
nmap <leader>tt :set nolist<CR>
