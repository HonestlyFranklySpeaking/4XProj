class_name UnitType
extends Node

var grid_position: Vector2i

var scene: Node2D
var current_order: OrderStructure
var tile_map: TileMapLayer

func _init(using_tilemap: TileMapLayer, location: Vector2i=Vector2i.ZERO, owner: helpers.UnitOwner=helpers.UnitOwner.OTHER) -> void:
	tile_map = using_tilemap
	grid_position = location
	
	state = UnitState.new(get_base_stats())
	current_order = OrderStructure.new()
	current_order.remaining_movement_points = state.total_movement_points
	current_order.remaining_speed_points = state.speed

var unit_owner: helpers.UnitOwner

var state: UnitState

class UnitState:
	func _init(data: Array[int]):
		if data.size() >= 5:
			attack = data[0]
			defense = data[1]
			total_movement_points = data[2]
			speed = data[3]
			health = data[4]
			vision = data[5]
			remaining_movement_points = total_movement_points

	var attack: int
	var defense: int
	var total_movement_points: int
	var speed: int
	var health: int
	var vision: int
	
	var remaining_movement_points: int

class OrderStructure:
	enum OrderType {
		MOVE,
		FORTIFY,
		CHARGE,
		OTHER,
	}
	
	var type: OrderType = OrderType.OTHER
	
	var move_sequence: Array[Vector2i] = []
	
	var remaining_movement_points: int
	
	var remaining_speed_points: int


func set_position(to: Vector2i):
	helpers.units_dict.erase(grid_position)
	grid_position = to
	var new_local_position = tile_map.map_to_local(to)
	print(new_local_position)
	scene.global_position = tile_map.to_global(tile_map.map_to_local(to))
	print(scene.global_position)
	helpers.units_dict[to] = self



### Returns attack, defense, movement points, speed, start HP
static func get_base_stats() -> Array[int]:
	push_error("base type has no stat")
	return []

func get_image() -> Texture2D:
	push_error("base type has no image")
	return preload("res://icon.svg")
