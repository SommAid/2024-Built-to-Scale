extends CharacterBody2D

@export_category("Enemy Velocity")
@export var speed : int = 50
@export var jump_velocity : int = -400
@export_category("Enemy Health")
@export var max_health : int = 5
@export var current_health : int = max_health

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player = get_node("/root/TestLevel/PlayerCat")

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	animated_sprite_2d.play("walk")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()


