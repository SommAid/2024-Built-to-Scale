extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	var sb = StyleBoxFlat.new()
	add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("ff0000")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
