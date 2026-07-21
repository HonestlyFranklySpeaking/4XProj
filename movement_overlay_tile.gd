extends Node2D

var num: int = -1
var charge: bool = false

func set_num_charge(target: int, charge_visible: bool) -> void:
	num = target
	
	charge = charge_visible
	$Sprite2D2.visible = charge_visible
	
	if target == -1:
		visible = false
		$Label.text = ""
	else:
		visible = true
		$Label.text = str(target)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_num_charge(-1, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
