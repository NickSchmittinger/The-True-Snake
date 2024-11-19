extends Node

signal begin_spawn
signal player_speed_up
signal launch
signal boost
signal consume
signal extend
signal force_update_gui
signal end_game

signal start_alteration_timer
signal alter_game
signal alter_ended

var screen_size : Vector2
var screen_rect : Rect2


var audio_clips : Dictionary

var started : bool = false
var ended : bool = true
var time_paused : bool = true

var alter_game_cooldown_timer : float = 10.0
var latest_alteration : String = ""
@onready var active_alterations : Array[alteration] = []

var extension_stop_threshold : int = 44
var extension_spawn_fixed_offset : float = 20
var extension_spawn_offset_distance : int = 24

var food_min_launch_dir : float = -200
var food_max_launch_dir : float = 200

var score : int = 0
var level : int = 1
var level_up_threshold : int = 1

var speed_increase_percent : float = .25

func _ready():
	get_viewport().connect("size_changed", alter_screen_size)
	screen_size = get_viewport().size
	screen_rect = get_viewport().get_visible_rect()
	audio_clips.clear()
	pass

func swap_game_state():
	started = not started
	ended = not ended
	pass

func stop_start_time():
	time_paused = not time_paused
	pass

func load_mp3(path, clip_name):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	audio_clips[clip_name] = sound

func play_mp3(clip_name):
	return audio_clips.get(clip_name)

func alter_screen_size():
	screen_size = get_viewport().size
	screen_rect = get_viewport().get_visible_rect()
	pass

func reset_score():
	Globals.score = 0
	Globals.level = 1
	Globals.level_up_threshold = 1
	pass

func add_points(value):
	score += value
	if score >= level_up_threshold:
		level_up()
	emit_signal("force_update_gui")
	pass

func level_up():
	level += 1
	level_up_threshold += 2
	if level == 2:
		emit_signal("start_alteration_timer")
	emit_signal("player_speed_up", speed_increase_percent)
	pass
