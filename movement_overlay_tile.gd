extends Node2D

var num: int = -1

func set_num(target: int) -> void:
	num = target
	if target == -1:
		visible = false
		$Label.text = ""
	else:
		visible = true
		$Label.text = str(target)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_num(-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
