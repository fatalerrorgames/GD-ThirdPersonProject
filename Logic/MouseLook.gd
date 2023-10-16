extends Node3D

@export var mouse_sensitivity = 0.15

@onready var x_look = $xLook

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		self.rotate_y(deg_to_rad(-event.relative.x*mouse_sensitivity))
		x_look.rotate_x(deg_to_rad(event.relative.y*mouse_sensitivity))
		x_look.rotation.x = clamp(x_look.rotation.x, deg_to_rad(-60), deg_to_rad(90))
