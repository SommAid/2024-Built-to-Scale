extends CharacterBody2D

@export_category("Enemy Velocity")
@export var enemy_speed : int = 50
@export var jump_velocity : int = -400

@export_category("Enemy Health")
@export var health_amount : int = 5

@export_category("Enemy Damage")
@export var damage_amount : int = 1
@export var range : int = 100

var slime_glob = preload("res://enemy/slime_glob.tscn")

@onready var timer = $Timer
@onready var muzzle = $muzzle
@onready var animated_sprite_2d = $AnimatedSprite2D
# @onready var player = get_node("/root/TestLevel/PlayerCat")

var player : CharacterBody2D
var direction : Vector2
enum enemy_state {Attack, Walk}
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
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D

func _physics_process(delta):
	var speed = enemy_speed
	var direction : Vector2
	var distance : float = KEY_NONE
	if player != null:
		direction = global_position.direction_to(player.global_position)
		distance = global_position.distance_to(player.global_position)

	if distance != KEY_NONE and !is_dying:
		var flip = false if direction[0] < 0 else true
		animated_sprite_2d.flip_h = flip
		slime_muzzle_position(flip)
		if distance <= range:
			speed = 0
			enemy_shoot()
		elif can_walk:
			enemy_walk()
	else:
		speed = 0

	velocity = direction * speed
	move_and_slide()
	
func enemy_walk():
	animated_sprite_2d.play("walk")

func enemy_shoot():
	if can_shoot:
		var instance = slime_glob.instantiate() as Node2D
		instance.global_position = muzzle.global_position
		get_parent().add_child(instance)
		animated_sprite_2d.play("attack")
		can_shoot = false
		can_walk = false
		timer.start()

func deal_damage() -> int:
	return damage_amount

func slime_muzzle_position(flip : bool):
	if flip:
		muzzle.position.x = -muzzle_position.x
	else:
		muzzle.position.x = muzzle_position.x
	

func _on_timer_timeout():
	can_shoot = true
	can_walk = true

func _on_hurtbox_area_entered(area):
	if area.has_method("get_damage_amount"):
		var node = area as Node
		health_amount -= node.damage_amount
		# print("Health amount: ", str(health_amount))
		if health_amount <= 0:
			is_dying = true
			animated_sprite_2d.play("death")
			await get_tree().create_timer(1).timeout
			queue_free() # Replace with function body.
