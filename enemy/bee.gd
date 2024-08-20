extends Node2D

@onready var main = get_tree().get_root().get_node("TestLevel")
@onready var projectile = load("res://enemy/projectile.tscn")
@onready var beebody = %beebody

var player : CharacterBody2D
var player_direction : float


func shoot():
	# Ensures stingers only spawn in if bee is alive
	if is_instance_valid(beebody):
		var instance = projectile.instantiate() as Node2D
		#instance.dir = rotation
		instance.spawnPos = beebody.global_position
		instance.spawnRot = rotation
		get_parent().add_child(instance)
		#instance.zdex = z_index-1
		#main.add_child.call_deferred(instance)
		# print(player_direction)

func _on_timer_timeout():
	shoot()
	# print("shooting")
