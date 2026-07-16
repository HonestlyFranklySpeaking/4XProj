class_name UnitType
extends RefCounted

var grid_position: Vector2i
var _health: int

var scene: Node2D
var current_order: OrderStructure = OrderStructure.new()
var tile_map: TileMapLayer

func _init(using_tilemap: TileMapLayer) -> void:
	set_health(get_base_stats()[4])
	tile_map = using_tilemap
	

class OrderStructure:
	enum OrderType {
		MOVE,
		OTHER,
	}
	
	var type: OrderType = OrderType.OTHER
	
	var move_sequence: Array[Vector2i] = []


func set_position(to: Vector2i):
	helpers.units_dict.erase(grid_position)
	grid_position = to
	var new_local_position = tile_map.map_to_local(to)
	print(new_local_position)
	scene.global_position = tile_map.to_global(tile_map.map_to_local(to))
	print(scene.global_position)
	helpers.units_dict[to] = self

func set_health(value: int) -> void:
	_health = value

### Returns attack, defense, movement points, speed, start HP
static func get_base_stats() -> Array[int]:
	push_error("base type has no stat")
	return []

func get_image() -> Texture2D:
	push_error("base type has no image")
	return preload("res://icon.svg")

func get_health() -> int:
	return _health

func damage(amount: int) -> bool:
	if amount >= _health:
		return true
	else:
		set_health(get_health()-amount)
		return false
