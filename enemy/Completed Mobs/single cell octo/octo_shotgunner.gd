extends CharacterBody2D

@export_category("Enemy Velocity")
@export var enemy_speed : int = 75

@export_category("Enemy Health")
@export var health_amount : int = 25

@export_category("Enemy Attack")
@export var damage_amount : int = 2
@export var range : int = 250

var scatter_shot = preload("res://enemy/Completed Mobs/single cell octo/scatter_shot.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var weapon_area = $WeaponArea
@onready var rage_duration = $RageDuration
@onready var rage_cooldown = $RageCooldown
@onready var muzzles = [$Marker2D1, $Marker2D2, $Marker2D3, $Marker2D4]

var shots_in_chamber : int = 8
var remaining_shots : int = shots_in_chamber
var muzzle_positions : Array[Vector2]
var player : CharacterBody2D
enum enemy_state {Attack, Walk, Charge, Break, Death}
var current_state : enemy_state = enemy_state.Walk

var is_dying : bool = false

func _ready():
	for muzzle in muzzles:
		muzzle_positions.append(muzzle.position)
	animated_sprite_2d.play("walk")
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D

func _physics_process(_delta):
	var direction : Vector2 = Vector2.ZERO
	var distance : int = KEY_NONE
	var speed = 0
	if current_state == enemy_state.Walk:
		speed = enemy_speed
	if player != null:
		direction = global_position.direction_to(player.global_position)
		distance = global_position.distance_to(player.global_position)
		if distance <= range and current_state == enemy_state.Walk:
			current_state = enemy_state.Charge
		var flip = false if direction[0] > 0 else true
		animated_sprite_2d.flip_h = flip
		update_muzzle_positions(flip)
			
	
	move(direction, speed)
	animation_handler(direction)
	move_and_slide()
	
func move(direction : Vector2, speed : int):
	velocity = direction * speed

func update_muzzle_positions(flip: bool):
	if flip:
		for i in range(muzzles.size()):
			muzzles[i].position.x = -muzzle_positions[i].x
	else:
		for i in range(muzzles.size()):
			muzzles[i].position.x = muzzle_positions[i].x

func animation_handler(direction : Vector2):
	match current_state:
		enemy_state.Walk:
			animated_sprite_2d.play("walk")
		enemy_state.Charge:
			animated_sprite_2d.play("charge")
			animated_sprite_2d.animation_finished
		enemy_state.Attack:
			animated_sprite_2d.play("attack")
			shotgun_attack(direction)
			animated_sprite_2d.animation_finished
		enemy_state.Break:
			animated_sprite_2d.play_backwards("charge")		
			animated_sprite_2d.animation_finished
	
func shotgun_attack(direction : Vector2):
	if remaining_shots > 0:
		for muzzle in muzzles:
			remaining_shots -= 1
			var scatter_shot_instance = scatter_shot.instantiate() as Node2D
			scatter_shot_instance.direction = muzzle.global_position.direction_to(player.global_position + Vector2(randi_range(-20,20),randi_range(-20, 20)))
			scatter_shot_instance.global_position = muzzle.global_position # + global_position - Vector2(2, -1)
			get_parent().add_child(scatter_shot_instance)
	
func deal_damage() -> int:
	return damage_amount

func _on_hurtbox_area_entered(area):
	if area.has_method("get_damage_amount"):
		var node = area as Node
		health_amount -= node.damage_amount
		if health_amount <= 0:
			current_state = enemy_state.Death
			animated_sprite_2d.play("death")
			animated_sprite_2d.animation_finished	

func _on_animated_sprite_2d_animation_finished():
	if current_state == enemy_state.Charge:
		remaining_shots = shots_in_chamber
		current_state = enemy_state.Attack
	elif current_state == enemy_state.Attack:
		current_state = enemy_state.Break
	elif current_state == enemy_state.Break:
		current_state = enemy_state.Walk
	elif current_state == enemy_state.Death:
		queue_free()
