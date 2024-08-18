extends CharacterBody2D

@export var SPEED = 300

var dir: Vector2
var spawnPos: Vector2
var spawnRot: float
var zdex: int 
var player : CharacterBody2D
var player_direction: Vector2
var projectile_damage : int = 1

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex
	# Check if player is still alive before indexing
	if get_tree().get_nodes_in_group("Player").size() > 0:
		player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
		player_direction = global_position.direction_to(player.global_position)

func _physics_process(_delta):
	#var distance = global_position.distance_to(player.global_position)
	
	velocity = player_direction*SPEED
	#print("Velocity: ", str(velocity))
	move_and_slide()


func _on_life_timeout():
	queue_free()

func deal_damage() -> int:
	return projectile_damage

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Player"):
		queue_free() # Replace with function body.
