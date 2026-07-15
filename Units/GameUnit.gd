extends Node2D

var unit: UnitType

func _ready() -> void:
	pass

func setup(unit_instance: UnitType) -> void:
	unit = unit_instance
	$Sprite2D.texture = unit.get_image()
	global_position = unit.tile_map.to_global(unit.tile_map.map_to_local(unit.position))

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed == true:
			print("INPUT")
			if unit.damage(10):
				queue_free()
