shader_type canvas_item;

uniform sampler2D dissolve_form;
//uniform float dissolve_state : hint_range(0.0, 1.0, 0.1);

uniform vec2 scroll1 = vec2(0.1, 0.1);
uniform vec2 scroll2 = vec2(0.5, 0.1);

void fragment() {
	float textureColor1 = texture(TEXTURE, UV + scroll1 * TIME).r;
	float textureColor2 = texture(dissolve_form, UV + scroll2 * TIME).r;
	float energy = textureColor1 * textureColor2;
	COLOR = vec4(energy, energy, energy, 1);
	
	
	
	
//	vec4 texture_colour = texture(TEXTURE, UV);
//	float brightness = (texture_colour.r + texture_colour.g + texture_colour.b) / 3.0;
//	COLOR = texture_colour;
//	float dissolveDif = abs(brightness - dissolve_state);
//	COLOR.rgb += vec3(1,1,0) + step(dissolveDif, 0.05);
//	COLOR.a = step(dissolve_state, brightness);
}
