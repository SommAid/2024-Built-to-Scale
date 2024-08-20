extends CharacterBody2D

@export_category("Enemy Velocity")
@export var enemy_speed : int = 35
@export var rage_speed : int = 175

@export_category("Enemy Health")
@export var health_amount : int = 300

@export_category("Enemy Attack")
@export var damage_amount : int = 300

var NUCLEAR_EXPLOSION = preload("res://projectile/explosions/animated_explosions/nuclear_explosion.tscn")

@onready var healthbar = $healthbar
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var weapon_area = $WeaponArea
@onready var rage_duration = $RageDuration
@onready var rage_cooldown = $RageCooldown


var player : CharacterBody2D
enum enemy_state {Attack, Walk, Rage, Charge, Break, Death}
var current_state : enemy_state = enemy_state.Walk

var is_dying : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	# weapon_area.set_collision_mask_value()
	animated_sprite_2d.play("walk")
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	healthbar.max_value = health_amount
	update_health_ui()

func update_health_ui():
	set_health_bar()

func  set_health_bar():
	healthbar.value = health_amount

func _physics_process(_delta):
	var direction : Vector2 = Vector2.ZERO
	var speed = 0
	if current_state == enemy_state.Rage:
		speed = rage_speed
	elif current_state == enemy_state.Walk:
		speed = enemy_speed
	if player != null:
		direction = global_position.direction_to(player.global_position)
		var flip = false if direction[0] > 0 else true
		animated_sprite_2d.flip_h = flip
	
	move(direction, speed)
	animation_handler()
	move_and_slide()
	
func move(direction : Vector2, speed : int):
	velocity = direction * speed
	
func _on_weapon_area_area_entered(area):
	if area.is_in_group("Player") and current_state == enemy_state.Rage:
		weapon_area.set_collision_layer_value(2, true)
		current_state = enemy_state.Attack
		animated_sprite_2d.animation_finished

func deal_damage() -> int:
	return damage_amount

func _on_hurtbox_area_entered(area):
	if area.has_method("get_damage_amount"):
		var node = area as Node
		health_amount -= node.damage_amount
		set_health_bar()
		if health_amount <= 0:
			current_state = enemy_state.Death
			var nuclear = NUCLEAR_EXPLOSION.instantiate() as Node2D
			nuclear.global_position = global_position
			get_parent().add_child(nuclear)
			animated_sprite_2d.play("death")
			animated_sprite_2d.animation_finished

func animation_handler():
	if current_state == enemy_state.Walk:
		animated_sprite_2d.play("walk")
	elif current_state == enemy_state.Attack:
		animated_sprite_2d.play("attack")
	elif current_state == enemy_state.Rage:
		animated_sprite_2d.play("rage")

func _on_animated_sprite_2d_animation_finished():
	if current_state == enemy_state.Attack:
		weapon_area.set_collision_layer_value(2, false)
		current_state = enemy_state.Rage
	elif current_state == enemy_state.Charge:
		current_state = enemy_state.Rage
		rage_duration.start()
	elif current_state == enemy_state.Break:
		current_state = enemy_state.Walk
	elif current_state == enemy_state.Death:
		queue_free()

func _on_rage_duration_timeout():
	current_state = enemy_state.Break
	animated_sprite_2d.play_backwards("charge")
	animated_sprite_2d.animation_finished
	rage_cooldown.start()

func _on_rage_cooldown_timeout():
	current_state = enemy_state.Charge
	animated_sprite_2d.play("charge")
	animated_sprite_2d.animation_finished
	
	
