extends Node2D

export (PackedScene) var Mob

var spawners = []
var used_spawners = []
var mobs = {}
var max_mobs = 0
var angry_mob_count = 0
export (int) var win_hearts = 10

var is_ending = false

onready var player = find_node("Player")
onready var tween = get_node("Tween")
onready var audio1 = get_node("MusicPlayerSneak")
onready var audio2 = get_node("MusicPlayerFight")
onready var active_audio = audio1
onready var muted_audio = audio2

var fail_tune = preload("res://audio/music/skelefailure.ogg")
var win_tune = preload("res://audio/music/skelevictory.ogg")

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
    audio2.stream = load("res://audio/music/skelestart.ogg")
    audio2.play()
    tween.start()
    get_tree().paused = true
    yield(tween,"tween_completed")
    
    tween.interpolate_property(audio2, "volume_db",
        audio2.volume_db, -36,
        2, transition_type, Tween.EASE_IN, 0)
    
    get_tree().paused = false
    yield(tween,"tween_completed")
    audio2.stream = load("res://audio/music/skelefight.ogg")
    audio2.play()
    audio1.play()

    
func _physics_process(delta):
        $UILayer/MarginContainer/TextureProgress.value = player.hearts
        $UILayer/MarginContainer/Label.text= str(player.hearts)
        if not is_ending:
            if player.hearts <= 0:
                is_ending = true
                bad_ending()
            elif player.hearts >= win_hearts:
                is_ending = true
                player.win()
                good_ending()
                
            
func good_ending():
    muted_audio.stop()
    muted_audio.stream = win_tune
    muted_audio.play()
    crossfade_audio(0.25)
    yield(get_tree().create_timer(2.0),"timeout")

    var transition_type = tween.TRANS_SINE
    var transition_duration = 8
    tween.remove_all()
    tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), transition_duration, transition_type, Tween.EASE_IN, 4)
    tween.interpolate_property(active_audio, "volume_db", active_audio.volume_db, -36, transition_duration, transition_type, Tween.EASE_IN, 4)
    tween.start()
    get_tree().paused = true
    yield(tween,"tween_completed")
    get_tree().paused = false
    get_parent().get_tree().change_scene("res://Scenes/Victory.tscn")
    
    
func bad_ending():
    muted_audio.stop()
    muted_audio.stream = fail_tune
    muted_audio.play()
    crossfade_audio(0.25)
    yield(player.animation_player,"animation_finished")

    var transition_type = tween.TRANS_SINE
    var transition_duration = 4
    tween.remove_all()
    tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(0,0,0,1), transition_duration, transition_type, Tween.EASE_IN, 4)
    tween.interpolate_property(active_audio, "volume_db", active_audio.volume_db, -80, transition_duration, transition_type, Tween.EASE_IN, 4)
    tween.start()
    get_tree().paused = true
    yield(tween,"tween_completed")
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
    crossfade_audio(0.25)
    
func _on_mob_calm():
    angry_mob_count -=1
    crossfade_audio(0.25)


func crossfade_audio(transition_duration = 1, 
    transition_type = Tween.TRANS_SINE, 
    ease_type = Tween.EASE_OUT):    
    
    tween.interpolate_property(muted_audio, "volume_db",
        muted_audio.volume_db, 0,
        transition_duration, transition_type, ease_type, 0)
    
    tween.interpolate_property(active_audio, "volume_db",
        active_audio.volume_db, -36,
        transition_duration, transition_type, ease_type, 0)
    tween.start()
    
    yield(tween, "tween_completed")
    tween.remove_all()
    
    if audio1.volume_db == 0:
        active_audio = audio1
        muted_audio = audio2
    else:
        active_audio = audio2
        muted_audio = audio1
    

func _on_Player_hit(body):
    if body.is_class("Mob"):
        body.die()

        
func _on_heart_caught():
    player.give_heart()
