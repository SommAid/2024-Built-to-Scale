extends Node2D

var cheese = preload("res://collectables/items/cheese.tscn")
var sword = preload("res://collectables/items/sword.tscn")
var box = [cheese,sword]
var flip = [1,-1]

var player: CharacterBody2D
var offX = 250
var offy = 250
var spawnx 
var spawny

func _ready():
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = player_list[0] as CharacterBody2D
		

func _on_timer_timeout():
	if player != null:
		spawnx= player.global_position.x + (offX* flip[randi()%flip.size()])
		spawny = player.global_position.y + (offy* flip[randi()%flip.size()])
		var spawn = box[randi() % box.size()].instantiate()
		spawn.position.x = spawnx
		spawn.position.y = spawny
		get_parent().add_child(spawn)
