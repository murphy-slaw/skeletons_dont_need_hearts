extends Node2D

export (PackedScene) var Mob

var spawners = []
var used_spawners = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$MobSpawnTimer.start()
	randomize()
	
	spawners = get_tree().get_nodes_in_group("arches")

func _on_Boinger_boing(boing_vec,body):
	if body.get("vel") !=null:
		body.vel = boing_vec

func _on_MobSpawnTimer_timeout():
	for i in range(randi() % 2):
		call_deferred("spawn_mob")


func get_spawn_point():
	if spawners.size() == 0:
		spawners = used_spawners.duplicate()
		used_spawners = []
	i = randi() % spawners.size()
	spawner = spawners[i]
	spawners.remove(i)
	used_spawners.append(spawner)
	return spawner/SpawnPoint
	

	
func spawn_mob():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	call_deferred("add_child",mob)
	mob.position = $MobPath/MobSpawnLocation.position
