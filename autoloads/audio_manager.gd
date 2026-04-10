extends Node

# Audio buses (Music, SFX, Ambient) must be created in Godot Audio Bus Layout editor

const CROSSFADE_TIME := 1.0
const SFX_POOL_SIZE := 8

var _music_player_a: AudioStreamPlayer
var _music_player_b: AudioStreamPlayer
var _active_player: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _sfx_index: int = 0
var _ambient_player: AudioStreamPlayer


func _ready() -> void:
	_music_player_a = AudioStreamPlayer.new()
	_music_player_a.bus = "Music"
	add_child(_music_player_a)

	_music_player_b = AudioStreamPlayer.new()
	_music_player_b.bus = "Music"
	add_child(_music_player_b)

	_active_player = _music_player_a

	for i: int in range(SFX_POOL_SIZE):
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_sfx_pool.append(player)

	_ambient_player = AudioStreamPlayer.new()
	_ambient_player.bus = "Ambient"
	add_child(_ambient_player)


func play_music(stream: AudioStream) -> void:
	if _active_player.playing and _active_player.stream == stream:
		return
	_crossfade_to(stream)


func _crossfade_to(new_stream: AudioStream) -> void:
	var inactive_player: AudioStreamPlayer = _music_player_b if _active_player == _music_player_a else _music_player_a
	inactive_player.stream = new_stream
	inactive_player.play()
	var tween := create_tween().bind_node(_active_player)
	tween.tween_method(_set_volume.bind(_active_player), 1.0, 0.0, CROSSFADE_TIME)
	tween.parallel().tween_method(_set_volume.bind(inactive_player), 0.0, 1.0, CROSSFADE_TIME)
	await tween.finished
	_active_player.stop()
	_active_player = inactive_player


func _set_volume(value: float, player: AudioStreamPlayer) -> void:
	player.volume_db = linear_to_db(value)


func play_sfx(stream: AudioStream) -> void:
	var player: AudioStreamPlayer = _sfx_pool[_sfx_index]
	player.stream = stream
	player.play()
	_sfx_index = (_sfx_index + 1) % SFX_POOL_SIZE


func play_ambient(stream: AudioStream) -> void:
	if _ambient_player.playing and _ambient_player.stream == stream:
		return
	_ambient_player.stream = stream
	_ambient_player.play()


func set_bus_volume(bus_name: String, volume_linear: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(volume_linear))
