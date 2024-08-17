extends Area2D

var traveled_distance = 0

func _physics_process(delta):
	# Max speed and range of bullet
	const SPEED = 1000
	const RANGE = 200
	
	# Sets direction and rotation for bullet being shot
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	traveled_distance += SPEED * delta
	print("traveled_distance: ", traveled_distance)
	# If bullet is out of range, delete the bullet
	if traveled_distance > RANGE:
		queue_free()


func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
