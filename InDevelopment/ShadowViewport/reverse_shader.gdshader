shader_type canvas_item;

uniform vec4 background_color : source_color;
uniform vec4 shadow_color : source_color;
// Currently pixels always in application size, so zooming in further wouldn't increase the size of the dropdown
// but changing that would also be relatively trivial
uniform vec2 offset_in_pixels;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	
	// Read screen texture
	vec4 current_color = texture(TEXTURE, UV);
	if (current_color.a > 0.0)  {
		vec4 new_color = texture(SCREEN_TEXTURE, SCREEN_UV);
		current_color = vec4(1.0 - new_color.r, 1.0 - new_color.g, 1.0 - new_color.b, 1.0);
		//if (new_color.r == new_color.g && new_color.g == new_color.b) {
			//current_color = vec4(1.0 - new_color.r, 1.0 - new_color.g, 1.0 - new_color.b, 1.0);
		//} 
	}
	
	COLOR = current_color;
}