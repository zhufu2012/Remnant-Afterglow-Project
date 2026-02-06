shader_type canvas_item;


uniform float percent :hint_range(0.0,1.0,0.1);
void fragment() {
	vec4 white_color = vec4(1.0,0.0,0.0,texture(TEXTURE, UV).a);
	COLOR = mix(texture(TEXTURE,UV),white_color,percent);
}