shader_type canvas_item;

uniform vec4 reverse_color : source_color = vec4(0.984313, 0.945098, 0.537254, 1.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	
	// Read screen texture
	vec4 current_color = texture(TEXTURE, UV);
	if (current_color.a > 0.0)  {
		vec4 new_color = texture(SCREEN_TEXTURE, SCREEN_UV);
		current_color = vec4(reverse_color.rgb - vec4(new_color.r, new_color.g, new_color.b, 1.0).rgb, current_color.a);
		//if (new_color.r == new_color.g && new_color.g == new_color.b) {
			//current_color = vec4(1.0 - new_color.r, 1.0 - new_color.g, 1.0 - new_color.b, 1.0);
		//} 
	}
	
	COLOR = current_color;
}