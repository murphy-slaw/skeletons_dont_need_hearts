extends TileMap

var boinger = load("res://Boinger.tscn")
var boing_count = 0


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var boinger_tile = tile_set.find_tile_by_name("Art Tileset41")
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var used = get_used_cells_by_id(boinger_tile)
	for c in used:
		var world_pos = map_to_world(c)
#		set_cellv(c,-1)
		var boing = boinger.instance()
		boing.set_name("tileboinger" + str(boing_count))
		boing_count += 1
		boing.position = world_pos
		boing.boing_vec = Vector2(0,-400)
		get_parent().call_deferred("add_child",boing)
	


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
