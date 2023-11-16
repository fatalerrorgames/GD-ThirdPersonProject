extends Node3D

@export var Target = Node3D
@export var TargetingSpeed = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_transform.origin = lerp(self.global_transform.origin, Target.yLookTransform, TargetingSpeed * (delta * 60))
	self.global_transform.basis = Target.xLookTransform
