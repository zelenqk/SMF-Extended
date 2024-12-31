/*////////////////////////////////////////////////////////////////////////
	A simple shader that alters UVs a bit.
*/////////////////////////////////////////////////////////////////////////
varying vec2 v_vTexcoord;

void main()
{
	vec2 texCoord = v_vTexcoord;
	if (texCoord.y >= .99){texCoord.y = 1.98 - v_vTexcoord.y;}
    gl_FragColor = texture2D(gm_BaseTexture, texCoord);
}
