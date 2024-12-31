/// @description add_button(x, y, sprite, text, tooltip, handle)
/// @param x
/// @param y
/// @param sprite
/// @param text
/// @param tooltip
/// @param handle
function add_button(argument0, argument1, argument2, argument3, argument4, argument5) {
	with instance_create_depth(argument0, argument1, 0, oAnimEditButton)
	{
		sprite_index = argument2;
		text = argument3;
		tooltip = argument4;
		handle = argument5;
		return id;
	}


}
