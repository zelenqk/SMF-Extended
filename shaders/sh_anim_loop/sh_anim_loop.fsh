//
// Simple passthrough fragment shader
//
varying vec4 v_colour;

void main()
{
    gl_FragColor = v_colour;
}
