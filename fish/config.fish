if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_add_path /opt/homebrew/bin
    fish_default_key_bindings
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by Antigravity
fish_add_path /Users/wujunchao/.antigravity/antigravity/bin
