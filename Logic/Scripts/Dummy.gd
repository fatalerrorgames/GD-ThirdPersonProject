extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var PlayerReference = CharacterBody3D
var direction = Vector3(0,0,0)
var knockback_vel = Vector3(0,0,0)

var hit_fx = preload("res://Assets/FX/enemy_hit_particles.tscn")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	velocity.x = lerp(velocity.x , direction.x , 0.1)
	velocity.z = lerp(velocity.z, direction.z , 0.1)

	knockback_vel = lerp(knockback_vel, PlayerReference.velocity, 0.1) #lerp vector so velocity remains even if player stops

	move_and_slide()


func _on_hit_box_area_entered(area):
	#velocity = (PlayerReference.velocity.normalized()*12)
	velocity = knockback_vel.normalized()*12
	instance_object()

func instance_object():

	var instance = hit_fx.instantiate()
	#call_deferred("add_child",object)
	add_child(instance)
