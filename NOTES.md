Ideas:
- powerbar should show keyboard inputs, or at least keystrokes in normal or visual mode
- Create menus for each plugin like NvimTree, Telescope, Cmp, etc that shows default and remapped keymappings
- What I really want is maybe just a telescope list I create myself to the help documents of each plugin?
- Fix nerdcommenter to ignore blank / whitespace lines
- Better nerdcommenter mappings
- What's Previous/Next edited buffer? Seen buffer?
- When dedenting in insert mode, but then hitting <CR>, it re-indents
- autopairs seems to not overwrite the closing bracket now?
- Ignore filetypes in Telescope live grep: https://www.reddit.com/r/neovim/comments/11ukbgn/how_to_includeexclude_files_in_telescope_live_grep/
- gx goes to link! but needs http/https. https://www.reddit.com/r/neovim/comments/xv0f4q/how_do_i_make_these_links_open_in_neovim/


Terminal bug:
- For startup or shell-related problems: try env -i TERM=ansi-256color "$(which nvim)".
