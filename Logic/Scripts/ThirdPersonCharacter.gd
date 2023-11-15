extends CharacterBody3D

@onready var yLook = $yLook
@onready var xLook = $yLook/xLook

var yLookTransform
var xLookTransform


func _physics_process(delta):
	move_and_slide()

func _process(delta):
	yLookTransform = yLook.global_transform.origin
	xLookTransform = xLook.global_transform.basis
