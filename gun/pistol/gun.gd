extends Area2D

@onready var pistol = $WeaponPivot/Pistol
@onready var weapon_pivot = $WeaponPivot
@onready var gun = $"."

var damage = 1
var enemies = []
var enemies_in_range = []

func _physics_process(_delta):
	enemies_in_range = gun.get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		gun.look_at(target_enemy.global_position)
		if target_enemy.global_position < weapon_pivot.global_position:
			pistol.flip_v = true;
		else:
			pistol.flip_v = false;
		#print(damage)
		# print("enemies_in_range: ", enemies_in_range)

func enter():
	enemies = get_tree().get_nodes_in_group("Enemy");

func shoot():
	const BULLET = preload("res://projectile/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.damage_amount = damage
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)

# Begins shooting gun after timer cooldown ends
func _on_timer_timeout():
	# Ensures there is somebody in range to shoot at
	if enemies_in_range.size() > 0:
		shoot()


func _on_area_entered(area):
	if area.is_in_group("Item"):
		damage +=1
