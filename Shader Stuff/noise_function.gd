@tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeMyCustom

# Define the display name of your node in the editor graph
func _get_name() -> String:
	return "PerlinNoise2D"

# Define the category path for the "Add Node" selection window
func _get_category() -> String:
	return "Custom"

# Brief text explaining what your node does
func _get_description() -> String:
	return "2D Perlin Noise Function"

# Define how many input ports you want
func _get_input_port_count() -> int:
	return 2

# Assign data types to inputs (0: Vector3/Color, 1: Float)
func _get_input_port_type(port: int) -> VisualShaderNode.PortType:
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_3D
		1:
			return VisualShaderNode.PORT_TYPE_SAMPLER
	return VisualShaderNode.PORT_TYPE_SCALAR

# Set visual labels for each input port
func _get_input_port_name(port: int) -> String:
	match port:
		0:
			return "position"
		1:
			return "Sampler Gradient input"
	return ""

# Define how many output ports you want
func _get_output_port_count() -> int:
	return 1

# Assign data type to the output port
func _get_output_port_type(port: int) -> VisualShaderNode.PortType:
	return VisualShaderNode.PORT_TYPE_SCALAR

# Set a visual label for the output port
func _get_output_port_name(port: int) -> String:
	return "amount_out"

# Generate the actual GLSL code that the engine injects into the shader pipeline
func _get_code(input_vars: Array[String], output_vars: Array[String], mode: Shader.Mode, stage: VisualShader.Type) -> String:
	# input_vars[0] maps to "color_in"
	# input_vars[1] maps to "multiplier"
	# output_vars[0] maps to "color_out"
	return output_vars[0] + " = " + input_vars[0] + " * " + input_vars[1] + ";"
