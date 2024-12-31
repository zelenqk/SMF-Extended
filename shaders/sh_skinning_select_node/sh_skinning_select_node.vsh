//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)

varying float v_vIndex;

uniform float u_scale;

void main()
{
	vec3 offset = u_scale * (in_Colour.rgb * 2. - 1.);
	vec4 objectSpacePos = vec4(in_Position + offset, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
    
	v_vIndex = float(in_Colour.a);
}
