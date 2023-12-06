extends HSlider

@export var DisplayLabel = Label

# Called when the node enters the scene tree for the first time.
func _ready():
	value_changed.connect(self._value_changed)
	value = ProjectSettings.get_setting("rendering/scaling_3d/scale")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	DisplayLabel.text = str(value)
	#ProjectSettings.set_setting("rendering/scaling_3d/scale", value)
	
func _value_changed(new_value):
	ProjectSettings.set_setting("rendering/scaling_3d/scale", new_value)
	ProjectSettings.save_custom("override.cfg")
