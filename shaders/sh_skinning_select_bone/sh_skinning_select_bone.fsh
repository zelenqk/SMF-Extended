//
// Simple passthrough fragment shader
//
varying float v_vIndex;

void main()
{
    gl_FragColor = vec4(fract(v_vIndex), floor(v_vIndex) / 255., floor(v_vIndex) / (255. * 256.), 1.0);
}
