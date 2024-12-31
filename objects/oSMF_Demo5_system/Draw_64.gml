/// @description
var xx = 10;
var yy = 20;
var str = "SMF demo 5: More real-time sample editing:\n" +
	"FPS: " + string(fps) + " FPS_real: " + string(fps_real) + "\n" +
	"Another demo showing how samples can be manipulated in real time.\n" +
	"The chassis and each wheel are mapped to their own bones, which can be rotated at will.\n" +
	"FPS is locked to 60 in order to simplify the car physics.\n" +
	"Controls: Mouse, WASD\n" +
	"Press 1 through 6 to switch rooms";;

draw_set_colour(c_black);
draw_set_alpha(0.3);
draw_rectangle(xx - 5, yy - 5, xx + string_width(str) + 5, yy + string_height(str) + 5, false);
draw_set_colour(c_white);
draw_set_alpha(1);
draw_text(10, 20, str);