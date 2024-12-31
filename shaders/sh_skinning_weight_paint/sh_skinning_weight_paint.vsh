//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec4 in_Colour2;                    // (r,g,b,a)
attribute vec4 in_Colour3;                    // (r,g,b,a)

varying vec4 v_vert1;
varying vec4 v_vert2;
varying vec4 v_vert3;
varying vec3 v_vertIndex;

uniform float u_Near;
uniform float u_Far;

void main()
{
	vec4 objectSpacePos = vec4(in_Position, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
	float _depth = (gl_Position.z - u_Near) / (u_Far - u_Near);
	
	v_vert1 = vec4(in_Colour.rgb, _depth);
	v_vert2 = vec4(in_Colour2.rgb, _depth);
	v_vert3 = vec4(in_Colour3.rgb, _depth);
	v_vertIndex = vec3(in_Colour.a, in_Colour2.a, in_Colour3.a);
}