extends State
class_name CombatState

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# References to nodes
@export var body: CharacterBody3D
@export var yLook: Node3D
@export var MeshParent: Node3D
@export var PlayerModel: Node3D

@export var AttackTimer: Timer
@export var DodgeTimer: Timer

# Variables for Movement
@export var SPEED = 3.0
@export var JUMP_VELOCITY = 2
@export var ACCELERATION = 0.3
@export var DEACCELERATION = 0.07

# used for calculations
var acc_process
var deacc_process

var can_attack = true
var can_dodge = true
var b_velocity_process

#animation variables
var velocity_anim
var sprint_anim
var input_velocity_anim
var has_stopped_anim
var has_startet_anim
var isgrounded_anim = 0.0
var has_dodged_anim
var has_landed_anim
var has_attacked_anim
var has_drawn_anim
var state_name_anim = "move"



func Enter():
	acc_process = ACCELERATION
	deacc_process = DEACCELERATION
	state_name_anim = "combat"
	has_drawn_anim = true

func Exit():
	has_drawn_anim = false

func Update(delta: float):
	#orient Character along yLook
	MeshParent.rotation.y = yLook.rotation.y
	Animate() #execute animation logic


func Physics_Update(delta: float):

	if Input.is_action_just_pressed("attack") and can_attack and can_dodge:
		body.velocity = (yLook.transform.basis * Vector3(0, 0, 7))
		AttackTimer.start()#starts the attack timer
		can_attack = false
		has_attacked_anim = true
	else:
		has_attacked_anim = false

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

	if direction and can_attack:
		body.velocity.x = lerp(body.velocity.x , direction.x * SPEED, acc_process)
		body.velocity.z = lerp(body.velocity.z, direction.z * SPEED, acc_process)

		# DODGE gets called only if direction true, otherwise we can infinitely accelerate by repeatetely dodging
		if Input.is_action_just_pressed("jump") and body.is_on_floor() and can_dodge:
			body.velocity = Vector3(body.velocity.x * 4, JUMP_VELOCITY, body.velocity.z * 4)
			DodgeTimer.start()#starts the attack timer
			can_dodge = false
			has_dodged_anim = true
		else:
			has_dodged_anim = false

	else:
		body.velocity.x = lerp(body.velocity.x , direction.x * SPEED, deacc_process)
		body.velocity.z = lerp(body.velocity.z, direction.z * SPEED, deacc_process)

	#transition to fall
	if body.is_on_floor():
		isgrounded_anim = lerp(isgrounded_anim, 0.0, 0.05)
	else:
		isgrounded_anim = lerp(isgrounded_anim, 1.0, 0.2)

	#transition to movestate
	if Input.is_action_just_pressed("draw") and can_attack and can_dodge:
			state_name_anim = "move"
			Transitioned.emit(self, "MoveState")

func Animate():
	var b_vel_x
	var b_vel_z
	var b_y_rotation = 0.0
	
	#can_attack_anim = can_attack

	b_y_rotation = MeshParent.rotation.y #get rotation of the player mesh
	b_velocity_process = body.velocity.rotated(Vector3.UP, - b_y_rotation) #rotate velocity around player mesh
	
	#splitting rotation and recombinig velocity into a Vector2, which can be used to blend the walking animations
	b_vel_x = b_velocity_process.x / SPEED
	b_vel_z = b_velocity_process.z / SPEED
	velocity_anim = Vector2(b_vel_x,b_vel_z)


#signals from attack and dodge timer
func _on_attack_timer_timeout():
	can_attack = true

func _on_dodge_timer_timeout():
	can_dodge = true
