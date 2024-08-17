extends Area2D

var traveled_distance = 0
var damage_amount : int = 1

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
	print("Bullet area entered")
