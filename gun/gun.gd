extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

var enemies = []

func _physics_process(_delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
		# print("enemies_in_range: ", enemies_in_range)

func enter():
	enemies = get_tree().get_nodes_in_group("Enemy");
	
