extends CharacterBody2D

var player : CharacterBody2D
var healthBoost = 1
func _ready():
	# weapon_area.set_collision_mask_value()
	var player_list = get_tree().get_nodes_in_group("Player")
	%AnimatedSprite2D.play("spin")
	if player_list.size() > 0:
		player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
		#print(player.health)

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Player"):
		player.health += healthBoost
		if player.health > player.max_player_health:
			player.health = player.max_player_health
		player.update_health_ui()
		#print(player.health)
		queue_free()


func _on_timer_timeout():
	queue_free()
