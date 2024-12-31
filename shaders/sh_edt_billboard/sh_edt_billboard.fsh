//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying float v_Depth;

void main()
{
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	if (gl_FragColor.a < .1){discard;}
	
	#extension GL_EXT_frag_depth : enable
	#ifdef GL_EXT_frag_depth
		gl_FragDepthEXT = v_Depth;
	#endif
}
