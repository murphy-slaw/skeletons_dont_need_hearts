extends Node

# Initial scene. Loads splash screen and sets up input and 
# viewport placement

var screen_size = OS.get_screen_size()
var window_size = OS.get_window_size()

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    if OS.get_name()=="HTML5":
        OS.set_window_maximized(true)
    
    # Disable all non-keyboard input maps to work around
    # Chrome bugs
        for action in InputMap.get_actions():
            for event in InputMap.get_action_list(action):
                if not event.action(event.KEY):
                    InputMap.action_erase_event(action,event)
                
    OS.set_window_position(screen_size * 0.5 - window_size * 0.5)