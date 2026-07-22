shader_type canvas_item;

uniform vec4 transparent_color = vec4(0, 0, 0, 0);
uniform vec4 fog_color = vec4(0.5, 0.5, 0.5, 1);
uniform vec2 vision_tiles[1000];
uniform float zoom_factor;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 actual_pos = vec2(FRAGCOORD.x, FRAGCOORD.y);
	bool found = false;
	for (int i=0; i<1000; i++) {
		if (abs(FRAGCOORD.x - vision_tiles[i].x) < 16.0 * zoom_factor) {
			if (abs(FRAGCOORD.y - vision_tiles[i].y - (FRAGCOORD.x - vision_tiles[i].x) / sqrt(3)) < 17.0 * zoom_factor) {
				if (abs(FRAGCOORD.y - vision_tiles[i].y + (FRAGCOORD.x - vision_tiles[i].x) / sqrt(3)) < 17.0 * zoom_factor) {
				found = true;
				break;
				}
			}
		}
	}
	
	if (found) {
		COLOR = transparent_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
