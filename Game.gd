extends Node2D

export (PackedScene) var Mob

var spawners = []
var used_spawners = []
var mob_count = 0
var max_mobs = 0

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    $MobSpawnTimer.start()
    randomize()
    spawners = get_tree().get_nodes_in_group("arches")
    max_mobs = spawners.size()
    $UILayer/Label.text = str(mob_count)jj

func _on_Boinger_boing(boing_vec,body):
    if body.get("vel") !=null:
        body.vel = boing_vec

func _on_MobSpawnTimer_timeout():
#	for i in range(randi() % 2):
    call_deferred("spawn_mob")


func get_spawn_point():
    if spawners.size() == 0:
        spawners = used_spawners.duplicate()
        used_spawners = []
    var i = randi() % spawners.size()
    var spawner = spawners[i]
    spawners.remove(i)
    used_spawners.append(spawner)
    var spawn_point = spawner.find_node("SpawnPoint").position
    return spawner.to_global(spawn_point)
    

func spawn_mob():
    if mob_count >= max_mobs:
        return
    $MobPath/MobSpawnLocation.set_offset(randi())
    var mob = Mob.instance()
    
    mob.connect("die",self,"_on_mob_died")
    
    call_deferred("add_child",mob)
    mob.position = get_spawn_point()
    mob_count += 1
    $UILayer/Label.text = str(mob_count)
#	mob.position = $MobPath/MobSpawnLocation.position

func _on_mob_died():
    mob_count -= 1
