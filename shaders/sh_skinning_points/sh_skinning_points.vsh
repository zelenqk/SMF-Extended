//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                  // (x,y,z)

uniform float u_Scale;

void main()
{
	float o = in_Colour.a * 255.;
	vec3 offset = 2. * vec3(mod(o, 2.), mod(floor(o * .5), 2.), mod(floor(o * .25), 2.)) - 1.;
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position + offset * u_Scale, 1.0);
}