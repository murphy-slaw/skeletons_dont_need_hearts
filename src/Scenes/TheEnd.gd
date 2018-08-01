extends CanvasLayer

signal start_game

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    connect("start_game",get_parent(),"_on_End_restart_game")