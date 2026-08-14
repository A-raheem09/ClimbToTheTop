extends TextureButton
@export var channel_name : String
@export var can_type : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_mode = true
	pressed.connect(_pressed)
	pass # Replace with function body.

func _pressed():
	Global.current_channel = channel_name
	if button_pressed == false:
		button_pressed = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
