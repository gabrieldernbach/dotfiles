" Use Space as the leader key.
let mapleader = " "

" Load the shared Vim runtime for colors and common autoloads.
set runtimepath^=~/.vim

" Bootstrap lazy.nvim.
lua << EOF_LUA
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\\nPress any key to exit...", "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
EOF_LUA

" Use the macOS system clipboard for ordinary yank and paste operations.
set clipboard=unnamedplus

" Use the light Solarized Bright palette consistently with Ghostty, tmux, and Pi.
set background=light
" Solarized uses the terminal's ANSI palette for its cterm highlights.
set notermguicolors
filetype plugin indent on
syntax enable
colorscheme solarized-bright

" Configure plugins with lazy.nvim.
lua << EOF_LUA
require("lazy").setup({
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>b", group = "buffers" },
        { "<leader>m", group = "markdown" },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Grep text" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "List buffers" },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = {},
  },
}, {
  checker = { enabled = true },
})

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>mt", "<cmd>Markview toggle<CR>", { desc = "Toggle Markdown rendering" })
vim.keymap.set("n", "<leader>mh", "<cmd>Markview hybridToggle<CR>", { desc = "Toggle hybrid Markdown editing" })
vim.keymap.set("n", "<leader>ms", "<cmd>Markview splitToggle<CR>", { desc = "Toggle Markdown split preview" })
EOF_LUA

" Navigate between buffers.
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

" Navigate the quickfix list.
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

" Navigate the location list.
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>

" Navigate the tag stack.
nnoremap <silent> [t :tprevious<CR>
nnoremap <silent> ]t :tnext<CR>

" Use tree-style netrw with hjkl navigation.
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25

" Open PDFs selected in netrw with tdf instead of reading their bytes in Nvim.
lua << EOF_LUA
local default_open = vim.ui.open

vim.ui.open = function(path, opts)
  if path:lower():match("%.pdf$") then
    if vim.fn.executable("tdf") == 0 then
      vim.notify("tdf is not installed or not on PATH", vim.log.levels.ERROR)
      return true
    end

    vim.cmd("botright new")
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()

    vim.fn.termopen({ "tdf", path }, {
      on_exit = function()
        vim.schedule(function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          elseif vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end)
      end,
    })
    vim.cmd("startinsert")
    return true
  end

  return default_open(path, opts)
end
EOF_LUA

" Return focus to the Lexplore window after opening a file.
" Netrw calls g:Netrw_funcref before its browse command has fully returned;
" defer the window switch until the command and related WinEnter events finish.
function! NetrwFocusWindow(winid, timer) abort
  if win_id2tabwin(a:winid)[0] == tabpagenr()
    call win_gotoid(a:winid)
  endif
endfunction

function! NetrwReturnToLexplore() abort
  let l:lexbuf = gettabvar(tabpagenr(), 'netrw_lexbufnr', -1)
  if l:lexbuf <= 0
    return
  endif

  let l:lexwin = bufwinid(l:lexbuf)
  if l:lexwin > 0
    " Switch immediately, then repeat after Netrw's command finishes.
    call win_gotoid(l:lexwin)
    call timer_start(0, function('NetrwFocusWindow', [l:lexwin]))
  endif
endfunction

" Find the file window targeted by Lexplore.
function! NetrwLexploreFileWindow() abort
  let l:lexbuf = gettabvar(tabpagenr(), 'netrw_lexbufnr', -1)
  if l:lexbuf <= 0
    return 0
  endif

  let l:lexwin = bufwinid(l:lexbuf)
  if l:lexwin <= 0
    return 0
  endif

  " Prefer Netrw's native preview window when one is open.
  for l:info in getwininfo()
    if l:info.tabnr == tabpagenr()
          \ && l:info.winid != l:lexwin
          \ && getwinvar(l:info.winid, '&previewwindow')
      return l:info.winid
    endif
  endfor

  let l:chgwin = get(g:, 'netrw_chgwin', -1)
  if l:chgwin > 0 && l:chgwin <= winnr('$')
    let l:target = win_getid(l:chgwin, tabpagenr())
    if l:target > 0 && l:target != l:lexwin
      return l:target
    endif
  endif

  for l:info in getwininfo()
    if l:info.tabnr == tabpagenr()
          \ && l:info.winid != l:lexwin
          \ && getbufvar(l:info.bufnr, '&filetype') !=# 'netrw'
      return l:info.winid
    endif
  endfor

  return 0
endfunction

" Scroll the file shown beside Lexplore without leaving the explorer focused.
function! NetrwScrollLexplore(direction) abort
  let l:browser = win_getid()
  let l:key = a:direction > 0 ? "\<C-f>" : "\<C-b>"
  let l:target = NetrwLexploreFileWindow()

  if l:target <= 0
    execute 'normal! ' . l:key
    return
  endif

  call win_execute(l:target, 'normal! ' . l:key)
  call win_gotoid(l:browser)
endfunction

function! NetrwOpenPdfOrFile() abort
  " Strip a possible symlink target before checking the selected entry.
  let l:entry = substitute(getline('.'), '\s\+-->.*$', '', '')

  if l:entry =~? '\.pdf\%([*@]\)\=\s*$' && l:entry !~# '/\s*$'
    " Netrw's x mapping resolves the full path, including spaces and tree entries.
    execute "normal x"
  else
    " Preserve Netrw's normal directory/file behavior for everything else.
    execute "normal \<Plug>NetrwLocalBrowseCheck"
  endif
endfunction

function! NetrwSetupMaps() abort
  " <Plug> mappings keep Netrw's own directory handling intact.
  nmap <silent> <buffer> l <Plug>NetrwLocalBrowseCheck
  nmap <silent> <buffer> h <Plug>NetrwTreeSqueeze
  nnoremap <silent> <buffer> <CR> :call NetrwOpenPdfOrFile()<CR>
  nnoremap <silent> <buffer> <PageUp> :call NetrwScrollLexplore(-1)<CR>
  nnoremap <silent> <buffer> <PageDown> :call NetrwScrollLexplore(1)<CR>
endfunction

augroup netrw_hjkl_focus
  autocmd!
  autocmd FileType netrw call NetrwSetupMaps()
augroup END

let g:Netrw_funcref = function('NetrwReturnToLexplore')
