extends Node


var levels : Array[String] = [
							"res://levels/completed_levels/level_one/level_one.tscn",
							"res://levels/completed_levels/level_two/level_two.tscn",
							"res://levels/completed_levels/level_three/level_three.tscn"]

var curr_level : int = 0
var time = 0
var timer_on = false

func start_timer():
	timer_on = true

func stop_timer():
	timer_on = false

func reset_timer():
	time = 0

func play_level():
	GameManager.resume_game()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(levels[curr_level])

func _process(delta):
	if timer_on:
		time += delta
	
	if time > 150 and curr_level == 0:
		curr_level = 1
		play_level()
	elif time > 300 and curr_level == 1:
		curr_level = 2
		play_level()
	#var secs = fmod(time, 60)
	#var mins = fmod(time, 60*60)/60
	#var time_passed : String = "%02d : %02d" % [mins, secs]
	pass
