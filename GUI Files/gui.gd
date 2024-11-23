extends Control

@onready var countdownLabel = $CountdownLabel
@onready var countdownTimer = $CountdownLabel/CountdownTimer
@onready var animPlayer = $CountdownLabel/AnimationPlayer
@onready var gameTimeLabel = $GameTimePanel/GameTimeLabel
@onready var scoreLabel = $ScorePanel/ScoreLabel
@onready var introOutroLabel = $IntroOutroLabel

@onready var audio_player = $AudioStreamPlayer
@export var gui_audio_paths : Dictionary


@export var initial_countdown_completed : bool = false
var current_time : float = 0
var points_add_time : bool = false

func _ready():
	Globals.connect("force_update_gui", update_score)
	Globals.connect("points_count_timer", begin_adding_time)
	Globals.connect("end_game",end_game)
	Globals.connect("start_alteration_timer",_on_countdown_timer_timeout)
	Globals.connect("alter_ended", clear_alteration_text)
	for a in gui_audio_paths:
		Globals.load_mp3(gui_audio_paths.get(a), a)
	pass

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

func _unhandled_input(event):
	if event.is_action_pressed("space") && Globals.ended:
		countdownTimer.stop()
		animPlayer.play("RESET")
		start_game_countdown()
		pass
	pass

func start_game_countdown():
	current_time = 0
	Globals.reset_score()
	countdownLabel.visible = true
	swap_gui_states()
	Globals.swap_game_state()
	play_intro_audio()
	pass

func finish_game_countdown():
	Globals.stop_start_time()
	countdownLabel.visible = false
	Globals.emit_signal("begin_spawn")
	pass

func play_intro_audio():
	audio_player.stream = Globals.play_mp3("OhNo")
	audio_player.play(0)
	countdownTimer.start(audio_player.stream.get_length())
	pass

func swap_gui_states():
	introOutroLabel.visible = not introOutroLabel.visible
	scoreLabel.visible = not scoreLabel.visible

func update_score():
	scoreLabel.text = str(Globals.score)
	pass

func begin_adding_time():
	points_add_time = true
	pass

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

func start_spawning_alterations():
	## Potentially remove. ##
	await get_tree().create_timer(1).timeout
	## -- ##
	if Globals.started:
		countdownTimer.start(Globals.alter_game_cooldown_timer)
		Globals.emit_signal("alter_game")
		$ActiveAlterationPanel/ActiveAlterationLabel.text = Globals.latest_alteration
	pass

func clear_alteration_text():
	$ActiveAlterationPanel/ActiveAlterationLabel.text = ""
	pass

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

func _on_countdown_timer_timeout():
	if Globals.started && not initial_countdown_completed:
		finish_game_countdown()
		initial_countdown_completed = true
		pass
	elif Globals.started && initial_countdown_completed:
		large_to_small_text(countdownLabel, 5)
		pass
	pass
