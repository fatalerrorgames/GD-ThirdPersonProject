extends State
class_name MoveState

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# References to nodes
@export var body: CharacterBody3D
@export var yLook: Node3D
@export var MeshParent: Node3D
@export var PlayerModel: Node3D
#@export var RaycastParent: Node3D
#@export var TestCast: Node3D

# Variables for Movement
@export var SPEED = 3.5
@export var SPRINT_MULTIPLIER = 1.8
@export var JUMP_VELOCITY = 5.5
@export var ACCELERATION = 0.1
@export var DEACCELERATION = 0.07

# used for calculations or variables that get changed in the code
var acc_process
var deacc_process
var sprint_multiplier_process
var b_velocity_process
#animation variables
var velocity_anim
var sprint_anim
var input_velocity_anim
var has_stopped_anim
var has_startet_anim
var isgrounded_anim = 0.0
var has_jumped_anim
var has_landed_anim



func Enter():
	acc_process = ACCELERATION
	deacc_process = DEACCELERATION

func Update(delta: float):
	if MeshParent.global_transform.origin != MeshParent.global_transform.origin + -body.velocity:
		#rotate MeshParent towards movement direction
		MeshParent.look_at_from_position(MeshParent.global_transform.origin, MeshParent.global_transform.origin + -body.velocity)
		#clamp x and z rotation
		MeshParent.rotation.x = clamp(MeshParent.rotation.x, deg_to_rad(0), deg_to_rad(0))
		MeshParent.rotation.z = clamp(MeshParent.rotation.z, deg_to_rad(0), deg_to_rad(0))
		Animate() #execute animation logic
		
func Physics_Update(delta: float):
	
	# Add the gravity.
	if not body.is_on_floor():
		body.velocity.y -= gravity * delta
		acc_process = 0.01
		deacc_process = 0.01
	else:
		acc_process = ACCELERATION
		deacc_process = DEACCELERATION

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and body.is_on_floor():
		body.velocity.y = JUMP_VELOCITY
		has_jumped_anim = true

	else:
		has_jumped_anim = false
		
	
	#transition to fall
	if body.is_on_floor():
		isgrounded_anim = lerp(isgrounded_anim, 0.0, 0.12)
		has_landed_anim = true
	else:
		isgrounded_anim = lerp(isgrounded_anim, 1.0, 0.2)


	#sprint	
	if Input.is_action_pressed("sprint") and body.is_on_floor():
		sprint_multiplier_process = SPRINT_MULTIPLIER
	else:
		sprint_multiplier_process = 1

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (yLook.transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()
	
	input_velocity_anim = direction
	#orient climb raycasts along input direction
	#if RaycastParent.global_transform.origin != RaycastParent.global_transform.origin + -direction:
	#	RaycastParent.look_at_from_position(RaycastParent.global_transform.origin, RaycastParent.global_transform.origin + -direction)
	
	if direction:
		body.velocity.x = lerp(body.velocity.x , direction.x * (SPEED * sprint_multiplier_process), acc_process)
		body.velocity.z = lerp(body.velocity.z, direction.z * (SPEED * sprint_multiplier_process), acc_process)
		
		
	
	else:
		body.velocity.x = lerp(body.velocity.x , direction.x * SPEED, deacc_process)
		body.velocity.z = lerp(body.velocity.z, direction.z * SPEED, deacc_process)
	
	#transition to CombatState
	if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("draw"):
		Transitioned.emit(self, "CombatState")
		
#Animation Logic (setting variables etc)
func Animate():
	b_velocity_process = body.velocity * Vector3(1,0,1)
	#velocity_anim = clamp(body.velocity.length() / SPEED, 0,1)
	velocity_anim = clamp(b_velocity_process.length() / SPEED, 0,1)
	sprint_anim = (b_velocity_process.length() * 0.5) - velocity_anim*2
	
	if input_velocity_anim < body.velocity:
		has_stopped_anim = true
	


