extends Node

signal line_ready(text: String)

var _lines: Array[Dictionary] = []
var _current_index: int = 0


func load_region(region_name: String) -> void:
	var path := "res://data/dialogue/%s.json" % region_name
	if not FileAccess.file_exists(path):
		push_warning("DialogueManager: no dialogue file for region: %s" % region_name)
		return
	var file := FileAccess.open(path, FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_as_text())
	_lines = json.data
	_current_index = 0


func get_line(emotion: String) -> void:
	var candidates: Array[Dictionary] = []
	for l: Dictionary in _lines:
		if l.get("emotion", "") == emotion:
			candidates.append(l)
	if candidates.is_empty():
		candidates = _lines
	if candidates.is_empty():
		return
	var picked: Dictionary = candidates[randi() % candidates.size()]
	line_ready.emit(picked.get("text", ""))
