extends Node

const SAVE_PATH := "user://gamestate.dat"
const SCHEMA_VERSION := 1

var _state: Dictionary = {}


func _ready() -> void:
	load_state()


func load_state() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_state = _default_state()
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		_state = file.get_var(true)
		if _state.get("schema_version", 0) != SCHEMA_VERSION:
			_state = _default_state()


func save_state() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(_state, true)


func get_value(key: String, default: Variant = null) -> Variant:
	return _state.get(key, default)


func set_value(key: String, value: Variant) -> void:
	_state[key] = value
	save_state()


func _default_state() -> Dictionary:
	return {
		"schema_version": SCHEMA_VERSION,
		"unlocked_scenes": ["lantern_clearing"],
		"return_count": 0,
		"last_emotion": "",
	}
