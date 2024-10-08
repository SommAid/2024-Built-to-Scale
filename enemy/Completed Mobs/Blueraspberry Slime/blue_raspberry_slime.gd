extends CharacterBody2D

@export_category("Enemy Velocity")
@export var enemy_speed : int = 50
@export var jump_velocity : int = -400

@export_category("Enemy Health")
@export var max_health : int = 15
@export var health_amount : int = 15

@export_category("Enemy Damage")
@export var damage_amount : int = 1
@export var range : int = 100

var slime_glob = preload("res://enemy/Completed Mobs/Blueraspberry Slime/slime_glob.tscn")

@onready var healthbar = $healthbar
@onready var muzzle = $muzzle
@onready var animated_sprite_2d = $AnimatedSprite2D
# @onready var player = get_node("/root/TestLevel/PlayerCat")

var player : CharacterBody2D
enum enemy_state {Attack, Walk, Dying}
var current_state : enemy_state = enemy_state.Walk
var muzzle_position
var can_shoot : bool = true
var can_walk : bool = true
var is_dying : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	muzzle_position = muzzle.position
	animated_sprite_2d.play("walk")
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = player_list[0] as CharacterBody2D
	healthbar.max_value = max_health
	update_health_ui()

func update_health_ui():
	set_health_bar()

func  set_health_bar():
	healthbar.value = health_amount

func _physics_process(_delta):
	var direction : Vector2
	var distance : float = KEY_NONE
	if player != null:
		direction = global_position.direction_to(player.global_position)
		distance = global_position.distance_to(player.global_position)
		var flip = false if direction[0] < 0 else true
		animated_sprite_2d.flip_h = flip
		slime_muzzle_position(flip)
		if current_state != enemy_state.Dying:
			if distance > range:
				enemy_walk(direction)
			elif distance <= range:
				enemy_attack(direction)
	move_and_slide()
	
func enemy_walk(direction : Vector2):
	if can_walk:
		current_state = enemy_state.Walk
		animated_sprite_2d.play("walk")
		velocity = direction * enemy_speed

func enemy_attack(direction : Vector2):
	velocity = direction * 0
	if can_shoot:
		current_state = enemy_state.Attack
		var instance = slime_glob.instantiate() as Node2D
		instance.global_position = muzzle.global_position
		get_parent().add_child(instance)
		animated_sprite_2d.play("attack")
		can_shoot = false
		can_walk = false
		animated_sprite_2d.animation_finished

func deal_damage() -> int:
	return damage_amount

func slime_muzzle_position(flip : bool):
	if flip:
		muzzle.position.x = -muzzle_position.x
	else:
		muzzle.position.x = muzzle_position.x

func _on_hurtbox_area_entered(area):
	if area.has_method("get_damage_amount"):
		var node = area as Node
		health_amount -= node.damage_amount
		update_health_ui()
		# print("Health amount: ", str(health_amount))
		if health_amount <= 0:
			velocity = Vector2.ZERO
			current_state = enemy_state.Dying
			animated_sprite_2d.play("death")
			animated_sprite_2d.animation_finished

func _on_animated_sprite_2d_animation_finished():
	if current_state == enemy_state.Attack:
		can_shoot = true
		can_walk = true
	elif current_state == enemy_state.Dying:
		queue_free()
