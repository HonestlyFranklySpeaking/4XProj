shader_type canvas_item;

uniform vec4 transparent_color = vec4(0, 0, 0, 0);
uniform vec4 fog_color = vec4(0, 0, 0, 255);
uniform vec2 vision_granters[100];
uniform float vision_magnitudes[100];

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 actual_pos = vec2(FRAGCOORD.x, FRAGCOORD.y);
	bool found = false;
	for (int i=0; i<100; i++) {
		if (distance(actual_pos, vision_granters[i]) <= vision_magnitudes[i]) {
			found = true;
			break;
		}
	}
	if (!found) {
		COLOR = fog_color;
	} else {
		COLOR = transparent_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
