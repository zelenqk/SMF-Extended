//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)     unused in this shader.
attribute vec2 in_TextureCoord;              // (u,v)
attribute vec4 in_Colour;                    // (r,g,b,a)
//attribute vec4 in_Colour2;                    // (r,g,b,a)
//attribute vec4 in_Colour3;                    // (r,g,b,a)

varying vec2 v_vTexcoord;
varying vec3 v_eyeVec;
varying vec3 v_vNormal;
varying float v_vRim;

void main()
{
    vec4 objectSpacePos = vec4(in_Position, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
    
    v_vTexcoord = in_TextureCoord;
	
	vec3 camPos = - (gm_Matrices[MATRIX_VIEW][3] * gm_Matrices[MATRIX_VIEW]).xyz;
    vec3 vertPos = (gm_Matrices[MATRIX_WORLD] * objectSpacePos).xyz;
	v_eyeVec = vertPos - camPos;
	v_vNormal = in_Normal;
	v_vRim = normalize((gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(v_vNormal, 0.)).xyz).z;
}