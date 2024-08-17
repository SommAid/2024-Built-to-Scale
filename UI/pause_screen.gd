extends CanvasLayer

func _on_resume_pressed():
	GameManager.resume_game()


func _on_main_menu_pressed():
	GameManager.menu_menu()
	queue_free()
