extends Node2D
var bonusHeath = 200
#@onready var main = get_node("/root/TestLevel")
var slime = preload("res://enemy/Completed Mobs/Blueraspberry Slime/blue_raspberry_slime.tscn")
var greenSlime = preload("res://enemy/mob.tscn")
var blueSlime = preload("res://enemy/Completed Mobs/blue amoeba/blue_amoeba.tscn")
var octoSlime = preload("res://enemy/Completed Mobs/single cell octo/octo_shotgunner.tscn")
var rhino = preload("res://enemy/rhino.tscn") 
var soldier = preload("res://enemy/soldier.tscn")
var snail  = preload("res://enemy/snail.tscn")
var bee = preload("res://enemy/bee.tscn")
var neptune = preload("res://enemy/Completed Mobs/neptune/neptune.tscn")
var saturn = preload("res://enemy/Completed Mobs/saturn/saturn.tscn")
var flip = [1,-1]
var offX = 250
var offy = 250
var spawnx 
var spawny
var enemyList = [slime,greenSlime, blueSlime, octoSlime,rhino, soldier, snail, bee, neptune, saturn]
var player: CharacterBody2D
var direction: Vector2
var distance = 300
var new_posiotn: Vector2
var box
# Called when the node enters the scene tree for the first time.
func _ready():
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player = player_list[0] as CharacterBody2D
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if player != null:
		spawnx= player.global_position.x + (offX* flip[randi()%flip.size()])
		spawny = player.global_position.y + (offy* flip[randi()%flip.size()])
		var enemy = enemyList[randi() % enemyList.size()].instantiate()
		enemy.health_amount += bonusHeath
		enemy.position.x = spawnx
		enemy.position.y = spawny
		get_parent().add_child(enemy)
		#main.add_child(enemy)
