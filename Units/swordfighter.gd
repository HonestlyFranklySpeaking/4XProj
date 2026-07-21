class_name SwordfighterType
extends UnitType

var image = preload("res://Assets/sword.png")


static func get_base_stats() -> Array[int]:
	return [5, 3, 20, 5, 50, 3]



func get_image() -> Texture2D:
	return image
