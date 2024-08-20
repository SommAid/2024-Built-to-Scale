extends AnimatedSprite2D

func _ready():
	animation_finished
	
func _on_animation_finished():
	queue_free()
