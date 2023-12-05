extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var PlayerReference = CharacterBody3D
var direction = Vector3(0,0,0)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	velocity.x = lerp(velocity.x , direction.x , 0.1)
	velocity.z = lerp(velocity.z, direction.z , 0.1)	

	move_and_slide()


func _on_hit_box_area_entered(area):
	velocity = (PlayerReference.velocity.normalized()*12)
