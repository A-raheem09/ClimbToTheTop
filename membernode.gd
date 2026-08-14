extends HBoxContainer
@export var Username : String
@export var PFP : String
@export var online : bool
@export var player : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PFP.set_texture(load(PFP))
	if player == true:
		Username = Global.pkey['username']
	$PanelContainer/RichTextLabel.text = Username
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match online:
		true: $PFP/OnlineStatus.set_texture(load("res://Assets/Textures/Online.png"))
		false: $PFP/OnlineStatus.set_texture(load("res://Assets/Textures/Offline.png"))
	pass
