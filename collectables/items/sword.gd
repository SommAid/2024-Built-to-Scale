extends CharacterBody2D

var player : CharacterBody2D
var attackBoost = 1
func _ready():
	# weapon_area.set_collision_mask_value()
	var player_list = get_tree().get_nodes_in_group("Player")
	%AnimatedSprite2D.play("shine")
	if player_list.size() > 0:
		player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
		#print(player.health)

func _on_timer_timeout():
	queue_free()


func _on_hurtbox_area_entered(area):
	if area.is_in_group("Player"):
		player.get_node("Gun").damage +=1
		queue_free()
