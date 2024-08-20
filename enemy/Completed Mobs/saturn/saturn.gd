extends CharacterBody2D

@export_category("Enemy Velocity")
@export var enemy_speed : int = 125
@export var chase_speed : int = 250

@export_category("Enemy Health")
@export var health_amount : int = 500

@export_category("Enemy Attack")
@export var damage_amount : int = 500

# @onready var healthbar = $healthbar
@onready var sprite_2d = $Sprite2D
@onready var fuse = $fuse


var NUCLEAR_EXPLOSION = preload("res://projectile/explosions/animated_explosions/nuclear_explosion.tscn")
var LARGE_EXPLOSION = preload("res://projectile/explosions/animated_explosions/large_explosion.tscn")
var player : CharacterBody2D
enum enemy_state {Walk, Chase, Explode, Death}
var current_state : enemy_state = enemy_state.Walk

var is_dying : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	# weapon_area.set_collision_mask_value()
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	# healthbar.max_value = health_amount
	#update_health_ui()

#func update_health_ui():
	#set_health_bar()

#func  set_health_bar():
	#healthbar.value = health_amount

func _physics_process(_delta):
	var direction : Vector2 = Vector2.ZERO
	var distance : int = KEY_NONE
	var speed = 0
	if current_state == enemy_state.Walk:
		speed = enemy_speed
	elif current_state == enemy_state.Chase:
		speed = chase_speed
	if player != null:
		direction = global_position.direction_to(player.global_position)
		distance = global_position.distance_to(player.global_position)
		if distance <= 300 and current_state != enemy_state.Chase:
			current_state = enemy_state.Chase
			fuse.start()
		var flip = false if direction[0] > 0 else true
		sprite_2d.flip_h = flip
	
	move(direction, speed)
	move_and_slide()
	
func move(direction : Vector2, speed : int):
	velocity = direction * speed

func deal_damage() -> int:
	return damage_amount

func _on_hurtbox_area_entered(area):
	if area.has_method("get_damage_amount"):
		var node = area as Node
		health_amount -= node.damage_amount
		#set_health_bar()
		if health_amount <= 0:
			current_state = enemy_state.Death

func explode():
	for i in range(25):
		var large = LARGE_EXPLOSION.instantiate() as Node2D
		var nuclear = NUCLEAR_EXPLOSION.instantiate() as Node2D
		large.global_position = global_position + Vector2(randi_range(-200, 200),randi_range(-200, 200))
		nuclear.global_position = global_position + Vector2(randi_range(-200, 200),randi_range(-200, 200))
		get_parent().add_child(large)
		get_parent().add_child(nuclear)
		await get_tree().create_timer(.04).timeout
	queue_free()
	

func _on_fuse_timeout():
	explode()
