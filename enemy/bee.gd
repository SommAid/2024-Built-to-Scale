extends Node2D

@onready var main = get_tree().get_root().get_node("TestLevel")
@onready var projectile = load("res://enemy/projectile.tscn")
@onready var beebody = %beebody

var player : CharacterBody2D
var player_direction : float


func shoot():
	var instance = projectile.instantiate()
	#instance.dir = rotation
	instance.spawnPos = beebody.global_position
	instance.spawnRot = rotation
	#instance.zdex = z_index-1
	main.add_child.call_deferred(instance)
	# print(player_direction)

func _on_timer_timeout():
	shoot()
	# print("shooting")
