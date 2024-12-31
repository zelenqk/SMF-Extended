/// @description
var xx = 10;
var yy = 20;
var str = "SMF demo 2: Interpolating between animations:\n" +
	"FPS: " + string(fps) + " FPS_real: " + string(fps_real) + "\n" +
	"This shows how a basic animated model can be drawn, and how to interpolate smoothly between animations\n" +
	"Press E to enable sample interpolation.\n" +
	"Interpolation: " + (global.enableInterpolation ? "Enabled" : "Disabled") + "\n" + 
	"Controls: Mouse, WASD, Shift, Space\n" +
	"Press 1 through 6 to switch rooms";;

draw_set_colour(c_black);
draw_set_alpha(0.3);
draw_rectangle(xx - 5, yy - 5, xx + string_width(str) + 5, yy + string_height(str) + 5, false);
draw_set_colour(c_white);
draw_set_alpha(1);
draw_text(10, 20, str);