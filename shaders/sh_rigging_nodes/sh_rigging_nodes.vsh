//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)

varying vec4 v_vColour;

const int maxBones = 64;
uniform vec4 boneDQ[2*maxBones];
uniform int animate;
uniform float u_selectedBone;
uniform float u_scale;
uniform vec4 u_color;
uniform vec4 u_selcolor;

void main()
{
	vec3 newPosition = in_Position;
	int boneInd = int(in_Colour.a * 255.);
	
	if (animate == 1)
	{
		//Blend bones
		vec4 blendReal = boneDQ[boneInd + boneInd];
		vec4 blendDual = boneDQ[boneInd + boneInd + 1];

		//Transform vertex
		/*Rotation*/	newPosition += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, newPosition) + blendReal.w * newPosition);
		/*Translation*/	newPosition += 2.0 * (blendReal.w * blendDual.xyz - blendDual.w * blendReal.xyz + cross(blendReal.xyz, blendDual.xyz));
	}
	
	v_vColour = u_color;
	vec3 offset = u_scale * (in_Colour.rgb * 2. - 1.);
	if (boneInd == int(u_selectedBone))
	{
		offset *= 1.2;
		v_vColour = u_selcolor;
	}
	vec4 objectSpacePos = vec4(newPosition + offset, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
}
