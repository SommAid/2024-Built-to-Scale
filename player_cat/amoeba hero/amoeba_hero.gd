extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)
@export var max_player_health : int = 5
@export var health : int = 5
@export var dash_speed = 200

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var healthbar = %healthbar
var dashing = false
var dash_cooldown = true

# can set stuff up when the script first runs
func _ready():
	animated_sprite_2d.play("default")
	healthbar.max_value = max_player_health
	update_health_ui()

func update_health_ui():
	healthbar.value = HealthManager.current_health

func  set_health_bar():
	healthbar.value = health

func _physics_process(_delta):
	
	# Get Input Direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if Input.is_action_just_pressed("dash") and dash_cooldown:
		dashing = true
		dash_cooldown = false
		%dash_timer.start()
		%dash_again_timer.start()
	
	# print(input_direction)
	
	# Update velocity
	if dashing:
		velocity = input_direction * dash_speed
	else:
		velocity = input_direction * move_speed
	
	# Move and Slide function uses vel. of character to move character on map
	
	move_and_slide()

func player_death() -> void:
	queue_free()

func _on_hurtbox_area_entered(area : Node2D):
	# print("Player got hit")
	if area.is_in_group("Enemy") or area.is_in_group("Enemy Projectile"):
		print("Player took damage")
		HealthManager.decrease_health(area.get_parent().deal_damage())
		update_health_ui()
		if HealthManager.current_health <= 0:
			player_death()

func _on_dash_timer_timeout():
	dashing = false

func _on_dash_again_timer_timeout():
	dash_cooldown = true
