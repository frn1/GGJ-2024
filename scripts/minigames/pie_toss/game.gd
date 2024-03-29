extends Node2D

@export var play_time = 20.5

var start_time

var Minigame = preload("res://scripts/minigame.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = Time.get_ticks_usec() / 1e+6
	pass # Replace with function body.

var minigame_ended = false
var played_alarm = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var remaining_time = max(play_time - (Time.get_ticks_usec() / 1e+6 - start_time), 0)
	if played_alarm == false && remaining_time <= 6:
		$sec.play()
		played_alarm = true
	if remaining_time <= 0 && minigame_ended == false:
		if $"P1 Shooter".score > $"P2 Shooter".score:
			get_parent().end_minigame(Minigame.MinigameEndState.P1Won)
		elif $"P2 Shooter".score > $"P1 Shooter".score:
			get_parent().end_minigame(Minigame.MinigameEndState.P2Won)
		else:
			get_parent().end_minigame(Minigame.MinigameEndState.Tie)
		minigame_ended = true
		var timeup = $timeup
		timeup.play()
		timeup.reparent(get_tree().root)
		timeup.finished.connect(timeup.queue_free)
	$Timer/Timer.text = "%04.1fs" % remaining_time
