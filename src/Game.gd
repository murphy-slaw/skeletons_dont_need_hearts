extends Node2D

export (PackedScene) var Mob

var spawners = []
var used_spawners = []
var mob_count = 0
var max_mobs = 0
var angry_mob_count = 0
export (int) var win_hearts = 10

func _ready():
    modulate = Color(0,0,0,1)
    if OS.get_name()=="HTML5": #hack around chrome input bug?
        Input.action_press("ui_right")
    $MobSpawnTimer.start()
    randomize()
    spawners = get_tree().get_nodes_in_group("arches")
    max_mobs = spawners.size()
    for i in range(max_mobs):
        call_deferred("spawn_mob")
    $UILayer/MarginContainer/ColorRect/Label.text = str($Player.hearts)
    $UILayer/MarginContainer/ColorRect/TextureProgress.max_value = win_hearts
    $UILayer/MarginContainer/ColorRect/TextureProgress.value = $Player.hearts
    
    var tween_in = get_node("Tween")
    var transition_type = Tween.TRANS_LINEAR
    var transition_duration = 3
    tween_in.interpolate_property(self, "modulate", Color(0,0,0,1), Color(1,1,1,1), transition_duration, transition_type, Tween.EASE_IN, 0)
    $MusicPlayer.stream = load("res://audio/music/skelestart.wav")
    $MusicPlayer.play()
    tween_in.start()
    get_tree().paused = true
    yield(tween_in,"tween_completed")
    get_tree().paused = false
    yield($MusicPlayer,"finished")
    $MusicPlayer.stream = load("res://audio/music/skelefight.wav")

    
func _physics_process(delta):
        $UILayer/MarginContainer/ColorRect/TextureProgress.value = $Player.hearts
        $UILayer/MarginContainer/ColorRect/Label.text= str($Player.hearts)
        if $Player.hearts <= 0:
            bad_ending()
        elif $Player.hearts >= win_hearts:
            good_ending()
            
func good_ending():
    get_parent().get_tree().change_scene("res://TheEnd.tscn")
    
func bad_ending():
    yield($Player/AnimationPlayer,"animation_finished")
    var tween_out = get_node("Tween")
    var transition_type = tween_out.TRANS_LINEAR
    var transition_duration = 3
    tween_out.interpolate_property(self, "modulate", Color(1,1,1,1), Color(0,0,0,1), transition_duration, transition_type, Tween.EASE_OUT, 0)
    tween_out.start()
    get_tree().paused = true
    yield(tween_out,"tween_completed")
    get_tree().paused = false
    get_parent().get_tree().change_scene("res://TheEnd.tscn")

        
func _on_Boinger_boing(boing_vec,body):
    if body.get("vel") !=null:
        body.vel = boing_vec

func _on_MobSpawnTimer_timeout():
    call_deferred("spawn_mob")

func get_spawn_point():
    if spawners.size() == 0:
        spawners = used_spawners.duplicate()
        used_spawners = []
#    var i = randi() % spawners.size()
    var spawner = spawners[0]
    spawners.remove(0)
    used_spawners.append(spawner)
    var spawn_point = spawner.find_node("SpawnPoint").position
    return spawner.to_global(spawn_point)
    

func spawn_mob():
    if mob_count >= max_mobs:
        return
    var mob = Mob.instance()
    mob.connect("die",self,"_on_mob_died")
    mob.connect("aggro",self,"_on_mob_aggro")
    mob.connect("calm",self,"_on_mob_calm")
    call_deferred("add_child",mob)
    mob.position = get_spawn_point()
    mob_count += 1

func _on_mob_died():
    mob_count -= 1
    angry_mob_count -= 1

func _on_mob_aggro():
    if not $MusicPlayer.is_playing():
        $MusicPlayer.play()       
    angry_mob_count += 1

func _on_mob_calm():
    angry_mob_count -=1

func _on_Player_hit(body):
    if body.is_class("Mob"):
        body.die()
        
func _on_heart_caught():
    $Player.give_heart()
    
