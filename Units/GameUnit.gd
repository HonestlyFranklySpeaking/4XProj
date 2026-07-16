extends Node2D

var unit: UnitType

func _ready() -> void:
	pass

func setup(unit_instance: UnitType) -> void:
	unit = unit_instance
	$Sprite2D.texture = unit.get_image()
	var new_local_position = unit.tile_map.map_to_local(unit.grid_position)
	print(new_local_position)
	print("NNNN")
	var new_global_position = unit.tile_map.to_global(new_local_position)
	print(new_global_position)
	global_position = new_global_position
