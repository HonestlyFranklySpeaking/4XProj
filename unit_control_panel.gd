extends Control

signal move_pressed(unit: UnitType)
signal fortify_pressed(unit: UnitType)
signal order_given(unit: UnitType)
signal all_orders_sent

var unit: UnitType

func set_manipulation_scene(forUnit: UnitType):
	unit = forUnit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	move_pressed.emit(unit)


func _on_button_2_pressed() -> void:
	order_given.emit(unit)


func _on_button_3_pressed() -> void:
	all_orders_sent.emit()


func _on_fortify_button_pressed() -> void:
	fortify_pressed.emit(unit)
