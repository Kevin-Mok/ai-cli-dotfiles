function refresh-config
    set codex_source_path (chezmoi source-path ~/.codex/config.toml)
    and cp ~/.codex/config.toml $codex_source_path
    and echo 'Copied local Codex config into repo source.'
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
