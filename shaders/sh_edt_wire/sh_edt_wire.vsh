//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec4 in_Colour2;                   // (r,g,b,a)

varying float v_depth;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
	
	v_depth = gl_Position.z / gl_Position.w - .000001;
}
