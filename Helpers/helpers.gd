class_name helpers

static var unit_scene = preload("res://UnitScene.tscn")

static var units_dict: Dictionary[Vector2i, UnitType] = {}

static func spawn_unit_scene(unitInstance: UnitType):
	var new = unit_scene.instantiate()
	new.setup(unitInstance)
	unitInstance.scene = new
	units_dict[unitInstance.grid_position] = unitInstance
	unitInstance.set_position(unitInstance.grid_position)
	
	return new

enum UnitOwner{
	ONE,
	TWO,
	OTHER,
}
