extends Area2D

@onready var pistol = $WeaponPivot/Pistol
@onready var weapon_pivot = $WeaponPivot
@onready var gun = $"."

func _physics_process(_delta):
	var enemies_in_range = gun.get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		gun.look_at(target_enemy.global_position)
		if target_enemy.global_position < weapon_pivot.global_position:
			pistol.flip_v = true
		else:
			pistol.flip_v = false
		
		# print("enemies_in_range: ", enemies_in_range)
	
