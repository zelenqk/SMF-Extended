//
// Simple passthrough fragment shader
//
varying vec4 v_vColour;
varying float v_vDepth;

void main()
{
    gl_FragColor = v_vColour;
	
	#extension GL_EXT_frag_depth : enable
	#ifdef GL_EXT_frag_depth
		gl_FragDepthEXT = v_vDepth;
	#endif
}
