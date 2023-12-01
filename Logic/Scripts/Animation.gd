extends Node3D

@onready var Animations = $AnimationPlayer/AnimationTree
#@onready var WeaponParent = $metarig/Skeleton3D/BoneAttachment3D

#reference to states from which to get the variables
@export var MoveRefference = Node
@export var CombatRefference = Node
#@export var WeaponParent = Node3D

var StateName #stores the state for transition between move and combat state
var AttackLR = true

func _ready():
	pass # Replace with function body.


func _process(delta):
	StateName = CombatRefference.state_name_anim #get StateName from CombatState

	Animations.set("parameters/TransitionCombatMove/transition_request", StateName)#transition between combat and move
	
	if Input.is_action_just_pressed("draw") or Input.is_action_just_pressed("attack") and CombatRefference.has_drawn_anim == true and CombatRefference.can_attack and CombatRefference.can_dodge:
		Animations.set("parameters/OneShotDraw/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	if Input.is_action_just_pressed("draw") and CombatRefference.has_drawn_anim == false and CombatRefference.can_attack and CombatRefference.can_dodge:
		Animations.set("parameters/OneShotSheathe/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

		
	#Move State ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Animations.set("parameters/BlendIdleRun/blend_amount", MoveRefference.velocity_anim)
	Animations.set("parameters/BlendSpaceRunSprint/blend_position", MoveRefference.sprint_anim)
	
	#test if player stopped while sprinting
	if Input.is_action_just_released("move_up") or Input.is_action_just_released("move_left") or Input.is_action_just_released("move_down") or Input.is_action_just_released("move_right"):
		if StateName == "move": #if I dont do this the game crashes while in combat (my guess is that the move state can't be accessed while in combat, therefore the values don't exist)
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
	Animations.set("parameters/BlendSpace2DDodge/blend_position", CombatRefference.velocity_anim)
	Animations.set("parameters/BlendCombatFall/blend_amount", CombatRefference.isgrounded_anim)
	
	if CombatRefference.has_attacked_anim == true:
		if AttackLR == true:
			Animations.set("parameters/OneShotAttackRight/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			Animations.set("parameters/OneShotAttackLeft/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
			AttackLR = false
		else:
			Animations.set("parameters/OneShotAttackLeft/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			Animations.set("parameters/OneShotAttackRight/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
			AttackLR = true

	if CombatRefference.has_dodged_anim == true:
		#play dodge animation
		Animations.set("parameters/OneShotDodge/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
		#abort attack animations
		Animations.set("parameters/OneShotAttackLeft/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		Animations.set("parameters/OneShotAttackRight/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_right"):
		if CombatRefference.can_attack:
			Animations.set("parameters/OneShotAttackRight/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
			Animations.set("parameters/OneShotAttackLeft/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
	#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

func _on_area_3d_body_entered(body):
	Animations.set("parameters/OneShotLand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	Animations.set("parameters/OneShotCombatLand/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
