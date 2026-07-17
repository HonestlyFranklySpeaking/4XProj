extends Node2D

var UnitScene = preload("res://UnitScene.tscn")

@onready var tilemap = $GridLayers/Terrain

enum Mode {
	MOVE,
	INSPECT,
	DEFAULT
}

var movement_tile_dict: Dictionary[Vector2i, Node2D] = {}


var current_mode: Mode = Mode.DEFAULT

func set_mode(mode: Mode):
	if mode == Mode.MOVE:
		current_mode = Mode.MOVE
		$CanvasLayer/Control/HBoxContainer/Button3.visible = false
		$CanvasLayer/Control/HBoxContainer/Button3.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$CanvasLayer/Control/HBoxContainer/Button2.visible = true
		$CanvasLayer/Control/HBoxContainer/Button2.mouse_filter = Control.MOUSE_FILTER_STOP
		$CanvasLayer/Control/HBoxContainer/FortifyButton.visible = false
		$CanvasLayer/Control/HBoxContainer/FortifyButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence = [] as Array[Vector2i]
		for i in $GridLayers/MovementOverlay.get_children():
			i.set_num(-1)
		# if mode is being reset, all points ought to be redrawn

	elif mode == Mode.INSPECT:
		current_mode = Mode.INSPECT
		$CanvasLayer/Control/HBoxContainer/Button3.visible = true
		$CanvasLayer/Control/HBoxContainer/Button3.mouse_filter = Control.MOUSE_FILTER_STOP
		$CanvasLayer/Control/HBoxContainer/FortifyButton.visible = true
		$CanvasLayer/Control/HBoxContainer/FortifyButton.mouse_filter = Control.MOUSE_FILTER_STOP
		$CanvasLayer/Control/HBoxContainer/Button2.visible = false
		$CanvasLayer/Control/HBoxContainer/Button2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$CanvasLayer/Control/HBoxContainer/Button.visible = true
		$CanvasLayer/Control/HBoxContainer/Button.mouse_filter = Control.MOUSE_FILTER_STOP
		
		for i in $GridLayers/MovementOverlay.get_children():
			i.set_num(-1)
	
	elif mode == Mode.DEFAULT:
		current_mode = Mode.DEFAULT
		
		$CanvasLayer/Control/HBoxContainer/Button3.visible = true
		$CanvasLayer/Control/HBoxContainer/Button3.mouse_filter = Control.MOUSE_FILTER_STOP
		$CanvasLayer/Control/HBoxContainer/Button2.visible = false
		$CanvasLayer/Control/HBoxContainer/Button2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$CanvasLayer/Control/HBoxContainer/Button.visible = false
		$CanvasLayer/Control/HBoxContainer/Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$CanvasLayer/Control/HBoxContainer/FortifyButton.visible = false
		$CanvasLayer/Control/HBoxContainer/FortifyButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		for i in $GridLayers/MovementOverlay.get_children():
			i.set_num(-1)

func fortify_pressed(unit: UnitType):
	print("FORTIFICAZIONE")
	unit.current_order.type = UnitType.OrderStructure.OrderType.FORTIFY
	unit.current_order.move_sequence = [] as Array[Vector2i]

func make_move(unit: UnitType):
	print("move detected")
	set_mode(Mode.MOVE)

func complete_unit_order(unit: UnitType):
	print("finish order detected")
	if unit.current_order.move_sequence == []:
		unit.current_order.type = UnitType.OrderStructure.OrderType.OTHER
	set_mode(Mode.DEFAULT)

func send_all_orders():
	print("finshe order")
	for i in $Units.get_children():
		if i.unit.current_order.type == i.unit.OrderStructure.OrderType.MOVE:
			i.unit.set_position(i.unit.current_order.move_sequence[-1])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_mode(Mode.DEFAULT)
	var new_swordsman = SwordfighterType.new($GridLayers/Terrain)
	$Units.add_child(helpers.spawn_unit_scene(new_swordsman))
	
	var newer_swordsman = SwordfighterType.new($GridLayers/Terrain, Vector2i(5, 5))
	$Units.add_child(helpers.spawn_unit_scene(newer_swordsman))
	var new = helpers.units_dict


	$CanvasLayer/Control/HBoxContainer.set_manipulation_scene(new_swordsman)
	
	$CanvasLayer/Control/HBoxContainer.order_given.connect(complete_unit_order)
	$CanvasLayer/Control/HBoxContainer.move_pressed.connect(make_move)
	$CanvasLayer/Control/HBoxContainer.all_orders_sent.connect(send_all_orders)
	$CanvasLayer/Control/HBoxContainer.fortify_pressed.connect(fortify_pressed)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("input press detected")
			if current_mode == Mode.MOVE:
				var actual_global_position = get_viewport().canvas_transform.affine_inverse() * event.global_position
				var move_tile_position = $GridLayers/Terrain.local_to_map($GridLayers/Terrain.to_local(actual_global_position))
				if move_tile_position in movement_tile_dict.keys():
					if $CanvasLayer/Control/HBoxContainer.unit.current_order.type == UnitType.OrderStructure.OrderType.MOVE:
						$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence.append(move_tile_position)
					else:
						$CanvasLayer/Control/HBoxContainer.unit.current_order.type = UnitType.OrderStructure.OrderType.MOVE
						var newArray: Array[Vector2i] = [move_tile_position]
						$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence = newArray
					print($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence)
					movement_tile_dict[move_tile_position].set_num(len($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence))
			elif current_mode == Mode.DEFAULT:
				var actual_global_position = get_viewport().canvas_transform.affine_inverse() * event.global_position
				var move_tile_position = $GridLayers/Terrain.local_to_map($GridLayers/Terrain.to_local(actual_global_position))
				if move_tile_position in helpers.units_dict.keys():
					set_mode(Mode.INSPECT)
					$CanvasLayer/Control/HBoxContainer.unit = helpers.units_dict[move_tile_position]
			

func _on_movement_overlay_child_entered_tree(node: Node) -> void:
	movement_tile_dict[$GridLayers/MovementOverlay.local_to_map(node.position)] = node
