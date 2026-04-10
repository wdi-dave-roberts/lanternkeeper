# Requires scene_transition.tscn (CanvasLayer > ColorRect) -- created in Godot editor
extends CanvasLayer

signal transition_finished

@onready var _overlay: ColorRect = $ColorRect


func _ready() -> void:
	_overlay.color = Color.BLACK
	_overlay.modulate.a = 0.0


func transition_to(scene_path: String) -> void:
	var tween := create_tween()
	tween.tween_property(_overlay, "modulate:a", 1.0, 0.4)
	await tween.finished
	get_tree().change_scene_to_file(scene_path)
	tween = create_tween()
	tween.tween_property(_overlay, "modulate:a", 0.0, 0.4)
	await tween.finished
	transition_finished.emit()
