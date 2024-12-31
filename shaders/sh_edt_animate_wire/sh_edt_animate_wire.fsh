//
// Simple passthrough fragment shader
//
#extension GL_EXT_frag_depth : enable

uniform vec4 u_colour;
varying float v_depth;
void main()
{
    gl_FragColor = u_colour;
	
	#ifdef GL_EXT_frag_depth
		gl_FragDepthEXT = v_depth;
	#endif
}
