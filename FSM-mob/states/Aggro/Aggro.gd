extends "res://addons/moe.ero-one.fsm/content/FSMState.gd"

func get_FSM(): return fsm; #defined in parent class
func get_logic_root(): return logic_root; #defined in parent class 

func state_init(args = null):
    .state_init()

var original_speed

#when entering state, usually you will want to reset internal state here somehow
func enter(from_state = null, from_transition = null, args = []):
    .enter(from_state, from_transition, args)
    original_speed = logic_root.walk_accel
    logic_root.walk_accel *= 2

#when updating state, paramx can be used only if updating fsm manually
func update(delta, args=null):
    .update(delta, args)
    var movement = Vector2()
    movement.x= (target.global_position - global_position).normalized().x

#when exiting state
func exit(to_state=null):
    .exit(to_state)
    logic_root.walk_accel = original_speed
