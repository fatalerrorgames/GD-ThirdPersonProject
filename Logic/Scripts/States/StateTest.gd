extends State
class_name StateTest

var move_direction : Vector3
var wander_time : float

@export var body: CharacterBody3D
@export var move_speed := 10

func randomize_wander():
	move_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	wander_time =  randf_range(1, 3)

func Enter():
	randomize_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		randomize_wander()

func Physics_Update(delta: float):
	if body:
		body.velocity = move_direction * move_speed
