/// @description sprite_resize(sprite_index, w, h)
/// @param sprite_index
/// @param w
/// @param h
function sprite_resize(argument0, argument1, argument2) {
	//Turn off 3D
	gpu_set_zwriteenable(false);
	gpu_set_ztestenable(false);
	gpu_set_cullmode(cull_noculling);

	var spr = argument0;
	var w = argument1;
	var h = argument2;
	var s = surface_create(w, h);
	surface_set_target(s);
	draw_clear_alpha(c_white, 0);
	draw_sprite_stretched(spr, 0, 0, 0, w, h);
	surface_reset_target();

	var ret = sprite_create_from_surface(s, 0, 0, w, h, 0, 0, 0, 0);
	surface_free(s);
	return ret;


}
