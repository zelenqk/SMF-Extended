/*////////////////////////////////////////////////////////////////////////
	A simple shader that attempts to remove repetitive patterns when
	drawing a repeating texture on the ground. Randomly rotates and
	translates UVs, and sutures tiles together using simplex noise.
*/////////////////////////////////////////////////////////////////////////
varying vec2 v_vTexcoord;

//Noise function
highp vec2 seed = vec2(1.0);
float noise()
{
	highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt = dot(seed, vec2(a,b));
    highp float sn = mod(dt, 3.14);
	highp float val = fract(sin(sn) * c);
	seed.x += val;
    return val;
}

// Simplex 2D noise
//
vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v)
{
  const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
  + i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
    dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

void main()
{
	seed = floor(v_vTexcoord + .2 * snoise(v_vTexcoord * 4.));
	
	float angle = noise() * 3.14159 * 2.; //Get a random number between 0 and 1
	mat2 mat = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
	
    gl_FragColor = texture2D(gm_BaseTexture, mat * v_vTexcoord + vec2(noise(), noise()));
}
