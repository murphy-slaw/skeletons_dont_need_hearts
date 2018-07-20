extends Node2D

export (PackedScene) var Mob

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$MobSpawnTimer.start()
	randomize()

func _on_Boinger_boing(boing_vec,body):
	if body.get("vel") !=null:
		body.vel = boing_vec

func _on_MobSpawnTimer_timeout():
	for i in range(randi() % 2):
		call_deferred("spawn_mob")

func spawn_mob():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	mob.position = $MobPath/MobSpawnLocation.position
	call_deferred("add_child",mob)
