extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode ==KEY_ESCAPE:
			get_tree().change_scene_to_file("res://Levels/Menu.tscn")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
