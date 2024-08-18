extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)
@export var health : int = 3
@export var dash_speed = 200

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
var dashing = false
var dash_cooldown = true

# can set stuff up when the script first runs
func _ready():
	update_animation_parameters(starting_direction)

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
	update_animation_parameters(input_direction)
	
	# print(input_direction)
	
	# Update velocity
	if dashing:
		velocity = input_direction * dash_speed
	else:
		velocity = input_direction * move_speed
	
	# Move and Slide function uses vel. of character to move character on map
	
	pick_new_state()
	move_and_slide()

func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func player_death() -> void:
	queue_free()

func _on_hurtbox_area_entered(area : Node2D):
	print("Player got hit")
	if area.is_in_group("Enemy") or area.is_in_group("Enemy Projectile"):
		HealthManager.decrease_health(area.get_parent().deal_damage())
		if HealthManager.current_health <= 0:
			player_death()
		# print("Ouch I just took: ", str(area.get_parent().deal_damage()))

func _on_dash_timer_timeout():
	dashing = false

func _on_dash_again_timer_timeout():
	dash_cooldown = true
