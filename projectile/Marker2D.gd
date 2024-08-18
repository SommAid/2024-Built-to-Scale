extends Marker2D

var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(get_angle_to(player.global_position))
