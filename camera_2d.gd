extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventPanGesture:
		position += event.delta / max(zoom.x, 0.001) * 10
	if event is InputEventMagnifyGesture:
			zoom.x = max(zoom.x*event.factor, 0.001)
			zoom.y = max(zoom.y*event.factor, 0.001)
