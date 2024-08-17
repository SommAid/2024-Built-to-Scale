extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	%SlimeBody.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%SlimeBody.play("hit")
	#%SlimeBody.queue("walk")
