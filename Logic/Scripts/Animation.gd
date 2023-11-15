extends Node3D

@onready var Animations = $AnimationPlayer/AnimationTree

#reference to states from which to get the variables
@export var MoveRefference = Node
@export var CombatRefference = Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Animations.set("parameters/BlendIdleRun/blend_amount", MoveRefference.velocity_anim)
	Animations.set("parameters/BlendSpaceRunSprint/blend_position", MoveRefference.sprint_anim)
	
	#test if player stopped while sprinting
	if Input.is_action_just_released("move_up") or Input.is_action_just_released("move_left") or Input.is_action_just_released("move_down") or Input.is_action_just_released("move_right"):
		if MoveRefference.sprint_anim > 0 :
			Animations.set("parameters/OneShotStop/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	#transition to fall
	Animations.set("parameters/BlendIrFall/blend_amount", MoveRefference.isgrounded_anim)
	
	if MoveRefference.has_jumped_anim == true:
		#play jump animation
		Animations.set("parameters/OneShotJump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	#if MoveRefference.has_landed_anim == true:
	#	Animations.set("parameters/OneShotLand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
