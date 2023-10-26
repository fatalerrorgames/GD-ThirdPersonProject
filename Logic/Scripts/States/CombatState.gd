extends State
class_name CombatState

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# References to nodes
@export var body: CharacterBody3D
@export var yLook: Node3D
@export var MeshParent: Node3D

# Variables for Movement
@export var SPEED = 3.0
@export var JUMP_VELOCITY = 2
@export var ACCELERATION = 0.3
@export var DEACCELERATION = 0.07

# used for calculations
var acc_process
var deacc_process



func Enter():
	acc_process = ACCELERATION
	deacc_process = DEACCELERATION

func Update(delta: float):
	#orient Character along yLook
	MeshParent.rotation.y = yLook.rotation.y

func Physics_Update(delta: float):
	if Input.is_action_just_pressed("attack"):
			body.velocity = (yLook.transform.basis * Vector3(0, 0, 7))
	# Add the gravity.
	if not body.is_on_floor():
		body.velocity.y -= gravity * delta
		acc_process = 0.01
		deacc_process = 0.01
	else:
		acc_process = ACCELERATION
		deacc_process = DEACCELERATION

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and body.is_on_floor():
	#	body.velocity = Vector3(body.velocity.x * 4, JUMP_VELOCITY, body.velocity.z * 4)

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (yLook.transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()

	if direction:
		body.velocity.x = lerp(body.velocity.x , direction.x * SPEED, acc_process)
		body.velocity.z = lerp(body.velocity.z, direction.z * SPEED, acc_process)
		
		# DODGE gets called only if direction true, otherwise we can infinitely accelerate by repeatetely dodging
		if Input.is_action_just_pressed("ui_accept") and body.is_on_floor():
			body.velocity = Vector3(body.velocity.x * 4, JUMP_VELOCITY, body.velocity.z * 4)
		
	
	else:
		body.velocity.x = lerp(body.velocity.x , direction.x * SPEED, deacc_process)
		body.velocity.z = lerp(body.velocity.z, direction.z * SPEED, deacc_process)
	
	#transition to movestate
	if Input.is_action_just_pressed("draw"):
			Transitioned.emit(self, "MoveState")



