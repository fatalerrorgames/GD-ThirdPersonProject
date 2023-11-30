extends Node3D

@onready var Animations = $AnimationPlayer/AnimationTree

#reference to states from which to get the variables
@export var MoveRefference = Node
@export var CombatRefference = Node

var StateName #stores the state for transition between move and combat state


func _ready():
	pass # Replace with function body.


func _process(delta):
	StateName = CombatRefference.state_name_anim #get StateName from CombatState
	
	Animations.set("parameters/TransitionCombatMove/transition_request", StateName)#transition between combat and move
	
	#Move State ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Animations.set("parameters/BlendIdleRun/blend_amount", MoveRefference.velocity_anim)
	Animations.set("parameters/BlendSpaceRunSprint/blend_position", MoveRefference.sprint_anim)
	
	#test if player stopped while sprinting
	if Input.is_action_just_released("move_up") or Input.is_action_just_released("move_left") or Input.is_action_just_released("move_down") or Input.is_action_just_released("move_right"):
		if StateName == "move": #if i dont do this the game crashes while in combat (my guess is that the move state can't be accessed while in combat, therefore the values don't exist)
			if MoveRefference.sprint_anim > 0:
				Animations.set("parameters/OneShotStop/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	#transition to fall
	Animations.set("parameters/BlendIrFall/blend_amount", MoveRefference.isgrounded_anim)
	
	
	if MoveRefference.has_jumped_anim == true:
		#play jump animation
		Animations.set("parameters/OneShotJump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		Animations.set("parameters/OneShotLand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	#Combat State -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	Animations.set("parameters/BlendSpace2DMove/blend_position", CombatRefference.velocity_anim)
	#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

func _on_area_3d_body_entered(body):
	Animations.set("parameters/OneShotLand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
