//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)     unused in this shader.
attribute vec2 in_TextureCoord;              // (u,v)
attribute vec4 in_Colour;                    // (r,g,b,a)

varying vec2 v_vTexcoord;

void main()
{
    vec4 objectSpacePos = vec4(in_Position, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
    
    v_vTexcoord = in_TextureCoord;
}
