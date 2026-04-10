extends Node

signal tapped(position: Vector2)
signal swiped(direction: Vector2)
signal dragged(delta: Vector2)

const TAP_MAX_DURATION := 0.3
const SWIPE_MIN_DISTANCE := 50.0

var _touch_start_pos: Vector2
var _touch_start_time: float


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_touch_start_pos = event.position
			_touch_start_time = Time.get_ticks_msec() / 1000.0
		else:
			var duration: float = (Time.get_ticks_msec() / 1000.0) - _touch_start_time
			var delta: Vector2 = event.position - _touch_start_pos
			if duration < TAP_MAX_DURATION and delta.length() < SWIPE_MIN_DISTANCE:
				tapped.emit(event.position)
			elif delta.length() >= SWIPE_MIN_DISTANCE:
				swiped.emit(delta.normalized())
	elif event is InputEventScreenDrag:
		dragged.emit(event.relative)
