extends CanvasLayer

onready var tween_out = get_node("Tween")

export var transition_type = Tween.TRANS_LINEAR
export (String, MULTILINE) var title_text = ""
export (String, MULTILINE) var blurb_text = ""
export (String) var link_text = ""
export (PackedScene) var scene_path
export (AudioStream) var music_track
var audio_length = 0
export var audio_loop_max = 4
var runtime = 0.0
var audio_stopping = false

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    find_node('Title').text = title_text
    find_node('Blurb').text = blurb_text
    find_node('LinkButton').text = link_text

    $AudioStreamPlayer.stream = music_track
    $AudioStreamPlayer.play()
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    audio_length = $AudioStreamPlayer.stream.get_length()
    

func _process(delta):
    runtime += delta
    if int(runtime/audio_length) >= audio_loop_max and not audio_stopping:
        audio_stopping = true
        fade_out($AudioStreamPlayer, 30)
        yield(tween_out,"tween_completed")
        $AudioStreamPlayer.stop()
        
    if Input.is_action_pressed("ui_accept"):
        $Margin/MarginContainer/VBoxContainer/LinkButton.pressed=true
        _on_LinkButton_pressed()
        
func fade_out(stream_player,duration):
    # tween music volume down to 0
    tween_out.interpolate_property(stream_player, "volume_db", stream_player.volume_db, -80, duration, transition_type, Tween.EASE_IN, 0)
    tween_out.start()
    
func _on_LinkButton_pressed():
    var stream = $AudioStreamPlayer.stream
#    stream.loop_mode = stream.LOOP_DISABLED
    fade_out($AudioStreamPlayer,2)
    yield(tween_out,"tween_completed")
    get_tree().change_scene_to(scene_path)
