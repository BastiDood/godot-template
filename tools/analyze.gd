extends SceneTree

const SKIPPED_DIRS: Array[String] = ["res://addons"]


func _initialize() -> void:
	var failures := 0
	var script := GDScript.new()
	for path in _collect_scripts("res://"):
		# A cached script has already compiled in this process, including this file.
		if ResourceLoader.has_cached(path):
			continue
		script.source_code = FileAccess.get_file_as_string(path)
		script.resource_path = path
		if script.reload() != OK:
			failures += 1
	quit(1 if failures > 0 else 0)


func _collect_scripts(dir: String) -> PackedStringArray:
	var paths := PackedStringArray()
	if dir in SKIPPED_DIRS or FileAccess.file_exists(dir.path_join(".gdignore")):
		return paths
	for file in DirAccess.get_files_at(dir):
		if file.get_extension() == "gd":
			var failed := paths.append(dir.path_join(file))
			assert(not failed)
	for subdir in DirAccess.get_directories_at(dir):
		paths.append_array(_collect_scripts(dir.path_join(subdir)))
	return paths
