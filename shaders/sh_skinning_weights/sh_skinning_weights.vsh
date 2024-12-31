//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)     unused in this shader.
attribute vec2 in_TextureCoord;              // (u,v)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec4 in_Colour2;                 // (bone1, bone2, bone3, bone4)
attribute vec4 in_Colour3;                 // (weight1, weight2, weight3, weight4)

varying vec2 v_vTexcoord;
varying float v_vWeight;

uniform int u_Bone;
	
void main()
{
	//Use all attributes, otherwise some may be forgotten
	float UNUSED = in_Colour.r + in_Normal.r;
	
	vec4 objectSpacePos = vec4(in_Position, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
    
    v_vWeight = -1.;
    v_vTexcoord = in_TextureCoord;
	vec4 weight = in_Colour3;
	ivec4 bone = ivec4(in_Colour2 * 255.0);
	if (bone[0] == u_Bone && weight[0] > 0.){
			v_vWeight = weight[0];}
	else if (bone[1] == u_Bone && weight[1] > 0.){
			v_vWeight = weight[1];}
	else if (bone[2] == u_Bone && weight[2] > 0.){
			v_vWeight = weight[2];}
	else if (bone[3] == u_Bone && weight[3] > 0.){
			v_vWeight = weight[3];}
}
