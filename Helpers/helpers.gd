class_name helpers extends Node

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

static func is_neighbor(a: Vector2i, b: Vector2i) -> bool:
	var x_diff = a.x - b.x
	var y_diff = a.y - b.y
	print("result: ")
	if abs(x_diff) > 1 or abs(y_diff) > 1:
		return false
	elif abs(x_diff) + abs(y_diff) == 1:
		return true
		
		
	return x_diff == y_diff

static func compute_cost(a: Vector2i, b: Vector2i) -> int:
	if is_neighbor(a, b):
		return 1
	else:
		return -1
