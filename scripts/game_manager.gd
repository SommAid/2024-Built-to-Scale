extends Node

var pause_state : bool = false

func pause_game():
	pause_state = true
	get_tree().paused = pause_state

func resume_game():
	pause_state = false
	get_tree().paused = pause_state
