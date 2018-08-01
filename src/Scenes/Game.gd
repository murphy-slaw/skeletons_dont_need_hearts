extends Node2D

export (PackedScene) var Mob

var spawners = []
var used_spawners = []
var mobs = {}
var max_mobs = 0
var angry_mob_count = 0
export (int) var win_hearts = 10

onready var player = find_node("Player")
onready var tween = get_node("Tween")


func _ready():
    modulate = Color(0,0,0,1)
    randomize()
    
    spawners = get_tree().get_nodes_in_group("arches")
    max_mobs = spawners.size()
    for i in range(max_mobs):
        call_deferred("spawn_mob")
        
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    $UILayer/MarginContainer/Label.text = str(player.hearts)
    $UILayer/MarginContainer/TextureProgress.max_value = win_hearts
    $UILayer/MarginContainer/TextureProgress.value = player.hearts
    

    var transition_type = Tween.TRANS_SINE
    var transition_duration = 2
    tween.interpolate_property(self, "modulate", Color(0,0,0,1), Color(1,1,1,1), transition_duration, transition_type, Tween.EASE_IN, 0)
    $MusicPlayerFight.stream = load("res://audio/music/skelestart.wav")
    $MusicPlayerFight.play()
    tween.start()
    get_tree().paused = true
    yield(tween,"tween_completed")
    
    tween.interpolate_property($MusicPlayerFight, "volume_db",
        $MusicPlayerFight.volume_db, -36,
        2, transition_type, Tween.EASE_IN, 0)
    
    get_tree().paused = false
    yield(tween,"tween_completed")
    $MusicPlayerFight.stream = load("res://audio/music/skelefight.wav")
    $MusicPlayerFight.play()
    $MusicPlayerSneak.play()

    
func _physics_process(delta):
        $UILayer/MarginContainer/TextureProgress.value = player.hearts
        $UILayer/MarginContainer/Label.text= str(player.hearts)
        if player.hearts <= 0:
            bad_ending()
        elif player.hearts >= win_hearts:
            good_ending()
            
            
func good_ending():
    get_parent().get_tree().change_scene("res://Scenes/Victory.tscn")
    
    
func bad_ending():
    yield(player.animation_player,"animation_finished")
    var tween_out = get_node("Tween")
    var transition_type = tween_out.TRANS_SINE
    var transition_duration = 3
    tween_out.interpolate_property(self, "modulate", Color(1,1,1,1), Color(0,0,0,1), transition_duration, transition_type, Tween.EASE_OUT, 0)
    tween_out.start()
    get_tree().paused = true
    yield(tween_out,"tween_completed")
    get_tree().paused = false
    get_parent().get_tree().change_scene("res://Scenes/TheEnd.tscn")

        
func _on_Boinger_boing(boing_vec,body):
    if body.get("vel") !=null:
        body.vel = boing_vec


func _on_MobSpawnTimer_timeout():
    call_deferred("spawn_mob", true)


func get_spawner():
    if spawners.size() == 0:
        spawners = used_spawners.duplicate()
        used_spawners = []
    var spawner = spawners.pop_back()
    used_spawners.append(spawner)
    return spawner

func spawn_mob(offscreen_only = false):

    if mobs.size() >= max_mobs:
        return
    
    var spawner = get_spawner()
    var visible = spawner.is_on_screen()
    if offscreen_only and visible:
        return
    
    var mob = Mob.instance()
    mob.connect("die",self,"_on_mob_died")
    mob.connect("aggro",self,"_on_mob_aggro")
    mob.connect("calm",self,"_on_mob_calm")
    mob.position = spawner.get_spawn_point()
    $TileMap.call_deferred("add_child",mob)
    mobs[mob] = 1


func _on_mob_died(mob):
    if mob.get_state() == 'Aggro':
        angry_mob_count -= 1
    mobs.erase(mob)

func _on_mob_aggro():
    angry_mob_count += 1
    tween.remove_all()
    var transition_type = Tween.TRANS_SINE
    var transition_duration = .25
    tween.interpolate_property($MusicPlayerFight, "volume_db",
        $MusicPlayerFight.volume_db, 0,
        transition_duration, transition_type, Tween.EASE_OUT, 0)
    tween.interpolate_property($MusicPlayerSneak, "volume_db",
        $MusicPlayerSneak.volume_db, -36,
        transition_duration, transition_type, Tween.EASE_IN, 0)
    tween.start()


func _on_mob_calm():
    angry_mob_count -=1
    tween.remove_all()
    var transition_type = Tween.TRANS_SINE
    var transition_duration = .25
    tween.interpolate_property($MusicPlayerSneak, "volume_db",
        $MusicPlayerSneak.volume_db, 0,
        transition_duration, transition_type, Tween.EASE_OUT, 0)
    tween.interpolate_property($MusicPlayerFight, "volume_db",
        $MusicPlayerFight.volume_db, -36,
        transition_duration, transition_type, Tween.EASE_IN, 0)
    tween.start()


func _on_Player_hit(body):
    if body.is_class("Mob"):
        body.die()

        
func _on_heart_caught():
    player.give_heart()