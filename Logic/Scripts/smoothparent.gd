#Smooth the rotation of the Character Mesh
extends Node3D

@export var Parent = Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_transform.basis = lerp(global_transform.basis, Parent.global_transform.basis, 0.1)
