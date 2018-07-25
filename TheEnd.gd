extends CanvasLayer

signal start_game

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    connect("start_game",get_parent(),"_on_Splash_start_game")

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func _on_LinkButton_pressed():
    emit_signal("start_game")