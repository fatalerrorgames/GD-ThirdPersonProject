#State Machine, every state is a child of this node
extends Node

@export var initial_state : State #define initial state

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():#----------------------------loop over all children
		if child is State:#----------------------------------adds child to dictionary if it is a State
			states[child.name.to_lower()] = child #----------to lower sets all letters to lowercase, to prevent issues from capitilasation
			child.Transitioned.connect(on_child_transition)#-if we register new State we connect to the "Transitioned" signal
		
		if initial_state:#-----------------------------------do we have an initial state?
			initial_state.Enter()#---------------------------if yes enter it and make it the current state
			current_state = initial_state

func _process(delta):#---------------------------------------executes "Update" function in State
	if current_state:#---------------------------------------check if we have a current state
		current_state.Update(delta) #------------------------run "Update" function

func _physics_process(delta):#-------------------------------executes "Physics_Update" function in State
	if current_state: #--------------------------------------check if we have a current state
		current_state.Physics_Update(delta) #----------------run "Update" function

func on_child_transition(state, new_state_name):#------------takes in state that called it and name it wants to transition to
	if state != current_state: #-----------------------------state calling it is not the current state
		return
	
	var new_state = states.get(new_state_name.to_lower())#---grab new state from Dictionary
	if !new_state: #make sure state exists
		return
	
	if current_state:#---------------------------------------if we have a current state exit it
		current_state.exit()
	
	new_state.enter()#---------------------------------------enter new state
	
	current_state = new_state #------------------------------set current state to the new state
