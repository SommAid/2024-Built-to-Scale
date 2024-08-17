extends CharacterBody2D

@export_category("Enemy Velocity")
@export var speed : int = 50
@export var jump_velocity : int = -400

@export_category("Enemy Health")
@export var health_amount : int = 5

@export_category("Enemy Damage")
@export var damage_amount : int = 1

@onready var animated_sprite_2d = $AnimatedSprite2D
# @onready var player = get_node("/root/TestLevel/PlayerCat")
var player : CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	animated_sprite_2d.play("idle")
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D

func _physics_process(_delta):
	var direction : Vector2
	if player != null:
		direction = global_position.direction_to(player.global_position)
	else:
		speed = 0
	velocity = direction * speed
	move_and_slide()
	

func deal_damage() -> int:
	return damage_amount


func _on_hurtbox_body_entered(body):
	print("Healpppppppppppppppp")
	if body.has_method("get_damage_amount"):
		var node = body as Node
		health_amount -= node.damage_amount
		if health_amount <= 0:
			queue_free()
