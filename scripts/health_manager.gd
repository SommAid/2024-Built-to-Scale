extends Node

var max_health : int = 3
var current_health : int

signal on_health_changed

func _ready():
	current_health = max_health

func set_max_health(max : int):
	max_health = max
	
func decrease_health(damage: int):
	current_health -= damage
	
	if current_health < 0:
		current_health = 0
	
	print("You lost health")
	on_health_changed.emit(current_health)
	
func increase_health(heal: int):
	current_health += heal
	
	if current_health > max_health:
		current_health = max_health
	
	print("You gained health")
	on_health_changed.emit(current_health)


