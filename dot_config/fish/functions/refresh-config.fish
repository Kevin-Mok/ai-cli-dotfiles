function refresh-config
    cp ~/.codex/config.toml ~/linux-config/dot_codex/config.toml
    and echo 'Synced Codex config.'
    chezmoi apply
    and echo 'Applied chezmoi.'
    # and tmux source-file ~/.tmux.conf
    # and echo 'Sourced tmux config.'

    sync-shortcuts
    echo 'Synced shortcuts.'
    source ~/.config/fish/key_abbr.fish > /dev/null
    and echo 'Sourced shortcuts.'
    and echo 'Reloading fish.'
    and exec fish
end
