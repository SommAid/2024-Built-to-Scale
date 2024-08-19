extends CharacterBody2D

@export_category("Enemy Velocity")
@export var speed : int = 100
@export var jump_velocity : int = -400

@export_category("Enemy Health")
@export var health_amount : int = 1000

@export_category("Enemy Damage")
@export var damage_amount : int = 1

@onready var animated_sprite_2d = $AnimatedSprite2D
# @onready var player = get_node("/root/TestLevel/PlayerCat")
var player : CharacterBody2D
enum animationList {hit, idle, walk, attack, die}
var state = animationList.idle

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	if state == animationList.idle:
		animated_sprite_2d.play("idle")
		state = animationList.walk
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = player_list[0] as CharacterBody2D

func _physics_process(_delta):
	var direction : Vector2
	if player != null:
		if state == animationList.walk:
			animated_sprite_2d.play("walk")
		elif state == animationList.idle:
			animated_sprite_2d.play("idle")
		elif state == animationList.hit:
			animated_sprite_2d.play("hit")
			state = animationList.walk
		elif state == animationList.die:
			animated_sprite_2d.play("die")
		else:
			animated_sprite_2d.play("attack")
			state = animationList.walk
		direction = global_position.direction_to(player.global_position)
		var flip = true if direction[0] < 0 else false
		animated_sprite_2d.flip_h = flip
			
	else:
		speed = 0
	velocity = direction * speed
	move_and_slide()
	

func deal_damage() -> int:
	return damage_amount

func _on_hurtbox_area_entered(area):
	if area.has_method("get_damage_amount"):
		state = animationList.hit
		var node = area as Node
		health_amount -= node.damage_amount
		print("anything: ", str(health_amount))
		if health_amount <= 0:
			state = animationList.die
			queue_free()

