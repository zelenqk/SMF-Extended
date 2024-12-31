//
// Simple passthrough vertex shader
//
attribute vec4 in_Colour;                    // (r,g,b,a)

varying vec4 v_colour;

uniform vec4 u_colour;
uniform float u_radius;
uniform float u_thickness;

void main()
{
	v_colour = u_colour;
	vec2 angles = in_Colour.xy * 2. * 3.14159;
	
	vec4 object_space_pos = vec4(0., 0., 0., 1.);
	vec2 dir = vec2(cos(angles.x), sin(angles.x));
	vec2 normal = vec2(cos(angles.y), sin(angles.y));
	float thickness = u_thickness;
	
	object_space_pos.z += thickness * normal.y;
	object_space_pos.xy += (u_radius + thickness * normal.x) * vec2(cos(angles.x), sin(angles.x));
	
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
