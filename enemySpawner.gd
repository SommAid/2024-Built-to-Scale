extends Node2D

@onready var main = get_node("/root/TestLevel")
var slime = preload("res://enemy/Completed Mobs/Blueraspberry Slime/blue_raspberry_slime.tscn")
var bee = preload("res://enemy/bee.tscn")
var greenSlime = preload("res://enemy/mob.tscn")
var spawnPoints = []
var enemyList = [slime,bee,greenSlime]
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i is Marker2D:
			spawnPoints.append(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var spawn = spawnPoints[randi() % spawnPoints.size()]
	var enemy = enemyList[randi() % enemyList.size()].instantiate()
	enemy.position = spawn.position
	main.add_child(enemy)
