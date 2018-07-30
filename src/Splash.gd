extends CanvasLayer

onready var tween_out = get_node("Tween")

export var transition_type = Tween.TRANS_SINE
export (String, MULTILINE) var title_text = ""
export (String, MULTILINE) var blurb_text = ""
export (String) var link_text = ""
export (PackedScene) var scene_path

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    find_node('Title').text = title_text
    find_node('Blurb').text = blurb_text
    find_node('LinkButton').text = link_text
    yield(get_tree().create_timer(30),"timeout")
    fade_out($AudioStreamPlayer,10)

func fade_out(stream_player,duration):
    # tween music volume down to 0
    tween_out.interpolate_property(stream_player, "volume_db", 0, -80, duration, transition_type, Tween.EASE_IN, 0)
    tween_out.start()
    # when the tween ends, the music will be stopped
    yield(tween_out,"tween_completed")
    $AudioStreamPlayer.stop()
    
func _on_LinkButton_pressed():
    var stream = $AudioStreamPlayer.stream
    stream.loop_mode = stream.LOOP_DISABLED
    fade_out($AudioStreamPlayer,1.5)
    get_tree().change_scene_to(scene_path)