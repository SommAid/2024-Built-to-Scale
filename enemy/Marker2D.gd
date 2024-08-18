extends Marker2D

var player : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = player_list[0] as CharacterBody2D
	look_at(player.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
