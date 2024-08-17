extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var pistol = $WeaponPivot/Pistol

var enemies = []

func _physics_process(_delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
		
		# print("enemies_in_range: ", enemies_in_range)

func enter():
	enemies = get_tree().get_nodes_in_group("Enemy");

func shoot():
	const BULLET = preload("res://projectile/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)

# Begins shooting gun after timer cooldown ends
func _on_timer_timeout():
	shoot()
