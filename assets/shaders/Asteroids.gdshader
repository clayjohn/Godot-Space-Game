shader_type spatial;

render_mode unshaded, blend_add;

void fragment() {
	ALBEDO = vec3(0.3, 0.15, 0.0);
	ALPHA = 0.2;
}
