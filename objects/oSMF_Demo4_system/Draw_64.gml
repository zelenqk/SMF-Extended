/// @description
if (loading)
{
	draw_text(10, 20, global._SMFAsyncText);
	exit;
}

var xx = 10;
var yy = 20;
var str = "SMF demo 4: Attaching objects to a rig:\n" +
	"FPS: " + string(fps) + " FPS_real: " + string(fps_real) + "\n" +
	"The player character can pick up a weapon, and this weapon will be drawn in his right hand.\n" +
	"This is done by getting the orientation of the hand node, and transforming the weapon using matrix_set.\n" +
	"You can chain animations together, attacking after rolling will result in a faster attack, even though it uses the same animation.\n" +
	"Controls: Mouse, WASD, Shift, Space\n" +
	"Press 1 through 6 to switch rooms";

draw_set_colour(c_black);
draw_set_alpha(0.3);
draw_rectangle(xx - 5, yy - 5, xx + string_width(str) + 5, yy + string_height(str) + 5, false);
draw_set_colour(c_white);
draw_set_alpha(1);
draw_text(10, 20, str);