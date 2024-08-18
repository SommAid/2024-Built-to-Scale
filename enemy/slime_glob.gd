extends AnimatedSprite2D

@export var projectile_speed : int = 300
@export var projectile_damage : int = 1
@onready var projectile = $"."
@onready var timer = $Timer

var player : CharacterBody2D
var direction
var desired_direction

func _ready():
	timer.start()
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = player_list[0] as CharacterBody2D
		desired_direction = global_position.direction_to(player.global_position)
		desired_direction *= projectile_speed
	
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
