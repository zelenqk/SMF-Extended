//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying float v_vWeight;

const vec3 col1 = vec3(.666, .6, .6); //Unweighted vertices
const vec3 col2 = vec3(0., 1., 1.); //Weighted vertices

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
    gl_FragColor = texture2D(gm_BaseTexture, v_vTexcoord);
	gl_FragColor.rgb = gl_FragColor.rgb * .2 + hsv2rgb(mix(col1, col2, v_vWeight));
}
