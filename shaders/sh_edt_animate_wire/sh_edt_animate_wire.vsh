//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec4 in_Colour2;                    // (r,g,b,a)

varying float v_depth;

///////////////////////////////
/////Animation/////////////////
const int maxBones = 128;
uniform vec4 u_boneDQ[2*maxBones];
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
	vec4 r0 = u_boneDQ[bone[0]];
	vec4 d0 = u_boneDQ[bone[0]+1];
	vec4 r1 = u_boneDQ[bone[1]];
	vec4 d1 = u_boneDQ[bone[1]+1];
	vec4 r2 = u_boneDQ[bone[2]];
	vec4 d2 = u_boneDQ[bone[2]+1];
	vec4 r3 = u_boneDQ[bone[3]];
	vec4 d3 = u_boneDQ[bone[3]+1];
	float w0 = weight[0];
	float w1 = weight[1] * sign(dot(r0, r1));
	float w2 = weight[2] * sign(dot(r0, r2));
	float w3 = weight[3] * sign(dot(r0, r3));
	blendReal  =  r0 * w0 + r1 * w1 + r2 * w2 + r3 * w3;
	blendDual  =  d0 * w0 + d1 * w1 + d2 * w2 + d3 * w3;
	//Normalize resulting dual quaternion
	float blendNormReal = 1.0 / length(blendReal);
	blendReal *= blendNormReal;
	blendDual = (blendDual - blendReal * dot(blendReal, blendDual)) * blendNormReal;
	blendTranslation = 2. * (blendReal.w * blendDual.xyz - blendDual.w * blendReal.xyz + cross(blendReal.xyz, blendDual.xyz));
}
vec3 animate_vertex(vec3 v)
{
	v += blendTranslation + 2. * cross(blendReal.xyz, cross(blendReal.xyz, v) + blendReal.w * v);
	return v;
}
vec3 animate_normal(vec3 n)
{
	n += 2. * cross(blendReal.xyz, cross(blendReal.xyz, n) + blendReal.w * n);
	return normalize(n);
}
/////Animation/////////////////
///////////////////////////////

void main()
{
	anim_init(ivec4(in_Colour * 510.0), in_Colour2);
	vec3 worldPos = animate_vertex(in_Position);
	
	vec4 test = in_Colour + in_Colour2;
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(worldPos, 1.0);
	
	v_depth = gl_Position.z / gl_Position.w - .000001;
}
