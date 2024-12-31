/// @description
var xx = 10;
var yy = 20;
var str = "SMF demo 6: Inverse kinematics:\n" +
	"FPS: " + string(fps) + " FPS_real: " + string(fps_real) + "\n" +
	"This demo shows how to use inverse kinematics to create a believable procedural animation\n" +
	"Each leg is placed using inverse kinematics each step\n" +
	"Controls: Mouse, WASD, Shift\n" +
	"Press 1 through 6 to switch rooms";

draw_set_colour(c_black);
draw_set_alpha(0.2);
draw_rectangle(xx - 5, yy - 5, xx + string_width(str) + 5, yy + string_height(str) + 5, false);
draw_set_colour(c_white);
draw_set_alpha(1);
draw_text(10, 20, str);