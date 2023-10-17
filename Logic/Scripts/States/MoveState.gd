extends State
class_name MoveState

var move_direction : Vector3
var wander_time : float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var body: CharacterBody3D
@export var yLook: Node3D
@export var MeshParent: Node3D

@export var SPEED = 4.0
@export var JUMP_VELOCITY = 5.5
@export var ACCELERATION = 0.1
@export var DEACCELERATION = 0.07

var acc_process
var deacc_process

func randomize_wander():
	move_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	wander_time =  randf_range(1, 3)

func Enter():
	acc_process = ACCELERATION
	deacc_process = DEACCELERATION

func Update(delta: float):
		pass

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
	if Input.is_action_just_pressed("ui_accept") and body.is_on_floor():
		body.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (yLook.transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()

	if direction:
		body.velocity.x = lerp(body.velocity.x , direction.x * SPEED, acc_process)
		body.velocity.z = lerp(body.velocity.z, direction.z * SPEED, acc_process)
		
		#rotate MeshParent towards movement direction
		MeshParent.look_at_from_position(MeshParent.global_transform.origin, MeshParent.global_transform.origin + -body.velocity)
		
		#clamp x and z rotation
		MeshParent.rotation.x = clamp(MeshParent.rotation.x, deg_to_rad(0), deg_to_rad(0))
		MeshParent.rotation.z = clamp(MeshParent.rotation.z, deg_to_rad(0), deg_to_rad(0))
	
	else:
		body.velocity.x = lerp(body.velocity.x , direction.x * SPEED, deacc_process)
		body.velocity.z = lerp(body.velocity.z, direction.z * SPEED, deacc_process)



