@warning_ignore("missing_tool")
extends "res://addons/gd-plug/plug.gd"


func _plugging() -> void:
	plug("godot-gdunit-labs/gdUnit4", {
		"tag": "v6.2.3",
		"exclude": ["addons/gdUnit4/test/"],
		"dev": true,
	})
