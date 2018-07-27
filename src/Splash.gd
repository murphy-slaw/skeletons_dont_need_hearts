extends CanvasLayer

signal start_game

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

onready var tween_out = get_node("Tween")

export var transition_duration = 1.50

export var transition_type = 1 # TRANS_SINE

func fade_out(stream_player):
    # tween music volume down to 0
    tween_out.interpolate_property(stream_player, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
    tween_out.start()
    # when the tween ends, the music will be stopped

func _on_LinkButton_pressed():
    var stream = $AudioStreamPlayer.stream
    stream.loop_mode = stream.LOOP_DISABLED
    fade_out($AudioStreamPlayer)
    yield(tween_out,"tween_completed")
    $AudioStreamPlayer.stop()
    emit_signal("start_game")