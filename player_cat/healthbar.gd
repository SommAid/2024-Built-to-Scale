extends ProgressBar

func _ready():
	var sb = StyleBoxFlat.new()
	add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("00300a")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
