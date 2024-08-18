extends Sprite2D

@export var projectile_speed : int = 300
@export var projectile_damage : int = 1
@onready var projectile = $"."
var player : CharacterBody2D
var direction
var desired_direction

func _ready():
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = player_list[0] as CharacterBody2D
		desired_direction = global_position.direction_to(player.global_position)
		desired_direction *= projectile_speed
	

func _physics_process(delta):
	move_local_x(desired_direction[0] * delta)
	move_local_y(desired_direction[1] * delta)

#func _on_area_entered(area):
	#if area.is_in_group("Enemy"):
		#curr_pierce += 1
		#if curr_pierce >= max_pierce:
			#queue_free()

func _on_timer_timeout():
	queue_free()
