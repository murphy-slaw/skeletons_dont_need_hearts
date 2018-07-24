extends "res://addons/moe.ero-one.fsm/content/FSMState.gd"

func get_FSM(): return fsm; #defined in parent class
func get_logic_root(): return logic_root; #defined in parent class

func state_init(args = null):
    .state_init()

#when entering state, usually you will want to reset internal state here somehow
func enter(from_state = null, from_transition = null, args = []):
    .enter(from_state, from_transition, args)
    logic_root.show_walk()

#when updating state, paramx can be used only if updating fsm manually
func update(delta, args=null):
    .update(delta, args)
    logic_root.flip_sprite = Input.is_action_pressed("ui_left")\
            or logic_root.flip_sprite and not Input.is_action_pressed("ui_right")
    var motion = Vector2()
    motion.x = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
    logic_root.walk(delta, motion)


#when exiting state
func exit(to_state=null):
    .exit(to_state)
