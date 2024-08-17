extends Node

var pause_state : bool = false

var pause_menu_screen = preload("res://UI/pause_screen.tscn")
var main_menu_screen = preload("res://UI/main_menu.tscn")
var test_level = "res://levels/test_level.tscn"
var PAUSE_MENU_SCREEN_instance

func pause_game():
	pause_state = true
	get_tree().paused = pause_state
	PAUSE_MENU_SCREEN_instance = pause_menu_screen.instantiate()
	get_tree().get_root().add_child(PAUSE_MENU_SCREEN_instance)
	

func resume_game():
	if PAUSE_MENU_SCREEN_instance != null && pause_state:
		PAUSE_MENU_SCREEN_instance.queue_free()
	if pause_state:
		pause_state = false
		get_tree().paused = pause_state

func menu_menu():
	var main_menu_screen_instance = main_menu_screen.instantiate()
	get_tree().current_scene.queue_free()
	get_tree().get_root().add_child(main_menu_screen_instance)
	
func exit_game():
	get_tree().quit()
	
func start_game():
	resume_game()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(test_level)
