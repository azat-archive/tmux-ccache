### `tmux` `ccache` status

Enables displaying of the `ccache` statistics in the `status-right`/`status-left`.


### Installation

##### Installation with tmux plugin manager

Add plugin to the list of TPM plugins in .tmux.conf:

```
set -g @plugin 'azat-archive/tmux-ccache'
```

Hit `prefix + I` to fetch the plugin and source it.

If format strings are added to `status-right`, they should now be visible.

### Supported Options

- `@ccache_icon`

### Supported formatters

- `#{ccache_status}` - shortcut for status with a symbol
- `#{ccache_cache_hit_rate}` - will display cache hit
- And any key from the `ccache --print-stats` with `ccache_` prefix
