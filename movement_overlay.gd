extends TileMapLayer

var physical_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	physical_position = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_viewport_transform().affine_inverse() * physical_position
