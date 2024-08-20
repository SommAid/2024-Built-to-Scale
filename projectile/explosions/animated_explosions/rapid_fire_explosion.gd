extends AnimatedSprite2D

@export var projectile_damage : int = 25
@onready var projectile = $"."
@onready var timer = $Timer

var player : CharacterBody2D
var direction
var desired_direction

func _ready():
	timer.start()
	
func _physics_process(delta):
	move_local_x(desired_direction[0] * delta)
	move_local_y(desired_direction[1] * delta)

func _on_timer_timeout():
	queue_free()

func deal_damage() -> int:
	return projectile_damage

func _on_hitbox_area_entered(area):
	if area.is_in_group("Player"):
		queue_free()

