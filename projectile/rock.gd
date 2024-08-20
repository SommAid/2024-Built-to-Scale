extends Area2D

var traveled_distance = 0
@export_category("Gun Mechanics")
@export var damage_amount : int = 7
@export var max_pierce : int = 2
var curr_pierce : int = 0

func _physics_process(delta):
	# Max speed and range of bullet
	const SPEED = 1000
	const RANGE = 200
	
	# Sets direction and rotation for bullet being shot
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	
	traveled_distance += SPEED * delta
	# print("traveled_distance: ", traveled_distance)
	# If bullet is out of range, delete the bullet
	if traveled_distance > RANGE:
		queue_free()

func get_damage_amount() -> int:
	return damage_amount

func _on_area_entered(area):
	if area.is_in_group("Enemy"):
		curr_pierce += 1
		if curr_pierce >= max_pierce:
			queue_free()
			
