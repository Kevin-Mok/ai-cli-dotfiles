complete -c install-agent-surface -f
complete -c install-agent-surface -s h -l help -d 'Show help text'
complete -c install-agent-surface -l target -r -d 'Target repo directory'
complete -c install-agent-surface -l global -d 'Install global ~/.agents and ~/.codex/AGENTS.md'
complete -c install-agent-surface -l chezmoi -d 'Install skills under dot_agents/skills'
complete -c install-agent-surface -l skill -r -d 'Copy one tracked skill by name'
complete -c install-agent-surface -l all-skills -d 'Copy every tracked skill with a SKILL.md'
complete -c install-agent-surface -l force -d 'Overwrite existing AGENTS files and copied skill directories'
