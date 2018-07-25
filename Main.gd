extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var screen_size = OS.get_screen_size()
var window_size = OS.get_window_size()

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    if OS.get_name()=="HTML5":
        OS.set_window_maximized(true)
    OS.set_window_position(screen_size*0.5 - window_size*0.5)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Splash_start_game():
    get_child(0).change_scene("res://Game.tscn")

func _on_End_restart_game():
    get_tree().change_scene("res://Game.tscn")