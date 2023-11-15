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
	
	if MoveRefference.has_stopped_anim == true:
		Animations.set("parameters/OneShotStop/active", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
