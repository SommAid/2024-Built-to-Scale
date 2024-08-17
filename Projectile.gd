extends CharacterBody2D

@export var SPEED = 300

var dir: Vector2
var spawnPos: Vector2
var spawnRot: float
var zdex: int 
var player : CharacterBody2D
var player_direction: Vector2

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	player_direction = global_position.direction_to(player.global_position)

func _physics_process(_delta):
	velocity = player_direction*SPEED
	move_and_slide()

func _on_area_2d_body_entered(body):
	print("hit")
	queue_free()


func _on_life_timeout():
	queue_free()
