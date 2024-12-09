Ideas:
- powerbar should show keyboard inputs, or at least keystrokes in normal or visual mode
- Create menus for each plugin like NvimTree, Telescope, Cmp, etc that shows default and remapped keymappings
- What I really want is maybe just a telescope list I create myself to the help documents of each plugin?
- What's Previous/Next edited buffer? Seen buffer?
- When dedenting in insert mode, but then hitting <CR>, it re-indents
- autopairs seems to not overwrite the closing bracket now?
- Ignore filetypes in Telescope live grep: https://www.reddit.com/r/neovim/comments/11ukbgn/how_to_includeexclude_files_in_telescope_live_grep/
- gx goes to link! but needs http/https. https://www.reddit.com/r/neovim/comments/xv0f4q/how_do_i_make_these_links_open_in_neovim/
- leader + t just go to nvim tree if its already there (toggle focus) instead of ctrl-w all the time
- What are the rest of the builtin g* commands???


Terminal bug:
- For startup or shell-related problems: try env -i TERM=ansi-256color "$(which nvim)".


https://www.reddit.com/r/neovim/comments/1abd2cq/what_are_your_favorite_tricks_using_neovim/
https://www.reddit.com/r/neovim/comments/1af1r03/what_was_that_one_keybinding_that_you_somehow/

https://github.com/rest-nvim/rest.nvim

https://www.youtube.com/shorts/Ofxlqz88pPA
Amazing, you can you use the quickfix list to apply multiple commands at specific locations

TODO replace copilot chat with https://github.com/CopilotC-Nvim/CopilotChat.nvim


TODO:
- Auto-copilot prompt to generate google style docstring
- command to format docstring text into max_lines
