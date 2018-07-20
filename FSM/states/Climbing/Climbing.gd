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
	var motion = Vector2(0,-11)
	logic_root.move(delta,motion)
	logic_root.my_motion.y = clamp(10,-10, my_motion.y)

#when exiting state
func exit(to_state=null):
	.exit(to_state)
