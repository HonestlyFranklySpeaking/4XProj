class_name helpers

static var unit_scene = preload("res://UnitScene.tscn")

static var units_dict: Dictionary[Vector2i, UnitType] = {}

static func spawn_unit_scene(unitInstance: UnitType, position: Vector2i=Vector2i.ZERO):
	var new = unit_scene.instantiate()
	new.setup(unitInstance)
	unitInstance.scene = new
	units_dict[position] = unitInstance
	return new
