extends Node

var pause_state : bool = false
var can_pause : bool = true

var pause_menu_screen = preload("res://UI/pause_screen.tscn")
var main_menu_screen = preload("res://UI/main_menu.tscn")
var test_level = "res://levels/test_level.tscn"
var PAUSE_MENU_SCREEN_instance

func pause_game():
	if can_pause:
		LevelManager.stop_timer()
		pause_state = true
		get_tree().paused = pause_state
		PAUSE_MENU_SCREEN_instance = pause_menu_screen.instantiate()
		get_tree().get_root().add_child(PAUSE_MENU_SCREEN_instance)
	

func resume_game():
	if PAUSE_MENU_SCREEN_instance != null && pause_state:
		PAUSE_MENU_SCREEN_instance.queue_free()
	if pause_state:
		LevelManager.start_timer()
		pause_state = false
		get_tree().paused = pause_state

func menu_menu():
	var main_menu_screen_instance = main_menu_screen.instantiate()
	get_tree().current_scene.queue_free()
	get_tree().get_root().add_child(main_menu_screen_instance)
	
func exit_game():
	get_tree().quit()
	
func start_game():
	LevelManager.start_timer()
	LevelManager.play_level()

func player_death():
	LevelManager.stop_timer()
	LevelManager.reset_timer()
	can_pause = false
	await get_tree().create_timer(2).timeout
	can_pause = true
	menu_menu()
