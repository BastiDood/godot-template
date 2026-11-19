# Checklist

- [ ] Set the project name under `Project > Project Settings > Application > Config > Name`.
- [ ] Rename the `game` binaries in each `export_path` of [`export_presets.cfg`](./export_presets.cfg).
- [ ] Replace the empty [`src/main.tscn`](./src/main.tscn) with the game's main scene.

# Requirements

- [Godot 4.7+](https://godotengine.org/download)
- [Just 1.59+](https://github.com/casey/just)
- [gdstyle 0.7+](https://github.com/atelico/gdstyle)
- [PowerShell 7+](https://github.com/PowerShell/PowerShell) 

Godot must be on the `PATH` as `godot`, and as `godot_console` on Windows. Exporting also requires the Godot export templates, which the editor installs from `Editor > Manage Export Templates`.

# Development

## Setting Up the Project

```bash
# Install GdUnit4 through gd-plug and build the import cache.
# Rerun after every clone and every change to `tools/plug.gd`.
just

# Open the project in the Godot editor.
just open

# Run the main scene without the editor.
just run
```

## Using an External Editor

The GDScript language server runs inside the Godot editor. `just lsp` starts the editor without a window, so external editors get completion, diagnostics, and go-to-definition without the full editor open.

```bash
# Serve the language server on Godot's default port, 6005.
just lsp

# Serve it on another port.
just lsp 6008
```

For [Zed](https://zed.dev), install the [GDScript extension](https://github.com/GDQuest/zed-gdscript) and [Netcat](https://nmap.org/ncat/) as `nc` or `ncat` on the `PATH`. Keep `just lsp` running in a terminal, then run `editor: restart language server` in Zed to connect. The extension connects to `127.0.0.1:6005` by default, so another port also needs this in Zed's `settings.json`.

```json
{
  "lsp": {
    "gdscript": {
      "binary": {
        "arguments": ["127.0.0.1", "<port>"]
      }
    }
  }
}
```

## Adding Plugins

[gd-plug](https://github.com/imjp94/gd-plug) installs every addon declared in [`tools/plug.gd`](./tools/plug.gd). Installed addons are ignored by Git, so adding a plugin only changes `tools/plug.gd`, `project.godot`, and sometimes `export_presets.cfg`.

### Declaring the Plugin

Add the plugin to [`tools/plug.gd`](./tools/plug.gd), pinned to a tag or a full 40-character commit hash. Mark tooling that must not ship with `"dev": true`.

```gdscript
plug("owner/repo", {"tag": "v1.2.3"})
```

gd-plug only copies the repository's `addons/` folder by default. For repositories with a different layout, set `include` or `install_root`.

### Installing the Plugin

Install the plugin and rebuild the import cache.

```bash
just
```

### Enabling the Plugin

Enable editor plugins under `Project > Project Settings > Plugins`. This adds the plugin to `[editor_plugins]` in [`project.godot`](./project.godot).

### Excluding Dev-Only Plugins from Builds

Add `addons/<name>/*` to every `exclude_filter` in [`export_presets.cfg`](./export_presets.cfg).

### Updating a Plugin

Change its tag or commit in `tools/plug.gd`, then run `just` again.

## Linting the Codebase

```bash
# Check formatting.
just fmt

# Run every `gdstyle` lint rule.
just lint

# Compile every script with all GDScript warnings treated as errors.
just check

# Apply lint fixes, then formatting fixes.
just fix
```

## Testing the Codebase

Tests are GdUnit4 suites named `<file>_test.gd`, which should be collocated next to the script that they test.

```bash
# Run every test suite in the project.
just test
```

## Exporting the Game

```bash
# Export release builds for Linux, Windows, and the Web into `build/<platform>/` in parallel.
just build

# Export one preset on its own.
just build-preset Web
just build-preset Linux
just build-preset 'Windows Desktop'
```
