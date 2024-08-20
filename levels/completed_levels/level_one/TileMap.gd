extends TileMap

var moisture = FastNoiseLite.new()
var temp = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

var width = 64
var height = 64

var load_chunks = []
var rng = RandomNumberGenerator.new()

func _ready():
	moisture.seed = randi()
	temp.seed = randi()
	altitude.seed = randi()
	
	altitude.frequency = 0.05
	
func _process(delta):
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		var player_tile_pos = local_to_map(player_list[0].position)
		generate_chunk(player_tile_pos)
	
func generate_chunk(pos):
	for x in range(width):
		for y in range(width):
			var moist = moisture.get_noise_2d(
				pos.x - (width / 2) + x,
				pos.y - (width / 2) + y
			)
			
			var tmp = moisture.get_noise_2d(
				pos.x - (width / 2) + x,
				pos.y - (width / 2) + y
			) 
			
			var alt = moisture.get_noise_2d(
				pos.x - (width / 2) + x,
				pos.y - (width / 2) + y
			) * 10
			
			
			
			var test_x = moisture.get_noise_2d(
				pos.x - (width / 2) + x,
				pos.y - (width / 2) + y
			)
			
			var tmp_x = round((test_x + 1) * 30)
			
			
			#print("test_x: ", tmp_x)
			
			#set_cell(0, 
			#Vector2i(pos.x - (width/2) + x, pos.y - (width/2) + y), 
			#3, 
			#Vector2(tmp_x, round((tmp + 1) / 2) ))
			
			set_cell(0, 
			Vector2i(pos.x - (width/2) + x, pos.y - (width/2) + y), 
			0, 
			Vector2(round(2 * (moist + 1)), round((tmp + 1) / 2) ))
			
			#set_cell(0, 
			#Vector2i(pos.x - (width/2) + x, pos.y - (width/2) + y), 
			#0, 
			#Vector2(round(3* (moist + 10) / 2), round(3* (tmp + 10) / 2)))

