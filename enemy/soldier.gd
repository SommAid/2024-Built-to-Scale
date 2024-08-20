extends CharacterBody2D

@export_category("Enemy Velocity")
@export var speed : int = 150
@export var jump_velocity : int = -400

@export_category("Enemy Health")
@export var health_amount : int = 10

@export_category("Enemy Damage")
@export var damage_amount : int = 4

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var marker = $marker
# @onready var player = get_node("/root/TestLevel/PlayerCat")
var player : CharacterBody2D
enum animationList {hit, idle, walk, attack, die}
var state = animationList.idle
var die = false
var near = false
var marker_position

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func hit_box_position(flip : bool):
	if flip:
		marker.position.x = -marker_position.x
	else:
		marker.position.x = marker_position.x

func _ready():
	if state == animationList.idle:
		animated_sprite_2d.play("idle")
		state = animationList.walk
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = player_list[0] as CharacterBody2D
	%ProgressBar.max_value = health_amount
	update_health_ui()
	marker_position = marker.position

func update_health_ui():
	set_health_bar()

func  set_health_bar():
	%ProgressBar.value = health_amount

func checkState():
	if state == animationList.die and die !=true:
		speed = 0
		animated_sprite_2d.play("die")
		die = true
		$Timer.start()
	else:
		if state == animationList.walk:
			animated_sprite_2d.play("walk")
			speed = 150
		elif state == animationList.hit:
			animated_sprite_2d.play("hit")
			speed = 0
			await wait(.5)
			state = animationList.walk
		elif state == animationList.attack:
			animated_sprite_2d.play("attack")
			await wait(.6)
			state = animationList.walk
			near = false


func _physics_process(_delta):
	var direction : Vector2
	if player != null:
		direction = global_position.direction_to(player.global_position)
		var flip = true if direction[0] < 0 else false
		animated_sprite_2d.flip_h = flip
		hit_box_position((flip))
	else:
		speed = 0
	#checkState()
	#print(state)
	velocity = direction * speed
	move_and_slide()
	

func deal_damage() -> int:
	return damage_amount

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Player"):
		state = animationList.attack
		near = true
	else:
		if area.has_method("get_damage_amount") and near == false:
			state = animationList.hit
			#checkState()
			var node = area as Node
			health_amount -= node.damage_amount
			update_health_ui()
			print("anything: ", str(health_amount))
		if health_amount <= 0:
			state = animationList.die



func _on_animated_sprite_2d_animation_changed():
	#print(state, " erfgfd")
	checkState()


func _on_animated_sprite_2d_frame_changed():
	#print("SAdasdsada")
	checkState()
	print(state)


func _on_timer_timeout():
	queue_free()
