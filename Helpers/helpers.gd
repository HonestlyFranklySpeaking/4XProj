class_name helpers

static var unit_scene = preload("res://UnitScene.tscn")

static func spawn_unit_scene(unitInstance: UnitType):
	var new = unit_scene.instantiate()
	new.setup(unitInstance)
	unitInstance.scene = new
	return new
