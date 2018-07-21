tool
extends "res://addons/moe.ero-one.fsm/content/FSMTransition.gd";

func get_fsm(): return fsm; #access to owner FSM, defined in parent class
func get_logic_root(): return logic_root; #access to logic root of FSM (usually fsm.get_parent())

func transition_init(args = []): 
	#you can optionally implement this to initialize transition on it's creation time 
	pass

func prepare(new_state, args = []): 
	#you can optionally implement this to reset transition when related state has been activated
	pass

func transition_condition(delta, args = []):
	test_motion = logic_root.my_motion
	test_motion.y = 0
	return logic_root.test_move(Transform2D(), test_motion)
	# Return true/false
	return false;
