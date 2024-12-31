//
// Simple passthrough fragment shader
//

varying vec4 v_vert1;
varying vec4 v_vert2;
varying vec4 v_vert3;
varying vec3 v_vertIndex;

void main()
{
	float m = max(v_vertIndex.r, max(v_vertIndex.g, v_vertIndex.b));
	
	if (m == v_vertIndex.r)
	{
		gl_FragColor = v_vert1;
	}
	else if (m == v_vertIndex.g)
	{
		gl_FragColor = v_vert2;
	}
	else
	{
		gl_FragColor = v_vert3;
	}
}
