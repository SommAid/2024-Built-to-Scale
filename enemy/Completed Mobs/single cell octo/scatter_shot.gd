extends AnimatedSprite2D

var speed : int = 750
var direction : Vector2 
var damage_amount : int = 1


func _physics_process(delta):
	move_local_x(direction[0] * speed * delta)
	move_local_y(direction[1] * speed * delta)


func _on_timer_timeout():
	queue_free()

func _on_hitbox_area_entered(area):
	print("Bullet area entered")
	bullet_impact()

func get_damage_amount() -> int:
	return damage_amount

func bullet_impact():
	queue_free()
