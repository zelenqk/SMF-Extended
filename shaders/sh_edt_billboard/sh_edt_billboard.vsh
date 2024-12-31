//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying float v_Depth;

void main()
{
    vec4 object_space_pos = vec4(in_Position, 1.0);
	mat4 modelView = gm_Matrices[MATRIX_VIEW] * gm_Matrices[MATRIX_WORLD];
	float scale = length(modelView[0].xyz);
	modelView[0][0] = scale;
	modelView[0][1] = 0.;
	modelView[0][2] = 0.;
	
	modelView[1][0] = 0.;
	modelView[1][1] = scale;
	modelView[1][2] = 0.;
	
	modelView[2][0] = 0.;
	modelView[2][1] = 0.;
	modelView[2][2] = scale;
	
	mat4 wvp = gm_Matrices[MATRIX_PROJECTION] * modelView;
    gl_Position = wvp * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
	v_Depth = gl_Position.z / gl_Position.w * 0.98;
}
