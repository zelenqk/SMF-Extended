//
// Snidr's Skeletal Animation Default Fragment Shader
//
varying vec2 v_vTexcoord;
varying float v_Depth;

void main()
{
    gl_FragColor = texture2D(gm_BaseTexture, v_vTexcoord);
	
	#extension GL_EXT_frag_depth : enable
	#ifdef GL_EXT_frag_depth
		gl_FragDepthEXT = v_Depth;
	#endif
}
