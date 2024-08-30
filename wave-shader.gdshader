shader_type canvas_item;

uniform sampler2D dissolve_form;
uniform float dissolve_state : hint_range(0.0, 1.0, 0.01);

void fragment() {
	vec4 textureColor = texture(TEXTURE, UV);
	vec2 trueUV = UV + vec2(0.5, 0.1) * TIME;
	float brightness = texture(dissolve_form, UV).r;
	COLOR = textureColor;
	COLOR.a *= step(dissolve_state, brightness);
}
