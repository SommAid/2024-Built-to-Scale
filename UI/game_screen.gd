extends CanvasLayer

func _input(event):
	if event.is_action_pressed("pause menu"):
		if GameManager.pause_state == true:
			GameManager.resume_game()
		else:
			GameManager.pause_game()
