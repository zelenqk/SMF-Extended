//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec4 in_Colour2;                    // (r,g,b,a)

varying vec4 v_vColour;
varying float v_vDepth;

const int maxBones = 128;
uniform vec4 u_boneDQ[2*maxBones];
uniform int animate;
uniform float u_selectedBone;
uniform float u_scale;
uniform float u_addscale;
uniform vec4 u_color;
uniform vec4 u_selcolor;
uniform float u_depthfactor;

void main()
{
	vec3 newPosition = in_Position;
	int boneInd = int(in_Colour2.a * 255.);
	
    v_vColour = u_color;
	v_vColour.rgb *= in_Colour.rgb;
	float tip = min(floor(in_Colour2.b * 2.0), 1.0);
	vec3 offset = u_scale * (mod(in_Colour2.rgb * 4., 2.) - 1.) * mix(1.0, 0.2, tip);
	offset *= 1. + u_addscale / length(offset);
	if (boneInd == int(u_selectedBone))
	{
		offset *= 1.2;
		v_vColour = u_selcolor;
	}
	
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
	
	v_vColour.rgb *= mix(1.0, 0.4, tip);
	vec4 objectSpacePos = vec4(newPosition + offset, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
	
	v_vDepth = gl_Position.z / gl_Position.w * u_depthfactor;
}
