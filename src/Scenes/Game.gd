extends Node2D


class AudioManager:
    
    var players
    var locked = false
    var tween
    
    func _init(p = [], t = Tween.new()):
        players = p
        tween = t
        players[0].volume_db = 0
        players[1].volume_db = -80
        
    func crossfade_audio(transition_duration = 1, 
        transition_type = Tween.TRANS_SINE, 
        ease_type = Tween.EASE_OUT):
            
        if locked:
            print("waiting to crossfade due to lock")
            yield(tween,"tween_completed")
        else:
            locked = true
            
        print("in crossfade_audio")
        
        assert players.size() == 2
        
        tween.interpolate_property(players[1], "volume_db",
            players[1].volume_db, 0,
            transition_duration, transition_type, ease_type, 0)
        
        tween.interpolate_property(players[0], "volume_db",
            players[0].volume_db, -36,
            transition_duration, transition_type, ease_type, 0)
        tween.start()
        
        yield(tween, "tween_completed")
        tween.remove_all()
        
        players.invert()        
        locked = false

    func play_active(stream):
        players[0].stop()
        players[0].stream = stream
        players[0].play()
        
    func play_muted(stream):
        players[1].stop()
        players[1].stream = stream
        players[1].play()
        
    func fade_active(duration, transition_type):
            tween.interpolate_property( players[0], "volume_db", 
            players[0].volume_db, -36, duration,
            transition_type, Tween.EASE_IN, 4)       
        

export (PackedScene) var Mob

var spawners = []
var used_spawners = []
var mobs = {}
var max_mobs = 0
var angry_mob_count = 0
var last_aggro_state = false
export (int) var win_hearts = 10

var is_ending = false

onready var player = find_node("Player")
onready var tween = get_node("Tween")
onready var audio1 = get_node("MusicPlayerSneak")
onready var audio2 = get_node("MusicPlayerFight")

var fail_tune = preload("res://audio/music/skelefailure.ogg")
var win_tune = preload("res://audio/music/skelevictory.ogg")
var audio_manager
var audio_time = 0.0

func _ready():
    modulate = Color(0,0,0,1)
    randomize()
    
    audio_manager = AudioManager.new([audio1, audio2], tween)
    
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
   

    audio_manager.play_active(load("res://audio/music/skelestart.ogg"))
    tween.start()
    get_tree().paused = true
    yield(tween,"tween_completed")
    
    audio_manager.crossfade_audio()
    
    get_tree().paused = false
    yield(tween,"tween_completed")
    audio_manager.play_muted(load("res://audio/music/skelefight.ogg"))
    audio_manager.play_active(load("res://audio/music/skelesneak.ogg"))


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
                
                
func _process(delta):
    audio_time += delta
    if audio_time > 1:
        audio_time = 0.0
        var is_aggro = (angry_mob_count > 0)
        if  is_aggro != last_aggro_state:
            last_aggro_state = is_aggro
            audio_manager.crossfade_audio(0.25)
                
            
func good_ending():
    audio_manager.play_muted(win_tune)
    audio_manager.crossfade_audio(0.25)
    yield(get_tree().create_timer(2.0),"timeout")

    var transition_type = tween.TRANS_SINE
    var transition_duration = 8
    tween.remove_all()
    tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), transition_duration, transition_type, Tween.EASE_IN, 4)
    audio_manager.fade_active(transition_duration, transition_type)
    tween.start()
    get_tree().paused = true
    yield(tween,"tween_completed")
    get_tree().paused = false
    get_parent().get_tree().change_scene("res://Scenes/Victory.tscn")
    
    
func bad_ending():
    
    audio_manager.play_muted(fail_tune)
    audio_manager.crossfade_audio(0.25)
    yield(player.animation_player,"animation_finished")

    var transition_type = tween.TRANS_SINE
    var transition_duration = 4
    tween.remove_all()
    tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(0,0,0,1), transition_duration, transition_type, Tween.EASE_IN, 4)
    tween.start()
    get_tree().paused = true
    yield(tween,"tween_completed")
    get_tree().paused = false
    get_parent().get_tree().change_scene("res://Scenes/TheEnd.tscn")
    
        
func _on_Boinger_boing(boing_vec,body):
    if body.get("vel") !=null:
        body.vel = boing_vec


func _on_MobSpawnTimer_timeout():
    call_deferred("spawn_mob", false)


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
    if (spawner.get_spawn_point() - player.global_position).length() < 200:
        return    
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
    print("mob" + str(mob.get_instance_id()) + " died in state: " + mob.get_state())
    if mob.get_state() == 'Aggro':
        print("on_mob_died, decrementing angry_mob_count")
        angry_mob_count -= 1
    mobs.erase(mob)


func _on_mob_aggro():
    print("on_mob_aggro, incrementing angry_mob_count, current count" + str(angry_mob_count))
    angry_mob_count += 1


func _on_mob_calm():
    print("on_mob_calm, decrementing angry_mob_count")
    angry_mob_count -=1    


func _on_Player_hit(body):
    if body.is_class("Mob"):
        body.die()

        
func _on_heart_caught():
    player.give_heart()
