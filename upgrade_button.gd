extends Button
@export var upg_number : int
@export var stat_to_change : String
@export var amt_to_change : Variant
@export var cost : int
@export var cost_scaling : int
@export var description :String
@export var operator : Operator
@export var max_level : int
enum Operator {
	Addition,
	Multiplicative,
	Subtraction,
	Username
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cost.text = 'Cost: ' + str(cost * max((cost_scaling * Global.shopupg[upg_number]),1))
	$Description.text = '[b]Upgrade #'+ str(upg_number+1)+':[/b]\n' + description
		
	pass # Repace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.shopupg[upg_number] == max_level:
		disabled = true
	pass


func _on_pressed() -> void:
	if Global.pkey['emeralds'] >= cost * max((cost_scaling * Global.shopupg[upg_number]),1):
		Global.pkey['emeralds'] -= cost * max((cost_scaling * Global.shopupg[upg_number]),1)
		Global.shopupg[upg_number] += 1
		match operator:
			0: Global.pkey[stat_to_change] = Global.pkey[stat_to_change] + amt_to_change
			1: Global.pkey[stat_to_change] = Global.pkey[stat_to_change] * amt_to_change
			2: Global.pkey[stat_to_change] -= amt_to_change
		$Cost.text = 'Cost: ' + str(cost * max((cost_scaling * Global.shopupg[upg_number]),1))
	pass # Replace with function body.
