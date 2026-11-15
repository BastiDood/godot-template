# Project Conventions

This is a Godot 4.7 project template written in fully typed GDScript.

- Every GDScript warning is promoted to an error
- Tests live next to the code they test.

## Development Tooling

- `just` is the ONLY supported task runner.
- [gd-plug](https://github.com/imjp94/gd-plug) is the ONLY supported addon manager. Declare addons in [`tools/plug.gd`](./tools/plug.gd) and never edit the installed copies under `addons/`.

### Recipes

See the [configuration file](./justfile) for the exact commands, which you almost never need to read except for debugging. Ad-hoc invocations of `godot` and `gdstyle` are strongly discouraged; rely on the `just` recipes as much as possible.

```bash
# Install addons and build the import cache. Run after every clone and `tools/plug.gd` change.
just

# Check formatting.
just fmt

# Run every `gdstyle` lint rule.
just lint

# Compile every script with all GDScript warnings treated as errors.
just check

# Run every GdUnit4 test suite.
just test

# Apply all lint fixes followed by all formatting fixes.
just fix

# View all available recipes for finer-grained invocation.
just --list
```

### Code Conventions

- Prefer `:=` inference. Write an explicit type only where inference has nothing to infer from or would infer the wrong type.
- Name test suites `<file>_test.gd`, place them next to the script they test, extend `GdUnitTestSuite`, and never give them a `class_name`.

### Repository Hygiene

After implementing features, fixes, and patches: make sure to run the formatters, linters, type checkers, and tests.
