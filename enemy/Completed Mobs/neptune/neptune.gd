extends CharacterBody2D

@export_category("Enemy Velocity")
@export var enemy_speed : int = 100

@export_category("Enemy Health")
@export var health_amount : int = 500

@export_category("Enemy Attack")
@export var damage_amount : int = 50
@export var range : int = 200
@export var bullets : int = 5

# @onready var healthbar = $healthbar
@onready var sprite_2d = $Sprite2D
@onready var muzzle = $Muzzle
@onready var attack_cooldown = $AttackCooldown

const RAPID_FIRE_EXPLOSION = preload("res://projectile/explosions/animated_explosions/rapid_fire_explosion.tscn")

var muzzle_position 
var player : CharacterBody2D
var can_attack : bool = true
enum enemy_state {Walk, Attack, Death}
var current_state : enemy_state = enemy_state.Walk

func _ready():
	muzzle_position = muzzle.position
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
	if player != null:
		direction = global_position.direction_to(player.global_position)
		distance = global_position.distance_to(player.global_position)
		if distance <= range and current_state != enemy_state.Attack and can_attack:
			enemy_attack()
			current_state = enemy_state.Attack
		var flip = false if direction[0] > 0 else true
		sprite_2d.flip_h = flip
		neptune_muzzle_position(flip)
	
	move(direction, speed)
	move_and_slide()
	
func move(direction : Vector2, speed : int):
	velocity = direction * speed

func enemy_attack():
	for i in range(bullets):
		var instance = RAPID_FIRE_EXPLOSION.instantiate() as Node2D
		instance.global_position = muzzle.global_position
		get_parent().add_child(instance)
		instance.desired_direction = muzzle.global_position.direction_to((player.global_position if player != null else Vector2.ZERO) + Vector2(randi_range(-50,50),randi_range(-50, 50))) * 220
		await get_tree().create_timer(.04).timeout
	can_attack = false
	attack_cooldown.start()
	current_state = enemy_state.Walk

func deal_damage() -> int:
	return damage_amount

func neptune_muzzle_position(flip : bool):
	if flip:
		muzzle.position.x = -muzzle_position.x
	else:
		muzzle.position.x = muzzle_position.x

func _on_hurtbox_area_entered(area):
	if area.has_method("get_damage_amount"):
		var node = area as Node
		health_amount -= node.damage_amount
		#set_health_bar()
		if health_amount <= 0:
			current_state = enemy_state.Death
			queue_free()

func _on_attack_cooldown_timeout():
	can_attack = true
