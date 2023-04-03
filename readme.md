These are my dotfiles. There are many like them, but these ones are mine.

# installing

Dotfiles can be installed with [chezmoi](https://www.chezmoi.io/).

Requires at least `sudo` and `curl` to install. Linux install assumes the
target is Debian (or at least has `apt`).

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply joshkunz
```
