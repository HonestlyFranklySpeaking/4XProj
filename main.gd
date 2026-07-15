extends Node2D

var UnitScene = preload("res://UnitScene.tscn")

enum Mode {
	MOVE,
	DEFAULT,
}

var current_mode: Mode = Mode.DEFAULT

func set_mode(mode: Mode):
	if mode == Mode.MOVE:
		current_mode = Mode.MOVE
		$CanvasLayer/Control/HBoxContainer/Button3.visible = false
		$CanvasLayer/Control/HBoxContainer/Button3.mouse_filter = Control.MOUSE_FILTER_IGNORE

	elif mode == Mode.DEFAULT:
		current_mode = Mode.DEFAULT
		$CanvasLayer/Control/HBoxContainer/Button3.visible = true
		$CanvasLayer/Control/HBoxContainer/Button3.mouse_filter = Control.MOUSE_FILTER_STOP

func make_move(unit: UnitType):
	print("move detected")
	set_mode(Mode.MOVE)

func complete_unit_order(unit: UnitType):
	print("finish order detected")
	set_mode(Mode.DEFAULT)

func send_all_orders():
	print("finshe order")
	for i in $Units.get_children():
		if i.unit.current_order.type == i.unit.OrderStructure.OrderType.MOVE:
			i.unit.set_position(i.unit.current_order.move_sequence[-1])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_mode(Mode.DEFAULT)
	var new_swordsman = SwordfighterType.new($TileMapLayer)
	$Units.add_child(helpers.spawn_unit_scene(new_swordsman))
	$CanvasLayer/Control/HBoxContainer.set_manipulation_scene(new_swordsman)
	$CanvasLayer/Control/HBoxContainer.order_given.connect(complete_unit_order)
	$CanvasLayer/Control/HBoxContainer.move_pressed.connect(make_move)
	$CanvasLayer/Control/HBoxContainer.all_orders_sent.connect(send_all_orders)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if current_mode == Mode.MOVE:
		if event is InputEventMouseButton:
			if event.is_pressed():
				if $CanvasLayer/Control/HBoxContainer.unit.current_order.type == UnitType.OrderStructure.OrderType.MOVE:
					$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence.append($TileMapLayer.local_to_map($TileMapLayer.to_local(event.position)))
				else:
					$CanvasLayer/Control/HBoxContainer.unit.current_order.type = UnitType.OrderStructure.OrderType.MOVE
					var oldMoveOrder = $CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence
					var newArray: Array[Vector2i] = [$TileMapLayer.local_to_map($TileMapLayer.to_local(event.position))]
					$CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence = newArray
				print($CanvasLayer/Control/HBoxContainer.unit.current_order.move_sequence)
