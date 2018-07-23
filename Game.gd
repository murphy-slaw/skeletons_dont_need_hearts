extends Node2D

export (PackedScene) var Mob

var spawners = {}
var used_spawners = {}

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$MobSpawnTimer.start()
	randomize()
	get_tree().get_nodes_in_group

func _on_Boinger_boing(boing_vec,body):
	if body.get("vel") !=null:
		body.vel = boing_vec

func _on_MobSpawnTimer_timeout():
	for i in range(randi() % 2):
		call_deferred("spawn_mob")

	
func spawn_mob():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	call_deferred("add_child",mob)
	mob.position = $MobPath/MobSpawnLocation.position
