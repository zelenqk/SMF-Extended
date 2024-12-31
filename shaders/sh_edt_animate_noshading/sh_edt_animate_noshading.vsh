//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)
attribute vec2 in_TextureCoord;              // (u,v)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec4 in_Colour2;                   // (r,g,b,a)
attribute vec4 in_Colour3;                   // (r,g,b,a)

varying vec2 v_vTexcoord;

///////////////////////////////
/////Animation/////////////////
const int maxBones = 128;
uniform vec4 u_boneDQ[2*maxBones];
uniform bool u_animate;
vec4 blendReal, blendDual;
vec3 blendTranslation;
void anim_init(ivec2 bone, vec2 weight)
{
	blendReal  =  u_boneDQ[bone[0]]   * weight[0] + u_boneDQ[bone[1]]   * weight[1];
	blendDual  =  u_boneDQ[bone[0]+1] * weight[0] + u_boneDQ[bone[1]+1] * weight[1];
	blendTranslation = 2. * (blendReal.w * blendDual.xyz - blendDual.w * blendReal.xyz + cross(blendReal.xyz, blendDual.xyz));
}
void anim_init(ivec4 bone, vec4 weight)
{
	blendReal  =  u_boneDQ[bone[0]]   * weight[0] + u_boneDQ[bone[1]]   * weight[1] + u_boneDQ[bone[2]]   * weight[2] + u_boneDQ[bone[3]]   * weight[3];
	blendDual  =  u_boneDQ[bone[0]+1] * weight[0] + u_boneDQ[bone[1]+1] * weight[1] + u_boneDQ[bone[2]+1] * weight[2] + u_boneDQ[bone[3]+1] * weight[3];
	//Normalize resulting dual quaternion
	float blendNormReal = 1.0 / length(blendReal);
	blendReal *= blendNormReal;
	blendDual = (blendDual - blendReal * dot(blendReal, blendDual)) * blendNormReal;
	blendTranslation = 2. * (blendReal.w * blendDual.xyz - blendDual.w * blendReal.xyz + cross(blendReal.xyz, blendDual.xyz));
}
vec3 anim_rotate(vec3 v)
{
	return v + 2. * cross(blendReal.xyz, cross(blendReal.xyz, v) + blendReal.w * v);
}
vec3 anim_transform(vec3 v)
{
	return anim_rotate(v) + blendTranslation;
}
/////Animation/////////////////
///////////////////////////////

void main()
{
	vec4 objectSpacePos;
	if (u_animate)
	{
		anim_init(ivec4(in_Colour2 * 510.0), in_Colour3);
		objectSpacePos = vec4(anim_transform(in_Position), 1.0);
	}
	else
	{
		objectSpacePos = vec4(in_Position, 1.0);
	}
	
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;

    v_vTexcoord = in_TextureCoord;
	
	vec4 test = in_Colour;
}
