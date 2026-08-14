extends Control
class_name Message
@export var message: String
@export var user: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MessageContainer/Message.text = '[b]'+user + ':[/b]\n' + message
	pass # Replace with function body.
func update_texture(texture):
	$TextureRect.set_texture(texture)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func vip_color(vip_level:int):
	match vip_level:
		2:$MessageContainer/Message.modulate = Color(0.883, 0.662, 0.158, 1.0)
		3:$MessageContainer/Message.modulate = Color(0.277, 0.774, 0.887, 1.0)
		4:$MessageContainer/Message.modulate = Color(0.882, 0.09, 0.157, 1.0)
