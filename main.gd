extends Node2D

var UnitScene = preload("res://UnitScene.tscn")

@onready var tilemap = $GridLayers/Terrain

var mat

enum Mode {
	MOVE,
	CHARGE,
	INSPECT,
	DEFAULT,
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
		$CanvasLayer/Control/HBoxContainer/InspectButtons.visible = false
		$CanvasLayer/Control/HBoxContainer/InspectButtons.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence = [] as Array[Vector2i]
		for i in $GridLayers/MovementOverlay.get_children():
			i.set_num_charge(-1, false)
		# if mode is being reset, all points ought to be redrawn
	elif mode == Mode.CHARGE:
		
		
		current_mode = Mode.CHARGE
		$CanvasLayer/Control/HBoxContainer/Button3.visible = false
		$CanvasLayer/Control/HBoxContainer/Button3.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$CanvasLayer/Control/HBoxContainer/Button2.visible = true
		$CanvasLayer/Control/HBoxContainer/Button2.mouse_filter = Control.MOUSE_FILTER_STOP
		$CanvasLayer/Control/HBoxContainer/InspectButtons.visible = false
		$CanvasLayer/Control/HBoxContainer/InspectButtons.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence = [] as Array[Vector2i]
		for i in $GridLayers/MovementOverlay.get_children():
			i.set_num_charge(-1, false)
		
	elif mode == Mode.INSPECT:
		
		
		current_mode = Mode.INSPECT
		$CanvasLayer/Control/HBoxContainer/InspectButtons/FortifyButton.disabled = false
		$CanvasLayer/Control/HBoxContainer/Button3.visible = true
		$CanvasLayer/Control/HBoxContainer/Button3.mouse_filter = Control.MOUSE_FILTER_STOP
		$CanvasLayer/Control/HBoxContainer/Button2.visible = false
		$CanvasLayer/Control/HBoxContainer/Button2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$CanvasLayer/Control/HBoxContainer/InspectButtons.visible = true
		$CanvasLayer/Control/HBoxContainer/InspectButtons.mouse_filter = Control.MOUSE_FILTER_STOP
		
		for i in $GridLayers/MovementOverlay.get_children():
			i.set_num_charge(-1, false)
	
	elif mode == Mode.DEFAULT:
		current_mode = Mode.DEFAULT
		
		
		var new_node = $CanvasLayer/Control/HBoxContainer.unit
		if new_node != null:
			new_node.scene.get_node("Sprite2D2").visible = false
		else:
			print("\n\n\n\n\n\n\n\n\n\n\n\n\n")
		
		$CanvasLayer/Control/HBoxContainer/Button3.visible = true
		$CanvasLayer/Control/HBoxContainer/Button3.mouse_filter = Control.MOUSE_FILTER_STOP
		$CanvasLayer/Control/HBoxContainer/InspectButtons.visible = false
		$CanvasLayer/Control/HBoxContainer/InspectButtons.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$CanvasLayer/Control/HBoxContainer/Button2.visible = true
		$CanvasLayer/Control/HBoxContainer/Button2.mouse_filter = Control.MOUSE_FILTER_STOP
		
		for i in $GridLayers/MovementOverlay.get_children():
			i.set_num_charge(-1, false)


func charge_pressed(unit: UnitType):
	unit.current_order.type = UnitType.OrderStructure.OrderType.OTHER
	unit.current_order.move_sequence = []
	unit.current_order.remaining_speed_points = unit.state.speed + 1
	set_mode(Mode.CHARGE)
	$CanvasLayer/Control/HBoxContainer/InspectButtons/FortifyButton.disabled = false

func fortify_pressed(unit: UnitType):
	print("FORTIFICAZIONE")
	unit.current_order.type = UnitType.OrderStructure.OrderType.FORTIFY
	unit.current_order.move_sequence = [] as Array[Vector2i]
	$CanvasLayer/Control/HBoxContainer/InspectButtons/FortifyButton.disabled = true

func make_move(unit: UnitType):
	unit.current_order.type = UnitType.OrderStructure.OrderType.OTHER
	unit.current_order.move_sequence = []
	unit.current_order.remaining_speed_points = unit.state.speed
	print("move detected")
	set_mode(Mode.MOVE)
	$CanvasLayer/Control/HBoxContainer/InspectButtons/FortifyButton.disabled = false

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
		i.unit.current_order.type = UnitType.OrderStructure.OrderType.OTHER
		i.unit.current_order.remaining_speed_points = i.unit.state.total_movement_points

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mat = $CanvasLayer2/ColorRect.material as ShaderMaterial
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
	$CanvasLayer/Control/HBoxContainer.charge_pressed.connect(charge_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var magnitudes: Array[int] = []
	magnitudes.resize(100)
	magnitudes.fill(0)
	
	var units: Array[Vector2] = []
	units.resize(100)
	units.fill(Vector2.ZERO)
	
	var currently_at: int = 0
	for i in $Units.get_children():
		var unit = i.unit
		units[currently_at] = (get_viewport_transform() * i.position)
		magnitudes[currently_at] = ((unit.state.vision * 20.0 + 16.0) * sqrt(get_viewport_transform().determinant()))
		currently_at += 1
	print(units, magnitudes)
	mat.set_shader_parameter("vision_granters", units)
	mat.set_shader_parameter("vision_magnitudes", magnitudes)
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("input press detected")
			if current_mode == Mode.MOVE:
				var actual_global_position = get_viewport().canvas_transform.affine_inverse() * event.global_position
				var move_tile_position = $GridLayers/Terrain.local_to_map($GridLayers/Terrain.to_local(actual_global_position))
				if move_tile_position in movement_tile_dict.keys():
					if $CanvasLayer/Control/HBoxContainer.unit.current_order.type == UnitType.OrderStructure.OrderType.MOVE:
						var new_speed_cost = helpers.compute_cost($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence[-1], move_tile_position)
						print("cost! cost:", new_speed_cost)
						if new_speed_cost != -1 and new_speed_cost <= $CanvasLayer/Control/HBoxContainer.unit.current_order.remaining_speed_points:
							$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence.append(move_tile_position)
							$CanvasLayer/Control/HBoxContainer.unit.current_order.remaining_speed_points -= new_speed_cost
							movement_tile_dict[move_tile_position].set_num_charge(len($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence), false)
					else:
						var used_movement_points = helpers.compute_cost($CanvasLayer/Control/HBoxContainer.unit.grid_position, move_tile_position)
						if used_movement_points != -1 and used_movement_points <= $CanvasLayer/Control/HBoxContainer.unit.current_order.remaining_speed_points:
							$CanvasLayer/Control/HBoxContainer.unit.current_order.type = UnitType.OrderStructure.OrderType.MOVE
							var newArray: Array[Vector2i] = [move_tile_position]
							$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence = newArray
							print($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence)
							movement_tile_dict[move_tile_position].set_num_charge(len($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence), false)
							$CanvasLayer/Control/HBoxContainer.unit.current_order.remaining_speed_points -= used_movement_points
			elif current_mode == Mode.CHARGE:
				var actual_global_position = get_viewport().canvas_transform.affine_inverse() * event.global_position
				var move_tile_position = $GridLayers/Terrain.local_to_map($GridLayers/Terrain.to_local(actual_global_position))
				if move_tile_position in movement_tile_dict.keys():
					if $CanvasLayer/Control/HBoxContainer.unit.current_order.type == UnitType.OrderStructure.OrderType.CHARGE:
						var new_speed_cost = helpers.compute_cost($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence[-1], move_tile_position)
						print("cost! cost:", new_speed_cost)
						if new_speed_cost != -1 and new_speed_cost <= $CanvasLayer/Control/HBoxContainer.unit.current_order.remaining_speed_points:
							$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence.append(move_tile_position)
							$CanvasLayer/Control/HBoxContainer.unit.current_order.remaining_speed_points -= new_speed_cost
							movement_tile_dict[move_tile_position].set_num_charge(len($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence), true)
					else:
						var used_movement_points = helpers.compute_cost($CanvasLayer/Control/HBoxContainer.unit.grid_position, move_tile_position)
						if used_movement_points != -1 and used_movement_points <= $CanvasLayer/Control/HBoxContainer.unit.current_order.remaining_speed_points:
							$CanvasLayer/Control/HBoxContainer.unit.current_order.type = UnitType.OrderStructure.OrderType.CHARGE
							var newArray: Array[Vector2i] = [move_tile_position]
							$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence = newArray
							print($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence)
							movement_tile_dict[move_tile_position].set_num_charge(len($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence), true)
							$CanvasLayer/Control/HBoxContainer.unit.current_order.remaining_speed_points -= used_movement_points
							
			elif current_mode == Mode.DEFAULT:
				
				print("click detected")
				
				var actual_global_position = get_viewport().canvas_transform.affine_inverse() * event.global_position
				var move_tile_position = $GridLayers/Terrain.local_to_map($GridLayers/Terrain.to_local(actual_global_position))
				if move_tile_position in helpers.units_dict.keys():
					set_mode(Mode.INSPECT)
					$CanvasLayer/Control/HBoxContainer.unit = helpers.units_dict[move_tile_position]
					$CanvasLayer/Control/HBoxContainer.unit.scene.get_node("Sprite2D2").visible = true


func _on_movement_overlay_child_entered_tree(node: Node) -> void:
	movement_tile_dict[$GridLayers/MovementOverlay.local_to_map(node.position)] = node

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("escape"):
		set_mode(Mode.DEFAULT)
