extends Node

#List of all the signals to be used in the game
#Will most likely be reduced
signal begin_spawn
signal player_speed_up
signal launch
signal boost
signal consume
signal growth_consumed
signal extend
signal force_update_gui
signal points_count_timer
signal end_game

signal start_alteration_timer
signal alter_game
signal alter_ended

#Variables related to the screen
var screen_size : Vector2
var screen_rect : Rect2

#Variables related to the audio
var audio_clips : Dictionary

#Variables related to the game play state
var started : bool = false
var ended : bool = true
var time_paused : bool = true

#Variables related to game alterations (power-ups)
var alter_game_cooldown_timer : float = 10.0
var latest_alteration : String = ""
@onready var active_alterations : Array[alteration] = []

#Variables related to the extension objects for the player
var extension_stop_threshold : int = 44
var extension_spawn_fixed_offset : float = 20
var extension_spawn_offset_distance : int = 24

#Variables related to the food
var food_min_launch_dir : float = -200
var food_max_launch_dir : float = 200

#Variables related to the score and level of the player
var score : int = 0
var time_score : int = 0
var level : int = 1
var level_up_threshold : int = 1

var speed_increase_percent : float = .25

#Adjusts the acknowledged screen size and rect for the world
#Connects the built in size_changed signal to the alter screen size function when screen resized
#Resets the audio clips list
func _ready():
	get_viewport().connect("size_changed", alter_screen_size)
	screen_size = get_viewport().size
	screen_rect = get_viewport().get_visible_rect()
	audio_clips.clear()
	pass

#A simple function to flip the state of the game
func swap_game_state():
	started = not started
	ended = not ended
	pass

#A simple function to flip the processing state of the game
func stop_start_time():
	time_paused = not time_paused
	pass

#Loads a sound file from the path while naming it the clip name
#Sets the loaded file as a sound clip and addes it to the audio clips list as its clip name
func load_mp3(path, clip_name):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	audio_clips[clip_name] = sound

#A simple function to fetch the requested audio clip by name
func play_mp3(clip_name):
	return audio_clips.get(clip_name)

#Called when the screen size is adjusted and sets the acknowledged variables to the new sizes
func alter_screen_size():
	screen_size = get_viewport().size
	screen_rect = get_viewport().get_visible_rect()
	pass

#Clears the score and level for the player
func reset_score():
	Globals.score = 0
	Globals.time_score = 0
	Globals.level = 1
	Globals.level_up_threshold = 1
	pass

#Adds points to the score of the player and levels up when score goes beyond threshold
#Tells the GUI to update itself with the new score
func add_points(value):
	score += value
	if score >= level_up_threshold:
		level_up()
	emit_signal("force_update_gui")
	pass

#Adds points to the time_score that is awarded to the player for the longer they survive
func add_time_score(value):
	time_score += value
	pass

#Called when players points go beyond required threshold
#At certain thresholds, the game starts spawning alterations (power-ups) and begins counting time for points
#Each level up makes the player go faster
func level_up():
	level += 1
	level_up_threshold += 2
	if level == 2:
		emit_signal("start_alteration_timer")
	if level == 5:
		emit_signal("points_count_timer")
		pass
	emit_signal("player_speed_up", speed_increase_percent)
	pass
