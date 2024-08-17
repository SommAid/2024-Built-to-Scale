extends CharacterBody2D

@export_category("Enemy Velocity")
@export var speed : int = 50
@export var jump_velocity : int = -400
@export_category("Enemy Health")
@export var health_amount : int = 5

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
	
func _on_hurtbox_area_entered(area):
	if area.has_method("get_damage_amount"):
		var node = area as Node
		health_amount -= node.damage_amount
		print("Health amount: ", str(health_amount))
		if health_amount <= 0:
			queue_free()
