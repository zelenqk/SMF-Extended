//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec4 in_Colour2;                    // (r,g,b,a)

varying float v_vIndex;

uniform float u_scale;

const int maxBones = 64;
uniform vec4 u_boneDQ[2*maxBones];
uniform int animate;

void main()
{
	vec4 test = in_Colour;
	v_vIndex = float(in_Colour2.a);
	vec3 newPosition = in_Position;
	int boneInd = int(in_Colour2.a * 255.);
	
	float tip = min(floor(in_Colour2.b * 2.0), 1.0);
	vec3 offset = u_scale * (mod(in_Colour2.rgb * 4., 2.) - 1.) * mix(1.0, 0.2, tip);
	
	if (animate == 1)
	{
		//Blend bones
		vec4 blendReal = u_boneDQ[boneInd + boneInd];
		vec4 blendDual = u_boneDQ[boneInd + boneInd + 1];

		//Transform vertex
		/*Rotation*/	newPosition += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, newPosition) + blendReal.w * newPosition);
		/*Translation*/	newPosition += 2.0 * (blendReal.w * blendDual.xyz - blendDual.w * blendReal.xyz + cross(blendReal.xyz, blendDual.xyz));
		/*Rotation*/	offset += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, offset) + blendReal.w * offset);
	}
	
	vec4 objectSpacePos = vec4(newPosition + offset, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
}
