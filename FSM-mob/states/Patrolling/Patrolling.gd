extends "res://addons/moe.ero-one.fsm/content/FSMState.gd"

func get_FSM(): return fsm; #defined in parent class
func get_logic_root(): return logic_root; #defined in parent class 

func state_init(args = null):
	.state_init()

#when entering state, usually you will want to reset internal state here somehow
func enter(from_state = null, from_transition = null, args = []):
	.enter(from_state, from_transition, args)

#when updating state, paramx can be used only if updating fsm manually
func update(delta, args=null):
	.update(delta, args)
	var movement = Vector2(1,0)
	if logic_root.get_flip_sprite():
		movement = Vector2(-1,0)
	logic_root.walk(delta, movement)

#when exiting state
func exit(to_state=null):
	.exit(to_state)
