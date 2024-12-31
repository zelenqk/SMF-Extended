/// @description
var xx = 10;
var yy = 20;
var str = "SMF demo 3: Real-time sample editing:\n" +
	"FPS: " + string(fps) + " FPS_real: " + string(fps_real) + "\n" +
	"The player, and nearby NPCs, will turn their heads dynamically\n" +
	"This is done by rotating the torso and head bones directly in a sample.\n" +
	"Controls: Mouse, WASD, Shift, Space\n" +
	"Press 1 through 6 to switch rooms";

draw_set_colour(c_black);
draw_set_alpha(0.3);
draw_rectangle(xx - 5, yy - 5, xx + string_width(str) + 5, yy + string_height(str) + 5, false);
draw_set_colour(c_white);
draw_set_alpha(1);
draw_text(10, 20, str);