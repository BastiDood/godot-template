[windows]
set shell := ["pwsh", "-NoLogo", "-NoProfile", "-Command"]

# The GUI build on Windows detaches from the shell, which drops its output and exit code.
godot := if os_family() == "windows" { "godot_console" } else { "godot" }

# Install addons before building the import cache. Run after every clone and `tools/plug.gd` change.
default: install import

# `gd-plug install` exits non-zero whether it succeeds or fails, so `install` ignores its exit status.
# https://github.com/imjp94/gd-plug/issues/36

# Install addons from `tools/plug.gd`.
install:
	-{{ godot }} --headless --script res://tools/plug.gd install

# Build the import cache.
import:
	{{ godot }} --headless --import

# Open the project in the Godot editor.
open:
	godot --editor

# Run the main scene without the editor.
run:
	{{ godot }}

# Check formatting across the project.
fmt:
	gdstyle fmt --check .

# Run every `gdstyle` lint rule.
lint:
	gdstyle check . --max-warnings 0

# Compile every project script with all analyzer warnings treated as errors.
check:
	{{ godot }} --headless --script res://tools/analyze.gd

# Run every GdUnit4 suite in the project.
test:
	{{ godot }} --headless --script res://addons/gdUnit4/bin/GdUnitCmdTool.gd --add res:// --continue --ignoreHeadlessMode

# Apply lint fixes before formatting fixes.
fix: lint-fix fmt-fix

# Apply safe `gdstyle` lint fixes.
lint-fix:
	gdstyle check . --fix --max-warnings 0

# Apply formatting fixes across the project.
fmt-fix:
	gdstyle fmt .

# Export release builds for every preset in parallel.
[parallel]
build: (build-preset "Linux") (build-preset "Windows Desktop") (build-preset "Web")

# Export the release build of one preset into its `export_path`.
build-preset preset:
	{{ godot }} --headless --export-release "{{ preset }}"
