## A state machine, which uses its children notes as states. Try to instantiate subclasses, not this object.
class_name StateMachine
extends State

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

# var shared_dict : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			child.shared_dict = shared_dict
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_state:
		current_state.state_update()

func _physics_process(_delta: float) -> void:
	if current_state:
		current_state.state_physics_update()

func on_child_transition(state: State, new_state_name: String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower(), null)
	if !new_state: return

	if current_state:
		current_state.state_exit()

	new_state.state_enter()
	current_state = new_state


func run():
	if initial_state:
		initial_state.state_enter()
		current_state = initial_state
