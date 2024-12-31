/// @description sprite_flip(sprite_index, flip H, flip V)
/// @param sprite_index
/// @param flip H
/// @param flip V
function sprite_flip(argument0, argument1, argument2) {
	//Turn off 3D
	gpu_set_zwriteenable(false);
	gpu_set_ztestenable(false);
	gpu_set_cullmode(cull_noculling);

	var spr = argument0;
	var w = sprite_get_width(spr);
	var h = sprite_get_height(spr);
	var s = surface_create(w, h);
	surface_set_target(s);
	draw_clear_alpha(c_white, 0);
	var xx = 0, yy = 0;
	var xScale = 1;
	var yScale = 1;
	if argument1
	{
		xx = w;
		xScale = -1;
	}
	if argument2
	{
		yy = h;
		yScale = -1;
	}
	draw_sprite_ext(spr, 0, xx, yy, xScale, yScale, 0, c_white, 1);
	surface_reset_target();

	ret = sprite_create_from_surface(s, 0, 0, w, h, 0, 0, 0, 0);
	surface_free(s);
	return ret;


}
