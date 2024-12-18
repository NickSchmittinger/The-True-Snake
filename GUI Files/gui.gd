extends Control

#Variables for all the visual GUI elements that will be altered mid game
@onready var countdownLabel = $CountdownLabel
@onready var countdownTimer = $CountdownLabel/CountdownTimer
@onready var animPlayer = $CountdownLabel/AnimationPlayer
@onready var gameTimeLabel = $GameTimePanel/GameTimeLabel
@onready var scoreLabel = $ScorePanel/ScoreLabel
@onready var introOutroLabel = $IntroOutroLabel

#Variables for the audio components
@onready var audio_player = $AudioStreamPlayer
@export var gui_audio_paths : Dictionary

#Variables for the time related functionality
@export var initial_countdown_completed : bool = false
var current_time : float = 0
var points_add_time : bool = false

#Connect global signals to functions for updating gui, using the points count timer, ending the game, starting and ending alteration timer
#Loads audio paths into the global stage
func _ready():
	Globals.connect("force_update_gui", update_score)
	Globals.connect("points_count_timer", begin_adding_time)
	Globals.connect("end_game",end_game)
	Globals.connect("start_alteration_timer",_on_countdown_timer_timeout)
	Globals.connect("alter_ended", clear_alteration_text)
	for a in gui_audio_paths:
		Globals.load_mp3(gui_audio_paths.get(a), a)
	pass

#Alters the center screen countdown timer for game start, and alteration spawning
#Alters game time label for tracking current game time
func _process(delta):
	if not countdownTimer.is_stopped() && not initial_countdown_completed:
		countdownLabel.text = "[center]" + str(int(countdownTimer.time_left)) + "[/center]"
	if initial_countdown_completed && not Globals.time_paused:
		current_time += delta
		gameTimeLabel.text = str(current_time).pad_decimals(2)
		pass
	if not countdownTimer.is_stopped() && initial_countdown_completed:
		countdownLabel.text = "%02d" % fmod(countdownTimer.time_left, 60)
		pass

#Starts and Resets the game when the game is not going and a key is pressed
func _unhandled_input(event):
	if event.is_action_pressed("space") && Globals.ended:
		countdownTimer.stop()
		animPlayer.play("RESET")
		start_game_countdown()
		pass
	pass

#Resets all aspects of the game, starts the visual center screen countdown timer, plays intro audio to match the countdown
func start_game_countdown():
	current_time = 0
	Globals.reset_score()
	countdownLabel.visible = true
	swap_gui_states()
	Globals.swap_game_state()
	play_intro_audio()
	pass

#Called when the game start countdown stops: tells teh game to start spawning and make every gameplay element visible
func finish_game_countdown():
	Globals.stop_start_time()
	countdownLabel.visible = false
	Globals.emit_signal("begin_spawn")
	pass

#Plays the intro audio clip by matching it to the start of the countdown timer
func play_intro_audio():
	audio_player.stream = Globals.play_mp3("OhNo")
	audio_player.play(0)
	countdownTimer.start(audio_player.stream.get_length())
	pass

#Alters the visual state of the final score label and existing score labels
func swap_gui_states():
	introOutroLabel.visible = not introOutroLabel.visible
	scoreLabel.visible = not scoreLabel.visible

#Changes the text on the score label
func update_score():
	scoreLabel.text = str(Globals.score)
	pass

#Enables the adding of time to the final score
func begin_adding_time():
	points_add_time = true
	pass

#Called when the game ends: resets score label text
#Combines the score and value of the survived time into a final score
#Ensures the central countdown timer stops counting
#Resets the state of the game for processing
func end_game():
	scoreLabel.text = "0"
	if points_add_time:
		Globals.add_time_score(roundi(current_time / 10))
		introOutroLabel.text = "Score: " + str(Globals.score) + "\nTime Score: " + str(Globals.time_score) +"\nTotal: " + str(Globals.score + Globals.time_score)
	else:
		introOutroLabel.text = "Score: " + str(Globals.score)
	countdownTimer.stop()
	swap_gui_states()

	Globals.swap_game_state()
	Globals.stop_start_time()
	
	Globals.started = false
	points_add_time = false
	initial_countdown_completed = false
	
	## Potentially remove. ##
	await get_tree().create_timer(2).timeout
	pass

#Called when player reaches required level: sends the global signal to begin spawning alterations (power-ups)
#Sets the top of screen text to the last activated alteration
func start_spawning_alterations():
	## Potentially remove. ##
	await get_tree().create_timer(1).timeout
	## -- ##
	if Globals.started:
		countdownTimer.start(Globals.alter_game_cooldown_timer)
		Globals.emit_signal("alter_game")
		$ActiveAlterationPanel/ActiveAlterationLabel.text = Globals.latest_alteration
	pass

#Clears the top of screen text for alterations
func clear_alteration_text():
	$ActiveAlterationPanel/ActiveAlterationLabel.text = ""
	pass

#Function to animate labels to start its text size high and then make it shrink then disappear over time
#Called for starting game and for spawning alterations
func large_to_small_text(label : RichTextLabel, time : float):
	label.visible = true
	for t in time:
		if Globals.started:
			if label.bbcode_enabled:
				label.text = "[center]" + str(time - t) + "[/center]"
			else:
				label.text = str(time - t)
			animPlayer.play("large_to_small_text")
			await animPlayer.animation_finished
			label.text = ""
		else:
			break
	label.visible = false
	if Globals.started:
		start_spawning_alterations()
	pass

#Called when timer ends for starting game and spawning alterations
#Tells the game to start itself or spawn a new alteration
func _on_countdown_timer_timeout():
	if Globals.started && not initial_countdown_completed:
		finish_game_countdown()
		initial_countdown_completed = true
		pass
	elif Globals.started && initial_countdown_completed:
		large_to_small_text(countdownLabel, 5)
		pass
	pass
