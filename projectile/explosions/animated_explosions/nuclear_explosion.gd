extends AnimatedSprite2D

@export var projectile_damage : int = 750

func _ready():
	animation_finished

func _on_animation_finished():
	queue_free()

func deal_damage() -> int:
	return projectile_damage

